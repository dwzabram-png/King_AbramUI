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

-- [FIXED] Более надежное обновление персонажа
local function updateCharacter()
	client = localPlayer.Character or localPlayer.CharacterAdded:Wait()
	clientHRP = client:WaitForChild("HumanoidRootPart", 10)
	if not clientHRP then
		task.wait(1)
		return updateCharacter()
	end
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
	AutoKill = false,
	AutoUpgrade = false,
	AutoBuyZone = false,
	AutoRebirth = false,
	AutoEquipBest = false,
	AutoFeed = false,
	Webhook = false
}
local Config = {
	AutoBestZoneInterval = 15,
	AutoUpgradeInterval = 30,
	AutoFeedInterval = 5,
	WebhookUrl = "",
	WebhookInterval = 30
}

-- Динамический поиск Remotes (проверяет ВСЕ версии networker)
local function getAllRemotesFolders()
	local result = {}
	local packages = ReplicatedStorage:FindFirstChild("Packages")
	if not packages then return result end
	local index = packages:FindFirstChild("_Index")
	if not index then return result end
	for _, child in ipairs(index:GetChildren()) do
		if child.Name:find("networker") then
			local networker = child:FindFirstChild("networker")
			if networker then
				local remotes = networker:FindFirstChild("_remotes")
				if remotes then
					table.insert(result, remotes)
				end
			end
		end
	end
	return result
end

local function findRemoteService(serviceName)
	local folders = getAllRemotesFolders()
	for _, folder in ipairs(folders) do
		local remote = folder:FindFirstChild(serviceName)
		if remote then return remote end
	end
	return nil
end

local function callRemote(service, method, ...)
	local remote = findRemoteService(service)
	if not remote then return false, "Service not found" end
	local func = remote:FindFirstChild("RemoteFunction")
	if not func then return false, "RemoteFunction not found" end
	
	local ok, result = pcall(function(...)
		return func:InvokeServer(...)
	end, method, ...)
	return ok, result
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

-- Teleport
local function Teleport(worldNum)
	callRemote("ZonesService", "requestTeleportZone", worldNum)
end

-- [FIXED BEST ZONE]
local function TeleportBestZone()
	local zonesFolder = workspace:FindFirstChild("Zones")
	if not zonesFolder then return end
	local best = 1
	
	local sortedZones = zonesFolder:GetChildren()
	table.sort(sortedZones, function(a, b)
		local numA = tonumber(a.Name:match("%d+")) or 0
		local numB = tonumber(b.Name:match("%d+")) or 0
		return numA < numB
	end)

	for _, zone in ipairs(sortedZones) do
		local zoneNum = tonumber(zone.Name:match("%d+"))
		if not zoneNum then continue end
		
		local gate = zone:FindFirstChild("Gate")
		local isOpened = false
		
		if gate then
			local blocker = gate:FindFirstChild("ClientGateBlocker_" .. zone.Name) or gate:FindFirstChild("GateBlocker")
			if blocker then
				isOpened = not blocker.CanCollide
			else
				local hasCollider = false
				for _, child in ipairs(gate:GetDescendants()) do
					if child:IsA("BasePart") and child.CanCollide == true then
						hasCollider = true
						break
					end
				end
				isOpened = not hasCollider
			end
		else
			isOpened = true
		end

		if isOpened then
			best = zoneNum
		else
			-- [PLUS ONE LOGIC] Пробуем прыгнуть в следующую (закрытую) зону
			best = zoneNum
			break
		end
	end
	
	if best > 0 then
		Teleport(best)
	end
end

-- Helpers
local function getGameplayFolder()
	for _, child in ipairs(workspace:GetChildren()) do
		if child.Name:match("^Gameplay%d+$") then
			return child
		end
	end
	return nil
end

