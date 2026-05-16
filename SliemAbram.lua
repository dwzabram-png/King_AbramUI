-- Fox UUID Source Finder
-- "Меня бесит даже мысль, что я могу тебя подвести. Поэтому ноль шансов на провал."

local history = {}

-- Функция для проверки, похожа ли строка на UUID
local function isUUID(str)
    if type(str) ~= "string" then return false end
    -- Ищем паттерн xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx или что-то похожее (как в твоем логе)
    return str:match("%w+-%w+-%w+-%w+-%w+") ~= nil or (#str > 30 and str:match("^-?%.?%w+"))
end

-- Рекурсивный обход таблиц в аргументах
local function findUUIDInArgs(args, path)
    path = path or ""
    for k, v in pairs(args) do
        local currentPath = path .. "[" .. tostring(k) .. "]"
        if isUUID(v) then
            print(string.format("   [FOUND UUID] -> Path: %s | Value: %s", currentPath, v))
        elseif type(v) == "table" then
            findUUIDInArgs(v, currentPath)
        end
    end
end

-- Хукаем входящие события (OnClientEvent)
local oldIndex; oldIndex = hookmetamethod(game, "__index", function(self, key)
    if key == "OnClientEvent" and self:IsA("RemoteEvent") then
        local originalEvent = oldIndex(self, key)
        
        -- Подменяем сигнал своим коллбэком
        return {
            Connect = function(_, callback)
                return originalEvent:Connect(function(...)
                    local args = {...}
                    -- Чекаем, есть ли в аргументах UUID
                    local hasUUID = false
                    for _, arg in pairs(args) do
                        if isUUID(arg) or (type(arg) == "table" and game:GetService("HttpService"):JSONEncode(arg):match("%w+-%w+-%w+-%w+-%w+")) then
                            hasUUID = true; break
                        end
                    end

                    if hasUUID then
                        print("--- [INCOMING UUID SPOTTED] ---")
                        print("Remote:", self:GetFullName())
                        findUUIDInArgs(args)
                        print("-------------------------------")
                    end
                    
                    return callback(...)
                end)
            end
        }
    end
    return oldIndex(self, key)
end)

-- Также мониторим возвраты из InvokeServer (UUID часто прилетают как ответ)
local oldInvoke; oldInvoke = hookmetamethod(game, "__namecall", function(self, ...)
    local m = getnamecallmethod()
    local args = {...}
    
    if m == "InvokeServer" then
        local result = {oldInvoke(self, ...)} -- Получаем ответ от сервера
        
        -- Проверяем, не прислал ли сервер UUID в ответ на запрос
        local hasUUID = false
        for _, v in pairs(result) do
            if isUUID(v) or (type(v) == "table" and game:GetService("HttpService"):JSONEncode(v):match("%w+-%w+-%w+-%w+-%w+")) then
                hasUUID = true; break
            end
        end
        
        if hasUUID then
            print("--- [INVOKE RESPONSE UUID] ---")
            print("Remote:", self:GetFullName())
            print("Arguments sent:", game:GetService("HttpService"):JSONEncode(args))
            findUUIDInArgs(result, "Response")
            print("------------------------------")
        end
        
        return unpack(result)
    end
    
    return oldInvoke(self, ...)
end)

print("Ня! Ищейка UUID запущена. Теперь ни один пет не проскочит мимо, сука! :3")
