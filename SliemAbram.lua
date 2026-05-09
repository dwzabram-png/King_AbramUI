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

-- ==================== DARK RED UI (v3 - Rectangular + Animations) ====================
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
main.Size = UDim2.new(0, 400, 0, 520)
main.Position = UDim2.new(0.5, -200, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(12, 2, 4)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = screenGui
corner(main, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(160, 25, 40)
stroke.Thickness = 2
stroke.Transparency = 0.15
stroke.Parent = main

-- Animated top accent bar with scanning glow
local topAccent = Instance.new("Frame")
topAccent.Size = UDim2.new(1, 0, 0, 3)
topAccent.Position = UDim2.new(0, 0, 0, 0)
topAccent.BorderSizePixel = 0
topAccent.BackgroundColor3 = Color3.fromRGB(220, 35, 50)
topAccent.Parent = main
local accentGradient = Instance.new("UIGradient")
accentGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 20, 30)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 60, 80)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 20, 30))
})
accentGradient.Parent = topAccent

-- Animate accent scanning effect
task.spawn(function()
	while topAccent and topAccent.Parent do
		TweenService:Create(accentGradient, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Offset = Vector2.new(1, 0)
		}):Play()
		task.wait(2)
		TweenService:Create(accentGradient, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			Offset = Vector2.new(-1, 0)
		}):Play()
		task.wait(2)
	end
end)

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 44)
titleBar.Position = UDim2.new(0, 0, 0, 3)
titleBar.BackgroundColor3 = Color3.fromRGB(22, 5, 8)
titleBar.BorderSizePixel = 0
titleBar.Parent = main
local titleBarGradient = Instance.new("UIGradient")
titleBarGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 8, 14)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 4, 6))
})
titleBarGradient.Rotation = 90
titleBarGradient.Parent = titleBar

-- Title icon "A" with pulse animation
local titleIcon = Instance.new("TextLabel")
titleIcon.Size = UDim2.new(0, 30, 0, 30)
titleIcon.Position = UDim2.new(0, 10, 0.5, -15)
titleIcon.BackgroundColor3 = Color3.fromRGB(180, 25, 40)
titleIcon.Text = "A"
titleIcon.Font = Enum.Font.GothamBlack
titleIcon.TextSize = 17
titleIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
titleIcon.BorderSizePixel = 0
titleIcon.Parent = titleBar

-- Pulse glow on icon
task.spawn(function()
	while titleIcon and titleIcon.Parent do
		TweenService:Create(titleIcon, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			BackgroundColor3 = Color3.fromRGB(220, 40, 60)
		}):Play()
		task.wait(1.5)
		TweenService:Create(titleIcon, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			BackgroundColor3 = Color3.fromRGB(140, 20, 35)
		}):Play()
		task.wait(1.5)
	end
end)

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
title.Size = UDim2.new(1, -160, 1, 0)
title.Position = UDim2.new(0, 48, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "AbramSliem"
title.TextSize = 19
title.TextColor3 = Color3.fromRGB(255, 225, 225)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Version badge
local version = Instance.new("TextLabel")
version.Size = UDim2.new(0, 28, 0, 14)
version.Position = UDim2.new(0, 48 + 95, 0.5, -7)
version.BackgroundColor3 = Color3.fromRGB(200, 35, 50)
version.BackgroundTransparency = 0.4
version.Text = "v3"
version.Font = Enum.Font.GothamBold
version.TextSize = 9
version.TextColor3 = Color3.fromRGB(255, 210, 210)
version.BorderSizePixel = 0
version.Parent = titleBar

-- Minimize button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -68, 0.5, -14)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 12, 18)
minimizeBtn.Text = "_"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 14
minimizeBtn.TextColor3 = Color3.fromRGB(255, 170, 170)
minimizeBtn.AutoButtonColor = false
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar
minimizeBtn.MouseEnter:Connect(function()
	TweenService:Create(minimizeBtn, TweenInfo.new(0.12), {
		BackgroundColor3 = Color3.fromRGB(80, 20, 30),
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()
end)
minimizeBtn.MouseLeave:Connect(function()
	TweenService:Create(minimizeBtn, TweenInfo.new(0.12), {
		BackgroundColor3 = Color3.fromRGB(45, 12, 18),
		TextColor3 = Color3.fromRGB(255, 170, 170)
	}):Play()
end)

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
closeBtn.BackgroundColor3 = Color3.fromRGB(45, 12, 18)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(255, 170, 170)
closeBtn.AutoButtonColor = false
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar
closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.12), {
		BackgroundColor3 = Color3.fromRGB(200, 30, 40),
		TextColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.12), {
		BackgroundColor3 = Color3.fromRGB(45, 12, 18),
		TextColor3 = Color3.fromRGB(255, 170, 170)
	}):Play()
