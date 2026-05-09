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

-- Centralized remote caller
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
			color = 3447003, -- Blue color
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
	if best > 0 then Teleport(best) end
end

local function AutoKill()
	if not State.AutoKill or not clientHRP then return end
	
	-- Динамический поиск папки Gameplay (т.к. номер меняется, например Gameplay303)
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
		
		-- Ищем RootPart (как в твоём примере) или стандартный HumanoidRootPart
		local root = enemy:FindFirstChild("RootPart") or enemy:FindFirstChild("HumanoidRootPart")
		local hum = enemy:FindFirstChild("Humanoid")
		
		-- Если RootPart оказался папкой/моделью, ищем в ней деталь Root
		if root and not root:IsA("BasePart") then
			root = root:FindFirstChild("Root") or root:FindFirstChild("HumanoidRootPart")
		end
		
		if root and root:IsA("BasePart") and hum and hum.Health > 0 then
			clientHRP.CFrame = root.CFrame
			task.wait(0.1)
			break -- Переходим к следующему циклу поиска, чтобы обновить список целей
		end
	end
end
	
	local enemiesFolder = gameplay:FindFirstChild("Enemies")
	if not enemiesFolder then 
		Notify("AutoKill Error", "Папка Enemies не найдена в Gameplay73")
		return 
	end

	local enemies = enemiesFolder:GetChildren()
	if #enemies == 0 then
		-- Чтобы не спамить уведомлениями, можно добавить таймер, но для теста оставим так
		return 
	end

	for _, enemy in ipairs(enemies) do
		if not State.AutoKill then break end
		local hrp = enemy:FindFirstChild("HumanoidRootPart")
		local hum = enemy:FindFirstChild("Humanoid")
		
		if hrp and hum and hum.Health > 0 then
			clientHRP.CFrame = hrp.CFrame
			task.wait(0.1) -- Короткая задержка для регистрации урона
			break -- Убиваем одного и выходим, чтобы loop из FEATURES начал поиск заново
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
		local thread = spawn(function()
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

-- ==================== LOGIC ====================
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

-- ==================== UI v5 — PERFECT DARK MODE & WIDGET & ALL FEATURES ====================
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
main.ClipsDescendants = false
main.Active = true -- Защита от кликов сквозь UI на мобилках
main.Parent = screenGui
addCorner(main, 12)
addStroke(main, C.Border, 1)

-- ===== TITLE BAR =====
local TITLE_H = 40
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, TITLE_H)
titleBar.BackgroundColor3 = C.Surface
titleBar.BorderSizePixel = 0
titleBar.Parent = main
addCorner(titleBar, 12)

local titlePatch = Instance.new("Frame")
titlePatch.Size = UDim2.new(1, 0, 0, 12)
titlePatch.Position = UDim2.new(0, 0, 1, -12)
titlePatch.BackgroundColor3 = C.Surface
titlePatch.BorderSizePixel = 0
titlePatch.Parent = titleBar

local titleSep = Instance.new("Frame")
titleSep.Size = UDim2.new(1, 0, 0, 1)
titleSep.Position = UDim2.new(0, 0, 1, -1)
titleSep.BackgroundColor3 = C.Border
titleSep.BorderSizePixel = 0
titleSep.Parent = titleBar

local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 8, 0, 8)
dot.Position = UDim2.new(0, 14, 0.5, -4)
dot.BackgroundColor3 = C.TextMuted
dot.BorderSizePixel = 0
dot.Parent = titleBar
addCorner(dot, 4)

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

local kbdChip = Instance.new("Frame")
kbdChip.AnchorPoint = Vector2.new(1, 0.5)
kbdChip.Position = UDim2.new(1, -12, 0.5, 0)
kbdChip.Size = UDim2.new(0, 78, 0, 22)
kbdChip.BackgroundColor3 = C.BG
kbdChip.BorderSizePixel = 0
kbdChip.Parent = titleBar
addCorner(kbdChip, 4)
addStroke(kbdChip, C.Border, 1)

local kbdKey = Instance.new("TextLabel")
kbdKey.Size = UDim2.new(0, 22, 0, 16)
kbdKey.Position = UDim2.new(0, 3, 0.5, -8)
kbdKey.BackgroundColor3 = C.SurfaceHi
kbdKey.Font = Enum.Font.GothamBold
kbdKey.Text = "Alt"
kbdKey.TextSize = 10
kbdKey.TextColor3 = C.Text
kbdKey.Parent = kbdChip
addCorner(kbdKey, 3)

