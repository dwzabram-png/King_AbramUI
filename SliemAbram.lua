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
			footer = { text = "AbramSliem v2" },
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

-- ==================== DARK RED UI (v2 - Enhanced) ====================
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

-- Shadow behind main window
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.Size = UDim2.new(0, 420, 0, 540)
shadow.Image = "rbxassetid://6014054546"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.Parent = screenGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 380, 0, 500)
main.Position = UDim2.new(0.5, -190, 0.5, -250)
main.BackgroundColor3 = Color3.fromRGB(18, 4, 7)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(160, 30, 45)
stroke.Thickness = 1.5
stroke.Transparency = 0.3
stroke.Parent = main

-- Subtle top glow accent
local topGlow = Instance.new("Frame")
topGlow.Size = UDim2.new(1, 0, 0, 3)
topGlow.Position = UDim2.new(0, 0, 0, 0)
topGlow.BorderSizePixel = 0
topGlow.BackgroundColor3 = Color3.fromRGB(220, 40, 55)
topGlow.Parent = main
local topGlowGradient = Instance.new("UIGradient")
topGlowGradient.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.3),
	NumberSequenceKeypoint.new(0.5, 0),
	NumberSequenceKeypoint.new(1, 0.3)
})
topGlowGradient.Parent = topGlow

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.Position = UDim2.new(0, 0, 0, 3)
titleBar.BackgroundColor3 = Color3.fromRGB(28, 8, 12)
titleBar.BorderSizePixel = 0
titleBar.Parent = main
local titleBarGradient = Instance.new("UIGradient")
titleBarGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 10, 16)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 6, 10))
})
titleBarGradient.Rotation = 90
titleBarGradient.Parent = titleBar

local titleIcon = Instance.new("TextLabel")
titleIcon.Size = UDim2.new(0, 28, 0, 28)
titleIcon.Position = UDim2.new(0, 10, 0.5, -14)
titleIcon.BackgroundColor3 = Color3.fromRGB(180, 30, 45)
titleIcon.Text = "A"
titleIcon.Font = Enum.Font.GothamBlack
titleIcon.TextSize = 16
titleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
titleIcon.Parent = titleBar
local titleIconCorner = Instance.new("UICorner")
titleIconCorner.CornerRadius = UDim.new(0, 6)
titleIconCorner.Parent = titleIcon

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -150, 1, 0)
title.Position = UDim2.new(0, 46, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "AbramSliem"
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 230, 230)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local version = Instance.new("TextLabel")
version.Size = UDim2.new(0, 30, 0, 14)
version.Position = UDim2.new(0, 46 + 90, 0.5, -7)
version.BackgroundColor3 = Color3.fromRGB(180, 30, 45)
version.BackgroundTransparency = 0.5
version.Text = "v2"
version.Font = Enum.Font.GothamBold
version.TextSize = 9
version.TextColor3 = Color3.fromRGB(255, 200, 200)
version.Parent = titleBar
local versionCorner = Instance.new("UICorner")
versionCorner.CornerRadius = UDim.new(0, 4)
versionCorner.Parent = version

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 15, 20)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(255, 180, 180)
closeBtn.AutoButtonColor = false
closeBtn.Parent = titleBar
local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 6)
closeBtnCorner.Parent = closeBtn
closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(180, 30, 40),
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(60, 15, 20),
		TextColor3 = Color3.fromRGB(255, 180, 180)
	}):Play()
end)
closeBtn.MouseButton1Click:Connect(function()
	TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 380, 0, 0),
		BackgroundTransparency = 1
	}):Play()
	TweenService:Create(shadow, TweenInfo.new(0.25), { ImageTransparency = 1 }):Play()
	task.delay(0.28, function()
		screenGui:Destroy()
	end)
end)

local hint = Instance.new("TextLabel")
hint.Size = UDim2.new(0, 70, 0, 18)
hint.Position = UDim2.new(1, -108, 0.5, -9)
hint.BackgroundColor3 = Color3.fromRGB(50, 12, 18)
hint.BackgroundTransparency = 0.4
hint.Font = Enum.Font.Gotham
hint.Text = "Alt toggle"
hint.TextSize = 10
hint.TextColor3 = Color3.fromRGB(255, 160, 160)
hint.TextXAlignment = Enum.TextXAlignment.Center
hint.Parent = titleBar
local hintCorner = Instance.new("UICorner")
hintCorner.CornerRadius = UDim.new(0, 4)
hintCorner.Parent = hint

-- Separator line under title bar
local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, -20, 0, 1)
separator.Position = UDim2.new(0, 10, 0, 45)
separator.BackgroundColor3 = Color3.fromRGB(120, 25, 35)
separator.BackgroundTransparency = 0.6
separator.BorderSizePixel = 0
separator.Parent = main

