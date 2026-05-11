-- KingLegacy.lua — King AbramUI
-- Auto Dungeon for King Legacy (Roblox), Third Sea · Hard · "Crustacean Cataclysm".
-- Безопасная и модульная логика: телепорт → выбор данжа → отслеживание этажей,
-- лифт со связкой CFrame → проверка зоны Ope Ope → авто-атака Kioru V2 M1
-- с приоритетом по боссам и фокусом на кость DEF-spine.001.
-- Все вызовы InvokeServer обёрнуты в pcall, обработаны смерть/респаун/деспавн моба,
-- катсцена Chaos Crab не сбивает атаку.

repeat task.wait() until game:IsLoaded()

local VERSION = "1.0.0"

local Players          = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local HttpService      = game:GetService("HttpService")
local VirtualUser      = game:GetService("VirtualUser")
local Workspace        = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer

-- ==================== EXECUTOR CAPABILITIES ====================
local hasFS = type(writefile) == "function"
          and type(readfile)  == "function"
          and type(isfile)    == "function"
local getHui = gethui

-- Единый неймспейс
_G.AbramKing = _G.AbramKing or {}
local NS = _G.AbramKing
NS.version = VERSION

-- Если предыдущий запуск ещё жив — корректно потушим
if NS.cleanup then
    pcall(NS.cleanup)
end

-- ==================== CHARACTER TRACKING ====================
local client, clientHRP, clientHum

local function updateCharacter()
    local attempts = 0
    while attempts < 30 do
        client = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local hrp = client:WaitForChild("HumanoidRootPart", 10)
        local hum = client:WaitForChild("Humanoid", 5)
        if hrp and hum then
            clientHRP = hrp
            clientHum = hum
            return
        end
        attempts = attempts + 1
        task.wait(1)
    end
end
updateCharacter()
local charAddedConn = localPlayer.CharacterAdded:Connect(updateCharacter)

-- Anti-AFK
local idledConn = localPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

local function isAlive()
    return client and clientHRP and clientHRP.Parent
       and clientHum and clientHum.Health > 0
end

-- ==================== CONFIG ====================
local DEFAULT_CONFIG = {
    -- Логика данжа
    DungeonDifficulty   = "Hard",                  -- Easy / Normal / Hard
    StartX              = 10959.46,
    StartY              = 141.89,
    StartZ              = 1252.01,
    DungeonMapName      = "Crustacean Cataclysm",  -- название карты для Third Sea · Hard
    ElevatorDuration    = 7.5,                     -- секунд CFrame-lock в лифте
    AutoRestart         = true,                    -- после фейла/выхода запускать новый данж

    -- Авто-атака
    AttackInterval      = 0.1,                     -- сек между M1 (10 кликов/сек)
    TargetRescanInterval = 0.25,                   -- сек между пересканом целей
    AttackOnlyInDungeon = true,                    -- атаковать только когда мы в карте данжа

    -- Anti-AFK + защита
    AntiAFK             = true,
    PcallVerbose        = false,                   -- логировать pcall-ошибки в консоль
}
local Config = table.clone(DEFAULT_CONFIG)
local CONFIG_FILE = "AbramKing_config.json"

local function saveConfig()
    if not hasFS then return end
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(Config))
    end)
end

local function loadConfig()
    if not hasFS then return end
    pcall(function()
        if not isfile(CONFIG_FILE) then return end
        local raw = readfile(CONFIG_FILE)
        local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
        if ok and type(decoded) == "table" then
            for k, v in pairs(decoded) do
                if DEFAULT_CONFIG[k] ~= nil and type(v) == type(DEFAULT_CONFIG[k]) then
                    Config[k] = v
                end
            end
        end
    end)
end
loadConfig()

-- ==================== STATE ====================
local State = {
    AutoDungeon  = false,  -- мастер-цикл: телепорт → выбор → данж → рестарт
    AutoTeleport = false,  -- только телепорт к точке входа
    AutoSelect   = false,  -- только Invoke SelectDungeon
    AutoOpeRoom  = false,  -- ставит DF_OpOp_Z если зоны нет
    AutoAttack   = false,  -- M1 спам по приоритетной цели
    AutoElevator = false,  -- CFrame-lock к лифту во время поездки
}

local connections = {}  -- key -> RBXScriptConnection | thread

local function disconnect(key)
    local c = connections[key]
    if c then
        if type(c) == "thread" then
            pcall(task.cancel, c)
        else
            pcall(function() c:Disconnect() end)
        end
        connections[key] = nil
    end
end

