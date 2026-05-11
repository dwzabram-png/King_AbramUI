-- SkyWars.lua — King AbramUI
-- Production rewrite of the legacy `SkyWars` prototype.
-- Auto-farm for ore/mining rounds with safe Tween navigation, efficient noclip,
-- AntiVoid platform, anti-detect jitter, dark-mode UI и mobile-адаптацией.

repeat task.wait() until game:IsLoaded()

local VERSION = "2.0.0"

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local CoreGui           = game:GetService("CoreGui")
local HttpService       = game:GetService("HttpService")
local VirtualUser       = game:GetService("VirtualUser")

local localPlayer = Players.LocalPlayer

-- ==================== EXECUTOR CAPABILITIES ====================
local hasFS  = type(writefile) == "function"
            and type(readfile)  == "function"
            and type(isfile)    == "function"
local getHui = gethui

-- Единый неймспейс вместо разрозненных глобалов
_G.AbramSky = _G.AbramSky or {}
local NS = _G.AbramSky
NS.version = VERSION

-- Если предыдущий запуск ещё жив — корректно потушим его
if NS.cleanup then
    pcall(NS.cleanup)
end

-- ==================== CHARACTER TRACKING ====================
local client, clientHRP

local function updateCharacter()
    local attempts = 0
    while attempts < 30 do
        client = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local hrp = client:WaitForChild("HumanoidRootPart", 10)
        if hrp then
            clientHRP = hrp
            return
        end
        attempts = attempts + 1
        task.wait(1)
    end
end
updateCharacter()
local charAddedConn = localPlayer.CharacterAdded:Connect(updateCharacter)

-- Anti-AFK — Roblox kick'ает за 20 минут idle
local idledConn = localPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

-- ==================== CONFIG ====================
local DEFAULT_CONFIG = {
    FarmRadius        = 105,    -- студы
    TweenSpeed        = 50,     -- студов в секунду
    RescanInterval    = 5,      -- сек — период обновления mapFolder
    AutoEquipAxe      = true,
    AntiVoidEnabled   = true,
    AntiDetectJitter  = true,
}
local Config = table.clone(DEFAULT_CONFIG)
local CONFIG_FILE = "AbramSky_config.json"

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
    AutoFarm = false,
    Noclip   = false,
    AntiVoid = false,
}

local activeFeatures = {}    -- name -> handle (thread / connection / true)
local connections    = {}    -- произвольные RBXScriptConnection
local noclipParts    = setmetatable({}, {__mode = "k"})
local activeTween    -- текущий tween персонажа (только один за раз)
local antiVoidPart   -- созданная платформа
local mapFolder      -- workspace.*Map*
local oresFolder     -- mapFolder.Map.Ores

local function disconnect(key)
    local c = connections[key]
    if c then
        pcall(function() c:Disconnect() end)
        connections[key] = nil
    end
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

-- ==================== MAP / ORE DISCOVERY ====================
local function findMapFolder()
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name:match("Map") then
            return v
        end
    end
    return nil
end

local function refreshMap()
    local found = findMapFolder()
    if found ~= mapFolder then
        mapFolder = found
        oresFolder = nil
    end
    if mapFolder then
        local sub = mapFolder:FindFirstChild("Map")
        if sub then
            oresFolder = sub:FindFirstChild("Ores")
        end
    end
end

-- Периодический rescan — карта меняется между раундами SkyWars
connections.rescan = task.spawn(function()
    while true do
        pcall(refreshMap)
        task.wait(math.max(Config.RescanInterval, 1))
    end
end)
-- task.spawn возвращает thread, не connection — храним отдельно
local rescanThread = connections.rescan
connections.rescan = nil

-- ==================== ANTI-VOID PLATFORM ====================
local function destroyAntiVoid()
    if antiVoidPart then
        pcall(function() antiVoidPart:Destroy() end)
        antiVoidPart = nil
    end
end

local function ensureAntiVoid()
    if not Config.AntiVoidEnabled then
        destroyAntiVoid()
        State.AntiVoid = false
        return
    end
    if antiVoidPart and antiVoidPart.Parent then
        State.AntiVoid = true
        return
    end
    local pos = Vector3.new(0, 50, 0)
    if mapFolder then
        local ok, cf = pcall(function() return mapFolder:GetPivot() end)
        if ok and cf then
            pos = Vector3.new(cf.Position.X, math.max(cf.Position.Y - 50, 30), cf.Position.Z)
        end
    end
    antiVoidPart = Instance.new("Part")
    antiVoidPart.Name         = "AS_AntiVoidPart"
    antiVoidPart.Size         = Vector3.new(2000, 4, 2000)
    antiVoidPart.Position     = pos
    antiVoidPart.Anchored     = true
    antiVoidPart.CanCollide   = true
    antiVoidPart.Transparency = 1
    antiVoidPart.Parent       = workspace
    State.AntiVoid = true
end

-- ==================== NOCLIP (event-driven, не per-frame) ====================
local function applyNoclipToCharacter(char)
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            part.CanCollide = false
            noclipParts[part] = true
        end
    end
end

