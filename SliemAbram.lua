wait(1)

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

local activeFeatures = {}
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
	AutoKill = false,
	Webhook = false
}
local Config = {
	AutoBestZoneInterval = 15,
	AutoUpgradeInterval = 30,
	WebhookUrl = "",
	WebhookInterval = 30
}

-- Централизованный поиск ремутов
local RemotesFolder = nil
task.spawn(function()
	while not RemotesFolder do
		RemotesFolder = ReplicatedStorage:FindFirstChild("_remotes", true)
		wait(1)
	end
end)

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

local function callRemote(service, method, ...)
	if not RemotesFolder then
		Notify("Remote Error", "RemotesFolder not found")
		return false
	end
	local remote = RemotesFolder:FindFirstChild(service)
	if not remote then
		Notify("Remote Error", "Service " .. tostring(service) .. " not found")
		return false
	end
	local func = remote:FindFirstChild("RemoteFunction")
	if not func then
		Notify("Remote Error", "RemoteFunction not found in " .. service)
		return false
	end
	local ok, result = pcall(function()
		return func:InvokeServer(method, ...)
	end)
	if not ok then
		Notify("Remote Error", tostring(result))
		return false
	end
	return true, result
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
		Notify("Webhook Error", "HTTP request API is not available")
		return false
	end
	local body = {
		content = data.content,
		embeds = {{
			title = data.title,
			description = data.description,
			color = 3447003,
			footer = { text = "Plink Utils" },
			timestamp = DateTime.now():ToIsoDate(),
		}},
		attachments = {}
	}
	local success, err = pcall(function()
		requestFn({
			Url = url,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json" },
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
	return 0.5
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
	if best > 0 then Teleport(best) end
end

local function AutoKill()
	if not State.AutoKill or not clientHRP then return end
	local gameplay = nil
	for _, child in ipairs(workspace:GetChildren()) do
		if child.Name:match("^Gameplay") then
			gameplay = child
			break
		end
	end
	if not gameplay then return end
	local enemiesFolder = gameplay:FindFirstChild("Enemies")
	if not enemiesFolder then return end

	local enemies = enemiesFolder:GetChildren()
	if #enemies == 0 then return end

	for _, enemy in ipairs(enemies) do
		if not State.AutoKill then break end
		local root = enemy:FindFirstChild("RootPart") or enemy:FindFirstChild("HumanoidRootPart")
		local hum = enemy:FindFirstChild("Humanoid")
		if root and not root:IsA("BasePart") then
			root = root:FindFirstChild("Root") or root:FindFirstChild("HumanoidRootPart")
		end
		if root and root:IsA("BasePart") and hum and hum.Health > 0 then
			clientHRP.CFrame = root.CFrame
			task.wait(0.1)
			break
		end
	end
end

-- ==================== FEATURE CONFIGURATION ====================
local FEATURES = {
	AutoRoll = {
		kind = "task_loop",
		getInterval = function() return getRollCooldown() end,
		action = function() Roll() end
	},
	AutoIndex = {
		kind = "task_loop",
		getInterval = function() return 30 end,
		action = function() ClaimIndex() end
	},
	AutoFarm = {
		kind = "rbx_connection",
		getSignal = function() return RunService.Heartbeat end,
		callback = function()
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
		end
	},
	AutoPotions = {
		kind = "task_loop",
		getInterval = function() return 3 end,
		action = function() ConsumePotions() end
	},
	AutoTeleportBestZone = {
		kind = "task_loop",
		getInterval = function() return Config.AutoBestZoneInterval end,
		action = function() TeleportBestZone() end
	},
	AutoUpgrade = {
		kind = "task_loop",
		getInterval = function() return Config.AutoUpgradeInterval end,
		action = function() Upgrade() end
	},
	AutoBuyZone = {
		kind = "task_loop",
		getInterval = function() return 5 end,
		action = function() callRemote("ZonesService", "requestPurchaseZone") end
	},
	AutoRebirth = {
		kind = "task_loop",
		getInterval = function() return 5 end,
		action = function() callRemote("RebirthService", "requestRebirth") end
	},
	AutoEquipBest = {
		kind = "task_loop",
		getInterval = function() return 10 end,
		action = function() callRemote("InventoryService", "requestEquipBest") end
	},
	AutoKill = {
		kind = "task_loop",
		getInterval = function() return 0.5 end,
		action = function() AutoKill() end
	},
	Webhook = {
		kind = "task_loop",
		getInterval = function() return Config.WebhookInterval end,
		action = function()
			if isValidWebhook(Config.WebhookUrl) and clientHRP then
				local titleGui = safeFind(client, "Head", "TitleGui") or safeFind(clientHRP, "TitleGui")
				local numRolls = titleGui and titleGui:FindFirstChild("NumRolls") and titleGui.NumRolls.Text or "N/A"
				SendDiscordWebhook(Config.WebhookUrl, {
					title = localPlayer.Name,
					description = numRolls
				})
			end
		end
	}
}

-- ==================== FEATURE MANAGEMENT ====================
local function stopFeature(name)
	local handle = activeFeatures[name]
	if not handle then return end
	if typeof(handle) == "thread" then
		pcall(task.cancel, handle)
	elseif typeof(handle) == "RBXScriptConnection" then
		pcall(handle.Disconnect, handle)
	end
	activeFeatures[name] = nil
end

local function startFeature(name)
	stopFeature(name)
	local cfg = FEATURES[name]
	if not cfg then return end

	if cfg.kind == "task_loop" then
		local thread = task.spawn(function()
			while State[name] do
				local ok, err = pcall(cfg.action)
				if not ok then
					Notify("Loop Error", name .. ": " .. tostring(err))
					break
				end
				if not State[name] then break end
				wait(cfg.getInterval())
			end
			activeFeatures[name] = nil
		end)
		activeFeatures[name] = thread
	elseif cfg.kind == "rbx_connection" then
		local signal = cfg.getSignal()
		if not signal then return end
		activeFeatures[name] = signal:Connect(cfg.callback)
	end
end

local function toggleFeature(name, value)
	State[name] = value
	Notify(name, value and "Enabled" or "Disabled")
	if value then
		startFeature(name)
	else
		stopFeature(name)
	end
	if _G.RefreshFooterUI then _G.RefreshFooterUI() end
end

-- ==================== UI v5 ====================
pcall(function()
	local oldGui = CoreGui:FindFirstChild("AbramSliemGui")
	if oldGui then oldGui:Destroy() end
end)

local C = {
	BG        = Color3.fromRGB(9, 9, 11),
	Surface   = Color3.fromRGB(24, 24, 27),
	SurfaceHi = Color3.fromRGB(39, 39, 42),
	Border    = Color3.fromRGB(39, 39, 42),
	BorderHi  = Color3.fromRGB(63, 63, 70),
	Accent    = Color3.fromRGB(59, 130, 246),
	AccentDim = Color3.fromRGB(37, 99, 235),
	Text      = Color3.fromRGB(250, 250, 250),
	TextDim   = Color3.fromRGB(161, 161, 170),
	TextMuted = Color3.fromRGB(113, 113, 122),
	Green     = Color3.fromRGB(16, 185, 129),
	Track     = Color3.fromRGB(63, 63, 70),
	Knob      = Color3.fromRGB(255, 255, 255),
}

local TW_FAST = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TW_POP  = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function tw(obj, props, info)
	pcall(function()
		TweenService:Create(obj, info or TW_FAST, props):Play()
	end)
end

local function addCorner(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 8)
	c.Parent = p
	return c
end

local function addStroke(p, col, t)
	local s = Instance.new("UIStroke")
	s.Color = col or C.Border
	s.Thickness = t or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = p
	return s
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AbramSliemGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = gethui and gethui() or CoreGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 480)
main.Position = UDim2.new(0.5, -180, 0.5, -240)
main.BackgroundColor3 = C.BG
main.BorderSizePixel = 0
main.Active = true
main.Parent = screenGui
addCorner(main, 12)
addStroke(main, C.Border, 1)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = C.Surface
titleBar.BorderSizePixel = 0
titleBar.Parent = main
addCorner(titleBar, 12)

local titlePatch = Instance.new("Frame")
titlePatch.Size = UDim2.new(1, 0, 0, 12)
titlePatch.Position = UDim2.new(0, 0, 1, -12)
titlePatch.BackgroundColor3 = C.Surface
titlePatch.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -160, 1, 0)
title.Position = UDim2.new(0, 28, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "AbramSliem"
title.TextSize = 14
title.TextColor3 = C.Text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local tabsBar = Instance.new("Frame")
tabsBar.Size = UDim2.new(1, -24, 0, 32)
tabsBar.Position = UDim2.new(0, 12, 0, 50)
tabsBar.BackgroundTransparency = 1
tabsBar.Parent = main

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.Padding = UDim.new(0, 6)
tabsLayout.Parent = tabsBar

local pages, tabButtons = {}, {}

local function setActiveTab(name)
	for pageName, page in pairs(pages) do page.Visible = (pageName == name) end
	for tabName, btn in pairs(tabButtons) do
		local active = tabName == name
		tw(btn, {
			BackgroundColor3 = active and C.SurfaceHi or C.Surface,
			TextColor3       = active and C.Text      or C.TextMuted,
		})
	end
end

for i, tabName in ipairs({"Main", "Upgrades", "Webhook"}) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1/3, -4, 1, 0)
	btn.BackgroundColor3 = C.Surface
	btn.Font = Enum.Font.GothamBold
	btn.Text = tabName
	btn.TextSize = 12
	btn.TextColor3 = C.TextMuted
	btn.Parent = tabsBar
	addCorner(btn, 6)
	btn.MouseButton1Click:Connect(function() setActiveTab(tabName) end)
	tabButtons[tabName] = btn
end

local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, -24, 1, -135)
pagesContainer.Position = UDim2.new(0, 12, 0, 95)
pagesContainer.BackgroundTransparency = 1
pagesContainer.Parent = main