local function safeCall(label, fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok and Config.PcallVerbose then
        warn(string.format("[AbramKing] %s -> %s", tostring(label), tostring(err)))
    end
    return ok
end

-- ==================== NOTIFICATIONS ====================
local function Notify(title, content)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title    = tostring(title),
            Text     = tostring(content),
            Duration = 4,
        })
    end)
end

-- ==================== REMOTE HELPERS ====================
-- Кешируем RemoteFunction, чтобы не лазить в дерево каждый вызов.
local cachedRemotes = {}

local function getRemote(path)
    if cachedRemotes[path] then return cachedRemotes[path] end
    local node = ReplicatedStorage
    for part in string.gmatch(path, "[^/]+") do
        if not node then return nil end
        node = node:FindFirstChild(part)
    end
    if node then
        cachedRemotes[path] = node
    end
    return node
end

local SELECT_DUNGEON_PATH = "Chest/Remotes/Functions/SelectDungeon"
local SKILL_ACTION_PATH   = "Chest/Remotes/Functions/SkillAction"

local function invokeSelectDungeon(difficulty)
    local rf = getRemote(SELECT_DUNGEON_PATH)
    if not rf then return false end
    return safeCall("SelectDungeon", function()
        rf:InvokeServer(difficulty)
    end)
end

local function invokeSkillAction(skillId, payload)
    local rf = getRemote(SKILL_ACTION_PATH)
    if not rf then return false end
    return safeCall("SkillAction " .. skillId, function()
        rf:InvokeServer(skillId, payload)
    end)
end

-- ==================== DUNGEON DISCOVERY ====================
local DUNGEON_MAPS = {
    Easy_First   = "Forgotten Prison",
    Easy_Second  = "Lavahold Prison",
    Easy_Third   = "The Warden’s Domain",
    Normal_Third = "Thunder Ruins",
    Hard_Third   = "Crustacean Cataclysm",
}

local function getDungeonMap()
    local name = Config.DungeonMapName or DUNGEON_MAPS.Hard_Third
    local island = Workspace:FindFirstChild("Island")
    if not island then return nil end
    local map = island:FindFirstChild("(Real) " .. name)
    return map
end

local function getElevatorPart()
    local map = getDungeonMap()
    if not map then return nil end
    local elev = map:FindFirstChild("Elevator")
    if elev then
        return elev.PrimaryPart or elev:FindFirstChildWhichIsA("BasePart", true)
    end
    return nil
end

local function getDungeonFloor()
    local ok, v = pcall(function() return ReplicatedStorage:GetAttribute("DungeonFloor") end)
    if ok then return v end
    return nil
end

local function getEnemiesCount()
    local pg = localPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local dgUI = pg:FindFirstChild("DungeonUI")
    if not dgUI then return nil end
    local node = dgUI
    for _, n in ipairs({"DungeonFrame", "Frame", "EnemiesFrame", "TextLabel"}) do
        node = node and node:FindFirstChild(n)
        if not node then return nil end
    end
    local txt = node and node.Text
    if not txt then return nil end
    -- В тексте обычно "5 / 5" или просто "5". Берём первое число.
    local n = tonumber(string.match(tostring(txt), "%d+"))
    return n
end

local function inDungeonMap()
    if not clientHRP then return false end
    local map = getDungeonMap()
    if not map then return false end
    local mapCF = nil
    local ok = pcall(function() mapCF = map:GetPivot() end)
    if not ok or not mapCF then return false end
    -- Карта генерируется в (20000, 15000, 20000). Считаем что мы "в данже",
    -- если до пивота карты < 5000 студов.
    local d = (clientHRP.Position - mapCF.Position).Magnitude
    return d < 5000
end

-- ==================== TARGET SELECTION ====================
local BOSS_NAMES = {
    ["Dark Warden"]  = true,
    ["Magma Warden"] = true,
    ["Veyzor [Lv. 10000]"]      = true,
    ["Chaos Crab [Lv. 10000]"]  = true,
}

local function isMobAlive(model)
    if not model or not model.Parent then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    if not model:FindFirstChild("HumanoidRootPart") then return false end
    return true
end

local function mobAttackCFrame(model)
    if not model then return nil end
    -- Приоритет — кость "DEF-spine.001" (валидируется ближе к центру моба).
    local spine = model:FindFirstChild("DEF-spine.001", true)
    if spine and spine:IsA("BasePart") then
        return spine.CFrame
    end
    local hrp = model:FindFirstChild("HumanoidRootPart")
    if hrp then return hrp.CFrame end
    return nil
end

local function isBossModel(model)
    if not model then return false end
    if model:GetAttribute("Boss") == true then return true end
    if BOSS_NAMES[model.Name] then return true end
    return false
end

