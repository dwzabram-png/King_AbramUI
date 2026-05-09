repeat task.wait() until game:IsLoaded()

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

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

-- UI
local Window = Fluent:CreateWindow({
	Title = "Plink Slime RNG v2.0",
	SubTitle = "by who?",
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	Acrylic = false,
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
	Main = Window:AddTab({ Title = "Main", Icon = "" }),
	Upgrades = Window:AddTab({ Title = "Upgrades", Icon = "" }),
	Webhooks = Window:AddTab({ Title = "Webhooks", Icon = "" }),
	Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Centralized remote caller (removes duplication)
local RemotesFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("leifstout_networker@0.3.1"):WaitForChild("networker"):WaitForChild("_remotes")

local function callRemote(service, method, ...)
	local remote = RemotesFolder:FindFirstChild(service)
	if not remote then return nil, "Remote folder not found" end
	local func = remote:FindFirstChild("RemoteFunction")
	if not func then return nil, "RemoteFunction not found" end
	return pcall(function(...) return func:InvokeServer(...) end, method, ...)
end

-- Notifications
local function Notify(title, content)
	Fluent:Notify({ Title = title, Content = content, Duration = 5 })
end

-- Safe teleport
local function TP(x, y, z)
	if not clientHRP then return end
	clientHRP.CFrame = CFrame.new(x, y, z)
end

-- Discord webhook with validation
local function isValidWebhook(url)
	return type(url) == "string" and url:match("^https://discord%.com/api/webhooks/%d+/.+") ~= nil
end

local function SendDiscordWebhook(url, data)
	if not isValidWebhook(url) then
		Notify("Webhook Error", "Invalid Discord webhook URL")
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
		request({
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
		if tile:IsA("GuiButton") or (tile.Name ~= "UIAspectRatioConstraint" and tile.Name ~= "UpgradeHoverInfo") then
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

-- ==================== TABS ====================

Tabs.Main:AddButton({
	Title = "Discord",
	Description = "Join the discord for updates <3",
	Callback = function()
		setclipboard("https://discord.gg/hJCn7UnkVZ")
		Notify("Discord", "Link copied to clipboard.")
	end
})

-- Auto Roll
local autoRollConnection
local AutoRoll = Tabs.Main:AddToggle("AutoRoll", { Title = "Auto Roll", Default = false })
AutoRoll:OnChanged(function()
	Notify("Auto Roll", tostring(Options.AutoRoll.Value))
	if autoRollConnection then autoRollConnection:Disconnect() end
	if Options.AutoRoll.Value then
		autoRollConnection = task.spawn(function()
			while Options.AutoRoll.Value do
				local cd = getRollCooldown()
				task.wait(cd)
				if Options.AutoRoll.Value then Roll() end
			end
		end)
	end
end)

-- Auto Index
local AutoIndex = Tabs.Main:AddToggle("AutoIndex", { Title = "Auto Index", Default = false })
AutoIndex:OnChanged(function()
	Notify("Auto Index", tostring(Options.AutoIndex.Value))
	task.spawn(function()
		while Options.AutoIndex.Value do
			task.wait(30)
			if Options.AutoIndex.Value then ClaimIndex() end
		end
	end)
end)

-- Auto Farm (optimized)
local autoFarmConnection
local AutoFarm = Tabs.Main:AddToggle("AutoFarm", { Title = "Auto Farm", Default = false })
AutoFarm:OnChanged(function()
	Notify("Auto Farm", tostring(Options.AutoFarm.Value))
	if autoFarmConnection then autoFarmConnection:Disconnect() end
	if not Options.AutoFarm.Value then return end

	autoFarmConnection = RunService.Heartbeat:Connect(function()
		if not Options.AutoFarm.Value or not clientHRP then return end
		local lootFolder = workspace:FindFirstChild("Loot")
		if not lootFolder then return end

		for _, drop in ipairs(lootFolder:GetChildren()) do
			if not Options.AutoFarm.Value then break end
			for _, child in ipairs(drop:GetChildren()) do
				if child:IsA("BasePart") and child.Name ~= "LootHighlight" then
					child.CFrame = clientHRP.CFrame
				end
			end
		end
	end)
end)

-- Auto Potions
local AutoPotions = Tabs.Main:AddToggle("AutoPotions", { Title = "Auto Potions", Default = false })
AutoPotions:OnChanged(function()
	Notify("Auto Potions", tostring(Options.AutoPotions.Value))
	task.spawn(function()
		while Options.AutoPotions.Value do
			ConsumePotions()
			task.wait(3)
		end
	end)
end)

-- Auto Best Zone
local AutoTeleportBestZone = Tabs.Main:AddToggle("AutoTeleportBestZone", { Title = "Auto Best Zone", Default = false })
AutoTeleportBestZone:OnChanged(function()
	Notify("Auto Best Zone", tostring(Options.AutoTeleportBestZone.Value))
	task.spawn(function()
		while Options.AutoTeleportBestZone.Value do
			TeleportBestZone()
			task.wait(tonumber(Options.AutoBestZoneInterval.Value) or 30)
		end
	end)
end)

Tabs.Main:AddInput("AutoBestZoneInterval", {
	Title = "Auto Best Zone Interval",
	Default = "30",
	Placeholder = "10",
	Numeric = true,
	Finished = false,
	Callback = function() end
})

-- Upgrades Tab
local AutoUpgrade = Tabs.Upgrades:AddToggle("AutoUpgrade", { Title = "Auto Upgrade", Default = false })
AutoUpgrade:OnChanged(function()
	Notify("Auto Upgrade", tostring(Options.AutoUpgrade.Value))
	task.spawn(function()
		while Options.AutoUpgrade.Value do
			Upgrade()
			task.wait(tonumber(Options.AutoUpgradeInterval.Value) or 30)
		end
	end)
end)

Tabs.Upgrades:AddInput("AutoUpgradeInterval", {
	Title = "Auto Upgrade Interval",
	Default = "30",
	Placeholder = "10",
	Numeric = true,
	Finished = false,
	Callback = function() end
})

local AutoBuyZone = Tabs.Upgrades:AddToggle("AutoBuyZone", { Title = "Auto Buy Zone", Default = false })
AutoBuyZone:OnChanged(function()
	Notify("Auto Buy Zone", tostring(Options.AutoBuyZone.Value))
	task.spawn(function()
		while Options.AutoBuyZone.Value do
			callRemote("ZonesService", "requestPurchaseZone")
			task.wait(5)
		end
	end)
end)

local AutoRebirth = Tabs.Upgrades:AddToggle("AutoRebirth", { Title = "Auto Rebirth", Default = false })
AutoRebirth:OnChanged(function()
	Notify("Auto Rebirth", tostring(Options.AutoRebirth.Value))
	task.spawn(function()
		while Options.AutoRebirth.Value do
			Notify("Rebirth", "Rebirthing...")
			callRemote("RebirthService", "requestRebirth")
			task.wait(5)
		end
	end)
end)

local AutoEquipBest = Tabs.Upgrades:AddToggle("AutoEquipBest", { Title = "Auto Equip Best", Default = false })
AutoEquipBest:OnChanged(function()
	Notify("Auto Equip Best", tostring(Options.AutoEquipBest.Value))
	task.spawn(function()
		while Options.AutoEquipBest.Value do
			callRemote("InventoryService", "requestEquipBest")
			task.wait(10)
			Notify("Equipped Best", "Equipped best pets.")
		end
	end)
end)

-- Webhooks Tab
Tabs.Webhooks:AddInput("WebhookUrl", {
	Title = "Webhook URL",
	Default = "",
	Placeholder = "https://discord.com/api/webhooks/...",
	Numeric = false,
	Finished = false,
	Callback = function() end
})

local webhookConnection
local Webhook = Tabs.Webhooks:AddToggle("Webhook", { Title = "Webhook", Default = false })
Webhook:OnChanged(function()
	Notify("Webhook", tostring(Options.Webhook.Value))
	if webhookConnection then webhookConnection:Disconnect() end
	if not Options.Webhook.Value then return end

	webhookConnection = task.spawn(function()
		while Options.Webhook.Value do
			local url = Options.WebhookUrl.Value
			if isValidWebhook(url) and clientHRP then
				local titleGui = safeFind(client, "Head", "TitleGui") or safeFind(clientHRP, "TitleGui")
				local numRolls = titleGui and titleGui:FindFirstChild("NumRolls") and titleGui.NumRolls.Text or "N/A"
				SendDiscordWebhook(url, {
					title = localPlayer.Name,
					description = numRolls
				})
			end
			task.wait(tonumber(Options.WebhookInterval.Value) or 30)
		end
	end)
end)

Tabs.Webhooks:AddInput("WebhookInterval", {
	Title = "Webhook Interval",
	Default = "30",
	Placeholder = "10",
	Numeric = true,
	Finished = false,
	Callback = function() end
})

-- ==================== SAVE ====================

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("Plink")
SaveManager:SetFolder("Plink/SRNG")

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({ Title = "Fluent", Content = "Script loaded successfully.", Duration = 8 })
SaveManager:LoadAutoloadConfig()