local tabsBar = Instance.new("Frame")
tabsBar.Size = UDim2.new(1, -16, 0, 34)
tabsBar.Position = UDim2.new(0, 8, 0, 50)
tabsBar.BackgroundTransparency = 1
tabsBar.Parent = main

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.Padding = UDim.new(0, 4)
tabsLayout.Parent = tabsBar

local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, -16, 1, -120)
pagesContainer.Position = UDim2.new(0, 8, 0, 88)
pagesContainer.BackgroundColor3 = Color3.fromRGB(14, 3, 5)
pagesContainer.BackgroundTransparency = 0.5
pagesContainer.BorderSizePixel = 0
pagesContainer.Parent = main
local pagesCorner = Instance.new("UICorner")
pagesCorner.CornerRadius = UDim.new(0, 8)
pagesCorner.Parent = pagesContainer

-- Status bar at the bottom
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 24)
statusBar.Position = UDim2.new(0, 0, 1, -24)
statusBar.BackgroundColor3 = Color3.fromRGB(22, 6, 10)
statusBar.BorderSizePixel = 0
statusBar.Parent = main
local statusBarCorner = Instance.new("UICorner")
statusBarCorner.CornerRadius = UDim.new(0, 0)
statusBarCorner.Parent = statusBar

local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 10, 0.5, -4)
statusDot.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
statusDot.BorderSizePixel = 0
statusDot.Parent = statusBar
local statusDotCorner = Instance.new("UICorner")
statusDotCorner.CornerRadius = UDim.new(1, 0)
statusDotCorner.Parent = statusDot

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -30, 1, 0)
statusText.Position = UDim2.new(0, 24, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Font = Enum.Font.Gotham
statusText.Text = "Ready | " .. localPlayer.Name
statusText.TextSize = 10
statusText.TextColor3 = Color3.fromRGB(180, 130, 140)
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBar

local pages = {}
local tabButtons = {}
local tabIndicators = {}

local function createPage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name
	page.Size = UDim2.new(1, -8, 1, -8)
	page.Position = UDim2.new(0, 4, 0, 4)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = Color3.fromRGB(180, 30, 45)
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.Visible = false
	page.Parent = pagesContainer
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 5)
	layout.Parent = page
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 4)
	padding.PaddingBottom = UDim.new(0, 4)
	padding.Parent = page
	pages[name] = page
	return page
end

local pageMain = createPage("Main")
local pageUpgrades = createPage("Upgrades")
local pageWebhook = createPage("Webhook")

local function createSectionHeader(parentPage, text)
	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, -6, 0, 20)
	header.BackgroundTransparency = 1
	header.Font = Enum.Font.GothamBold
	header.TextSize = 11
	header.TextColor3 = Color3.fromRGB(200, 60, 75)
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.Text = string.upper(text)
	header.Parent = parentPage
end

local function createToggle(parentPage, label, key)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -6, 0, 34)
	btn.BackgroundColor3 = Color3.fromRGB(35, 10, 14)
	btn.TextColor3 = Color3.fromRGB(255, 232, 232)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 13
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Parent = parentPage
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn

	-- Toggle indicator dot
	local indicator = Instance.new("Frame")
	indicator.Size = UDim2.new(0, 10, 0, 10)
	indicator.Position = UDim2.new(0, 10, 0.5, -5)
	indicator.BackgroundColor3 = Color3.fromRGB(80, 25, 30)
	indicator.BorderSizePixel = 0
	indicator.Parent = btn
	local indicatorCorner = Instance.new("UICorner")
	indicatorCorner.CornerRadius = UDim.new(1, 0)
	indicatorCorner.Parent = indicator

	local labelText = Instance.new("TextLabel")
	labelText.Size = UDim2.new(1, -60, 1, 0)
	labelText.Position = UDim2.new(0, 28, 0, 0)
	labelText.BackgroundTransparency = 1
	labelText.Font = Enum.Font.GothamSemibold
	labelText.TextSize = 13
	labelText.TextColor3 = Color3.fromRGB(255, 220, 220)
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	labelText.Text = label
	labelText.Parent = btn

	local stateLabel = Instance.new("TextLabel")
	stateLabel.Size = UDim2.new(0, 36, 0, 18)
	stateLabel.Position = UDim2.new(1, -46, 0.5, -9)
	stateLabel.BackgroundColor3 = Color3.fromRGB(60, 15, 20)
	stateLabel.BackgroundTransparency = 0.3
	stateLabel.Font = Enum.Font.GothamBold
	stateLabel.TextSize = 10
	stateLabel.TextColor3 = Color3.fromRGB(200, 140, 140)
	stateLabel.Text = "OFF"
	stateLabel.Parent = btn
	local stateLabelCorner = Instance.new("UICorner")
	stateLabelCorner.CornerRadius = UDim.new(0, 4)
	stateLabelCorner.Parent = stateLabel

	-- Hover effect
	btn.MouseEnter:Connect(function()
		if not State[key] then
			TweenService:Create(btn, TweenInfo.new(0.12), {
				BackgroundColor3 = Color3.fromRGB(48, 14, 20)
			}):Play()
		end
	end)
	btn.MouseLeave:Connect(function()
		if not State[key] then
			TweenService:Create(btn, TweenInfo.new(0.12), {
				BackgroundColor3 = Color3.fromRGB(35, 10, 14)
			}):Play()
		end
	end)

	btn.MouseButton1Click:Connect(function()
		local newValue = not State[key]
		toggleFeature(key, newValue)
		stateLabel.Text = State[key] and "ON" or "OFF"
		local targetBg = State[key] and Color3.fromRGB(100, 22, 32) or Color3.fromRGB(35, 10, 14)
		local targetIndicator = State[key] and Color3.fromRGB(0, 220, 90) or Color3.fromRGB(80, 25, 30)
		local targetStateColor = State[key] and Color3.fromRGB(0, 220, 90) or Color3.fromRGB(200, 140, 140)
		local targetStateBg = State[key] and Color3.fromRGB(0, 60, 25) or Color3.fromRGB(60, 15, 20)
		TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = targetBg
		}):Play()
		TweenService:Create(indicator, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = targetIndicator
		}):Play()
		TweenService:Create(stateLabel, TweenInfo.new(0.18), {
			TextColor3 = targetStateColor,
			BackgroundColor3 = targetStateBg
		}):Play()
	end)