-- Сканит папку карты, возвращает приоритетную живую цель.
-- Приоритет: босс → ближайший к игроку моб.
local function findTarget()
    local map = getDungeonMap()
    if not map or not clientHRP then return nil end
    local playerPos = clientHRP.Position

    local bestBoss, bestBossDist
    local bestMob,  bestMobDist
    for _, descendant in ipairs(map:GetDescendants()) do
        if descendant:IsA("Model") and descendant ~= client then
            if isMobAlive(descendant) then
                local hrp = descendant:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local d = (hrp.Position - playerPos).Magnitude
                    if isBossModel(descendant) then
                        if not bestBossDist or d < bestBossDist then
                            bestBoss, bestBossDist = descendant, d
                        end
                    else
                        if not bestMobDist or d < bestMobDist then
                            bestMob, bestMobDist = descendant, d
                        end
                    end
                end
            end
        end
    end
    return bestBoss or bestMob
end

-- ==================== OPE ROOM ====================
local function getOpeRoom()
    return Workspace:FindFirstChild("OpeRoom" .. localPlayer.Name)
end

local function spawnOpeRoom()
    if not clientHRP then return false end
    local cf = clientHRP.CFrame
    local downOk = invokeSkillAction("DF_OpOp_Z", {
        ["Type"]     = "Down",
        ["MouseHit"] = cf,
    })
    -- Лёгкая пауза между Down/Up, чтобы скилл сработал как human-input.
    task.wait(0.05)
    local upOk = invokeSkillAction("DF_OpOp_Z", {
        ["Type"]     = "Up",
        ["MouseHit"] = cf,
    })
    return downOk and upOk
end

-- ==================== ELEVATOR ====================
local elevatorThread
local elevatorBusy = false

local function rideElevator()
    if elevatorBusy then return end
    elevatorBusy = true
    elevatorThread = task.spawn(function()
        local elev = getElevatorPart()
        if not elev then
            elevatorBusy = false
            return
        end
        local startTime = os.clock()
        local duration  = math.max(0.5, Config.ElevatorDuration or 7.5)
        -- Связываем игрока с лифтом, чтобы не вылететь в Void.
        while os.clock() - startTime < duration do
            if not State.AutoElevator then break end
            if not isAlive() then break end
            if not elev or not elev.Parent then break end
            pcall(function()
                clientHRP.CFrame = elev.CFrame + Vector3.new(0, 3, 0)
                -- Глушим velocity, чтобы инерция не сносила.
                clientHRP.AssemblyLinearVelocity  = Vector3.new()
                clientHRP.AssemblyAngularVelocity = Vector3.new()
            end)
            task.wait()
        end
        elevatorBusy = false
    end)
end

-- ==================== AUTO ATTACK ====================
local function performM1(targetCF)
    return invokeSkillAction("SW_Kioru V2_M1", {
        ["MouseHit"] = targetCF,
    })
end

local attackThread, targetThread
local currentTarget

local function startAutoAttack()
    if attackThread or targetThread then return end
    -- Поток выбора цели (медленнее) — обновляет currentTarget.
    targetThread = task.spawn(function()
        while State.AutoAttack do
            if isAlive() and (not Config.AttackOnlyInDungeon or inDungeonMap()) and not elevatorBusy then
                if not currentTarget or not isMobAlive(currentTarget) then
                    currentTarget = findTarget()
                end
            else
                currentTarget = nil
            end
            task.wait(math.max(0.05, Config.TargetRescanInterval or 0.25))
        end
        targetThread = nil
    end)

    -- Поток атаки (быстрый) — спам M1 с интервалом AttackInterval.
    attackThread = task.spawn(function()
        while State.AutoAttack do
            if isAlive()
               and (not Config.AttackOnlyInDungeon or inDungeonMap())
               and not elevatorBusy then
                if currentTarget and isMobAlive(currentTarget) then
                    local cf = mobAttackCFrame(currentTarget)
                    if cf then
                        performM1(cf)
                    end
                else
                    -- Цель умерла — сразу пересчитываем, не ждём targetThread.
                    currentTarget = findTarget()
                end
            end
            task.wait(math.max(0.02, Config.AttackInterval or 0.1))
        end
        attackThread = nil
    end)
end

local function stopAutoAttack()
    State.AutoAttack = false
    if attackThread then pcall(task.cancel, attackThread); attackThread = nil end
    if targetThread then pcall(task.cancel, targetThread); targetThread = nil end
    currentTarget = nil
end

-- ==================== AUTO OPE ROOM ====================
local opeRoomThread

