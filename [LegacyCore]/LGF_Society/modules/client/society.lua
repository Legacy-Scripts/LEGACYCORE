---@diagnostic disable: missing-parameter
local Society = {}

function Society:GetSocietyData(name)
    local societyData = lib.callback.await('LegacyCore:GetSocietyInfo', false, name)
    return societyData
end

exports("GetSocietyData", function(name)
    return Society:GetSocietyData(name)
end)


RegisterNetEvent("GetSocietyData", function(name, callback)
    local data = Society:GetSocietyData(name)
    callback(data)
end)

TriggerEvent("LegacyCore:GetSocietyData", "ambulance", function(data)
    print(json.encode(data))
end)

return Society