local kbdLabel = Instance.new("TextLabel")
kbdLabel.Position = UDim2.new(0, 28, 0, 0)
kbdLabel.Size = UDim2.new(1, -28, 1, 0)
kbdLabel.BackgroundTransparency = 1
kbdLabel.Font = Enum.Font.GothamMedium
kbdLabel.Text = "hide menu"
kbdLabel.TextSize = 10
kbdLabel.TextColor3 = C.TextDim
kbdLabel.TextXAlignment = Enum.TextXAlignment.Left
kbdLabel.Parent = kbdChip

-- ===== TABS =====
local TABS_TOP = TITLE_H + 10
local TAB_H = 32
local TABS_PAD = 12
local tabNames = { "Main", "Upgrades", "Webhook" }

local tabsBar = Instance.new("Frame")
tabsBar.Size = UDim2.new(1, -TABS_PAD * 2, 0, TAB_H)
tabsBar.Position = UDim2.new(0, TABS_PAD, 0, TABS_TOP)
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

for i, tabName in ipairs(tabNames) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1/3, -4, 1, 0)
	btn.LayoutOrder = i
	btn.BackgroundColor3 = C.Surface
	btn.AutoButtonColor = false
	btn.Font = Enum.Font.GothamBold
	btn.Text = tabName
	btn.TextSize = 12
	btn.TextColor3 = C.TextMuted
	btn.Parent = tabsBar
	addCorner(btn, 6)
	btn.MouseButton1Click:Connect(function() setActiveTab(tabName) end)
	tabButtons[tabName] = btn
end

-- ===== PAGES CONTAINER =====
local CONTENT_TOP = TABS_TOP + TAB_H + 12
local FOOTER_H = 32
local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, -TABS_PAD * 2, 1, -(CONTENT_TOP + FOOTER_H + 10))
pagesContainer.Position = UDim2.new(0, TABS_PAD, 0, CONTENT_TOP)
pagesContainer.BackgroundTransparency = 1
pagesContainer.ClipsDescendants = true
pagesContainer.Parent = main

local function createPage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 2
	page.ScrollBarImageColor3 = C.BorderHi
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.Visible = false
	page.Parent = pagesContainer
	
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.Parent = page
	
	local p = Instance.new("UIPadding")
	p.PaddingRight = UDim.new(0, 6)
	p.PaddingBottom = UDim.new(0, 4)
	p.Parent = page
	pages[name] = page
	return page
end

local pageMain = createPage("Main")
local pageUpgrades = createPage("Upgrades")
local pageWebhook = createPage("Webhook")

-- ===== FOOTER =====
local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, FOOTER_H)
footer.Position = UDim2.new(0, 0, 1, -FOOTER_H)
footer.BackgroundColor3 = C.Surface
footer.BorderSizePixel = 0
footer.Parent = main
addCorner(footer, 12)

local footerPatch = Instance.new("Frame")
footerPatch.Size = UDim2.new(1, 0, 0, 12)
footerPatch.Position = UDim2.new(0, 0, 0, 0)
footerPatch.BackgroundColor3 = C.Surface
footerPatch.BorderSizePixel = 0
footerPatch.Parent = footer

local footerSep = Instance.new("Frame")
footerSep.Size = UDim2.new(1, 0, 0, 1)
footerSep.Position = UDim2.new(0, 0, 0, 0)
footerSep.BackgroundColor3 = C.Border
footerSep.BorderSizePixel = 0
footerSep.Parent = footer

local footerDot = Instance.new("Frame")
footerDot.Size = UDim2.new(0, 6, 0, 6)
footerDot.Position = UDim2.new(0, 14, 0.5, -3)
footerDot.BackgroundColor3 = C.TextMuted
footerDot.Parent = footer
addCorner(footerDot, 3)

local footerStatus = Instance.new("TextLabel")
footerStatus.Size = UDim2.new(0.5, -24, 1, 0)
footerStatus.Position = UDim2.new(0, 24, 0, 0)
footerStatus.BackgroundTransparency = 1
footerStatus.Font = Enum.Font.GothamMedium
footerStatus.Text = "0 active"
footerStatus.TextSize = 11
footerStatus.TextColor3 = C.TextDim
footerStatus.TextXAlignment = Enum.TextXAlignment.Left
footerStatus.Parent = footer