end

local function createInput(parentPage, label, defaultValue, onChanged)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, -6, 0, 34)
	container.BackgroundColor3 = Color3.fromRGB(30, 8, 12)
	container.BackgroundTransparency = 0.5
	container.BorderSizePixel = 0
	container.Parent = parentPage
	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 6)
	containerCorner.Parent = container

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0.52, 0, 1, 0)
	textLabel.Position = UDim2.new(0, 10, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(220, 180, 185)
	textLabel.Font = Enum.Font.Gotham
	textLabel.TextSize = 12
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Text = label
	textLabel.Parent = container

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.42, -8, 0, 24)
	box.Position = UDim2.new(0.56, 4, 0.5, -12)
	box.BackgroundColor3 = Color3.fromRGB(25, 6, 10)
	box.TextColor3 = Color3.fromRGB(255, 230, 230)
	box.PlaceholderText = tostring(defaultValue)
	box.PlaceholderColor3 = Color3.fromRGB(120, 70, 80)
	box.Text = tostring(defaultValue)
	box.Font = Enum.Font.GothamSemibold
	box.TextSize = 12
	box.ClearTextOnFocus = false
	box.Parent = container
	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 5)
	boxCorner.Parent = box
	local boxStroke = Instance.new("UIStroke")
	boxStroke.Color = Color3.fromRGB(80, 20, 30)
	boxStroke.Thickness = 1
	boxStroke.Transparency = 0.5
	boxStroke.Parent = box

	box.Focused:Connect(function()
		TweenService:Create(boxStroke, TweenInfo.new(0.15), {
			Color = Color3.fromRGB(180, 40, 55),
			Transparency = 0
		}):Play()
	end)
	box.FocusLost:Connect(function()
		onChanged(box.Text)
		TweenService:Create(boxStroke, TweenInfo.new(0.15), {
			Color = Color3.fromRGB(80, 20, 30),
			Transparency = 0.5
		}):Play()
		TweenService:Create(box, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = Color3.fromRGB(45, 12, 18)
		}):Play()
		task.delay(0.15, function()
			if box and box.Parent then
				TweenService:Create(box, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Color3.fromRGB(25, 6, 10)
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
			TweenService:Create(page, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				ScrollBarImageTransparency = 0.3
			}):Play()
		end
	end
	for tabName, btn in pairs(tabButtons) do
		local isActive = tabName == name
		local targetBg = isActive and Color3.fromRGB(140, 28, 40) or Color3.fromRGB(40, 10, 15)
		local targetText = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 140, 150)
		TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
		if tabIndicators[tabName] then
			TweenService:Create(tabIndicators[tabName], TweenInfo.new(0.2), {
				BackgroundTransparency = isActive and 0 or 1
			}):Play()
		end
	end
end

