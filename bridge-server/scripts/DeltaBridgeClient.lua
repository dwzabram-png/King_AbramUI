--[[
    King AbramUI – Delta Bridge Client
    For Delta Mobile Executor (UNC Standard)

    IMPORTANT: This script is designed for MOBILE ONLY.
    - NO UserInputService KeyCodes
    - NO keyboard shortcuts
    - ONLY TouchTap, GUI buttons, ContextActionService for mobile touch
    
    Usage:
    1. Start bridge-server on your PC/VPS
    2. Set BRIDGE_URL below to your public tunnel URL
    3. Execute this script in Delta Mobile
]]

-- ══════════════════════════════════════════════════════════════════════
-- CONFIGURATION – Set your bridge server URL here
-- ══════════════════════════════════════════════════════════════════════
local BRIDGE_URL = "https://da443506404a-tunnel-wtuzd4aw.devinapps.com" -- Replace with your tunnel URL
local BRIDGE_USER = "user" -- Basic Auth username (leave "" if no auth)
local BRIDGE_PASS = "5571bcdcd0160a12caa9acf30ae7d166" -- Basic Auth password (leave "" if no auth)
local POLL_INTERVAL = 2 -- seconds between polls
local SESSION_PING_INTERVAL = 10 -- seconds between keep-alive pings

-- ══════════════════════════════════════════════════════════════════════
-- Services (mobile-safe only)
-- ══════════════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ══════════════════════════════════════════════════════════════════════
-- HTTP Helpers (UNC-compliant: uses request/http_request/syn.request)
-- ══════════════════════════════════════════════════════════════════════
local httpRequest = (request or http_request or (syn and syn.request) or http)