local footerUser = Instance.new("TextLabel")
footerUser.Size = UDim2.new(0.5, -14, 1, 0)
footerUser.Position = UDim2.new(0.5, 0, 0, 0)
footerUser.BackgroundTransparency = 1
footerUser.Font = Enum.Font.Gotham
footerUser.Text = localPlayer.Name
footerUser.TextSize = 11
footerUser.TextColor3 = C.TextMuted
footerUser.TextXAlignment = Enum.TextXAlignment.Right
footerUser.Parent = footer

-- ===== FLOATING PILL WIDGET =====
local pill = Instance.new("TextButton")
pill.Size = UDim2.new(0, 48, 0, 48)
pill.Position = UDim2.new(0, 20, 0.5, -24)
pill.BackgroundColor3 = C.Surface
pill.AutoButtonColor = false
pill.Text = ""
pill.Visible = false
pill.Active = true -- Защита от случайных кликов сквозь виджет
pill.Parent = screenGui
addCorner(pill, 14)
addStroke(pill, C.BorderHi, 1)

local pillIcon = Instance.new("TextLabel")
pillIcon.Size = UDim2.new(1, 0, 1, 0)
pillIcon.BackgroundTransparency = 1
pillIcon.Font = Enum.Font.GothamBold
pillIcon.Text = "AS"
pillIcon.TextSize = 16
pillIcon.TextColor3 = C.Text
pillIcon.Parent = pill

local pillStatusDot = Instance.new("Frame")
pillStatusDot.Size = UDim2.new(0, 10, 0, 10)
pillStatusDot.Position = UDim2.new(1, -12, 0, 2)
pillStatusDot.BackgroundColor3 = C.TextMuted
pillStatusDot.BorderSizePixel = 0
pillStatusDot.Parent = pill
addCorner(pillStatusDot, 5)

pill.MouseEnter:Connect(function() tw(pill, { BackgroundColor3 = C.SurfaceHi }) end)
pill.MouseLeave:Connect(function() tw(pill, { BackgroundColor3 = C.Surface }) end)

_G.RefreshFooterUI = function()
	local count = 0
	for _, v in pairs(State) do
		if v then count = count + 1 end
	end
	footerStatus.Text = count .. " active"
	local col = count > 0 and C.Green or C.TextMuted
	footerStatus.TextColor3 = count > 0 and C.Green or C.TextDim
	tw(footerDot, { BackgroundColor3 = col })
	tw(dot, { BackgroundColor3 = col })
	tw(pillStatusDot, { BackgroundColor3 = col })
end

-- ===== UI BUILDER UTILS =====
local function createSection(parentPage, label)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 0, 24)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamBold
	lbl.Text = string.upper(label)
	lbl.TextSize = 10
	lbl.TextColor3 = C.TextMuted
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.TextYAlignment = Enum.TextYAlignment.Bottom
	lbl.Parent = parentPage
	local pad = Instance.new("UIPadding", lbl)
	pad.PaddingBottom = UDim.new(0, 4)
	pad.PaddingLeft = UDim.new(0, 2)
end