end)
closeBtn.MouseButton1Click:Connect(function()
	-- Flash red on stroke then collapse
	TweenService:Create(stroke, TweenInfo.new(0.1), {
		Color = Color3.fromRGB(255, 50, 60),
		Transparency = 0
	}):Play()
	task.delay(0.1, function()
		TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 400, 0, 0),
			BackgroundTransparency = 1
		}):Play()
		TweenService:Create(shadow, TweenInfo.new(0.3), { ImageTransparency = 1 }):Play()
		TweenService:Create(stroke, TweenInfo.new(0.3), { Transparency = 1 }):Play()
		task.delay(0.32, function()
			for key, value in pairs(State) do
				if value then toggleFeature(key, false) end
			end
			screenGui:Destroy()
		end)
	end)
end)

local hint = Instance.new("TextLabel")
hint.Size = UDim2.new(0, 74, 0, 18)
hint.Position = UDim2.new(1, -148, 0.5, -9)
hint.BackgroundColor3 = Color3.fromRGB(40, 10, 16)
hint.BackgroundTransparency = 0.3
hint.Font = Enum.Font.Gotham
hint.Text = "Alt = toggle"
hint.TextSize = 9
hint.TextColor3 = Color3.fromRGB(200, 130, 140)
hint.TextXAlignment = Enum.TextXAlignment.Center
hint.BorderSizePixel = 0
hint.Parent = titleBar

-- Separator lines (double)
local sep1 = Instance.new("Frame")
sep1.Size = UDim2.new(1, 0, 0, 1)
sep1.Position = UDim2.new(0, 0, 0, 47)
sep1.BackgroundColor3 = Color3.fromRGB(140, 25, 35)
sep1.BackgroundTransparency = 0.5
sep1.BorderSizePixel = 0
sep1.Parent = main

local sep2 = Instance.new("Frame")
sep2.Size = UDim2.new(1, 0, 0, 1)
sep2.Position = UDim2.new(0, 0, 0, 49)
sep2.BackgroundColor3 = Color3.fromRGB(80, 15, 22)
sep2.BackgroundTransparency = 0.6
sep2.BorderSizePixel = 0
sep2.Parent = main

-- Tabs bar
local tabsBar = Instance.new("Frame")
tabsBar.Size = UDim2.new(1, 0, 0, 32)
tabsBar.Position = UDim2.new(0, 0, 0, 50)
tabsBar.BackgroundColor3 = Color3.fromRGB(16, 4, 6)
tabsBar.BorderSizePixel = 0
tabsBar.Parent = main
corner(tabsBar, 8)

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.Padding = UDim.new(0, 0)
tabsLayout.Parent = tabsBar
pad(tabsBar, 4)

-- Tab underline (animated, slides between tabs)
local tabUnderline = Instance.new("Frame")
tabUnderline.Size = UDim2.new(0, 133, 0, 2)
tabUnderline.Position = UDim2.new(0, 0, 0, 82)
tabUnderline.BackgroundColor3 = Color3.fromRGB(255, 45, 65)
tabUnderline.BorderSizePixel = 0
tabUnderline.Parent = main
local underlineGlow = Instance.new("UIGradient")
underlineGlow.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.6),
	NumberSequenceKeypoint.new(0.5, 0),
	NumberSequenceKeypoint.new(1, 0.6)
})
underlineGlow.Parent = tabUnderline

-- Separator under tabs
local sep3 = Instance.new("Frame")
sep3.Size = UDim2.new(1, 0, 0, 1)
sep3.Position = UDim2.new(0, 0, 0, 84)
sep3.BackgroundColor3 = Color3.fromRGB(60, 14, 20)
sep3.BackgroundTransparency = 0.5
sep3.BorderSizePixel = 0
sep3.Parent = main

