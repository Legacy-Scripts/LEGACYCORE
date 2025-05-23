-- DEPRECATED: Use Legacy.DATA:GetPlayerDataBySlot(src)
--[[
    Legacy.DATA:GetPlayerData(src) DEPRECATED AND OBSOLETE
]]
---@param src number - Source of the player
---@return table | nil - Player data table or nil if not found
function Legacy.DATA:GetPlayerData(src)
    if not src then return end
    local identifier = GetPlayerIdentifierByType(src, 'license')
    local playerData = MySQL.query.await('SELECT * FROM `users` WHERE `identifier` = ?', { identifier })
    return playerData[1]
end

--[[
    Legacy.DATA:GetPlayerDataBySlot(src)
]]
---@param src number - Source of the player
---@return table | nil - Player data table or nil if not found
function Legacy.DATA:GetPlayerDataBySlot(src)
    local identifier = GetPlayerIdentifierByType(src, 'license')
    local slot = Legacy.DATA:GetSlotSelected(src)
    local playerDatats = MySQL.query.await('SELECT * FROM `users` WHERE `identifier` = ? AND `charIdentifier` = ?',
        { identifier, slot })
    return playerDatats[1]
end

--[[
    Legacy.DATA:GetPlayerCharSlot(src)
]]
---@param src number - Source of the player
---@return string - Character slot
function Legacy.DATA:GetPlayerCharSlot(src)
    return Legacy.DATA:GetSlotSelected(src)
end

--[[
    Legacy.DATA:GetPlayerJobData(src)
]]
---@param src number - Source of the player
---@return table | nil - Job data table or nil if not found
function Legacy.DATA:GetPlayerJobData(src)
    local playerData = Legacy.DATA:GetPlayerDataBySlot(src)
    if not playerData then return warn('Player data not found!') end

    local Identifier = playerData.identifier
    local JobName = playerData.JobName
    local JobGrade = playerData.JobGrade
    local JobLabel = playerData.JobLabel

    if Identifier and JobName and JobLabel then
        if JobName == 'unemployed' then JobGrade = 0 end
        local JobData = { JobName = JobName, JobLabel = JobLabel, JobGrade = JobGrade }
        return JobData
    else
        return warn('Table is Empty!!')
    end
end

--[[
    Legacy.DATA:GetPlayerGroup(src)
]]
---@param src number - Source of the player
---@return string | nil - Player group or nil if not found
function Legacy.DATA:GetPlayerGroup(src)
    local PlayerGroup = Legacy.DATA:GetPlayerDataBySlot(src).playerGroup
    if not PlayerGroup then return warn('Player Group not found!') end
    return PlayerGroup
end

--[[
    Legacy.DATA:GetName(src)
]]
---@param src number - Source of the player
---@return string | nil - Player name or nil if not found
function Legacy.DATA:GetName(src)
    local PlayerName = Legacy.DATA:GetPlayerDataBySlot(src).playerName
    if not PlayerName then return warn('Player Name not found!') end
    return PlayerName
end

--[[
    Legacy.DATA:GetGender(src)
]]
---@param src number - Source of the player
---@return string | nil - Player gender or nil if not found
function Legacy.DATA:GetGender(src)
    local Sex = Legacy.DATA:GetPlayerDataBySlot(src).sex
    if not Sex then return warn('Player Gender not found!') end
    return Sex
end

--[[
    Legacy.DATA:GetInventoryData(src)
]]
---@param src number - Source of the player
---@return table | nil - Player inventory or nil if not found
function Legacy.DATA:GetInventoryData(src)
    local Inventory = Legacy.DATA:GetPlayerDataBySlot(src).inventory
    if not Inventory then return warn('Player Inventory not found!') end
    return Inventory
end

--[[
    Legacy.DATA:GetPlayerAccount(src)
]]
---@param src number - Source of the player
---@return table | nil - Player account data or nil if not found
function Legacy.DATA:GetPlayerAccount(src)
    local Accounts = Legacy.DATA:GetPlayerDataBySlot(src).accounts
    if not Accounts then return warn('Player Account not found!') end
    return Accounts
end

--[[
    Legacy.DATA:SetPlayerData(src, key, value, slot)
]]
---@param src number - Source of the player
---@param key string - Data key to be updated
---@param value any - New value for the key
---@param slot string - Character slot
---@return boolean? - True if successful, false otherwise
function Legacy.DATA:SetPlayerData(src, key, value, slot)
    if not src or not key or not value then return warn('Invalid parameters') end
    local playerData = Legacy.DATA:GetPlayerDataBySlot(src)
    if not playerData then return warn('Player data not found!') end
    local identifier = playerData.identifier
    local query = ('UPDATE `users` SET `%s` = ? WHERE `identifier` = ? AND charIdentifier = ?'):format(key)
    local success, error_message = MySQL.rawExecute.await(query, { value, identifier, slot })
    if not success then return warn(('Failed to update %s: %s'):format(key, tostring(error_message))) end
    return true
end

--[[
    Legacy.DATA:GetCharacterExist(src, slot)
]]
---@param src number - Source of the player
---@param slot string - Character slot to check
---@return boolean? - True if the character exists, false otherwise
function Legacy.DATA:GetCharacterExist(src, slot)
    local identifier = GetPlayerIdentifierByType(src, 'license')
    local exists = MySQL.query.await(
        'SELECT COUNT(*) as count FROM `users` WHERE `identifier` = ? AND `charIdentifier` = ?', { identifier, slot })
    return exists[1].count > 0
end

--[[
    Legacy.DATA:GetFirstAvailableSlot(src)
]]
---@param src number - Source of the player
---@return string - First available slot number or "1" if none found
function Legacy.DATA:GetFirstAvailableSlot(src)
    local maxSlots = 10
    local identifier = GetPlayerIdentifierByType(src, 'license')

    for slotNumber = 1, maxSlots do
        local exists = MySQL.query.await(
            'SELECT COUNT(*) as count FROM `users` WHERE `identifier` = ? AND `charIdentifier` = ?',
            { identifier, slotNumber })
        if exists[1].count == 1 then
            return tostring(slotNumber)
        end
    end

    return tostring(1)
end

--[[
    Legacy.DATA:GiveVehicle(src, props, stored)
    Inserts a vehicle into the owned_vehicles table for the specified player.
]]
---@param src number - Source ID of the player
---@param props table - Vehicle properties (plate, model, etc.)
---@param stored boolean - Whether the vehicle is stored (true = stored, false = out)
---@return boolean - True on success, false/nil on failure
function Legacy.DATA:GiveVehicle(src, props, stored)
    if not src or not props or not props.plate then
        return false, warn('Invalid parameters for GiveVehicle')
    end

    local identifier = GetPlayerIdentifierByType(src, 'license')
    if not identifier then
        return false, warn('Player identifier not found')
    end

    local insertId = MySQL.insert.await(
        'INSERT INTO owned_vehicles (owner, plate, vehicle, garage, stored) VALUES (?, ?, ?, ?, ?)',
        { identifier, props.plate, json.encode(props), "A", stored and 1 or 0 }
    )

    if not insertId then
        warn('Failed to insert vehicle into the database')
        return false
    end

    return true
end
