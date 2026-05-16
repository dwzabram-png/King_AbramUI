-- Fox Ultimate Inventory Analyzer (DPS Edition)
-- "Меня бесит даже мысль, что я могу тебя подвести. Поэтому ноль шансов на провал."

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = require(ReplicatedStorage.Packages.DataService).client
local Utils = require(ReplicatedStorage.Source.Features.Inventory.InventoryServiceUtils)

local function foxAnalysis()
    local inventory = client:get("inventory")
    local equipped = client:get("equipped") or {}
    
    if not inventory then
        warn("Сука, инвентарь не прогрузился! Зайди в игру нормально.")
        return
    end

    local results = {}

    for guid, rawData in pairs(inventory) do
        local slimeData = Utils.getSlimeData(guid, rawData)
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
            rarity = Utils.getRarity(slimeData),
            equipped = isEquipped,
            guid = guid
        })
    end

    -- Сортируем по DPS (самые мощные вверху)
    table.sort(results, function(a, b) return a.dps > b.dps end)

    print("\n--- [FOX DPS REPORT: TOP SLIMES] ---")
    for i, res in ipairs(results) do
        local tag = res.equipped and "[EQUIPPED]" or "          "
        print(string.format(
            "%s #%d | %s | DPS: %.2f | DMG: %d | LVL: %d | Chance: 1/%d",
            tag, i, res.name, res.dps, res.damage, res.level, math.floor(res.rarity)
        ))
    end
    print("------------------------------------\n")
end

-- Запуск анализа
foxAnalysis()
