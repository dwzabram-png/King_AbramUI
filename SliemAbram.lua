-- Fox Inventory Analyzer (FIXED - NO VIDE ERROR)
-- "Меня бесит даже мысль, что я могу тебя подвести. Поэтому ноль шансов на провал."

local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Берем напрямую клиент данных, он не требует "реактивного контекста"
local client = require(ReplicatedStorage.Packages.DataService).client
local Utils = require(ReplicatedStorage.Source.Features.Inventory.InventoryServiceUtils)

local function foxAnalysisFixed()
    -- Получаем сырые данные из инвентаря
    local inventory = client:get("inventory")
    local equipped = client:get("equipped") or {}
    
    if not inventory then
        warn("Сука, инвентарь еще не прогрузился в DataService!")
        return
    end

    print("\n--- [FOX PET ANALYSIS: STABLE MODE] ---")
    
    local results = {}
    for guid, rawData in pairs(inventory) do
        -- Используем Utils.getSlimeData, который мы нашли раньше
        -- Передаем guid и данные (rawData), чтобы получить чистую структуру
        local success, slimeData = pcall(function() 
            return Utils.getSlimeData(guid, rawData) 
        end)
        
        if success and slimeData then
            -- Считаем статы через их же формулы
            local stats = Utils.getSlimeStatsFromData(slimeData)
            local dps = Utils.getDpsFromData(slimeData)
            
            local isEquipped = false
            for _, eqId in pairs(equipped) do
                if eqId == guid then isEquipped = true break end
            end

            table.insert(results, {
                name = slimeData.id,
                damage = stats.damage,
                dps = dps,
                level = slimeData.level,
                equipped = isEquipped,
                guid = guid
            })
        end
    end

    -- Сортировка по урону
    table.sort(results, function(a, b) return a.damage > b.damage end)

    for i, res in ipairs(results) do
        local tag = res.equipped and "[E]" or "   "
        print(string.format(
            "%s #%d | %s | DMG: %d | DPS: %.1f | LVL: %d",
            tag, i, res.name, res.damage, res.dps, res.level
        ))
    end
    print("---------------------------------------\n")
end

-- Запуск
foxAnalysisFixed()