-- Pages container
local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, -12, 1, -120)
pagesContainer.Position = UDim2.new(0, 6, 0, 88)
pagesContainer.BackgroundTransparency = 1
pagesContainer.BorderSizePixel = 0
pagesContainer.Parent = main

-- Status bar
local statusBar = Instance.new("Frame")
statusBar.Size = UDim2.new(1, 0, 0, 26)
statusBar.Position = UDim2.new(0, 0, 1, -26)
statusBar.BackgroundColor3 = Color3.fromRGB(16, 4, 7)
statusBar.BorderSizePixel = 0
statusBar.Parent = main
local statusSep = Instance.new("Frame")
statusSep.Size = UDim2.new(1, 0, 0, 1)
statusSep.BackgroundColor3 = Color3.fromRGB(80, 18, 25)
statusSep.BackgroundTransparency = 0.5
statusSep.BorderSizePixel = 0
statusSep.Parent = statusBar

-- Animated status dot (breathing)
local statusDot = Instance.new("Frame")
statusDot.Size = UDim2.new(0, 8, 0, 8)
statusDot.Position = UDim2.new(0, 10, 0.5, -3)
statusDot.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
statusDot.BorderSizePixel = 0
statusDot.Parent = statusBar

task.spawn(function()
	while statusDot and statusDot.Parent do
		TweenService:Create(statusDot, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			BackgroundTransparency = 0.5
		}):Play()
		task.wait(1)
		TweenService:Create(statusDot, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			BackgroundTransparency = 0
		}):Play()
		task.wait(1)
	end
end)

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0.5, -30, 1, 0)
statusText.Position = UDim2.new(0, 24, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Font = Enum.Font.Gotham
statusText.Text = "Ready"
statusText.TextSize = 10
statusText.TextColor3 = Color3.fromRGB(160, 110, 120)
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusBar

local statusUser = Instance.new("TextLabel")
statusUser.Size = UDim2.new(0.5, -10, 1, 0)
statusUser.Position = UDim2.new(0.5, 0, 0, 0)
statusUser.BackgroundTransparency = 1
statusUser.Font = Enum.Font.GothamBold
statusUser.Text = localPlayer.Name
statusUser.TextSize = 10
statusUser.TextColor3 = Color3.fromRGB(200, 50, 65)
statusUser.TextXAlignment = Enum.TextXAlignment.Right
statusUser.Parent = statusBar

local pages = {}
local tabButtons = {}
local tabPositions = {}
local activeTab = "Main"

local function createPage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name
	page.Size = UDim2.new(1, 0, 1, -4)
	page.Position = UDim2.new(0, 0, 0, 2)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = Color3.fromRGB(180, 30, 45)
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.Visible = false
	page.Parent = pagesContainer
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 4)
	layout.Parent = page
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 4)
	padding.PaddingBottom = UDim.new(0, 4)
	padding.PaddingLeft = UDim.new(0, 2)
	padding.PaddingRight = UDim.new(0, 2)
	padding.Parent = page
	pages[name] = page
	return page
end

local pageMain     = createPage("Main")
local pageUpgrades = createPage("Upgrades")
local pageWebhook  = createPage("Webhook")

local function createSectionHeader(parentPage, text)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 22)
	container.BackgroundTransparency = 1
	container.Parent = parentPage

	local line1 = Instance.new("Frame")
	line1.Size = UDim2.new(0, 14, 0, 1)
	line1.Position = UDim2.new(0, 0, 0.5, 0)
	line1.BackgroundColor3 = Color3.fromRGB(180, 40, 55)
	line1.BackgroundTransparency = 0.4
	line1.BorderSizePixel = 0
	line1.Parent = container

	local header = Instance.new("TextLabel")
	header.Size = UDim2.new(1, -20, 1, 0)
	header.Position = UDim2.new(0, 18, 0, 0)
	header.BackgroundTransparency = 1
	header.Font = Enum.Font.GothamBold
	header.TextSize = 10
	header.TextColor3 = Color3.fromRGB(200, 55, 70)
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.Text = string.upper(text)
	header.Parent = container
