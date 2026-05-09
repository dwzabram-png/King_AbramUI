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

-- Theme palette (refined dark crimson)
local Theme = {
	BgDeep        = Color3.fromRGB(15, 5, 8),
	BgBase        = Color3.fromRGB(22, 8, 12),
	BgRaised      = Color3.fromRGB(34, 12, 18),
	BgHover       = Color3.fromRGB(50, 16, 24),
	Accent        = Color3.fromRGB(190, 35, 55),
	AccentHi      = Color3.fromRGB(225, 55, 80),
	AccentDim     = Color3.fromRGB(120, 22, 35),
	Border        = Color3.fromRGB(95, 22, 35),
	BorderSubtle  = Color3.fromRGB(60, 14, 22),
	TextPrimary   = Color3.fromRGB(255, 232, 235),
	TextSecondary = Color3.fromRGB(220, 165, 175),
	TextMuted     = Color3.fromRGB(160, 110, 120),
	TrackOff      = Color3.fromRGB(55, 18, 26),
	Knob          = Color3.fromRGB(255, 230, 232),
	Success       = Color3.fromRGB(95, 210, 130),
}

local TWEEN_FAST = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_MED  = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_POP  = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function tween(obj, props, info)
	TweenService:Create(obj, info or TWEEN_FAST, props):Play()
end

local function corner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 8)
	c.Parent = parent
	return c
end

local function pad(parent, all)
	local p = Instance.new("UIPadding")
	p.PaddingLeft   = UDim.new(0, all)
	p.PaddingRight  = UDim.new(0, all)
	p.PaddingTop    = UDim.new(0, all)
	p.PaddingBottom = UDim.new(0, all)
	p.Parent = parent
	return p
end

local function stroke(parent, color, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color or Theme.BorderSubtle
	s.Thickness = thickness or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = parent
	return s
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AbramSliemGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parentGui = gethui and gethui() or CoreGui
screenGui.Parent = parentGui

-- Drop shadow (soft outline behind main)
local shadow = Instance.new("Frame")
shadow.Size = UDim2.new(0, 392, 0, 532)
shadow.Position = UDim2.new(0.5, -196, 0.5, -266)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.55
shadow.BorderSizePixel = 0
shadow.ZIndex = 0
shadow.Parent = screenGui
corner(shadow, 14)

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 380, 0, 520)
main.Position = UDim2.new(0.5, -190, 0.5, -260)
main.BackgroundColor3 = Theme.BgBase
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui
corner(main, 12)

local mainStroke = stroke(main, Theme.Border, 1.2)
mainStroke.Transparency = 0.15

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = Theme.BgRaised
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Mask the bottom corners of the title bar so only the top stays rounded
local titleMask = Instance.new("Frame")
titleMask.Size = UDim2.new(1, 0, 0, 12)
titleMask.Position = UDim2.new(0, 0, 1, -12)
titleMask.BackgroundColor3 = Theme.BgRaised
titleMask.BorderSizePixel = 0
titleMask.ZIndex = 1
titleMask.Parent = titleBar

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Theme.BgRaised),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(58, 16, 26)),
}
titleGradient.Rotation = 0
titleGradient.Parent = titleBar

-- Accent dot before title
local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 10, 0, 10)
dot.Position = UDim2.new(0, 14, 0.5, -5)
dot.BackgroundColor3 = Theme.Accent
dot.BorderSizePixel = 0
dot.Parent = titleBar
corner(dot, 5)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -200, 1, 0)
title.Position = UDim2.new(0, 32, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "AbramSliem"
title.TextSize = 18
title.TextColor3 = Theme.TextPrimary
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local versionTag = Instance.new("TextLabel")
versionTag.Size = UDim2.new(0, 40, 0, 16)
versionTag.Position = UDim2.new(0, 122, 0.5, -8)
versionTag.BackgroundColor3 = Theme.AccentDim
versionTag.BorderSizePixel = 0
versionTag.Font = Enum.Font.GothamBold
versionTag.Text = "v2.0"
versionTag.TextSize = 10
versionTag.TextColor3 = Theme.TextPrimary
versionTag.Parent = titleBar
corner(versionTag, 4)

-- Title bar buttons
local function createTitleButton(symbol, xOffset, hoverColor)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 28, 0, 24)
	b.Position = UDim2.new(1, xOffset, 0.5, -12)
	b.BackgroundColor3 = Theme.BgBase
	b.BackgroundTransparency = 0.4
	b.AutoButtonColor = false
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Theme.TextPrimary
	b.Text = symbol
	b.Parent = titleBar
	corner(b, 6)
	b.MouseEnter:Connect(function()
		tween(b, { BackgroundColor3 = hoverColor or Theme.BgHover, BackgroundTransparency = 0 })
	end)
	b.MouseLeave:Connect(function()
		tween(b, { BackgroundColor3 = Theme.BgBase, BackgroundTransparency = 0.4 })
	end)
	return b
