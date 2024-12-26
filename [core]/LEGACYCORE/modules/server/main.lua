Legacy = {
    MAIN = {},
    DATA = {}
}

function Legacy.MAIN:GetPlayers()
    local players = {}
    local allPlayers = GetPlayers() 

    for i = 1, #allPlayers do
        local targetID = allPlayers[i]

        players[#players + 1] = {
            id = targetID,
            name = Legacy.MAIN:GetNameIDE(targetID)
        }
    end
    
    return players
end


function Legacy.MAIN:GetNameIDE(src)
    return GetPlayerName(src)
end

function Legacy.MAIN:GetPlayerCount()
    return #GetPlayers()
end

function Legacy.MAIN:IsPlayerOnline(source)
    local players = GetPlayers()

    for i = 1, #players do
        if tonumber(players[i]) == tonumber(source) then
            return true
        end
    end

    return false
end

function Legacy.MAIN:SendServerNotification(source, title, msg, icon, duration, tipo)
    TriggerClientEvent('ox_lib:notify', source, {
        title = title or 'Legacy Core',
        description = msg,
        icon = icon,
        duration = duration,
        position = 'top-left',
        type = tipo,
    })
end

function Legacy.MAIN:initializeCoreGroups()
    local coreGroups = {}
    for _, groupName in ipairs(Config.GroupData.GroupCore) do
        table.insert(coreGroups, groupName)
    end
    Config.GroupData.CoreGroups = coreGroups
end

CreateThread(Legacy.MAIN.initializeCoreGroups)


function Legacy.MAIN:GetPlayerBucket(target)
    local current_bucket = GetPlayerRoutingBucket(target)
    return current_bucket
end

function Legacy.MAIN:setPlayerBucket(data)
    local lockdownType = data.restriction and data.restriction.lockdownType or false
    local enablePopulation = data.enablePopulation or true
    local bucket_id = data.bucket
    local target = data.target

    if self:GetPlayerBucket(target) == bucket_id then
        return false, (("You are already in bucket %s"):format(bucket_id))
    end

    if not bucket_id then
        local current_bucket = self:GetPlayerBucket(target)
        return false, current_bucket
    end

    if bucket_id <= 0 then
        return false, ("Bucket starts from 0, not a negative value")
    end

    SetPlayerRoutingBucket(target, bucket_id)
    SetRoutingBucketPopulationEnabled(bucket_id, enablePopulation)

    if lockdownType then
        if lockdownType == "strict" or lockdownType == "relaxed" or lockdownType == "inactive" then
            SetRoutingBucketEntityLockdownMode(bucket_id, lockdownType)
        else
            return false, ("Invalid lockdown type. Valid types are: strict, relaxed, inactive.")
        end
    end

    return true, bucket_id
end


