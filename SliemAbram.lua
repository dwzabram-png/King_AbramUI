repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local client, clientHRP

-- Dynamic character reference (fixes respawn issues)
local function updateCharacter()
	client = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	clientHRP = client:WaitForChild("HumanoidRootPart", 5)
end
updateCharacter()
localPlayer.CharacterAdded:Connect(updateCharacter)

-- Anti-AFK
localPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

local loopThreads = {}
local State = {
	AutoRoll = false,
	AutoIndex = false,
	AutoFarm = false,
	AutoPotions = false,
	AutoTeleportBestZone = false,
	AutoUpgrade = false,
	AutoBuyZone = false,
	AutoRebirth = false,
	AutoEquipBest = false,
	Webhook = false
}
local Config = {
	AutoBestZoneInterval = 30,
	AutoUpgradeInterval = 30,
	WebhookUrl = "",
	WebhookInterval = 30
}

-- Centralized remote caller (removes duplication)
local RemotesFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("leifstout_networker@0.3.1"):WaitForChild("networker"):WaitForChild("_remotes")

local function callRemote(service, method, ...)
	local remote = RemotesFolder:FindFirstChild(service)
	if not remote then return false, "Remote folder not found" end
	local func = remote:FindFirstChild("RemoteFunction")
	if not func then return false, "RemoteFunction not found" end
	local ok, result = pcall(function(...)
		return func:InvokeServer(...)
	end, method, ...)
	if not ok then
		return false, result
	end
	return true, result
end

-- Notifications
local function Notify(title, content)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = tostring(title),
			Text = tostring(content),
			Duration = 4
		})
	end)
end

local function stopLoop(name)
	local thread = loopThreads[name]
	if thread then
		pcall(task.cancel, thread)
		loopThreads[name] = nil
	end
end

local function startLoop(name, loopFn)
	stopLoop(name)
	loopThreads[name] = task.spawn(function()
		local ok, err = pcall(loopFn)
		if not ok then
			Notify("Loop Error", name .. ": " .. tostring(err))
		end
		loopThreads[name] = nil
	end)
end

-- Safe teleport
local function TP(x, y, z)
	if not clientHRP then return end
	clientHRP.CFrame = CFrame.new(x, y, z)
end

-- Discord webhook with validation
local function isValidWebhook(url)
	return type(url) == "string" and (
		url:match("^https://discord%.com/api/webhooks/%d+/.+") ~= nil
		or url:match("^https://discordapp%.com/api/webhooks/%d+/.+") ~= nil
	)
end

local function SendDiscordWebhook(url, data)
	if not isValidWebhook(url) then
		Notify("Webhook Error", "Invalid Discord webhook URL")
		return false
	end
	local requestFn = request or http_request or (syn and syn.request)
	if not requestFn then
		Notify("Webhook Error", "HTTP request API is not available in this executor")
		return false
	end
	local body = {
		content = data.content,
		embeds = {{
			title = data.title,
			description = data.description,
			color = 5814783,
			footer = { text = "Plink Utils" },
			timestamp = DateTime.now():ToIsoDate(),
		}},
		attachments = {}
	}
	local success, err = pcall(function()
		requestFn({
			Url = url,
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = HttpService:JSONEncode(body)
		})
	end)
	if not success then
		Notify("Webhook Error", tostring(err))
		return false
	end
	return true
end

-- Safe UI traversal helper
local function safeFind(root, ...)
	local current = root
	for _, name in ipairs({...}) do
		if not current then return nil end
		current = current:FindFirstChild(name)
	end
	return current
end

-- Upgrades
local function getUpgradeTiles()
	local frame = safeFind(localPlayer, "PlayerGui", "Root", "UpgradeScreen", "UpgradeContent", "Frame")
	return frame and frame:GetChildren() or {}
end

local function Upgrade()
	local tiles = getUpgradeTiles()
	if not tiles then return end
	for _, tile in ipairs(tiles) do
		if tile:IsA("GuiButton") and tile.Name ~= "UIAspectRatioConstraint" and tile.Name ~= "UpgradeHoverInfo" then
			local upgrade = tile.Name:match("^(%S+)Tile")
			if upgrade then
				callRemote("UpgradeService", "requestUnlock", upgrade)
				task.wait(0.05)
			end
		end
	end