local function createPage(name)
	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 2
	page.Visible = false
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.Parent = pagesContainer
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.Parent = page
	pages[name] = page
	return page
end

local pageMain = createPage("Main")
local pageUpgrades = createPage("Upgrades")
local pageWebhook = createPage("Webhook")

local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, 32)
footer.Position = UDim2.new(0, 0, 1, -32)
footer.BackgroundColor3 = C.Surface
footer.Parent = main
addCorner(footer, 12)

local footerStatus = Instance.new("TextLabel")
footerStatus.Size = UDim2.new(0.5, -24, 1, 0)
footerStatus.Position = UDim2.new(0, 24, 0, 0)
footerStatus.BackgroundTransparency = 1
footerStatus.Font = Enum.Font.GothamMedium
footerStatus.Text = "0 active"
footerStatus.TextColor3 = C.TextDim
footerStatus.TextSize = 11
footerStatus.TextXAlignment = Enum.TextXAlignment.Left
footerStatus.Parent = footer

local pill = Instance.new("TextButton")
pill.Size = UDim2.new(0, 48, 0, 48)
pill.Position = UDim2.new(0, 20, 0.5, -24)
pill.BackgroundColor3 = C.Surface
pill.Text = "AS"
pill.Font = Enum.Font.GothamBold
pill.TextColor3 = C.Text
pill.Visible = false
pill.Parent = screenGui
addCorner(pill, 14)
addStroke(pill, C.BorderHi, 1)

