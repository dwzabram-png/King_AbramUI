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


-- ==================== UI v3 — PERFECTED DARK MODE ====================
pcall(function()
	local oldGui = CoreGui:FindFirstChild("AbramSliemGui")
	if oldGui then oldGui:Destroy() end
end)

-- Modern Zinc palette with Emerald and Blue accents
local C = {
	BG        = Color3.fromRGB(9, 9, 11),       -- Zinc 950 (Deepest dark)
	Surface   = Color3.fromRGB(24, 24, 27),     -- Zinc 900 (Main cards)
	SurfaceHi = Color3.fromRGB(39, 39, 42),     -- Zinc 800 (Hover/Active states)
	Border    = Color3.fromRGB(39, 39, 42),     -- Zinc 800 (Borders)
	BorderHi  = Color3.fromRGB(63, 63, 70),     -- Zinc 700 (Lighter borders)
	Accent    = Color3.fromRGB(59, 130, 246),   -- Blue 500 (Primary buttons)
	AccentDim = Color3.fromRGB(37, 99, 235),    -- Blue 600 (Button clicks)
	Text      = Color3.fromRGB(250, 250, 250),  -- Zinc 50  (Primary text)
	TextDim   = Color3.fromRGB(161, 161, 170),  -- Zinc 400 (Secondary text)
	TextMuted = Color3.fromRGB(113, 113, 122),  -- Zinc 500 (Labels, inactive)
	Green     = Color3.fromRGB(16, 185, 129),   -- Emerald 500 (Active Toggles/Dots)
	Track     = Color3.fromRGB(63, 63, 70),     -- Zinc 700 (Toggle OFF track)
	Knob      = Color3.fromRGB(255, 255, 255),
}

local TW_FAST = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TW_MED  = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TW_POP  = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function tw(obj, props, info)
	TweenService:Create(obj, info or TW_FAST, props):Play()
end

local function addCorner(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 8)
	c.Parent = p
end

local function addStroke(p, col, t)
	local s = Instance.new("UIStroke")
	s.Color = col or C.Border
	s.Thickness = t or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = p
	return s
end

-- ===== ScreenGui & main frame =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AbramSliemGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
local parentGui = gethui and gethui() or CoreGui
screenGui.Parent = parentGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 480)
main.Position = UDim2.new(0.5, -180, 0.5, -240)
main.BackgroundColor3 = C.BG
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui
addCorner(main, 12)
addStroke(main, C.Border, 1)

-- ===== Title bar =====
local TITLE_H = 40
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, TITLE_H)
titleBar.BackgroundColor3 = C.Surface
titleBar.BorderSizePixel = 0
titleBar.Parent = main

-- subtle bottom border on title bar
local titleSep = Instance.new("Frame")
titleSep.Size = UDim2.new(1, 0, 0, 1)
titleSep.Position = UDim2.new(0, 0, 1, -1)
titleSep.BackgroundColor3 = C.Border
titleSep.BorderSizePixel = 0
titleSep.Parent = titleBar

-- status dot (Neutral until active)
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

-- "Alt toggle" chip (Fixed alignment)
local kbdChip = Instance.new("Frame")
kbdChip.AnchorPoint = Vector2.new(1, 0.5)
kbdChip.Position = UDim2.new(1, -12, 0.5, 0)
kbdChip.Size = UDim2.new(0, 68, 0, 22)
kbdChip.BackgroundColor3 = C.BG
kbdChip.BorderSizePixel = 0
kbdChip.Parent = titleBar
addCorner(kbdChip, 4)
addStroke(kbdChip, C.Border, 1)

local kbdKey = Instance.new("TextLabel")
kbdKey.Size = UDim2.new(0, 22, 0, 16)
kbdKey.Position = UDim2.new(0, 3, 0.5, -8)
kbdKey.BackgroundColor3 = C.SurfaceHi
kbdKey.BorderSizePixel = 0
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
kbdLabel.Text = "toggle"
kbdLabel.TextSize = 10
kbdLabel.TextColor3 = C.TextDim
kbdLabel.TextXAlignment = Enum.TextXAlignment.Left
kbdLabel.Parent = kbdChip

-- ===== Tab strip =====
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
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabsLayout.Parent = tabsBar

local pages = {}
local tabButtons = {}

local function setActiveTab(name)
	for pageName, page in pairs(pages) do
		page.Visible = (pageName == name)
	end
	for tabName, btn in pairs(tabButtons) do
		local active = tabName == name
		tw(btn, {
			BackgroundColor3 = active and C.SurfaceHi or C.Surface, -- Clean active state, no harsh colors
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

-- ===== Pages container =====
local CONTENT_TOP = TABS_TOP + TAB_H + 12
local FOOTER_H = 32
local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, -TABS_PAD * 2, 1, -(CONTENT_TOP + FOOTER_H + 10)) -- Fixed spacing to prevent scrollbar clip
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
	layout.Padding = UDim.new(0, 8) -- Increased gap
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = page
	
	local p = Instance.new("UIPadding")
	p.PaddingRight = UDim.new(0, 6)
	p.PaddingBottom = UDim.new(0, 4) -- Ensures last item isn't flush with bottom
	p.Parent = page
	
	pages[name] = page
	return page
end

local pageMain     = createPage("Main")
local pageUpgrades = createPage("Upgrades")
local pageWebhook  = createPage("Webhook")

-- ===== Footer =====
local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, FOOTER_H)
footer.Position = UDim2.new(0, 0, 1, -FOOTER_H)
footer.BackgroundColor3 = C.Surface
footer.BorderSizePixel = 0
footer.Parent = main

-- Clean footer top divider
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
footerDot.BorderSizePixel = 0
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