local function startAutoOpeRoom()
    if opeRoomThread then return end
    opeRoomThread = task.spawn(function()
        while State.AutoOpeRoom do
            if isAlive() and inDungeonMap() and not elevatorBusy then
                if not getOpeRoom() then
                    spawnOpeRoom()
                end
            end
            task.wait(1)
        end
        opeRoomThread = nil
    end)
end

local function stopAutoOpeRoom()
    State.AutoOpeRoom = false
    if opeRoomThread then pcall(task.cancel, opeRoomThread); opeRoomThread = nil end
end

-- ==================== AUTO ELEVATOR ====================
local elevatorWatcherThread

local function startAutoElevator()
    if elevatorWatcherThread then return end
    elevatorWatcherThread = task.spawn(function()
        while State.AutoElevator do
            if isAlive() and inDungeonMap() and not elevatorBusy then
                local enemies = getEnemiesCount()
                if enemies == 0 then
                    rideElevator()
                    -- Подождём окончания поездки + небольшую паузу на телепорт сервера.
                    while elevatorBusy do task.wait(0.1) end
                    task.wait(0.5)
                end
            end
            task.wait(0.3)
        end
        elevatorWatcherThread = nil
    end)
end

local function stopAutoElevator()
    State.AutoElevator = false
    if elevatorWatcherThread then
        pcall(task.cancel, elevatorWatcherThread); elevatorWatcherThread = nil
    end
end

-- ==================== AUTO TELEPORT / SELECT ====================
local function teleportToStart()
    if not clientHRP then return false end
    local cf = CFrame.new(Config.StartX, Config.StartY, Config.StartZ)
    return safeCall("teleportToStart", function()
        clientHRP.CFrame = cf
    end)
end

local function waitForChooseMap(timeout)
    local pg = localPlayer:FindFirstChild("PlayerGui")
        or localPlayer:WaitForChild("PlayerGui", 10)
    if not pg then return nil end
    local deadline = os.clock() + (timeout or 30)
    while os.clock() < deadline do
        local ui = pg:FindFirstChild("ChooseMap")
        if ui then return ui end
        task.wait(0.25)
    end
    return nil
end

local function waitForDungeonMap(timeout)
    local deadline = os.clock() + (timeout or 60)
    while os.clock() < deadline do
        local map = getDungeonMap()
        if map then return map end
        task.wait(0.5)
    end
    return nil
end

-- ==================== MASTER LOOP: AUTO DUNGEON ====================
local masterThread

local function runDungeonOnce()
    -- 1. Телепорт к точке выбора данжа.
    if not isAlive() then return false, "dead" end
    teleportToStart()
    task.wait(1.0)

    -- 2. Дожидаемся UI ChooseMap.
    local ui = waitForChooseMap(20)
    if not ui then
        return false, "no ChooseMap UI"
    end

    -- 3. Выбираем нужный режим.
    invokeSelectDungeon(Config.DungeonDifficulty or "Hard")

    -- 4. Ждём пока на карте появится нужная папка.
    local map = waitForDungeonMap(60)
    if not map then
        return false, "no dungeon map"
    end

    -- 5. Активируем суб-фичи на время прохождения.
    State.AutoOpeRoom  = true; startAutoOpeRoom()
    State.AutoAttack   = true; startAutoAttack()
    State.AutoElevator = true; startAutoElevator()

    -- 6. Цикл: ждём смены пятого этажа / выхода / смерти.
    while State.AutoDungeon do
        if not isAlive() then break end
        if not inDungeonMap() then
            -- Сервер выкинул нас обратно (победа/поражение).
            task.wait(1)
            if not inDungeonMap() then break end
        end
        local floor = getDungeonFloor()
        local enemies = getEnemiesCount()
        if floor == 5 and enemies == 0 then
            -- Финальный этаж пройден — даём 5с на лут / телепорт.
            task.wait(5)
            break
        end
        task.wait(1)
    end

    -- 7. Выключаем фичи.
    stopAutoOpeRoom()
    stopAutoAttack()
    stopAutoElevator()
    return true
end

local function startAutoDungeon()
    if masterThread then return end
    masterThread = task.spawn(function()
        while State.AutoDungeon do
            local ok, reason = runDungeonOnce()
            if not ok then
                Notify("KingLegacy", "Run aborted: " .. tostring(reason))
            end
            if not Config.AutoRestart then break end
            -- Пауза между рестартами + ожидание респауна, если игрока убили.
            task.wait(3)
            local waitTries = 0
            while State.AutoDungeon and not isAlive() and waitTries < 60 do
                task.wait(1); waitTries = waitTries + 1
            end
        end
        masterThread = nil
    end)
end

