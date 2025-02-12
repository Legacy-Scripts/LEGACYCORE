IsLoaded = {}
Slots = {}

AddEventHandler('playerDropped', function()
    local src = source
    TriggerEvent('LegacyCore:PlayerLogout', src)
    lib.TriggerClientEvent('LegacyCore:PlayerLogout', src)
end)

RegisterNetEvent('LegacyCore:PlayerLogout', function()
    local src = source
    local SHARED = require 'modules.shared.shared_functions'

    SHARED.DebugData(('IsLoaded[%s] set to false'):format(src))

    IsLoaded[src] = false

    Slots[src] = nil
end)

RegisterNetEvent('LegacyCore:PlayerLoaded', function(slot, data)
    local SHARED = require 'modules.shared.shared_functions'
    local src = source

    Slots[src] = slot
    IsLoaded[src] = true
    SHARED.DebugData(('IsLoaded[%s] set to true'):format(src))
    if Config.CoreInfo.PayCheck.EnablePaycheck then
        SetTimeout(10000, function()
            Legacy.DATA:SetPaycheck(src, slot)
        end)
    end
end)

exports('isLoadedServer', function(src)
    return IsLoaded[src]
end)

function Legacy.DATA:GetSlotSelected(source)
    return Slots[source]
end

function Legacy.DATA:SetPaycheck(src, slot)
    local isOnline = Legacy.MAIN:IsPlayerOnline(src)
    local PlayerData = Legacy.DATA:GetPlayerDataBySlot(src)

    if not IsLoaded[src] then return end

    if not PlayerData then
        print(('Player data not found for slot %s'):format(slot))
        return
    end

    local PlayerJob = PlayerData.JobName
    local PlayerGrade = PlayerData.JobGrade

    if not PlayerJob or not PlayerGrade then
        print(('Job or Grade not found for player %s'):format(src))
        return
    end

    if isOnline then
        local promise, error = MySQL.query.await('SELECT `paycheck` FROM `lgf_jobs` WHERE `name` = ? AND `grade` = ?',
            { PlayerJob, PlayerGrade })
        if promise then
            for i = 1, #promise do
                local row = promise[i]
                local accountsData = json.decode(PlayerData.accounts)
                if accountsData then
                    accountsData.Bank = (accountsData.Bank or 0) + row.paycheck
                    local updatedAccounts = json.encode(accountsData)
                    local updatePromise, updateError = MySQL.update.await(
                        'UPDATE `users` SET `accounts` = ? WHERE `identifier` = ? AND `charIdentifier` = ?',
                        { updatedAccounts, PlayerData.identifier, slot })
                    if updatePromise then
                        local message = LANG.CoreLang("Paycheck_Notification_Message"):format(row.paycheck)
                        Legacy.MAIN:SendServerNotification(src, LANG.CoreLang("Paycheck_Notification_Title"), message,
                            'fa-solid fa-money-bill', 5000, 'success')
                    else
                        print(('Failed to update accounts for player %s: %s'):format(src, updateError))
                    end
                end
            end
        else
            print(error)
        end
    end
end

CreateThread(function()
    if Config.CoreInfo.PayCheck.EnablePaycheck then
        while true do
            Wait(Config.CoreInfo.PayCheck.ThicknessPaycheck * 1000)
            for src, slot in pairs(Slots) do
                if IsLoaded[src] then
                    Legacy.DATA:SetPaycheck(src, slot)
                end
            end
        end
    end
end)


RegisterNetEvent('LegacyCore:StartInventoryPack', function(sour, slot)
    local SHARED = require 'modules.shared.shared_functions'
    local src = source

    if sour ~= src then
        print("Source and Target mismatch, probably Triggering Event")
        return
    end

    if slot == Legacy.DATA:GetSlotSelected(sour) then
        Legacy.DATA:CharacterStarterPack({
            target = src,
        })
    else
        SHARED.DebugData('Slot is not the same, my G. DON ALI')
    end
end)

function Legacy.DATA:CharacterStarterPack(data)
    local SHARED = require 'modules.shared.shared_functions'

    local startPack = Config.HandlePlayer.StartPack

    for i = 1, #startPack do
        local itemName = data?.itemData and data?.itemData[i] and data?.itemData[i]?.itemName or startPack[i]?.item
        local itemCount = data?.itemData and data?.itemData[i] and data?.itemData[i]?.itemCount or startPack[i]?.count
        local metadata = data?.itemData and data?.itemData[i] and data?.itemData[i]?.metadata or nil

        local target = data.target
        if not target then target = source end

        local success, response = exports.ox_inventory:AddItem(target, itemName, itemCount, metadata)


        if not success then
            SHARED.DebugData(("Failed to add item %s: %s"):format(itemName, response))
        else
            SHARED.DebugData(("Successfully added %d of item '%s' to inventory."):format(itemCount, itemName))
        end
    end
end
