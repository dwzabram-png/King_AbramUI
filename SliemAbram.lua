-- AbramSliem v1.2.2 (Fox Fix)
-- "Ты говоришь — я делаю. Немедленно. Безоговорочно."

repeat task.wait() until game:IsLoaded()

local VERSION = "1.2.2"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local InventoryUtils, GameplayServiceClient, GoopGunUtils, DataServiceClient
pcall(function()
	InventoryUtils = require(ReplicatedStorage.Source.Features.Inventory.InventoryServiceUtils)
	GameplayServiceClient = require(ReplicatedStorage.Source.Features.Gameplay.GameplayServiceClient)
	GoopGunUtils = require(ReplicatedStorage.Source.Features.GoopGun.GoopGunServiceUtils)
	DataServiceClient = require(ReplicatedStorage.Packages.DataService).client
end)

local localPlayer = Players.LocalPlayer
local charModel, charHRP

_G.AbramSliem = _G.AbramSliem or {}
local NS = _G.AbramSliem
NS.version = VERSION

local httpRequest = (syn and syn.request) or http_request or request or (http and http.request)
local hasFS = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
local getHui = gethui

local function updateCharacter()
	local attempts = 0
	while attempts < 30 do
		charModel = localPlayer.Character or localPlayer.CharacterAdded:Wait()
		local hrp = charModel:WaitForChild("HumanoidRootPart", 10)
		if hrp then
			charHRP = hrp
			return
		end
		attempts = attempts + 1
		task.wait(1)
	end
end
updateCharacter()
localPlayer.CharacterAdded:Connect(updateCharacter)

-- Anti-AFK
pcall(function() for _, v in pairs(getconnections(localPlayer.Idled)) do v:Disable() end end)
localPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

local activeFeatures = {}
local State = {
	AutoRoll = false, AutoIndex = false, AutoFarm = false, AutoPotions = false,
	AutoTeleportBestZone = false, AutoKill = false, AutoUpgrade = false,
	AutoBuyZone = false, AutoRebirth = false, AutoEquipBest = false,
	AutoFeed = false, AutoGun = false, Webhook = false,
}

local DEFAULT_CONFIG = {
	AutoBestZoneInterval = 15, AutoUpgradeInterval = 30, AutoFeedInterval = 5,
	WebhookUrl = "", WebhookInterval = 30, FeedReserve = 0, AntiDetectJitter = true,
}
local Config = table.clone(DEFAULT_CONFIG)

-- Config persistence
local CONFIG_FILE = "AbramSliem_config.json"
local function saveConfig() if hasFS then writefile(CONFIG_FILE, HttpService:JSONEncode(Config)) end end
local function loadConfig()
	if hasFS and isfile(CONFIG_FILE) then
		pcall(function()
			local decoded = HttpService:JSONDecode(readfile(CONFIG_FILE))
			for k, v in pairs(decoded) do if Config[k] ~= nil then Config[k] = v end end
		end)
	end
end
loadConfig()

-- Remotes
local remoteCache = {}
local function findRemoteService(serviceName)
	if remoteCache[serviceName] and remoteCache[serviceName].Parent then return remoteCache[serviceName] end
	local packages = ReplicatedStorage:FindFirstChild("Packages")
	local index = packages and packages:FindFirstChild("_Index")
	if not index then return nil end
	for _, child in ipairs(index:GetChildren()) do
		if child.Name:find("networker") then
			local remotes = child:FindFirstChild("networker") and child.networker:FindFirstChild("_remotes")
			local found = remotes and remotes:FindFirstChild(serviceName)
			if found then remoteCache[serviceName] = found return found end
		end
	end
	return nil
end

local function callRemote(service, method, ...)
	local remote = findRemoteService(service)
	local rf = remote and remote:FindFirstChild("RemoteFunction")
	if not rf then return false, "Remote not found" end
	return pcall(function(...) return rf:InvokeServer(...) end, method, ...)
end

local function Notify(title, content)
	pcall(function() game:GetService("StarterGui"):SetCore("SendNotification", {Title = tostring(title), Text = tostring(content), Duration = 4}) end)
end

-- Helpers
local function getGameplayFolder()
	for _, child in ipairs(workspace:GetChildren()) do if child.Name:match("^Gameplay%d+$") then return child end end
	return nil
end

-- [FEED & INVENTORY LOGIC]
local FOOD_TYPES = {"apple", "grapes", "banana", "pizza", "drumstick", "chicken", "watermelon", "cherries", "carrot"}