local function stopAutoDungeon()
    State.AutoDungeon = false
    stopAutoOpeRoom()
    stopAutoAttack()
    stopAutoElevator()
    if masterThread then pcall(task.cancel, masterThread); masterThread = nil end
end

-- ==================== FEATURES TABLE ====================
local FEATURES = {
    AutoDungeon = {
        onStart = startAutoDungeon,
        onStop  = stopAutoDungeon,
    },
    AutoTeleport = {
        onStart = function()
            -- Одноразовое действие — выключаемся сразу после телепорта.
            teleportToStart()
            State.AutoTeleport = false
            if NS.RefreshFooterUI then NS.RefreshFooterUI() end
        end,
        onStop = function() end,
    },
    AutoSelect = {
        onStart = function()
            invokeSelectDungeon(Config.DungeonDifficulty or "Hard")
            State.AutoSelect = false
            if NS.RefreshFooterUI then NS.RefreshFooterUI() end
        end,
        onStop = function() end,
    },
    AutoOpeRoom  = { onStart = startAutoOpeRoom,  onStop = stopAutoOpeRoom  },
    AutoAttack   = { onStart = startAutoAttack,   onStop = stopAutoAttack   },
    AutoElevator = { onStart = startAutoElevator, onStop = stopAutoElevator },
}

local function toggleFeature(name, value)
    State[name] = value
    Notify("KingLegacy · " .. name, value and "Enabled" or "Disabled")
    local cfg = FEATURES[name]
    if not cfg then return end
    if value then
        pcall(cfg.onStart)
    else
        pcall(cfg.onStop)
    end
    if NS.RefreshFooterUI then NS.RefreshFooterUI() end
end

-- ==================== GLOBAL CLEANUP ====================
NS.cleanup = function()
    stopAutoDungeon()
    for name in pairs(State) do State[name] = false end
    for _, def in pairs(FEATURES) do
        if def and def.onStop then pcall(def.onStop) end
    end
    for k in pairs(connections) do disconnect(k) end
    if charAddedConn then pcall(function() charAddedConn:Disconnect() end) end
    if idledConn     then pcall(function() idledConn:Disconnect()     end) end
    pcall(function()
        for _, v in ipairs((getHui and getHui()) or CoreGui:GetChildren()) do
            if v:IsA("ScreenGui") and (v.Name == "AbramKingGui" or v.Name:match("^AK_King")) then
                v:Destroy()
            end
        end
    end)
end