end

-- Roll with safe fallback
local function Roll()
	callRemote("RollService", "requestRoll")
end

local function getRollCooldown()
	local label = safeFind(localPlayer, "PlayerGui", "Root", "BottomBarStats", "StatsList", "RollSpeedStat", "Content", "Value", "TextLabel")
	if label then
		local num = tonumber(label.Text:match("[%d%.]+"))
		return num or 0.5
	end
	return 0.5 -- safe fallback
end

-- Potions
local PotionTypes = { "luck", "ultraLuck", "currency", "rollSpeed" }
local function ConsumePotions()
	for _, potion in ipairs(PotionTypes) do
		callRemote("BoostService", "requestUseBoost", potion)
		task.wait(0.05)
	end
end

-- Index rewards
local IndexRewards = { "basic", "big", "huge", "shiny", "inverted" }
local function ClaimIndex()
	for _, reward in ipairs(IndexRewards) do
		callRemote("IndexService", "requestClaimReward", reward)
		task.wait(0.1)
	end
end

-- Teleport
local function Teleport(worldNum)
	callRemote("ZonesService", "requestTeleportZone", worldNum)
end

local function TeleportBestZone()
	local zonesFolder = workspace:FindFirstChild("Zones")
	if not zonesFolder then return end
	local best = 0
	for _, zone in ipairs(zonesFolder:GetChildren()) do
		local gate = safeFind(zone, "Gate", "ClientGateBlocker_" .. zone.Name)
		if gate and not gate.CanCollide then
			local num = tonumber(zone.Name)
			if num and num > best then best = num end
		end
	end
	Teleport(best + 1)
end

-- ==================== LOGIC ====================
local autoFarmConnection

local function toggleFeature(name, value)
	State[name] = value
	Notify(name, value and "Enabled" or "Disabled")

	if name == "AutoRoll" then
		if value then
			startLoop("AutoRoll", function()
				while State.AutoRoll do
					local cd = getRollCooldown()
					task.wait(cd)
					if State.AutoRoll then Roll() end
				end
			end)
		else
			stopLoop("AutoRoll")
		end
	elseif name == "AutoIndex" then
		if value then
			startLoop("AutoIndex", function()
				while State.AutoIndex do
					task.wait(30)
					if State.AutoIndex then ClaimIndex() end
				end
			end)
		else
			stopLoop("AutoIndex")
		end
	elseif name == "AutoFarm" then
		if autoFarmConnection then autoFarmConnection:Disconnect() end
		if value then
			autoFarmConnection = RunService.Heartbeat:Connect(function()
				if not State.AutoFarm or not clientHRP then return end
				local lootFolder = workspace:FindFirstChild("Loot")
				if not lootFolder then return end
				for _, drop in ipairs(lootFolder:GetChildren()) do
					if not State.AutoFarm then break end
					for _, child in ipairs(drop:GetChildren()) do
						if child:IsA("BasePart") and child.Name ~= "LootHighlight" then
							child.CFrame = clientHRP.CFrame
						end
					end
				end
			end)
		end
	elseif name == "AutoPotions" then
		if value then
			startLoop("AutoPotions", function()
				while State.AutoPotions do
					ConsumePotions()
					task.wait(3)
				end
			end)
		else
			stopLoop("AutoPotions")
		end
	elseif name == "AutoTeleportBestZone" then
		if value then
			startLoop("AutoTeleportBestZone", function()
				while State.AutoTeleportBestZone do
					TeleportBestZone()
					task.wait(Config.AutoBestZoneInterval)
				end
			end)
		else
			stopLoop("AutoTeleportBestZone")
		end
	elseif name == "AutoUpgrade" then
		if value then
			startLoop("AutoUpgrade", function()
				while State.AutoUpgrade do
					Upgrade()
					task.wait(Config.AutoUpgradeInterval)
				end
			end)
		else
			stopLoop("AutoUpgrade")
		end
	elseif name == "AutoBuyZone" then
		if value then
			startLoop("AutoBuyZone", function()
				while State.AutoBuyZone do
					callRemote("ZonesService", "requestPurchaseZone")
					task.wait(5)
				end
			end)
		else
			stopLoop("AutoBuyZone")
		end
	elseif name == "AutoRebirth" then
		if value then
			startLoop("AutoRebirth", function()
				while State.AutoRebirth do
					callRemote("RebirthService", "requestRebirth")
					task.wait(5)
				end
			end)
		else
			stopLoop("AutoRebirth")
		end
	elseif name == "AutoEquipBest" then
		if value then
			startLoop("AutoEquipBest", function()
				while State.AutoEquipBest do
					callRemote("InventoryService", "requestEquipBest")
					task.wait(10)
				end
			end)
		else
			stopLoop("AutoEquipBest")
		end
	elseif name == "Webhook" then
		if value then
			startLoop("Webhook", function()
				while State.Webhook do
					if isValidWebhook(Config.WebhookUrl) and clientHRP then
						local titleGui = safeFind(client, "Head", "TitleGui") or safeFind(clientHRP, "TitleGui")
						local numRolls = titleGui and titleGui:FindFirstChild("NumRolls") and titleGui.NumRolls.Text or "N/A"
						SendDiscordWebhook(Config.WebhookUrl, {
							title = localPlayer.Name,
							description = numRolls
						})
					end
					task.wait(Config.WebhookInterval)
				end
			end)
		else
			stopLoop("Webhook")
		end
	end
