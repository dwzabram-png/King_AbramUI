-- Deobfuscated from king_legacy_obf.lua (NTT Obf v8.35.9)
-- Source SHA256: 429f89f5a8d1ff5221de45ad15a13d66acb540784324cf9c252911b0baeebdcd
-- Note: _G.index_key and loader guard checks have been removed for standalone execution.

_G.sharehash = "ver01"
NP7K8k = _G.xxxxx
_G.name_game = "King Legacy414" .. game.Players.LocalPlayer.Name
_G.Setting = {
    galefirst = {false},
    onracewheninboss = {false},
    delele_lag = {true},
    lowhealth_doodge = {70},
    webhook_item = {"Enter"},
    webhook_material = {"Enter"},
    webhook_onof = {false},
    candy = {false},
    pearlhop = {false},
    autoexe = {false},
    event1 = {false},
    event2 = {false},
    event3 = {false},
    event4 = {false},
    sbv3 = {false},
    tp_prl = {false},
    depthking = {false},
    hopdepthking = {false},
    bt = {false},
    tricster = {false},
    maintool = {Combat = true, Sword = true, ["Fruit Power"] = true},
    tradekey_select = {"Key : Select"},
    tradekey = {false},
    time_hop = {10},
    notjoinsamesv = {true},
    hop_preranodon = {false},
    hop_setsail = {false},
    hop_serpent = {false},
    hop_bigmom = {false},
    materialmulti = {false},
    dodge_dungeon = {true},
    bsaber = {false},
    buychest = {false},
    bringfruit = {false},
    log = {false},
    setsailvip = {false},
    ptevip = {false},
    serpentvip = {false},
    sbp = {false},
    ally = {false},
    material_multi = {["1"] = {}, ["2"] = {}, ["3"] = {}},
    dungeon_tool = {Combat = true, Sword = true, ["Fruit Power"] = true},
    dungeon_melee = {Z = true, X = true, C = true, V = true, B = true, E = true},
    dungeon_fruit = {Z = true, X = true, C = true, V = true, B = true, E = true},
    dungeon_sword = {Z = true, X = true},
    dungeon_option = {false},
    safezone = {true},
    onrace = {true},
    memory = {4000},
    dungeon_reset = {true},
    serpent_tool = {"Set Tool Sword : None"},
    blacklist = {},
    conquest = {false},
    conquest_hop = {false},
    try = {false},
    tool_select = {"Tool : Combat"},
    level = {false},
    mobnear = {false},
    mobnear_value = {400},
    material_select = {"Material : Select"},
    material = {false},
    pearl = {false},
    dailyquest = {false},
    melee = {false},
    defense = {false},
    sword = {false},
    fruit = {false},
    y = {9},
    skill_melee = {Z = true, X = true, C = true, V = true, B = true, E = true},
    skill_fruit = {Z = true, X = true, C = true, V = true, B = true, E = true},
    skill_sword = {Z = true, X = true},
    autorejoin = {false},
    blackscreen = {false},
    boss_select = {"Boss : Select"},
    boss = {false},
    boss_multi = {["1"] = {}, ["2"] = {}, ["3"] = {}},
    bossmulti = {false},
    bossquest = {true},
    serpent = {false},
    preranodon = {false},
    saber = {false},
    skhd = {true},
    dragon = {false},
    gs = {true},
    bigmom = {false},
    oden = {false},
    setsail = {false},
    ship = {false},
    islandrace = {false},
    lordsaber = {false},
    dungeon_select = {"Dungeon : Hard"},
    dungeon = {false},
    dungeon_race = {35},
    dungeon_attack = {500},
    dungeon_y = {9},
    esp_prl = {false},
    esp_fruit = {false},
    dungeon = {false},
    fish_cf = {"CFrame : 0,0,0"},
    fish = {false},
    combat_player = {"Player : Select"},
    aimskill = {false},
    aimskill_near = {false},
    aimskill_value = {400},
    aimcamara = {false},
    aimcamara_near = {false},
    aimcamara_value = {400},
    combattool_multi = {Combat = true, Sword = true, ["Fruit Power"] = true},
    shop_select1 = {"Key : Select"},
    shop_value = {1},
    buykey = {false},
    shop_select2 = {"Key : Select"},
    shop_value2 = {1},
    randomfruit = {false},
    randomfruitx10 = {false},
    storagefruit = {true},
    server_live = {"Server Live : Select"},
    island_select = {"Island : Select"},
    npc_select = {"NPC : Select"},
    water = {false},
    walkspeed = {false},
    jumpower = {false},
    infjump = {false},
    jump_value = {35},
    speed_value = {100},
    kioru = {false}
}
function ZrEkwD()
    if game.PlaceId == 4520749081 then
        return 1
    elseif game.PlaceId == 6381829480 then
        return 2
    elseif game.PlaceId == 15759515082 then
        return 3
    end
    return nil
end
XZV = tostring(ZrEkwD())
function unWA(t, value)
    if type(t) ~= "table" then
        return nil
    end
    for i, v in ipairs(t) do
        if v == value then
            return i
        end
    end
    return nil
end
QS3 = {
    ["1"] = {
    {"Rusted Scrap", "Clown Swordman [Lv. 50]", CFrame.new(-764, 97, -3546)},
    {"Fresh Fish", "Fighter Fishman [Lv. 180]", CFrame.new(-856, 52, -1422)},
    {"Leather", "Commander [Lv. 100]", CFrame.new(-2122, 92, -2549)},
    {"Thief's rag", "Desert Marauder [Lv. 675]", CFrame.new(-2750, 73, -777)},
    {"Angellic's Feather", "Sky Soldier [Lv. 800]", CFrame.new(-4589, 222, 1151)},
    {"Gunpowder", "Naval personnel [Lv. 1200]", CFrame.new(-1308, 69, 2148)},
    {"Undead's Ooze", "Zombie [Lv. 1500]", CFrame.new(-2789, 16, 4188)},
    {"Twilight's Orb", "Shadow Master [Lv. 1650]", CFrame.new(-2849, 20, 4319)},
    {"Shark's Canine", "Seasoned Fishman [Lv. 2200]", CFrame.new(-1801, 40, 6451)}
},
    ["2"] = {
    {"Iron", "Dead Troupe [Lv. 3800]", CFrame.new(9716, 93, -4292)},
    {"Rusted Scrap", "Beast Pirate [Lv. 2250]", CFrame.new(-4114, 57, 113)},
    {"Carrot", "Beast Pirate [Lv. 2250]", CFrame.new(-4114, 57, 113)},
    {"Samurai Badage", "Violet Samurai [Lv. 2500]", CFrame.new(-4969, 105, -1007)},
    {"Bread Crumbs", "Chess Soldier [Lv. 3200]", CFrame.new(-7, 77, 8164)},
    {"Ice Cystal", "Azlan [Lv. 3300]", CFrame.new(-832, 69, -2860)},
    {"Magma Cystal", "The Volcano [Lv. 3325]", CFrame.new(-152, 173, -3579)},
    {"Essence of Fire", "Flame User [Lv. 3200]", CFrame.new(1990, 35, 1419)},
    {"Lost Ruby", "Pharaoh [Lv. 3175]", CFrame.new(2048, 49, 1632)},
    {"Pile of Bones", "Skull Pirate [Lv. 3050]", CFrame.new(-6400, 78, 6907)},
    {"Dragon's Orb", "Elite Skeleton [Lv. 3100]", CFrame.new(-5926, 98, 7183)},
    {"Lucidus's Totem", "Hefty [Lv. 3550]", CFrame.new(-9993, 87, 421)},
    {"Dark Beard's Totem", "Supreme Swordman [Lv. 3425]", CFrame.new(-9647, 114, -4483)}
},
    ["3"] = {
    {"Sea Artifact", "Depths Voyager [Lv. 5300]", CFrame.new(-9855, 94, 12383)},
    {"Essence of Fire", "Allosaurus [Lv. 5350]", CFrame.new(-10682, 185, 12081)},
    {"Shark's Fin", "Fishman Guardian [Lv. 4150]", CFrame.new(1786, 66, 86)},
    {"Leather", "Wilderness Gorilla [Lv. 4325]", CFrame.new(4865, 45, 9876)},
    {"Shark's Canine", "Tidal Warrior [Lv. 4450]", CFrame.new(-506, 26, -8673)},
    {"Coral", "Depths Voyager [Lv. 5300]", CFrame.new(-9855, 94, 12383)},
    {"Pearl", "Depths Voyager [Lv. 5300]", CFrame.new(-9855, 94, 12383)}
}
}
x132c = {
    ["1"] = {
    {"Smoky [Lv. 20]", CFrame.new(-2065, 99, -4686)},
    {"Tashi [Lv. 30]", CFrame.new(-2270, 109, -4548)},
    {"The Clown [Lv. 75]", CFrame.new(-397, 114, -3436)},
    {"Captain [Lv. 120]", CFrame.new(-2122, 92, -2549)},
    {"The Barbaric [Lv. 145]", CFrame.new(-2375, 139, -2419)},
    {"Karate Fishman [Lv. 200]", CFrame.new(-856, 52, -1422)},
    {"Shark Man [Lv. 230]", CFrame.new(-666, 56, -1493)},
    {"Dark Leg [Lv. 300]", CFrame.new(-4217, 162, -2899)},
    {"King Snow [Lv. 450]", CFrame.new(-5519, 40, -1557)},
    {"Little Dear [Lv. 500]", CFrame.new(-5467, 55, -1104)},
    {"Bomb Man [Lv. 625]", CFrame.new(-2956, 92, -602)},
    {"King of Sand [Lv. 725]", CFrame.new(-3021, 92, -545)},
    {"Ball Man [Lv. 850]", CFrame.new(-4076, 433, 1344)},
    {"Rumble Man [Lv. 950]", CFrame.new(-4076, 433, 1344)},
    {"Leader [Lv. 1100]", CFrame.new(1897, 12, 749)},
    {"Pasta [Lv. 1150]", CFrame.new(1523, 27, 1167)},
    {"Wolf [Lv. 1250]", CFrame.new(-1308, 69, 2148)},
    {"Giraffe [Lv. 1300]", CFrame.new(-1204, 69, 2100)},
    {"Leo [Lv. 1450]", CFrame.new(-1256, 167, 2585)},
    {"Shadow Master [Lv. 1650]", CFrame.new(-2849, 20, 4319)},
    {"True Karate Fishman [Lv. 1850]", CFrame.new(2471, 103, -1938)},
    {"Quake Woman [Lv. 1925]", CFrame.new(2285, 49, -1908)},
    {"Combat Fishman [Lv. 2050]", CFrame.new(-1956, 55, 6236)},
    {"Sword Fishman [Lv. 2100]", CFrame.new(-1635, 96, 6688)},
    {"Seasoned Fishman [Lv. 2200]", CFrame.new(-1801, 40, 6451)}
},
    ["2"] = {
    {"Gazelle Man [Lv. 2350]", CFrame.new(-4363, 57, 252)},
    {"Violet Samurai [Lv. 2500]", CFrame.new(-4969, 105, -1007)},
    {"Duke [Lv. 2550]", CFrame.new(-5434, 100, -228)},
    {"Magician [Lv. 2600]", CFrame.new(-5048, 105, -154)},
    {"Kitsune Samurai [Lv. 2650]", CFrame.new(-5452, 100, 16)},
    {"Bear Man [Lv. 2750]", CFrame.new(-4438, 53, 775)},
    {"Bean [Lv. 2800]", CFrame.new(-4018, 68, 904)},
    {"Meji [Lv. 2850]", CFrame.new(-5302, 83, 1163)},
    {"Petra [Lv. 2900]", CFrame.new(-5857, 80, 1308)},
    {"Kappa [Lv. 2950]", CFrame.new(-4853, 109, 1926)},
    {"Joey [Lv. 3000]", CFrame.new(-5287, 57, 2066)},
    {"Elite Skeleton [Lv. 3100]", CFrame.new(-5926, 98, 7183)},
    {"Desert Thief [Lv. 3125]", CFrame.new(1575, 53, 1513)},
    {"Anubis [Lv. 3150]", CFrame.new(1964, 48, 899)},
    {"Pharaoh [Lv. 3175]", CFrame.new(2048, 49, 1632)},
    {"Sunken Vessel [Lv. 3225]", CFrame.new(-986, 83, 8169)},
    {"Biscuit Man [Lv. 3250]", CFrame.new(-1375, 202, 8860)},
    {"Dough Master [Lv. 3275]", CFrame.new(30370, 106, 93598)},
    {"Supreme Swordman [Lv. 3425]", CFrame.new(-9647, 114, -4483)},
    {"Sally [Lv. 3450]", CFrame.new(-9584, 135, -5374)},
    {"Pondere [Lv. 3525]", CFrame.new(-10142, 100, 1298)},
    {"Hefty [Lv. 3550]", CFrame.new(-10489, 84, 969)},
    {"Lomeo [Lv. 3675]", CFrame.new(6487, 72, -2135)},
    {"Prince Aria [Lv. 3700]", CFrame.new(6785, 150, -3794)},
    {"Devastate [Lv. 3725]", CFrame.new(7632, 122, -2644)},
    {"Floffy [Lv. 3775]", CFrame.new(7865, 462, -2529)},
    {"Ryu [Lv. 3975]", CFrame.new(9927, 86, -4856)}
},
    ["3"] = {
    {"Fugitive [Lv. 4050]", CFrame.new(2888, 35, 993)},
    {"The deep one [Lv. 4200]", CFrame.new(2833, 35, 136)},
    {"Cyborg Gorilla [Lv. 4375]", CFrame.new(5784, 45, 9463)},
    {"Ripcurrent Raider [Lv. 4400]", CFrame.new(-506, 26, -8673)},
    {"Tidal Warrior [Lv. 4450]", CFrame.new(-73, 96, -8404)},
    {"Ocean Gladiator [Lv. 4500]", CFrame.new(-22, 44, -9066)},
    {"Electro Abyss Warrior [Lv. 4600]", CFrame.new(-5230, 22, 964)},
    {"Inferno Diver [Lv. 4650]", CFrame.new(-6044, 54, 467)},
    {"Tempest Tidebreaker [Lv. 4700]", CFrame.new(-7296, 42, 469)},
    {"Abyssal Swordsman [Lv. 4750]", CFrame.new(-8255, 186, 455)},
    {"Prisoner of Gravity [Lv. 4875]", CFrame.new(12436, 79, 1052)},
    {"Nightbound Explorer [Lv. 5150]", CFrame.new(-8634, 235, 11395)},
    {"Allosaurus [Lv. 5350]", CFrame.new(-10548, 248, 11940)},
    {"Spinosaurus [Lv. 5400]", CFrame.new(-10655, 177, 10159)}
}
}
EcUA = game.Workspace.SpawnItem
caMR = {
    ["1"] = {
    ["Kill 20 Soldiers"] = {{0, "mob"}, "Soldier [Lv. 1]", CFrame.new(-1965, 50, -4504)},
    ["Forget and Forgot"] = {{5, "talk"}, "Civilian Old"},
    ["Venture Lagoons!"] = {
    {10, "ship"},
    CFrame.new(-2066, 17, -4015),
    function()
    game.ReplicatedStorage.Chest.Remotes.Events.Ship:FireServer("Rowboat", "ShipA")
end,
    function()
    for W, U in pairs(EcUA:GetChildren()) do
        if U.Name == "Venture Lagoons!" and U:FindFirstChild("LeePunggQuestTracker") then
            return U.CFrame
        end
    end
end
},
    ["Tomb Raiding!"] = {{50, "mob"}, "Shadow Master [Lv. 1650]", CFrame.new(-2849, 20, 4319)},
    ["Dead Walking"] = {{100, "mob"}, "Zombie [Lv. 1500]", CFrame.new(-2789, 16, 4188)},
    ["Kill 4 King Snow"] = {{500, "mob"}, "King Snow [Lv. 450]", CFrame.new(-5519, 40, -1557)},
    ["Kill 10 Soldier Fishman"] = {{2000, "mob"}, "Soldier Fishman [Lv. 2150]", CFrame.new(-1801, 40, 6451)}
},
    ["2"] = {
    ["Bone Hunter"] = {
    {3000, "fp"},
    function()
    for z, O in pairs(EcUA:GetChildren()) do
        if O.Name == "Bone Hunter" and O.PromptQuest.Enabled then
            return {O.CFrame, O.PromptQuest}
        end
    end
end
},
    ["Box Box!"] = {
    {3000, "box"},
    function()
    local d = game.Workspace.SpawnItem.Box
    return {d.CFrame, d:FindFirstChildWhichIsA("ProximityPrompt")}
end,
    "Civilian Port"
},
    ["Catch me,If you can"] = {
    {3000, "fp"},
    function()
    for S, N in pairs(EcUA:GetChildren()) do
        if N.Name == "Catch me,If you can" then
            return {N.CFrame, N.PromptQuest}
        end
    end
end
},
    ["Dead Above"] = {
    {3000, "fp"},
    function()
    for S, O in pairs(EcUA:GetChildren()) do
        if O.Name == "Floating Feather" and O.ProximityPrompt.Enabled then
            return {O.CFrame, O.ProximityPrompt}
        end
    end
end
},
    ["I'm not,YOU ARE!"] = {
    {3000, "tp"},
    function()
    for v, V in pairs(EcUA:GetChildren()) do
        if V.Name == "I'm not,YOU ARE!" and V:FindFirstChild("LeePunggQuestTracker") then
            return V.CFrame
        end
    end
end
},
    ["Left to Dead"] = {{3000, "mob"}, "Dead Troupe Captain [Lv. 3850]", CFrame.new(10021, 102, -3947)},
    ["One More Time"] = {{3000, "mob"}, "Joey [Lv. 3000]", CFrame.new(-5287, 57, 2066)},
    ["Order Disobey"] = {
    {3000, "fp"},
    function()
    for T, Z in pairs(EcUA:GetChildren()) do
        if Z.Name == "PosterQuest" and Z.ProximityPrompt.Enabled then
            return {Z.CFrame, Z.ProximityPrompt}
        end
    end
end
},
    ["Under The Sea~"] = {
    {3000, "tp"},
    function()
    for e, C in pairs(EcUA:GetChildren()) do
        if C.Name == "Under The Sea~" and C:FindFirstChild("LeePunggQuestTracker") then
            return C.CFrame
        end
    end
end
},
    Believer = {{3500, "mob"}, "Hefty [Lv. 3550]", CFrame.new(-10489, 84, 969)},
    ["Left For Dead?"] = {{3500, "mob"}, "Dead Troupe Captain [Lv. 3850]", CFrame.new(10021, 102, -3947)},
    ["Is it Thriller?"] = {{3500, "mob"}, "Skull Pirate [Lv. 3050]", CFrame.new(-6400, 78, 6907)},
    ["The Lost Book"] = {
    {3500, "fp"},
    function()
    local B = game.Workspace.Island["H - Fiore"]["Lost Book"].Main
    return {B.CFrame, B.ProximityPrompt}
end
}
},
    ["3"] = {
    ["Hide'n Seek!"] = {
    {4000, "fp"},
    function()
    for e, X in pairs(EcUA:GetChildren()) do
        if X.Name == "Hide'n Seek!" and (X.PromptQuest:FindFirstChild("Hide'n Seek!") and X.PromptQuest["Hide'n Seek!"].Enabled or not X.PromptQuest:FindFirstChild("Hide'n Seek!")) then
            return {X.CFrame, X.PromptQuest}
        end
    end
end
},
    ["Into the Bubble-Verse"] = {{4000, "mob"}, "Cyborg Gorilla [Lv. 4375]", CFrame.new(5784, 45, 9463)},
    ["Mossy Must Gone"] = {
    {4000, "fp"},
    function()
    for U, F in pairs(game.Workspace.SpawnItem:GetChildren()) do
        if F.Name == "Mossy Must Gone" and F.PromptQuest.Enabled == true then
            return {F.CFrame, F.PromptQuest}
        end
    end
end
},
    Redemption = {{4000, "mob"}, "Fugitive [Lv. 4050]", CFrame.new(2888, 35, 993)},
    ["Rolling in the Depth"] = {{4000, "mob"}, "Deep Diver [Lv. 4000]", CFrame.new(1674, 47, 1015)},
    ["The Pillar"] = {
    {4000, "fp"},
    function()
    for C, o in pairs(EcUA:GetChildren()) do
        if o.Name == "The Pillar" then
            return {o.CFrame, o.PromptQuest}
        end
    end
end
},
    ["Until Pond"] = {{4000, "mob"}, "Ocean Gladiator [Lv. 4500]", CFrame.new(-22, 44, -9066)},
    ["Krakenci Codes (Easy)"] = {
    {4000, "code"},
    function()
    return {[1] = "Submit", [2] = {[1] = "Fallen", [2] = "Dark", [3] = "Heroic"}}
end
},
    ["Krakenci Codes (Medium)"] = {
    {4000, "code"},
    function()
    return {[1] = "Submit", [2] = {[1] = "Moon", [2] = "Savior", [3] = "Bright"}}
end
},
    ["Krakenci Codes (Hard)"] = {
    {4000, "code"},
    function()
    return {[1] = "Submit", [2] = {[1] = "Fearful", [2] = "Moon", [3] = "Night"}}
end
}
}
}
WAP = {
    ["1"] = {},
    ["2"] = {
    "QuestKioru",
    {
    ["Kappa [Lv. 2950]"] = (CFrame.new(-4845.7, 53.9, 2005)),
    ["Anubis [Lv. 3150]"] = (CFrame.new(2108, 11, 958)),
    ["Flame User [Lv. 3200]"] = (CFrame.new(2031.2, 14.6, 1354.4)),
    ["Sunken Vessel [Lv. 3225]"] = (CFrame.new(-1102, 50.9, 8234.8)),
    ["Biscuit Man [Lv. 3250]"] = (CFrame.new(-1532.7, 188.6, 8864.6)),
    ["Dough Master [Lv. 3275]"] = (CFrame.new(30279.0, 69.3, 93166.2))
}
},
    ["3"] = {
    {"Tyrant Slayer", "Krakenbane", "Shellbreaker", "Dragonbane"},
    function()
    for Q, J in pairs(WAP[1]) do
        if not string.find(game.Players.LocalPlayer.PlayerStats.TitleStore.Value, J) then
            return false
        end
    end
    return true
end,
    function()
    if game.Players.LocalPlayer.PlayerStats.beli.Value >= 55555555 then
        return true
    end
end,
    function()
    local h = {}
    h[34] = "Buy Kioru V2"
    local s = {}
    s.Price = 55555555
    s.TextSuccess = "<AnimateStyle=Rainbow>Successfully purchased a sword."
    s.TextNoMoney = "<AnimateStyle=Appear><Color=Red>Not enough Money $!"
    h[89] = s
    local y = h
    game.ReplicatedStorage.Chest.Remotes.Functions.EtcFunction:InvokeServer(y[34], y[89])
end
}
}
WAP = WAP[XZV]
caMR = caMR[XZV]
x132c = x132c[XZV]
HVxJpFD = {}
RoVthRM = {}
for d, x in ipairs(x132c) do
    _G.Setting.boss_multi[XZV][x[1]] = true
    table.insert(HVxJpFD, x[1])
    RoVthRM[x[1]] = x[2]
end
QS3 = QS3[XZV]
ZhZ6gDx = {}
Gktt = {}
for v, C in ipairs(QS3) do
    _G.Setting.material_multi[XZV][C[1]] = false
    table.insert(ZhZ6gDx, C[1])
    Gktt[C[1]] = {C[2], C[3]}
end
local function S()
    if readfile and (writefile and (isfile and isfolder)) then
        if not isfolder("NTT HUB") then
            makefolder("NTT HUB")
        end
        if not isfolder("NTT HUB/Save Script/") then
            makefolder("NTT HUB/Save Script/")
        end
        local i = "NTT HUB/Save Script/" .. _G.name_game .. ".json"
        if not isfile(i) or readfile(i) == "" then
            writefile(i, (game:GetService("HttpService")):JSONEncode(_G.Setting))
        else
            local I, m = pcall(function()
                return (game:GetService("HttpService")):JSONDecode(readfile(i))
            end)
            if I then
                for Q, i in pairs(m) do
                    _G.Setting[Q] = i
                end
            else
                writefile(i, (game:GetService("HttpService")):JSONEncode(_G.Setting))
            end
        end
    else
        return warn("Status : Undetected Executor")
    end
end
local function k()
    if readfile and (writefile and (isfile and isfolder)) then
        local W = "NTT HUB/Save Script/" .. _G.name_game .. ".json"
        if not isfile(W) then
            S()
        else
            local a = {}
            for q, B in pairs(_G.Setting) do
                a[q] = B
            end
            writefile(W, (game:GetService("HttpService")):JSONEncode(a))
        end
    else
        return warn("Status : Undetected Executor")
    end
end
S()
if _G.linkdis == nil then
    _G.linkdis = 111
end
if _G.Setting.notjoinsamesv then
    _G.Setting.blacklist[game.JobId] = os.time() + 30 * 60
    k()
end
local a = Instance.new("ScreenGui")
local D = Instance.new("Frame")
local f = Instance.new("TextLabel")
local E, d, N, F, j, u, m, y, w, q, C, z, e, P, df = (function(E, e)
    local function o(w)
        if w > e then
            return
        end
        return Instance.new(E), o(w + 1)
    end
    return o(1)
end)("ScrollingFrame", 15)
local dJ = Instance.new("Frame")
local G = Instance.new("ScrollingFrame")
RoxmfX4 = Instance.new("Frame")
local J, o, V, l, g, p, Y, r, Q, H, B, T, dd, dD, dV = (function(U, m)
    local function T(O)
        if O > m then
            return
        end
        return Instance.new(U), T(O + 1)
    end
    return T(1)
end)("TextButton", 15)
do
    local V = getfenv(0)
    V.lwIi8X = Instance.new("TextLabel")
    V.YfPq = Instance.new("TextButton")
    V.baT = Instance.new("TextLabel")
    V.BVXcF = Instance.new("TextButton")
end
do
    local w = getfenv(0)
    local Q = {
        "Ej5gcuj",
        "ifb8r",
        "main_bar3",
        "Ye6",
        "Q1R",
        "abDo",
        "uMwvU9s",
        "WiPQGL",
        "x4BlU6C",
        "JsH8yG",
        "gt6",
        "IHYCP",
        "SbWtG",
        "JWtf",
        "dtRby",
        "rQm1",
        "ZzkMm",
        "tvPQxaS",
        "y2Q",
        "NRHQ",
        "main_f9",
        "main_b9",
        "main_f10",
        "main_b10",
        "main_f11",
        "main_b11",
        "main_f12",
        "main_b12",
        "z5YA4p5",
        "gAORC9",
        "zsKXhzA",
        "Ei4Z",
        "WkoYDr",
        "Flma6",
        "Iqz",
        "qlg2",
        "VMxe",
        "DjhW",
        "wUDIUl",
        "MCUs9",
        "main_f19",
        "main_b19"
    }
    local a = {
        "ScrollingFrame",
        "ScrollingFrame",
        "ScrollingFrame",
        "ScrollingFrame",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton"
    }
    for u = 1, #Q do
        w[Q[u]] = Instance.new(a[u])
    end
end
do
    local L = getfenv(0)
    local l = {"KfAj5u", "kxEgZ", "x7Z", "Wx2Nq", "XhnC", "eHDv", "eTHT1", "LOAARFi"}
    local J = {
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton"
    }
    for C = 1, #l do
        L[l[C]] = Instance.new(J[C])
    end
end
do
    local Y = getfenv(0)
    local S = {
        "Det",
        "setting_f1",
        "setting_b1",
        "JOan",
        "tDb",
        "jLEqE",
        "PQPf",
        "hXKn",
        "yTt2xsE",
        "q2V",
        "uTtoxT",
        "setting_f6",
        "setting_b6",
        "cBd",
        "IVYKUNC",
        "tA7",
        "TPOD",
        "vgYpr",
        "bWL7W",
        "qhLkJ",
        "YVImL",
        "Srgcl",
        "setting_b11",
        "lYxVuy",
        "xp9",
        "YYJv0g",
        "zex",
        "MOA"
    }
    local p = {
        "ScrollingFrame",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextBox",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextBox"
    }
    for I = 1, #S do
        Y[S[I]] = Instance.new(p[I])
    end
end
do
    local S = getfenv(0)
    local u = {
        "boss_bar1",
        "boss_bar2",
        "boss_bar3",
        "TG3WjP",
        "Z0pd",
        "hqkP0",
        "AFLa",
        "boss_f1",
        "boss_b1",
        "boss_f2",
        "boss_b2",
        "boss_f3",
        "boss_b3",
        "uuDRYjt",
        "XoW",
        "HK3y0AC",
        "Tmc04oo",
        "vIv8vw",
        "W6iSbh",
        "fX4",
        "NAiTNC",
        "VS0zW",
        "JCH8zYM"
    }
    local E = {
        "ScrollingFrame",
        "ScrollingFrame",
        "ScrollingFrame",
        "ScrollingFrame",
        "ScrollingFrame",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton"
    }
    for p = 1, #u do
        S[u[p]] = Instance.new(E[p])
    end
end
do
    local d = getfenv(0)
    local E = {
        "hop_f1",
        "hop_b1",
        "hop_f2",
        "hop_b2",
        "hop_f3",
        "hop_b3",
        "hop_f4",
        "hop_b4",
        "hop_f5",
        "hop_b5",
        "hop_f6",
        "hop_b6",
        "hop_f7",
        "hop_b7",
        "hop_f8",
        "hop_b8"
    }
    local O = {
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton"
    }
    for S = 1, #E do
        d[E[S]] = Instance.new(O[S])
    end
end
do
    local d = getfenv(0)
    local q = {
        "exBmb",
        "zTlq",
        "U1j",
        "DTM",
        "LJz8YL",
        "yGUOT",
        "FulA",
        "E1Qh",
        "qqgj",
        "nGhC2Ts",
        "TICE6z",
        "M3KATs",
        "J5ArWKb",
        "n3LTk4",
        "J6dO",
        "Ib8xIt",
        "Rx2Aw",
        "uv36Uf2",
        "TQMa3xn",
        "b8jhgS",
        "Pce9RTG",
        "qGYu5",
        "AB5",
        "c94p",
        "more_fss",
        "more_bss"
    }
    local v = {
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton"
    }
    for G = 1, #q do
        d[q[G]] = Instance.new(v[G])
    end
end
do
    local f = getfenv(0)
    local T = {
        "lGr1sdQ",
        "dungeon_bar2",
        "dungeon_bar3",
        "qPUPK0j",
        "dungeon_bar5",
        "dungeon_bar6",
        "zaHziH",
        "EMBvvfZ",
        "fUAnJ"
    }
    for r = 1, #T do
        f[T[r]] = Instance.new("ScrollingFrame")
    end
end
do
    local k = getfenv(0)
    local U = {
        "qW2PDV",
        "KQbOcTF",
        "docu7l",
        "rEXBRgt",
        "Pn47xxc",
        "aqCb1",
        "dungeon_f4",
        "dungeon_b4",
        "fAM9GUh",
        "UCF",
        "dungeon_f6",
        "dungeon_b6",
        "rh9",
        "Maq3",
        "dungeon_f8",
        "dungeon_b8",
        "wVD55",
        "Uc0IR4",
        "ZcHyIIU",
        "U10EOW",
        "Etpqd",
        "mWs",
        "UGFFw",
        "oea",
        "MecB0gz",
        "JnZaG"
    }
    local F = {
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton"
    }
    for G = 1, #U do
        k[U[G]] = Instance.new(F[G])
    end
end
do
    local k = getfenv(0)
    local w = {"FwoQh", "QvL1iXj", "KmUyZ", "uj2Cz", "zYLcKM", "pRclNCR", "esp_f4", "esp_b4"}
    local Z = {
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton"
    }
    for O = 1, #w do
        k[w[O]] = Instance.new(Z[O])
    end
end
do
    local i = getfenv(0)
    local B = {"rx8yb", "lJ5", "KnjHkVw", "NxLc6Z", "fish_f3", "fish_b3", "fish_f4", "fish_b4"}
    local H = {
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton"
    }
    for k = 1, #B do
        i[B[k]] = Instance.new(H[k])
    end
end
do
    local H = getfenv(0)
    local U = {
        "wCamL",
        "combat_bar2",
        "rpSKWh0",
        "rm2",
        "bgzaueM",
        "ud8",
        "ZZM",
        "BhQE",
        "DLd",
        "cLAaGu",
        "JTOYBv9",
        "zCXri6",
        "bx2T",
        "f7ke",
        "combat_f7",
        "combat_b7",
        "combat_f8",
        "combat_b8",
        "Yx5rq",
        "NoA1Y"
    }
    local Z = {
        "ScrollingFrame",
        "ScrollingFrame",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton"
    }
    for t = 1, #U do
        H[U[t]] = Instance.new(Z[t])
    end
end
do
    local Z = getfenv(0)
    local y = {
        "fJ1LT",
        "nOf",
        "XvuVl0",
        "AoU",
        "gdT",
        "DolK6s",
        "WkR2",
        "oY1",
        "rYb",
        "c0QD6",
        "K6Y",
        "ofKfno",
        "PAp",
        "Ceq3Q",
        "yPQLx",
        "l1fY1vg",
        "TkX",
        "FFNf",
        "dSM"
    }
    local q = {
        "ScrollingFrame",
        "ScrollingFrame",
        "ScrollingFrame",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton"
    }
    for V = 1, #y do
        Z[y[V]] = Instance.new(q[V])
    end
end
do
    local z = getfenv(0)
    local C = {
        "dVpU0a",
        "nNMaxA",
        "lTRRb63",
        "l0usBw",
        "YlLHx",
        "JJ3mCm",
        "D1EWeMa",
        "khLPr",
        "server_f5",
        "server_b5",
        "WxBjB"
    }
    local f = {
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextBox"
    }
    for X = 1, #C do
        z[C[X]] = Instance.new(f[X])
    end
end
JsMdqzQ = Instance.new("TextLabel")
hWBqTv = Instance.new("TextButton")
do
    local J = getfenv(0)
    J.pKZ2 = Instance.new("ScrollingFrame")
    J.OC2 = Instance.new("TextLabel")
    J.JURCj = Instance.new("TextButton")