-- ==================== UI (dark mode, mobile-adaptive) ====================
pcall(function()
    for _, v in ipairs(CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and (v.Name == "AbramKingGui" or v.Name:match("^AK_King")) then
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
    Accent    = Color3.fromRGB(234, 179, 8),    -- gold для King Legacy
    AccentDim = Color3.fromRGB(202, 138, 4),
    Text      = Color3.fromRGB(250, 250, 250),
    TextDim   = Color3.fromRGB(161, 161, 170),
    TextMuted = Color3.fromRGB(113, 113, 122),
    Green     = Color3.fromRGB(16, 185, 129),
    Track     = Color3.fromRGB(63, 63, 70),
    Knob      = Color3.fromRGB(255, 255, 255),
}

local TW_FAST = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TW_POP  = TweenInfo.new(0.3,  Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function tw(obj, props, info)
    pcall(function() TweenService:Create(obj, info or TW_FAST, props):Play() end)
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
screenGui.Name = "AK_King_" .. HttpService:GenerateGUID(false):sub(1, 8)
screenGui.ResetOnSpawn = false
screenGui.Parent = (getHui and getHui()) or CoreGui

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local camera = workspace.CurrentCamera
local screenSize = camera and camera.ViewportSize or Vector2.new(1920, 1080)

local BASE_W, BASE_H = 340, 440

local mobileScale = 1
if isMobile then
    local scaleW = (screenSize.X * 0.55) / BASE_W
    local scaleH = (screenSize.Y * 0.85) / BASE_H
    mobileScale = math.min(scaleW, scaleH, 1)
end

local main = Instance.new("Frame")
main.Size = UDim2.new(0, BASE_W, 0, BASE_H)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.BackgroundColor3 = C.BG
main.BorderSizePixel = 0
main.Active = true
main.Parent = screenGui
addCorner(main, 12)
addStroke(main, C.Border, 1)

if isMobile then
    local uiScale = Instance.new("UIScale")
    uiScale.Scale = mobileScale
    uiScale.Parent = main
end

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
title.Text = "KingLegacy"
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
local tabNames = { "Main", "Settings", "Info" }

local tabsBar = Instance.new("Frame")
tabsBar.Size = UDim2.new(1, -TABS_PAD * 2, 0, TAB_H)
tabsBar.Position = UDim2.new(0, TABS_PAD, 0, TABS_TOP)
tabsBar.BackgroundTransparency = 1
tabsBar.Parent = main

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.Padding = UDim.new(0, 4)
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

local TAB_COUNT = #tabNames
for i, tabName in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1/TAB_COUNT, -4, 1, 0)
    btn.LayoutOrder = i
    btn.BackgroundColor3 = C.Surface
    btn.AutoButtonColor = false
    btn.Font = Enum.Font.GothamBold
    btn.Text = tabName
    btn.TextSize = 11
    btn.TextColor3 = C.TextMuted
    btn.Parent = tabsBar
    addCorner(btn, 6)
    btn.MouseButton1Click:Connect(function() setActiveTab(tabName) end)
    tabButtons[tabName] = btn
end

-- ===== PAGES =====
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

    local pad = Instance.new("UIPadding")
    pad.PaddingRight = UDim.new(0, 6)
    pad.PaddingBottom = UDim.new(0, 4)
    pad.Parent = page

    pages[name] = page
    return page
end

local pageMain     = createPage("Main")
local pageSettings = createPage("Settings")
local pageInfo     = createPage("Info")

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

-- ===== FLOATING PILL =====
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
pillIcon.Text = "KL"
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
pill.MouseLeave:Connect(function() tw(pill, { BackgroundColor3 = C.Surface   }) end)

NS.RefreshFooterUI = function()
    local count = 0
    for _, v in pairs(State) do if v then count = count + 1 end end
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

local function buildToggleRow(parentPage, label)
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
    track.Parent = row
    addCorner(track, 10)

    local KNOB_SIZE, KNOB_PAD = 14, 3
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, KNOB_SIZE, 0, KNOB_SIZE)
    knob.Position = UDim2.new(0, KNOB_PAD, 0, KNOB_PAD)
    knob.BackgroundColor3 = C.Knob
    knob.Parent = track
    addCorner(knob, 7)

    local function setVisual(on, animate)
        local bg  = on and C.Green or C.Track
        local pos = on and UDim2.new(0, 19, 0, KNOB_PAD) or UDim2.new(0, KNOB_PAD, 0, KNOB_PAD)
        local col = on and C.Text or C.TextDim
        if animate then
            tw(track, { BackgroundColor3 = bg })
            tw(knob,  { Position = pos })
            tw(lbl,   { TextColor3 = col })
        else
            track.BackgroundColor3 = bg
            knob.Position = pos
            lbl.TextColor3 = col
        end
    end

    row.MouseEnter:Connect(function() tw(rowStroke, { Transparency = 0 })   end)
    row.MouseLeave:Connect(function() tw(rowStroke, { Transparency = 0.5 }) end)

    return row, setVisual
end

local function createToggle(parentPage, label, key)
    local row, setVisual = buildToggleRow(parentPage, label)
    row.MouseButton1Click:Connect(function()
        toggleFeature(key, not State[key])
        setVisual(State[key], true)
    end)
    setVisual(State[key], false)
end

local function createConfigToggle(parentPage, label, configKey, onChange)
    local row, setVisual = buildToggleRow(parentPage, label)
    row.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        saveConfig()
        setVisual(Config[configKey], true)
        if onChange then pcall(onChange, Config[configKey]) end
    end)
    setVisual(Config[configKey], false)
end

local function createNumberInput(parentPage, label, configKey, min, max, step)
    step = step or 1
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = C.Surface
    row.BorderSizePixel = 0
    row.Parent = parentPage
    addCorner(row, 8)
    local stroke = addStroke(row, C.Border, 1)
    stroke.Transparency = 0.5

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.55, -14, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = label
    lbl.TextSize = 12
    lbl.TextColor3 = C.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local box = Instance.new("TextBox")
    box.AnchorPoint = Vector2.new(1, 0.5)
    box.Position = UDim2.new(1, -14, 0.5, 0)
    box.Size = UDim2.new(0.4, -14, 0, 26)
    box.BackgroundColor3 = C.BG
    box.BorderSizePixel = 0
    box.ClearTextOnFocus = false
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.TextColor3 = C.Text
    box.Text = tostring(Config[configKey])
    box.Parent = row
    addCorner(box, 6)
    addStroke(box, C.Border, 1)

    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n and n >= min and n <= max then
            Config[configKey] = n
            saveConfig()
        end
        box.Text = tostring(Config[configKey])
    end)
end