end

local closeBtn    = createTitleButton("×", -34,  Color3.fromRGB(180, 30, 40))
local minBtn      = createTitleButton("–", -68,  Theme.BgHover)
local hintBtn     = createTitleButton("⌥", -102, Theme.BgHover)

-- Hint tooltip on hover of the alt button
local hintLabel = Instance.new("TextLabel")
hintLabel.Size = UDim2.new(0, 130, 0, 18)
hintLabel.Position = UDim2.new(1, -244, 0.5, -9)
hintLabel.BackgroundTransparency = 1
hintLabel.Font = Enum.Font.Gotham
hintLabel.Text = "Alt — show / hide"
hintLabel.TextSize = 11
hintLabel.TextColor3 = Theme.TextSecondary
hintLabel.TextXAlignment = Enum.TextXAlignment.Right
hintLabel.Parent = titleBar

-- Tab strip
local tabsBar = Instance.new("Frame")
tabsBar.Size = UDim2.new(1, -20, 0, 36)
tabsBar.Position = UDim2.new(0, 10, 0, 50)
tabsBar.BackgroundColor3 = Theme.BgDeep
tabsBar.BorderSizePixel = 0
tabsBar.Parent = main
corner(tabsBar, 8)

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.Padding = UDim.new(0, 4)
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabsLayout.Parent = tabsBar
pad(tabsBar, 4)

-- Animated active-tab indicator
local indicator = Instance.new("Frame")
indicator.Size = UDim2.new(0, 110, 0, 28)
indicator.Position = UDim2.new(0, 4, 0, 4)
indicator.BackgroundColor3 = Theme.AccentDim
indicator.BorderSizePixel = 0
indicator.ZIndex = 1
indicator.Parent = tabsBar
corner(indicator, 6)
local indicatorStroke = stroke(indicator, Theme.Accent, 1)
indicatorStroke.Transparency = 0.3

-- Pages container
local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, -20, 1, -132)
pagesContainer.Position = UDim2.new(0, 10, 0, 94)
pagesContainer.BackgroundTransparency = 1
pagesContainer.Parent = main

-- Footer / status bar
local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, 0, 0, 28)
footer.Position = UDim2.new(0, 0, 1, -28)
footer.BackgroundColor3 = Theme.BgDeep
footer.BorderSizePixel = 0
footer.Parent = main

local footerStatus = Instance.new("TextLabel")
footerStatus.Size = UDim2.new(0.5, -12, 1, 0)
footerStatus.Position = UDim2.new(0, 12, 0, 0)
footerStatus.BackgroundTransparency = 1
footerStatus.Font = Enum.Font.GothamSemibold
footerStatus.Text = "0 active"
footerStatus.TextSize = 11
footerStatus.TextColor3 = Theme.TextSecondary
footerStatus.TextXAlignment = Enum.TextXAlignment.Left
footerStatus.Parent = footer

local footerUser = Instance.new("TextLabel")
footerUser.Size = UDim2.new(0.5, -12, 1, 0)
footerUser.Position = UDim2.new(0.5, 0, 0, 0)
footerUser.BackgroundTransparency = 1
footerUser.Font = Enum.Font.Gotham
footerUser.Text = localPlayer.DisplayName .. "  •  @" .. localPlayer.Name
footerUser.TextSize = 11
footerUser.TextColor3 = Theme.TextMuted
footerUser.TextXAlignment = Enum.TextXAlignment.Right
footerUser.Parent = footer

local pages = {}
local tabButtons = {}
local tabOrder = {}

local function refreshFooter()
	local count = 0
	for _, v in pairs(State) do
		if v then count = count + 1 end
	end
	footerStatus.Text = string.format("%d active", count)
	footerStatus.TextColor3 = count > 0 and Theme.Success or Theme.TextSecondary
end

local function createPage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = Theme.Accent
	page.ScrollBarImageTransparency = 0.4
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.Visible = false
	page.Parent = pagesContainer
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = page
	local p = Instance.new("UIPadding")
	p.PaddingTop    = UDim.new(0, 4)
	p.PaddingBottom = UDim.new(0, 6)
	p.PaddingRight  = UDim.new(0, 4)
	p.Parent = page
	pages[name] = page
	return page
