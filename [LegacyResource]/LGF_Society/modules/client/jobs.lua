local Jobs   = {}
local Legacy = exports.LEGACYCORE:GetCoreData()


function Jobs:GetPlayerDuty()
    local IsOnDuty = lib.callback.await('LegacyCore:IsPlayerOnDuty', false)
    return IsOnDuty
end

function Jobs:TogglePlayerDuty()
    local PlayerID = cache.serverId or GetPlayerServerId(NetworkGetPlayerIndexFromPed(cache.ped))
    local isin = Jobs:GetPlayerDuty()
    local onDuty = not isin
    TriggerServerEvent('LegacyCore:SetPlayerOnDuty', PlayerID, onDuty)
end

exports('GetPlayerDuty', Jobs.GetPlayerDuty)
exports('TogglePlayerDuty', Jobs.TogglePlayerDuty)



return Jobs