end
do
    local B = getfenv(0)
    local v = {"AF5oiMV", "E0r", "PJFep", "zqo0a", "JZDorn9", "XojDUC", "DoeGOpP", "Kpc", "epb", "FDr"}
    local O = {
        "ScrollingFrame",
        "ScrollingFrame",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton"
    }
    for A = 1, #v do
        B[v[A]] = Instance.new(O[A])
    end
end
do
    local F = getfenv(0)
    local y = {
        "xTrF8t",
        "rj9E4oi",
        "m4IqmpZ",
        "z4U",
        "XLdIu",
        "eTzC",
        "gM9Z",
        "B42",
        "prl_f5",
        "prl_b5",
        "prl_f6",
        "prl_b6"
    }
    local p = {
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton"
    }
    for J = 1, #y do
        F[y[J]] = Instance.new(p[J])
    end
end
do
    local Y = getfenv(0)
    local I = {
        "vlQQdOg",
        "JiVYr",
        "rymnCU",
        "Rb2MMiG",
        "Ops",
        "tpnaD",
        "jqN0L",
        "Rc7G",
        "xGN",
        "YkgFP",
        "TKD",
        "UM2oYoO",
        "item_f7",
        "item_b7",
        "item_f8",
        "item_b8",
        "item_f9",
        "item_b9",
        "item_f10",
        "item_b10",
        "item_f11",
        "item_b11",
        "item_f12",
        "item_b12",
        "item_f13",
        "item_b13",
        "item_f14",
        "item_b14",
        "item_f15",
        "item_b15",
        "item_f16",
        "item_b16",
        "item_f17",
        "item_b17",
        "item_f18",
        "item_b18",
        "item_f19",
        "item_b19",
        "item_f20",
        "item_b20"
    }
    local e = {
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton"
    }
    for h = 1, #I do
        Y[I[h]] = Instance.new(e[h])
    end
end
do
    local o = getfenv(0)
    local z = {"lwIi8X", "YfPq", "baT", "BVXcF", "n6p", "VKe", "event_f4", "event_b4"}
    local v = {
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton",
        "TextLabel",
        "TextButton"
    }
    for i = 1, #z do
        o[z[i]] = Instance.new(v[i])
    end
end
local function dE()
    if type(k) == "function" then
        local C, W = pcall(k)
        if not C then
            warn("NTT UI: không lưu được settings: " .. tostring(W))
        end
    end
end
function z6xv6W(A)
    spawn(function()
        for R = 1, 20 do
            A.Rotation = R * 18
            task.wait(16 / 1000)
        end
        A.Rotation = 0
    end)
end
function nKFGU0v(w)
    if w == "fake" then
        return false
    end
    local G = type(_G.Setting) == "table" and _G.Setting[w]
    if type(G) == "table" then
        return G[1]
    end
    return nil
end
function XJb0c(s, V)
    local v = type(_G.Setting) == "table" and _G.Setting[s]
    if type(v) ~= "table" then
        return false
    end
    v[1] = V
    dE()
    return true
end
_G._ = nKFGU0v
local dW = {}
local de = {
    "ScreenGui",
    "UICorner",
    "UIStroke",
    "UIListLayout",
    "UIPadding",
    "UIScale",
    "Frame",
    "ScrollingFrame",
    "TextLabel",
    "TextButton",
    "TextBox",
    "ImageLabel",
    "ImageButton",
    "ViewportFrame",
    "VideoFrame",
    "CanvasGroup"
}
local dz = {}
for L, G in ipairs(de) do
    dz[G] = true
end
function DIrCT(className)
    if not dz[className] then
        return nil
    end
    if not dW[className] then
        dW[className] = Instance.new(className)
    end
    return dW[className]
end
local function db(gui)
    local ok = pcall(function()
        gui.Parent = game:GetService("CoreGui")
    end)
    if not ok then
        gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
end
function iRuP(screenGui)
    screenGui.Name = "name1"
    screenGui.ResetOnSpawn = false
    screenGui.Enabled = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    db(screenGui)
end
local v
_G.ntt_select_arrows = {}
_G.ntt_pending_select_arrow = nil
local function dF(btn, arrow)
    _G.ntt_select_arrows = _G.ntt_select_arrows or {}
    table.insert(_G.ntt_select_arrows, arrow)
    btn.InputBegan:Connect(function()
        _G.ntt_pending_select_arrow = arrow
    end)
    btn.MouseButton1Down:Connect(function()
        _G.ntt_pending_select_arrow = arrow
    end)
end
function ec4rNnE(target)
    return target
end
_G.ntt_autopos = function(F)
    local a = 0.001
    local Y = {0.001}
    for o = 1, 99 do
        table.insert(Y, a + F * o)
    end
    return Y
end
local dt = 6
local U = setmetatable({}, {__mode = "k"})
local function ds(y)
    local F = 1
    local X = y
    while X do
        if X:IsA("GuiObject") then
            for d, u in ipairs(X:GetChildren()) do
                if u:IsA("UIScale") then
                    F = F * u.Scale
                end
            end
        end
        if X:IsA("ScreenGui") then
            break
        end
        X = X.Parent
    end
    return math.max(1 / 1000, F)
end
local function X(H, S)
    if not H then
        return nil
    end
    local Q = H:FindFirstChildOfClass("UIListLayout")
    if not Q then
        Q = Instance.new("UIListLayout")
        Q.Name = "AutoVerticalLayout"
        Q.Parent = H
    end
    Q.FillDirection = Enum.FillDirection.Vertical
    Q.SortOrder = Enum.SortOrder.LayoutOrder
    Q.HorizontalAlignment = Enum.HorizontalAlignment.Left
    Q.VerticalAlignment = Enum.VerticalAlignment.Top
    Q.Padding = UDim.new(0, S or dt)
    local R = U[H]
    if R and R.layout == Q then
        R.refresh()
        return Q
    end
    if R then
        R.cleanup()
    end
    local i = 0
    for o, X in ipairs(H:GetChildren()) do
        if X:IsA("GuiObject") then
            i = i + 1
            X.LayoutOrder = i
        end
    end
    local f = {layout = Q, connections = {}, queued = false, destroyed = false}
    local V = f.connections
    local function C()
        if f.destroyed or (not H.Parent or Q.Parent ~= H) then
            return
        end
        if not H:IsA("ScrollingFrame") then
            return
        end
        local E = H.AbsoluteWindowSize.Y
        if E <= 0 then
            E = H.AbsoluteSize.Y
        end
        if E <= 0 or not H.Visible then
            return
        end
        local m = ds(H)
        local L = Q.AbsoluteContentSize.Y / m
        local v = E / m
        local t = 12
        local P = math.ceil(math.max(v, L + t))
        local i = UDim2.fromOffset(0, P)
        if H.CanvasSize ~= i then
            H.CanvasSize = i
        end
        local C = math.max(P * m - E, 0)
        if H.CanvasPosition.Y > C + 1 then
            H.CanvasPosition = Vector2.new(H.CanvasPosition.X, C)
        end
    end
    f.refresh = function()
        if f.queued or f.destroyed then
            return
        end
        f.queued = true
        task.defer(function()
            f.queued = false
            C()
        end)
    end
    f.cleanup = function()
        f.destroyed = true
        for U, O in pairs(V) do
            O:Disconnect()
        end
        if U[H] == f then
            U[H] = nil
        end
    end
    U[H] = f
    V.childAdded = H.ChildAdded:Connect(function(v)
        if v:IsA("GuiObject") then
            i = i + 1
            v.LayoutOrder = i
        end
        f.refresh()
    end)
    V.childRemoved = H.ChildRemoved:Connect(f.refresh)
    V.destroying = H.Destroying:Connect(f.cleanup)
    if H:IsA("ScrollingFrame") then
        H.Active = true
        H.ScrollingEnabled = true
        H.ScrollingDirection = Enum.ScrollingDirection.Y
        H.AutomaticCanvasSize = Enum.AutomaticSize.None
        H.ClipsDescendants = true
        V.contentChanged = (Q:GetPropertyChangedSignal("AbsoluteContentSize")):Connect(f.refresh)
        V.frameResized = (H:GetPropertyChangedSignal("AbsoluteSize")):Connect(f.refresh)
        V.windowResized = (H:GetPropertyChangedSignal("AbsoluteWindowSize")):Connect(f.refresh)
        V.visibleChanged = (H:GetPropertyChangedSignal("Visible")):Connect(f.refresh)
        V.ancestryChanged = H.AncestryChanged:Connect(f.refresh)
        local i = H
        while i do
            if i:IsA("GuiObject") then
                for Q, z in ipairs(i:GetChildren()) do
                    if z:IsA("UIScale") then
                        table.insert(V, (z:GetPropertyChangedSignal("Scale")):Connect(f.refresh))
                    end
                end
            end
            if i:IsA("ScreenGui") then
                break
            end
            i = i.Parent
        end
    end
    f.refresh()
    return Q
end
_G.ntt_mainscrollingframe = {}
function BVj99Ic(a, e, h)
    _G.ntt_mainscrollingframe = _G.ntt_mainscrollingframe or {}
    local F, U = false, false
    for X, h in ipairs(_G.ntt_mainscrollingframe) do
        if h == a then
            U = true
        elseif h.Parent == e then
            F = true
        end
    end
    if not U then
        table.insert(_G.ntt_mainscrollingframe, a)
    end
    a.Name = "Page"
    a.Parent = e
    a.Active = true
    a.BackgroundColor3 = Color3.fromRGB(235, 220, 255)
    a.BackgroundTransparency = 0
    a.BorderSizePixel = 0
    a.Size = UDim2.new(0, 498, 0, 230)
    a.Position = UDim2.new(205 / 1000, 0, 13285722 / 100000000, 0)
    a.Visible = h == true or h == nil and not F
    a.ScrollingEnabled = true
    a.ScrollingDirection = Enum.ScrollingDirection.Y
    a.ScrollBarThickness = 4
    a.AutomaticCanvasSize = Enum.AutomaticSize.None
    a.CanvasSize = UDim2.new(0, 0, 0, 0)
    X(a, 4)
    local n = Instance.new("UICorner")
    n.CornerRadius = UDim.new(0, 10)
    n.Parent = a
    local m = Instance.new("UIStroke")
    m.Color = Color3.fromRGB(150, 100, 220)
    m.Thickness = 1
    m.Parent = a
end
function NKyikD0(parent, title)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.BackgroundColor3 = Color3.fromRGB(150, 100, 220)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(0, 498, 0, 30)
    label.BorderColor3 = Color3.fromRGB(150, 100, 220)
    label.Font = Enum.Font.SourceSansBold
    label.Text = title
    label.TextColor3 = Color3.fromRGB(250, 250, 250)
    label.TextSize = 18
    label.TextWrapped = true
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = label
    return label
end
function TwA9(btn, parent, title)
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(220, 200, 255)
    btn.Position = UDim2.new(0, 0, 0, 0)
    btn.Size = UDim2.new(0, 120, 0, 30)
    btn.Font = Enum.Font.Ubuntu
    btn.BorderColor3 = Color3.fromRGB(150, 100, 220)
    btn.Text = " " .. tostring(title)
    btn.TextColor3 = Color3.fromRGB(50, 10, 80)
    btn.TextSize = 14
    btn.TextWrapped = false
    btn.TextXAlignment = Enum.TextXAlignment.Left
end
function d8pV(label, btn, parent, title, settingKey)
    label.Parent = parent
    label.BackgroundColor3 = Color3.fromRGB(240, 230, 255)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(0, 498, 0, 30)
    label.BorderColor3 = Color3.fromRGB(150, 100, 220)
    label.Font = Enum.Font.Ubuntu
    label.Text = " " .. tostring(title)
    label.TextColor3 = Color3.fromRGB(50, 10, 80)
    label.TextSize = 14
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    local c1 = Instance.new("UICorner")
    c1.CornerRadius = UDim.new(0, 8)
    c1.Parent = label
    btn.Name = "name2"
    btn.Parent = label
    btn.BackgroundColor3 = Color3.fromRGB(130, 80, 200)
    btn.Position = UDim2.new(0.94, 0, 0.12, 0)
    btn.Size = UDim2.new(0, 20, 0, 20)
    btn.BorderColor3 = Color3.fromRGB(150, 100, 220)
    btn.Font = Enum.Font.GothamBold
    btn.Text = ""
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.TextScaled = true
    btn.ClipsDescendants = true
    local c2 = Instance.new("UICorner")
    c2.CornerRadius = UDim.new(0, 6)
    c2.Parent = btn
    local enabled = nKFGU0v(settingKey) == true
    if enabled then
        btn.Text = "X"
    end
    btn.MouseButton1Down:Connect(function()
        enabled = not enabled
        btn.Text = enabled and "X" or ""
        XJb0c(settingKey, enabled)
    end)
end
function bUQMb1C(container, btn, toggleBtn, parent, title, posY, settingKey)
    container.Parent = parent
    container.BackgroundColor3 = Color3.fromRGB(235, 220, 255)
    container.Position = UDim2.new(0, 0, posY or 0, 0)
    container.Size = UDim2.new(0, 498, 0, 30)
    container.Font = Enum.Font.Ubuntu
    container.BackgroundTransparency = 1
    container.Text = ""
    container.TextColor3 = Color3.fromRGB(50, 10, 80)
    container.TextSize = 14
    container.TextWrapped = true
    container.TextXAlignment = Enum.TextXAlignment.Left
    btn.Name = "name2"
    btn.Parent = container
    btn.BackgroundColor3 = Color3.fromRGB(220, 200, 255)
    btn.Size = UDim2.new(0, 350, 0, 30)
    btn.BorderColor3 = Color3.fromRGB(150, 100, 220)
    btn.Font = Enum.Font.SourceSans
    btn.Text = " " .. tostring(title)
    btn.TextColor3 = Color3.fromRGB(50, 10, 80)
    btn.TextSize = 18
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Active = true
    local c1 = Instance.new("UICorner")
    c1.CornerRadius = UDim.new(0, 8)
    c1.Parent = btn
    local arrow = Instance.new("TextLabel")
    arrow.Name = "SelectArrow"
    arrow.Parent = btn
    arrow.Size = UDim2.new(0, 30, 0, 30)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(130, 80, 200)
    arrow.TextSize = 20
    arrow.BackgroundTransparency = 1
    arrow.ZIndex = btn.ZIndex + 1
    arrow.AnchorPoint = Vector2.new(1, 0)
    arrow.Position = UDim2.new(1, 0, 0, 0)
    dF(btn, arrow)
    if toggleBtn and typeof(toggleBtn) == "Instance" then
        toggleBtn.Name = "name3"
        toggleBtn.Parent = container
        toggleBtn.BackgroundColor3 = Color3.fromRGB(130, 80, 200)
        toggleBtn.Position = UDim2.new(0.94, 0, 0.12, 0)
        toggleBtn.Size = UDim2.new(0, 20, 0, 20)
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.Text = nKFGU0v(settingKey) and "X" or ""
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleBtn.TextSize = 14
        local c2 = Instance.new("UICorner")
        c2.CornerRadius = UDim.new(0, 6)
        c2.Parent = toggleBtn
    end
end
_G.ntt_farmain_table = {}
_G.ntt_frame = function(G, j)
    if not G or not G:IsA("GuiObject") then
        warn("ntt_frame: invalid GuiObject")
        return
    end
    local m = not G.Visible
    for T = 1, #_G.ntt_farmain_table do
        local U = _G.ntt_farmain_table[T]
        if U and U.Parent then
            U.Visible = false
        end
    end
    for r = 1, #_G.ntt_select_arrows do
        local g = _G.ntt_select_arrows[r]
        if g and g.Parent then
            g.Text = "▼"
        end
    end
    if m then
        G.Visible = true
        local B = j and j:FindFirstChild("SelectArrow") or _G.ntt_pending_select_arrow
        if B and B.Parent then
            B.Text = "▲"
        end
        X(G, 4)
    end
    _G.ntt_pending_select_arrow = nil
end
hj9MM = Instance.new("TextButton")
hj9MM.Name = "ntt_sframe"
hj9MM.Active = false
hj9MM.Selectable = false
hj9MM.AutoButtonColor = false
hj9MM.BackgroundColor3 = (Color3.fromRGB(240, 230, 255))
hj9MM.BackgroundTransparency = 1
hj9MM.BorderColor3 = (Color3.fromRGB(150, 100, 220))
hj9MM.Position = (UDim2.new(0.6, 0, 0.1, 0))
hj9MM.Size = (UDim2.new(0, 250, 0, 245))
hj9MM.ZIndex = 2
hj9MM.Text = ""
hj9MM.Visible = false
function qsGMDwP(P, Y)
    local L = Y or (v or (D or _G.mainframe))
    if not L then
        warn("make_selectscrollingframe: thiếu parent; truyền main vào tham số thứ hai")
        return
    end
    _G.ntt_farmain_table = _G.ntt_farmain_table or {}
    local y = false
    for g, a in ipairs(_G.ntt_farmain_table) do
        if a == P then
            y = true
            break
        end
    end
    if not y then
        table.insert(_G.ntt_farmain_table, P)
    end
    P.Name = "SelectMenu"
    P.Parent = L
    P.Active = true
    P.BackgroundColor3 = Color3.fromRGB(235, 220, 255)
    P.BorderColor3 = Color3.fromRGB(150, 100, 220)
    P.Position = UDim2.new(60 / 100, 0, 10 / 100, 0)
    P.Size = UDim2.new(0, 250, 0, 245)
    P.BorderSizePixel = 1
    local A = L:IsA("GuiObject") and L.ZIndex or 0
    P.ZIndex = math.max(A + 10, 10)
    P.Visible = false
    P.Draggable = false
    P.ScrollingEnabled = true
    P.ScrollingDirection = Enum.ScrollingDirection.Y
    P.ScrollBarThickness = 8
    P.ScrollBarImageTransparency = 0
    P.ScrollBarImageColor3 = Color3.fromRGB(130, 80, 200)
    P.AutomaticCanvasSize = Enum.AutomaticSize.None
    P.CanvasSize = UDim2.new(0, 0, 0, 0)
    X(P, 4)
    local R = Instance.new("UICorner")
    R.CornerRadius = UDim.new(0, 10)
    R.Parent = P
end
local h = game:GetService("UserInputService")
local dU = game:GetService("GuiService")
local A = game:GetService("Workspace")
local dG = Vector2.new(640, 280)
local function i()
    local q = A.CurrentCamera
    local B = q and q.ViewportSize or Vector2.new(1280, 720)
    local h, I = Vector2.new(0, 0), Vector2.new(0, 0)
    pcall(function()
        h, I = dU:GetGuiInset()
    end)
    return Vector2.new(h.X, h.Y), Vector2.new(math.max(h.X + 1, B.X - I.X), math.max(h.Y + 1, B.Y - I.Y))
end
local function L(w, W)
    if not w or not w.Parent then
        return
    end
    local N = w.AbsolutePosition
    local f = w.AbsoluteSize
    if f.X < 1 or f.Y < 1 then
        return
    end
    local n, H = i()
    W = W or 5
    local k = n.X + W
    local p = n.Y + W
    local s = math.max(k, H.X - (W - f.X))
    local R = math.max(p, H.Y - (W - f.Y))
    local Q = math.clamp(N.X, k, s)
    local x = math.clamp(N.Y, p, R)
    local e, Y = Q - N.X, x - N.Y
    if math.abs(e) > 0.5 or math.abs(Y) > 0.5 then
        local n = w.Position
        w.Position = UDim2.new(n.X.Scale, n.X.Offset + e, n.Y.Scale, n.Y.Offset + Y)
    end
end
local function dN(y, R, a, F)
    local E, k = i()
    local r = y.AbsoluteSize
    local g, f = E.X + 5, E.Y + 5
    local U = math.max(g, k.X - (r.X - 5))
    local Q = math.max(f, k.Y - (r.Y - 5))
    local I = math.clamp(a.X + F.X, g, U)
    local j = math.clamp(a.Y + F.Y, f, Q)
    return UDim2.new(R.X.Scale, R.X.Offset + (I - a.X), R.Y.Scale, R.Y.Offset + (j - a.Y))
end
local function du(R, y)
    local e
    local l
    local p
    local function f()
        if e then
            e:Disconnect()
            e = nil
        end
        local L = A.CurrentCamera
        if L then
            e = (L:GetPropertyChangedSignal("ViewportSize")):Connect(y)
        end
        y()
    end
    l = (A:GetPropertyChangedSignal("CurrentCamera")):Connect(f)
    p = R.Destroying:Connect(function()
        if e then
            e:Disconnect()
        end
        if l then
            l:Disconnect()
        end
        if p then
            p:Disconnect()
        end
    end)
    f()
end
local function dZ(B)
    local J = B:FindFirstChild("NTT_AutoScale")
    if not J or not J:IsA("UIScale") then
        J = Instance.new("UIScale")
        J.Name = "NTT_AutoScale"
        J.Parent = B
    end
    B.AnchorPoint = Vector2.new(0.5, 0.5)
    B.Position = UDim2.fromScale(0.5, 0.5)
    local function H()
        local d, n = i()
        local l = math.max(1, n.X - (d.X - 12))
        local b = math.max(1, n.Y - (d.Y - 12))
        local I = h.TouchEnabled
        local Z = I and 0.78 or 0.9
        local t = I and 0.7 or 0.85
        local q = math.min(1, l * (Z / dG.X), b * (t / dG.Y))
        J.Scale = math.max(0.1, q)
        task.defer(function()
            L(B, 5)
        end)
    end
    du(B, H);
    (B:GetPropertyChangedSignal("AbsoluteSize")):Connect(function()
        task.defer(function()
            L(B, 5)
        end)
    end)
    return J
end
function n4tSu(q, J, m, H, Y)
    local p = game:GetService("UserInputService")
    q.Name = "MainFrame"
    q.Parent = H
    q.BackgroundColor3 = Color3.fromRGB(240, 230, 255)
    q.Position = UDim2.new(180126051 / 1000000000, 0, 228999169 / 1000000000, 0)
    q.Size = UDim2.new(0, 640, 0, 280)
    q.BorderColor3 = Color3.fromRGB(150, 100, 220)
    q.Active = true
    q.Draggable = false
    q.Visible = false
    dZ(q)
    v = q
    hj9MM.Parent = q;
    (q:GetPropertyChangedSignal("Visible")):Connect(function()
        if q.Visible then
            for r, z in ipairs(q:GetDescendants()) do
                local R
                R = U[z]
                if R then
                    R.refresh()
                end
            end
        else
            for H, i in ipairs(_G.ntt_farmain_table) do
                if i:IsDescendantOf(q) then
                    i.Visible = false
                end
            end
        end
    end)
    J.Parent = q
    J.BackgroundColor3 = Color3.fromRGB(130, 80, 200)
    J.Position = UDim2.new(0, 0, 0, 0)
    J.Size = UDim2.new(0, 640, 0, 26)
    J.Font = Enum.Font.SourceSansBold
    J.Text = " " .. tostring(Y or "")
    J.TextColor3 = Color3.fromRGB(255, 255, 255)
    J.TextSize = 18
    J.TextWrapped = true
    J.TextXAlignment = Enum.TextXAlignment.Left
    J.BorderColor3 = Color3.fromRGB(150, 100, 220)
    J.Active = true
    m.Name = "TabList"
    m.Parent = q
    m.Active = true
    m.BackgroundColor3 = Color3.fromRGB(220, 200, 255)
    m.Position = UDim2.new(0, 0, 102285722 / 1000000000, 0)
    m.Size = UDim2.new(0, 120, 0, 250)
    m.BorderColor3 = Color3.fromRGB(150, 100, 220)
    m.ScrollBarThickness = 4
    m.ScrollingEnabled = true
    m.ScrollingDirection = Enum.ScrollingDirection.Y
    m.AutomaticCanvasSize = Enum.AutomaticSize.None
    m.CanvasSize = UDim2.new(0, 0, 0, 0)
    X(m, 4)
    local y, N, A, B
    J.InputBegan:Connect(function(k)
        if k.UserInputType ~= Enum.UserInputType.MouseButton1 and k.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        if y then
            return
        end
        y = k
        N = k.Position
        A = q.Position
        B = q.AbsolutePosition
    end)
    local G = p.InputChanged:Connect(function(T)
        if not y then
            return
        end
        if y.UserInputType == Enum.UserInputType.Touch then
            if T ~= y then
                return
            end
        elseif T.UserInputType ~= Enum.UserInputType.MouseMovement then
            return
        end
        local J = T.Position - N
        q.Position = dN(q, A, B, J)
    end)
    local Q = p.InputEnded:Connect(function(A)
        if y and (A == y or y.UserInputType == Enum.UserInputType.MouseButton1 and A.UserInputType == Enum.UserInputType.MouseButton1) then
            y = nil
        end
    end)
    q.Destroying:Connect(function()
        G:Disconnect()
        Q:Disconnect()
    end)
end
function y3wHE(container, btn, parent, title, posY)
    container.Parent = parent
    container.BackgroundColor3 = Color3.fromRGB(235, 220, 255)
    container.Position = UDim2.new(0, 0, posY or 0, 0)
    container.Size = UDim2.new(0, 498, 0, 30)
    container.Font = Enum.Font.Ubuntu
    container.BackgroundTransparency = 1
    container.Text = ""
    container.TextColor3 = Color3.fromRGB(50, 10, 80)
    container.TextSize = 14
    container.TextWrapped = true
    container.TextXAlignment = Enum.TextXAlignment.Left
    btn.Name = "name2"
    btn.Parent = container
    btn.BackgroundColor3 = Color3.fromRGB(220, 200, 255)
    btn.Size = UDim2.new(0, 350, 0, 30)
    btn.BorderColor3 = Color3.fromRGB(150, 100, 220)
    container.BorderSizePixel = 1
    btn.Font = Enum.Font.SourceSans
    btn.Text = " " .. tostring(title)
    btn.TextColor3 = Color3.fromRGB(50, 10, 80)
    btn.TextSize = 18
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Active = true
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    local arrow = Instance.new("TextLabel")
    arrow.Name = "SelectArrow"
    arrow.Parent = btn
    arrow.Size = UDim2.new(0, 30, 0, 30)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(130, 80, 200)
    arrow.TextSize = 20
    arrow.BackgroundTransparency = 1
    arrow.ZIndex = btn.ZIndex + 1
    arrow.AnchorPoint = Vector2.new(1, 0)
    arrow.Position = UDim2.new(1, 0, 0, 0)
    dF(btn, arrow)
end
function PYaeN7I(A, d, k, j, O)
    A.Name = "button"
    A.Parent = k
    A.BackgroundColor3 = Color3.fromRGB(240, 230, 255)
    A.Position = UDim2.new(0, 0, 0, 0)
    A.Size = UDim2.new(0, 498, 0, 30)
    A.BorderColor3 = Color3.fromRGB(150, 100, 220)
    A.Font = Enum.Font.Ubuntu
    A.Text = j
    A.TextColor3 = Color3.fromRGB(50, 10, 80)
    A.TextSize = 14
    A.TextWrapped = true
    A.TextXAlignment = Enum.TextXAlignment.Left
    local e = Instance.new("UICorner")
    e.CornerRadius = UDim.new(0, 8)
    e.Parent = A
    d.Name = "name2"
    d.Parent = A
    d.BackgroundColor3 = Color3.fromRGB(130, 80, 200)
    d.Position = UDim2.new(0.825, 0, 0.05, 0)
    d.Size = UDim2.new(0, 80, 0, 25)
    d.BorderColor3 = Color3.fromRGB(150, 100, 220)
    d.Font = Enum.Font.SourceSans
    d.Text = "Button"
    d.TextColor3 = Color3.fromRGB(255, 255, 255)
    d.TextSize = 16
    local U = Instance.new("UICorner")
    U.CornerRadius = UDim.new(0, 8)
    U.Parent = d
    d.MouseButton1Down:connect(function()
        O()
    end)
end
function rOr(textBox, parent, initialValue)
    textBox.Parent = parent
    textBox.BackgroundColor3 = Color3.fromRGB(250, 245, 255)
    textBox.Position = UDim2.new(0, 0, 0, 0)
    textBox.Size = UDim2.new(0, 498, 0, 30)
    textBox.BorderColor3 = Color3.fromRGB(150, 100, 220)
    textBox.Font = Enum.Font.Ubuntu
    textBox.Text = tostring(initialValue or "")
    textBox.TextColor3 = Color3.fromRGB(50, 10, 80)
    textBox.TextSize = 14
    textBox.TextWrapped = true
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = textBox
end
local function R(i, g)
    local k, z, m, o
    local P = false
    local d
    local function C()
        if d then
            d:Disconnect()
            d = nil
        end
    end
    local function V(s)
        if z and (math.abs(s.X - z.X) > 8 or math.abs(s.Y - z.Y) > 8) then
            P = true
        end
    end
    i.InputBegan:Connect(function(D)
        if D.UserInputType ~= Enum.UserInputType.MouseButton1 and D.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        C()
        k = D
        z = D.Position
        P = false
        m = i:FindFirstAncestorWhichIsA("ScrollingFrame")
        o = m and m.CanvasPosition.Y
        d = (D:GetPropertyChangedSignal("Position")):Connect(function()
            V(D.Position)
        end)
    end)
    i.MouseMoved:Connect(function(L, x)
        if k and k.UserInputState == Enum.UserInputState.Begin then
            V(Vector2.new(L, x))
        end
    end)
    i.Activated:Connect(function(e)
        if e and e == k then
            V(e.Position)
            local w = m and math.abs(m.CanvasPosition.Y - o) > 8
            C()
            if P or w then
                return
            end
        end
        g()
    end)
    i.Destroying:Connect(C)
end
function tocz5(i, Y, l, w)
    local T = w or l
    if type(T) ~= "table" then
        warn("tocz5: invalid table")
        return nil
    end
    local X = Instance.new("TextLabel")
    X.Parent = i
    X.ZIndex = i.ZIndex + 1
    X.BackgroundColor3 = Color3.fromRGB(240, 230, 255)
    X.Size = UDim2.new(0, 230, 0, 20)
    X.BorderColor3 = Color3.fromRGB(150, 100, 220)
    X.Font = Enum.Font.Ubuntu
    X.Text = tostring(Y)
    X.TextColor3 = Color3.fromRGB(50, 10, 80)
    X.TextSize = 14
    X.TextWrapped = true
    X.TextXAlignment = Enum.TextXAlignment.Left
    local v = Instance.new("UICorner")
    v.CornerRadius = UDim.new(0, 6)
    v.Parent = X
    local z = Instance.new("TextButton")
    z.Parent = X
    z.ZIndex = X.ZIndex + 1
    z.BackgroundColor3 = Color3.fromRGB(130, 80, 200)
    z.Position = UDim2.new(0.718, 0, 0, 0)
    z.Size = UDim2.new(0, 65, 0, 20)
    z.BorderColor3 = Color3.fromRGB(150, 100, 220)
    z.Font = Enum.Font.SourceSans
    z.TextColor3 = Color3.fromRGB(255, 255, 255)
    z.TextSize = 14
    local L = Instance.new("UICorner")
    L.CornerRadius = UDim.new(0, 6)
    L.Parent = z
    local function H()
        local G = T[X.Text] == true
        if G then
            z.Text = "On"
            z.BackgroundColor3 = Color3.fromRGB(130, 80, 200)
            z.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            z.Text = "Off"
            z.BackgroundColor3 = Color3.fromRGB(220, 200, 255)
            z.TextColor3 = Color3.fromRGB(50, 10, 80)
        end
    end
    H()
    R(z, function()
        T[X.Text] = not (T[X.Text] == true)
        H()
        dE()
    end)
    return X
end
function TPSg7ok(openBtn, scrollFrame, optionText, title, settingKey, order)
    local row = Instance.new("TextLabel")
    row.LayoutOrder = order or 1
    row.ZIndex = scrollFrame.ZIndex + 1
    row.Parent = scrollFrame
    row.BackgroundColor3 = Color3.fromRGB(240, 230, 255)
    row.Size = UDim2.new(0, 230, 0, 20)
    row.BorderColor3 = Color3.fromRGB(150, 100, 220)
    row.Font = Enum.Font.Ubuntu
    row.Text = tostring(optionText)
    row.TextColor3 = Color3.fromRGB(50, 10, 80)
    row.TextSize = 14
    row.TextWrapped = true
    row.TextXAlignment = Enum.TextXAlignment.Left
    local c1 = Instance.new("UICorner")
    c1.CornerRadius = UDim.new(0, 6)
    c1.Parent = row
    local btn = Instance.new("TextButton")
    btn.Parent = row
    btn.ZIndex = row.ZIndex + 1
    btn.BackgroundColor3 = Color3.fromRGB(130, 80, 200)
    btn.Position = UDim2.new(0.718, 0, 0, 0)
    btn.Size = UDim2.new(0, 65, 0, 20)
    btn.BorderColor3 = Color3.fromRGB(150, 100, 220)
    btn.Font = Enum.Font.SourceSans
    btn.Text = "Button"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    local c2 = Instance.new("UICorner")
    c2.CornerRadius = UDim.new(0, 6)
    c2.Parent = btn
    R(btn, function()
        openBtn.Text = " " .. tostring(title) .. " : " .. tostring(optionText)
        scrollFrame.Visible = false
        if settingKey then
            XJb0c(settingKey, openBtn.Text)
        end
        local arrow = openBtn:FindFirstChild("SelectArrow")
        if arrow then
            arrow.Text = "▼"
        end
    end)
    return row
end
local function dj(g, y)
    local p = Instance.new("TextLabel")
    p.Name = y
    p.BackgroundTransparency = 1
    p.Size = UDim2.new(0, 230, 0, 30)
    p.Font = Enum.Font.Ubuntu
    p.Text = "No options available"
    p.TextColor3 = Color3.fromRGB(50, 10, 80)
    p.TextSize = 14
    p.ZIndex = g.ZIndex + 1
    p.Parent = g
    return p