end

local pageMain     = createPage("Main")
local pageUpgrades = createPage("Upgrades")
local pageWebhook  = createPage("Webhook")

-- Section header (title + divider)
local function createSection(parentPage, label)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 22)
	container.BackgroundTransparency = 1
	container.Parent = parentPage
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 200, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamBold
	lbl.Text = string.upper(label)
	lbl.TextSize = 11
	lbl.TextColor3 = Theme.Accent
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = container
	local div = Instance.new("Frame")
	div.AnchorPoint = Vector2.new(1, 0.5)
	div.Position = UDim2.new(1, 0, 0.5, 0)
	div.Size = UDim2.new(1, -210, 0, 1)
	div.BackgroundColor3 = Theme.BorderSubtle
	div.BorderSizePixel = 0
	div.Parent = container
end

-- Modern toggle: label + animated switch
local toggleRefs = {}

local function createToggle(parentPage, label, key)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 36)
	row.BackgroundColor3 = Theme.BgRaised
	row.BorderSizePixel = 0
	row.Parent = parentPage
	corner(row, 8)
	stroke(row, Theme.BorderSubtle, 1).Transparency = 0.2

	local hit = Instance.new("TextButton")
	hit.Size = UDim2.new(1, 0, 1, 0)
	hit.BackgroundTransparency = 1
	hit.Text = ""
	hit.AutoButtonColor = false
	hit.Parent = row

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, -70, 1, 0)
	lbl.Position = UDim2.new(0, 12, 0, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamSemibold
	lbl.Text = label
	lbl.TextSize = 13
	lbl.TextColor3 = Theme.TextPrimary
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Parent = row

	local track = Instance.new("Frame")
	track.AnchorPoint = Vector2.new(1, 0.5)
	track.Position = UDim2.new(1, -10, 0.5, 0)
	track.Size = UDim2.new(0, 42, 0, 20)
	track.BackgroundColor3 = Theme.TrackOff
	track.BorderSizePixel = 0
	track.Parent = row
	corner(track, 10)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.Position = UDim2.new(0, 2, 0.5, -8)
	knob.BackgroundColor3 = Theme.Knob
	knob.BorderSizePixel = 0
	knob.Parent = track
	corner(knob, 8)

	local function applyVisual(on)
		tween(track, { BackgroundColor3 = on and Theme.Accent or Theme.TrackOff })
		tween(knob,  { Position = on and UDim2.new(0, 24, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) })
		tween(row,   { BackgroundColor3 = on and Theme.BgHover or Theme.BgRaised })
	end

	hit.MouseEnter:Connect(function()
		if not State[key] then tween(row, { BackgroundColor3 = Theme.BgHover }) end
	end)
	hit.MouseLeave:Connect(function()
		if not State[key] then tween(row, { BackgroundColor3 = Theme.BgRaised }) end
	end)

	hit.MouseButton1Click:Connect(function()
		local newValue = not State[key]
		toggleFeature(key, newValue)
		applyVisual(State[key])
		refreshFooter()
	end)

	toggleRefs[key] = applyVisual
	applyVisual(State[key])
end

-- Input row: label above, input below — wider for long labels
local function createInput(parentPage, label, defaultValue, onChanged)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 56)
	container.BackgroundTransparency = 1
	container.Parent = parentPage

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 0, 18)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Theme.TextSecondary
	textLabel.Font = Enum.Font.GothamSemibold
	textLabel.TextSize = 12
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Text = label
	textLabel.Parent = container

	local boxFrame = Instance.new("Frame")
	boxFrame.Position = UDim2.new(0, 0, 0, 22)
	boxFrame.Size = UDim2.new(1, 0, 0, 32)
	boxFrame.BackgroundColor3 = Theme.BgRaised
	boxFrame.BorderSizePixel = 0
	boxFrame.Parent = container
	corner(boxFrame, 8)
	local boxStroke = stroke(boxFrame, Theme.BorderSubtle, 1)

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(1, -16, 1, 0)
	box.Position = UDim2.new(0, 8, 0, 0)
	box.BackgroundTransparency = 1
	box.TextColor3 = Theme.TextPrimary
	box.PlaceholderColor3 = Theme.TextMuted
	box.PlaceholderText = tostring(defaultValue)
	box.Text = tostring(defaultValue)
	box.Font = Enum.Font.Gotham
	box.TextSize = 13
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.ClearTextOnFocus = false
	box.Parent = boxFrame

	box.Focused:Connect(function()
		tween(boxStroke, { Color = Theme.Accent, Transparency = 0 })
		tween(boxFrame,  { BackgroundColor3 = Theme.BgHover })
	end)
	box.FocusLost:Connect(function()
		onChanged(box.Text)
		tween(boxStroke, { Color = Theme.BorderSubtle, Transparency = 0.2 })
		tween(boxFrame,  { BackgroundColor3 = Theme.BgRaised })
	end)
	return box