end

-- ==================== DARK RED UI ====================
pcall(function()
	local oldGui = CoreGui:FindFirstChild("AbramSliemGui")
	if oldGui then oldGui:Destroy() end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AbramSliemGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parentGui = gethui and gethui() or CoreGui
screenGui.Parent = parentGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 380, 0, 500)
main.Position = UDim2.new(0.5, -190, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(20, 5, 8)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(150, 25, 40)
stroke.Thickness = 1.5
stroke.Parent = main

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 10, 16)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "AbramSliem"
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 220, 220)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local hint = Instance.new("TextLabel")
hint.Size = UDim2.new(0, 108, 1, 0)
hint.Position = UDim2.new(1, -108, 0, 0)
hint.BackgroundTransparency = 1
hint.Font = Enum.Font.Gotham
hint.Text = "Alt = Toggle UI"
hint.TextSize = 12
hint.TextColor3 = Color3.fromRGB(255, 170, 170)
hint.TextXAlignment = Enum.TextXAlignment.Center
hint.Parent = titleBar

local tabsBar = Instance.new("Frame")
tabsBar.Size = UDim2.new(1, -12, 0, 32)
tabsBar.Position = UDim2.new(0, 6, 0, 44)
tabsBar.BackgroundTransparency = 1
tabsBar.Parent = main

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.Padding = UDim.new(0, 6)
tabsLayout.Parent = tabsBar

local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, -12, 1, -84)
pagesContainer.Position = UDim2.new(0, 6, 0, 78)
pagesContainer.BackgroundTransparency = 1
pagesContainer.Parent = main

local pages = {}
local tabButtons = {}

local function createPage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 4
	page.CanvasSize = UDim2.new(0, 0, 0, 1100)
	page.Visible = false
	page.Parent = pagesContainer
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.Parent = page
	pages[name] = page
	return page
end

local pageMain = createPage("Main")
local pageUpgrades = createPage("Upgrades")
local pageWebhook = createPage("Webhook")

local function createToggle(parentPage, label, key)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -6, 0, 28)
	btn.BackgroundColor3 = Color3.fromRGB(50, 12, 18)
	btn.TextColor3 = Color3.fromRGB(255, 232, 232)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 13
	btn.Text = label .. ": OFF"
	btn.AutoButtonColor = true
	btn.Parent = parentPage
	btn.MouseButton1Click:Connect(function()
		local newValue = not State[key]
		toggleFeature(key, newValue)
		btn.Text = label .. ": " .. (State[key] and "ON" or "OFF")
		local targetColor = State[key] and Color3.fromRGB(130, 28, 42) or Color3.fromRGB(50, 12, 18)
		TweenService:Create(btn, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = targetColor
		}):Play()
	end)
end