local function createTextInput(parentPage, label, configKey)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = C.Surface
    row.BorderSizePixel = 0
    row.Parent = parentPage
    addCorner(row, 8)
    local stroke = addStroke(row, C.Border, 1)
    stroke.Transparency = 0.5

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.45, -14, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium
    lbl.Text = label
    lbl.TextSize = 12
    lbl.TextColor3 = C.Text
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    local box = Instance.new("TextBox")
    box.AnchorPoint = Vector2.new(1, 0.5)
    box.Position = UDim2.new(1, -14, 0.5, 0)
    box.Size = UDim2.new(0.5, -14, 0, 26)
    box.BackgroundColor3 = C.BG
    box.BorderSizePixel = 0
    box.ClearTextOnFocus = false
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.TextColor3 = C.Text
    box.Text = tostring(Config[configKey])
    box.Parent = row
    addCorner(box, 6)
    addStroke(box, C.Border, 1)

    box.FocusLost:Connect(function()
        Config[configKey] = box.Text
        saveConfig()
    end)
end

local function createReadOnlyRow(parentPage, label, value)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundColor3 = C.Surface
    row.BorderSizePixel = 0
    row.Parent = parentPage
    addCorner(row, 8)

    local lblL = Instance.new("TextLabel")
    lblL.Size = UDim2.new(0.5, -14, 1, 0)
    lblL.Position = UDim2.new(0, 14, 0, 0)
    lblL.BackgroundTransparency = 1
    lblL.Font = Enum.Font.GothamMedium
    lblL.Text = label
    lblL.TextSize = 11
    lblL.TextColor3 = C.TextDim
    lblL.TextXAlignment = Enum.TextXAlignment.Left
    lblL.Parent = row

    local lblR = Instance.new("TextLabel")
    lblR.AnchorPoint = Vector2.new(1, 0.5)
    lblR.Position = UDim2.new(1, -14, 0.5, 0)
    lblR.Size = UDim2.new(0.5, -14, 1, 0)
    lblR.BackgroundTransparency = 1
    lblR.Font = Enum.Font.Gotham
    lblR.Text = tostring(value)
    lblR.TextSize = 11
    lblR.TextColor3 = C.Text
    lblR.TextXAlignment = Enum.TextXAlignment.Right
    lblR.Parent = row
end

-- ===== MAIN PAGE CONTENT =====
createSection(pageMain, "Auto Dungeon")
createToggle(pageMain, "Auto Dungeon (full cycle)", "AutoDungeon")
createToggle(pageMain, "One-shot Teleport",         "AutoTeleport")
createToggle(pageMain, "One-shot Select Dungeon",   "AutoSelect")

createSection(pageMain, "In-dungeon")
createToggle(pageMain, "Auto Ope Ope Room (Z)",     "AutoOpeRoom")
createToggle(pageMain, "Auto Attack (Kioru V2 M1)", "AutoAttack")
createToggle(pageMain, "Auto Elevator (CFrame lock)","AutoElevator")

-- ===== SETTINGS PAGE CONTENT =====
createSection(pageSettings, "Dungeon")
createTextInput  (pageSettings, "Difficulty",    "DungeonDifficulty")
createTextInput  (pageSettings, "Map name",      "DungeonMapName")
createNumberInput(pageSettings, "Start X",       "StartX", -100000, 100000, 0.01)
createNumberInput(pageSettings, "Start Y",       "StartY", -100000, 100000, 0.01)
createNumberInput(pageSettings, "Start Z",       "StartZ", -100000, 100000, 0.01)
createNumberInput(pageSettings, "Elevator (s)",  "ElevatorDuration", 0.5, 30, 0.1)
createConfigToggle(pageSettings, "Auto Restart", "AutoRestart")

createSection(pageSettings, "Combat")
createNumberInput(pageSettings, "Attack interval (s)",  "AttackInterval", 0.02, 1, 0.01)
createNumberInput(pageSettings, "Target rescan (s)",    "TargetRescanInterval", 0.05, 2, 0.05)
createConfigToggle(pageSettings, "Only attack in dungeon", "AttackOnlyInDungeon")

createSection(pageSettings, "Misc")
createConfigToggle(pageSettings, "Anti-AFK", "AntiAFK")
createConfigToggle(pageSettings, "Verbose pcall logs", "PcallVerbose")