end

-- Action button (e.g. "Send Test")
local function createActionButton(parentPage, label, onClick)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, 0, 0, 32)
	b.BackgroundColor3 = Theme.AccentDim
	b.AutoButtonColor = false
	b.Font = Enum.Font.GothamBold
	b.Text = label
	b.TextSize = 13
	b.TextColor3 = Theme.TextPrimary
	b.Parent = parentPage
	corner(b, 8)
	stroke(b, Theme.Accent, 1).Transparency = 0.4

	b.MouseEnter:Connect(function() tween(b, { BackgroundColor3 = Theme.Accent }) end)
	b.MouseLeave:Connect(function() tween(b, { BackgroundColor3 = Theme.AccentDim }) end)
	b.MouseButton1Click:Connect(function()
		tween(b, { BackgroundColor3 = Theme.AccentHi })
		task.delay(0.1, function()
			if b.Parent then tween(b, { BackgroundColor3 = Theme.Accent }) end
		end)
		onClick()
	end)
	return b
end

-- Tabs
local function setActiveTab(name)
	for pageName, page in pairs(pages) do
		page.Visible = (pageName == name)
	end
	for tabName, ref in pairs(tabButtons) do
		local active = tabName == name
		tween(ref.label, { TextColor3 = active and Theme.TextPrimary or Theme.TextSecondary })
	end
	local target = tabButtons[name]
	if target then
		tween(indicator, {
			Position = UDim2.new(0, target.button.AbsolutePosition.X - tabsBar.AbsolutePosition.X, 0, 4),
			Size = UDim2.new(0, target.button.AbsoluteSize.X, 0, 28),
		}, TWEEN_MED)
	end
end

local function createTabButton(name, icon)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 110, 1, -8)
	btn.BackgroundTransparency = 1
	btn.AutoButtonColor = false
	btn.Text = ""
	btn.LayoutOrder = #tabOrder + 1
	btn.Parent = tabsBar

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamBold
	lbl.Text = icon .. "  " .. name
	lbl.TextSize = 12
	lbl.TextColor3 = Theme.TextSecondary
	lbl.ZIndex = 2
	lbl.Parent = btn

	btn.MouseButton1Click:Connect(function() setActiveTab(name) end)
	btn.MouseEnter:Connect(function()
		if not pages[name].Visible then tween(lbl, { TextColor3 = Theme.TextPrimary }) end
	end)
	btn.MouseLeave:Connect(function()
		if not pages[name].Visible then tween(lbl, { TextColor3 = Theme.TextSecondary }) end
	end)

	tabButtons[name] = { button = btn, label = lbl }
	table.insert(tabOrder, name)
end

createTabButton("Main",     "⚡")
createTabButton("Upgrades", "⚙")
createTabButton("Webhook",  "🔔")

-- ===== Content =====
createSection(pageMain, "Automation")
createToggle(pageMain, "Auto Roll",       "AutoRoll")
createToggle(pageMain, "Auto Index",      "AutoIndex")
createToggle(pageMain, "Auto Farm",       "AutoFarm")
createToggle(pageMain, "Auto Potions",    "AutoPotions")
createToggle(pageMain, "Auto Best Zone",  "AutoTeleportBestZone")
createSection(pageMain, "Settings")
createInput(pageMain, "Best zone interval (sec)", Config.AutoBestZoneInterval, function(v)
	Config.AutoBestZoneInterval = math.max(1, tonumber(v) or 30)
end)

createSection(pageUpgrades, "Progression")
createToggle(pageUpgrades, "Auto Upgrade",     "AutoUpgrade")
createToggle(pageUpgrades, "Auto Buy Zone",    "AutoBuyZone")
createToggle(pageUpgrades, "Auto Rebirth",     "AutoRebirth")
createToggle(pageUpgrades, "Auto Equip Best",  "AutoEquipBest")
createSection(pageUpgrades, "Settings")
createInput(pageUpgrades, "Upgrade interval (sec)", Config.AutoUpgradeInterval, function(v)
	Config.AutoUpgradeInterval = math.max(1, tonumber(v) or 30)
end)

