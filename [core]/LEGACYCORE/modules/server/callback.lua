lib.callback.register("LegacyCore.setPlayerBucket", function(source, data)
    if not data.target then data.target = source end
    if not data.bucket then data.bucket = source end

    local result, bucket = Legacy.MAIN:SetPlayerBucket(data)

    return result, bucket
end)

lib.callback.register('LegacyCore:DATA:GetPlayerDataBySlot', function(source)
    return Legacy.DATA:GetPlayerDataBySlot(source)
end)

lib.callback.register('LegacyCore:DATA:GetFirstAvailableSlot', function(source)
    return Legacy.DATA:GetFirstAvailableSlot(source)
end)


lib.callback.register('LegacyCore:GetPlayerStatus', function(source)
    local playerData = Legacy.DATA:GetPlayerDataBySlot(source)
    if not playerData or not playerData.identifier then return nil end

    local Identifier = playerData.identifier
    local slot = Legacy.DATA:GetSlotSelected(source)
    if not slot then return nil end

    local statusDataResult = MySQL.query.await('SELECT status FROM `users` WHERE `identifier` = ? AND `charIdentifier` = ?', { Identifier, slot })
    if not statusDataResult[1].status then
        print(("Failed to retrieve status data for identifier: %s and slot: %s"):format(Identifier, slot))
        return nil
    end

    local statusData = json.decode(statusDataResult[1].status)

    TriggerClientEvent('LegacyCore:thickStatus', source, statusData.hunger, statusData.thirst, slot)


    return {
        thirst = statusData.thirst,
        hunger = statusData.hunger
    }
end)