local function startNoclip()
    if State.Noclip then return end
    State.Noclip = true
    if client then applyNoclipToCharacter(client) end
    -- Подписка на текущего персонажа
    local function hook(char)
        disconnect("noclipDesc")
        applyNoclipToCharacter(char)
        connections.noclipDesc = char.DescendantAdded:Connect(function(d)
            if d:IsA("BasePart") and d.CanCollide then
                d.CanCollide = false
                noclipParts[d] = true
            end
        end)
    end
    if client then hook(client) end
    connections.noclipChar = localPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(0.3)
        hook(newChar)
    end)
end

local function stopNoclip()
    if not State.Noclip then return end
    State.Noclip = false
    disconnect("noclipDesc")
    disconnect("noclipChar")
    -- Восстановим коллизии у живых частей
    for part in pairs(noclipParts) do
        if part and part.Parent then
            pcall(function() part.CanCollide = true end)
        end
    end
    noclipParts = setmetatable({}, {__mode = "k"})
end

-- ==================== AXE ====================
local function findAxe()
    if not client then return nil, false end
    local axe = client:FindFirstChild("Axe")
    if axe then return axe, true end
    local pack = localPlayer:FindFirstChild("Backpack")
    if pack then
        axe = pack:FindFirstChild("Axe")
        if axe then return axe, false end
    end
    return nil, false
end

local function equipAxe()
    local axe, equipped = findAxe()
    if not axe then return nil end
    if not equipped and Config.AutoEquipAxe then
        pcall(function() axe.Parent = client end)
    end
    return axe
end

-- ==================== AUTO FARM ITERATION ====================
local function pickNearestBlock()
    if not (oresFolder and clientHRP) then return nil end
    local nearest, nearestDist
    local origin = clientHRP.Position
    for _, block in ipairs(oresFolder:GetChildren()) do
        if block.Name == "Block" and block:IsA("BasePart") then
            local dist = (origin - block.Position).Magnitude
            if dist < Config.FarmRadius and (not nearestDist or dist < nearestDist) then
                nearest, nearestDist = block, dist
            end
        end
    end
    return nearest, nearestDist
end

local function farmStep()
    if not (client and clientHRP) then return end
    local axe = equipAxe()
    if not axe then return end
    pcall(function() axe:Activate() end)

    local remote = axe:FindFirstChildWhichIsA("RemoteEvent")
    if not (remote and oresFolder) then return end

    local block, dist = pickNearestBlock()
    if not block then return end

    -- Отменяем предыдущий tween, не накапливая
    if activeTween then
        pcall(function() activeTween:Cancel() end)
        activeTween = nil
    end

    local speed = math.max(Config.TweenSpeed, 5)
    local timeScale, posJitter = 1, Vector3.zero
    if Config.AntiDetectJitter then
        timeScale = 1 + (math.random() - 0.5) * 0.15           -- ±7.5%
        posJitter = Vector3.new(
            (math.random() - 0.5) * 1.5,
            (math.random() - 0.5) * 0.5,
            (math.random() - 0.5) * 1.5
        )
    end

    local tweenTime = math.max(dist / speed * timeScale, 0.05)
    local targetCF  = block.CFrame + posJitter

    activeTween = TweenService:Create(
        clientHRP,
        TweenInfo.new(tweenTime, Enum.EasingStyle.Linear),
        { CFrame = targetCF }
    )
    activeTween:Play()
    pcall(function() remote:FireServer(block) end)
    activeTween.Completed:Wait()
    activeTween = nil
end

-- ==================== FEATURE LIFECYCLE ====================
local function startAutoFarm()
    if activeFeatures.AutoFarm then return end
    ensureAntiVoid()
    startNoclip()
    refreshMap()

    activeFeatures.AutoFarm = task.spawn(function()
        while State.AutoFarm do
            local ok, err = pcall(farmStep)
            if not ok then
                warn("[SkyWars] farmStep:", err)
                task.wait(0.5)
            end
            if not State.AutoFarm then break end
            -- лёгкая пауза между итерациями + микро-джиттер
            local pause = 0.05
            if Config.AntiDetectJitter then
                pause = pause + math.random() * 0.05
            end
            task.wait(pause)
        end
        if activeTween then
            pcall(function() activeTween:Cancel() end)
            activeTween = nil
        end
        activeFeatures.AutoFarm = nil
    end)
end

local function stopAutoFarm()
    activeFeatures.AutoFarm = nil
    if activeTween then
        pcall(function() activeTween:Cancel() end)
        activeTween = nil
    end
    if not State.Noclip then stopNoclip() end
end

local FEATURES = {
    AutoFarm = { onStart = startAutoFarm,             onStop = stopAutoFarm  },
    Noclip   = { onStart = startNoclip,               onStop = stopNoclip    },
    AntiVoid = { onStart = ensureAntiVoid,            onStop = destroyAntiVoid },
}

local function toggleFeature(name, value)
    State[name] = value
    Notify("SkyWars · " .. name, value and "Enabled" or "Disabled")
    local cfg = FEATURES[name]
    if not cfg then return end
    if value then
        pcall(cfg.onStart)
    else
        pcall(cfg.onStop)
    end
    if NS.RefreshFooterUI then NS.RefreshFooterUI() end
