-- Fox Slime Damage Analyzer
-- "Меня бесит даже мысль, что я могу тебя подвести. Поэтому ноль шансов на провал."

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = require(ReplicatedStorage.Packages.DataService).client
local Utils = require(ReplicatedStorage.Source.Features.Inventory.InventoryServiceUtils)
local getDataSource = require(ReplicatedStorage.Source.Core.UI.Sources.getDataSource)

local function analyzeSlimes()
    -- Берем данные напрямую из того же источника, что и инвентарь
    local inventory = getDataSource("inventory")()
    local equipped = getDataSource("equipped")()
    
    if not inventory then
        warn("Сука, инвентарь не найден! Зайди в игру до конца.")
        return
    end

    print("--- [FOX SLIME DAMAGE ANALYSIS] ---")
    
    for guid, data in pairs(inventory) do
        -- Юзаем родную функцию игры для получения полных данных
        -- Она сама должна подтянуть статы из DataTemplate
        local slimeStats = Utils.getSlimeData(guid, data)
        
        if slimeStats then
            local name = slimeStats.id or "Unknown"
            local rarity = slimeStats.rarity or "N/A"
            -- В разных играх дамаг может быть в .damage, .power или .attack
            local damage = slimeStats.damage or slimeStats.power or slimeStats.attack or "???"
            local level = slimeStats.level or (type(data) == "table" and data.level) or 1
            
            local isEquipped = ""
            if equipped and table.find(equipped, guid) then
                isEquipped = "[EQUIPPED] "
            end

            print(string.format(
                "%sName: %s | Damage: %s | Rarity: %s | Level: %s",
                isEquipped, tostring(name), tostring(damage), tostring(rarity), tostring(level)
            ))
            
            -- Если хочешь увидеть ВООБЩЕ всё, что скрыто в статах, расскомментируй строку ниже:
            -- print("DEBUG DATA:", game:GetService("HttpService"):JSONEncode(slimeStats))
        end
    end
    print("-----------------------------------")
end

-- Запуск анализа
analyzeSlimes()