end
function hMR6c(D, f, W, k, j)
    if not f or not f:IsA("ScrollingFrame") then
        warn("make_auto_selectbutton: parent phải là ScrollingFrame")
        return
    end
    if type(W) ~= "table" then
        warn("make_auto_selectbutton: gettable phải là table")
        return
    end
    for o, b in ipairs(f:GetChildren()) do
        if b.Name == "__AutoSelectOption" then
            b:Destroy()
        end
    end
    X(f, 4)
    f.Active = true
    f.ScrollingEnabled = true
    f.ScrollingDirection = Enum.ScrollingDirection.Y
    f.AutomaticCanvasSize = Enum.AutomaticSize.None
    for Tf, TU in ipairs(W) do
        local W = Instance.new("TextLabel")
        W.Name = "__AutoSelectOption"
        W.LayoutOrder = Tf
        W.ZIndex = f.ZIndex + 1
        W.Parent = f
        W.BackgroundColor3 = Color3.fromRGB(240, 230, 255)
        W.Size = UDim2.new(0, 230, 0, 20)
        W.BorderColor3 = Color3.fromRGB(150, 100, 220)
        W.Font = Enum.Font.Ubuntu
        W.Text = tostring(TU)
        W.TextColor3 = Color3.fromRGB(50, 10, 80)
        W.TextSize = 14
        W.TextWrapped = true
        W.TextXAlignment = Enum.TextXAlignment.Left
        local Tw = Instance.new("UICorner")
        Tw.CornerRadius = UDim.new(0, 6)
        Tw.Parent = W
        local TT = Instance.new("TextButton")
        TT.Parent = W
        TT.ZIndex = W.ZIndex + 1
        TT.BackgroundColor3 = Color3.fromRGB(130, 80, 200)
        TT.Position = UDim2.new(718 / 1000, 0, 0, 0)
        TT.Size = UDim2.new(0, 65, 0, 20)
        TT.BorderColor3 = Color3.fromRGB(150, 100, 220)
        TT.Font = Enum.Font.SourceSans
        TT.Text = "Button"
        TT.TextColor3 = Color3.fromRGB(255, 255, 255)
        TT.TextSize = 14
        local Ty = Instance.new("UICorner")
        Ty.CornerRadius = UDim.new(0, 6)
        Ty.Parent = TT
        R(TT, function()
            local u
            D.Text = " " .. tostring(k) .. " : " .. tostring(TU)
            f.Visible = false
            if j then
                XJb0c(j, D.Text)
            end
            u = D:FindFirstChild("SelectArrow")
            if u then
                u.Text = "▼"
            end
        end)
    end
    if #W == 0 then
        dj(f, "__AutoSelectOption")
    end
    X(f, 4)
    return true
end
local dy = setmetatable({}, {__mode = "k"})
function TI9eG(d, C, k, R)
    local W = R or k
    if not d or not d:IsA("GuiObject") then
        warn("make_auto_selectbutton_v2: parent không hợp lệ")
        return
    end
    if type(C) ~= "table" then
        warn("make_auto_selectbutton_v2: gettable phải là table")
        return
    end
    if type(W) ~= "table" then
        warn("make_auto_selectbutton_v2: save phải là table")
        return
    end
    local S = dy[d]
    if S then
        for J, y in ipairs(S) do
            if y and y.Parent then
                y:Destroy()
            end
        end
    end
    X(d, 4)
    if d:IsA("ScrollingFrame") then
        d.Active = true
        d.ScrollingEnabled = true
        d.ScrollingDirection = Enum.ScrollingDirection.Y
        d.ScrollBarThickness = math.max(d.ScrollBarThickness, 8)
        d.AutomaticCanvasSize = Enum.AutomaticSize.None
    end
    local x = {}
    for h, g in ipairs(C) do
        local Z = tocz5(d, g, W)
        if Z then
            Z.LayoutOrder = h
            table.insert(x, Z)
        end
    end
    if #C == 0 then
        table.insert(x, dj(d, "__AutoSelectOptionV2"))
    end
    dy[d] = x
    X(d, 4)
    return true
end
function dqh4Sz(parent, title, minVal, maxVal, settingKey)
    local saved = tonumber(nKFGU0v(settingKey)) or minVal
    local currentVal = math.clamp(math.floor(saved + 0.5), minVal, maxVal)
    local row = Instance.new("TextLabel", parent)
    row.BackgroundColor3 = Color3.fromRGB(240, 230, 255)
    row.Position = UDim2.new(0, 0, 0, 0)
    row.Size = UDim2.new(0, 498, 0, 30)
    row.BorderColor3 = Color3.fromRGB(150, 100, 220)
    row.Font = Enum.Font.Ubuntu
    row.Text = ""
    row.TextColor3 = Color3.fromRGB(50, 10, 80)
    row.TextSize = 14
    row.TextWrapped = true
    row.TextXAlignment = Enum.TextXAlignment.Left
    local c1 = Instance.new("UICorner")
    c1.CornerRadius = UDim.new(0, 8)
    c1.Parent = row
    local bar = Instance.new("Frame", row)
    bar.AnchorPoint = Vector2.new(0.5, 0.5)
    bar.Position = UDim2.new(0.27, 0, 0.5, 0)
    bar.Size = UDim2.new(0.5, 0, 0, 6)
    bar.BackgroundColor3 = Color3.fromRGB(200, 180, 240)
    bar.BorderSizePixel = 0
    bar.Name = "Bar"
    local c2 = Instance.new("UICorner")
    c2.CornerRadius = UDim.new(1, 0)
    c2.Parent = bar
    local fill = Instance.new("Frame", bar)
    fill.BackgroundColor3 = Color3.fromRGB(130, 80, 200)
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.Name = "Fill"
    local c3 = Instance.new("UICorner")
    c3.CornerRadius = UDim.new(1, 0)
    c3.Parent = fill
    local knob = Instance.new("Frame", bar)
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new(0, 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(180, 130, 230)
    knob.BorderSizePixel = 0
    knob.Name = "Knob"
    local c4 = Instance.new("UICorner")
    c4.CornerRadius = UDim.new(1, 0)
    c4.Parent = knob
    local valueLabel = Instance.new("TextLabel", row)
    valueLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    valueLabel.Position = UDim2.new(0.85, 0, 0.5, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.TextColor3 = Color3.fromRGB(50, 10, 80)
    valueLabel.TextScaled = true
    valueLabel.Font = Enum.Font.Ubuntu
    valueLabel.TextXAlignment = Enum.TextXAlignment.Left
    valueLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
    local uis = game:GetService("UserInputService")
    local dragging = false
    local function setFraction(frac, save)
        frac = math.clamp(frac, 0, 1)
        local val = math.floor(minVal + (maxVal - minVal) * frac + 0.5)
        currentVal = val
        local displayFrac = (maxVal ~= minVal) and ((val - minVal) / (maxVal - minVal)) or 0
        fill.Size = UDim2.new(displayFrac, 0, 1, 0)
        knob.Position = UDim2.new(displayFrac, 0, 0.5, 0)
        valueLabel.Text = tostring(title) .. " : " .. tostring(val)
        if save then
            XJb0c(settingKey, val)
        end
    end
    knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    uis.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local width = bar.AbsoluteSize.X
            if width > 0 then
                setFraction((input.Position.X - bar.AbsolutePosition.X) / width, true)
            end
        end
    end)
    uis.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    local initFrac = (maxVal ~= minVal) and ((currentVal - minVal) / (maxVal - minVal)) or 0
    setFraction(initFrac, false)
end
local function dq(b)
    local h = b
    while h do
        if h.Name == "MainFrame" then
            return h
        else
            h = h.Parent
        end
    end
    return v or (D or _G.mainframe)
end
local function dC(menuFrame, openBtn, optionsList, populateFn)
    R(openBtn, function()
        if menuFrame.Visible then
            _G.ntt_frame(menuFrame, openBtn)
            return
        end
        local items = type(optionsList) == "function" and optionsList() or optionsList
        if populateFn(items) then
            _G.ntt_frame(menuFrame, openBtn)
        end
    end)
end
function m62Pr(menuFrame, rowContainer, openBtn, parent, title, optionsList, settingKey)
    local saved = nKFGU0v(settingKey)
    local displayText = (type(saved) == "string" and saved ~= "") and saved or title
    y3wHE(rowContainer, openBtn, parent, displayText, 0.1)
    qsGMDwP(menuFrame, dq(parent))
    dC(menuFrame, openBtn, optionsList, function(items)
        return hMR6c(openBtn, menuFrame, items, title, settingKey)
    end)
end
function QLZ(menuFrame, rowContainer, openBtn, parent, title, optionsList, saveTable)
    y3wHE(rowContainer, openBtn, parent, title, 0.52)
    qsGMDwP(menuFrame, dq(parent))
    dC(menuFrame, openBtn, optionsList, function(items)
        return TI9eG(menuFrame, items, saveTable)
    end)
end
local function da(title, message, onAccept)
    local tweenService = game:GetService("TweenService")
    local gui = Instance.new("ScreenGui")
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    db(gui)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 145)
    frame.Position = UDim2.new(1, 340, 1, -165)
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(55, 60, 75)
    stroke.Thickness = 1
    stroke.Parent = frame
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, -20, 0, 30)
    titleLbl.Position = UDim2.new(0, 10, 0, 8)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = tostring(title)
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.TextSize = 18
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = frame
    local bodyLbl = Instance.new("TextLabel")
    bodyLbl.Size = UDim2.new(1, -20, 0, 55)
    bodyLbl.Position = UDim2.new(0, 10, 0, 38)
    bodyLbl.BackgroundTransparency = 1
    bodyLbl.Text = tostring(message)
    bodyLbl.TextColor3 = Color3.fromRGB(190, 195, 205)
    bodyLbl.TextSize = 14
    bodyLbl.Font = Enum.Font.Gotham
    bodyLbl.TextWrapped = true
    bodyLbl.TextXAlignment = Enum.TextXAlignment.Left
    bodyLbl.TextYAlignment = Enum.TextYAlignment.Top
    bodyLbl.Parent = frame
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 90, 0, 32)
    closeBtn.Position = UDim2.new(1, -195, 1, -42)
    closeBtn.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
    closeBtn.Text = "Close"
    closeBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
    closeBtn.Font = Enum.Font.GothamMedium
    closeBtn.TextSize = 14
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = frame
    local cClose = Instance.new("UICorner", closeBtn)
    cClose.CornerRadius = UDim.new(0, 7)
    local acceptBtn = Instance.new("TextButton")
    acceptBtn.Size = UDim2.new(0, 90, 0, 32)
    acceptBtn.Position = UDim2.new(1, -100, 1, -42)
    acceptBtn.BackgroundColor3 = Color3.fromRGB(45, 120, 255)
    acceptBtn.Text = "Accept"
    acceptBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    acceptBtn.Font = Enum.Font.GothamMedium
    acceptBtn.TextSize = 14
    acceptBtn.AutoButtonColor = false
    acceptBtn.Parent = frame
    local cAccept = Instance.new("UICorner", acceptBtn)
    cAccept.CornerRadius = UDim.new(0, 7)
    local closed = false
    local function dismiss()
        if closed then
            return
        end
        closed = true
        tweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 340, 1, -165)
        }):Play()
        task.delay(0.35, function()
            if gui and gui.Parent then
                gui:Destroy()
            end
        end)
    end
    tweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -15, 1, -165)
    }):Play()
    closeBtn.MouseButton1Click:Connect(dismiss)
    acceptBtn.MouseButton1Click:Connect(function()
        dismiss()
        if type(onAccept) == "function" then
            task.spawn(onAccept)
        end
    end)
    task.delay(15, dismiss)
end
local function dm(btn, onClick)
    btn.Draggable = false
    btn.Active = true
    btn.AnchorPoint = Vector2.new(0, 0)
    local dragInput, dragStart, startPos, startAbs
    local moved = false
    local cChanged, cEnded
    du(btn, function()
        task.defer(function()
            L(btn, 5)
        end)
    end)
    btn.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        dragInput = input
        dragStart = input.Position
        startPos = btn.Position
        startAbs = btn.AbsolutePosition
        moved = false
    end)
    cChanged = h.InputChanged:Connect(function(input)
        if dragInput and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if math.abs(delta.X) > 6 or math.abs(delta.Y) > 6 then
                moved = true
            end
            if moved then
                btn.Position = dN(btn, startPos, startAbs, delta)
            end
        end
    end)
    cEnded = h.InputEnded:Connect(function(input)
        if dragInput and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1) then
            dragInput = nil
            task.defer(function()
                L(btn, 5)
            end)
        end
    end)
    btn.Activated:Connect(function()
        if moved then
            moved = false
            return
        end
        if type(onClick) == "function" then
            onClick()
        end
    end)
    btn.Destroying:Connect(function()
        if cChanged then
            cChanged:Disconnect()
        end
        if cEnded then
            cEnded:Disconnect()
        end
    end)
end
local dR = setmetatable({}, {__mode = "k"})
local function dI(targetFrame, onToggle)
    if dR[targetFrame] then
        dR[targetFrame]:Disconnect()
        dR[targetFrame] = nil
    end
    local conn = h.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or h:GetFocusedTextBox() then
            return
        end
        if input.KeyCode == Enum.KeyCode.M then
            onToggle()
        end
    end)
    dR[targetFrame] = conn
    targetFrame.Destroying:Once(function()
        if dR[targetFrame] == conn then
            dR[targetFrame] = nil
        end
        conn:Disconnect()
    end)
end
function d4O5R(mainFrame, parentGui)
    local btn = Instance.new("TextButton")
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    btn.Parent = parentGui
    btn.BackgroundColor3 = Color3.fromRGB(130, 80, 200)
    btn.Position = UDim2.new(0.15162201, 0, 0.273285708, 0)
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.BorderColor3 = Color3.fromRGB(150, 100, 220)
    btn.Font = Enum.Font.ArialBold
    btn.Text = "Open"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 20
    corner.Parent = btn
    local function toggle()
        mainFrame.Visible = not mainFrame.Visible
    end
    dm(btn, toggle)
    dI(mainFrame, toggle)
    return btn
end
function RfH4ew(mainFrame, parentGui)
    local btn = Instance.new("ImageButton")
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    btn.Parent = parentGui
    btn.BackgroundColor3 = Color3.fromRGB(130, 80, 200)
    btn.Position = UDim2.new(0.15162201, 0, 0.273285708, 0)
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Image = "rbxassetid://88025466559424"
    btn.BorderColor3 = Color3.fromRGB(150, 100, 220)
    btn.BackgroundTransparency = 0
    corner.Parent = btn
    local function toggle()
        mainFrame.Visible = not mainFrame.Visible
    end
    dm(btn, toggle)
    dI(mainFrame, toggle)
    return btn
end
function mOTRLwc()
    if game.PlaceId == 6381829480 then
        return true
    end
end
function VyZC()
    if game.PlaceId == 15759515082 then
        return true
    end
end
function cEQuwBt()
    if game.PlaceId == 4520749081 then
        return true
    end
end
function mOTRLwc()
    if game.PlaceId == 6381829480 then
        return true
    end
end
function VyZC()
    if game.PlaceId == 15759515082 then
        return true
    end
end
iRuP(a)
n4tSu(D, f, G, a, "NTT HUB | Main | " .. _G.linkdis)
D.Draggable = false
RfH4ew(D, a)
BVj99Ic(E, D, true, 17 / 1000)
BVj99Ic(d, D, false, 17 / 1000)
BVj99Ic(F, D, false, 6 / 100)
BVj99Ic(j, D, false, 6 / 100)
BVj99Ic(u, D, false, 6 / 100)
BVj99Ic(N, D, false, 6 / 100)
BVj99Ic(m, D, false, 6 / 100)
BVj99Ic(y, D, false, 6 / 100)
BVj99Ic(w, D, false, 6 / 100)
BVj99Ic(q, D, false, 6 / 100)
BVj99Ic(C, D, false, 6 / 100)
BVj99Ic(z, D, false, 6 / 100)
BVj99Ic(e, D, false, 6 / 100)
BVj99Ic(P, D, false, 6 / 100)
TwA9(T, G, "Setting")
if VyZC() or mOTRLwc() then
    TwA9(dD, G, "Event")
end
TwA9(J, G, "Main")
TwA9(dd, G, "Start")
TwA9(o, G, "Boss/Hop")
if mOTRLwc() or VyZC() then
    TwA9(B, G, "Item/Race")
end
TwA9(l, G, "Dungeon")
TwA9(g, G, "Esp/Fish")
TwA9(p, G, "Combat")
TwA9(H, G, "Player")
TwA9(V, G, "Fruit/Shop")
TwA9(Q, G, "Teleport")
TwA9(r, G, "Server Live")
TwA9(Y, G, "Server")
YG5XGe = Instance.new("Frame")
YG5XGe.Name = "black_screen"
YG5XGe.Parent = a
YG5XGe.BackgroundColor3 = (Color3.fromRGB(0, 0, 0))
YG5XGe.Position = (UDim2.new(0, 0, -0.3, 0))
YG5XGe.Size = (UDim2.new(2, 0, 2, 0))
YG5XGe.Visible = false
YG5XGe.ZIndex = -1
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/NTT-HUB/Script/refs/heads/main/noti"))()
end)
TZR = "char"
Q0XH = "NTT_"
ZnN3lmV = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
function AW7(N)
    return (N:gsub(".", function(v)
        local V = ""
        local T = v:byte()
        for k = 8, 1, -1 do
            if T % 2 ^ k - T % 2 ^ (k - 1) > 0 then
                V = V .. "1"
            else
                V = V .. "0"
            end
        end
        return V
    end) .. "0000"):gsub("%d%d%d?%d?%d?%d?", function(J)
        if #J < 6 then
            return ""
        end
        local L = 0
        for a = 1, 6 do
            if J:sub(a, a) == "1" then
                L = L + 2 ^ (6 - a)
            end
        end
        return ZnN3lmV:sub(L + 1, L + 1)
    end) .. ({"", "==", "="})[#N % 3 + 1]
end
function oHQgum(X)
    X = X:gsub("[^" .. ZnN3lmV .. "=]", "")
    return ((X:gsub(".", function(y)
        if y == "=" then
            return ""
        end
        local S, H = "", ZnN3lmV:find(y) - 1
        for X = 6, 1, -1 do
            S = S .. (H % 2 ^ X - H % 2 ^ (X - 1) > 0 and "1" or "0")
        end
        return S
    end)):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(w)
        if #w ~= 8 then
            return ""
        end
        local d = 0
        for Y = 1, 8 do
            d = d + (w:sub(Y, Y) == "1" and 2 ^ (8 - Y) or 0)
        end
        return string.char(d)
    end))