-- ПОЛНОСТЬЮ ПЕРЕРАБОТАННАЯ И ИСПРАВЛЕННАЯ ФУНКЦИЯ ПОЛЗУНКА (БЕЗ БАГОВ)
local function createToggle(parentPage, label, key)
	local row = Instance.new("TextButton")
	row.Size = UDim2.new(1, 0, 0, 40)
	row.BackgroundColor3 = C.Surface
	row.AutoButtonColor = false
	row.Text = ""
	row.Parent = parentPage
	addCorner(row, 8)
	local rowStroke = addStroke(row, C.Border, 1)
	rowStroke.Transparency = 0.5

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -64, 1, 0)
	lbl.Position = UDim2.new(0, 14, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamMedium
	lbl.Text = label
	lbl.TextSize = 13
	lbl.TextColor3 = C.Text
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row

	local track = Instance.new("Frame")
	track.AnchorPoint = Vector2.new(1, 0.5)
	track.Position = UDim2.new(1, -14, 0.5, 0)
	track.Size = UDim2.new(0, 36, 0, 20)
	track.BackgroundColor3 = C.Track
	track.ClipsDescendants = false
	track.Parent = row
	addCorner(track, 10)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new(0, 3, 0, 3)
	knob.BackgroundColor3 = C.Knob
	knob.Parent = track
	addCorner(knob, 7)

	-- Прямое использование TweenService для надежности на мобильных экзекуторах
	local tInfoColor = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tInfoPos = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local function setVisual(on, animate)
		local targetBg = on and C.Green or C.Track
		local targetPos = on and UDim2.new(0, 19, 0, 3) or UDim2.new(0, 3, 0, 3)
		local targetCol = on and C.Text or C.TextDim

		if animate then
			pcall(function()
				TweenService:Create(track, tInfoColor, {BackgroundColor3 = targetBg}):Play()
				TweenService:Create(knob, tInfoPos, {Position = targetPos}):Play()
				TweenService:Create(lbl, tInfoColor, {TextColor3 = targetCol}):Play()
			end)
		else
			track.BackgroundColor3 = targetBg
			knob.Position = targetPos
			lbl.TextColor3 = targetCol
		end
	end

	row.MouseEnter:Connect(function() tw(rowStroke, { Transparency = 0 }) end)
	row.MouseLeave:Connect(function() tw(rowStroke, { Transparency = 0.5 }) end)
	
	row.MouseButton1Click:Connect(function()
		toggleFeature(key, not State[key])
		setVisual(State[key], true)
	end)
	
	-- Устанавливаем начальное состояние без проигрывания анимации
	setVisual(State[key], false)
end

local function createInput(parentPage, label, defaultValue, onChanged)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 40)
	row.BackgroundColor3 = C.Surface
	row.BorderSizePixel = 0
	row.Parent = parentPage
	addCorner(row, 8)
	local rowStroke = addStroke(row, C.Border, 1)
	rowStroke.Transparency = 0.5

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0.55, -16, 1, 0)
	lbl.Position = UDim2.new(0, 14, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = C.TextDim
	lbl.Font = Enum.Font.GothamMedium
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Text = label
	lbl.Parent = row

	local boxFrame = Instance.new("Frame")
	boxFrame.AnchorPoint = Vector2.new(1, 0.5)
	boxFrame.Position = UDim2.new(1, -14, 0.5, 0)
	boxFrame.Size = UDim2.new(0.35, 0, 0, 26) 
	boxFrame.BackgroundColor3 = C.BG 
	boxFrame.BorderSizePixel = 0
	boxFrame.Parent = row
	addCorner(boxFrame, 6)
	local bStroke = addStroke(boxFrame, C.Border, 1)

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, 0, 1, 0)
	box.Position = UDim2.new(0, 0, 0, 0)
	box.BackgroundTransparency = 1
	box.TextColor3 = C.Text
	box.PlaceholderColor3 = C.TextMuted
	box.PlaceholderText = tostring(defaultValue)
	box.Text = tostring(defaultValue)
	box.Font = Enum.Font.Gotham
	box.TextSize = 12
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.TextYAlignment = Enum.TextYAlignment.Center
	box.ClearTextOnFocus = false
	box.ClipsDescendants = true
	box.Parent = boxFrame
	
	local boxPad = Instance.new("UIPadding", box)
	boxPad.PaddingLeft = UDim.new(0, 8)
	boxPad.PaddingRight = UDim.new(0, 8)

	box.Focused:Connect(function()
		tw(bStroke,   { Color = C.Accent, Transparency = 0 })
		tw(rowStroke, { Transparency = 0 })
	end)
	box.FocusLost:Connect(function()
		onChanged(box.Text)
		tw(bStroke,   { Color = C.Border, Transparency = 0 })
		tw(rowStroke, { Transparency = 0.5 })
	end)
end

local function createActionButton(parentPage, label, onClick)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 36)
	b.BackgroundColor3 = C.Accent
	b.AutoButtonColor = false
	b.Font = Enum.Font.GothamBold
	b.Text = label
	b.TextSize = 12
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.Parent = parentPage
	addCorner(b, 8)

	b.MouseEnter:Connect(function() tw(b, { BackgroundColor3 = C.AccentDim }) end)
	b.MouseLeave:Connect(function() tw(b, { BackgroundColor3 = C.Accent }) end)
	b.MouseButton1Click:Connect(function()
		tw(b, { BackgroundColor3 = C.SurfaceHi })
		task.delay(0.12, function()
			if b.Parent then tw(b, { BackgroundColor3 = C.Accent }) end
		end)
		onClick()
	end)
end

-- ===== СОЗДАНИЕ ВСЕХ ЭЛЕМЕНТОВ =====