local function getEquippedSlimeUUIDs()
	if not DataServiceClient then return {} end
	local ok, uuids = pcall(function() return DataServiceClient:get("equipped") end)
	local result = {}
	if ok and type(uuids) == "table" then
		for i = 1, 8 do if uuids[i] and uuids[i] ~= "" then table.insert(result, uuids[i]) end end
	end
	return result
end

local function getLootCounts()
	if not DataServiceClient then return {} end
	local ok, data = pcall(function() return DataServiceClient:get() end)
	if ok and type(data) == "table" then
		return data.items or data.loot or data
	end
	return {}
end

local function getEquippedSlimesSorted()
	local equippedUUIDs = getEquippedSlimeUUIDs()
	local inventory = DataServiceClient and DataServiceClient:get("inventory") or {}
	local sortedList = {}
	for _, guid in ipairs(equippedUUIDs) do
		local rawData = inventory[guid]
		if rawData and InventoryUtils then
			local slimeData = InventoryUtils.getSlimeData(guid, rawData)
			local stats = InventoryUtils.getSlimeStatsFromData(slimeData)
			table.insert(sortedList, {guid = guid, damage = stats.damage or 0, level = slimeData.level or 1, id = slimeData.id})
		end
	end
	table.sort(sortedList, function(a, b) return a.damage > b.damage end)
	return sortedList
end

local function FeedSlimes()
	task.defer(function()
		if not DataServiceClient or not InventoryUtils then return end
		local sorted = getEquippedSlimesSorted()
		if #sorted == 0 then return end

		-- Уравнитель: ищем самый низкий уровень
		local target = sorted[1]
		local minLvl = math.huge
		for _, s in ipairs(sorted) do
			if s.level < minLvl then minLvl = s.level target = s end
		end

		local loot = getLootCounts()
		local fedCount = 0
		for _, foodName in ipairs(FOOD_TYPES) do
			-- Пытаемся найти количество (apple или lootApple)
			local key2 = "loot" .. foodName:sub(1,1):upper() .. foodName:sub(2)
			local total = tonumber(loot[foodName]) or tonumber(loot[key2]) or 0
			local reserve = math.max(0, tonumber(Config.FeedReserve) or 0)
			local available = total - reserve

			if available > 0 then
				local ok, _ = callRemote("InventoryService", "requestUseFood", foodName, target.guid, available)
				if ok then 
					fedCount = fedCount + available
					print(string.format("[FOX FEED] Скормил %d %s пету %s (%d лвл)", available, foodName, target.id, target.level))
				end
				task.wait(0.1)
			end
		end
		if fedCount > 0 then Notify("Feed", "Fed " .. fedCount .. " items to " .. target.id) end
	end)
end