end
function G3lKTem(l, C)
    local j = {}
    for d = 1, #l do
        local x = string.byte(C, (d - 1) % #C + 1)
        local i = string.byte(l, d)
        table.insert(j, string.char(bit32.bxor(i, x)))
    end
    return table.concat(j)
end
function zVdc5T4(N)
    return Q0XH .. AW7(G3lKTem(N, TZR))
end
function UPKB(N)
    if N:sub(1, #Q0XH) == Q0XH then
        N = N:sub(#Q0XH + 1)
    else
        return nil
    end
    return G3lKTem(oHQgum(N), TZR)
end
function GwaiLpy(N, a, l)
    l = tonumber(l) or 0
    game:HttpGet("https://api.nttsv.online/api/server?name=" .. N .. "&title=" .. a .. "&jobid=" .. game.JobId .. "&time=" .. os.time() .. "&zindex=" .. l)
end
function Dqz(name, title, timestamp, zindex)
    timestamp = tonumber(timestamp) or 0
    zindex = tonumber(zindex) or 0
    return game:HttpGet("https://api.nttsv.online/api/server2?name=" .. tostring(name) .. "&title=" .. tostring(title) .. "&jobid=" .. tostring(game.JobId) .. "&time=" .. tostring(timestamp) .. "&zindex=" .. tostring(zindex))
end
function g93Q1F()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/NTTTTTTTT/Main/main/Svv"))()
end
function IDp(n)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = n
end
function bcpg(R)
    IDp(R * (CFrame.new(0, _G._("y"), 0) * CFrame.Angles(math.rad(-90), 0, 0)))
    _G.pos_skill = R
end
function DwTQIfY(h)
    local F = {"MouseButton1Up", "MouseButton1Down", "MouseButton1Click", "Activated"}
    for D, C in pairs(F) do
        for C, v in pairs(getconnections(h[C])) do
            v:Fire()
        end
    end
end
function Ycwda(G)
    (game:GetService("VirtualInputManager")):SendKeyEvent(true, G, false, game);
    (game:GetService("VirtualInputManager")):SendKeyEvent(false, G, false, game)
end
function X832WOA(toolName)
    local plr = game.Players.LocalPlayer
    if plr and plr.Character then
        local t = plr.Character:FindFirstChild(toolName)
        if t then
            return t
        end
    end
    if plr and plr.Backpack then
        return plr.Backpack:FindFirstChild(toolName)
    end
    return nil
end
function U53t(l)
    for F, c in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if c:IsA("Tool") then
            if c.ToolTip == l or c.Name == l then
                return true
            end
        end
    end
end
function FWN(p)
    for z, g in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if g:IsA("Tool") then
            if g.ToolTip == p or g.Name == p then
                game.Players.LocalPlayer.Character.Humanoid:EquipTool(g)
            end
        end
    end
end
function RFpy(J)
    if typeof(J) == "Vector3" then
        return (J - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    else
        return (J.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    end
end
function xqcT9fL(s)
    local z = {game.Players.LocalPlayer.Backpack, game.Players.LocalPlayer.Character}
    for x = 1, 2 do
        for K, x in pairs(z[x]:GetChildren()) do
            if x:IsA("Tool") then
                if x.ToolTip == s or x.Name == s then
                    return true
                end
            end
        end
    end
end
function rBrUGg3(S)
    return S:match("%:%s*(.+)")
end
function smi()
    if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        return game.Players.LocalPlayer.Character.Humanoid.Sit
    end
end
jTuhV = {}
function eWM(u, j)
    local r = tostring(u)
    local Q = os.clock()
    if jTuhV[r] == nil or jTuhV[r] and jTuhV[r][1] < Q then
        jTuhV[r] = {}
        jTuhV[r][1] = Q + 1
        local D = {}
        for g, s in pairs(u) do
            if j == 1 then
                if s then
                    table.insert(D, g)
                end
            elseif j == 2 then
                table.insert(D, g)
            end
        end
        jTuhV[r][2] = D
        return D
    else
        return jTuhV[r][2]
    end
end
function Psmhqe()
    local S = {}
    for H, Y in pairs(game.Players:GetPlayers()) do
        if Y.Name ~= game.Players.LocalPlayer.Name then
            table.insert(S, Y.Name)
        end
    end
    return S
end
function tULJ(Q)
    fireproximityprompt(Q)
end
rIcti = false
function A921YRv(B)
    if rIcti == false then
        game:GetService("GuiService").SelectedObject = B
        if game:GetService("GuiService").SelectedObject == B then
            rIcti = true;
            (game:GetService("VirtualInputManager")):SendKeyEvent(true, 13, false, game)
            task.wait();
            (game:GetService("VirtualInputManager")):SendKeyEvent(false, 13, false, game)
        end
        task.wait()
        game:GetService("GuiService").SelectedObject = nil
        rIcti = false
    end
end
O7oIXei = {}
function z8Jf8qa(u, j, X)
    local l = X
    if l == nil or l == 0 then
        l = 1
    end
    local P = tostring(u)
    local a = os.clock()
    if O7oIXei[P] == nil or O7oIXei[P] <= a then
        O7oIXei[P] = a + l
        spawn(function()
            if type(j) == "function" then
                return j()
            else
                return j
            end
        end)
    end
end
function Kcmy(mod)
    if mod and mod:IsA("ModuleScript") then
        return decompile(mod)
    end
    return nil
end
function dbz6pRH(y)
    return (game:GetService("HttpService")):JSONDecode(y)
end
function wYLqiGr()
    local X = game.Players.LocalPlayer.PlayerStats.lvl.Value
    local function u(z, g)
        return X == z or X <= g
    end
    if game.PlaceId == 4520749081 then
        if u(1, 9) then
            return {"Soldier [Lv. 1]", "Kill 4 Soldiers", CFrame.new(-1860, 50, -4489)}
        elseif u(10, 19) then
            return {"Clown Pirate [Lv. 10]", "Kill 5 Clown Pirates", CFrame.new(-1860, 50, -4489)}
        elseif u(20, 29) then
            return {"Smoky [Lv. 20]", "Kill 1 Smoky", CFrame.new(-2065, 99, -4686)}
        elseif u(30, 49) then
            return {"Tashi [Lv. 30]", "Kill 1 Tashi", CFrame.new(-2270, 109, -4548)}
        elseif u(50, 74) then
            return {"Clown Swordman [Lv. 50]", "Kill 6 Clown Swordman", CFrame.new(-764, 97, -3546)}
        elseif u(75, 99) then
            return {"The Clown [Lv. 75]", "Kill 1 The Clown", CFrame.new(-397, 114, -3436)}
        elseif u(100, 119) then
            return {"Commander [Lv. 100]", "Kill 4 Commander", CFrame.new(-2122, 92, -2549)}
        elseif u(120, 144) then
            return {"Captain [Lv. 120]", "Kill 1 Captain", CFrame.new(-2122, 92, -2549)}
        elseif u(145, 179) then
            return {"The Barbaric [Lv. 145]", "Kill 1 The Barbaric", CFrame.new(-2375, 139, -2419)}
        elseif u(180, 199) then
            return {"Fighter Fishman [Lv. 180]", "Kill 4 Fighter Fishmans", CFrame.new(-856, 52, -1422)}
        elseif u(200, 229) then
            return {"Karate Fishman [Lv. 200]", "Kill 1 Karate Fishman", CFrame.new(-856, 52, -1422)}
        elseif u(230, 249) then
            return {"Shark Man [Lv. 230]", "Kill 1 Shark Man", CFrame.new(-666, 56, -1493)}
        elseif u(250, 299) then
            return {"Trainer Chef [Lv. 250]", "Kill 4 Trainer Chef", CFrame.new(-4217, 162, -2899)}
        elseif u(300, 349) then
            return {"Dark Leg [Lv. 300]", "Kill 1 Dark Leg", CFrame.new(-4217, 162, -2899)}
        elseif u(350, 399) then
            return {"Dory [Lv. 350]", "Kill 1 Dory", CFrame.new(-4217, 162, -2899)}
        elseif u(400, 449) then
            return {"Snow Soldier [Lv. 400]", "Kill 5 Snow Soldier", CFrame.new(-5310, 65, -1275)}
        elseif u(450, 499) then
            return {"King Snow [Lv. 450]", "Kill 1 King Snow", CFrame.new(-5519, 40, -1557)}
        elseif u(500, 524) then
            return {"Little Dear [Lv. 500]", "Kill 1 Little Dear", CFrame.new(-5467, 55, -1104)}
        elseif u(525, 574) then
            return {"Candle Man [Lv. 525]", "Kill 1 Candle Man", CFrame.new(-2956, 92, -602)}
        elseif u(575, 624) then
            return {"Sand Bandit [Lv. 575]", "Kill 4 Sand Bandit", CFrame.new(-2750, 73, -777)}
        elseif u(625, 674) then
            return {"Bomb Man [Lv. 625]", "Kill 1 Bomb Man", CFrame.new(-2956, 92, -602)}
        elseif u(675, 724) then
            return {"Desert Marauder [Lv. 675]", "Kill 4 Desert Marauder", CFrame.new(-2750, 73, -777)}
        elseif u(725, 799) then
            return {"King of Sand [Lv. 725]", "Kill 1 King of Sand", CFrame.new(-3021, 92, -545)}
        elseif u(800, 849) then
            return {"Sky Soldier [Lv. 800]", "Kill 4 Sky Soldier", CFrame.new(-4189, 407, 1345)}
        elseif u(850, 899) then
            return {"Ball Man [Lv. 850]", "Kill 1 Ball Man", CFrame.new(-4922, 511, 1234)}
        elseif u(900, 949) then
            return {"Cloud Warrior [Lv. 900]", "Kill 4 Cloud Warrior", CFrame.new(-4433, 413, 1248)}
        elseif u(950, 999) then
            return {"Rumble Man [Lv. 950]", "Kill 1 Rumble Man", CFrame.new(-4922, 511, 1234)}
        elseif u(1000, 1049) then
            return {"Elite Soldier [Lv. 1000]", "Kill 4 Elite Soldiers", CFrame.new(1730, 67, 894)}
        elseif u(1050, 1099) then
            return {"High-class Soldier [Lv. 1050]", "Kill 4 High-class Soldier", CFrame.new(1456, 98, 917)}
        elseif u(1100, 1149) then
            return {"Leader [Lv. 1100]", "Kill 1 Leader", CFrame.new(1660, 47, 607)}
        elseif u(1150, 1199) then
            return {"Pasta [Lv. 1150]", "Kill 1 Pasta", CFrame.new(1928, 128, 878)}
        elseif u(1200, 1249) then
            return {"Naval personnel [Lv. 1200]", "Kill 4 Naval personnel", CFrame.new(-1308, 69, 2148)}
        elseif u(1250, 1299) then
            return {"Wolf [Lv. 1250]", "Kill 1 Wolf", CFrame.new(-1308, 69, 2148)}
        elseif u(1300, 1349) then
            return {"Giraffe [Lv. 1300]", "Kill 1 Giraffe", CFrame.new(-1204, 69, 2100)}
        elseif u(1350, 1399) then
            return {"Nautical soldier [Lv. 1350]", "Kill 4 Nautical soldier", CFrame.new(-1204, 69, 2100)}
        elseif u(1400, 1449) then
            return {"Naval soldier [Lv. 1400]", "Kill 4 Naval soldier", CFrame.new(-1256, 167, 2585)}
        elseif u(1450, 1499) then
            return {"Leo [Lv. 1450]", "Kill 1 Leo", CFrame.new(-1256, 167, 2585)}
        elseif u(1500, 1549) then
            return {"Zombie [Lv. 1500]", "Kill 5 Zombies", CFrame.new(-2789, 16, 4188)}
        elseif u(1550, 1599) then
            return {"Elite Zombie [Lv. 1550]", "Kill 4 Elite Zombies", CFrame.new(-2789, 16, 4188)}
        elseif u(1600, 1649) then
            return {"Revenant [Lv. 1600]", "Kill 4 Revenant", CFrame.new(-2849, 20, 4319)}
        elseif u(1650, 1699) then
            return {"Shadow Master [Lv. 1650]", "Kill 1 Shadow Master", CFrame.new(-2849, 20, 4319)}
        elseif u(1700, 1749) then
            return {"New World Pirate [Lv. 1700]", "Kill 4 New World Pirates", CFrame.new(2153, 109, -1587)}
        elseif u(1750, 1799) then
            return {"Cutlass Pirate [Lv. 1750]", "Kill 4 Cutlass Pirates", CFrame.new(2391, 80, -1982)}
        elseif u(1800, 1849) then
            return {"Rear Admiral [Lv. 1800]", "Kill 4 Rear Admirals", CFrame.new(2410, 109, -2228)}
        elseif u(1850, 1924) then
            return {
                "True Karate Fishman [Lv. 1850]",
                "Kill 1 True Karate Fishman",
                CFrame.new(2471, 103, -1938)
            }
        elseif u(1925, 1999) then
            return {"Quake Woman [Lv. 1925]", "Kill 1 Quake Woman", CFrame.new(2285, 49, -1908)}
        elseif u(2000, 2049) then
            return {"Fishman [Lv. 2000]", "Kill 4 Fishmans", CFrame.new(-1743, 40, 6198)}
        elseif u(2050, 2099) then
            return {"Combat Fishman [Lv. 2050]", "Kill 1 Combat Fishman", CFrame.new(-1956, 55, 6236)}
        elseif u(2100, 2149) then
            return {"Sword Fishman [Lv. 2100]", "Kill 1 Sword Fishman", CFrame.new(-1635, 96, 6688)}
        elseif u(2150, 2199) then
            return {"Soldier Fishman [Lv. 2150]", "Kill 4 Soldier Fishman", CFrame.new(-1801, 40, 6451)}
        elseif u(2200, 999999999) then
            return {"Seasoned Fishman [Lv. 2200]", "Kill 1 Seasoned Fishman", CFrame.new(-1801, 40, 6451)}
        end
    elseif game.PlaceId == 6381829480 then
        if u(2250, 2299) then
            return {"Beast Pirate [Lv. 2250]", "Kill 4 Beast Pirates", CFrame.new(-4114, 57, 113)}
        elseif u(2300, 2349) then
            return {"Beast Swordman [Lv. 2300]", "Kill 4 Beast Swordman", CFrame.new(-4092, 98, -268)}
        elseif u(2350, 2399) then
            return {"Gazelle Man [Lv. 2350]", "Kill 1 Gazelle Man", CFrame.new(-4363, 57, 252)}
        elseif u(2400, 2449) then
            return {
                "Bandit Beast Pirate [Lv. 2400]",
                "Kill 4 Bandit Beast Pirates",
                CFrame.new(-4344, 176, -1015)
            }
        elseif u(2450, 2499) then
            return {
                "Powerful Beast Pirate [Lv. 2450]",
                "Kill 4 Powerful Beast Pirates",
                CFrame.new(-4656, 136, -851)
            }
        elseif u(2500, 2549) then
            return {"Violet Samurai [Lv. 2500]", "Kill 1 Violet Samurai", CFrame.new(-4969, 105, -1007)}
        elseif u(2550, 2599) then
            return {"Duke [Lv. 2550]", "Kill 1 Duke", CFrame.new(-5434, 100, -228)}
        elseif u(2600, 2649) then
            return {"Magician [Lv. 2600]", "Kill 1 Magician", CFrame.new(-5048, 105, -154)}
        elseif u(2650, 2699) then
            return {"Kitsune Samurai [Lv. 2650]", "Kill 1 Kitsune Samurai", CFrame.new(-5452, 100, 16)}
        elseif u(2700, 2749) then
            return {
                "Elite Beast Pirate [Lv. 2700]",
                "Kill 4 Elite Beast Pirates",
                CFrame.new(-4564, 73, 1380)
            }
        elseif u(2750, 2799) then
            return {"Bear Man [Lv. 2750]", "Kill 1 Bear Man", CFrame.new(-4438, 53, 775)}
        elseif u(2800, 2849) then
            return {"Bean [Lv. 2800]", "Kill 1 Bean", CFrame.new(-4018, 68, 904)}
        elseif u(2850, 2899) then
            return {"Meji [Lv. 2850]", "Kill 1 Meji", CFrame.new(-5302, 83, 1163)}
        elseif u(2900, 2949) then
            return {"Petra [Lv. 2900]", "Kill 1 Petra", CFrame.new(-5857, 80, 1308)}
        elseif u(2950, 2999) then
            return {"Kappa [Lv. 2950]", "Kill 1 Kappa", CFrame.new(-4853, 109, 1926)}
        elseif u(3000, 3049) then
            return {"Joey [Lv. 3000]", "Kill 1 Joey", CFrame.new(-5287, 57, 2066)}
        elseif u(3050, 3099) then
            return {"Skull Pirate [Lv. 3050]", "Kill 4 Skull Pirates", CFrame.new(-6400, 78, 6907)}
        elseif u(3100, 3124) then
            return {"Elite Skeleton [Lv. 3100]", "Kill 1 Elite Skeleton", CFrame.new(-5926, 98, 7183)}
        elseif u(3125, 3149) then
            return {"Desert Thief [Lv. 3125]", "Kill 1 Desert Thief", CFrame.new(1575, 53, 1513)}
        elseif u(3150, 3174) then
            return {"Anubis [Lv. 3150]", "Kill 1 Anubis", CFrame.new(1964, 48, 899)}
        elseif u(3175, 3199) then
            return {"Pharaoh [Lv. 3175]", "Kill 1 Pharaoh", CFrame.new(2048, 49, 1632)}
        elseif u(3200, 3224) then
            return {"Chess Soldier [Lv. 3200]", "Kill 4 Chess Soldiers", CFrame.new(-7, 77, 8164)}
        elseif u(3225, 3249) then
            return {"Sunken Vessel [Lv. 3225]", "Kill 1 Sunken Vessel", CFrame.new(-986, 83, 8169)}
        elseif u(3250, 3274) then
            return {"Biscuit Man [Lv. 3250]", "Kill 1 Biscuit Man", CFrame.new(-1375, 202, 8860)}
        elseif u(3275, 3299) then
            return {"Dough Master [Lv. 3275]", "Kill 1 Dough Master", CFrame.new(30370, 106, 93598)}
        elseif u(3300, 3324) then
            return {"Azlan [Lv. 3300]", "Kill 4 Azlan", CFrame.new(-832, 69, -2860)}
        elseif u(3325, 3399) then
            return {"The Volcano [Lv. 3325]", "Kill 4 The Volcano", CFrame.new(-152, 173, -3579)}
        elseif u(3400, 3424) then
            return {
                "Dark Beard Servant [Lv. 3400]",
                "Kill 4 Dark Beard Servant",
                CFrame.new(-9156, 94, -4629)
            }
        elseif u(3425, 3449) then
            return {"Supreme Swordman [Lv. 3425]", "Kill 1 Supreme Swordman", CFrame.new(-9647, 114, -4483)}
        elseif u(3450, 3499) then
            return {"Sally [Lv. 3450]", "Kill 1 Sally", CFrame.new(-9584, 135, -5374)}
        elseif u(3500, 3524) then
            return {"Vice Admiral [Lv. 3500]", "Kill 5 Vice Admiral", CFrame.new(-9993, 87, 421)}
        elseif u(3525, 3549) then
            return {"Pondere [Lv. 3525]", "Kill 1 Pondere", CFrame.new(-10142, 100, 1298)}
        elseif u(3550, 3599) then
            return {"Hefty [Lv. 3550]", "Kill 1 Hefty", CFrame.new(-10489, 84, 969)}
        elseif u(3600, 3624) then
            return {"Fiore Gladiator [Lv. 3600]", "Kill 6 Fiore Gladiator", CFrame.new(5450, 133, -2782)}
        elseif u(3625, 3649) then
            return {"Fiore Fighter [Lv. 3625]", "Kill 6 Fiore Fighter", CFrame.new(5466, 87, -2559)}
        elseif u(3650, 3674) then
            return {"Fiore Pirate [Lv. 3650]", "Kill 7 Fiore Pirate", CFrame.new(6095, 134, -2905)}
        elseif u(3675, 3699) then
            return {"Lomeo [Lv. 3675]", "Kill 1 Lomeo", CFrame.new(6487, 72, -2135)}
        elseif u(3700, 3724) then
            return {"Prince Aria [Lv. 3700]", "Kill 1 Prince Aria", CFrame.new(6785, 150, -3794)}
        elseif u(3725, 3774) then
            return {"Devastate [Lv. 3725]", "Kill 1 Devastate", CFrame.new(7632, 122, -2644)}
        elseif u(3775, 3799) then
            return {"Floffy [Lv. 3775]", "Kill 1 Floffy", CFrame.new(7865, 462, -2529)}
        elseif u(3800, 3849) then
            return {"Dead Troupe [Lv. 3800]", "Kill 4 Dead Troupe", CFrame.new(9716, 93, -4292)}
        elseif u(3850, 3974) then
            return {
                "Dead Troupe Captain [Lv. 3850]",
                "Kill 4 Dead Troupe Captain",
                CFrame.new(10021, 102, -3947)
            }
        elseif u(3975, 9999999) then
            return {"Ryu [Lv. 3975]", "Kill 1 Ryu", CFrame.new(9927, 86, -4856)}
        end
    elseif game.PlaceId == 15759515082 then
        if u(4000, 4049) then
            return {"Deep Diver [Lv. 4000]", "Kill 4 Deep Diver", CFrame.new(1674, 47, 1015)}
        elseif u(4050, 4099) then
            return {"Fugitive [Lv. 4050]", "Kill Fugitive", CFrame.new(2888, 35, 993)}
        elseif u(4100, 4149) then
            return {"Deep one Villager [Lv. 4100]", "Kill 4 Deep one Villager", CFrame.new(3299, 316, 671)}
        elseif u(4150, 4199) then
            return {"Fishman Guardian [Lv. 4150]", "Kill 6 Fishman Guardian", CFrame.new(1786, 66, 86)}
        elseif u(4200, 4249) then
            return {"The deep one [Lv. 4200]", "Kill The deep one", CFrame.new(2833, 35, 136)}
        elseif u(4250, 4299) then
            return {
                "Fishman King's Guard [Lv. 4250]",
                "Kill Fishman King's Guard",
                CFrame.new(1934, 125, -457)
            }
        elseif u(4300, 4324) then
            return {"Jungle Gorilla [Lv. 4300]", "Kill 5 Jungle Gorilla", CFrame.new(4215, 181, 9081)}
        elseif u(4325, 4349) then
            return {"Wilderness Gorilla [Lv. 4325]", "Kill 5 Wilderness Gorilla", CFrame.new(4865, 45, 9876)}
        elseif u(4350, 4374) then
            return {"Jungle Ape [Lv. 4350]", "Kill 5 Jungle Ape", CFrame.new(5307, 45, 9640)}
        elseif u(4375, 4399) then
            return {"Cyborg Gorilla [Lv. 4375]", "Kill 1 Cyborg Gorilla", CFrame.new(5784, 45, 9463)}
        elseif u(4400, 4449) then
            return {"Ripcurrent Raider [Lv. 4400]", "Kill 1 Ripcurrent Raider", CFrame.new(-506, 26, -8673)}
        elseif u(4450, 4499) then
            return {"Tidal Warrior [Lv. 4450]", "Kill 1 Tidal Warrior", CFrame.new(-73, 96, -8404)}
        elseif u(4500, 4549) then
            return {"Ocean Gladiator [Lv. 4500]", "Kill 1 Ocean Gladiator", CFrame.new(-22, 44, -9066)}
        elseif u(4550, 4599) then
            return {"Deepfire Combatant [Lv. 4550]", "Kill 4 Deepfire Combatant", CFrame.new(-5174, 26, 171)}
        elseif u(4600, 4649) then
            return {
                "Electro Abyss Warrior [Lv. 4600]",
                "Kill 1 Electro Abyss Warrior",
                CFrame.new(-5230, 22, 964)
            }
        elseif u(4650, 4699) then
            return {"Inferno Diver [Lv. 4650]", "Kill 1 Inferno Diver", CFrame.new(-6044, 54, 467)}
        elseif u(4700, 4749) then
            return {
                "Tempest Tidebreaker [Lv. 4700]",
                "Kill 1 Tempest Tidebreaker",
                CFrame.new(-7296, 42, 469)
            }
        elseif u(4750, 4799) then
            return {"Abyssal Swordsman [Lv. 4750]", "Kill 1 Abyssal Swordsman", CFrame.new(-8255, 186, 455)}
        elseif u(4800, 4849) then
            return {"Rogue Prisoner [Lv. 4825]", "Kill 4 Rogue Prisoner", CFrame.new(10931, 78, 478)}
        elseif u(4850, 4874) then
            return {"Prisoner Buccaneer [Lv. 4850]", "Kill 4 Prisoner Buccaneer", CFrame.new(11731, 125, 253)}
        elseif u(4875, 4999) then
            return {
                "Prisoner of Gravity [Lv. 4875]",
                "Kill 1 Prisoner of Gravity",
                CFrame.new(12436, 79, 1052)
            }
        elseif u(5000, 5049) then
            return {"Obsidian Seeker [Lv. 5000]", "Kill 8 Obsidian Seeker", CFrame.new(-7751, 165, 11631)}
        elseif u(5050, 5099) then
            return {"Forgotten Delver [Lv. 5050]", "Kill 8 Forgotten Delver", CFrame.new(-8570, 214, 10434)}
        elseif u(5100, 5149) then
            return {"Blackreach Scout [Lv. 5100]", "Kill 8 Blackreach Scout", CFrame.new(-8440, 116, 12270)}
        elseif u(5150, 5199) then
            return {
                "Nightbound Explorer [Lv. 5150]",
                "Kill 1 Nightbound Explorer",
                CFrame.new(-8634, 235, 11395)
            }
        elseif u(5200, 5249) then
            return {"Ruinstep Nomad [Lv. 5200]", "Kill 8 Ruinstep Nomad", CFrame.new(-9066, 79, 13239)}
        elseif u(5250, 5299) then
            return {"Ancient Wayfarer [Lv. 5250]", "Kill 1 Ancient Wayfarer", CFrame.new(-9061, 79, 11636)}
        elseif u(5300, 5349) then
            return {"Depths Voyager [Lv. 5300]", "Kill 8 Depths Voyager", CFrame.new(-10193, 107, 12325)}
        elseif u(5350, 5399) then
            return {"Allosaurus [Lv. 5350]", "Kill 1 Allosaurus", CFrame.new(-10548, 248, 11940)}
        elseif u(5400, 9999) then
            return {"Spinosaurus [Lv. 5400]", "Kill 1 Spinosaurus", CFrame.new(-10655, 177, 10159)}
        end
    end
end
BMwkbvT = {"Combat", "Sword", "Fruit Power"}
YaDJ6T = {"Z", "X", "C", "V", "B", "E"}
aonXbO = {"Copper Key", "Iron Key", "Gold Key", "Platinum Key"}
function NbTWcsM(y)
    P4Eh5a = _G.Setting.blacklist
    if P4Eh5a[y] then
        if os.time() > P4Eh5a[y] then
            return true
        else
            return false
        end
    else
        return true
    end
end
function JBX()
    local x = {}
    for N = 1, #game.Workspace.AllNPC:GetChildren() do
        uex = game.Workspace.AllNPC:GetChildren()[N].Name
        if not string.find(uex, "SetSpawn") and (not string.find(uex, "Progre") and ((not string.find(uex, "Quest") or string.find(uex, "Daily")) and not string.find(uex, "BuyShips"))) then
            table.insert(x, uex)
        end
    end
    return x
end
function Gak()
    local n = game.Players.LocalPlayer.PlayerStats
    return {n.FightingStyle.Value, n.SwordName.Value, n.DFName.Value}
end
do
    local Y = game:GetService("Players").LocalPlayer
    local o = setthreadidentity or set_thread_identity
    local Q = getthreadidentity or get_thread_identity
    local B = {FS = "FightingStyleSkills", SW = "SwordSkills", DF = "FruitSkills"}
    function G0i27FO(R)
        local v, s, A = R:match("^(%u%u)_(.+)_([^_]+)$")
        if not v or not B[v] then
            warn("Skill không hợp lệ:", R)
            return
        end
        if type(o) ~= "function" or type(Q) ~= "function" then
            warn("Executor thiếu thread identity")
            return
        end
        task.spawn(function()
            local z, T = pcall(Q)
            if not z then
                return
            end
            local W = pcall(o, 2)
            if not W then
                warn("Không đổi được thread identity")
                return
            end
            local k, O = xpcall(function()
                local D = (Y.PlayerScripts:WaitForChild("Services")):WaitForChild("ClientSkillHandler")
                local q = D:FindFirstChild(B[v])
                assert(q, "Không tìm thấy folder")
                local V = q:FindFirstChild(s .. "_Client") or q:FindFirstChild(s)
                assert(V, "Không tìm thấy module: " .. s)
                local H = require(V)
                local X = H[A:upper()]
                assert(type(X) == "function", "Không có skill " .. A)
                local P = getfenv(X)._G
                local h = _G.pos_skill or Y:GetMouse().Hit
                if typeof(h) == "Vector3" then
                    h = CFrame.new(h)
                end
                assert(typeof(h) == "CFrame", "Target phải là CFrame")
                local j = P.MouseHit
                P.MouseHit = h
                print("[TEST] Gọi:", R)
                task.delay(4 / 10, function()
                    local w
                    local X, L = pcall(Q)
                    if X then
                        w = L
                        pcall(o, 2)
                    end
                    if type(H.Deactive) == "function" then
                        pcall(H.Deactive, A:upper())
                    end
                    if P.MouseHit == h then
                        P.MouseHit = j
                    end
                    if w ~= nil then
                        pcall(o, w)
                    end
                    print("[TEST] Đã nhả skill:", R)
                end)
                X()
                print("[TEST] Đã gọi hàm skill:", R)
            end, function(P)
                return tostring(P)
            end)
            pcall(o, T)
            if not k then
                warn("[TEST] Lỗi:", O)
            end
        end)
    end
end
do
    local C = game:GetService("Players")
    local k = C.LocalPlayer
    local F = setthreadidentity or set_thread_identity
    local z = getthreadidentity or get_thread_identity
    local E = {[1] = "FightingStyleSkills", [2] = "SwordSkills", [3] = "FruitSkills"}
    function FpNzYV5()
        if type(F) ~= "function" or type(z) ~= "function" then
            return
        end
        local X = Gak()
        local w = k.PlayerScripts.Services.ClientSkillHandler
        for u = 1, 3 do
            local q = X[u]
            local S = E[u]
            if type(q) == "string" and q ~= "" then
                task.spawn(function()
                    local m, E, j, P, n, e, p, t
                    m = w:FindFirstChild(S)
                    if not m then
                        return
                    else
                        E = m:FindFirstChild(q) or m:FindFirstChild(q .. "_Client")
                        if not E then
                            return
                        else
                            j, P = pcall(z)
                            if not j then
                                return
                            else
                                n, e = pcall(F, 2)
                                if not n then
                                    return
                                else
                                    p, t = pcall(function()
                                        local y
                                        y = require(E)
                                        y.M1()
                                    end)
                                    pcall(F, P)
                                    if not p then
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end
end
function OQHfDP()
    FlFcSR = nil
    for n, m in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if m.ClassName == "Tool" then
            FlFcSR = m.ToolTip
        end
    end
    local E = {}
    E[89] = "FS_" .. Gak()[1] .. "_M1"
    local e = {}
    e.MouseHit = _G.pos_skill
    E[92] = e
    local f = E
    game.ReplicatedStorage.Chest.Remotes.Functions.SkillAction:InvokeServer(f[89], f[92])
    task.wait(1 / 10)
    local k = {}
    k[118] = "SW_" .. Gak()[2] .. "_M1"
    local g = {}
    g.MouseHit = _G.pos_skill
    k[85] = g
    local t = k
    game.ReplicatedStorage.Chest.Remotes.Functions.SkillAction:InvokeServer(t[118], t[85])
    task.wait(1 / 10)
    local a = {}
    a[114] = "DF_" .. Gak()[3] .. "_M1"
    local N = {}
    N.MouseHit = _G.pos_skill
    a[104] = N
    local H = a
    game.ReplicatedStorage.Chest.Remotes.Functions.SkillAction:InvokeServer(H[114], H[104])
end
function km9x6(v)
    game:GetService("Players").LocalPlayer.PlayerGui.MainGui.StarterFrame.StatsFrame.RemoteEvent:FireServer(v, 1)
end
function ygznD()
    if nKFGU0v("main_b1") then
        FWN.Text = rBrUGg3.Text
    end
end
function B4AcFW()
    FWN.Text = rBrUGg3.Text
end
function s00WNaQ(y)
    local q, v = game.ReplicatedStorage.MOB:FindFirstChild(y), game.Workspace.Monster.Boss:FindFirstChild(y)
    if q and q:FindFirstChild("HumanoidRootPart") then
        return q
    elseif v and v:FindFirstChild("HumanoidRootPart") then
        return v
    end
end
HQW2 = os.clock()
_G.file_mob = {}
function LPQH(e)
    local T, a, x = type(e), game.ReplicatedStorage.MOB
    if HQW2 < os.clock() then
        HQW2 = os.clock() + 2 / 10
        _G.file_mob = {}
        if T == "string" then
            x = a:FindFirstChild(e)
            if x and (x:FindFirstChild("HumanoidRootPart") and x:FindFirstChild("Humanoid")) then
                table.insert(_G.file_mob, x)
            end
        else
            for j = 1, #e do
                x = a:FindFirstChild(e[j])
                if x and (x:FindFirstChild("HumanoidRootPart") and x:FindFirstChild("Humanoid")) then
                    table.insert(_G.file_mob, x)
                end
            end
        end
        for S, x in pairs(game.Workspace.Monster.Mon:GetChildren()) do
            if x:FindFirstChild("HumanoidRootPart") and (x:FindFirstChild("Humanoid") and x.Humanoid.Health > 0) then
                if T == "string" and x.Name == e or RFpy(x.HumanoidRootPart.Position) < 1000 then
                    table.insert(_G.file_mob, x)
                end
            end
        end
        for G, N in pairs(game.Workspace.Monster.Boss:GetChildren()) do
            if N:FindFirstChild("HumanoidRootPart") and (N:FindFirstChild("Humanoid") and N.Humanoid.Health > 0) then
                table.insert(_G.file_mob, N)
            end
        end
    end
    local S = _G.file_mob
    local j = {[1] = {}, [2] = {}}
    if T == "string" then
        x = a:FindFirstChild(e)
        if x and (x:FindFirstChild("HumanoidRootPart") and x:FindFirstChild("Humanoid")) then
            return x
        end
        for A, r in pairs(S) do
            if r.Name == e or string.find(r.Name, e) then
                if r:FindFirstChild("Humanoid") and (r.Humanoid.Health == r.Humanoid.MaxHealth and r:FindFirstChild("HumanoidRootPart")) then
                    table.insert(j[1], r)
                end
                if r:FindFirstChild("Humanoid") and (r.Humanoid.Health > 0 and r:FindFirstChild("HumanoidRootPart")) then
                    table.insert(j[2], r)
                end
            end
        end
        if #j[1] > 0 then
            return j[1][1]
        else
            return j[2][1]
        end
    elseif T == "table" then
        for h, r in pairs(S) do
            local N = r.Name
            for q = 1, #e do
                if e[q] == N then
                    x = a:FindFirstChild(e[q])
                    if x and (x:FindFirstChild("HumanoidRootPart") and x:FindFirstChild("Humanoid")) then
                        return x
                    else
                        if r:FindFirstChild("Humanoid") and (r.Humanoid.Health > 0 and r:FindFirstChild("HumanoidRootPart")) then
                            return r
                        end
                    end
                end
            end
        end
    end
end
function sQKqxX()
    for l, y in pairs(game:GetService("Workspace").Island:GetChildren()) do
        if string.find(y.Name, "Human") or (string.find(y.Name, "Gale") or (string.find(y.Name, "SeaKing I") or (string.find(y.Name, "Angel") or (string.find(y.Name, "Animal") or (string.find(y.Name, "Fish I") or string.find(y.Name, "Demon I")))))) then
            return y
        end
    end
end
function qz9CHzC()
    if game.Workspace:FindFirstChild("PlayerCharacters")[game:GetService("Players").LocalPlayer.Name].Services.Haki.Value == 0 then
        game.ReplicatedStorage.Chest.Remotes.Events.Armament:FireServer()
    end
end
function zWEquU()
    if game.Workspace:FindFirstChild("PlayerCharacters")[game:GetService("Players").LocalPlayer.Name].Services.KenOpen.Value == false then
        game.ReplicatedStorage.Chest.Remotes.Functions.KenEvent:InvokeServer()
    end
end
function VnvGX()
    local f = game.Players.LocalPlayer
    local E, p = dbz6pRH(f.PlayerStats.FruitStore.Value), f.PlayerStats.FruitStorage.Value
    for h, X in ipairs({f.Character:GetChildren(), f.Backpack:GetChildren()}) do
        for O, P in pairs(X) do
            if P.ClassName == "Tool" and ((P:FindFirstChild("FruitModel") or P:FindFirstChild("RootPart")) and (E[P.Name] == nil or E[P.Name] ~= p)) then
                return P
            end
        end
    end
end
function gPDaI1()
    local y = game.Players.LocalPlayer.PlayerGui
    if y.MainGui.QuestFrame.QuestBoard.Visible then
        return y.MainGui.QuestFrame.QuestBoard.TextFrame.QuestName.Text
    end
end
function aYMvJS(O)
    local X = workspace.AllNPC:FindFirstChild(O)
    local h = game.Players.LocalPlayer.PlayerGui
    if O and workspace.AllNPC:FindFirstChild(O) then
        IDp(game.workspace.AllNPC[O].CFrame)
    end
    if not X then
        for o, D in pairs(workspace.AllNPC:GetChildren()) do
            if RFpy(D.Position) < 20 then
                X = D
                break
            end
        end
    end
    if X then
        local Y = h:FindFirstChild(X.Name)
        if Y then
            A921YRv(Y.Dialogue.Accept)
            game:GetService("Players").LocalPlayer.PlayerGui[X.Name].DelGui:FireServer()
            return
        end
        game.ReplicatedStorage.Chest.Remotes.Functions.CheckQuest:InvokeServer(X)
    end
end
local O = workspace.CurrentCamera
local function dw(B)
    local q = O.CFrame.Position
    local z = B.Position
    O.CameraType = Enum.CameraType.Scriptable
    O.CFrame = CFrame.new(q, z)
    O.CameraType = Enum.CameraType.Custom
end
function bAsB()
    for Y, e in pairs(_G.Setting.skill) do
        if e then
            Ycwda(Y)
        end
    end
end
function HzrQ()
    local y, O = game.Workspace.SeaMonster:FindFirstChild("SeaKing"), game.Workspace.SeaMonster:FindFirstChild("HydraSeaKing")
    if y and (y:FindFirstChild("HumanoidRootPart") and y.Humanoid.Health > 0) then
        return {y.HumanoidRootPart.CFrame, "boss", 1}
    end
    if O and (O:FindFirstChild("HumanoidRootPart") and O.Humanoid.Health > 0) then
        return {O.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0), "boss", 2}
    end
    for R, N in pairs(game:GetService("Workspace").Island:GetChildren()) do
        if string.find(N.Name, "Sea King") or string.find(N.Name, "Legacy Island") then
            local J, F = N:FindFirstChild("ChestSpawner"), N:FindFirstChild("HydraStand")
            if J then
                return {J.CFrame, "chest", 1}
            elseif F then
                return {F.CFrame, "chest", 2}
            end
        end
    end
end
function dB6g()
    for a, L in pairs(game.Workspace.Island:GetChildren()) do
        if string.find(L.Name, "Gate of Behemoth") then
            for C, O in pairs(L.Map:GetChildren()) do
                if O.ClassName == "Model" and O:FindFirstChild("Open") then
                    return {O.RootPart.CFrame, 1}
                end
            end
            for P, y in pairs(L.Map:GetChildren()) do
                if y.ClassName == "MeshPart" and y.Name == "Base" then
                    return {y.CFrame, 2}
                end
            end
        end
    end
end
function GkDuC3()
    local E = game.Workspace.GhostMonster:FindFirstChild("Ghost Ship")
    if E and (E:FindFirstChild("HumanoidRootPart") and E.Humanoid.Health > 0) then
        return {E.HumanoidRootPart, "Ghost Ship", 1}
    end
    local l = {}
    for Y = 1, 6 do
        local g
        g = game.Workspace:FindFirstChild("Chest" .. Y)
        if g then
            table.insert(l, g.RootPart)
        end
    end
    if #l ~= 0 then
        return {l, "Chest Ghost Ship", 2}
    end
end
function yuv()
    for b, O in pairs(game.Workspace.SeaMonster:GetChildren()) do
        if not string.find(O.Name, "Galleon") then
            if O.Humanoid.Health > 0 and O:FindFirstChild("HumanoidRootPart") then
                return O
            end
        end
    end
    local e = LPQH("FuryTentacle")
    if e then
        return e
    end
end
function i2C6k1()
    for v, j in pairs(game.Workspace.ClamFolder:GetChildren()) do
        if #j:GetChildren() > 0 then
            return {j.Clam.RootPart.CFrame, j.Clam.RootPart.Prompt}
        end
    end
end
function CmEFL1()
    for G, d in pairs(game.Workspace.SeaMonster:GetChildren()) do
        if string.find(d.Name, "Galleon") then
            return d
        end
    end
end
function ksGa(t)
    for u, n in pairs(game.Players:GetPlayers()) do
        if n.Name == t then
            return n
        end
    end
end
function QXE0V(R)
    for u, O in pairs(game.Players:GetChildren()) do
        if O.Name ~= game.Players.LocalPlayer.Name then
            if O:FindFirstChild("PlayerStats") and (O.PlayerStats:FindFirstChild("lvl") and (O.PlayerStats:FindFirstChild("PVP") and O.PlayerStats.PVP.Value)) then
                if O.Character:FindFirstChild("Humanoid") and (O.Character:FindFirstChild("HumanoidRootPart") and (O.Character.Humanoid.Health > 0 and RFpy(O.Character:FindFirstChild("HumanoidRootPart").Position) < R)) then
                    return O
                end
            end
        end
    end
end
function QUXU()
    for D, u in pairs(game:GetService("Workspace").FlagConquest:GetChildren()) do
        if string.find(u.Name, "FlagConquest") then
            if u.Beam.BillboardGui.TextLabel.Text ~= "< ON COOLDOWN >" then
                return u.Beam
            end
        end
    end
end
function hWk(b)
    local Y = {rBrUGg3(nKFGU0v("shop_select1")), b};
    ((((game.ReplicatedStorage:WaitForChild("Chest")):WaitForChild("Remotes")):WaitForChild("Functions")):WaitForChild("UseKey")):InvokeServer(unpack(Y))
end
function Iuc6h()
    local n = game.Workspace.Effects:FindFirstChild("SerpentWhirlpool")
    return (if n then n.Whirlpool else nil)
end
function f8MkTRD(Y)
    local n = {}
    n[39] = "EquipWeapon"
    local C = {}
    C.WeaponName = Y
    C.Type = "Primary"
    n[58] = C
    local F = n
    game.ReplicatedStorage.Chest.Remotes.Functions.EtcFunction:InvokeServer(F[39], F[58])
end
function YHhNl5(E)
    return (if game.Players.LocalPlayer.Inventory:FindFirstChild(E) then true else false)
end
if RBW1 == nil then
    RBW1 = {}
    spawn(function()
        while task.wait() do
            pcall(function()
                if #RBW1 == 0 then
                    RBW1 = game.ReplicatedStorage.Chest.Assets.Modules.Network.ClientNetwork.GetServerLists:InvokeServer()
                    task.wait(5 / 10)
                else
                    print(#RBW1)
                    task.wait(10)
                    RBW1 = {}
                end
            end)
        end
    end)
end
function wi4Eg(v, D)
    local U = v * 60 + D
    for L, u in pairs(RBW1) do
        if game.PlaceId == u.PlaceId and (u.JobId and (u.JobId ~= game.JobId and u.CreatedAt)) then
            local E = os.time() - u.CreatedAt
            local e = math.floor(E / 60)
            if e >= U and (e <= 1440 and e % U <= 2) then
                pcall(function()
                    if NbTWcsM(u.JobId) then
                        (game:GetService("TeleportService")):TeleportToPlaceInstance(game.PlaceId, u.JobId, game.Players.LocalPlayer)
                    end
                end)
                task.wait(5 / 10)
            end
        end
    end
end
function BOgK(J)
    local j = {}
    for w, D in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if string.find(D.Name, "Fruit") and (not string.find(D.Name, "Phoenix") and (not string.find(D.Name, "Dragon") and (not string.find(D.Name, "Demon") and (not string.find(D.Name, "Toy") and (not string.find(D.Name, "Tree") and (not string.find(D.Name, "Gate") and (not string.find(D.Name, "Pter") and (not string.find(D.Name, "Melody") and (not string.find(D.Name, "Dough") and not string.find(D.Name, "Erebus")))))))))) then
            table.insert(j, D.Name)
        end
    end
    if #j > 0 then
        game.ReplicatedStorage.Chest.Remotes.Functions.DealFruit:InvokeServer(J, j)
    end
end
function fsurP(w)
    local X = {}
    X[90] = "TeleportSea"
    local J = {}
    J.SeaName = ({"FirstSea", "SecondSea", "ThirdSea"})[w]
    X[99] = J
    local d = X
    game.ReplicatedStorage.Chest.Remotes.Functions.EtcFunction:InvokeServer(d[90], d[99])
end
function N0Fx()
    local F = n(game.workspace.Island.ThirdSeaTurtleChalice.Crystals.TimeBoard.TextLabel.Text, ":")
    if #F >= 3 then
        local h = tonumber
        local X = h(F[1]) * (60 * 60) + (h(F[2]) * 60 + h(F[3]))
        return h(X)
    else
        return 0
    end
end
function oUlf9()
    for F, j in pairs(RBW1) do
        if game.placeId == j.PlaceId then
            if j.JobId and j.JobId ~= game.JobId then
                if NbTWcsM(j.JobId) then
                    local R = os.time() - j.CreatedAt
                    local X = math.floor(R / 60)
                    local m = math.floor(X / 60)
                    local l = math.floor(m / 54)
                    local N = R % 60
                    local s = X % 60
                    local J = m % 54
                    local g = l
                    if g == 0 and (J == 1 and (s >= 0 and s <= 4) or (J == 2 and (s >= 8 and s <= 12) or (J == 3 and (s >= 16 and s <= 20) or (J == 4 and (s >= 28 and s <= 33) or (J == 6 and (s >= 10 and s <= 14) or (J == 7 and (s >= 10 and s <= 13) or (J == 8 and (s >= 55 and s <= 60) or (J == 9 and (s >= 0 and s <= 5) or (J == 10 and (s >= 30 and s <= 35) or (J == 11 and (s >= 2 and s <= 5) or (J == 15 and (s >= 30 and s <= 35) or (J == 15 and (s >= 50 and s <= 55) or J == 17 and (s >= 35 and s <= 40))))))))))))) or g == 1 and (J == 0 and (s >= 30 and s <= 35)) then
                        pcall(function()
                            if NbTWcsM(j.JobId) then
                                (game:GetService("TeleportService")):TeleportToPlaceInstance(game.placeId, j.JobId, game.Players.LocalPlayer)
                            end
                        end)
                        task.wait(5 / 10)
                    end
                end
            end
        end
    end
end
function kW4RKBO()
    for C, N in pairs(RBW1) do
        if game.placeId == N.PlaceId then
            if N.JobId and N.JobId ~= game.JobId then
                if NbTWcsM(N.JobId) then
                    pcall(function()
                        (game:GetService("TeleportService")):TeleportToPlaceInstance(game.placeId, N.JobId, game.Players.LocalPlayer)
                    end)
                    task.wait(5 / 10)
                end
            end
        end
    end
end
function QsdvwKg()
    for B, P in pairs(game.Workspace.Island:GetChildren()) do
        if P.ClassName == "Model" then
            if P:GetChildren()[1]:FindFirstChild("Tree") then
                return P:GetChildren()[1]:FindFirstChild("Tree").Tree.Part.CFrame
            end
        end
    end
end
function ACJ()
    if nKFGU0v("serpent") and Iuc6h() then
        return 4
    end
    if nKFGU0v("event1") and _G.jack or (nKFGU0v("sbv3") or (nKFGU0v("depthking") and _G.depthking or (nKFGU0v("tricster") and _G.ss or (nKFGU0v("bt") and not YHhNl5("Bloodmoon Twins") or (nKFGU0v("serpentvip") and _G.serpent2 or (nKFGU0v("serpent") and _G.serpent or (nKFGU0v("lordsaber") and _G.lordsaber or (nKFGU0v("preranodon") and _G.preranodon or (nKFGU0v("bigmom") and _G.bigmom or (nKFGU0v("saber") and _G.saber or (nKFGU0v("skhd") and _G.skhd or (nKFGU0v("gs") and _G.gs or (nKFGU0v("oden") and _G.oden or (nKFGU0v("setsail") and _G.ss or nKFGU0v("ship") and _G.ship)))))))))))))) then
        return 3
    end
    if nKFGU0v("kioru") and ((mOTRLwc() or VyZC()) and (not _G.k1 or not _G.k2)) or (nKFGU0v("boss") or (nKFGU0v("bossmulti") or nKFGU0v("dragon") and _G.dragon)) then
        return 2
    end
    if mOTRLwc() and nKFGU0v("event3") or (not cEQuwBt() and nKFGU0v("candy") or (nKFGU0v("log") or (nKFGU0v("level") or (nKFGU0v("mobnear") or (nKFGU0v("material") or (nKFGU0v("materialmulti") or nKFGU0v("dailyquest") and (_G.dl2 and (_G.dl and (_G.dl[1][2] == "mob" and not string.find(game.Players.LocalPlayer.PlayerStats.DailyQuest.Value, _G.dl2, 1, true)))))))))) then
        return 1
    end
    if nKFGU0v("conquest") or (VyZC() and nKFGU0v("pearl") or (nKFGU0v("fish") or (_G.combat_b2 or (_G.teleport_b2 or (_G.teleport_b4 or nKFGU0v("dailyquest")))))) then
        return 0
    end
    return false
end
spawn(function()
    while task.wait() do
        pcall(function()
            _G.core_control = ACJ()
        end)
    end
end)
if nKFGU0v("serpent") and nKFGU0v("hop_serpent") or (nKFGU0v("pearlhop") or (XZV == "2" and (nKFGU0v("bigmom") and nKFGU0v("hop_bigmom")) or XZV == "3" and (nKFGU0v("tricster") or (nKFGU0v("depthking") and nKFGU0v("hopdepthking") or (nKFGU0v("setsail") and nKFGU0v("hop_setsail") or (nKFGU0v("preranodon") and nKFGU0v("hop_preranodon") or nKFGU0v("lordsaber") and nKFGU0v("hop_lordsaber"))))))) then
    da("NTT HUB", "Do you want turn off hop?", function()
        XJb0c("pearlhop", false)
        XJb0c("hop_bigmom", false)
        XJb0c("hop_setsail", false)
        XJb0c("hop_preranodon", false)
        XJb0c("hop_lordsaber", false)
        XJb0c("hop_serpent", false)
        XJb0c("tricster", false)
    end)
end
pcall(function()
    if ((game.ReplicatedStorage:WaitForChild("Chest")):WaitForChild("Modules")):WaitForChild("GateWorldList") then
        gXXlq = loadstring(Kcmy(game.ReplicatedStorage.Chest.Modules.GateWorldList))()
        if gXXlq then
            xB9qz = {}
            yuy5 = {}
            for E, r in pairs(gXXlq[({"FirstSea", "SecondSea", "ThirdSea"})[tonumber(XZV)]]) do
                table.insert(xB9qz, E)
                yuy5[E] = r.Position
            end
        end
    end
    do
        local n = game:GetService("Players")
        local d = game:GetService("Workspace")
        local g = game:GetService("TweenService")
        local p = game:GetService("RunService")
        local N = game:GetService("ContextActionService")
        local WW = game.ReplicatedStorage
        local A = n.LocalPlayer
        local t = A:WaitForChild("PlayerGui")
        if type(_G.StopKenESP) == "function" then
            pcall(_G.StopKenESP)
        end
        local D = {
            UPDATE_INTERVAL = 0.25,
            MOB_MAX_DISTANCE = 300,
            MAX_TOOLS = 10,
            ESP_SCALE = 1,
            REFERENCE_DISTANCE = 15,
            REQUIRE_PVP_FOR_KEN = false,
            TOGGLE_COOLDOWN = 0.35,
            REPLICATION_TIMEOUT = 1.5,
            SCREEN_BLACK_TRANSPARENCY = 0.88,
            PLAYER_COLOR = (Color3.fromRGB(245, 246, 255)),
            MON_COLOR = (Color3.fromRGB(255, 242, 210)),
            BOSS_COLOR = (Color3.fromRGB(255, 168, 168))
        }
        local B = true
        local Q = {}
        local U = {}
        local S = false
        local w = false
        local X = -math.huge
        local u, s, T
        local o, j, G
        _G.ken = false
        local function W(U, B, q)
            local P = Instance.new(U)
            for S, x in pairs(B or {}) do
                P[S] = x
            end
            if q then
                P.Parent = q
            end
            return P
        end
        local function J(f, i)
            return W("UICorner", {CornerRadius = UDim.new(0, i)}, f)
        end
        local function V(U, L, u, v)
            return W("UIStroke", {Color = L, Transparency = u, Thickness = v}, U)
        end
        local function O(G)
            local P = d:FindFirstChild("PlayerCharacters")
            return P and P:FindFirstChild(G.Name)
        end
        local function l(V)
            local H = O(V)
            if H and (H:IsA("Model") and (H:FindFirstChild("HumanoidRootPart") or H:FindFirstChild("Head"))) then
                return H
            end
            return V.Character
        end
        local function L(V)
            if not V or not V:IsA("Model") then
                return nil
            end
            return V:FindFirstChild("HumanoidRootPart") or (V:FindFirstChild("Head") or (V.PrimaryPart or V:FindFirstChildWhichIsA("BasePart")))
        end
        local function k(U)
            return U and U:FindFirstChildOfClass("Humanoid")
        end
        local function z(d)
            local y = O(d)
            local R = y and y:FindFirstChild("Services")
            if not R then
                local D = d.Character
                R = D and D:FindFirstChild("Services")
            end
            return R and R:FindFirstChild("KenOpen") or nil, R and R:FindFirstChild("KenHaki") or nil
        end
        local function F(B)
            local D = B:FindFirstChild("PlayerStats")
            if not D then
                return nil, nil
            end
            return D:FindFirstChild("PVP"), D:FindFirstChild("lvl")
        end
        local function a(L)
            local v = ((if not L or not (L:IsA("IntValue") or L:IsA("NumberValue")) then {nil} else nil))
            if v then
                return v[1]
            end
            return L.Value
        end
        local function H(G)
            if not G or not G:IsA("BoolValue") then
                return nil
            else
                return G.Value
            end
        end
        local function WD()
            local u = WW:FindFirstChild("Chest")
            local i = u and u:FindFirstChild("Remotes")
            local M = i and i:FindFirstChild("Functions")
            local L = M and M:FindFirstChild("KenEvent")
            if L and L:IsA("RemoteFunction") then
                return L
            end
            return nil
        end
        local function WA(j)
            local a = Color3.fromRGB(255, 97, 110)
            local d = Color3.fromRGB(255, 198, 91)
            local p = Color3.fromRGB(84, 239, 147)
            local k = ((function()
                if j < 5 / 10 then
                    return function()
                        return a:Lerp(d, j * 2)
                    end
                else
                    return nil
                end
            end)())
            if k then
                return k()
            end
            return d:Lerp(p, (j - 5 / 10) * 2)
        end
        local function WU(Z, F, q)
            local a = W("Frame", {
                Name = "HealthTrack",
                AnchorPoint = Vector2.new(5 / 10, 0),
                Position = UDim2.fromScale(5 / 10, F),
                Size = UDim2.fromScale(q, 26 / 100),
                BackgroundColor3 = Color3.fromRGB(13, 19, 25),
                BackgroundTransparency = 10 / 100,
                BorderSizePixel = 0,
                ClipsDescendants = true
            }, Z)
            W("UICorner", {CornerRadius = UDim.new(3 / 10, 0)}, a)
            V(a, Color3.fromRGB(220, 237, 242), 38 / 100, 12 / 10)
            local j = W("Frame", {
                Name = "HealthFill",
                Position = UDim2.fromScale(12 / 1000, 10 / 100),
                Size = UDim2.fromScale(976 / 1000, 80 / 100),
                BackgroundColor3 = Color3.fromRGB(84, 239, 147),
                BorderSizePixel = 0,
                ClipsDescendants = true
            }, a)
            W("UICorner", {CornerRadius = UDim.new(3 / 10, 0)}, j)
            W("UIGradient", {
                Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 195, 190))
            }),
                Rotation = 90
            }, j)
            local r = W("TextLabel", {
                Name = "HealthValue",
                Size = UDim2.fromScale(1, 1),
                BackgroundTransparency = 1,
                Text = "HP 100 / 100",
                Font = Enum.Font.GothamBold,
                TextScaled = true,
                TextColor3 = Color3.new(1, 1, 1),
                TextStrokeColor3 = Color3.fromRGB(5, 14, 17),
                TextStrokeTransparency = 30 / 100,
                ZIndex = 4
            }, a)
            W("UITextSizeConstraint", {MinTextSize = 1, MaxTextSize = 12 * D.ESP_SCALE}, r)
            return j, r
        end
        local function E(j, A)
            local w = math.max(1, A.MaxHealth)
            local g = math.max(0, A.Health)
            local W = math.clamp(g / w, 0, 1)
            j.hpFill.Size = UDim2.fromScale(976 / (1000 * W), 80 / 100)
            j.hpFill.BackgroundColor3 = WA(W)
            j.hpText.Text = ("HP %d / %d"):format(math.ceil(g), math.ceil(w))
        end
        local R = d.CurrentCamera
        local WB = R and R.ViewportSize.Y or 720
        local Wu = R and R.FieldOfView or 70
        local e = WB / (2 * (D.REFERENCE_DISTANCE * math.tan(math.rad(Wu) * 0.5)))
        local function Wx(V)
            return UDim2.fromOffset(math.max(1, math.floor(V.X.Scale * e + 5 / 10)), math.max(1, math.floor(V.Y.Scale * e + 5 / 10)))
        end
        local function Y(z, Z)
            return W("Frame", {
                Name = "KenInfo",
                AnchorPoint = (Vector2.new(5 / 10, 5 / 10 + (Z and Z.Y or 0))),
                Position = (UDim2.fromOffset(0, 0)),
                Size = (Wx(z)),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Visible = false
            }, G)
        end
        local function C(F, L, S, E)
            local J = D.ESP_SCALE
            local f = S and UDim2.fromScale(52 / (10 * J), 162 / (100 * J)) or UDim2.fromScale(4 * J, 116 / (100 * J))
            local z = Vector3.new(0, S and 38 / 10 + 81 / (100 * (J - 1)) or 31 / 10 + 58 / (100 * (J - 1)), 0)
            local Z = Y(f, Vector2.new(0, 5 / 10))
            local C = W("Frame", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1}, Z)
            local G, A = WU(C, 75 / 1000, S and 80 / 100 or 86 / 100)
            local B = W("TextLabel", {
                Name = "CharacterName",
                Position = UDim2.fromScale(0, S and 405 / 1000 or 50 / 100),
                Size = UDim2.fromScale(1, S and 25 / 100 or 36 / 100),
                BackgroundTransparency = 1,
                Text = F.Name,
                Font = Enum.Font.GothamBold,
                TextScaled = true,
                TextColor3 = S and D.PLAYER_COLOR or (E and D.BOSS_COLOR or D.MON_COLOR),
                TextStrokeColor3 = Color3.new(0, 0, 0),
                TextStrokeTransparency = 12 / 100
            }, C)
            W("UITextSizeConstraint", {MinTextSize = 1, MaxTextSize = 17 * D.ESP_SCALE}, B)
            local r
            if S then
                r = W("TextLabel", {
                    Name = "KenAndDodges",
                    Position = UDim2.fromScale(0, 69 / 100),
                    Size = UDim2.fromScale(1, 22 / 100),
                    BackgroundTransparency = 1,
                    Font = Enum.Font.GothamBold,
                    TextScaled = true,
                    Text = "KEN: UNKNOWN  |  DODGES: ?  |  PVP: ?",
                    TextColor3 = Color3.fromRGB(252, 253, 255),
                    TextStrokeColor3 = Color3.new(0, 0, 0),
                    TextStrokeTransparency = 8 / 100
                }, C)
                W("UITextSizeConstraint", {MinTextSize = 1, MaxTextSize = 13 * D.ESP_SCALE}, r)
            end
            local Q = W("Highlight", {
                Name = "KenOutline",
                Adornee = F,
                DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
                FillTransparency = 80 / 100,
                OutlineTransparency = 6 / 100,
                FillColor = E and D.BOSS_COLOR or Color3.fromRGB(245, 245, 252),
                OutlineColor = Color3.fromRGB(255, 255, 255)
            }, F)
            local V = {
                model = F,
                headGui = Z,
                headWorldSize = f,
                root = L,
                headOffset = z,
                highlight = Q,
                hpFill = G,
                hpText = A,
                name = B,
                status = r,
                isPlayer = S,
                toolSignature = "",
                toolSize = 0
            }
            if S then
                local u = UDim2.fromScale(48 / (10 * J), 56 / (100 * J))
                local G = Y(u, Vector2.new(0, -(5 / 10)))
                V.feetOffset = Vector3.new(0, -3, 0)
                V.feetWorldSize = u
                local a = W("Frame", {Name = "BackpackIcons", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1)}, G)
                W("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(9 / 1000, 0),
                    SortOrder = Enum.SortOrder.LayoutOrder
                }, a)
                V.feetGui = G
                V.holder = a
            end
            U[F] = V
            return V
        end
        local function i(D)
            local T = U[D]
            if not T then
                return
            end
            U[D] = nil
            if T.headGui then
                T.headGui:Destroy()
            end
            if T.feetGui then
                T.feetGui:Destroy()
            end
            if T.highlight then
                T.highlight:Destroy()
            end
        end
        local function r()
            for V in pairs(U) do
                i(V)
            end
        end
        local function m(M)
            if not M:IsA("Tool") then
                return ""
            end
            if M.TextureId ~= "" then
                return M.TextureId
            end
            local D = M:FindFirstChild("Handle")
            if D then
                local o = D:FindFirstChildWhichIsA("Decal")
                if o and o.Texture ~= "" then
                    return o.Texture
                end
                local B = D:FindFirstChildWhichIsA("SpecialMesh")
                if B and B.TextureId ~= "" then
                    return B.TextureId
                end
            end
            return "rbxasset://textures/ui/GuiImagePlaceholder.png"
        end
        local function Wd(A)
            local w, C = {}, {}
            local function t(R, E)
                if not R then
                    return
                else
                    for T, A in ipairs(R:GetChildren()) do
                        if A:IsA("Tool") and not C[A] then
                            C[A] = true
                            table.insert(w, {object = A, equipped = E})
                        end
                    end
                end
            end
            t(A.Character, true)
            local h = O(A)
            if h and h ~= A.Character then
                t(h, true)
            end
            t(A:FindFirstChildOfClass("Backpack"), false)
            table.sort(w, function(H, w)
                if H.equipped ~= w.equipped then
                    return H.equipped
                else
                    return H.object.Name < w.object.Name
                end
            end)
            return w
        end
        local function Wo(F, w)
            local u = {}
            for t = 1, math.min(#w, D.MAX_TOOLS) do
                local z = w[t]
                table.insert(u, tostring(z.object) .. ":" .. m(z.object) .. ":" .. tostring(z.equipped))
            end
            local T = table.concat(u, "|")
            if F.toolSignature == T then
                return
            end
            F.toolSignature = T
            for F, E in ipairs(F.holder:GetChildren()) do
                if not E:IsA("UIListLayout") then
                    E:Destroy()
                end
            end
            for y = 1, math.min(#w, D.MAX_TOOLS) do
                local A = w[y]
                local z = W("Frame", {
                    Name = "ToolIcon",
                    LayoutOrder = y,
                    Size = UDim2.fromScale(88 / 1000, 76 / 100),
                    BackgroundColor3 = Color3.fromRGB(14, 19, 25),
                    BackgroundTransparency = 8 / 100,
                    BorderSizePixel = 0
                }, F.holder)
                W("UICorner", {CornerRadius = UDim.new(2 / 10, 0)}, z)
                V(z, A.equipped and Color3.fromRGB(255, 220, 118) or Color3.fromRGB(224, 233, 241), A.equipped and 5 / 100 or 30 / 100, A.equipped and 17 / 10 or 1)
                W("ImageLabel", {
                    Name = "Icon",
                    Position = UDim2.fromScale(8 / 100, 8 / 100),
                    Size = UDim2.fromScale(84 / 100, 84 / 100),
                    BackgroundTransparency = 1,
                    ScaleType = Enum.ScaleType.Fit,
                    Image = m(A.object)
                }, z)
            end
        end
        local function Wk(S, t, g)
            local Q = l(S)
            local o = L(Q)
            local m = k(Q) or k(S.Character)
            if not o or (not m or m.Health <= 0) then
                return
            end
            g[Q] = true
            local B = U[Q]
            if not B or not B.headGui.Parent then
                if B then
                    i(Q)
                end
                B = C(Q, o, true, false)
            end
            B.root = o
            B.highlight.Adornee = Q
            local j, V = F(S)
            local W = V and tostring(V.Value) or "?"
            B.name.Text = ("%s [Lv. %s]"):format(S.Name, W)
            E(B, m)
            local D, v = z(S)
            local T = H(D)
            local f = T == nil and "?" or (T and "ON" or "OFF")
            local J = a(v)
            local q = J ~= nil and tostring(J) or "?"
            local x = j and (j:IsA("BoolValue") and (j.Value and "ON" or "OFF")) or "?"
            B.status.Text = ("KEN: %s  |  DODGES: %s  |  PVP: %s"):format(f, q, x)
            if f == "ON" then
                B.highlight.FillTransparency = 55 / 100
                B.highlight.OutlineTransparency = 0
                B.highlight.OutlineColor = Color3.fromRGB(246, 250, 255)
            else
                B.highlight.FillTransparency = 82 / 100
                B.highlight.OutlineTransparency = 13 / 100
                B.highlight.OutlineColor = Color3.fromRGB(200, 210, 229)
            end
            Wo(B, Wd(S))
        end
        local function f(W, R)
            if not W then
                return
            end
            for g, E in ipairs(W:GetChildren()) do
                if E:IsA("Model") then
                    R(E)
                elseif E:IsA("Folder") then
                    f(E, R)
                end
            end
        end
        local function y(u, g, O, r)
            local W = L(u)
            local a = k(u)
            if not W or (not a or a.Health <= 0) then
                return
            end
            if (W.Position - O.Position).Magnitude > D.MOB_MAX_DISTANCE then
                return
            end
            r[u] = true
            local J = U[u]
            if not J or not J.headGui.Parent then
                if J then
                    i(u)
                end
                J = C(u, W, false, g)
            end
            J.root = W
            J.highlight.Adornee = u
            J.name.Text = u.Name
            E(J, a)
        end
        o = W("ScreenGui", {
            Name = "KenOverlay",
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            DisplayOrder = 9997,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        }, t)
        j = W("Frame", {
            Name = "UniformBlackShade",
            Size = (UDim2.fromScale(1, 1)),
            BackgroundColor3 = (Color3.new(0, 0, 0)),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 1
        }, o)
        G = W("ScreenGui", {Name = "KenESP", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 9998}, t)
        local function Wz()
            if not B or not _G.ken then
                return
            end
            local v = d.CurrentCamera
            if not v then
                return
            end
            for e, M in pairs(U) do
                local R, r, z, F, g, J, L
                R = M.root
                if R and R.Parent then
                    r, z = v:WorldToViewportPoint(R.Position + M.headOffset)
                    F = z and r.Z > 0
                    M.headGui.Visible = F
                    if F then
                        M.headGui.Position = UDim2.fromOffset(r.X, r.Y)
                    end
                    if M.feetGui then
                        g, J = v:WorldToViewportPoint(R.Position + M.feetOffset)
                        L = J and g.Z > 0
                        M.feetGui.Visible = L
                        if L then
                            M.feetGui.Position = UDim2.fromOffset(g.X, g.Y)
                        end
                    end
                else
                    M.headGui.Visible = false
                    if M.feetGui then
                        M.feetGui.Visible = false
                    end
                end
            end
        end
        table.insert(Q, p.RenderStepped:Connect(Wz))
        local function WH()
            local P = d.CurrentCamera and d.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
            local n = math.ceil(math.max(P.X, P.Y) * (15 / 10))
            local X = W("Frame", {
                Name = "KenActivationBurst",
                AnchorPoint = (Vector2.new(5 / 10, 5 / 10)),
                Position = (UDim2.fromScale(5 / 10, 5 / 10)),
                Size = (UDim2.fromOffset(10, 10)),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 3
            }, o)
            J(X, 9999)
            local T = V(X, Color3.fromRGB(240, 247, 255), 10 / 100, 35 / 10)
            local U = W("Frame", {
                AnchorPoint = (Vector2.new(5 / 10, 5 / 10)),
                Position = (UDim2.fromScale(5 / 10, 5 / 10)),
                Size = (UDim2.fromScale(1, 1)),
                BackgroundColor3 = (Color3.fromRGB(232, 242, 252)),
                BackgroundTransparency = 94 / 100,
                BorderSizePixel = 0,
                ZIndex = 2
            }, X)
            J(U, 9999);
            (g:Create(X, TweenInfo.new(45 / 100, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(n, n)})):Play();
            (g:Create(T, TweenInfo.new(45 / 100), {Transparency = 1, Thickness = 0})):Play();
            (g:Create(U, TweenInfo.new(45 / 100), {BackgroundTransparency = 1})):Play()
            task.delay(50 / 100, function()
                if X.Parent then
                    X:Destroy()
                end
            end)
        end
        local function Wg(e, m)
            S = e;
            (g:Create(j, TweenInfo.new(30 / 100, Enum.EasingStyle.Quad), {BackgroundTransparency = e and D.SCREEN_BLACK_TRANSPARENCY or 1})):Play()
            if e and m then
                WH()
            end
            if not e then
                for e, y in ipairs(o:GetChildren()) do
                    if y.Name == "KenActivationBurst" then
                        y:Destroy()
                    end
                end
            end
        end
        local function h(R)
            R = R == true
            _G.ken = R
            if S ~= R then
                Wg(R, R)
            end
            if not R and next(U) ~= nil then
                r()
            end
        end
        local function P()
            if not B or w then
                return
            end
            local e = os.clock()
            if e - X < D.TOGGLE_COOLDOWN then
                return
            end
            local y, P = z(A)
            local r = H(y)
            local t = a(P)
            if r == nil or t == nil then
                return
            end
            local v = not r
            if v then
                local X = l(A)
                local v = k(X) or k(A.Character)
                if t <= 0 or (not v or v.Health <= 0) then
                    h(false)
                    return
                end
                if D.REQUIRE_PVP_FOR_KEN then
                    local r = select(1, F(A))
                    if not r or (not r:IsA("BoolValue") or not r.Value) then
                        h(false)
                        return
                    end
                end
            end
            local Q = WD()
            if not Q then
                return
            end
            w = true
            X = e
            task.spawn(function()
                local f, l, k, x, X, P
                f, l = pcall(function()
                    return Q:InvokeServer()
                end)
                if not B then
                    return
                else
                    if not f then
                        warn(tostring(l))
                    else
                        k = os.clock() + D.REPLICATION_TIMEOUT
                        while B and os.clock() < k do
                            do
                                local j
                                j = H(select(1, z(A)))
                                if j == v then
                                    break
                                else
                                    task.wait(5 / 100)
                                end
                            end
                        end
                    end
                    if B then
                        x, X = z(A)
                        P = H(x) == true and (a(X) or 0) > 0
                        h(P)
                        w = false
                    end
                end
            end)
        end
        local function WK()
            local X = t:WaitForChild("MainGui", 10)
            local l = X and X:WaitForChild("MobileMove", 10)
            local n = l and l:WaitForChild("Ken", 10)
            if not B or (not n or not n:IsA("GuiButton")) then
                return
            end
            s = n
            T = n.Visible
            u = n:Clone()
            u.Name = "CustomKen"
            for y, c in ipairs(u:GetDescendants()) do
                if c:IsA("LocalScript") or (c:IsA("Script") or c:IsA("ModuleScript")) then
                    c:Destroy()
                end
            end
            u.Parent = n.Parent
            n.Visible = false
            u.Visible = true
            table.insert(Q, u.Activated:Connect(P))
        end
        local function q()
            if not B then
                return
            end
            B = false
            _G.ken = false
            N:UnbindAction("KenToggle")
            for j, Q in ipairs(Q) do
                Q:Disconnect()
            end
            r()
            if o then
                o:Destroy()
            end
            if G then
                G:Destroy()
            end
            if u then
                u:Destroy()
            end
            if s and s.Parent then
                s.Visible = T
            end
            if _G.StopKenESP == q then
                _G.StopKenESP = nil
            end
        end
        _G.StopKenESP = q
        N:UnbindAction("KenToggle")
        N:BindActionAtPriority("KenToggle", function(e, x)
            if x == Enum.UserInputState.Begin then
                P()
            end
            return Enum.ContextActionResult.Sink
        end, false, 9999, Enum.KeyCode.Y)
        task.spawn(WK)
        task.spawn(function()
            while B do
                do
                    local F, O
                    F, O = pcall(function()
                        local w, M, D, o, s, j, R, Y
                        w, M = z(A)
                        D = H(w)
                        o = a(M)
                        s = D == true and (o ~= nil and o > 0)
                        if _G.ken == (true ~= s) then
                            h(s)
                        end
                        if not s then
                            if next(U) ~= nil then
                                r()
                            end
                            return
                        else
                            j = L(l(A))
                            if not j then
                                r()
                                return
                            else
                                R = {}
                                for l, x in ipairs(n:GetPlayers()) do
                                    if x ~= A then
                                        pcall(Wk, x, j, R)
                                    end
                                end
                                Y = d:FindFirstChild("Monster")
                                if Y then
                                    f(Y:FindFirstChild("Mon"), function(u)
                                        pcall(y, u, false, j, R)
                                    end)
                                    f(Y:FindFirstChild("Boss"), function(u)
                                        pcall(y, u, true, j, R)
                                    end)
                                end
                                for e in pairs(U) do
                                    if not R[e] then
                                        i(e)
                                    end
                                end
                            end
                        end
                    end)
                    if not F then
                        warn(tostring(O))
                    end
                    task.wait(D.UPDATE_INTERVAL)
                end
            end
        end)
    end
end)
if xB9qz == nil or #xB9qz == 0 then
    xB9qz = {"No Data"}
end
function gEIW(g)
    if not _G.pos_skill then
        return
    end
    if _G.pos_skill and RFpy(_G.pos_skill) >= 100 then
        return
    end
    spawn(function()
        local j = {}
        j[47] = g
        local b = {}
        b.Type = "Down"
        b.MouseHit = _G.pos_skill
        j[35] = b
        local k = j
        game:GetService("ReplicatedStorage").Chest.Remotes.Functions.SkillAction:InvokeServer(k[47], k[35])
        local W = {}
        W[107] = g
        local U = {}
        U.Type = "Up"
        U.MouseHit = _G.pos_skill
        W[33] = U
        local v = W
        game:GetService("ReplicatedStorage").Chest.Remotes.Functions.SkillAction:InvokeServer(v[107], v[33])
    end)
end;
(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/NTT-HUB/Script/refs/heads/main/run"))()
end)()
NKyikD0(P, "Event")
if mOTRLwc() then
    d8pV(lwIi8X, YfPq, P, "Auto Boss Skull King/Spawn", "event3")
    d8pV(baT, BVXcF, P, "Auto Farm Candy", "candy")
    function OeWLRf()
        return game:GetService("ReplicatedStorage").Chest.Remotes.Functions.EtcFunction:InvokeServer("SpawnSkullKing")
    end
    function Csk1WWl()
        local J = game.workspace.SeaMonster:FindFirstChild("Skull King")
        if J and J.Humanoid.Health > 0 then
            return J
        end
    end
    spawn(function()
        while task.wait() do
            pcall(function()
                local T, U, n
                _G.skullking = Csk1WWl()
                if nKFGU0v("event3") then
                    if _G.core_control and _G.core_control >= 3 then
                        return
                    else
                        T = dbz6pRH(game:GetService("Players").LocalPlayer.PlayerStats.Material.Value).Candy
                        U = _G.skullking
                        if U then
                            bcpg(U.HumanoidRootPart.CFrame)
                        else
                            if T and T >= 200 then
                                IDp(CFrame.new(-3376, 104, 4346))
                                z8Jf8qa("ssk", OeWLRf)
                            else
                                n = LPQH("Skull Pirate [Lv. 3050]")
                                if n then
                                    bcpg(n.HumanoidRootPart.CFrame)
                                else
                                    IDp(CFrame.new(-6400, 78, 6907))
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
    spawn(function()
        while task.wait() do
            pcall(function()
                local X
                if nKFGU0v("candy") then
                    if _G.core_control and _G.core_control >= 3 then
                        return
                    else
                        X = LPQH("Skull Pirate [Lv. 3050]")
                        if X then
                            bcpg(X.HumanoidRootPart.CFrame)
                        else
                            IDp(CFrame.new(-6400, 78, 6907))
                        end
                    end
                end
            end)
        end
    end)
elseif VyZC() then
    d8pV(lwIi8X, YfPq, P, "Auto Boss Jack", "event1")
    d8pV(baT, BVXcF, P, "Auto Hop Boss Jack", "event2")
    d8pV(n6p, VKe, P, "Auto Farm Candy", "candy")
    kpwu = 0
    spawn(function()
        while task.wait() do
            pcall(function()
                local Q
                _G.jack = s00WNaQ("Jack o lantern [Lv. 10000]")
                if nKFGU0v("event1") then
                    Q = _G.jack
                    if Q then
                        bcpg(Q.HumanoidRootPart.CFrame)
                        kpwu = 0
                    else
                        if nKFGU0v("event2") then
                            IDp(CFrame.new(2799, 408, 5682))
                            z8Jf8qa("jack", function()
                                kpwu = kpwu + 1
                            end)
                            if kpwu >= 10 then
                                wi4Eg(1, 0)
                            end
                        end
                    end
                end
            end)
        end
    end)
    spawn(function()
        while task.wait() do
            pcall(function()
                local P
                if nKFGU0v("candy") then
                    if _G.core_control and _G.core_control >= 3 then
                        return
                    else
                        P = LPQH("Jungle Gorilla [Lv. 4300]")
                        if P then
                            bcpg(P.HumanoidRootPart.CFrame)
                        else
                            IDp(CFrame.new(CFrame.new(4215, 181, 9081)))
                        end
                    end
                end
            end)
        end
    end)
end
NKyikD0(z, "Setting")
QLZ(Ej5gcuj, Q1R, abDo, z, "Tool Multi Select", BMwkbvT, _G.Setting.maintool)
QLZ(Det, cBd, IVYKUNC, z, "Skill Melee Select", YaDJ6T, _G.Setting.skill_melee)
QLZ(Det, tA7, TPOD, z, "Skill Sword Select", {"Z", "X"}, _G.Setting.skill_sword)
QLZ(Det, vgYpr, bWL7W, z, "Skill Fruit Select", YaDJ6T, _G.Setting.skill_fruit)
dqh4Sz(z, "Distance Value", 8, 30, "y")
d8pV(qhLkJ, YVImL, z, "Auto Executor Script", "autoexe")
d8pV(YYJv0g, zex, z, "Delete All Effect", "delele_lag")
d8pV(hXKn, yTt2xsE, z, "Auto Accept Ally", "ally")
d8pV(JOan, tDb, z, "Auto Rejoin If Memory So High", "autorejoin")
dqh4Sz(z, "Memory Value Value", 3500, 10000, "memory")
d8pV(jLEqE, PQPf, z, "Black Screen", "blackscreen")
d8pV(q2V, uTtoxT, z, "Auto On Race", "onrace")
NKyikD0(z, "Webhook Item")
rOr(Srgcl, z, nKFGU0v("webhook_item"))
NKyikD0(z, "Webhook Material")
rOr(MOA, z, nKFGU0v("webhook_material"))
d8pV(lYxVuy, xp9, z, "Webhook Item", "webhook_onof")
local function dO(d)
    d = (d:gsub("<font[^>]*>", "")):gsub("</font>", "")
    d = d:gsub("^%s*Obtained%s+", "")
    local l, q = d:match("^(.-)%s+x(%d+)%.?%s*$")
    if l then
        return {l, "x" .. q, 1}
    end
    local p, v = d:match("^(.-)%s+(But you already own the item%. How lucky!.*)$")
    if p then
        return {p, v, 2}
    end
    p, v = d:match("^(.-)%s+(Check Your Inventory!.*)$")
    if p then
        return {p, v, 3}
    end
    return d
end
spawn(function()
    while task.wait() do
        pcall(function()
            _G.Setting.webhook_item = {Srgcl.Text}
            _G.Setting.webhook_material = {MOA.Text}
            if nKFGU0v("webhook_onof") then
                for A, L in pairs(game.Players.LocalPlayer.PlayerGui.Popup.Frame:GetChildren()) do
                    local u, S, H, v, N
                    if L.Name ~= "Done" and (L.ClassName == "Frame" and L:FindFirstChild("TextLabel")) then
                        L.Name = "Done"
                        u = dO(L.TextLabel.Text)
                        if u then
                            S = {
                                embeds = {
                                {
                                title = "Notification",
                                color = 7498202,
                                fields = {
                                {
                                name = "Player",
                                value = "```Name : " .. game.Players.LocalPlayer.Name .. "```",
                                inline = true
                            },
                                {
                                name = (if u[3] == 1 then "Material" else "Item"),
                                value = "```" .. u[1] .. " " .. u[2] .. "```",
                                inline = true
                            }
                            }
                            }
                            }
                            }
                            H = {["Content-Type"] = "application/json"}
                            v = (game:GetService("HttpService")):JSONEncode(S)
                            N = http_request or (request or (HttpPost or syn.request))
                            N({
                                Url = ((if u[3] == 1 then nKFGU0v("webhook_material") else nKFGU0v("webhook_item"))),
                                Body = v,
                                Method = "POST",
                                Headers = H
                            })
                        end
                    end
                end
            end
        end)
    end
end)
Hfl = true
spawn(function()
    while task.wait(1) do
        pcall(function()
            if nKFGU0v("delele_lag") then
                if not Hfl then
                    return
                else
                    Hfl = false
                    for U, w in ipairs((game:GetService("ReplicatedStorage")):GetDescendants()) do
                        if w:IsA("ParticleEmitter") or (w:IsA("Trail") or w:IsA("Beam")) then
                            w.Enabled = false
                        end
                        task.wait(1 / 10)
                    end
                end
            end
        end)
    end
end)
Bo8Oig = true
spawn(function()
    while task.wait(1) do
        pcall(function()
            local u, E, t
            if nKFGU0v("autoexe") and Bo8Oig then
                Bo8Oig = false
                u = (if NP7K8k then "https://raw.githubusercontent.com/NTT-HUB/Script/refs/heads/main/prenium" else "https://raw.githubusercontent.com/NTT-HUB/Script/refs/heads/main/main")
                E = queue_on_teleport or (queueonteleport or syn and syn.queue_on_teleport)
                t = string.format("loadstring(game:HttpGet(%q))()", u)
                if E then
                    E(t)
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait(1) do
        pcall(function()
            if nKFGU0v("ally") then
                for W, t in pairs(game.Players.LocalPlayer.PlayerGui.MainGui.StarterFrame.AllyFrame.ScrollingFrame:GetChildren()) do
                    local z
                    if t.ClassName == "TextButton" and t.FunctionFrame.Accept.Visible then
                        z = {[1] = {Action = "Accept", Target = t.Name}}
                        game.ReplicatedStorage.Chest.Remotes.Functions.Ally:InvokeServer(unpack(z))
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait(1) do
        pcall(function()
            if nKFGU0v("autorejoin") then
                game:GetService("CoreGui").loxPromptGui.promptOverlay.ChildAdded:Connect(function(s)
                    if s.Name == "ErrorPrompt" and (s:FindFirstChild("MessageArea") and s.MessageArea:FindFirstChild("ErrorFrame")) then
                        if tonumber((game:GetService("Stats")):GetTotalMemoryUsageMb()) >= nKFGU0v("memory") then
                            (game:GetService("TeleportService")):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
                        end
                    end
                end)
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            if nKFGU0v("blackscreen") then
                YG5XGe.Visible = true
            else
                YG5XGe.Visible = false
            end
        end)
    end
end)
NKyikD0(E, "Main")
d8pV(uMwvU9s, WiPQGL, E, "Auto Farm Level", "level")
d8pV(y2Q, NRHQ, E, "Auto All Daily Quest", "dailyquest")
d8pV(x4BlU6C, JsH8yG, E, "Auto Farm Mob Near", "mobnear")
dqh4Sz(E, "Distance Value", 100, 1000, "mobnear_value")
NKyikD0(E, "Conquest")
d8pV(z5YA4p5, gAORC9, E, "Auto Conquest", "conquest")
d8pV(Iqz, qlg2, E, "Auto Buy Chest Common", "buychest")
d8pV(zsKXhzA, Ei4Z, E, "Conquest Hop", "conquest_hop")
NKyikD0(E, "Material")
m62Pr(ifb8r, gt6, IHYCP, E, "Material", ZhZ6gDx, "material_select")
d8pV(SbWtG, JWtf, E, "Auto Farm Material", "material")
NKyikD0(E, "Material Multi")
QLZ(Ye6, VMxe, DjhW, E, "Material Multi", ZhZ6gDx, _G.Setting.material_multi[XZV])
d8pV(wUDIUl, MCUs9, E, "Auto Farm Material Multi", "materialmulti")
if VyZC() then
    d8pV(dtRby, rQm1, E, "Auto Take Noir Pear", "pearl")
    d8pV(ZzkMm, tvPQxaS, E, "Hop Noir Pear", "pearlhop")
end
d8pV(WkoYDr, Flma6, E, "Auto Farm Log", "log")
N5Hi = {
    {"Undead's Ooze", 10, "1"},
    {"Angellic's Feather", 15, "1"},
    {"Fresh Fish", 50, "1"},
    {"Pile of Bones", 10, "2"}
}
twf0sM = function(E)
    game.ReplicatedStorage.Chest.Remotes.Functions.Quest:InvokeServer("take", E)
end
spawn(function()
    while task.wait() do
        pcall(function()
            if nKFGU0v("level") or (nKFGU0v("kioru") and UcImOr == "money" or (nKFGU0v("bt") and Ef85d or nKFGU0v("galefirst") and gale_staus[1])) then
                local r = game.Players.LocalPlayer.PlayerStats.lvl.Value
                local S = dbz6pRH(game:GetService("Players").LocalPlayer.PlayerStats.Material.Value)
                if not S then
                    return
                end
                if dbz6pRH(game.Players.LocalPlayer.PlayerStats.TitleStore.Value)["Kraken Challenger"] then
                    if not VyZC() then
                        fsurP(3)
                    end
                else
                    if r >= 4000 then
                        local x = game.Workspace.Monster.Boss:FindFirstChild("Tentacle")
                        local w = ((function()
                            if x then
                                return function()
                                    return bcpg(x.HumanoidRootPart.CFrame * CFrame.new(-30, -30, 0))
                                end
                            else
                                return nil
                            end
                        end)())
                        if w then
                            return w()
                        end
                        if S["Heart of Sea"] then
                            if XZV ~= "2" then
                                return fsurP(2)
                            end
                            aYMvJS("Summon Tentacle")
                        else
                            for g, G in ipairs(N5Hi) do
                                local i, o
                                if S[G[1]] == nil or S[G[1]] < G[2] then
                                    if XZV ~= G[3] then
                                        return fsurP(tonumber(G[3]))
                                    else
                                        i = Gktt[G[1]]
                                        o = LPQH(i[1])
                                        if o then
                                            bcpg(o.HumanoidRootPart.CFrame)
                                        else
                                            IDp(i[2])
                                        end
                                        return
                                    end
                                end
                            end
                            if S.Log == nil or S.Log < 50 then
                                local a = QsdvwKg()
                                if a then
                                    IDp(a)
                                    _G.pos_skill = a
                                end
                                return
                            end
                            if S["Sea King's Blood"] == nil then
                                local Y = ((function()
                                    if NP7K8k and not _G.skhd then
                                        return function()
                                            return oUlf9()
                                        end
                                    else
                                        return nil
                                    end
                                end)())
                                if Y then
                                    return Y()
                                end
                            else
                                task.wait(2)
                                local n = R
                                return game.ReplicatedStorage.Chest.Remotes.Functions.CraftMaterial:InvokeServer(n[113], n[120])
                            end
                            if XZV ~= "2" then
                                return fsurP(2)
                            end
                        end
                    end
                end
                if XZV == "1" and r >= 2400 then
                    if game.Players.LocalPlayer.PlayerStats.SecondSeaProgression.Value == "No" then
                        local F = ((function()
                            if (game.Players.LocalPlayer.PlayerGui.MainGui.StarterFrame.Inventory_Frame.ScrollingFrameMaterial:FindFirstChild("Map")) then
                                return function()
                                    return aYMvJS("Traveler")
                                end
                            else
                                return nil
                            end
                        end)())
                        if F then
                            return F()
                        end
                    else
                        task.wait(1)
                        return fsurP(2)
                    end
                end
                if _G.core_control and _G.core_control >= 3 then
                    return
                end
                local x = wYLqiGr()
                z8Jf8qa("lv", twf0sM(x[2]))
                local m = LPQH(x[1])
                if m then
                    bcpg(m.HumanoidRootPart.CFrame)
                else
                    IDp(x[3])
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            local P, U, N, L, z, B, A, o, G, X
            if nKFGU0v("dailyquest") then
                P = game.Players.LocalPlayer
                U, N, L = P.CurrentQuest.Value, P.PlayerStats.DailyQuest.Value, P.PlayerStats.lvl.Value
                if U and (#U > 1 and (_G.dl2 and (_G.dl and not string.find(N, _G.dl2, 1, true)))) then
                    if _G.dl[1][2] == "mob" then
                        z = LPQH(_G.dl[2])
                        if z then
                            bcpg(z.HumanoidRootPart.CFrame)
                        else
                            IDp(_G.dl[3])
                        end
                    elseif _G.dl[1][2] == "tp" then
                        IDp(_G.dl[2]())
                    elseif _G.dl[1][2] == "fp" then
                        B = _G.dl[2]()
                        IDp(B[1])
                        z8Jf8qa("fp_daily", function()
                            tULJ(B[2])
                        end)
                    elseif _G.dl[1][2] == "talk" then
                        z8Jf8qa("talk_npc", function()
                            aYMvJS(_G.dl[2])
                        end)
                    elseif _G.dl[1][2] == "box" then
                        if game.Players.LocalPlayer.Character:FindFirstChild(game.Players.LocalPlayer.Name .. "QuestBox") then
                            aYMvJS(_G.dl[3])
                        else
                            z8Jf8qa("box box", function()
                                IDp(_G.dl[2]()[1])
                                tULJ(_G.dl[2]()[2])
                            end, 5 / 10)
                        end
                    elseif _G.dl[1][2] == "code" then
                        IDp(CFrame.new(2089, 404, -1422))
                        task.wait(5 / 10)
                        if game.Players.LocalPlayer.PlayerGui:FindFirstChild("LeePungg_PuzzleLibs") then
                            A = _G.dl[2]()
                            game.Players.LocalPlayer.PlayerGui.LeePungg_PuzzleLibs.PuzzleRemote:InvokeServer(unpack(A))
                        elseif game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("LoreGUI") then
                            o = {[1] = {Quest = "Krakenci Codes", Gui = "PuzzleLibs"}}
                            game:GetService("Players").LocalPlayer.PlayerGui.LoreGUI.LOREGUI_REMOTE:InvokeServer(unpack(o))
                        else
                            G = {[1] = workspace.AllNPC:FindFirstChild("Lore Kraken Codex Giver")}
                            game.ReplicatedStorage.Chest.Remotes.Functions.CheckQuest:InvokeServer(unpack(G))
                        end
                    elseif _G.dl[1][2] == "ship" then
                        X = game.Workspace.Ships:FindFirstChild(game.Players.LocalPlayer.Name .. " Ship")
                        if X then
                            if smi() then
                                IDp(_G.dl[4]())
                            else
                                z8Jf8qa("tp_ship", function()
                                    IDp(X.DriverSeat.CFrame)
                                end)
                                tULJ(X.DriverSeat.ProximityPrompt)
                            end
                        else
                            IDp(_G.dl[2])
                            task.wait(1)
                            _G.dl[3]()
                        end
                    end
                else
                    for E, A in pairs(caMR) do
                        local F
                        F = caMR[E]
                        if not string.find(N, E, 1, true) and L >= F[1][1] then
                            game.Players.LocalPlayer.Character.Humanoid.Sit = false
                            game.ReplicatedStorage.Chest.Remotes.Functions.Quest:InvokeServer("take", E)
                            _G.dl = F
                            _G.dl2 = E
                            return
                        end
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            if nKFGU0v("mobnear") then
                if _G.core_control and _G.core_control >= 3 then
                    return
                else
                    for A, o in pairs(game.Workspace.Monster:GetChildren()) do
                        if o.ClassName == "Folder" then
                            for z, B in pairs(o:GetChildren()) do
                                if B.ClassName == "Model" then
                                    if RFpy(B.HumanoidRootPart.Position) < nKFGU0v("mobnear_value") then
                                        if B.Humanoid.Health > 0 then
                                            IDp(B.HumanoidRootPart.CFrame * (CFrame.new(0, nKFGU0v("y"), 0) * CFrame.Angles(math.rad(-90), 0, 0)))
                                            _G.pos_skill = B.HumanoidRootPart.CFrame
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait(1) do
        pcall(function()
            local x
            if nKFGU0v("buychest") then
                x = {[1] = "BuyChest", [2] = {ChestName = "Common", Price = 29}}
                game.ReplicatedStorage.Chest.Remotes.Functions.CrewOperations:InvokeServer(unpack(x))
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            if nKFGU0v("conquest") then
                if _G.core_control and _G.core_control >= 3 then
                    return
                else
                    if QUXU() then
                        IDp(QUXU().CFrame)
                    else
                        if nKFGU0v("conquest_hop") then
                            g93Q1F()
                        end
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            local q, m
            if nKFGU0v("material") then
                if _G.core_control and _G.core_control >= 3 then
                    return
                else
                    q = Gktt[rBrUGg3(nKFGU0v("material_select"))]
                    m = LPQH(q[1])
                    if m then
                        IDp(m.HumanoidRootPart.CFrame * (CFrame.new(0, nKFGU0v("y"), 0) * CFrame.Angles(math.rad(-90), 0, 0)))
                        _G.pos_skill = m.HumanoidRootPart.CFrame
                    else
                        IDp(q[2])
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            local o
            if nKFGU0v("materialmulti") then
                if _G.core_control and _G.core_control >= 3 then
                    return
                else
                    o = eWM(_G.Setting.material_multi[XZV], 1)
                    z8Jf8qa("material_multi", function()
                        cCc = {}
                        for F = 1, #o do
                            table.insert(cCc, Gktt[o[F]][1])
                        end
                    end)
                    for h = 1, #o do
                        local f, R
                        f = Gktt[o[h]]
                        R = LPQH(cCc)
                        if R then
                            return bcpg(R.HumanoidRootPart.CFrame)
                        else
                            IDp(f[2])
                            task.wait(1)
                        end
                    end
                end
            end
        end)
    end
end)
if VyZC() then
    spawn(function()
        while task.wait() do
            pcall(function()
                local H
                if nKFGU0v("pearl") and VyZC() then
                    if _G.core_control and _G.core_control >= 3 then
                        return
                    else
                        H = i2C6k1()
                        if H then
                            IDp(H[1])
                            tULJ(H[2])
                        else
                            if nKFGU0v("pearlhop") then
                                g93Q1F()
                            end
                        end
                    end
                end
            end)
        end
    end)
end
spawn(function()
    while task.wait() do
        pcall(function()
            local M
            if nKFGU0v("log") then
                if _G.core_control and _G.core_control >= 3 then
                    return
                else
                    M = QsdvwKg()
                    if M then
                        IDp(M)
                        _G.pos_skill = M
                    end
                end
            end
        end)
    end
end)
NKyikD0(e, "Start")
d8pV(KfAj5u, kxEgZ, e, "Melee", "melee")
d8pV(x7Z, Wx2Nq, e, "Defense", "defense")
d8pV(XhnC, eHDv, e, "Sword", "sword")
d8pV(eTHT1, LOAARFi, e, "Fruit", "fruit")
spawn(function()
    while task.wait() do
        pcall(function()
            if game.Players.LocalPlayer.PlayerStats.Points.Value > 0 then
                if nKFGU0v("melee") then
                    km9x6("Melee")
                end
                if nKFGU0v("defense") then
                    km9x6("Defense")
                end
                if nKFGU0v("sword") then
                    km9x6("Sword")
                end
                if nKFGU0v("fruit") then
                    km9x6("Fruit")
                end
            end
        end)
    end
end)
NKyikD0(d, "Setting")
dqh4Sz(d, "Time Hop", 5, 15, "time_hop")
d8pV(hqkP0, AFLa, d, "Not Join Same Server", "notjoinsamesv")
NKyikD0(d, "Normal Boss/Boss Multi")
m62Pr(TG3WjP, uuDRYjt, XoW, d, "Boss", HVxJpFD, "boss_select")
d8pV(HK3y0AC, Tmc04oo, d, "Auto Kill Boss", "boss")
QLZ(Z0pd, vIv8vw, W6iSbh, d, "Boss Multi Select", HVxJpFD, _G.Setting.boss_multi[XZV])
d8pV(fX4, NAiTNC, d, "Auto Kill Boss Multi", "bossmulti")
d8pV(VS0zW, JCH8zYM, d, "Auto Quest Boss", "bossquest")
NKyikD0(d, "Boss Event/Hop")
d8pV(exBmb, zTlq, d, "Auto Kill Serpent", "serpent")
d8pV(LJz8YL, yGUOT, d, "Serpent Hop", "hop_serpent")
PYaeN7I(U1j, DTM, d, nKFGU0v("serpent_tool"), function()
    XJb0c("serpent_tool", "Set Tool Sword : " .. Gak()[2])
    U1j.Text = "Set Tool Sword : " .. Gak()[2]
end)
spawn(function()
    while task.wait() do
        pcall(function()
            local x, w
            if nKFGU0v("boss") then
                if _G.core_control and _G.core_control >= 3 then
                    return
                else
                    x = rBrUGg3(nKFGU0v("boss_select"))
                    w = LPQH(x)
                    if w then
                        if nKFGU0v("bossquest") then
                            z8Jf8qa("bossquest", function()
                                game.ReplicatedStorage.Chest.Remotes.Functions.Quest:InvokeServer("take", "Kill 1 " .. w.Name:match("^(.-)%s*%["))
                            end)
                        end
                        return bcpg(w.HumanoidRootPart.CFrame)
                    else
                        IDp(RoVthRM[x])
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            local C
            if nKFGU0v("bossmulti") then
                if _G.core_control and _G.core_control >= 3 then
                    return
                else
                    C = eWM(_G.Setting.boss_multi[XZV], 1)
                    for X = 1, #C do
                        local v, x
                        v = C[X]
                        x = LPQH(C)
                        if x then
                            if nKFGU0v("bossquest") then
                                z8Jf8qa("bossquest", game.ReplicatedStorage.Chest.Remotes.Functions.Quest:InvokeServer("take", "Kill 1 " .. x.Name:match("^(.-)%s*%[")))
                            end
                            return bcpg(x.HumanoidRootPart.CFrame)
                        else
                            IDp(RoVthRM[v])
                            task.wait(1)
                        end
                    end
                end
            end
        end)
    end
end)
m3LeSER = 0
spawn(function()
    while task.wait() do
        pcall(function()
            local m, A, d, X
            _G.serpent = s00WNaQ("Serpent")
            m, A, d, X = _G.serpent, Iuc6h(), game.Players.LocalPlayer.Inventory, rBrUGg3(nKFGU0v("serpent_tool"))
            exBmb.Text = "Auto Kill Serpent | " .. (function()
                if m then
                    return "Boss Spawn"
                elseif A then
                    return "Whirlpool Spawn"
                elseif m3LeSER >= 10 then
                    return "Do Hop"
                else
                    return "Not Spawn"
                end
            end)()
            if nKFGU0v("serpent") then
                if nKFGU0v("hop_serpent") then
                    if m or A then
                        m3LeSER = 0
                    else
                        z8Jf8qa("serpent_t", function()
                            m3LeSER = m3LeSER + 1
                        end)
                        if m3LeSER >= nKFGU0v("time_hop") then
                            z8Jf8qa("serpent_t1", function()
                                wi4Eg(1, 30)
                            end, 1 / 10)
                        end
                    end
                end
                if m then
                    if Gak()[2] == "Basic Rod" then
                        if X ~= "None" and d:FindFirstChild(X) then
                            z8Jf8qa("tool", function()
                                f8MkTRD(X)
                            end)
                        end
                    end
                    IDp(m.HumanoidRootPart.CFrame * (CFrame.new(0, 80, 0) * CFrame.Angles(math.rad(-90), 0, 0)))
                    _G.pos_skill = m.HumanoidRootPart.CFrame
                elseif A and d:FindFirstChild("Basic Rod") then
                    if Gak()[2] == "Basic Rod" then
                        IDp(CFrame.new(A.CFrame.X, 1, A.CFrame.Z + 40))
                    else
                        z8Jf8qa("tool", function()
                            f8MkTRD("Basic Rod")
                        end)
                    end
                end
            end
        end)
    end
end)
if XZV == "1" then
    d8pV(FulA, E1Qh, d, "Auto Kill Boss Saber", "saber")
    spawn(function()
        while task.wait() do
            pcall(function()
                local o
                _G.saber = s00WNaQ("Expert Swordman [Lv. 3000]")
                if nKFGU0v("saber") then
                    o = _G.saber
                    if o then
                        bcpg(o.HumanoidRootPart.CFrame)
                    end
                end
            end)
        end
    end)
elseif XZV == "2" then
    d8pV(J6dO, Ib8xIt, d, "Auto Summon/Kill Kaido", "dragon")
    d8pV(FulA, E1Qh, d, "Auto Kill Seaking/Hydra", "skhd")
    d8pV(qqgj, nGhC2Ts, d, "Auto Kill Ghost Ship", "gs")
    d8pV(TICE6z, M3KATs, d, "Auto Kill Big Mom", "bigmom")
    d8pV(Rx2Aw, uv36Uf2, d, "Hop Big Mom", "hop_bigmom")
    d8pV(J5ArWKb, n3LTk4, d, "Auto Kill Oden", "oden")
    phthhtl = 0
    spawn(function()
        while task.wait() do
            pcall(function()
                local S
                pcall(function()
                    FulA.Text = "Auto Kill Seaking/Hydra | " .. game.ReplicatedStorage:GetAttribute("SeaMonsterSpawnText")
                end)
                _G.skhd = false
                if nKFGU0v("skhd") or nKFGU0v("level") then
                    S = HzrQ()
                    if S then
                        if S[2] == "boss" then
                            _G.skhd = true
                            IDp(S[1])
                            _G.pos_skill = S[1]
                            phthhtl = 0
                        elseif S[2] == "chest" and phthhtl <= 30 then
                            _G.skhd = true
                            IDp(S[1])
                            z8Jf8qa("skhd", function()
                                phthhtl = phthhtl + 1
                            end)
                        end
                    else
                        phthhtl = 0
                    end
                end
            end)
        end
    end)
    spawn(function()
        while task.wait() do
            pcall(function()
                local G
                qqgj.Text = "Auto Kill Ghost Ship | " .. game.ReplicatedStorage:GetAttribute("GhostShipSpawnText")
                _G.gs = false
                if nKFGU0v("gs") then
                    G = GkDuC3()
                    if G then
                        _G.gs = true
                        if G[2] == "Ghost Ship" then
                            bcpg(G[1].CFrame)
                        elseif string.find(G[2], "Chest") then
                            for w, I in pairs(G[1]) do
                                IDp(I.CFrame)
                                task.wait(5 / 10)
                            end
                        end
                    end
                end
            end)
        end
    end)
    aHW3Gw = 0
    spawn(function()
        while task.wait() do
            pcall(function()
                local G
                _G.bigmom = s00WNaQ("Ms. Mother [Lv. 7500]")
                if nKFGU0v("bigmom") or nKFGU0v("galefirst") and gale_staus[2] then
                    if not mOTRLwc() then
                        return fsurP(2)
                    else
                        G = _G.bigmom
                        if G then
                            aHW3Gw = 0
                            bcpg(G.HumanoidRootPart.CFrame)
                        else
                            if nKFGU0v("hop_bigmom") or nKFGU0v("galefirst") and gale_staus[2] then
                                z8Jf8qa("bmh", function()
                                    aHW3Gw = aHW3Gw + 1
                                end)
                                if aHW3Gw >= nKFGU0v("time_hop") then
                                    wi4Eg(2, 0)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
    spawn(function()
        while task.wait() do
            pcall(function()
                local V
                _G.oden = s00WNaQ("King Samurai [Lv. 3500]")
                if nKFGU0v("oden") then
                    V = _G.oden
                    if V then
                        bcpg(V.HumanoidRootPart.CFrame)
                    end
                end
            end)
        end
    end)
    spawn(function()
        while task.wait() do
            pcall(function()
                local b
                _G.dragon = s00WNaQ("Dragon [Lv. 5000]")
                if nKFGU0v("dragon") then
                    if _G.core_control and _G.core_control >= 3 then
                        return
                    else
                        b = _G.dragon
                        if b then
                            bcpg(b.HumanoidRootPart.CFrame)
                        else
                            z8Jf8qa("dragon", function()
                                aYMvJS("SummonDragon")
                            end)
                        end
                    end
                end
            end)
        end
    end)
elseif XZV == "3" then
    eJ3 = "Hop Set Sail " .. (if NP7K8k then "| Premium" else "")
    d8pV(Pce9RTG, qGYu5, d, "Auto Depth King Boss", "depthking")
    if NP7K8k then
        d8pV(AB5, c94p, d, "Hop Depth King Boss", "hopdepthking")
    end
    d8pV(FulA, E1Qh, d, "Auto Set Sail Boss", "setsail")
    d8pV(qqgj, nGhC2Ts, d, eJ3, "hop_setsail")
    d8pV(TICE6z, M3KATs, d, "Auto Kill Pteranodon", "preranodon")
    d8pV(J5ArWKb, n3LTk4, d, "Hop Pteranodon", "hop_preranodon")
    d8pV(J6dO, Ib8xIt, d, "Teleport Island Race", "islandrace")
    d8pV(Rx2Aw, uv36Uf2, d, "Auto Kill Lord of Saber", "lordsaber")
    d8pV(TQMa3xn, b8jhgS, d, "Hop Lord of Saber", "hop_lordsaber")
    BCTS17y = 0
    i5ig = 0
    spawn(function()
        while task.wait() do
            pcall(function()
                local o, p, O
                _G.depthking = false
                pcall(function()
                    Pce9RTG.Text = "Auto Depth King | " .. workspace.Island.ThirdSeaTurtleChalice.Crystals.TimeBoard.TextLabel.Text
                end)
                if nKFGU0v("depthking") then
                    o, p = s00WNaQ("Depth King"), dB6g()
                    if o then
                        _G.depthking = true
                        BCTS17y = 0
                        i5ig = 0
                        IDp(o.HumanoidRootPart.CFrame * CFrame.new(0, 50, 0))
                        _G.pos_skill = o.HumanoidRootPart.CFrame
                    else
                        if p then
                            z8Jf8qa("dkk", function()
                                BCTS17y = BCTS17y + 1
                            end)
                            if BCTS17y <= 15 then
                                _G.depthking = true
                                IDp(p[1])
                            end
                        else
                            BCTS17y = 0
                        end
                    end
                    if NP7K8k and (not o and nKFGU0v("hopdepthking")) then
                        O = math.ceil(N0Fx() / 60)
                        if O and (O ~= 0 and O <= 10) then
                            return
                        else
                            z8Jf8qa("hahahhw", function()
                                i5ig = i5ig + 1
                            end)
                            if i5ig >= 20 then
                                z8Jf8qa("runss", function()
                                    vdBN = loadstring(game:HttpGet("https://api.nttsv.online/api/datasever-v1?name=Depth-King&id=19&hash=" .. gethwid()))()
                                end, 5)
                                if vdBN then
                                    for s, k in pairs(vdBN) do
                                        local t = UPKB(k[2])
                                        pcall(function()
                                            if NbTWcsM(t) then
                                                print(t);
                                                (game:GetService("TeleportService")):TeleportToPlaceInstance(game.PlaceId, t, game.Players.LocalPlayer)
                                                task.wait(5 / 10)
                                            end
                                        end)
                                    end
                                end
                                if i5ig >= 35 then
                                    if O > 10 then
                                        kW4RKBO()
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
    F6a0wl4 = 0
    dhWjH = 0
    spawn(function()
        while task.wait() do
            pcall(function()
                local k, m
                _G.ss = yuv()
                k = _G.ss
                pcall(function()
                    FulA.Text = "Auto Set Sail Boss | " .. (if k then k.Name else game.ReplicatedStorage:GetAttribute("ThirdSeaMonsterSpawnText"))
                end)
                if nKFGU0v("setsail") or nKFGU0v("kioru") and UcImOr == "ss" then
                    if k then
                        F6a0wl4 = 0
                        m = k.HumanoidRootPart.CFrame
                        _G.pos_skill = m
                        IDp(m)
                    else
                        if nKFGU0v("hop_setsail") or nKFGU0v("kioru") then
                            z8Jf8qa("s1s", function()
                                F6a0wl4 = F6a0wl4 + 1
                            end)
                            if F6a0wl4 >= nKFGU0v("time_hop") then
                                if NP7K8k then
                                    z8Jf8qa("runss", function()
                                        eEHm = loadstring(game:HttpGet("https://api.nttsv.online/api/datasever-v1?name=Set-Sail&id=19&hash=" .. gethwid()))()
                                    end, 5)
                                    if eEHm then
                                        qqgj.Text = eJ3 .. " | List Server: " .. #eEHm
                                        for C, h in pairs(eEHm) do
                                            local q = UPKB(h[2])
                                            pcall(function()
                                                if NbTWcsM(q) then
                                                    print(q);
                                                    (game:GetService("TeleportService")):TeleportToPlaceInstance(game.PlaceId, q, game.Players.LocalPlayer)
                                                    task.wait(5 / 10)
                                                end
                                            end)
                                        end
                                    end
                                    if F6a0wl4 >= nKFGU0v("time_hop") + 60 then
                                        wi4Eg(1, 30)
                                    end
                                else
                                    wi4Eg(1, 30)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
    SUlBVz = 0
    spawn(function()
        while task.wait() do
            pcall(function()
                local i
                _G.preranodon = s00WNaQ("Pteranodon [Lv. 12500]")
                if nKFGU0v("preranodon") then
                    i = _G.preranodon
                    if i then
                        bcpg(i.HumanoidRootPart.CFrame)
                    else
                        if nKFGU0v("hop_preranodon") then
                            z8Jf8qa("pte", function()
                                SUlBVz = SUlBVz + 1
                            end)
                            if SUlBVz >= nKFGU0v("time_hop") then
                                wi4Eg(2, 0)
                            end
                        end
                    end
                end
            end)
        end
    end)
    spawn(function()
        while task.wait() do
            pcall(function()
                local g, G
                _G.island_race = sQKqxX()
                g = _G.island_race
                J6dO.Text = "Teleport Island Race | " .. (if g then g.Name else "Not Spawn")
                if nKFGU0v("islandrace") and g then
                    G = g:FindFirstChildWhichIsA("BasePart")
                    if G then
                        IDp(G.CFrame * CFrame.new(0, 20, 0))
                    end
                end
            end)
        end
    end)
    ca4UGa = 0
    spawn(function()
        while task.wait() do
            pcall(function()
                local g
                _G.lordsaber = s00WNaQ("Lord of Saber [Lv. 8500]")
                if nKFGU0v("lordsaber") then
                    g = _G.lordsaber
                    if g then
                        bcpg(g.HumanoidRootPart.CFrame)
                    else
                        if nKFGU0v("hop_lordsaber") then
                            z8Jf8qa("saber", function()
                                ca4UGa = ca4UGa + 1
                            end)
                            if ca4UGa >= nKFGU0v("time_hop") then
                                custom(1, 0)
                            end
                        end
                    end
                end
            end)
        end
    end)
end
NKyikD0(F, "Dungeon")
m62Pr(lGr1sdQ, qW2PDV, KQbOcTF, F, "Dunegon", {"Easy", "Normal", "Hard"}, "dungeon_select")
d8pV(docu7l, rEXBRgt, F, "Auto Dungeon | Need Ope V2 Kioru V2, Melee", "dungeon")
NKyikD0(F, "Dungeon Customize")
d8pV(Pn47xxc, aqCb1, F, "Auto Dungeon Customize ", "dungeon_option")
QLZ(qPUPK0j, rh9, Maq3, F, "Tool Multi Select", BMwkbvT, _G.Setting.dungeon_tool)
QLZ(zaHziH, Etpqd, mWs, F, "Skill Melee Select", YaDJ6T, _G.Setting.dungeon_melee)
QLZ(EMBvvfZ, UGFFw, oea, F, "Skill Sword Select", {"Z", "X"}, _G.Setting.dungeon_sword)
QLZ(fUAnJ, MecB0gz, JnZaG, F, "Skill Fruit Select", YaDJ6T, _G.Setting.dungeon_fruit)
NKyikD0(F, "Setting")
d8pV(wVD55, Uc0IR4, F, "Auto Dodge Skill", "dodge_dungeon")
dqh4Sz(F, "Only Doodge When Low Health", 1, 100, "lowhealth_doodge")
d8pV(ZcHyIIU, U10EOW, F, "Auto Reset If Dungeon Clear", "dungeon_reset")
dqh4Sz(F, "% Health On Race", 1, 100, "dungeon_race")
d8pV(fAM9GUh, UCF, F, "Keep the race going at the boss", "onracewheninboss")
dqh4Sz(F, "Distance Y", 9, 70, "dungeon_y")
dqh4Sz(F, "Distance Attack Mob", 100, 1000, "dungeon_attack")
function t1dN()
    return (if game.Players.LocalPlayer.PlayerGui:FindFirstChild("DungeonUI") then true else false)
end
function apof0y()
    return {CFrame.new(-4610, 30, -6009), CFrame.new(-2428, 54, -1566), CFrame.new(10960, 130, 1250)}
end
function A79M0K()
    return ({-70, 70})[math.random(1, 2)]
end
function WVQ()
    local B = game.Workspace:FindFirstChild("OpeRoom" .. game.Players.LocalPlayer.Name)
    return (if B and RFpy(B.Position) <= 350 then true else false)
end
function lMtaZQ2()
    local i = game.Players.LocalPlayer.PlayerGui.MainGui.StarterFrame.StatusEffect.RaceV3.Frame.TextLabel.Text
    return (if i == "" then 0 else tonumber(i))
end
function Z6Fn9()
    for B, p in pairs(game.Workspace.Island:GetChildren()) do
        if string.find(p.Name, "(Real)") then
            return (p:FindFirstChild("Elevator")):FindFirstChild("MeshPart")
        end
    end
end
function gFL()
    local F = lMtaZQ2()
    if nKFGU0v("dodge_dungeon") ~= true or (Ej4Yne2 == nil or #Ej4Yne2[3] == 0) then
        return false
    end
    if game.Workspace.Effects:FindFirstChild("Warning") or game.Workspace.Effects:FindFirstChild("warning") then
        return true
    end
    if F >= 50 and F <= 60 then
        return false
    else
        if game.Players.LocalPlayer.Character.Humanoid.Health < game.Players.LocalPlayer.Character.Humanoid.MaxHealth * (nKFGU0v("dungeon_race") / 100) then
            return true
        end
    end
    for i, x in pairs(game.Workspace.Effects:GetChildren()) do
        if (x.ClassName == "Part" or (x.ClassName == "MeshPart" or x.ClassName == "Model")) and (string.find(x.Name, "Ball") or (string.find(x.Name, "ball") or (string.find(x.Name, "bullet") or (x.Name == "warning" or (x.Name == "Warning" or (string.find(x.Name, "Gravity") or (string.find(x.Name, "gravity") or (string.find(x.Name, "Ice,") or (string.find(x.Name, "ice") or (string.find(x.Name, "spiri") or (string.find(x.Name, "gun") or (string.find(x.Name, "fire") or (string.find(x.Name, "Fire") or (string.find(x.Name, "flame") or (string.find(x.Name, "Flame") or (string.find(x.Name, "meteo") or (string.find(x.Name, "Meteo") or (string.find(x.Name, "gravity") or (string.find(x.Name, "Gravity") or (x.Name == "IcePathAwake" or x.Name == "IceSpike")))))))))))))))))))) then
            local t = x:IsA("BasePart") and x or x:FindFirstChildWhichIsA("BasePart")
            if t and RFpy(t.Position) < 1000 then
                return true
            end
        end
    end
end
function OefJqap()
    mlN = {[1] = {}, [2] = {}, [3] = {}}
    for z, U in pairs(game.Workspace.MOB:GetChildren()) do
        if U.ClassName == "Model" and (U:FindFirstChild("Humanoid") and (U:FindFirstChild("HumanoidRootPart") and U.Humanoid.Health > 0)) then
            table.insert(mlN[1], U)
            if (U.HumanoidRootPart.Position - Z6Fn9().Position).Magnitude < nKFGU0v("dungeon_attack") then
                table.insert(mlN[2], U)
            end
            if U:FindFirstChild("TargetBossGUI") then
                table.insert(mlN[3], U)
            end
        end
    end
    return mlN
end
spawn(function()
    while task.wait() do
        pcall(function()
            local z, C, s
            if zKvy or (nKFGU0v("dungeon") or nKFGU0v("dungeon_option")) then
                if t1dN() then
                    if zKvy == false and (_G.core_control and _G.core_control >= 3) then
                        game.Players.LocalPlayer.Character.Humanoid.Health = 0
                        return
                    else
                        return
                    end
                else
                    z = apof0y()[tonumber(XZV)]
                    if z and RFpy(z) > 10 then
                        IDp(z)
                    end
                    C, s = game.Players.LocalPlayer.PlayerGui, (if zKvy then "Easy" else rBrUGg3(KQbOcTF.Text))
                    if C:FindFirstChild("ChooseMap") and C.ChooseMap.ChooseMapFrame.MapFrame:FindFirstChild(s) then
                        task.wait(1)
                        A921YRv(C.ChooseMap.ChooseMapFrame.MapFrame:FindFirstChild(s))
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            local Z, X, Y
            if not t1dN() then
                return
            else
                Z, X, Y = WVQ(), FWN, BMwkbvT
                if nKFGU0v("dungeon") then
                    if not Z then
                        X(Y[3])
                        Ycwda("Z")
                        return
                    else
                        for R = 1, 2 do
                            X(Y[R])
                            task.wait(1 / 10)
                        end
                        return
                    end
                else
                    if nKFGU0v("dungeon_option") or zKvy then
                        for v, b in pairs(_G.Setting.dungeon_tool) do
                            if b then
                                X(v)
                                task.wait(1 / 10)
                            end
                        end
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            local F, a, D
            if not t1dN() then
                return
            else
                if nKFGU0v("dungeon") and WVQ() then
                    for v, C in pairs(YaDJ6T) do
                        Ycwda(C)
                    end
                end
                if nKFGU0v("dungeon_option") or zKvy then
                    task.wait(1)
                    F = Gak()[1]
                    if F then
                        for J, B in pairs(_G.Setting.dungeon_melee) do
                            if B then
                                gEIW("FS_" .. F .. "_" .. J)
                            end
                        end
                    end
                    a = Gak()[2]
                    if a then
                        for g, t in pairs(_G.Setting.dungeon_sword) do
                            if t then
                                gEIW("SW_" .. a .. "_" .. g)
                            end
                        end
                    end
                    D = Gak()[3]
                    if D then
                        for w, G in pairs(_G.Setting.dungeon_fruit) do
                            if G then
                                gEIW("DF_" .. D .. "_" .. w)
                            end
                        end
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            local T, z, b, S, d, f
            if not t1dN() then
                return
            else
                if nKFGU0v("dungeon") or (nKFGU0v("dungeon_option") or zKvy) then
                    T, z = lMtaZQ2(), OefJqap()
                    OefJqap()
                    b, S, d = z[1], z[2], z[3]
                    Ej4Yne2 = z
                    if #b < 5 and #d ~= 0 then
                        if _G.dodge or _G.checkskill then
                            return
                        else
                            for S, k in pairs(d) do
                                local j
                                j = (function()
                                    if Gak()[3] == "TreeTree" then
                                        return {1, CFrame.new(0, 0, nKFGU0v("dungeon_y"))}
                                    elseif string.find(d[1].Name, "Crab") then
                                        return {2, 14}
                                    else
                                        return {2, nKFGU0v("dungeon_y")}
                                    end
                                end)()
                                if j[1] == 2 then
                                    j[2] = CFrame.new(0, j[2], 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                end
                                IDp(k.HumanoidRootPart.CFrame * j[2])
                                _G.pos_skill = k.HumanoidRootPart.CFrame
                            end
                            return
                        end
                    else
                        if #b > 5 and (#S == 0 and #d == 0) then
                            return IDp(Z6Fn9().CFrame * CFrame.new(0, 100, 0))
                        else
                            f = (function()
                                if T >= 1 and (T <= 49 and game.Players.LocalPlayer.Character.Humanoid.Health < game.Players.LocalPlayer.Character.Humanoid.MaxHealth * (50 / 100)) then
                                    return CFrame.new(A79M0K(), 90, A79M0K())
                                elseif Gak()[3] == "TreeTree" then
                                    return CFrame.new(0, 0, nKFGU0v("dungeon_y"))
                                else
                                    return CFrame.new(0, nKFGU0v("dungeon_y"), 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                end
                            end)()
                            for R, P in pairs((if #b <= 5 then b else S)) do
                                IDp(P.HumanoidRootPart.CFrame * f)
                                _G.pos_skill = P.HumanoidRootPart.CFrame
                                task.wait(1 / 10)
                            end
                        end
                    end
                end
            end
        end)
    end
end)
pM3IP = {
    function()
    pM3IP[2] = pM3IP[2] + 1
end,
    0
}
RuaPA7j, NqJIJOn, MutaSt1 = 300, 5, 0
spawn(function()
    while task.wait() do
        pcall(function()
            if (nKFGU0v("dungeon") or (nKFGU0v("dungeon_option") or zKvy)) and (t1dN() and Z6Fn9()) then
                if game.Players.LocalPlayer.Character.Humanoid.Health >= game.Players.LocalPlayer.Character.Humanoid.MaxHealth * (nKFGU0v("lowhealth_doodge") / 100) then
                    _G.checkskill = false
                    _G.dodge = false
                    return
                end
                local m, z = Ej4Yne2, pM3IP[2]
                _G.debug = Ej4Yne2
                _G.dodge = (if nKFGU0v("dodge_dungeon") and pM3IP[2] <= 1 then true else false)
                _G.checkskill = gFL()
                z8Jf8qa("wa", pM3IP[1])
                if m and #m[3] == 0 then
                    return
                end
                for x, F in pairs(game.Workspace.Effects:GetChildren()) do
                    if (F.ClassName == "Part" or (F.ClassName == "MeshPart" or F.ClassName == "Model")) and (F.Name == "warning" or F.Name == "Warning") then
                        local Q = F:IsA("BasePart") and F or F:FindFirstChildWhichIsA("BasePart")
                        pM3IP[2] = 0
                        if m and (#m[3] > 0 and string.find(m[3][1].Name, "Crab")) then
                            MeHA = CFrame.new(19893, 15647, 20400)
                            if (CFrame.new(19909, 15447, 20299).Position - m[3][1].HumanoidRootPart.Position).Magnitude < 300 then
                                MeHA = CFrame.new(19855, 15647, 19563)
                            end
                            IDp(MeHA)
                            return
                        end
                        return
                    end
                end
                if #m[3] >= 0 and string.find(m[3][1].Name, "Crab") then
                    Ycwda("R")
                    return
                end
                if _G.checkskill then
                    MutaSt1 = MutaSt1 + 20
                    local o = Z6Fn9().Position
                    local q = o.Y + NqJIJOn
                    local p = o.X + math.cos(math.rad(MutaSt1)) * RuaPA7j
                    local O = o.Z + math.sin(math.rad(MutaSt1)) * RuaPA7j
                    local X = CFrame.new(p, q, O)
                    local D = game.Players.LocalPlayer.Character
                    if D and D:FindFirstChild("HumanoidRootPart") then
                        D.HumanoidRootPart.CFrame = X
                    end
                end
            end
        end)
    end
end)
function MImKGfI()
    local j = Ej4Yne2
    if j and #j[3] > 0 then
        local t = {}
        t[31] = "take"
        t[76] = "Kill 1 " .. j[3][1].Name
        local W = t
        game.ReplicatedStorage.Chest.Remotes.Functions.Quest:InvokeServer(W[31], W[76])
    end
end
spawn(function()
    while task.wait() do
        pcall(function()
            if (nKFGU0v("dungeon") or nKFGU0v("dungeon_option")) and t1dN() then
                zWEquU()
                if nKFGU0v("onracewheninboss") and (Ej4Yne2 and #Ej4Yne2[3] > 0) or game.Players.LocalPlayer.Character.Humanoid.Health < game.Players.LocalPlayer.Character.Humanoid.MaxHealth * (nKFGU0v("dungeon_race") / 100) then
                    Ycwda("R")
                end
                if zKvy == false and (nKFGU0v("dungeon_reset") and game.Players.LocalPlayer.PlayerGui:FindFirstChild("DungeonClearUI")) then
                    game.Players.LocalPlayer.Character.Humanoid.Health = 0
                end
                z8Jf8qa("qd", MImKGfI)
            end
        end)
    end
end)
spawn(function()
    while task.wait(1) do
        pcall(function()
            local Y
            if (nKFGU0v("dungeon") or nKFGU0v("dungeon_option")) and t1dN() then
                Y = Ej4Yne2
                if Y and #Y[3] > 0 then
                    game:GetService("Players").LocalPlayer.PlayerGui.MainGui.StarterFrame.Setting_Frame.LocalScript.Remote:InvokeServer("Setting_HideAllEffects_Off")
                else
                    game:GetService("Players").LocalPlayer.PlayerGui.MainGui.StarterFrame.Setting_Frame.LocalScript.Remote:InvokeServer("Setting_HideAllEffects_On")
                end
            end
        end)
    end
end)
NKyikD0(j, "Esp")
d8pV(FwoQh, QvL1iXj, j, "Esp Player", "esp_prl")
d8pV(KmUyZ, uj2Cz, j, "Esp Fruit", "esp_fruit")
d8pV(zYLcKM, pRclNCR, j, "Bring Fruit", "bringfruit")
NKyikD0(j, "Fish")
PYaeN7I(rx8yb, lJ5, j, "CFrame : " .. tostring(nKFGU0v("fish_cf")), function()
    XJb0c("fish_cf", tostring(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame))
    rx8yb.Text = "   CFrame : " .. tostring(nKFGU0v("fish_cf"))
end)
d8pV(KnjHkVw, NxLc6Z, j, "Auto Fish", "fish")
spawn(function()
    while task.wait() do
        pcall(function()
            if nKFGU0v("esp_prl") then
                for e, n in pairs(game.Players:GetChildren()) do
                    local m, O, C, H
                    if n.Name ~= game.Players.LocalPlayer.Name then
                        if not n.Character.Head:FindFirstChild("PlayerESP") then
                            m = Instance.new("BillboardGui")
                            O = Instance.new("TextLabel")
                            m.Parent = n.Character.Head
                            m.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                            m.Active = true
                            m.Name = "PlayerESP"
                            m.AlwaysOnTop = true
                            m.LightInfluence = 1
                            m.Size = (UDim2.new(0, 200, 0, 50))
                            m.StudsOffset = (Vector3.new(0, 25 / 10, 0))
                            O.Parent = m
                            O.BackgroundColor3 = (Color3.fromRGB(255, 255, 255))
                            O.BackgroundTransparency = 1
                            O.Size = (UDim2.new(0, 200, 0, 50))
                            O.Font = Enum.Font.GothamBold
                            O.TextColor3 = (Color3.fromRGB(255, 255, 255))
                            O.Text.Size = 100
                            O.TextStrokeTransparency = 0
                            O.TextWrapped = true
                        end
                        C = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - n.Character.Head.Position).Magnitude)
                        if n:FindFirstChild("PlayerStats") then
                            H = n.PlayerStats.lvl.Value
                            if n.PlayerStats.PVP.Value then
                                tI1s2w = "PVP : On"
                            else
                                tI1s2w = "PVP : Off"
                            end
                            n.Character.Head:FindFirstChild("PlayerESP").TextLabel.Text = n.Name .. " | Level : " .. H .. " | " .. tI1s2w .. " | " .. C .. " M"
                        end
                    end
                end
            else
                for t, J in pairs(game.Players:GetChildren()) do
                    if J.Name ~= game.Players.LocalPlayer.Name then
                        if J.Character.Head:FindFirstChild("PlayerESP") then
                            J.Character.Head.PlayerESP:Destroy()
                        end
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            local ll
            ll = game.Workspace:FindFirstChild("AllDroppedFruit")
            if not ll then
                return
            else
                if nKFGU0v("esp_fruit") then
                    for d, o in pairs(ll:GetChildren()) do
                        if o and o:IsA("Model") then
                            local d = o:FindFirstChild("Handle")
                            if d and d:IsA("BasePart") then
                                if not d:FindFirstChild("FruitESP") then
                                    local o = Instance.new("BillboardGui")
                                    local A = Instance.new("TextLabel")
                                    o.Parent = d
                                    o.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                                    o.Active = true
                                    o.Name = "FruitESP"
                                    o.AlwaysOnTop = true
                                    o.LightInfluence = 1
                                    o.Size = (UDim2.new(0, 200, 0, 50))
                                    o.StudsOffset = (Vector3.new(0, 25 / 10, 0))
                                    A.Parent = o
                                    A.BackgroundColor3 = (Color3.fromRGB(255, 255, 255))
                                    A.BackgroundTransparency = 1
                                    A.Size = (UDim2.new(0, 200, 0, 50))
                                    A.Font = Enum.Font.GothamBold
                                    A.TextColor3 = (Color3.fromRGB(255, 255, 255))
                                    A.Text.Size = 100
                                    A.TextStrokeTransparency = 0
                                    A.TextWrapped = true
                                end
                                local t = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                local TT = 0
                                if t then
                                    TT = math.floor((t.Position - d.Position).Magnitude)
                                end
                                local A = o.Name
                                local S = o:FindFirstChild("Name") or (o:FindFirstChild("FruitName") or (o:FindFirstChild("ToolTip") or o:FindFirstChildWhichIsA("StringValue")))
                                if S then
                                    if S:IsA("StringValue") then
                                        A = S.Value
                                    else
                                        A = S.Name
                                    end
                                end
                                local P = d:FindFirstChild("FruitESP")
                                if P and P:FindFirstChild("TextLabel") then
                                    P.TextLabel.Text = A .. " | " .. TT .. " M"
                                end
                            end
                        end
                    end
                else
                    for n, K in pairs(ll:GetChildren()) do
                        local X, J
                        if K and K:IsA("Model") then
                            X = K:FindFirstChild("Handle")
                            if X and X:IsA("BasePart") then
                                J = X:FindFirstChild("FruitESP")
                                if J then
                                    J:Destroy()
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            if nKFGU0v("bringfruit") then
                for S, o in pairs((game.Workspace:FindFirstChild("AllDroppedFruit")):GetChildren()) do
                    if o and o:IsA("Model") then
                        if o:FindFirstChild("Handle") then
                            o:FindFirstChild("Handle").CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                        end
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            local R, l, i, y, s, Y
            if nKFGU0v("fish") then
                if _G.core_control and (_G.core_control == 3 or nKFGU0v("serpent") and _G.core_control == 4) then
                    return
                else
                    if game.Players.LocalPlayer.Inventory:FindFirstChild("Basic Rod") then
                        if Gak()[2] == "Basic Rod" then
                            R, l = string.split(nKFGU0v("fish_cf"), ","), tonumber
                            i, y, s = l(R[1]), l(R[2]), l(R[3])
                            IDp(CFrame.new(i, y, s))
                        else
                            Y = {[1] = "EquipWeapon", [2] = {WeaponName = "Basic Rod", Type = "Primary"}}
                            game.ReplicatedStorage.Chest.Remotes.Functions.EtcFunction:InvokeServer(unpack(Y))
                        end
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait(1) do
        pcall(function()
            local U
            if nKFGU0v("fish") or _G.core_control == 4 then
                FWN("")
                U = {
                    [1] = "SW_Basic Rod_M1",
                    [2] = {
                    MouseHit = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5),
                    Charge = 100
                }
                }
                game.ReplicatedStorage.Chest.Remotes.Functions.SkillAction:InvokeServer(unpack(U))
            end
        end)
    end
end)
local function dk()
    if nKFGU0v("fish") or nKFGU0v("serpent") and _G.core_control == 4 then
        local q = game.Players.LocalPlayer.PlayerGui
        if q:FindFirstChild("FishingUI") then
            local I = q.FishingUI.FishingBackground.FishingBar
            local f = q.FishingUI.FishingBackground.FishLabel
            f.Position = I.Position
        end
    end
end
game:GetService("RunService").Stepped:Connect(dk)
NKyikD0(u, "Combat")
m62Pr(wCamL, rpSKWh0, rm2, u, "Player", Psmhqe, "combat_player")
d8pV(bgzaueM, ud8, u, "Teleport Player", "tp_prl")
d8pV(Yx5rq, NoA1Y, u, "Auto Safe Zone", "safezone")
NKyikD0(u, "Aim Skill")
d8pV(ZZM, BhQE, u, "Aim Skill Player Select", "aimskill")
d8pV(DLd, cLAaGu, u, "Aim Skill Player Near", "aimskill_near")
dqh4Sz(u, "Distance Value", 100, 1000, "aimskill_value")
NKyikD0(u, "Aim Camara")
d8pV(JTOYBv9, zCXri6, u, "Aim Camara Player Select", "aimcamara")
d8pV(bx2T, f7ke, u, "Aim Camara Player Near", "aimcamara_near")
dqh4Sz(u, "Distance Value", 100, 1000, "aimcamara_value")
spawn(function()
    while task.wait() do
        pcall(function()
            local d
            if nKFGU0v("tp_prl") then
                d = ksGa(rBrUGg3(nKFGU0v("combat_player")))
                if d then
                    IDp(d.Character.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0))
                end
            end
        end)
    end
end)
local function dv()
    if nKFGU0v("aimskill") then
        if ksGa(rBrUGg3(rm2.Text)) then
            _G.pos_skill = ksGa(rBrUGg3(rm2.Text)).Character.HumanoidRootPart.CFrame
        end
    end
end
game:GetService("RunService").Stepped:Connect(dv)
local function dh()
    if nKFGU0v("aimskill_near") then
        local p = QXE0V(nKFGU0v("aimskill_value"))
        if p then
            _G.pos_skill = p.Character.HumanoidRootPart.CFrame
        end
    end
end
game:GetService("RunService").Stepped:Connect(dh)
local function dc()
    if nKFGU0v("aimcamara") then
        if ksGa(rBrUGg3(rm2.Text)) then
            dw(ksGa(rBrUGg3(rm2.Text)).Character.HumanoidRootPart.CFrame)
        end
    end
end
game:GetService("RunService").Stepped:Connect(dc)
local function dA()
    if nKFGU0v("aimcamara_near") then
        if QXE0V(nKFGU0v("aimcamara_value")) then
            dw(QXE0V(nKFGU0v("aimcamara_value")).Character.HumanoidRootPart.CFrame)
        end
    end
end
game:GetService("RunService").Stepped:Connect(dA)
NKyikD0(N, "Buy Key")
m62Pr(fJ1LT, AoU, gdT, N, "Key", aonXbO, "shop_select1")
d8pV(DolK6s, WkR2, N, "Auto Buy Key", "buykey")
dqh4Sz(N, "Key Value", 1, 100, "shop_value")
NKyikD0(N, "Random Fruit")
m62Pr(nOf, oY1, rYb, N, "Key", aonXbO, "shop_select1")
d8pV(c0QD6, K6Y, N, "Auto Random Fruit", "randomfruit")
d8pV(ofKfno, PAp, N, "Auto Random Fruit X10", "randomfruitx10")
d8pV(FFNf, dSM, N, "Auto Storage Fruit", "storagefruit")
NKyikD0(N, "Trade Fruit To Key")
m62Pr(XvuVl0, Ceq3Q, yPQLx, N, "Key", aonXbO, "tradekey_select")
d8pV(l1fY1vg, TkX, N, "Auto Trade Fruit To Key", "tradekey")
spawn(function()
    while task.wait(1) do
        pcall(function()
            local i
            if nKFGU0v("buykey") then
                i = {(rBrUGg3(gdT.Text)), nKFGU0v("shop_value")};
                ((((game.ReplicatedStorage:WaitForChild("Chest")):WaitForChild("Remotes")):WaitForChild("Functions")):WaitForChild("BuyKey")):InvokeServer(unpack(i))
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            if nKFGU0v("randomfruit") then
                hWk("Open1")
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            if nKFGU0v("randomfruitx10") then
                hWk("Open10")
            end
        end)
    end
end)
spawn(function()
    while task.wait(1) do
        pcall(function()
            if nKFGU0v("tradekey") then
                BOgK(rBrUGg3(nKFGU0v("tradekey_select")))
            end
        end)
    end
end)
NKyikD0(m, "Server", 0.03)
rOr(WxBjB, m, "Enter Code Join Server")
PYaeN7I(dVpU0a, nNMaxA, m, "Join Server", function()
    if string.find(WxBjB.Text, "NTT") then
        V0b6lo = UPKB(WxBjB.Text)
    else
        V0b6lo = WxBjB.Text
    end;
    (game:GetService("TeleportService")):TeleportToPlaceInstance(game.PlaceId, V0b6lo, game.Players.LocalPlayer)
end)
PYaeN7I(lTRRb63, l0usBw, m, "Coppy Code Server", function()
    setclipboard(game.JobId)
end)
PYaeN7I(YlLHx, JJ3mCm, m, "Rejoin", function()
    (game:GetService("TeleportService")):Teleport(game.PlaceId)
end)
PYaeN7I(D1EWeMa, khLPr, m, "Server Hop", function()
    g93Q1F()
end)
NKyikD0(y, "Server Live")
m62Pr(pKZ2, OC2, JURCj, y, "Server", {"Serpent", "Set-Sail", "Boss-KL", "Island-Race", "Depth-King"}, "server_live")
function n1RVJ0()
    local j = loadstring(game:HttpGet("https://api.nttsv.online/api/datasever-v1?name=" .. rBrUGg3(nKFGU0v("server_live")) .. "&id=19&hash=" .. gethwid()))()
    for D, p in pairs(j) do
        if p then
            pcall(function()
                local s = Instance.new("TextLabel")
                local C = Instance.new("TextButton")
                PYaeN7I(s, C, y, p[1] .. ": " .. p[2], function()
                    (game:GetService("TeleportService")):TeleportToPlaceInstance(game.PlaceId, UPKB(p[2]), game.Players.LocalPlayer)
                end)
            end)
        end
    end
end
ioI = ""
spawn(function()
    while task.wait() do
        pcall(function()
            z8Jf8qa("rsv", function()
                if y.Visible and D.Visible then
                    ioI = 1
                end
            end, 5)
            if ioI == nKFGU0v("server_live") then
                return
            else
                for X = 1, #y:GetChildren() do
                    if y:FindFirstChild("button") then
                        (y:FindFirstChild("button")):Destroy()
                    end
                end
                ioI = nKFGU0v("server_live")
                n1RVJ0()
            end
        end)
    end
end)
NKyikD0(w, "Island")
m62Pr(AF5oiMV, PJFep, zqo0a, w, "Island", xB9qz, "island_select")
PYaeN7I(JZDorn9, XojDUC, w, "Teleport Island", function()
    IDp(CFrame.new(yuy5[rBrUGg3(nKFGU0v("island_select"))]))
end)
NKyikD0(w, "NPC")
m62Pr(E0r, DoeGOpP, Kpc, w, "NPC", JBX, "npc_select")
PYaeN7I(epb, FDr, w, "Teleport NPC", function()
    IDp(game.Workspace.AllNPC[rBrUGg3(Kpc.Text)].CFrame)
end)
NKyikD0(q, "Player")
d8pV(xTrF8t, rj9E4oi, q, "Walk On Water", "water")
d8pV(m4IqmpZ, z4U, q, "Walk Speed", "walkspeed")
dqh4Sz(q, "Speed Value", 30, 500, "speed_value")
d8pV(XLdIu, eTzC, q, "Jumpower", "jumpower")
dqh4Sz(q, "Jump Value", 30, 500, "jump_value")
d8pV(gM9Z, B42, q, "Inf Jump", "infjump")
local function di()
    pcall(function()
        if nKFGU0v("water") then
            game.Workspace.SeaFolder.Sea.CanCollide = true
        else
            game.Workspace.SeaFolder.Sea.CanCollide = false
        end
    end)
end
game:GetService("RunService").RenderStepped:connect(di)
local function dL()
    pcall(function()
        if nKFGU0v("walkspeed") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = nKFGU0v("speed_value")
        end
    end)
end
game:GetService("RunService").RenderStepped:connect(dL)
spawn(function()
    while task.wait() do
        pcall(function()
            if nKFGU0v("jumppower") then
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = nKFGU0v("jump_value")
            end
        end)
    end
end)
game:GetService("UserInputService").JumpRequest:connect(function()
    pcall(function()
        if nKFGU0v("infjump") then
            (game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")):ChangeState("Jumping")
        end
    end)
end)
NKyikD0(C, "Item")
if mOTRLwc() or VyZC() then
    d8pV(vlQQdOg, JiVYr, C, "Auto Get Kioru v1/v2", "kioru")
    d8pV(rymnCU, Rb2MMiG, C, "Auto Bloodmoon Twins", "bt")
    RZm = {
        function()
        RZm[2] = RZm[2] + 1
    end,
        0
    }
    function AkZ7zzP()
        for h = 1, 10 do
            local W = workspace.Torches:FindFirstChild("Torch" .. h)
            if W and W:FindFirstChild("FlamePart") then
                local e = W.FlamePart:FindFirstChild("Attachment")
                e = e and e:FindFirstChild("FlameFlame")
                if e and not e.Enabled then
                    return W.FlamePart.CFrame
                end
            end
        end
    end
    function Shwn(y)
        local f = {}
        f[119] = "AddQuestProgress"
        local b = {}
        b.QuestChapter = y
        b.QuestProgressName = "Bloodmoon Twins Quest"
        f[66] = b
        local o = f
        game.ReplicatedStorage.Chest.Remotes.Functions.EtcFunction:InvokeServer(o[119], o[66])
    end
    Ef85d = false
    spawn(function()
        while task.wait() do
            pcall(function()
                if not nKFGU0v("bt") then
                    return
                end
                if YHhNl5("Bloodmoon Twins") then
                    return
                end
                if not YHhNl5("Hell Sword") then
                    if XZV ~= "2" then
                        return fsurP(2)
                    end
                    local g = s00WNaQ("King Samurai [Lv. 3500]")
                    if g then
                        bcpg(g.HumanoidRootPart.CFrame)
                        RZm[2] = 0
                    else
                        z8Jf8qa("bss", RZm[1])
                        if RZm[2] >= 10 then
                            wi4Eg(1, 0)
                        end
                    end
                    return
                end
                if not YHhNl5("Ethereal") then
                    if XZV ~= "3" then
                        return fsurP(3)
                    end
                    local G = s00WNaQ("Bushido Ape [Lv. 5000]")
                    if G then
                        bcpg(G.HumanoidRootPart.CFrame)
                        RZm[2] = 0
                        return
                    end
                    IDp(CFrame.new(5114, 392, 8826))
                    z8Jf8qa("bss", RZm[1])
                    if RZm[2] >= 10 then
                        wi4Eg(1, 0)
                    end
                    return
                end
                if XZV ~= "3" then
                    return fsurP(3)
                end
                local i = dbz6pRH(game:GetService("Players").LocalPlayer.PlayerStats.QuestProgression.Value)["Bloodmoon Twins Quest"]
                if i == nil or (i < 3 or i == 4) then
                    task.wait(1)
                    Shwn((if i == nil then 1 else i + 1))
                    return
                end
                if i and (i == 3 or i == 6) then
                    local C = s00WNaQ("Samurai Soul [Lv. 7500]")
                    local a = ((function()
                        if C then
                            return function()
                                return bcpg(C.HumanoidRootPart.CFrame)
                            end
                        else
                            return nil
                        end
                    end)())
                    if a then
                        return a()
                    end
                    local G = (if i == 3 then "Hell Sword" else "Ethereal")
                    if Gak()[2] == G then
                        z8Jf8qa("btts", function()
                            game.ReplicatedStorage.Chest.Remotes.Functions.ThirdSeaQuests:InvokeServer("BeginTorchQuest")
                        end)
                        local U = AkZ7zzP()
                        if U then
                            IDp(U)
                            FWN("Sword")
                            Ycwda("Z")
                            Ycwda("X")
                        end
                    else
                        task.wait(1)
                        f8MkTRD(G)
                    end
                    return
                end
                if i and i == 5 then
                    local j = ((function()
                        if game:GetService("Lighting").Sky.MoonTextureId ~= "rbxassetid://5250084176" then
                            return function()
                                return wi4Eg(0, 50)
                            end
                        else
                            return nil
                        end
                    end)())
                    if j then
                        return j()
                    end
                    z8Jf8qa("chshw", function()
                        Shwn(6)
                    end, 5)
                    local G = LPQH("Jungle Gorilla [Lv. 4300]")
                    if G then
                        bcpg(G.HumanoidRootPart.CFrame)
                    else
                        IDp(CFrame.new(4215, 181, 9081))
                    end
                end
                if i and i == 7 then
                    if game.Players.LocalPlayer.PlayerStats.beli.Value > 22500000 then
                        Ef85d = false
                        task.wait(1)
                        local A = {}
                        A.Price = 22500000
                        A.TextSuccess = "<AnimateStyle=Rainbow>Successfully purchased a sword."
                        A.TextNoMoney = "<AnimateStyle=Appear><Color=Red>Not enough Money $!"
                        r[99] = A
                        local E = r
                        game.ReplicatedStorage.Chest.Remotes.Functions.EtcFunction:InvokeServer(E[74], E[99])
                    else
                        Ef85d = true
                    end
                end
            end)
        end
    end)
    spawn(function()
        while task.wait() do
            pcall(function()
                local z, h, g, j, G, d
                UcImOr = nil
                z = game.Players.LocalPlayer.Inventory
                h, g, j, G = WAP, z:FindFirstChild("Kioru"), z:FindFirstChild("Kioru V2"), gPDaI1()
                _G.k1, _G.k2 = g, j
                if nKFGU0v("kioru") then
                    if XZV == "2" then
                        if g and not j then
                            z8Jf8qa("tps", function()
                                tpsea3()
                            end)
                        else
                            if G and h[2][G] then
                                d = s00WNaQ(G)
                                if d then
                                    bcpg(d.HumanoidRootPart.CFrame)
                                else
                                    IDp(h[2][G])
                                end
                            else
                                z8Jf8qa("ktlk", function()
                                    aYMvJS(h[1])
                                end)
                            end
                        end
                    elseif XZV == "3" then
                        if not g then
                            z8Jf8qa("tps", function()
                                tpsea2()
                            end)
                            return
                        else
                            if not j then
                                if h[2]() then
                                    if h[3]() then
                                        z8Jf8qa("bk", function()
                                            h[4]()
                                        end)
                                    else
                                        UcImOr = "money"
                                    end
                                else
                                    UcImOr = "ss"
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end
if VyZC() then
    d8pV(Ops, tpnaD, C, "Auto solve Sea Beast Puzzle", "sbp")
    d8pV(jqN0L, Rc7G, C, "Auto Melee Tricster", "tricster")
    d8pV(TKD, UM2oYoO, C, "Auto Mele Gale First", "galefirst")
    d8pV(xGN, YkgFP, C, "Auto Race Sea Beast V3", "sbv3")
    spawn(function()
        while task.wait() do
            pcall(function()
                tO4gXK = false
                FrkDbd = false
                zKvy = false
                if not nKFGU0v("sbv3") then
                    return
                end
                local P = dbz6pRH(game:GetService("Players").LocalPlayer.PlayerStats.QuestProgression.Value)
                local T = dbz6pRH(game:GetService("Players").LocalPlayer.PlayerStats.Material.Value)
                local Y, n, h = P["Sea Beast Puzzle"], P["Sea Beast V2"], P["Sea BeastV3"]
                if Y == 2 and dbz6pRH(game:GetService("Players").LocalPlayer.PlayerStats.RaceTbl.Value).Race ~= "Sea Beast" then
                    task.wait(1)
                    local Q = {}
                    Q.Text1 = "You have changed your race to a <Color=Red>Sea Beast."
                    i[29] = Q
                    local X = i
                    game:GetService("ReplicatedStorage").Chest.Remotes.Functions.EtcFunction:InvokeServer(X[92], X[29])
                    return
                end
                if h and h == 4 then
                    return
                end
                if n and n == 5 then
                    local U = _G.island_race
                    if U == nil or U and not U.Name == "SeaKing Island" then
                        z8Jf8qa("r817unss", function()
                            qE5o = loadstring(game:HttpGet("https://api.nttsv.online/api/datasever-v1?name=Island-Race&id=19&hash=" .. gethwid()))()
                        end, 5)
                        if qE5o then
                            for d, j in pairs(qE5o) do
                                local h = UPKB(j[2])
                                pcall(function()
                                    if NbTWcsM(h) and j[1] == "SeaKing Island" then
                                        print(h);
                                        (game:GetService("TeleportService")):TeleportToPlaceInstance(game.PlaceId, h, game.Players.LocalPlayer)
                                        task.wait(5 / 10)
                                    end
                                end)
                            end
                        end
                        return
                    end
                end
                if h == nil and (n and n == 5) then
                    FrkDbd = true
                    IDp(_G.island_race.SeaBeastV3PuzzlePart.CFrame)
                    if not string.find(_G.island_race.SeaBeastV3PuzzlePart.BillboardGui.TextLabel.Text, game.Players.LocalPlayer.Name) then
                        task.wait(1)
                        local z = {}
                        z.QuestChapter = 1
                        z.QuestProgressName = "Sea BeastV3"
                        R[120] = z
                        local a = R
                        game:GetService("ReplicatedStorage").Chest.Remotes.Functions.EtcFunction:InvokeServer(a[70], a[120])
                    end
                end
                if h and (h == 1 or h == 3) then
                    task.wait(1)
                    local W = {}
                    W.QuestChapter = ((if h == 1 then h + 1 else h))
                    W.QuestProgressName = "Sea BeastV3"
                    i[89] = W
                    local w = i
                    game:GetService("ReplicatedStorage").Chest.Remotes.Functions.EtcFunction:InvokeServer(w[80], w[89])
                end
                if h and h == 2 then
                    zKvy = true
                    return
                end
                if Y == nil then
                    if T["Sea Artifact"] >= 100 then
                        local A = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.Dialogue
                        if A.Visible and A.LevelRequire.Text == "Neptunian" then
                            A921YRv(A.Button1)
                        else
                            IDp(CFrame.new(4541, 47, 11628));
                            (game:GetService("VirtualInputManager")):SendMouseButtonEvent(0, 0, 0, true, game, 0);
                            (game:GetService("VirtualInputManager")):SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        end
                    else
                        local I = Gktt["Sea Artifact"]
                        local k = LPQH(I[1])
                        if k then
                            bcpg(k.HumanoidRootPart.CFrame)
                        else
                            IDp(I[2])
                        end
                    end
                elseif n == nil and Y == 1 then
                    tO4gXK = true
                elseif n == nil and Y == 2 then
                    if T["Sea Artifact"] and T["Sea Artifact"] >= 50 then
                        task.wait(1)
                        local E = {}
                        E.QuestChapter = 1
                        E.QuestProgressName = "Sea Beast V2"
                        n[46] = E
                        local w = n
                        game:GetService("ReplicatedStorage").Chest.Remotes.Functions.EtcFunction:InvokeServer(w[71], w[46])
                    else
                        local W = Gktt["Sea Artifact"]
                        local y = LPQH(W[1])
                        if y then
                            bcpg(y.HumanoidRootPart.CFrame)
                        else
                            IDp(W[2])
                        end
                    end
                elseif h == nil and (n and (n >= 1 and n <= 3)) then
                    local t = {{"Coral", 25}, {"Shark's Fin", 10}, {"Pearl", 1}}
                    if T[t[n][1]] and T[t[n][1]] >= t[n][2] then
                        task.wait(1)
                        local Y = {}
                        Y.QuestChapter = n + 1
                        Y.QuestProgressName = "Sea Beast V2"
                        e[87] = Y
                        local W = e
                        game:GetService("ReplicatedStorage").Chest.Remotes.Functions.EtcFunction:InvokeServer(W[120], W[87])
                    else
                        local K = Gktt[t[n][1]]
                        local D = LPQH(K[1])
                        if D then
                            bcpg(D.HumanoidRootPart.CFrame)
                        else
                            IDp(K[2])
                        end
                    end
                elseif n and n == 4 then
                    if T["Aqua Gem"] then
                        task.wait(1)
                        local p = {}
                        p.QuestChapter = 5
                        p.QuestProgressName = "Sea Beast V2"
                        o[20] = p
                        local O = o
                        game:GetService("ReplicatedStorage").Chest.Remotes.Functions.EtcFunction:InvokeServer(O[58], O[20])
                    else
                        local a = {Pearl = 1, ["Shark's Fin"] = 10, Coral = 10, ["Sea Artifact"] = 25}
                        for N, e in pairs(a) do
                            local E, Q
                            if not T[N] or T[N] and T[N] < e then
                                E = Gktt[N]
                                Q = LPQH(E[1])
                                if Q then
                                    bcpg(Q.HumanoidRootPart.CFrame)
                                else
                                    IDp(E[2])
                                end
                                return
                            end
                        end
                        task.wait(1)
                        local d = f
                        game:GetService("ReplicatedStorage").Chest.Remotes.Functions.CraftMaterial:InvokeServer(d[33], d[71])
                    end
                end
            end)
        end
    end)
    spawn(function()
        pcall(function()
            local B = function()
                return workspace.Island["SeaKing Island"]:FindFirstChild("SeaBeastV3PuzzlePart")
            end
            local A = B()
            local V = {
                "119576559183680",
                "115625326781152",
                "94434872009841",
                "116017251168091",
                "120381852599372",
                "123634528802626",
                "133326415582853",
                "135120773462269"
            }
            local k = {}
            for A, h in ipairs(V) do
                k[h] = tostring(A)
            end
            local Q = 0.3
            local R = 1.5
            local T = 0.07
            local n = 1.5
            local y = 400
            UnX = (UnX or 0) + 1
            local F = UnX
            local function q()
                return UnX == F and FrkDbd == true
            end
            local function D()
                local C, T
                C, T = {}, {}
                for s = 1, 9 do
                    local p, W, Y, m, l, d, S
                    p = A:FindFirstChild(tostring(s))
                    W = p and p:FindFirstChild("FakePlate")
                    Y = W and W:FindFirstChild("SurfaceGui")
                    if not Y then
                        return nil, "Khong tim thay SurfaceGui tai o " .. s
                    else
                        if Y.Enabled == false then
                            m = "9"
                            if T[m] then
                                return nil, "Board bi trung hinh hoac co nhieu o BLANK: " .. m
                            else
                                T[m] = true
                                C[s] = m
                            end
                        else
                            l = Y:FindFirstChild("PuzzlePic")
                            d = l and l.Image or ""
                            S = d:match("(%d+)$")
                            m = S and k[S]
                            if not m then
                                return nil, "ID hinh khong co trong map, o " .. s .. ": " .. d
                            else
                                if T[m] then
                                    return nil, "Board bi trung hinh hoac co nhieu o BLANK: " .. m
                                else
                                    T[m] = true
                                    C[s] = m
                                end
                            end
                        end
                    end
                end
                if not T["9"] then
                    return nil, "Khong tim thay o BLANK"
                else
                    return table.concat(C)
                end
            end
            local X = {}
            local v = {}
            for C = 1, 9 do
                local h, l, B
                h, l = math.floor((C - 1) / 3), (C - 1) % 3
                B = {}
                if h > 0 then
                    B[#B + 1] = C - 3
                end
                if h < 2 then
                    B[#B + 1] = C + 3
                end
                if l > 0 then
                    B[#B + 1] = C - 1
                end
                if l < 2 then
                    B[#B + 1] = C + 1
                end
                X[C] = B
            end
            for I = 1, 8 do
                v[I] = {}
                local L, x = math.floor((I - 1) / 3), (I - 1) % 3
                for t = 1, 9 do
                    local T, F = math.floor((t - 1) / 3), (t - 1) % 3
                    v[I][t] = math.abs(T - L) + math.abs(F - x)
                end
            end
            local function i(s)
                local x
                x = 0
                for a = 1, 9 do
                    local U
                    U = tonumber(s:sub(a, a))
                    if U ~= 9 then
                        x = x + v[U][a]
                    end
                end
                return x
            end
            local function W(S)
                local l
                l = 0
                for z = 1, 8 do
                    local Y
                    Y = tonumber(S:sub(z, z))
                    if Y ~= 9 then
                        for o = z + 1, 9 do
                            local X
                            X = tonumber(S:sub(o, o))
                            if X ~= 9 and Y > X then
                                l = l + 1
                            end
                        end
                    end
                end
                return l % 2 == 0
            end
            local function G(V, g, w)
                if g > w then
                    g, w = w, g
                end
                return V:sub(1, g - 1) .. V:sub(w, w) .. V:sub(g + 1, w - 1) .. V:sub(g, g) .. V:sub(w + 1)
            end
            local function H(R, a)
                if R.f ~= a.f then
                    return R.f < a.f
                else
                    return R.h < a.h
                end
            end
            local function p(k, y)
                local W
                W = #k + 1
                while W > 1 do
                    do
                        local m
                        m = math.floor(W / 2)
                        if not H(y, k[m]) then
                            break
                        else
                            k[W] = k[m]
                            W = m
                        end
                    end
                end
                k[W] = y
            end
            local function h(Y)
                local e, G, X, M
                e = #Y
                if e == 0 then
                    return nil
                else
                    G, X = Y[1], Y[e]
                    Y[e] = nil
                    e = e - 1
                    if e > 0 then
                        M = 1
                        while M * 2 <= e do
                            do
                                local a
                                local V = false
                                a = M * 2
                                if a + 1 <= e and H(Y[a + 1], Y[a]) then
                                    a = a + 1
                                end
                                if not H(Y[a], X) then
                                    V = true
                                else
                                    Y[M] = Y[a]
                                    M = a
                                end
                                if V then
                                    break
                                end
                            end
                        end
                        Y[M] = X
                    end
                    return G
                end
            end
            local function L(o)
                local z, F, O, L, m
                if o == "123456789" then
                    return {}
                else
                    if not W(o) then
                        return nil, "Trang thai 3x3 khong the giai (le nghich the)"
                    else
                        z = i(o)
                        F = {}
                        O = {[o] = 0}
                        L = {}
                        p(F, {key = o, blank = o:find("9", 1, true), g = 0, h = z, f = z})
                        m = 0
                        while #F > 0 do
                            do
                                if not q() then
                                    return nil, "Da dung"
                                end
                                local z = h(F)
                                if O[z.key] == z.g then
                                    if z.key == "123456789" then
                                        local Q, C = {}, z.key
                                        while C ~= o do
                                            do
                                                local p
                                                p = L[C]
                                                if not p then
                                                    return nil, "Khong the truy vet duong di"
                                                else
                                                    Q[#Q + 1] = p.click
                                                    C = p.from
                                                end
                                            end
                                        end
                                        for T = 1, math.floor(#Q / 2) do
                                            local b = #Q - (T + 1)
                                            Q[T], Q[b] = Q[b], Q[T]
                                        end
                                        return Q
                                    end
                                    m = m + 1
                                    if m % y == 0 then
                                        task.wait()
                                        if not q() then
                                            return nil, "Da dung"
                                        end
                                    end
                                    for D, X in ipairs(X[z.blank]) do
                                        local n, m, Q, U
                                        n = tonumber(z.key:sub(X, X))
                                        m = G(z.key, z.blank, X)
                                        Q = z.g + 1
                                        if O[m] == nil or Q < O[m] then
                                            U = z.h - (v[n][X] + v[n][z.blank])
                                            O[m] = Q
                                            L[m] = {from = z.key, click = X}
                                            p(F, {key = m, blank = X, g = Q, h = U, f = Q + U})
                                        end
                                    end
                                end
                            end
                        end
                        return nil, "Khong tim thay duong di"
                    end
                end
            end
            local function t(w, L)
                local p, a
                p = w
                a = p:find("9", 1, true)
                for F, M in ipairs(L) do
                    if not q() then
                        return false, "Da dung"
                    end
                    local S, m = D()
                    if not S then
                        return false, m
                    end
                    if S ~= p then
                        return false, "Trang thai da thay doi, tim lai duong"
                    end
                    local i = A:FindFirstChild(tostring(M))
                    local w = i and i:FindFirstChild("ClickDetector")
                    local B = ((function()
                        if not w then
                            return function()
                                return false, "Thieu ClickDetector tai o " .. M
                            end
                        else
                            return nil
                        end
                    end)())
                    if B then
                        return B()
                    end
                    local l = G(p, a, M)
                    fireclickdetector(w)
                    local H = os.clock() + R
                    local u = false
                    repeat
                        local P
                        local Q = false
                        task.wait(T)
                        if not q() then
                            return false, "Da dung"
                        else
                            P = D()
                            if P == l then
                                u = true
                                Q = true
                            else
                                if P and P ~= p then
                                    return false, "Board doi khac du kien, tim lai duong"
                                end
                            end
                        end
                        if Q then
                            break
                        end
                    until os.clock() >= H
                    local h = ((function()
                        if not u then
                            return function()
                                return false, "Click chua duoc ghi nhan tai o " .. M
                            end
                        else
                            return nil
                        end
                    end)())
                    if h then
                        return h()
                    end
                    p = l
                    a = M
                    task.wait(Q)
                end
                return true
            end
            task.spawn(function()
                local C
                C = nil
                while UnX == F do
                    task.wait(20 / 100)
                    if q() then
                        if type(fireclickdetector) ~= "function" then
                            if C ~= "Khong co fireclickdetector" then
                                warn("[SeaBeast 3x3] Executor khong ho tro fireclickdetector")
                                C = "Khong co fireclickdetector"
                            end
                            task.wait(n)
                        else
                            local R, y = D()
                            if not R then
                                if C ~= y then
                                    warn("[SeaBeast 3x3] " .. y)
                                    C = y
                                end
                                task.wait(n)
                            elseif R == "123456789" then
                                C = nil
                                task.wait(n)
                            else
                                local A, g = L(R)
                                if not q() then
                                    task.wait(1 / 10)
                                elseif not A then
                                    if C ~= g then
                                        warn("[SeaBeast 3x3] " .. tostring(g))
                                        C = g
                                    end
                                    task.wait(n)
                                else
                                    C = nil
                                    print("[SeaBeast 3x3] Tim duoc " .. #A .. " buoc")
                                    local G, u = t(R, A)
                                    if not G and q() then
                                        if C ~= u then
                                            warn("[SeaBeast 3x3] " .. tostring(u))
                                            C = u
                                        end
                                        task.wait(4 / 10)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end)
    end)
    jssq = 0
    spawn(function()
        while task.wait() do
            pcall(function()
                local y, r
                if nKFGU0v("tricster") then
                    y = dbz6pRH(game:GetService("Players").LocalPlayer.PlayerStats.Material.Value).Trickshard
                    if not (y and y >= 10) then
                        r = _G.ss
                        if r and r.Name == "FuryTentacle" then
                            IDp(r.HumanoidRootPart.CFrame)
                            _G.pos_skill = r.HumanoidRootPart.CFrame
                            jssq = 0
                        else
                            z8Jf8qa("s12s", function()
                                jssq = jssq + 1
                            end)
                            if jssq >= nKFGU0v("time_hop") then
                                if NP7K8k then
                                    z8Jf8qa("run8ss", function()
                                        eEHm = loadstring(game:HttpGet("https://api.nttsv.online/api/datasever-v1?name=Set-Sail&id=19&hash=" .. gethwid()))()
                                    end, 5)
                                    if eEHm then
                                        for E, G in pairs(eEHm) do
                                            local s = UPKB(G[2])
                                            pcall(function()
                                                if NbTWcsM(s) then
                                                    print(s);
                                                    (game:GetService("TeleportService")):TeleportToPlaceInstance(game.PlaceId, s, game.Players.LocalPlayer)
                                                    task.wait(5 / 10)
                                                end
                                            end)
                                        end
                                    end
                                    if jssq >= nKFGU0v("time_hop") + 60 then
                                        wi4Eg(1, 30)
                                    end
                                else
                                    wi4Eg(1, 30)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
    spawn(function()
        while task.wait() do
            pcall(function()
                if nKFGU0v("sbp") or nKFGU0v("sbv3") and tO4gXK then
                    _G.sovel = true
                    if RFpy(CFrame.new(4594, 72, 11653)) > 50 then
                        IDp(CFrame.new(4594, 72, 11653))
                    end
                else
                    _G.sovel = false
                end
            end)
        end
    end)
    do
        local u = {}
        local v = {}
        v[19701] = {3, "16991582974"}
        v[57074] = {2, "16991583165"}
        v[10264] = {7, "16991582233"}
        v[47326] = {11, "16991581157"}
        v[39842] = {13, "16991580585"}
        v[14786] = {10, "16991581537"}
        v[24171] = {5, "16991582713"}
        v[27325] = {12, "16991580817"}
        v[51000] = {1, "16991583334"}
        v[39703] = {15, "16991580091"}
        v[17436] = {14, "16991580411"}
        v[35870] = {16, "BLANK"}
        v[18903] = {6, "16991582586"}
        v[17840] = {4, "16991582856"}
        v[17234] = {8, "16991582022"}
        v[35326] = {9, "16991581798"}
        local B = {
            51000,
            57074,
            19701,
            17840,
            24171,
            18903,
            10264,
            17234,
            35326,
            14786,
            47326,
            27325,
            39842,
            17436,
            39703,
            35870
        }
        for Q = 1, #B do
            local H = v[B[Q]]
            u[H[1]] = H[2]
        end
        _G.GOAL = u
    end
    _G._folder = game.Workspace.Island.SBPuzzleFolder
    local q = {}
    for C, p in ipairs(_G.GOAL) do
        q[p] = C
    end
    local u = 0.3
    local G = 200
    local d = 300
    local g = 1.5
    local function h()
        local s = {}
        for O = 1, 16 do
            local B = _G._folder[tostring(O)].FakePlate.SurfaceGui
            s[O] = B.Enabled == false and "BLANK" or (B.PuzzlePic.Image:match("%d+") or "BLANK")
        end
        return s
    end
    local function P(R)
        for i = 1, 16 do
            if R[i] == "BLANK" then
                return i
            end
        end
    end
    local function V(X)
        return table.concat(X, ",")
    end
    local function f(k)
        local i = {}
        local s, X = math.floor((k - 1) / 4), (k - 1) % 4
        if s > 0 then
            i[#i + 1] = k - 4
        end
        if s < 3 then
            i[#i + 1] = k + 4
        end
        if X > 0 then
            i[#i + 1] = k - 1
        end
        if X < 3 then
            i[#i + 1] = k + 1
        end
        return i
    end
    local function E(h)
        local V = 0
        for b = 1, 16 do
            if h[b] ~= "BLANK" and q[h[b]] then
                local R = q[h[b]]
                local g, N = math.floor((b - 1) / 4), (b - 1) % 4
                local F, M = math.floor((R - 1) / 4), (R - 1) % 4
                V = V + (math.abs(g - F) + math.abs(N - M))
            end
        end
        for l = 0, 3 do
            local L = {}
            for Z = 0, 3 do
                local p, G, E
                p = l * 4 + (Z + 1)
                G = h[p]
                if G ~= "BLANK" and q[G] then
                    E = math.floor((q[G] - 1) / 4)
                    if E == l then
                        table.insert(L, {col = Z, gCol = (q[G] - 1) % 4})
                    end
                end
            end
            for B = 1, #L do
                for s = B + 1, #L do
                    if L[B].gCol > L[s].gCol and L[B].col < L[s].col or L[B].gCol < L[s].gCol and L[B].col > L[s].col then
                        V = V + 2
                    end
                end
            end
        end
        for k = 0, 3 do
            local w = {}
            for a = 0, 3 do
                local z, j, L
                z = a * 4 + (k + 1)
                j = h[z]
                if j ~= "BLANK" and q[j] then
                    L = (q[j] - 1) % 4
                    if L == k then
                        table.insert(w, {row = a, gRow = math.floor((q[j] - 1) / 4)})
                    end
                end
            end
            for q = 1, #w do
                for k = q + 1, #w do
                    if w[q].gRow > w[k].gRow and w[q].row < w[k].row or w[q].gRow < w[k].gRow and w[q].row > w[k].row then
                        V = V + 2
                    end
                end
            end
        end
        return V
    end
    local function t(y)
        local T = E(y)
        if T == 0 then
            return {}
        end
        local J = {{state = y, path = {}, g = 0, h = T, key = V(y)}}
        local k = {[V(y)] = true}
        local w = 0
        for d = 1, d do
            if not _G.sovel then
                return nil
            end
            w = w + 1
            if w % 10 == 0 then
                task.wait()
            end
            if not _G.sovel then
                return nil
            end
            local g = {}
            for L, Q in ipairs(J) do
                local R = P(Q.state)
                for s, q in ipairs(f(R)) do
                    local A, h, L, S
                    A = {}
                    for c = 1, 16 do
                        A[c] = Q.state[c]
                    end
                    A[R], A[q] = A[q], A[R]
                    h = V(A)
                    if not k[h] then
                        k[h] = true
                        L = E(A)
                        S = {}
                        for x, I in ipairs(Q.path) do
                            S[#S + 1] = I
                        end
                        S[#S + 1] = q
                        if L == 0 then
                            return S
                        else
                            g[#g + 1] = {state = A, path = S, g = Q.g + 1, h = L, key = h, score = Q.g + (1 + L)}
                        end
                    end
                end
            end
            if #g == 0 then
                break
            end
            table.sort(g, function(W, c)
                return W.score < c.score
            end)
            local C = {}
            for j = 1, math.min(G, #g) do
                C[j] = g[j]
            end
            J = C
        end
        return nil
    end
    local function A(x, U)
        local W = P(x)
        local N, B = math.huge, nil
        for k, y in ipairs(f(W)) do
            local M = {}
            for K = 1, 16 do
                M[K] = x[K]
            end
            M[W], M[y] = M[y], M[W]
            local D = V(M)
            local R = E(M)
            if not U[D] and R < N then
                N = R
                B = y
            end
        end
        if not B then
            for F, b in ipairs(f(W)) do
                local v = {}
                for L = 1, 16 do
                    v[L] = x[L]
                end
                v[W], v[b] = v[b], v[W]
                local y = E(v)
                if y < N then
                    N = y
                    B = b
                end
            end
        end
        return B
    end
    local function Y()
        local z = {}
        local x = {}
        local F = 500
        local function l(o)
            local X = V(o)
            if not z[X] then
                z[X] = true
                table.insert(x, X)
                if #x > F then
                    z[table.remove(x, 1)] = nil
                end
            end
        end
        l(h())
        while _G.sovel do
            do
                local s = h()
                local R = E(s)
                if R == 0 then
                    return true
                end
                local p = t(s)
                if not _G.sovel then
                    return false
                end
                if p and #p > 0 then
                    for w, M in ipairs(p) do
                        local p
                        if not _G.sovel then
                            return false
                        else
                            p = _G._folder:FindFirstChild(tostring(M))
                            if p and p:FindFirstChild("ClickDetector") then
                                fireclickdetector(p.ClickDetector)
                                task.wait(5 / 100)
                                l(h())
                                task.wait(math.max(0, u - 5 / 100))
                                if E(h()) == 0 then
                                    return true
                                end
                            end
                        end
                    end
                else
                    local E = A(s, z)
                    if E then
                        local R = _G._folder:FindFirstChild(tostring(E))
                        if R and R:FindFirstChild("ClickDetector") then
                            fireclickdetector(R.ClickDetector)
                            task.wait(5 / 100)
                            l(h())
                            task.wait(math.max(0, u - 5 / 100))
                        end
                    end
                    for L = 1, math.min(100, #x) do
                        z[table.remove(x, 1)] = nil
                    end
                end
            end
        end
        return false
    end
    task.spawn(function()
        local i = false
        while true do
            task.wait(2 / 10)
            if not _G.sovel then
                if not i then
                    i = true
                end
            else
                i = false
                local R = E(h())
                if R == 0 then
                    task.wait(g)
                else
                    Y()
                end
            end
        end
    end)
end
function WtLVMc(A, h)
    A.MouseButton1Down:connect(function()
        for X = 1, #_G.ntt_mainscrollingframe do
            _G.ntt_mainscrollingframe[X].Visible = false
        end
        for C = 1, #_G.ntt_farmain_table do
            _G.ntt_farmain_table[C].Visible = false
        end
        h.Visible = true
        f.Text = "NTT HUB | " .. A.Text .. " | " .. _G.linkdis
    end)
end
WtLVMc(J, E)
WtLVMc(o, d)
WtLVMc(l, F)
WtLVMc(g, j)
WtLVMc(p, u)
WtLVMc(V, N)
WtLVMc(Y, m)
WtLVMc(r, y)
WtLVMc(Q, w)
WtLVMc(H, q)
WtLVMc(B, C)
WtLVMc(T, z)
WtLVMc(dd, e)
WtLVMc(dD, P)
local function dS()
    if _G.pos_skill and (_G.combat_b7 or (nKFGU0v("aimskill") or (nKFGU0v("aimskill_near") or _G.core_control and (_G.core_control == 1 or (_G.core_control == 2 or _G.core_control == 3))))) then
        _G.hookdone = true
    else
        _G.hookdone = false
    end
end
game:GetService("RunService").RenderStepped:connect(dS)
pcall(function()
    local w = game.ReplicatedStorage.Chest.Remotes.Functions.SkillAction
    local t
    local F = function()
        return getnamecallmethod
    end
    local b
    b = function(r, ...)
        local M = F()()
        if M == "InvokeServer" and (rawequal(r, w) and (_G.hookdone and _G.pos_skill)) then
            local v = table.pack(...)
            if typeof(v[2]) == "table" and (v[2].Type == "Down" or v[2].Type == "Up") then
                v[2].MouseHit = _G.pos_skill
            end
            if type(v[2]) == "string" and v[2] == "MouseHit" then
                v[2].MouseHit = _G.pos_skill
            end
            return t(r, table.unpack(v, 1, v.n))
        end
        return t(r, ...)
    end
    t = hookmetamethod(game, "__namecall", newcclosure(b))
end)
spawn(function()
    while task.wait() do
        pcall(function()
            local f
            if nKFGU0v("storagefruit") then
                f = VnvGX()
                _G.st = f
                if f then
                    FWN(f.Name);
                    (game:GetService("VirtualInputManager")):SendMouseButtonEvent(0, 0, 0, true, game, 0);
                    (game:GetService("VirtualInputManager")):SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("EatFruitBecky") then
                        A921YRv(game.Players.LocalPlayer.PlayerGui.EatFruitBecky.Dialogue.Collect)
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            if nKFGU0v("storagefruit") and _G.st then
                return
            else
                if zKvy then
                    return
                else
                    if _G.core_control and (_G.core_control >= 1 and (_G.pos_skill and RFpy(_G.pos_skill) <= 150)) then
                        for e, z in pairs(_G.Setting.maintool) do
                            if z then
                                FWN(e)
                                task.wait(1 / 10)
                            end
                        end
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait(1) do
        pcall(function()
            local E, a, D
            if zKvy then
                return
            else
                if _G.core_control and (_G.core_control >= 1 and (_G.pos_skill and RFpy(_G.pos_skill) <= 150)) then
                    if game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Y <= 0 then
                        return
                    else
                        E = Gak()[1]
                        if E then
                            for D, l in pairs(_G.Setting.skill_melee) do
                                if l then
                                    gEIW("FS_" .. E .. "_" .. D)
                                end
                            end
                        end
                        a = Gak()[2]
                        if a then
                            for e, V in pairs(_G.Setting.skill_sword) do
                                if V then
                                    gEIW("SW_" .. a .. "_" .. e)
                                end
                            end
                        end
                        D = Gak()[3]
                        if D then
                            for B, k in pairs(_G.Setting.skill_fruit) do
                                if k then
                                    gEIW("DF_" .. D .. "_" .. B)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while task.wait() do
        pcall(function()
            if (_G.core_control and _G.core_control >= 1 or (nKFGU0v("dungeon") or nKFGU0v("dungeon_option"))) and (_G.pos_skill and RFpy(_G.pos_skill) <= 150) then
                FpNzYV5()
            end
        end)
    end
end)
spawn(function()
    while task.wait(2) do
        pcall(function()
            if _G.core_control and (nKFGU0v("onrace") and (not nKFGU0v("dungeon") and not nKFGU0v("dungeon_option"))) then
                Ycwda("R")
            end
        end)
    end
end)
spawn(function()
    pcall(function()
        game:GetService("RunService").Stepped:Connect(function()
            local e
            if nKFGU0v("dungeon") or (nKFGU0v("dungeon_option") or _G.core_control) then
                game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").PlatformStand = true
                if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    (game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip")):Destroy()
                end
                if not game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    e = Instance.new("BodyVelocity")
                    e.Name = "BodyClip"
                    e.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
                    e.MaxForce = (Vector3.new(100000, 100000, 100000))
                    e.Velocity = (Vector3.new(0, 0, 0))
                end
            else
                game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").PlatformStand = false
                if game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    (game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyClip")):Destroy()
                end
            end
        end)
    end)
end)
spawn(function()
    while task.wait(1) do
        pcall(function()
            qz9CHzC()
        end)
    end
end)
spawn(function()
    while task.wait(1) do
        pcall(function()
            if _G.core_control then
                zWEquU()
            end
        end)
    end
end)
game:GetService("RunService").Stepped:Connect(function(O, F)
    z8Jf8qa("cg", function()
        if game.Players.LocalPlayer.PlayerGui:FindFirstChild("LoadingGUI") and game.Players.LocalPlayer.PlayerGui.LoadingGUI:FindFirstChild("Play") then
            if game.Players.LocalPlayer.PlayerGui.LoadingGUI.Play.Visible == true then
                A921YRv(game.Players.LocalPlayer.PlayerGui.LoadingGUI.Play)
            end
        end
    end, 0.1)
end)
local dP = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:connect(function()
    dP:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    dP:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)
if cEQuwBt() then
    _G.sea = "Sea 1"
elseif mOTRLwc() then
    _G.sea = "Sea 2"
elseif VyZC() then
    _G.sea = "Sea 3"
end
if mOTRLwc() then
    pcall(function()
        _G.tskhd = n(game.ReplicatedStorage:GetAttribute("SeaMonsterSpawnText"), ":")
        if #_G.tskhd == 3 then
            Dqz("skhdgs", "Unknow", os.time() + (tonumber(_G.tskhd[1]) * (60 * 60) + tonumber(_G.tskhd[2]) * 60))
        end
    end)
end
if VyZC() then
    pcall(function()
        hIxXPu = n(game.ReplicatedStorage:GetAttribute("ThirdSeaMonsterSpawnText"), ":")
        if #hIxXPu == 3 then
            Dqz("Set-Sail", "Set Sail", os.time() + (tonumber(hIxXPu[1]) * (60 * 60) + tonumber(hIxXPu[2]) * 60))
        end
    end)
    pcall(function()
        local x = n(game.workspace.Island.ThirdSeaTurtleChalice.Crystals.TimeBoard.TextLabel.Text, ":")
        if #x == 3 and tonumber(x[2]) ~= 0 then
        end
    end)
end
glGPc = #(game:GetService("Players")):GetPlayers()
Uba = zVdc5T4(game.JobId)
local function W(H)
    if not H:FindFirstChild("done") then
        local X = Instance.new("Folder")
        X.Name = "done"
        X.Parent = H
    end
end
spawn(function()
    while task.wait(1) do
        pcall(function()
            local F
            F = {_G.jack, _G.skullking, _G.saber, _G.bigmom, _G.oden, _G.preranodon, _G.lordsaber}
            for w, Q in pairs(F) do
                pcall(function()
                    if Q and not Q:FindFirstChild("done") then
                        W(Q)
                        GwaiLpy("Boss-KL", _G.sea .. " : " .. Q.Name)
                        _G.webhook1("boss_kl", Q.Name, glGPc, Uba)
                    end
                end)
            end
        end)
    end
end)
spawn(function()
    while task.wait(1) do
        pcall(function()
            local M
            M = _G.serpent
            if M then
                if not M:FindFirstChild("done") then
                    W(M)
                    GwaiLpy("Serpent", _G.sea .. " : " .. M.Name)
                    _G.webhook1("serpent", M.Name, glGPc, Uba)
                end
            end
            if game.Workspace.Effects:FindFirstChild("SerpentWhirlpool") then
                if not (game.Workspace.Effects:FindFirstChild("SerpentWhirlpool")):FindFirstChild("done") then
                    W(game.Workspace.Effects:FindFirstChild("SerpentWhirlpool"))
                    GwaiLpy("Serpent", _G.sea .. " : Whirlpool")
                    _G.webhook1("serpent", _G.sea .. " : Whirlpool", glGPc, Uba)
                end
            end
        end)
    end
end)
if mOTRLwc() then
    k4AcDR = true
    spawn(function()
        while task.wait(1) do
            pcall(function()
                local V, P, r
                V = HzrQ()
                if V then
                    if k4AcDR then
                        k4AcDR = false
                        P = V
                        r = (if P[3] == 1 then {"Seaking", 1} else {"Hydra", 2})
                        GwaiLpy("skhdgs", r[1], r[2])
                        _G.webhook1("skhd", r[1], glGPc, Uba)
                    end
                else
                    k4AcDR = true
                end
            end)
        end
    end)
end
spawn(function()
    while task.wait(1) do
        pcall(function()
            if CmEFL1() then
                if not (CmEFL1()):FindFirstChild("done") then
                    W(CmEFL1())
                    _G.webhook1("ks", CmEFL1().Name, glGPc, Uba)
                end
            end
        end)
    end
end)
if VyZC() then
    spawn(function()
        while task.wait(1) do
            pcall(function()
                local M
                M = s00WNaQ("Depth King")
                if M and not M:FindFirstChild("done") then
                    W(M)
                    GwaiLpy("Depth-King", "Depth King")
                    _G.webhook1("dk", "Depth King", glGPc, Uba)
                end
            end)
        end
    end)
    MVL = true
    spawn(function()
        while task.wait(1) do
            pcall(function()
                local Q
                Q = math.floor(N0Fx() / 60)
                if Q and Q <= 10 then
                    if MVL then
                        MVL = false
                        GwaiLpy("Depth-King", "Depth King Wait 10 Min")
                        _G.webhook1("dk", "Depth King 10 Min Left", glGPc, Uba)
                    end
                else
                    MVL = true
                end
            end)
        end
    end)
    spawn(function()
        while task.wait(1) do
            pcall(function()
                local q
                q = _G.island_race
                if q then
                    if not q:FindFirstChild("done") then
                        W(q)
                        GwaiLpy("Island-Race", q.Name)
                        _G.webhook1("race", q.Name, glGPc, Uba)
                    end
                end
            end)
        end
    end)
    spawn(function()
        while task.wait(1) do
            pcall(function()
                for O, D in pairs(game.Workspace.SeaMonster:GetChildren()) do
                    if not string.find(D.Name, "Galleon") and D.Humanoid.Health > 0 then
                        if not D:FindFirstChild("done") then
                            W(D)
                            GwaiLpy("Set-Sail", D.Name)
                            _G.webhook1("ss", D.Name, glGPc, Uba)
                        end
                    end
                end
            end)
        end
    end)
    spawn(function()
        while task.wait(1) do
            pcall(function()
                _G.karken = false
                if LPQH("FuryTentacle") then
                    _G.karken = true
                end
                if _G.karken then
                    if not game.Workspace.Monster.Boss:FindFirstChild("done") then
                        W(game.Workspace.Monster.Boss)
                        GwaiLpy("Set-Sail", "Karken")
                        _G.webhook1("ss", "Karken", glGPc, Uba)
                    end
                else
                    if game.Workspace.Monster.Boss:FindFirstChild("done") then
                        (game.Workspace.Monster.Boss:FindFirstChild("done")):Destroy()
                    end
                end
            end)
        end
    end)
end
local function dX(L, l)
    FJvZ = ""
    l = l or 0
    local y = string.rep("  ", l)
    if typeof(L) ~= "table" then
        print(y .. tostring(L))
        return
    end
    for X, F in pairs(L) do
        if typeof(F) == "table" then
            print(y .. "[" .. tostring(X) .. "] = {")
            dX(F, l + 1)
            print(y .. "}")
        else
            if FJvZ == "" then
                FJvZ = y .. "" .. tostring(X)
            else
                FJvZ = FJvZ .. "\n" .. y .. "" .. tostring(X)
            end
        end
    end
end
dX(game.ReplicatedStorage.Chest.Remotes.Functions.GetDFShop:InvokeServer())
_G.webhook2("stock_kl", "Notification", "Stock Fruit", FJvZ)