end

local function createToggle(parentPage, label, key)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.BackgroundColor3 = Color3.fromRGB(22, 6, 10)
	btn.TextColor3 = Color3.fromRGB(255, 232, 232)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 13
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.BorderSizePixel = 0
	btn.Parent = parentPage

	-- Left accent bar (animates on toggle)
	local leftBar = Instance.new("Frame")
	leftBar.Size = UDim2.new(0, 3, 1, 0)
	leftBar.Position = UDim2.new(0, 0, 0, 0)
	leftBar.BackgroundColor3 = Color3.fromRGB(60, 15, 22)
	leftBar.BorderSizePixel = 0
	leftBar.Parent = btn

	-- Toggle indicator dot
	local indicator = Instance.new("Frame")
	indicator.Size = UDim2.new(0, 8, 0, 8)
	indicator.Position = UDim2.new(0, 14, 0.5, -4)
	indicator.BackgroundColor3 = Color3.fromRGB(70, 22, 28)
	indicator.BorderSizePixel = 0
	indicator.Parent = btn

	local labelText = Instance.new("TextLabel")
	labelText.Size = UDim2.new(1, -80, 1, 0)
	labelText.Position = UDim2.new(0, 30, 0, 0)
	labelText.BackgroundTransparency = 1
	labelText.Font = Enum.Font.GothamSemibold
	labelText.TextSize = 13
	labelText.TextColor3 = Color3.fromRGB(240, 210, 215)
	labelText.TextXAlignment = Enum.TextXAlignment.Left
	labelText.Text = label
	labelText.Parent = btn

	-- ON/OFF state badge
	local stateLabel = Instance.new("TextLabel")
	stateLabel.Size = UDim2.new(0, 38, 0, 18)
	stateLabel.Position = UDim2.new(1, -48, 0.5, -9)
	stateLabel.BackgroundColor3 = Color3.fromRGB(40, 10, 16)
	stateLabel.Font = Enum.Font.GothamBold
	stateLabel.TextSize = 10
	stateLabel.TextColor3 = Color3.fromRGB(180, 120, 130)
	stateLabel.Text = "OFF"
	stateLabel.BorderSizePixel = 0
	stateLabel.Parent = btn

	-- Hover effect with left bar glow
	btn.MouseEnter:Connect(function()
		if not State[key] then
			TweenService:Create(btn, TweenInfo.new(0.1), {
				BackgroundColor3 = Color3.fromRGB(32, 10, 16)
			}):Play()
			TweenService:Create(leftBar, TweenInfo.new(0.1), {
				BackgroundColor3 = Color3.fromRGB(120, 30, 42)
			}):Play()
		end
	end)
	btn.MouseLeave:Connect(function()
		if not State[key] then
			TweenService:Create(btn, TweenInfo.new(0.1), {
				BackgroundColor3 = Color3.fromRGB(22, 6, 10)
			}):Play()
			TweenService:Create(leftBar, TweenInfo.new(0.1), {
				BackgroundColor3 = Color3.fromRGB(60, 15, 22)
			}):Play()
		end
	end)

	btn.MouseButton1Click:Connect(function()
		local newValue = not State[key]
		toggleFeature(key, newValue)
		local isOn = State[key]
		stateLabel.Text = isOn and "ON" or "OFF"

		-- Ripple flash effect
		local ripple = Instance.new("Frame")
		ripple.Size = UDim2.new(1, 0, 1, 0)
		ripple.BackgroundColor3 = isOn and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 60)
		ripple.BackgroundTransparency = 0.8
		ripple.BorderSizePixel = 0
		ripple.ZIndex = 10
		ripple.Parent = btn
		TweenService:Create(ripple, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 1
		}):Play()
		task.delay(0.35, function()
			if ripple and ripple.Parent then ripple:Destroy() end
		end)

		-- Animate all elements
		local targetBg = isOn and Color3.fromRGB(55, 14, 20) or Color3.fromRGB(22, 6, 10)
		local targetBar = isOn and Color3.fromRGB(0, 220, 90) or Color3.fromRGB(60, 15, 22)
		local targetIndicator = isOn and Color3.fromRGB(0, 220, 90) or Color3.fromRGB(70, 22, 28)
		local targetStateColor = isOn and Color3.fromRGB(0, 220, 90) or Color3.fromRGB(180, 120, 130)
		local targetStateBg = isOn and Color3.fromRGB(0, 50, 22) or Color3.fromRGB(40, 10, 16)

		TweenService:Create(btn, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = targetBg
		}):Play()
		TweenService:Create(leftBar, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = targetBar
		}):Play()
		TweenService:Create(indicator, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = targetIndicator
		}):Play()
		TweenService:Create(stateLabel, TweenInfo.new(0.22), {
			TextColor3 = targetStateColor,
			BackgroundColor3 = targetStateBg
		}):Play()

		-- Update status bar text
		local activeCount = 0
		for _, v in pairs(State) do if v then activeCount = activeCount + 1 end end
		statusText.Text = activeCount > 0 and (activeCount .. " active") or "Ready"
	end)