_G.RefreshFooterUI = function()
	local count = 0
	for _, v in pairs(State) do if v then count = count + 1 end end
	footerStatus.Text = count .. " active"
end

local function createToggle(parentPage, label, key)
	local row = Instance.new("TextButton")
	row.Size = UDim2.new(1, 0, 0, 40)
	row.BackgroundColor3 = C.Surface
	row.Text = ""
	row.Parent = parentPage
	addCorner(row, 8)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -64, 1, 0)
	lbl.Position = UDim2.new(0, 14, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamMedium
	lbl.Text = label
	lbl.TextColor3 = C.Text
	lbl.TextSize = 13
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row
	local track = Instance.new("Frame")
	track.Size = UDim2.new(0, 36, 0, 20)
	track.Position = UDim2.new(1, -50, 0.5, -10)
	track.BackgroundColor3 = C.Track
	track.Parent = row
	addCorner(track, 10)
	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new(0, 3, 0, 3)
	knob.BackgroundColor3 = C.Knob
	knob.Parent = track
	addCorner(knob, 7)
	row.MouseButton1Click:Connect(function()
		toggleFeature(key, not State[key])
		local on = State[key]
		tw(track, {BackgroundColor3 = on and C.Green or C.Track})
		tw(knob, {Position = on and UDim2.new(0, 19, 0, 3) or UDim2.new(0, 3, 0, 3)})
	end)
end

local function createInput(parentPage, label, defaultValue, onChanged)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 40)
	row.BackgroundColor3 = C.Surface
	row.Parent = parentPage
	addCorner(row, 8)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.3, 0, 0.7, 0)
	box.Position = UDim2.new(0.65, 0, 0.15, 0)
	box.BackgroundColor3 = C.BG
	box.Text = tostring(defaultValue)
	box.TextColor3 = C.Text
	box.Parent = row
	addCorner(box, 4)
	box.FocusLost:Connect(function() onChanged(box.Text) end)
end

createToggle(pageMain, "Auto Roll", "AutoRoll")
createToggle(pageMain, "Auto Index", "AutoIndex")
createToggle(pageMain, "Auto Farm", "AutoFarm")
createToggle(pageMain, "Auto Potions", "AutoPotions")
createToggle(pageMain, "Auto Kill", "AutoKill")
createToggle(pageMain, "Auto Best Zone", "AutoTeleportBestZone")
createToggle(pageUpgrades, "Auto Upgrade", "AutoUpgrade")
createToggle(pageUpgrades, "Auto Buy Zone", "AutoBuyZone")
createToggle(pageUpgrades, "Auto Rebirth", "AutoRebirth")
createToggle(pageUpgrades, "Auto Equip Best", "AutoEquipBest")
createToggle(pageWebhook, "Webhook", "Webhook")
createInput(pageWebhook, "Webhook URL", "", function(v) Config.WebhookUrl = v end)

setActiveTab("Main")

-- Dragging & Alt logic
local dragStart, startPos, dragging
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true dragStart = input.Position startPos = main.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local d = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

local function toggleMenu()
	main.Visible = not main.Visible
	pill.Visible = not main.Visible
end
pill.MouseButton1Click:Connect(toggleMenu)
UserInputService.InputBegan:Connect(function(input, gp)
	if not gp and (input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt) then toggleMenu() end
end)

Notify("AbramSliem", "Fixed & Loaded. Press ALT to hide.")
