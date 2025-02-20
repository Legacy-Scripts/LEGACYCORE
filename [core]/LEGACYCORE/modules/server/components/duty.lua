local playerDutyStates = {}

function Legacy.DATA:SetPlayerDuty(target, dutyState)
    if Legacy.MAIN:IsPlayerOnline(target) then
        local identifier = GetPlayerIdentifierByType(target, "license")
        local slot = Legacy.DATA:GetSlotSelected(target)

        if not slot then print(("Missing charIdentifier for target %s"):format(target)) return end 

        local currentDutyState = playerDutyStates[target] or Legacy.DATA:IsPlayerOnDuty(target)

        if currentDutyState == dutyState then
            return true
        end

        local query = string.format("UPDATE `users` SET `inDuty` = ?, `charIdentifier` = ? WHERE `identifier` = ?")
        local result, err = MySQL.query.await(query, { dutyState, slot, identifier })

        if err then
            return false, err
        end


        playerDutyStates[target] = dutyState

        return result ~= nil
    end

    return false
end

function Legacy.DATA:IsPlayerOnDuty(target)
    if playerDutyStates[target] ~= nil then
        return playerDutyStates[target]
    end


    local identifier = GetPlayerIdentifierByType(target, "license")
    local slot = Legacy.DATA:GetSlotSelected(target)

    if not slot then print(("Missing charIdentifier for target %s"):format(target)) return end 

    local result, err = MySQL.query.await('SELECT `inDuty` FROM `users` WHERE `identifier` = ? AND `charIdentifier` = ?',
        { identifier, slot })

    if err then
        return false, err
    end


    if result and #result > 0 then
        playerDutyStates[target] = result[1].inDuty
        return result[1].inDuty
    else
        playerDutyStates[target] = false
        return false
    end
end

lib.callback.register("LegacyCore.SetPlayerDutyState", function(source, target, dutyState)
    local success, err = Legacy.DATA:SetPlayerDuty(target, dutyState)

    if success then
        return true
    else
        return false, err
    end
end)


lib.callback.register("LegacyCore.GetPlayerDutyState", function(source, target)
    local playerId = target or source

    local dutyState, err = Legacy.DATA:IsPlayerOnDuty(playerId)

    if dutyState then
        return dutyState
    else
        return false, err
    end
end)