local function createInput(parentPage, label, defaultValue, onChanged)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -6, 0, 28)
	container.BackgroundTransparency = 1
	container.Parent = parentPage
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0.52, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(255, 210, 210)
	textLabel.Font = Enum.Font.Gotham
	textLabel.TextSize = 12
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Text = label
	textLabel.Parent = container
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.48, -4, 1, 0)
	box.Position = UDim2.new(0.52, 4, 0, 0)
	box.BackgroundColor3 = Color3.fromRGB(40, 9, 14)
	box.TextColor3 = Color3.fromRGB(255, 240, 240)
	box.PlaceholderText = tostring(defaultValue)
	box.Text = tostring(defaultValue)
	box.Font = Enum.Font.Gotham
	box.TextSize = 12
	box.ClearTextOnFocus = false
	box.Parent = container
	box.FocusLost:Connect(function()
		onChanged(box.Text)
		TweenService:Create(box, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = Color3.fromRGB(60, 14, 20)
		}):Play()
		task.delay(0.12, function()
			if box and box.Parent then
				TweenService:Create(box, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Color3.fromRGB(40, 9, 14)
				}):Play()
			end
		end)
	end)
end

local function setActiveTab(name)
	for pageName, page in pairs(pages) do
		page.Visible = (pageName == name)
		if page.Visible then
			page.ScrollBarImageTransparency = 1
			TweenService:Create(page, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				ScrollBarImageTransparency = 0.2
			}):Play()
		end
	end
	for tabName, btn in pairs(tabButtons) do
		local targetColor = tabName == name and Color3.fromRGB(120, 24, 36) or Color3.fromRGB(60, 12, 19)
		TweenService:Create(btn, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = targetColor
		}):Play()
	end
end

local function createTabButton(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 110, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(60, 12, 19)
	btn.TextColor3 = Color3.fromRGB(255, 220, 220)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.Text = name
	btn.AutoButtonColor = true
	btn.Parent = tabsBar
	btn.MouseButton1Click:Connect(function()
		setActiveTab(name)
	end)
	tabButtons[name] = btn
end

createTabButton("Main")
createTabButton("Upgrades")
createTabButton("Webhook")

createToggle(pageMain, "Auto Roll", "AutoRoll")
createToggle(pageMain, "Auto Index", "AutoIndex")
createToggle(pageMain, "Auto Farm", "AutoFarm")
createToggle(pageMain, "Auto Potions", "AutoPotions")
createToggle(pageMain, "Auto Best Zone", "AutoTeleportBestZone")
createInput(pageMain, "Best Zone Interval", Config.AutoBestZoneInterval, function(v)
	Config.AutoBestZoneInterval = math.max(1, tonumber(v) or 30)
end)

createToggle(pageUpgrades, "Auto Upgrade", "AutoUpgrade")
createToggle(pageUpgrades, "Auto Buy Zone", "AutoBuyZone")
createToggle(pageUpgrades, "Auto Rebirth", "AutoRebirth")
createToggle(pageUpgrades, "Auto Equip Best", "AutoEquipBest")
createInput(pageUpgrades, "Upgrade Interval", Config.AutoUpgradeInterval, function(v)
	Config.AutoUpgradeInterval = math.max(1, tonumber(v) or 30)
end)

createToggle(pageWebhook, "Webhook", "Webhook")
createInput(pageWebhook, "Webhook URL", Config.WebhookUrl, function(v)
	Config.WebhookUrl = tostring(v or "")
end)
createInput(pageWebhook, "Webhook Interval", Config.WebhookInterval, function(v)
	Config.WebhookInterval = math.max(1, tonumber(v) or 30)
end)
setActiveTab("Main")

local dragging = false
local dragStart, startPos
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local expandedSize = UDim2.new(0, 380, 0, 500)
local minimizedSize = UDim2.new(0, 380, 0, 38)
local minimized = false
local uiTweenInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local fadeTweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard and (input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt) then
		minimized = not minimized
		local goal = minimized and minimizedSize or expandedSize
		TweenService:Create(main, uiTweenInfo, { Size = goal }):Play()
		TweenService:Create(main, fadeTweenInfo, { BackgroundTransparency = minimized and 0.12 or 0 }):Play()
	end
end)

main.Size = minimizedSize
main.BackgroundTransparency = 0.12
TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = expandedSize,
	BackgroundTransparency = 0
}):Play()

Notify("AbramSliem", "Loaded successfully.")
