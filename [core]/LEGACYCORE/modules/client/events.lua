local PlayerManager = require('modules.client.constructor')

AddEventHandler('playerSpawned', function()
    Wait(1500)

    TriggerEvent('LegacyCore:PlayerLoaded')
end)

RegisterNetEvent('LegacyCore:PlayerLogout', function()
    PlayerManager:handlePlayerLogout()
end)

function Legacy.DATA:IsPlayerLoaded()
    return PlayerManager:IsPlayerLoaded()
end

function Legacy.DATA:GetPlayerMetadata(key)
    return PlayerManager:GetPlayerMetadata(key)
end

function Legacy.DATA:GetSkin()
    return PlayerManager:GetSkin()
end

function Legacy.DATA:GetSlotCharacter()
    return PlayerManager:GetPlayerCharId()
end

RegisterNetEvent('LegacyCore:PlayerLoaded')
AddEventHandler('LegacyCore:PlayerLoaded', function(slot, playerdata, new)
    PlayerManager:handlePlayerLoaded(slot, playerdata, new)

    if new then
        TriggerServerEvent('LegacyCore:PlayerLoaded', slot, playerdata, true)
    end
end)


RegisterNetEvent('LegacyCore:LoadSkin', function(appearance)
    exports['fivem-appearance']:setPlayerAppearance(appearance)
end)
