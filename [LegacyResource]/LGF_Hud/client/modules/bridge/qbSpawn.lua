local QBCore = GetResourceState('qb-core'):find('start') and exports['qb-core']:GetCoreObject() or nil

if not QBCore then return end

PlayerLogged = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerLogged = true
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    PlayerLogged = false
end)

AddStateBagChangeHandler('PlayerLogged', nil, function(_, _, value)
    if value then
        PlayerLogged = true
    else
        PlayerLogged = false
    end
end)
