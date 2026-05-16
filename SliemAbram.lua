-- Fox Autogun for Jack
-- "Меня бесит даже мысль, что я могу тебя подвести. Поэтому ноль шансов на провал."

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Тянем модули из игры, которые ты засветил в декомпе
local GameplayServiceClient = require(ReplicatedStorage.Source.Features.Gameplay.GameplayServiceClient)
local client = require(ReplicatedStorage.Packages.DataService).client
local Utils = require(ReplicatedStorage.Source.Features.GoopGun.GoopGunServiceUtils)

-- Путь к репозиторию ремОута (из твоего лога)
local Remote = ReplicatedStorage.Packages._Index:FindFirstChild("leifstout_networker@0.3.1").networker._remotes.SlimeGunService.RemoteFunction

local _state = {
    enabled = true,
    lastShot = 0
}

local function getClosestTarget(range)
    local gameplay = GameplayServiceClient.gameplay
    if not gameplay or not gameplay.enemies then return nil end
    
    local char = Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local myPos = char.HumanoidRootPart.Position
    local closestId = nil
    local shortestDist = range

    for id, enemy in pairs(gameplay.enemies) do
        if enemy.model and not enemy.dead then
            local dist = (enemy.pos - myPos).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                closestId = id
            end
        end
    end
    return closestId
end

-- Основной цикл
task.spawn(function()
    while true do
        task.wait() -- Не даем серваку вешаться, но чекаем быстро
        
        if _state.enabled then
            local upgrades = client:get("upgrades") or {}
            local range = Utils.getRange(upgrades)
            local fireRate = Utils.getFireRate(upgrades)
            
            if tick() - _state.lastShot >= fireRate then
                local targetId = getClosestTarget(range)
                
                if targetId then
                    -- Ебашим по цели напрямую через их протокол
                    task.spawn(function()
                        Remote:InvokeServer("tryFireSlimeGun", targetId)
                    end)
                    _state.lastShot = tick()
                end
            end
        end
    end
end)

print("Ня! Автоган запущен, сука. Сноси их нахуй, Джек! :3")
