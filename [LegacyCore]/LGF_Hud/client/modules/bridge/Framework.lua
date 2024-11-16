local Legacy = GetResourceState('LEGACYCORE'):find('start') and exports['LEGACYCORE']:GetCoreData() or nil
local ESX    = GetResourceState('es_extended'):find('start') and exports['es_extended']:getSharedObject() or nil
local QBCore = GetResourceState('qb-core'):find('start') and exports['qb-core']:GetCoreObject() or nil

local Frame  = {}



function Frame:IsPlayerLoaded()
    if Legacy then
        return Legacy.DATA:IsPlayerLoaded()
    elseif ESX then
        return ESX.IsPlayerLoaded()
    elseif QBCore then
        return PlayerLogged
    end
end

function Frame:GetplayerData()
    if Legacy then
        local PlayerData = LocalPlayer.state.GetPlayerObject
        if PlayerData then
            return PlayerData
        else
            return {}
        end
    elseif ESX then
        local PlayerData = ESX.GetPlayerData()
        if PlayerData then
            return PlayerData
        end
    elseif QBCore then
        local PlayerData = QBCore.Functions.GetPlayerData()
        if PlayerData then
            return PlayerData
        end
    end
end

function Frame:GetPlayerJob()
    if Legacy then
        local PlayerData = Frame:GetplayerData()
        local PlayerJob = PlayerData.JobLabel
        if PlayerJob then
            return PlayerJob
        end
    elseif ESX then
        local PlayerData = Frame:GetplayerData()
        return PlayerData and PlayerData.job.label
    elseif QBCore then
        local PlayerData = Frame:GetplayerData()
        return PlayerData.job.label
    end
end

function Frame:GetPlayerThirst()
    if Legacy then
        return exports.LEGACYCORE:GetPlayerThirst()
    elseif ESX then
        local thirst = nil
        TriggerEvent('esx_status:getStatus', "thirst", function(status)
            if status then
                thirst = (status.val / 10000)
            end
        end)
        return thirst
    elseif QBCore then
        local Data = Frame:GetplayerData()
        return Data and Data.metadata.thirst
    end
end

function Frame:GetPlayerHunger()
    if Legacy then
        return exports.LEGACYCORE:GetPlayerHunger()
    elseif ESX then
        local hunger = nil
        TriggerEvent('esx_status:getStatus', "hunger", function(status)
            if status then
                hunger = (status.val / 10000)
            end
        end)
        return hunger
    elseif QBCore then
        local Data = Frame:GetplayerData()
        return Data and Data.metadata.hunger
    end
end

function Frame:GetPlayerBankAmount()
    if Legacy then
        local PlayerData = Frame:GetplayerData()
        local Accounts = PlayerData.accounts
        if PlayerData and Accounts then
            local finalAmount = Accounts.Bank
            return finalAmount
        else
            return nil
        end
    elseif ESX then
        if lib.context == 'server' then
            local xPlayer = ESX.GetPlayerFromId(cache.serverId)
            local accounts = xPlayer.getAccount('bank').money
            return accounts
        end
    elseif QBCore then
        local Data = Frame:GetplayerData()
        return Data and Data.money.bank
    end
end

return Frame
