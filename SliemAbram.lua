-- [[ AbramSliem FULL FIXED SCRIPT ]] --

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
 
-- Dynamic character reference
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

-- Remote Search
local RemotesFolder = nil
task.spawn(function()
    while not RemotesFolder do
        RemotesFolder = ReplicatedStorage:FindFirstChild("_remotes", true)
        task.wait(1)
    end
end)

local function callRemote(service, method, ...)
    if not RemotesFolder then return false, "RemotesFolder not found" end
    local remote = RemotesFolder:FindFirstChild(service)
    if not remote then return false, "Service not found" end
    local func = remote:FindFirstChild("RemoteFunction")
    if not func then return false, "RemoteFunction not found" end
    
    local ok, result = pcall(function(...)
        return func:InvokeServer(...)
    end, method, ...)
    
    return ok, result
end

-- Helpers
local function safeFind(root, ...)
    local current = root
    for _, name in ipairs({...}) do
        if not current then return nil end
        current = current:FindFirstChild(name)
    end
    return current
end

local function TP(x, y, z)
    if not clientHRP then return end
    clientHRP.CFrame = CFrame.new(x, y, z)
end

-- Discord Webhook
local function isValidWebhook(url)
    return type(url) == "string" and (url:find("discord.com/api/webhooks") or url:find("discordapp.com/api/webhooks"))
end

local function SendDiscordWebhook(url, data)
    if not isValidWebhook(url) then return false end
    local requestFn = (syn and syn.request) or (http and http.request) or http_request or request
    if not requestFn then return false end
    
    local body = HttpService:JSONEncode({
        embeds = {{
            title = data.title,
            description = data.description,
            color = 3447003,
            timestamp = DateTime.now():ToIsoDate(),
        }}
    })
    
    pcall(function()
        requestFn({
            Url = url,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = body
        })
    end)
end

-- Game Actions
local function Upgrade()
    local frame = safeFind(localPlayer, "PlayerGui", "Root", "UpgradeScreen", "UpgradeContent", "Frame")
    if not frame then return end
    for _, tile in ipairs(frame:GetChildren()) do
        if tile:IsA("GuiButton") and tile.Name:find("Tile") then
            local upName = tile.Name:gsub("Tile", "")
            callRemote("UpgradeService", "requestUnlock", upName)
            task.wait(0.05)
        end
    end
end

local function getRollCooldown()
    local label = safeFind(localPlayer, "PlayerGui", "Root", "BottomBarStats", "StatsList", "RollSpeedStat", "Content", "Value", "TextLabel")
    return label and tonumber(label.Text:match("[%d%.]+")) or 0.5
end

local function AutoKill()
    if not clientHRP then return end
    local gameplay = nil
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name:match("^Gameplay") then gameplay = v break end
    end
    if not gameplay then return end
    local enemies = gameplay:FindFirstChild("Enemies")
    if not enemies then return end
    
    for _, enemy in ipairs(enemies:GetChildren()) do
        local root = enemy:FindFirstChild("RootPart") or enemy:FindFirstChild("HumanoidRootPart")
        local hum = enemy:FindFirstChild("Humanoid")
        if root and hum and hum.Health > 0 then
            clientHRP.CFrame = root.CFrame
            break
        end
    end
end

-- Feature Loop Manager
local FEATURES = {
    AutoRoll = {kind="loop", getInt=getRollCooldown, act=function() callRemote("RollService", "requestRoll") end},
    AutoIndex = {kind="loop", getInt=function() return 30 end, act=function() 
        for _, r in ipairs({"basic", "big", "huge", "shiny", "inverted"}) do callRemote("IndexService", "requestClaimReward", r) task.wait(0.1) end 
    end},
    AutoPotions = {kind="loop", getInt=function() return 5 end, act=function()
        for _, p in ipairs({"luck", "ultraLuck", "currency", "rollSpeed"}) do callRemote("BoostService", "requestUseBoost", p) end
    end},
    AutoTeleportBestZone = {kind="loop", getInt=function() return Config.AutoBestZoneInterval end, act=function()
        local zones = workspace:FindFirstChild("Zones")
        if not zones then return end
        local best = 0
        for _, z in ipairs(zones:GetChildren()) do
            local g = safeFind(z, "Gate", "ClientGateBlocker_"..z.Name)
            if g and not g.CanCollide then
                local n = tonumber(z.Name) or 0
                if n > best then best = n end
            end
        end
        if best > 0 then callRemote("ZonesService", "requestTeleportZone", best) end
    end},
    AutoBuyZone = {kind="loop", getInt=function() return 5 end, act=function() callRemote("ZonesService", "requestPurchaseZone") end},
    AutoRebirth = {kind="loop", getInt=function() return 10 end, act=function() callRemote("RebirthService", "requestRebirth") end},
    AutoEquipBest = {kind="loop", getInt=function() return 10 end, act=function() callRemote("InventoryService", "requestEquipBest") end},
    AutoUpgrade = {kind="loop", getInt=function() return Config.AutoUpgradeInterval end, act=Upgrade},
    AutoKill = {kind="loop", getInt=function() return 0.5 end, act=AutoKill},
    AutoFarm = {kind="conn", signal=RunService.Heartbeat, act=function()
        if not State.AutoFarm or not clientHRP then return end
        local loot = workspace:FindFirstChild("Loot")
        if not loot then return end
        for _, d in ipairs(loot:GetChildren()) do
            for _, c in ipairs(d:GetChildren()) do
                if c:IsA("BasePart") and c.Name ~= "LootHighlight" then c.CFrame = clientHRP.CFrame end
            end
        end
    end}
}