end

local function createInput(parentPage, label, defaultValue, onChanged)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 36)
	container.BackgroundColor3 = Color3.fromRGB(18, 5, 8)
	container.BorderSizePixel = 0
	container.Parent = parentPage

	local inputAccent = Instance.new("Frame")
	inputAccent.Size = UDim2.new(0, 3, 1, 0)
	inputAccent.BackgroundColor3 = Color3.fromRGB(100, 25, 35)
	inputAccent.BackgroundTransparency = 0.4
	inputAccent.BorderSizePixel = 0
	inputAccent.Parent = container

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0.52, 0, 1, 0)
	textLabel.Position = UDim2.new(0, 14, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(200, 160, 168)
	textLabel.Font = Enum.Font.Gotham
	textLabel.TextSize = 12
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.Text = label
	textLabel.Parent = container

	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.40, -8, 0, 24)
	box.Position = UDim2.new(0.58, 0, 0.5, -12)
	box.BackgroundColor3 = Color3.fromRGB(10, 2, 4)
	box.TextColor3 = Color3.fromRGB(255, 220, 225)
	box.PlaceholderText = tostring(defaultValue)
	box.PlaceholderColor3 = Color3.fromRGB(100, 55, 65)
	box.Text = tostring(defaultValue)
	box.Font = Enum.Font.GothamSemibold
	box.TextSize = 12
	box.ClearTextOnFocus = false
	box.BorderSizePixel = 0
	box.Parent = container

	local boxStroke = Instance.new("UIStroke")
	boxStroke.Color = Color3.fromRGB(70, 18, 26)
	boxStroke.Thickness = 1
	boxStroke.Transparency = 0.3
	boxStroke.Parent = box

	box.Focused:Connect(function()
		TweenService:Create(boxStroke, TweenInfo.new(0.15), {
			Color = Color3.fromRGB(200, 45, 60),
			Transparency = 0
		}):Play()
		TweenService:Create(inputAccent, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(200, 45, 60),
			BackgroundTransparency = 0
		}):Play()
	end)
	box.FocusLost:Connect(function()
		onChanged(box.Text)
		TweenService:Create(boxStroke, TweenInfo.new(0.2), {
			Color = Color3.fromRGB(70, 18, 26),
			Transparency = 0.3
		}):Play()
		TweenService:Create(inputAccent, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(100, 25, 35),
			BackgroundTransparency = 0.4
		}):Play()
		-- Flash confirm
		TweenService:Create(box, TweenInfo.new(0.08), {
			BackgroundColor3 = Color3.fromRGB(40, 10, 16)
		}):Play()
		task.delay(0.12, function()
			if box and box.Parent then
				TweenService:Create(box, TweenInfo.new(0.2), {
					BackgroundColor3 = Color3.fromRGB(10, 2, 4)
				}):Play()
			end
		end)
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
	activeTab = name
	-- Animate page transitions (fade in/out)
	for pageName, page in pairs(pages) do
		if pageName == name then
			page.Visible = true
			page.CanvasPosition = Vector2.new(0, 0)
			-- Fade in all children
			for _, child in ipairs(page:GetChildren()) do
				if child:IsA("GuiObject") then
					child.BackgroundTransparency = 1
					TweenService:Create(child, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundTransparency = child:IsA("TextButton") and 0 or (child:IsA("Frame") and (child.BackgroundTransparency > 0.5 and 1 or 0) or 1)
					}):Play()
				end
			end
			page.ScrollBarImageTransparency = 1
			TweenService:Create(page, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				ScrollBarImageTransparency = 0.3
			}):Play()
		else
			page.Visible = false
		end
	end

	-- Animate tab buttons
	for tabName, btn in pairs(tabButtons) do
		local isActive = tabName == name
		local targetBg = isActive and Color3.fromRGB(35, 10, 15) or Color3.fromRGB(16, 4, 6)
		local targetText = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 110, 120)
		TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundColor3 = targetBg,
			TextColor3 = targetText
		}):Play()
	end

	-- Slide underline to active tab position
	if tabPositions[name] ~= nil then
		TweenService:Create(tabUnderline, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, tabPositions[name], 0, 82)
		}):Play()
	end