createSection(pageMain, "Automation")
createToggle(pageMain, "Auto Roll",      "AutoRoll")
createToggle(pageMain, "Auto Index",     "AutoIndex")
createToggle(pageMain, "Auto Farm",      "AutoFarm")
createToggle(pageMain, "Auto Potions",   "AutoPotions")
createToggle(pageMain, "Auto Kill",      "AutoKill")
createToggle(pageMain, "Auto Best Zone", "AutoTeleportBestZone")
createSection(pageMain, "Settings")
createInput(pageMain, "Zone interval (s)", Config.AutoBestZoneInterval, function(v)
	Config.AutoBestZoneInterval = math.max(1, tonumber(v) or 30)
end)

createSection(pageUpgrades, "Progression")
createToggle(pageUpgrades, "Auto Upgrade",    "AutoUpgrade")
createToggle(pageUpgrades, "Auto Buy Zone",   "AutoBuyZone")
createToggle(pageUpgrades, "Auto Rebirth",    "AutoRebirth")
createToggle(pageUpgrades, "Auto Equip Best", "AutoEquipBest")
createSection(pageUpgrades, "Settings")
createInput(pageUpgrades, "Upgrade interval (s)", Config.AutoUpgradeInterval, function(v)
	Config.AutoUpgradeInterval = math.max(1, tonumber(v) or 30)
end)

createSection(pageWebhook, "Discord Webhook")
createToggle(pageWebhook, "Webhook", "Webhook")
createInput(pageWebhook, "Webhook URL", Config.WebhookUrl, function(v)
	Config.WebhookUrl = tostring(v or "")
end)
createInput(pageWebhook, "Interval (s)", Config.WebhookInterval, function(v)
	Config.WebhookInterval = math.max(1, tonumber(v) or 30)
end)
createSection(pageWebhook, "Actions")
createActionButton(pageWebhook, "Send test message", function()
	if not isValidWebhook(Config.WebhookUrl) then
		Notify("Webhook", "Invalid Discord webhook URL")
		return
	end
	local ok = SendDiscordWebhook(Config.WebhookUrl, {
		title = "AbramSliem test",
		description = "Triggered by " .. localPlayer.Name,
	})
	Notify("Webhook", ok and "Test sent" or "Failed to send")
end)

setActiveTab("Main")
if _G.RefreshFooterUI then _G.RefreshFooterUI() end

-- ===== DRAG & ALT HIDE LOGIC =====

local draggingMain = false
local dragStartM, startPosM

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingMain = true
		dragStartM = input.Position
		startPosM = main.Position
	end
end)

local pillDrag = false
local pDragStart, pStartPos, pMoved
local DRAG_THRESHOLD = 15 -- Увеличенный порог для мобильных свайпов

pill.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		pillDrag = true
		pMoved = false
		pDragStart = input.Position
		pStartPos = pill.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		if draggingMain then
			local d = input.Position - dragStartM
			main.Position = UDim2.new(startPosM.X.Scale, startPosM.X.Offset + d.X, startPosM.Y.Scale, startPosM.Y.Offset + d.Y)
		elseif pillDrag then
			local d = input.Position - pDragStart
			if d.Magnitude > DRAG_THRESHOLD then pMoved = true end
			pill.Position = UDim2.new(pStartPos.X.Scale, pStartPos.X.Offset + d.X, pStartPos.Y.Scale, pStartPos.Y.Offset + d.Y)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingMain = false
		pillDrag = false
	end
end)

local hidden = false
local function toggleMenu()
	hidden = not hidden
	if hidden then
		tw(main, { Size = UDim2.new(0, 340, 0, 460) }, TW_FAST)
		task.delay(0.1, function()
			if hidden then
				main.Visible = false
				pill.Visible = true
				pill.Size = UDim2.new(0, 36, 0, 36)
				tw(pill, { Size = UDim2.new(0, 48, 0, 48) }, TW_POP)
			end
		end)
	else
		pill.Visible = false
		main.Visible = true
		main.Size = UDim2.new(0, 340, 0, 460)
		tw(main, { Size = UDim2.new(0, 360, 0, 480) }, TW_POP)
	end
end

pill.MouseButton1Click:Connect(function()
	if not pMoved then toggleMenu() end
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
		toggleMenu()
	end
end)

task.spawn(function()
	while screenGui.Parent do
		wait(2)
		if _G.RefreshFooterUI then _G.RefreshFooterUI() end
	end
end)

Notify("AbramSliem", "Loaded successfully. Press ALT or click AS icon.")