local function toggleFeature(name, val)
    State[name] = val
    if activeFeatures[name] then
        if typeof(activeFeatures[name]) == "thread" then task.cancel(activeFeatures[name]) else activeFeatures[name]:Disconnect() end
        activeFeatures[name] = nil
    end
    if val then
        local cfg = FEATURES[name]
        if cfg.kind == "loop" then
            activeFeatures[name] = task.spawn(function()
                while State[name] do
                    pcall(cfg.act)
                    task.wait(cfg.getInt())
                end
            end)
        else
            activeFeatures[name] = cfg.signal:Connect(cfg.act)
        end
    end
    if _G.RefreshFooterUI then _G.RefreshFooterUI() end
end

-- ==================== UI SYSTEM ====================
local C = {
    BG = Color3.fromRGB(15, 15, 15), Surface = Color3.fromRGB(25, 25, 25), 
    Accent = Color3.fromRGB(60, 130, 250), Text = Color3.fromRGB(240, 240, 240),
    TextDim = Color3.fromRGB(150, 150, 150), Green = Color3.fromRGB(50, 200, 100)
}

local sg = Instance.new("ScreenGui", (gethui and gethui()) or CoreGui)
sg.Name = "AbramSliemFixed"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 350, 0, 450)
main.Position = UDim2.new(0.5, -175, 0.5, -225)
main.BackgroundColor3 = C.BG
main.BorderSizePixel = 0

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 10)

-- Tab logic & Building
local content = Instance.new("ScrollingFrame", main)
content.Size = UDim2.new(1, -20, 1, -60)
content.Position = UDim2.new(0, 10, 0, 50)
content.BackgroundTransparency = 1
content.CanvasSize = UDim2.new(0,0,2,0)
content.ScrollBarThickness = 2

local list = Instance.new("UIListLayout", content)
list.Padding = UDim.new(0, 5)

local function createToggle(name, label, key)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = C.Surface
    btn.Text = "  " .. label
    btn.Font = Enum.Font.GothamSemibold
    btn.TextColor3 = C.TextDim
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn)
    
    local indicator = Instance.new("Frame", btn)
    indicator.Size = UDim2.new(0, 10, 0, 10)
    indicator.Position = UDim2.new(1, -20, 0.5, -5)
    indicator.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)

    btn.MouseButton1Click:Connect(function()
        local newState = not State[key]
        toggleFeature(key, newState)
        btn.TextColor3 = newState and C.Text or C.TextDim
        indicator.BackgroundColor3 = newState and C.Green or Color3.new(0.2, 0.2, 0.2)
    end)
end

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ABRAM SLIEM FIXED"
title.TextColor3 = C.Accent
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1

-- Add Toggles
createToggle("Roll", "Auto Roll", "AutoRoll")
createToggle("Farm", "Auto Farm (Loot)", "AutoFarm")
createToggle("Kill", "Auto Kill Enemies", "AutoKill")
createToggle("Zone", "Auto Best Zone", "AutoTeleportBestZone")
createToggle("Potions", "Auto Use Potions", "AutoPotions")
createToggle("Index", "Auto Claim Index", "AutoIndex")
createToggle("Upgrade", "Auto Upgrade", "AutoUpgrade")
createToggle("Buy", "Auto Buy Zones", "AutoBuyZone")
createToggle("Rebirth", "Auto Rebirth", "AutoRebirth")

-- Drag & Toggle Menu
local dragging, dragInput, dragStart, startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.LeftAlt then main.Visible = not main.Visible end
end)

Notify("Success", "Script Loaded! Press Left ALT to hide/show")
