IsLoaded = {}
Slots = {}
local CHECK = {}

AddEventHandler('playerDropped', function()
    local src = source
    TriggerEvent('LegacyCore:PlayerLogout', src)
    lib.TriggerClientEvent('LegacyCore:PlayerLogout', src)
end)

RegisterNetEvent('LegacyCore:PlayerLogout', function()
    local src = source
    local SHARED = require 'modules.shared.shared_functions'
    if not UTILS:IsEventAuthorized('LegacyCore:PlayerLogout') then
        print(('Unauthorized attempt to trigger %s by %s'):format('LegacyCore:PlayerLogout', src))
        CancelEvent()
        return
    end

    IsLoaded[src] = false
    Slots[src] = nil
    SHARED.DebugData(('IsLoaded[%s] set to false'):format(src))
end)

RegisterNetEvent('LegacyCore:PlayerLoaded', function(slot, data)
    print(string.format('Player Loded In Server Side With Slot Used %s', slot))
    print('my data server side', data)
    local SHARED = require 'modules.shared.shared_functions'
    local src = source
    if not UTILS:IsEventAuthorized('LegacyCore:PlayerLoaded') then
        print(('Unauthorized attempt to trigger %s by %s'):format('LegacyCore:PlayerLoaded', src))
        CancelEvent()
        return
    end

    Slots[src] = slot
    IsLoaded[src] = true
    SHARED.DebugData(('IsLoaded[%s] set to true'):format(src))
    Citizen.SetTimeout(10000, function()
        CHECK:SetPaycheck(src, slot)
    end)
end)

exports('isLoadedServer', function(src)
    return IsLoaded[src]
end)

function Legacy.DATA:GetSlotSelected(source)
    return Slots[source]
end

function CHECK:SetPaycheck(src, slot)
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
                        NOTIFY:SendServerNotification(src, LANG.CoreLang("Paycheck_Notification_Title"), message,
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
                    CHECK:SetPaycheck(src, slot)
                end
            end
        end
    end
end)


RegisterNetEvent('LegacyCore:StartInventoryPack', function(sour, slot)
    local SHARED = require 'modules.shared.shared_functions'
    if slot == Legacy.DATA:GetSlotSelected(sour) then
        local startPack = Config.HandlePlayer.StartPack
        for i = 1, #startPack do
            local itemName = startPack[i].item
            local itemCount = startPack[i].count
            local success, response = exports.ox_inventory:AddItem(sour, itemName, itemCount)
            if not success then
                if response == "invalid_item" then
                    print(string.format("Failed to add item '%s': item does not exist.", itemName))
                elseif response == "invalid_inventory" then
                    print("Failed to add item: inventory does not exist.")
                else
                    SHARED.DebugData(("Failed to add item %s:"):format(response))
                end
            else
                SHARED.DebugData(("Successfully added %d of item '%s' to inventory."):format(itemCount, itemName))
            end
        end
    else
        SHARED.DebugData('SLot Is not the same my G DON ALI')
    end
end)