local function EquipBestManual()
	local inventory = DataServiceClient and DataServiceClient:get("inventory") or {}
	local upgrades = DataServiceClient and DataServiceClient:get("upgrades") or {}
	local maxSlots = InventoryUtils and InventoryUtils.getOwnedSlotCount(upgrades, 0) or 8
	local bestUUIDs = InventoryUtils and InventoryUtils.getBestEquippedUniqueIds(inventory, maxSlots)
	if not bestUUIDs then return end
	for _, guid in ipairs(bestUUIDs) do callRemote("InventoryService", "equipSlime", guid) task.wait(0.05) end
	Notify("AutoEquip", "Equipped top " .. #bestUUIDs .. " slimes by real DPS!")
end

-- [AUTOMATION ACTIONS]
local function Roll() callRemote("RollService", "requestRoll") end

local function AutoGun()
	local remote = findRemoteService("SlimeGunService")
	local rf = remote and remote:FindFirstChild("RemoteFunction")
	if not rf or not DataServiceClient then return end
	local upgrades = DataServiceClient:get("upgrades") or {}
	local range = GoopGunUtils and GoopGunUtils.getRange(upgrades) or 100
	local targetId = nil
	local gameplay = GameplayServiceClient and GameplayServiceClient.gameplay
	if gameplay and gameplay.enemies and charHRP then
		local minDist = range
		for id, enemy in pairs(gameplay.enemies) do
			if enemy.model and not enemy.dead then
				local dist = (enemy.pos - charHRP.Position).Magnitude
				if dist < minDist then minDist = dist targetId = id end
			end
		end
	end
	if targetId then pcall(function() rf:InvokeServer("tryFireSlimeGun", targetId) end) end
end

local function TeleportBestZone()
	local zones = workspace:FindFirstChild("Zones")
	if not zones then return end
	local target = 1
	local children = zones:GetChildren()
	table.sort(children, function(a, b) return (tonumber(a.Name:match("%d+")) or 0) < (tonumber(b.Name:match("%d+")) or 0) end)
	for _, zone in ipairs(children) do
		local num = tonumber(zone.Name:match("%d+"))
		if not num then continue end
		target = num
		local gate = zone:FindFirstChild("Gate")
		if gate then
			local blocker = gate:FindFirstChild("ClientGateBlocker_" .. zone.Name) or gate:FindFirstChild("GateBlocker")
			if blocker and blocker.CanCollide then break end
		end
	end
	callRemote("ZonesService", "requestTeleportZone", target)
end

local function Kill()
	if not charHRP or not State.AutoKill then return end
	local enemies = getGameplayFolder() and getGameplayFolder():FindFirstChild("Enemies")
	if not enemies then return end
	local target, minDist = nil, math.huge
	for _, enemy in ipairs(enemies:GetChildren()) do
		local hrp = enemy:FindFirstChild("RootPart") or enemy:FindFirstChild("HumanoidRootPart")
		if hrp then
			local d = (charHRP.Position - hrp.Position).Magnitude
			if d < minDist then minDist = d target = hrp end
		end
	end
	if target then
		local jitter = Config.AntiDetectJitter and Vector3.new((math.random()-0.5)*0.5, 0, (math.random()-0.5)*0.5) or Vector3.new(0,0,0)
		charHRP.CFrame = charHRP.CFrame:Lerp(target.CFrame * CFrame.new(0, 0, 3) + jitter, 0.15)
		charHRP.AssemblyLinearVelocity = Vector3.new(0,0,0)
	end
end

-- [FEATURE LOOPS]
local FEATURES = {
	AutoRoll = {kind = "task_loop", getInterval = function() return 0.5 end, action = Roll},
	AutoIndex = {kind = "task_loop", getInterval = function() return 30 end, action = function() for _, r in ipairs({"basic","big","huge","shiny","inverted"}) do callRemote("IndexService", "requestClaimReward", r) end end},
	AutoFarm = {kind = "rbx_connection", getSignal = function() return RunService.Heartbeat end, callback = function()
		if not State.AutoFarm or not charHRP then return end
		local loot = workspace:FindFirstChild("Loot")
		if not loot then return end
		for _, drop in ipairs(loot:GetChildren()) do
			for _, c in ipairs(drop:GetChildren()) do
				if c:IsA("BasePart") and c.Name ~= "LootHighlight" then c.CFrame = charHRP.CFrame end
			end
		end
	end},
	AutoPotions = {kind = "task_loop", getInterval = function() return 5 end, action = function() for _, p in ipairs({"luck","ultraLuck","currency","rollSpeed"}) do callRemote("BoostService", "requestUseBoost", p) end end},
	AutoTeleportBestZone = {kind = "task_loop", getInterval = function() return Config.AutoBestZoneInterval end, action = TeleportBestZone},
	AutoKill = {kind = "rbx_connection", getSignal = function() return RunService.Heartbeat end, callback = Kill},
	AutoUpgrade = {kind = "task_loop", getInterval = function() return Config.AutoUpgradeInterval end, action = function()
		-- Тут твоя пачка апгрейдов из скрипта...
	end},
	AutoBuyZone = {kind = "task_loop", getInterval = function() return 5 end, action = function() callRemote("ZonesService", "requestPurchaseZone") end},
	AutoRebirth = {kind = "task_loop", getInterval = function() return 5 end, action = function() callRemote("RebirthService", "requestRebirth") end},
	AutoEquipBest = {kind = "task_loop", getInterval = function() return 10 end, action = EquipBestManual},
	AutoFeed = {kind = "task_loop", getInterval = function() return Config.AutoFeedInterval end, action = FeedSlimes},
	AutoGun = {kind = "task_loop", getInterval = function() return (GoopGunUtils and DataServiceClient and GoopGunUtils.getFireRate(DataServiceClient:get("upgrades") or {})) or 0.1 end, action = AutoGun},
}

-- [THE REST OF UI AND LOGIC IS OMITTED FOR BREVITY, BUT KEEP YOUR EXISTING UI CODE]
-- ... (тут твой код меню и драга из sliem.txt) ...

Notify("AbramSliem", "v1.2.2 Fox Fix Loaded. Ня! :3")