createSection(pageWebhook, "Discord")
createToggle(pageWebhook, "Webhook reporting", "Webhook")
createInput(pageWebhook, "Webhook URL", Config.WebhookUrl, function(v)
	Config.WebhookUrl = tostring(v or "")
end)
createInput(pageWebhook, "Send interval (sec)", Config.WebhookInterval, function(v)
	Config.WebhookInterval = math.max(1, tonumber(v) or 30)
end)
createSection(pageWebhook, "Actions")
createActionButton(pageWebhook, "Send test message", function()
	if not isValidWebhook(Config.WebhookUrl) then
		Notify("Webhook", "Invalid Discord webhook URL")
		return
	end
	local ok = SendDiscordWebhook(Config.WebhookUrl, {
		title = "AbramSliem — test",
		description = "Triggered by " .. localPlayer.Name,
	})
	Notify("Webhook", ok and "Test sent" or "Failed to send test")
end)

setActiveTab("Main")
refreshFooter()

-- Realign indicator after first frame so AbsolutePosition is valid
task.defer(function() setActiveTab("Main") end)

-- Drag (title bar)
local dragging = false
local dragStart, startPos
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		main.Position = newPos
		shadow.Position = UDim2.new(newPos.X.Scale, newPos.X.Offset - 6, newPos.Y.Scale, newPos.Y.Offset - 6)
	end
end)

-- Show / hide / minimize
local expandedSize  = UDim2.new(0, 380, 0, 520)
local minimizedSize = UDim2.new(0, 380, 0, 42)
local minimized = false
local hidden = false

-- Floating reopen pill (also handy on touch)
local pill = Instance.new("TextButton")
pill.Size = UDim2.new(0, 44, 0, 44)
pill.Position = UDim2.new(0, 16, 1, -60)
pill.BackgroundColor3 = Theme.Accent
pill.AutoButtonColor = false
pill.Font = Enum.Font.GothamBold
pill.Text = "AS"
pill.TextSize = 14
pill.TextColor3 = Theme.TextPrimary
pill.Visible = false
pill.Parent = screenGui
corner(pill, 22)
stroke(pill, Theme.AccentHi, 1.5)
pill.MouseEnter:Connect(function() tween(pill, { BackgroundColor3 = Theme.AccentHi }) end)
pill.MouseLeave:Connect(function() tween(pill, { BackgroundColor3 = Theme.Accent }) end)

local function setMinimized(state)
	minimized = state
	tween(main, { Size = state and minimizedSize or expandedSize }, TWEEN_MED)
	tween(shadow, {
		Size = state and UDim2.new(0, 392, 0, 54) or UDim2.new(0, 392, 0, 532),
	}, TWEEN_MED)
end

local function setHidden(state)
	hidden = state
	if state then
		tween(main,   { BackgroundTransparency = 1 }, TWEEN_FAST)
		tween(shadow, { BackgroundTransparency = 1 }, TWEEN_FAST)
		task.delay(0.15, function()
			if hidden then
				main.Visible = false
				shadow.Visible = false
				pill.Visible = true
			end
		end)
	else
		main.Visible = true
		shadow.Visible = true
		pill.Visible = false
		main.BackgroundTransparency = 1
		shadow.BackgroundTransparency = 1
		tween(main,   { BackgroundTransparency = 0 }, TWEEN_FAST)
		tween(shadow, { BackgroundTransparency = 0.55 }, TWEEN_FAST)
	end
end

minBtn.MouseButton1Click:Connect(function() setMinimized(not minimized) end)
closeBtn.MouseButton1Click:Connect(function() setHidden(true) end)
hintBtn.MouseButton1Click:Connect(function() setHidden(true) end)
pill.MouseButton1Click:Connect(function() setHidden(false) end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard
		and (input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt) then
		setHidden(not hidden)
	end
end)

-- Refresh footer when state changes externally (notifications / loop errors etc.)
task.spawn(function()
	while screenGui.Parent do
		task.wait(1)
		refreshFooter()
	end
end)

-- Open animation
main.Size = UDim2.new(0, 380, 0, 0)
shadow.Size = UDim2.new(0, 392, 0, 0)
main.BackgroundTransparency = 1
shadow.BackgroundTransparency = 1
tween(main,   { Size = expandedSize, BackgroundTransparency = 0 }, TWEEN_POP)
tween(shadow, { Size = UDim2.new(0, 392, 0, 532), BackgroundTransparency = 0.55 }, TWEEN_POP)

Notify("AbramSliem", "Loaded successfully.")