-- ===== INFO PAGE CONTENT =====
createSection(pageInfo, "About")
createReadOnlyRow(pageInfo, "Script",     "KingLegacy")
createReadOnlyRow(pageInfo, "Version",    VERSION)
createReadOnlyRow(pageInfo, "Player",     localPlayer.Name)
createReadOnlyRow(pageInfo, "Platform",   isMobile and "Mobile" or "PC")
createReadOnlyRow(pageInfo, "FileSystem", hasFS and "available" or "n/a")
createSection(pageInfo, "Tips")
do
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 100)
    lbl.BackgroundColor3 = C.Surface
    lbl.BorderSizePixel = 0
    lbl.TextColor3 = C.TextDim
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.Text =
        "  · Auto Dungeon: teleport → SelectDungeon → ждём карту → включает OpeRoom / Attack / Elevator." ..
        "\n  · Для Third Sea Hard: difficulty=Hard, map=Crustacean Cataclysm." ..
        "\n  · Auto Elevator привязывает CFrame к лифту на ElevatorDuration секунд." ..
        "\n  · Auto Attack ищет босса (атрибут Boss=true) или ближайшего моба, фокус в DEF-spine.001." ..
        "\n  · В лифте атака автоматически паузится."
    lbl.Parent = pageInfo
    addCorner(lbl, 8)
    local pad = Instance.new("UIPadding", lbl)
    pad.PaddingLeft  = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop   = UDim.new(0, 8)
end

setActiveTab("Main")
NS.RefreshFooterUI()

-- ===== DRAG & ALT HIDE =====
local draggingMain = false
local dragPending  = false
local dragStartM, startPosM
local MAIN_DRAG_THRESHOLD = 10

local pillDrag = false
local pDragStart, pStartPos, pMoved
local DRAG_THRESHOLD = 15

local function isInsideMain(touchPos)
    local uiScaleObj = main:FindFirstChildOfClass("UIScale")
    local s = uiScaleObj and uiScaleObj.Scale or 1
    local vp = camera and camera.ViewportSize or Vector2.new(1920, 1080)
    local cx = vp.X * main.Position.X.Scale + main.Position.X.Offset
    local cy = vp.Y * main.Position.Y.Scale + main.Position.Y.Offset
    local hw = (BASE_W * s) / 2
    local hh = (BASE_H * s) / 2
    return touchPos.X >= cx - hw and touchPos.X <= cx + hw
       and touchPos.Y >= cy - hh and touchPos.Y <= cy + hh
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        if main.Visible and isInsideMain(input.Position) then
            dragPending = true
            draggingMain = false
            dragStartM = input.Position
            startPosM = main.Position
        end
    end
end)

pill.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        pillDrag = true
        pMoved = false
        pDragStart = input.Position
        pStartPos = pill.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        if dragPending and not draggingMain then
            if (input.Position - dragStartM).Magnitude > MAIN_DRAG_THRESHOLD then
                draggingMain = true
                dragPending = false
            end
        end
        if draggingMain then
            local d = input.Position - dragStartM
            main.Position = UDim2.new(
                startPosM.X.Scale, startPosM.X.Offset + d.X,
                startPosM.Y.Scale, startPosM.Y.Offset + d.Y
            )
        elseif pillDrag then
            local d = input.Position - pDragStart
            if d.Magnitude > DRAG_THRESHOLD then pMoved = true end
            pill.Position = UDim2.new(
                pStartPos.X.Scale, pStartPos.X.Offset + d.X,
                pStartPos.Y.Scale, pStartPos.Y.Offset + d.Y
            )
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        draggingMain = false
        dragPending = false
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

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
        toggleMenu()
    end
end)

-- Мобильная toggle-кнопка
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
    mobileBtnIcon.Text = "KL"
    mobileBtnIcon.TextSize = 16
    mobileBtnIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    mobileBtnIcon.ZIndex = 11
    mobileBtnIcon.Parent = mobileBtn

    mobileBtn.MouseButton1Click:Connect(function() toggleMenu() end)

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
            mobileBtn.Position = UDim2.new(
                mbStartPos.X.Scale, mbStartPos.X.Offset + d.X,
                mbStartPos.Y.Scale, mbStartPos.Y.Offset + d.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            mbDrag = false
        end
    end)
end

-- Адаптация при изменении viewport
if camera and isMobile then
    camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        local newSize = camera.ViewportSize
        local scaleW = (newSize.X * 0.55) / BASE_W
        local scaleH = (newSize.Y * 0.85) / BASE_H
        local uiScale = main:FindFirstChildOfClass("UIScale")
        if uiScale then
            uiScale.Scale = math.min(scaleW, scaleH, 1)
        end
    end)
end

-- Периодически обновляем счётчик активных фич
task.spawn(function()
    while screenGui.Parent do
        task.wait(2)
        NS.RefreshFooterUI()
    end
end)

local loadMsg = ("v%s loaded. "):format(VERSION)
    .. (isMobile and "Tap KL button to toggle menu." or "Press ALT or click KL pill.")
Notify("KingLegacy", loadMsg)
if not hasFS then
    Notify("KingLegacy", "Note: executor lacks file I/O — config will not persist.")
end
