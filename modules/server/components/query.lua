local SHARED = require 'modules.shared.shared_functions'

local function CreateDatabaseAndUsersTable()
    local dbName = Config.QueryData.NameDB
    local createDatabaseQuery = 'CREATE DATABASE IF NOT EXISTS `' .. dbName .. '`'
    MySQL.rawExecute(createDatabaseQuery, {})

    local checkTableQuery = 'SHOW TABLES FROM `' .. dbName .. '` LIKE ?'
    local result = MySQL.query.await(checkTableQuery, { 'users' })
    if result and #result > 0 then
        SHARED.DebugData("The [^3users^7] table already exists in the database " .. dbName)
    else
        local createTableQuery = [[
            CREATE TABLE IF NOT EXISTS `]] .. dbName .. [[`.`users` (
                `id` INT AUTO_INCREMENT PRIMARY KEY,
                `identifier` VARCHAR(50),
                `charIdentifier` VARCHAR(50),
                `inventory` TEXT DEFAULT '{}',
                `playerName` VARCHAR(50),
                `sex` VARCHAR(10),
                `dob` DATE,
                `height` DECIMAL(5,2),
                `accounts` TEXT DEFAULT '{}',
                `status` LONGTEXT DEFAULT '{}',
                `skin` TEXT DEFAULT '{}',
                `lastSpawn` TEXT DEFAULT '{}',
                `playerGroup` VARCHAR(50),
                `JobName` VARCHAR(50),
                `JobLabel` VARCHAR(50),
                `JobGrade` INT,
                `is_dead` INT
            )
        ]]
        MySQL.rawExecute(createTableQuery, {})

        SHARED.DebugData("The [^4users^7] table has been created correctly in database " .. dbName)
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

    -- Check if the identifier matches any admin identifier
    local isAdmin = false
    for _, adminIdentifier in ipairs(Config.AdminIdentifier) do
        if identifier == adminIdentifier then
            isAdmin = true
            break
        end
    end

    if isAdmin then
        playerGroup = 'admin'
    elseif not tableIncludes(Config.GroupData.GroupCore, playerGroup) then
        playerGroup = defaultGroup
    end
    return playerGroup
end

RegisterNetEvent('LEGACYCORE:QUERY:CreateCharId', function(src, sex, height, name, dob, appearance, slot)
    local identifier = GetPlayerIdentifierByType(src, 'license')
    local accounts = json.encode({
        Bank = Config.HandlePlayer.Accounts.StartBankQuantity,
        money = Config.HandlePlayer.Accounts.StartCashQuantity,
    })

    local status = json.encode({
        hunger = Config.HandlePlayer.StatusParameters.Hunger,
        thirst = Config.HandlePlayer.StatusParameters.Thirst,
    })

    -- Check char identifier match with this char
    local existingCharIdentifiers = MySQL.query.await('SELECT `charIdentifier` FROM `users` WHERE `identifier` = ?',
        { identifier })

    local newCharIdentifier =slot or GenerateNewCharIdentifier(existingCharIdentifiers)

    local playerGroup = IsAdmin(identifier)

    print(playerGroup)
    local jobName = Config.GroupData.JobData.FirstJobAssigned
    local jobLabel = Config.GroupData.JobData.LabelJobAssigned
    local jobGrade = Config.GroupData.JobData.GradeJobAssigned
    local is_dead = false

    local insertQuery =
    [[ INSERT INTO `users` (`identifier`, `charIdentifier`, `sex`, `dob`, `height`, `playerName`, `playerGroup`, `JobName`, `JobLabel`, `skin`,`accounts` ,`is_dead`,`status` ,`JobGrade` ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ]]

    MySQL.rawExecute(insertQuery,{ identifier, newCharIdentifier, sex, dob, height, name, playerGroup, jobName, jobLabel, appearance, accounts, is_dead, status, jobGrade })

    SHARED.DebugData(("Created new record with charIdentifier '%s' for player %s with group %s and job %s"):format( newCharIdentifier, identifier, playerGroup, jobName))
    Wait(2000)
    local PlayerData = {
        identifier = identifier,
        charIdentifier = newCharIdentifier,
        sex = sex,
        dob = dob,
        height = height,
        playerName = name,
        playerGroup = playerGroup,
        JobName = jobName,
        JobLabel = jobLabel,
        is_dead = is_dead,
        jobGrade = jobGrade,
        accounts = json.decode(accounts),
        status = json.decode(status),
        skin = appearance,
        source = src,
        inventory = {},
    }
    lib.TriggerClientEvent('LegacyCore:LGF_OxCharacter:RiempiTable',src ,PlayerData)
    -- StartInventoryPack(src)
end)

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