end

-- ==================== GLOBAL CLEANUP (для повторного запуска) ====================
NS.cleanup = function()
    for name in pairs(State) do State[name] = false end
    pcall(stopAutoFarm)
    pcall(stopNoclip)
    pcall(destroyAntiVoid)
    for k in pairs(connections) do disconnect(k) end
    if rescanThread then pcall(task.cancel, rescanThread) end
    if charAddedConn then pcall(function() charAddedConn:Disconnect() end) end
    if idledConn     then pcall(function() idledConn:Disconnect()     end) end
    pcall(function()
        for _, v in ipairs((getHui and getHui()) or CoreGui:GetChildren()) do
            if v:IsA("ScreenGui") and (v.Name == "AbramSkyGui" or v.Name:match("^AS_Sky")) then
                v:Destroy()
            end
        end
    end)
end

-- ==================== UI (dark mode, mobile-adaptive) ====================
pcall(function()
    for _, v in ipairs(CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and (v.Name == "AbramSkyGui" or v.Name:match("^AS_Sky")) then
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
screenGui.Name = "AS_Sky_" .. HttpService:GenerateGUID(false):sub(1, 8)
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
title.Text = "SkyWars"
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
pillIcon.Text = "SW"
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

local function createReadOnlyRow(parentPage, label, value)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundColor3 = C.Surface
    row.BorderSizePixel = 0
    row.Parent = parentPage
    addCorner(row, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, -14, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = C.TextDim
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = label
    lbl.Parent = row

    local val = Instance.new("TextLabel")
    val.Size = UDim2.new(0.5, -14, 1, 0)
    val.Position = UDim2.new(0.5, 0, 0, 0)
    val.BackgroundTransparency = 1
    val.TextColor3 = C.Text
    val.Font = Enum.Font.Gotham
    val.TextSize = 12
    val.TextXAlignment = Enum.TextXAlignment.Right
    val.Text = tostring(value)
    val.Parent = row
end

-- ===== BUILD PAGES =====
createSection(pageMain, "Automation")
createToggle(pageMain, "Auto Farm", "AutoFarm")
createToggle(pageMain, "Noclip",    "Noclip")
createToggle(pageMain, "Anti-Void Platform", "AntiVoid")

createSection(pageSettings, "Farm")
createInput(pageSettings, "Farm radius (studs)", Config.FarmRadius, function(v)
    Config.FarmRadius = math.clamp(tonumber(v) or DEFAULT_CONFIG.FarmRadius, 10, 2000)
    saveConfig()
end)
createInput(pageSettings, "Tween speed (studs/s)", Config.TweenSpeed, function(v)
    Config.TweenSpeed = math.clamp(tonumber(v) or DEFAULT_CONFIG.TweenSpeed, 5, 500)
    saveConfig()
end)
createInput(pageSettings, "Map rescan (s)", Config.RescanInterval, function(v)
    Config.RescanInterval = math.clamp(tonumber(v) or DEFAULT_CONFIG.RescanInterval, 1, 60)
    saveConfig()
end)
createSection(pageSettings, "Behaviour")
createConfigToggle(pageSettings, "Auto-equip Axe",       "AutoEquipAxe")
createConfigToggle(pageSettings, "Anti-Detect Jitter",   "AntiDetectJitter")
createConfigToggle(pageSettings, "Enable Anti-Void", "AntiVoidEnabled", function(on)
    if not on and State.AntiVoid then
        toggleFeature("AntiVoid", false)
    end
end)

createSection(pageInfo, "About")
createReadOnlyRow(pageInfo, "Script",       "SkyWars")
createReadOnlyRow(pageInfo, "Version",      VERSION)
createReadOnlyRow(pageInfo, "Player",       localPlayer.Name)
createReadOnlyRow(pageInfo, "Platform",     isMobile and "Mobile" or "PC")
createReadOnlyRow(pageInfo, "FileSystem",   hasFS and "available" or "n/a")
createSection(pageInfo, "Tips")
do
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 72)
    lbl.BackgroundColor3 = C.Surface
    lbl.BorderSizePixel = 0
    lbl.TextColor3 = C.TextDim
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextWrapped = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.Text = "  · Auto Farm включает Noclip и Anti-Void автоматически.\n  · Карта обновляется между раундами — настраивай в Settings.\n  · Anti-Detect Jitter добавляет шум в Tween и позицию."
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
    mobileBtnIcon.Text = "SW"
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

-- Адаптация при изменении viewport (поворот экрана и т.д.)
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

-- Периодически обновляем счётчик активных фич (на случай внешних правок)
task.spawn(function()
    while screenGui.Parent do
        task.wait(2)
        NS.RefreshFooterUI()
    end
end)

local loadMsg = ("v%s loaded. "):format(VERSION)
    .. (isMobile and "Tap SW button to toggle menu." or "Press ALT or click SW pill.")
Notify("SkyWars", loadMsg)
if not hasFS then
    Notify("SkyWars", "Note: executor lacks file I/O — config will not persist.")
end
