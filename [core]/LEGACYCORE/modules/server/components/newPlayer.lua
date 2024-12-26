local SHARED = require 'modules.shared.shared_functions'
local ServerConfig = require "common.sv-configuration"


local function CreateDatabaseAndUsersTable()
    local dbName = Config.QueryData.NameDB
    local createDatabaseQuery = string.format('CREATE DATABASE IF NOT EXISTS `%s`', dbName)
    MySQL.query.await(createDatabaseQuery)
    SHARED.DebugData(string.format("Database created successfully or already exists: %s", dbName))

    local checkTableQuery = MySQL.query.await(string.format('SHOW TABLES FROM `%s` LIKE ?', dbName), { 'users' })

    if checkTableQuery and #checkTableQuery > 0 then
        SHARED.DebugData(string.format("The [^3users^7] table already exists in the database %s", dbName))
        return
    end


    local createTableQuery = string.format([[
        CREATE TABLE IF NOT EXISTS `%s`.`users` (
            `id` INT(11) NOT NULL AUTO_INCREMENT,
            `identifier` VARCHAR(50) DEFAULT NULL,
            `charIdentifier` VARCHAR(50) DEFAULT NULL,
            `inventory` TEXT DEFAULT '{}',
            `playerName` VARCHAR(50) DEFAULT NULL,
            `sex` VARCHAR(10) DEFAULT NULL,
            `dob` TINYTEXT DEFAULT NULL,
            `height` DECIMAL(5,2) DEFAULT NULL,
            `accounts` TEXT DEFAULT '{}',
            `status` LONGTEXT DEFAULT '{}',
            `skin` TEXT DEFAULT '{}',
            `lastSpawn` TEXT DEFAULT '{}',
            `playerGroup` VARCHAR(50) DEFAULT NULL,
            `JobName` VARCHAR(50) DEFAULT NULL,
            `JobLabel` VARCHAR(50) DEFAULT NULL,
            `JobGrade` INT(11) DEFAULT NULL,
            `is_dead` INT(11) DEFAULT NULL,
            `inDuty` TINYINT(1) DEFAULT 0,
            `mugshot` LONGTEXT DEFAULT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
    ]], dbName)

    local success, err = MySQL.query.await(createTableQuery)

    if success then
        SHARED.DebugData(string.format("The [^4users^7] table has been created successfully in the database %s", dbName))
    else
        SHARED.DebugData(string.format("Error creating the [users] table: %s", err or "Unknown error"))
    end
end


if Config.QueryData.CreateUsersAndDB then
    CreateDatabaseAndUsersTable()
end




local function GenerateNewCharIdentifier(existingCharIdentifiers)
    local maxNumber = 0
    for _, row in ipairs(existingCharIdentifiers) do
        local charIdentifier = row['charIdentifier']
        local num = tonumber(charIdentifier:match('%d+$')) or 0
        if num > maxNumber then maxNumber = num end
    end
    local newCharIdentifier = tostring(maxNumber + 1)
    return newCharIdentifier
end

local function tableIncludes(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

local function IsAdmin(identifier)
    local defaultGroup = Config.GroupData.FirstGroupAssigned
    local playerGroup = defaultGroup

    if not ServerConfig.Admin or type(ServerConfig.Admin) ~= 'table' then
        return defaultGroup
    end


    for i = 1, #ServerConfig.Admin do
        local adminData = ServerConfig.Admin[i]
        local adminIdentifier = adminData.Identifier
        local adminGroup = adminData.AssignedGroup or defaultGroup

        if identifier == adminIdentifier then
            playerGroup = adminGroup
            break
        end
    end


    if not tableIncludes(Config.GroupData.GroupCore, playerGroup) then
        playerGroup = defaultGroup
    end

    return playerGroup
end

exports('IsAdmin', IsAdmin)

local function createCharacter(data)
    local src = data.src
    local sex = data.sex
    local height = data.height
    local name = data.name
    local dob = data.dob
    local appearance = data.appearance
    local slot = data.slot
    local identifier = GetPlayerIdentifierByType(src, 'license')

    local accounts = json.encode({
        Bank = Config.HandlePlayer.Accounts.StartBankQuantity,
        money = Config.HandlePlayer.Accounts.StartCashQuantity,
    })
    local status = json.encode({
        hunger = Config.HandlePlayer.StatusParameters.Hunger,
        thirst = Config.HandlePlayer.StatusParameters.Thirst,
    })

    local existingCharIdentifiers = MySQL.query.await('SELECT `charIdentifier` FROM `users` WHERE `identifier` = ?',
        { identifier })
    local newCharIdentifier = slot or GenerateNewCharIdentifier(existingCharIdentifiers)

    local playerGroup = IsAdmin(identifier)
    local jobName = Config.GroupData.JobData.FirstJobAssigned
    local jobLabel = Config.GroupData.JobData.LabelJobAssigned
    local jobGrade = Config.GroupData.JobData.GradeJobAssigned
    local is_dead = false

    data.charIdentifier = newCharIdentifier
    data.playerGroup = playerGroup
    data.JobName = jobName
    data.JobLabel = jobLabel
    data.JobGrade = jobGrade
    data.is_dead = is_dead
    data.accounts = accounts
    data.status = status
    data.identifier = identifier
    data.sex = sex
    data.dob = dob
    data.height = height
    data.playerName = name
    data.skin = appearance
    data.source = src
    data.inventory = {}
    data.inDuty = false

    local success = false

    CreateThread(function()
        success = insertCharacterData(data)
    end)

    while not success do Wait(500) end

    lib.TriggerClientEvent('LegacyCore:PlayerLoaded', src, slot, data, true)

end


function insertCharacterData(data)
    local insertQuery = [[
        INSERT INTO `users` (`identifier`, `charIdentifier`, `sex`, `dob`, `height`, `playerName`, `playerGroup`,
                             `JobName`, `JobLabel`, `skin`, `accounts`, `is_dead`, `status`, `JobGrade`, `inDuty`)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]]

    local result = MySQL.rawExecute.await(insertQuery, {
        data.identifier, data.charIdentifier, data.sex, data.dob, data.height, data.playerName, data.playerGroup,
        data.JobName, data.JobLabel, data.skin, data.accounts, data.is_dead, data.status, data.JobGrade, data.inDuty
    })

    return result ~= nil
end

exports('createCharacter', createCharacter)

RegisterNetEvent('LEGACYCORE:QUERY:UpdateAppearance', function(appearance, slot)
    local src = source
    local identifier = GetPlayerIdentifierByType(src, 'license')
    local charIdentifier = slot
    SHARED.DebugData(("Slot Number '%s'"):format(charIdentifier))
    if charIdentifier and identifier then
        local updateQuery = [[ UPDATE `users` SET `skin` = ? WHERE `charIdentifier` = ? AND `identifier` = ? ]]
        MySQL.rawExecute(updateQuery, { json.encode(appearance), charIdentifier, identifier })

        SHARED.DebugData(("Updated appearance for character with charIdentifier '%s' and identifier '%s'"):format(
            charIdentifier, identifier))
    else
        SHARED.DebugData("Error: Character slot or player identifier not found")
    end
end)

RegisterNetEvent('Legacy:QUERY:SavePlayerStatus', function(playerId, hunger, thirst)
    local identifier = GetPlayerIdentifierByType(playerId, 'license')
    local newStatus = json.encode({ thirst = thirst, hunger = hunger })
    local PlayerSlot = Legacy.DATA:GetSlotSelected(playerId)
    if not PlayerSlot then return end

    local sql = 'UPDATE users SET status = ? WHERE identifier = ? AND charIdentifier = ?'
    local params = { newStatus, identifier, PlayerSlot }
    MySQL.update(sql, params, function(status)
        if status then
            -- print(string.format('Player status saved (Hunger: %.2f, Thirst: %.2f) for %s in slot %s', hunger, thirst, identifier, PlayerSlot))
        else
            print('Errore: Nessuna riga è stata aggiornata nel database.')
        end
    end)
end)