local function base64encode(str)
    local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    return (str:gsub(".", function(x)
        local r, byte = "", x:byte()
        for i = 8, 1, -1 do r = r .. (byte % 2 ^ i - byte % 2 ^ (i - 1) > 0 and "1" or "0") end
        return r
    end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(x)
        if #x < 6 then return "" end
        local c = 0
        for i = 1, 6 do c = c + (x:sub(i, i) == "1" and 2 ^ (6 - i) or 0) end
        return b:sub(c + 1, c + 1)
    end) .. ({  "", "==", "=" })[#str % 3 + 1]
end

local function buildHeaders()
    local headers = {
        ["Content-Type"] = "application/json",
        ["Bypass-Tunnel-Reminder"] = "true",
    }
    if BRIDGE_USER ~= "" and BRIDGE_PASS ~= "" then
        headers["Authorization"] = "Basic " .. base64encode(BRIDGE_USER .. ":" .. BRIDGE_PASS)
    end
    return headers
end

local function makeRequest(method, endpoint, body)
    local url = BRIDGE_URL .. endpoint
    local success, response = pcall(function()
        if type(httpRequest) == "function" then
            return httpRequest({
                Url = url,
                Method = method,
                Headers = buildHeaders(),
                Body = body and HttpService:JSONEncode(body) or nil,
            })
        end
        return nil
    end)

    if not success or not response then
        warn("[Bridge] Request failed: " .. tostring(response))
        return nil, "Request failed"
    end

    if response.StatusCode and response.StatusCode ~= 200 then
        warn("[Bridge] HTTP " .. tostring(response.StatusCode) .. ": " .. tostring(response.Body):sub(1, 100))
    end

    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)

    if ok then
        return decoded, nil
    end
    warn("[Bridge] JSON decode failed, raw: " .. tostring(response.Body):sub(1, 200))
    return nil, "JSON decode failed"
end

-- ══════════════════════════════════════════════════════════════════════
-- Session Management
-- ══════════════════════════════════════════════════════════════════════
local sessionId = HttpService:GenerateGUID(false)

local function getDeviceInfo()
    return {
        player = player.Name,
        userId = player.UserId,
        placeId = game.PlaceId,
        gameId = game.GameId,
        executor = (identifyexecutor and identifyexecutor()) or "Unknown",
        platform = "Mobile",
    }
end

local function pingSession()
    makeRequest("POST", "/api/session/ping", {
        sessionId = sessionId,
        deviceInfo = getDeviceInfo(),
    })
end

-- ══════════════════════════════════════════════════════════════════════
-- Script Execution Engine
-- ══════════════════════════════════════════════════════════════════════
local function executeScript(scriptData)
    local scriptId = scriptData.id or "unknown"
    local code = scriptData.script

    local success, result = pcall(function()
        local fn, err = loadstring(code)
        if not fn then
            error("Compile error: " .. tostring(err))
        end
        return fn()
    end)

    -- Report result back to bridge
    makeRequest("POST", "/api/result", {
        scriptId = scriptId,
        success = success,
        output = success and tostring(result or "OK") or "",
        error = not success and tostring(result) or nil,
    })

    return success, result
end

-- ══════════════════════════════════════════════════════════════════════
-- Polling Loop
-- ══════════════════════════════════════════════════════════════════════
local bridgeActive = true

local function pollLoop()
    while bridgeActive do
        local data, err = makeRequest("GET", "/api/pull", nil)
        if data and data.ok and data.script then
            executeScript(data)
        end
        task.wait(POLL_INTERVAL)
    end
end

local function pingLoop()
    while bridgeActive do
        pingSession()
        task.wait(SESSION_PING_INTERVAL)
    end
end

-- ══════════════════════════════════════════════════════════════════════
-- Mobile GUI (Touch-only controls – NO keyboard input)
-- ══════════════════════════════════════════════════════════════════════
local function createBridgeGUI()
    -- Clean up existing
    local existing = playerGui:FindFirstChild("BridgeGUI")
    if existing then existing:Destroy() end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BridgeGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    -- Drag state
    local dragging = false
    local dragStart, startPos

    -- Main container (draggable)
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 220, 0, 160)
    frame.Position = UDim2.new(1, -230, 0, 60)
    frame.BackgroundColor3 = Color3.fromRGB(13, 17, 23)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(48, 54, 61)
    stroke.Thickness = 1
    stroke.Parent = frame

    -- Title bar (drag handle)
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 32)
    titleBar.BackgroundColor3 = Color3.fromRGB(22, 27, 34)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = "Bridge"
    titleLabel.Size = UDim2.new(1, -40, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(88, 166, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- Drag functionality (TOUCH only)
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- Status indicator
    local statusDot = Instance.new("Frame")
    statusDot.Name = "StatusDot"
    statusDot.Size = UDim2.new(0, 8, 0, 8)
    statusDot.Position = UDim2.new(1, -20, 0.5, -4)
    statusDot.BackgroundColor3 = Color3.fromRGB(35, 134, 54)
    statusDot.BorderSizePixel = 0
    statusDot.Parent = titleBar
    Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

    -- Status text
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Text = "Connected"
    statusLabel.Size = UDim2.new(1, -20, 0, 20)
    statusLabel.Position = UDim2.new(0, 10, 0, 36)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.fromRGB(139, 148, 158)
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 11
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = frame

    -- Toggle button (TOUCH TAP to pause/resume)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "ToggleBtn"
    toggleBtn.Text = "Pause"
    toggleBtn.Size = UDim2.new(0.45, 0, 0, 32)
    toggleBtn.Position = UDim2.new(0.025, 0, 1, -44)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(218, 54, 51)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = frame
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

    toggleBtn.TouchTap:Connect(function()
        bridgeActive = not bridgeActive
        if bridgeActive then
            toggleBtn.Text = "Pause"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(218, 54, 51)
            statusDot.BackgroundColor3 = Color3.fromRGB(35, 134, 54)
            statusLabel.Text = "Connected"
            -- Restart loops
            task.spawn(pollLoop)
            task.spawn(pingLoop)
        else
            toggleBtn.Text = "Resume"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(35, 134, 54)
            statusDot.BackgroundColor3 = Color3.fromRGB(218, 54, 51)
            statusLabel.Text = "Paused"
        end
    end)

    -- Close button (TOUCH TAP)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Text = "Close"
    closeBtn.Size = UDim2.new(0.45, 0, 0, 32)
    closeBtn.Position = UDim2.new(0.525, 0, 1, -44)
    closeBtn.BackgroundColor3 = Color3.fromRGB(48, 54, 61)
    closeBtn.TextColor3 = Color3.fromRGB(201, 209, 217)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = frame
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

    closeBtn.TouchTap:Connect(function()
        bridgeActive = false
        screenGui:Destroy()
    end)

    -- Minimize toggle via ContextActionService (mobile touch button)
    local minimized = false
    local contentVisible = true

    ContextActionService:BindAction("BridgeMinimize", function(_, state)
        if state == Enum.UserInputState.Begin then
            minimized = not minimized
            if minimized then
                frame.Size = UDim2.new(0, 220, 0, 32)
            else
                frame.Size = UDim2.new(0, 220, 0, 160)
            end
        end
    end, true, Enum.KeyCode.Unknown)

    return screenGui
end

-- ══════════════════════════════════════════════════════════════════════
-- Initialization
-- ══════════════════════════════════════════════════════════════════════
local function init()
    print("[Bridge] King AbramUI Delta Bridge Client v1.0")
    print("[Bridge] Session: " .. sessionId)
    print("[Bridge] Target: " .. BRIDGE_URL)

    -- Initial ping
    pingSession()

    -- Create mobile GUI
    createBridgeGUI()

    -- Start background loops
    task.spawn(pollLoop)
    task.spawn(pingLoop)

    print("[Bridge] Ready! Polling for scripts...")
end

init()