end

local tabIndex = 0
local function createTabButton(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 133, 1, 0)
	btn.BackgroundColor3 = Color3.fromRGB(16, 4, 6)
	btn.TextColor3 = Color3.fromRGB(150, 110, 120)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.Text = name
	btn.AutoButtonColor = false
	btn.BorderSizePixel = 0
	btn.Parent = tabsBar

	tabPositions[name] = tabIndex * 133
	tabIndex = tabIndex + 1

	-- Hover
	btn.MouseEnter:Connect(function()
		if activeTab ~= name then
			TweenService:Create(btn, TweenInfo.new(0.1), {
				BackgroundColor3 = Color3.fromRGB(28, 8, 12)
			}):Play()
		end
	end)
	btn.MouseLeave:Connect(function()
		if activeTab ~= name then
			TweenService:Create(btn, TweenInfo.new(0.1), {
				BackgroundColor3 = Color3.fromRGB(16, 4, 6)
			}):Play()
		end
	end)

	btn.MouseButton1Click:Connect(function()
		setActiveTab(name)
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

-- Dragging with smooth tween
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
		TweenService:Create(main, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = newPos
		}):Play()
		shadow.Position = UDim2.new(0, newPos.X.Offset + 200, 0, newPos.Y.Offset + 260)
	end
end)

-- Toggle minimize with Alt or minimize button
local expandedSize = UDim2.new(0, 400, 0, 520)
local minimizedSize = UDim2.new(0, 400, 0, 47)
local minimized = false

local function toggleMinimize()
	minimized = not minimized
	local goalSize = minimized and minimizedSize or expandedSize
	local goalShadow = minimized and UDim2.new(0, 440, 0, 87) or UDim2.new(0, 420, 0, 540)
	TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = goalSize
	}):Play()
	TweenService:Create(main, TweenInfo.new(0.2), {
		BackgroundTransparency = minimized and 0.05 or 0
	}):Play()
	TweenService:Create(shadow, TweenInfo.new(0.25), {
		Size = goalShadow,
		ImageTransparency = minimized and 0.85 or 0.5
	}):Play()
	-- Animate stroke
	TweenService:Create(stroke, TweenInfo.new(0.2), {
		Transparency = minimized and 0.5 or 0.15
	}):Play()
end

minimizeBtn.MouseButton1Click:Connect(toggleMinimize)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.Keyboard and (input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt) then
		toggleMinimize()
	end
end)

-- Opening animation: slide from left + fade
main.Position = UDim2.new(0.5, -250, 0.5, -260)
main.Size = expandedSize
main.BackgroundTransparency = 0.6
shadow.ImageTransparency = 1

TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
	Position = UDim2.new(0.5, -200, 0.5, -260),
	BackgroundTransparency = 0
}):Play()
TweenService:Create(shadow, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	ImageTransparency = 0.5
}):Play()
TweenService:Create(stroke, TweenInfo.new(0.5), {
	Transparency = 0.15
}):Play()

-- Title text typewriter effect
title.Text = ""
task.spawn(function()
	local fullTitle = "AbramSliem"
	for i = 1, #fullTitle do
		title.Text = string.sub(fullTitle, 1, i)
		task.wait(0.04)
	end
end)

Notify("AbramSliem v3", "Loaded successfully.")