local function toggleNoclip(value)
	if value then
		if _G.NoclipConn then _G.NoclipConn:Disconnect() end
		_G.NoclipConn = RunService.Stepped:Connect(function()
			if not client then return end
			for _, part in ipairs(client:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end)
	else
		if _G.NoclipConn then
			_G.NoclipConn:Disconnect()
			_G.NoclipConn = nil
		end
	end
end

local function Kill()
	if not clientHRP or not State.AutoKill then return end
	local gameplay = getGameplayFolder()
	local enemies = gameplay and gameplay:FindFirstChild("Enemies")
	if not enemies then return end
	
	local target = nil
	local minDist = math.huge
	
	for _, enemy in ipairs(enemies:GetChildren()) do
		local hrp = enemy:FindFirstChild("RootPart") or enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("PrimaryPart")
		if hrp then
			local dist = (clientHRP.Position - hrp.Position).Magnitude
			if dist < minDist then
				minDist = dist
				target = hrp
			end
		end
	end
	
	if target then
		local targetPos = target.CFrame * CFrame.new(0, 0, 3)
		clientHRP.CFrame = clientHRP.CFrame:Lerp(targetPos, 0.15)
		clientHRP.AssemblyLinearVelocity = Vector3.new(0,0,0)
	end
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
	return success
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

-- [UPGRADE SYSTEM] Точные ID всех апгрейдов
-- Генерирует список ID: name..from, name..(from+1), ..., name..to
local function range(name, from, to)
	local t = {}
	for i = from, to do table.insert(t, name .. i) end
	return t
end

-- Все апгрейды (точные ID из игры)
local ALL_UPGRADES = {}
local function add(list) for _, v in ipairs(list) do table.insert(ALL_UPGRADES, v) end end

-- === MAIN ===
add(range("luck", 1, 15))
add(range("rollSpeed", 1, 6))
add(range("goopDropRate", 1, 6))
add(range("cloverRolls", 1, 5))
add(range("bonusRolls", 1, 3))
add(range("extraRollColumn", 1, 3))
add(range("enemyCount", 2, 7))
add(range("slots", 2, 6))
add(range("slimeTargetRange", 1, 3))
add(range("friendLuck", 1, 6))
add(range("friendBoost", 1, 4))
add(range("friendLuckBoost", 1, 4))
-- Прокрутки (первый без цифры, остальные с 2)
add({"goldenRolls", "goldenRolls2", "goldenRolls3", "goldenRolls4"})
add({"diamondRolls", "diamondRolls2", "diamondRolls3", "diamondRolls4"})
add({"voidRolls", "voidRolls2", "voidRolls3", "voidRolls4"})
-- Мутации слаймов
add({"bigSlimes", "hugeSlimes", "shinySlimes", "invertedSlimes"})
-- Мутации врагов
add({"bigEnemies", "hugeEnemies", "shinyEnemies", "invertedEnemies"})
add({"bigEnemyChance1", "shinyEnemyChance1", "hugeEnemyChance1", "invertedEnemyChance1"})

-- === LOOT ===
add(range("coinIncome", 1, 13))
add(range("overkill", 1, 6))
add(range("offlineLootAmount", 1, 5))
add(range("enemySpawnSpeed", 1, 3))
-- Предметы
add({"lootApple", "lootCarrot", "lootCherries", "lootGrapes", "lootBanana",
	"lootWatermelon", "lootPizza", "lootChicken", "lootDrumstick"})
-- Бусты
add({"lootLuck", "lootCurrency", "lootRollSpeed", "lootUltraLuck"})

-- === PLAYER ===
add(range("walkSpeed", 1, 3))
add(range("magnet", 1, 3))
add({"teleporter"})

local function Upgrade()
	for _, id in ipairs(ALL_UPGRADES) do
		callRemote("UpgradeService", "requestUnlock", id)
		task.wait(0.05)
	end
end

-- [AUTO FEED] Кормит слаймов фруктами поровну
local FOOD_TYPES = {"apple", "grapes", "banana", "pizza", "drumstick", "chicken", "watermelon", "cherries", "carrot"}

-- Получение UUID экипированных слаймов через DataService
local function getEquippedSlimeUUIDs()
	-- DataService хранит equipped как массив UUID (индексы 1-8)
	-- Источник: ReplicatedStorage.Source.Features.Inventory.UI.Components.EquippedSlimesFrame
	-- getDataSource("equipped") -> массив uniqueId для каждого слота

	-- Метод 1: require DataService напрямую
	local ok1, uuids1 = pcall(function()
		local DataService = require(ReplicatedStorage.Packages.DataService)
		local c = DataService.client
		local equipped = c:get({"equipped"})
		if not equipped or type(equipped) ~= "table" then return nil end
		local result = {}
		for i = 1, 8 do
			local val = equipped[i]
			if val and type(val) == "string" and val ~= "" then
				table.insert(result, val)
			end
		end
		return result
	end)
	if ok1 and uuids1 and #uuids1 > 0 then
		return uuids1
	end

	-- Метод 2: getDataSource("equipped") из Vide-обёртки
	local ok2, uuids2 = pcall(function()
		local getDataSource = require(ReplicatedStorage.Source.Core.UI.Sources.getDataSource)
		local equippedSource = getDataSource("equipped")
		local equipped = equippedSource()
		if not equipped or type(equipped) ~= "table" then return nil end
		local result = {}
		for i = 1, 8 do
			local val = equipped[i]
			if val and type(val) == "string" and val ~= "" then
				table.insert(result, val)
			end
		end
		return result
	end)
	if ok2 and uuids2 and #uuids2 > 0 then
		return uuids2
	end

	-- Метод 3: getValue вместо get (альтернативный API)
	local ok3, uuids3 = pcall(function()
		local DataService = require(ReplicatedStorage.Packages.DataService)
		local c = DataService.client
		local equipped = c:getValue({"equipped"})
		if not equipped or type(equipped) ~= "table" then return nil end
		local result = {}
		for i = 1, 8 do
			local val = equipped[i]
			if val and type(val) == "string" and val ~= "" then
				table.insert(result, val)
			end
		end
		return result
	end)
	if ok3 and uuids3 and #uuids3 > 0 then
		return uuids3
	end

	return {}
end

-- Получение количества еды через DataService (loot)
local function getLootCounts()
	local ok, loot = pcall(function()
		local DataService = require(ReplicatedStorage.Packages.DataService)
		local c = DataService.client
		local data = c:get({"loot"})
		if not data then
			data = c:get({"items"})
		end
		return data
	end)
	if ok and loot and type(loot) == "table" then
		return loot
	end
	return nil
end

local function FeedSlimes()
	task.defer(function()
		-- 1. Получаем UUID экипированных слаймов
		local equippedUUIDs = getEquippedSlimeUUIDs()
		if #equippedUUIDs == 0 then
			Notify("Feed", "No equipped slimes found")
			return
		end
		-- 2. Пробуем получить количество еды из DataService
		local loot = getLootCounts()

		-- 3. Раздаём еду
		local fedCount = 0
		for _, foodName in ipairs(FOOD_TYPES) do
			local totalFood = 0

			-- Из DataService
			if loot then
				totalFood = tonumber(loot[foodName]) or 0
			end

			-- Фоллбэк: из UI
			if totalFood <= 0 then
				pcall(function()
					local consumablesList = localPlayer.PlayerGui.Root.Inventory.PageItemsContent
						.ItemsInventoryPage.DefaultItemsView.ConsumablesPanel.ConsumablesList
					local itemButton = consumablesList:FindFirstChild(foodName .. "ItemButton")
					if itemButton then
						local amountObj = itemButton:FindFirstChild("Amount")
						if amountObj then
							local amountText = ""
							if amountObj:IsA("TextLabel") then
								amountText = amountObj.Text
							else
								local label = amountObj:FindFirstChildWhichIsA("TextLabel")
								if label then amountText = label.Text end
							end
							amountText = amountText:gsub("[^%d]", "")
							totalFood = tonumber(amountText) or 0
						end
					end
				end)
			end

			if totalFood > 0 then
				local perSlime = math.max(1, math.floor(totalFood / #equippedUUIDs))
				for _, slimeUUID in ipairs(equippedUUIDs) do
					local ok, res = callRemote("InventoryService", "requestUseFood", foodName, slimeUUID, perSlime)
					if ok then
						fedCount = fedCount + 1
					end
					task.wait(0.05)
				end
			end
		end

		if fedCount > 0 then
			Notify("Feed", "Fed " .. fedCount .. " food items")
		end
	end)
end

-- [FIXED ROLL]
local function Roll()
	callRemote("RollService", "requestRoll")
end

local function getRollCooldown()
	local statsList = safeFind(localPlayer, "PlayerGui", "Root", "BottomBarStats", "StatsList")
	local rollSpeedStat = statsList and (statsList:FindFirstChild("RollSpeedStat") or statsList:FindFirstChild("RollSpeed"))
	local label = rollSpeedStat and safeFind(rollSpeedStat, "Content", "Value", "TextLabel")
	
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
	AutoKill = {
		kind = "rbx_connection",
		getSignal = function() return RunService.Heartbeat end,
		callback = function() Kill() end
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
	AutoFeed = {
		kind = "task_loop",
		getInterval = function() return Config.AutoFeedInterval end,
		action = function() FeedSlimes() end
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
	
	if name == "AutoKill" then toggleNoclip(false) end
end

local function startFeature(name)
	stopFeature(name)
	local cfg = FEATURES[name]
	if not cfg then return end

	if name == "AutoKill" then toggleNoclip(true) end

	if cfg.kind == "task_loop" then
		local thread = task.spawn(function()
			while State[name] do
				local ok, err = pcall(cfg.action)
				if not ok then
					Notify("Loop Error", name .. ": " .. tostring(err))
					task.wait(2)
				end
				if not State[name] then break end
				task.wait(cfg.getInterval())
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
	for _, v in ipairs(CoreGui:GetChildren()) do
		if v:IsA("ScreenGui") and (v.Name == "AbramSliemGui" or v.Name:match("^AS_")) then
			v:Destroy()
		end
	end
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
screenGui.Name = "AS_" .. HttpService:GenerateGUID(false):sub(1,8)
screenGui.ResetOnSpawn = false
screenGui.Parent = gethui and gethui() or CoreGui

-- Определение платформы и адаптивный размер
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local camera = workspace.CurrentCamera
local screenSize = camera and camera.ViewportSize or Vector2.new(1920, 1080)

local BASE_W, BASE_H = 360, 480
if isMobile then
	local sw, sh = screenSize.X, screenSize.Y
	local maxW = math.floor(sw * 0.88)
	local maxH = math.floor(sh * 0.52)
	BASE_W = math.min(BASE_W, maxW)
	BASE_H = math.min(BASE_H, maxH)
end

local main = Instance.new("Frame")
main.Size = UDim2.new(0, BASE_W, 0, BASE_H)
main.Position = UDim2.new(0.5, -BASE_W/2, 0.5, -BASE_H/2)
main.BackgroundColor3 = C.BG
main.BorderSizePixel = 0
main.ClipsDescendants = false
main.Active = true
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
kbdChip.Visible = not isMobile
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
pill.Active = true
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
createToggle(pageUpgrades, "MEGA Auto Upgrade", "AutoUpgrade")
createToggle(pageUpgrades, "Auto Buy Zone",   "AutoBuyZone")
createToggle(pageUpgrades, "Auto Rebirth",    "AutoRebirth")
createToggle(pageUpgrades, "Auto Equip Best", "AutoEquipBest")
createToggle(pageUpgrades, "Auto Feed Slimes", "AutoFeed")
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
_G.RefreshFooterUI()

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
local DRAG_THRESHOLD = 15

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
		tw(main, { Size = UDim2.new(0, BASE_W - 20, 0, BASE_H - 20) }, TW_FAST)
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
		main.Size = UDim2.new(0, BASE_W - 20, 0, BASE_H - 20)
		tw(main, { Size = UDim2.new(0, BASE_W, 0, BASE_H) }, TW_POP)
	end
end

pill.MouseButton1Click:Connect(function()
	if not pMoved then toggleMenu() end
end)

-- ALT toggle (ПК)
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
		toggleMenu()
	end
end)

-- Мобильная кнопка toggle (вместо ALT)
if isMobile then
	local mobileBtn = Instance.new("TextButton")
	mobileBtn.Size = UDim2.new(0, 44, 0, 44)
	mobileBtn.Position = UDim2.new(1, -54, 0, 10)
	mobileBtn.BackgroundColor3 = C.Accent
	mobileBtn.AutoButtonColor = false
	mobileBtn.Text = ""
	mobileBtn.Active = true
	mobileBtn.ZIndex = 10
	mobileBtn.Parent = screenGui
	addCorner(mobileBtn, 22)
	addStroke(mobileBtn, C.BorderHi, 1)

	local mobileBtnIcon = Instance.new("TextLabel")
	mobileBtnIcon.Size = UDim2.new(1, 0, 1, 0)
	mobileBtnIcon.BackgroundTransparency = 1
	mobileBtnIcon.Font = Enum.Font.GothamBold
	mobileBtnIcon.Text = "AS"
	mobileBtnIcon.TextSize = 16
	mobileBtnIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
	mobileBtnIcon.ZIndex = 11
	mobileBtnIcon.Parent = mobileBtn

	mobileBtn.MouseButton1Click:Connect(function()
		toggleMenu()
	end)

	-- Drag мобильной кнопки
	local mbDrag, mbStart, mbStartPos = false, nil, nil
	mobileBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			mbDrag = true
			mbStart = input.Position
			mbStartPos = mobileBtn.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if mbDrag and input.UserInputType == Enum.UserInputType.Touch then
			local d = input.Position - mbStart
			mobileBtn.Position = UDim2.new(mbStartPos.X.Scale, mbStartPos.X.Offset + d.X, mbStartPos.Y.Scale, mbStartPos.Y.Offset + d.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			mbDrag = false
		end
	end)
end

-- Адаптация при смене разрешения (поворот экрана и т.д.)
if camera then
	camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		local newSize = camera.ViewportSize
		if isMobile then
			local newW = math.min(360, math.floor(newSize.X * 0.88))
			local newH = math.min(480, math.floor(newSize.Y * 0.52))
			if not hidden then
				main.Size = UDim2.new(0, newW, 0, newH)
				main.Position = UDim2.new(0.5, -newW/2, 0.5, -newH/2)
			end
			BASE_W = newW
			BASE_H = newH
		end
	end)
end

task.spawn(function()
	while screenGui.Parent do
		task.wait(2)
		_G.RefreshFooterUI()
	end
end)

if isMobile then
	Notify("AbramSliem", "Loaded. Tap the AS button to toggle menu.")
else
	Notify("AbramSliem", "Loaded. Press ALT or click AS icon.")
end