local function createTabButton(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 114, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(40, 10, 15)
	btn.TextColor3 = Color3.fromRGB(180, 140, 150)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.Text = name
	btn.AutoButtonColor = false
	btn.Parent = tabsBar
	local tabCorner = Instance.new("UICorner")
	tabCorner.CornerRadius = UDim.new(0, 6)
	tabCorner.Parent = btn

	-- Active indicator line at bottom
	local tabLine = Instance.new("Frame")
	tabLine.Size = UDim2.new(0.6, 0, 0, 2)
	tabLine.Position = UDim2.new(0.2, 0, 1, -4)
	tabLine.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
	tabLine.BackgroundTransparency = 1
	tabLine.BorderSizePixel = 0
	tabLine.Parent = btn
	local tabLineCorner = Instance.new("UICorner")
	tabLineCorner.CornerRadius = UDim.new(0, 1)
	tabLineCorner.Parent = tabLine
	tabIndicators[name] = tabLine

	-- Hover
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.12), {
			BackgroundColor3 = Color3.fromRGB(60, 16, 22)
		}):Play()
	end)
	btn.MouseLeave:Connect(function()
		local isActive = pages[name] and pages[name].Visible
		local restColor = isActive and Color3.fromRGB(140, 28, 40) or Color3.fromRGB(40, 10, 15)
		TweenService:Create(btn, TweenInfo.new(0.12), {
			BackgroundColor3 = restColor
		}):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		setActiveTab(name)
	end)
	tabButtons[name] = btn
end

createTabButton("Main")
createTabButton("Upgrades")
createTabButton("Webhook")

createSectionHeader(pageMain, "Automation")
createToggle(pageMain, "Auto Roll", "AutoRoll")
createToggle(pageMain, "Auto Index", "AutoIndex")
createToggle(pageMain, "Auto Farm", "AutoFarm")
createToggle(pageMain, "Auto Potions", "AutoPotions")
createSectionHeader(pageMain, "Teleport")
createToggle(pageMain, "Auto Best Zone", "AutoTeleportBestZone")
createInput(pageMain, "Best Zone Interval", Config.AutoBestZoneInterval, function(v)
	Config.AutoBestZoneInterval = math.max(1, tonumber(v) or 30)
end)

createSectionHeader(pageUpgrades, "Upgrades & Economy")
createToggle(pageUpgrades, "Auto Upgrade", "AutoUpgrade")
createToggle(pageUpgrades, "Auto Buy Zone", "AutoBuyZone")
createToggle(pageUpgrades, "Auto Rebirth", "AutoRebirth")
createToggle(pageUpgrades, "Auto Equip Best", "AutoEquipBest")
createInput(pageUpgrades, "Upgrade Interval", Config.AutoUpgradeInterval, function(v)
	Config.AutoUpgradeInterval = math.max(1, tonumber(v) or 30)
end)

createSectionHeader(pageWebhook, "Discord Integration")
createToggle(pageWebhook, "Webhook", "Webhook")
createInput(pageWebhook, "Webhook URL", Config.WebhookUrl, function(v)
	Config.WebhookUrl = tostring(v or "")
end)
createInput(pageWebhook, "Webhook Interval", Config.WebhookInterval, function(v)
	Config.WebhookInterval = math.max(1, tonumber(v) or 30)
end)
setActiveTab("Main")

-- Dragging
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
		local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		TweenService:Create(main, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = newPos
		}):Play()
		shadow.Position = UDim2.new(0, newPos.X.Offset + 190, 0, newPos.Y.Offset + 250)
	end
end)

-- Toggle minimize with Alt
local expandedSize = UDim2.new(0, 380, 0, 500)
local minimizedSize = UDim2.new(0, 380, 0, 45)
local minimized = false
local uiTweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local fadeTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard and (input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt) then
		minimized = not minimized
		local goalSize = minimized and minimizedSize or expandedSize
		local goalShadow = minimized and UDim2.new(0, 420, 0, 85) or UDim2.new(0, 420, 0, 540)
		TweenService:Create(main, uiTweenInfo, { Size = goalSize }):Play()
		TweenService:Create(main, fadeTweenInfo, { BackgroundTransparency = minimized and 0.08 or 0 }):Play()
		TweenService:Create(shadow, fadeTweenInfo, { Size = goalShadow }):Play()
		TweenService:Create(shadow, fadeTweenInfo, { ImageTransparency = minimized and 0.8 or 0.5 }):Play()
	end
end)

-- Opening animation
main.Size = UDim2.new(0, 380, 0, 0)
main.BackgroundTransparency = 0.5
shadow.Size = UDim2.new(0, 420, 0, 40)
shadow.ImageTransparency = 1
TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = expandedSize,
	BackgroundTransparency = 0
}):Play()
TweenService:Create(shadow, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 420, 0, 540),
	ImageTransparency = 0.5
}):Play()

Notify("AbramSliem v2", "Loaded successfully.")