local function refreshFooter()
	local count = 0
	for _, v in pairs(State) do
		if v then count = count + 1 end
	end
	footerStatus.Text = count .. " active"
	footerStatus.TextColor3 = count > 0 and C.Green or C.TextDim
	tw(footerDot, { BackgroundColor3 = count > 0 and C.Green or C.TextMuted })
	tw(dot, { BackgroundColor3 = count > 0 and C.Green or C.TextMuted }) -- Link title dot too
end

-- ===== Section header (Clean, muted typography) =====
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

-- ===== Toggle: Perfected alignments & colors =====
local function createToggle(parentPage, label, key)
	local row = Instance.new("TextButton")
	row.Size = UDim2.new(1, 0, 0, 40)
	row.BackgroundColor3 = C.Surface
	row.AutoButtonColor = false
	row.Text = ""
	row.BorderSizePixel = 0
	row.Parent = parentPage
	addCorner(row, 8)
	local rowStroke = addStroke(row, C.Border, 1)
	rowStroke.Transparency = 0.5

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -64, 1, 0)
	lbl.Position = UDim2.new(0, 14, 0, 0) -- Fixed left padding
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamMedium
	lbl.Text = label
	lbl.TextSize = 13
	lbl.TextColor3 = C.Text
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row

	local track = Instance.new("Frame")
	track.AnchorPoint = Vector2.new(1, 0.5)
	track.Position = UDim2.new(1, -14, 0.5, 0) -- Fixed right padding (symmetric)
	track.Size = UDim2.new(0, 36, 0, 20)
	track.BackgroundColor3 = C.Track
	track.BorderSizePixel = 0
	track.Parent = row
	addCorner(track, 10)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new(0, 3, 0.5, -7)
	knob.BackgroundColor3 = C.Knob
	knob.BorderSizePixel = 0
	knob.Parent = track
	addCorner(knob, 7)

	local function setVisual(on)
		tw(track, { BackgroundColor3 = on and C.Green or C.Track })
		tw(knob,  { Position = on and UDim2.new(0, 19, 0.5, -7) or UDim2.new(0, 3, 0.5, -7) })
		tw(lbl,   { TextColor3 = on and C.Text or C.TextDim })
	end

	row.MouseEnter:Connect(function()
		tw(rowStroke, { Transparency = 0 })
	end)
	row.MouseLeave:Connect(function()
		tw(rowStroke, { Transparency = 0.5 })
	end)

	row.MouseButton1Click:Connect(function()
		toggleFeature(key, not State[key])
		setVisual(State[key])
		refreshFooter()
	end)
	setVisual(State[key])
end

-- ===== Input (Proper text field appearance) =====
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
	boxFrame.Size = UDim2.new(0.35, 0, 0, 26) -- True input field size
	boxFrame.BackgroundColor3 = C.BG -- Dark background marks it as input
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
	box.TextXAlignment = Enum.TextXAlignment.Left -- Left aligned!
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

-- ===== Action button =====
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

-- ===== Pages =====
createSection(pageMain, "Automation")
createToggle(pageMain, "Auto Roll",      "AutoRoll")
createToggle(pageMain, "Auto Index",     "AutoIndex")
createToggle(pageMain, "Auto Farm",      "AutoFarm")
createToggle(pageMain, "Auto Potions",   "AutoPotions")
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
refreshFooter()

-- ===== Drag (title bar + touch) =====
local dragging = false
local dragStart, startPos
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local d = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)

-- ===== Minimize / hide =====
local expandedSize  = UDim2.new(0, 360, 0, 480)
local minimizedSize = UDim2.new(0, 360, 0, TITLE_H)
local minimized = false
local hidden = false

-- Floating reopen pill
local pill = Instance.new("TextButton")
pill.Size = UDim2.new(0, 40, 0, 40)
pill.Position = UDim2.new(0, 14, 1, -56)
pill.BackgroundColor3 = C.SurfaceHi
pill.AutoButtonColor = false
pill.Font = Enum.Font.GothamBold
pill.Text = "AS"
pill.TextSize = 13
pill.TextColor3 = C.Text
pill.Visible = false
pill.Parent = screenGui
addCorner(pill, 20)
addStroke(pill, C.Border, 1)

pill.MouseEnter:Connect(function() tw(pill, { BackgroundColor3 = C.BorderHi }) end)
pill.MouseLeave:Connect(function() tw(pill, { BackgroundColor3 = C.SurfaceHi }) end)

local function setHidden(state)
	hidden = state
	if state then
		tw(main, { BackgroundTransparency = 1 })
		task.delay(0.15, function()
			if hidden then
				main.Visible = false
				pill.Visible = true
			end
		end)
	else
		main.Visible = true
		pill.Visible = false
		main.BackgroundTransparency = 1
		tw(main, { BackgroundTransparency = 0 })
	end
end

local function setMinimized(state)
	minimized = state
	tw(main, { Size = state and minimizedSize or expandedSize }, TW_MED)
end

pill.MouseButton1Click:Connect(function() setHidden(false) end)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.UserInputType == Enum.UserInputType.Keyboard
		and (input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt) then
		if hidden then
			setHidden(false)
		elseif minimized then
			setMinimized(false)
		else
			setMinimized(true)
		end
	end
end)

-- Footer auto-refresh
task.spawn(function()
	while screenGui.Parent do
		task.wait(2)
		refreshFooter()
	end
end)

-- Startup animation
main.Size = minimizedSize
main.BackgroundTransparency = 0.3
tw(main, { Size = expandedSize, BackgroundTransparency = 0 }, TW_POP)

Notify("AbramSliem", "Loaded successfully.")
