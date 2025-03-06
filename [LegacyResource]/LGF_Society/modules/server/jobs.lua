local Jobs = {}
local Legacy = exports.LEGACYCORE:GetCoreData()
local OnDutyPlayers = {}
if lib.context == 'server' then lib.load("@oxmysql/lib/MySQL") end


if Config.RunSqlJob then
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `lgf_jobs` (
            `id` INT AUTO_INCREMENT PRIMARY KEY,
            `name` VARCHAR(255) NOT NULL,
            `label` VARCHAR(255) NOT NULL,
            `grade` INT,
            `paycheck` INT,
            UNIQUE KEY `id_UNIQUE` (`id`)
        ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ]])
end

function Jobs:CreateJob(name, label, grade, paycheck)
    MySQL.scalar('SELECT COUNT(*) AS count FROM `lgf_jobs` WHERE `name` = ?', { name },
        function(count)
            if count > 0 then
                print(("Error: Job '%s' already exists."):format(name))
            else
                MySQL.rawExecute('INSERT INTO `lgf_jobs` (`name`, `label`, `grade`, `paycheck`) VALUES (?, ?, ?, ?)',
                    { name, label, grade, paycheck },
                    function(rowsChanged)
                        if rowsChanged then
                            if Config.EnableDebug then
                                print(("Job '%s' created successfully with label '%s', grade '%d', and paycheck '%d'.")
                                    :format(name, label, grade, paycheck))
                            end
                        else
                            print("Failed to create job.")
                        end
                    end
                )
            end
        end
    )
end

function Jobs:RemoveJob(name)
    MySQL.scalar('SELECT COUNT(*) AS count FROM `lgf_jobs` WHERE `name` = ?', { name },
        function(count)
            if count > 0 then
                MySQL.rawExecute('DELETE FROM `lgf_jobs` WHERE `name` = ?',
                    { name },
                    function(rowsChanged)
                        if rowsChanged then
                            if Config.EnableDebug then
                                print(("Job '%s' removed successfully."):format(name))
                            end
                        else
                            print("Failed to remove job.")
                        end
                    end
                )
            else
                print(("Error: Job '%s' not found."):format(name))
            end
        end
    )
end

function Jobs:CreateOrUpdateJobGrade(name, label, grade, paycheck)
    MySQL.scalar('SELECT COUNT(*) AS count FROM `lgf_jobs` WHERE `name` = ? AND `grade` = ?', { name, grade },
        function(count)
            if count > 0 then
                MySQL.rawExecute('UPDATE `lgf_jobs` SET `label` = ?, `paycheck` = ? WHERE `name` = ? AND `grade` = ?',
                    { label, paycheck, name, grade },
                    function(rowsChanged)
                        if rowsChanged then
                            if Config.EnableDebug then
                                print(("Job grade updated successfully for '%s' at grade '%d' with label '%s' and paycheck '%d'.")
                                    :format(name, grade, label, paycheck))
                            end
                        else
                            print("Failed to update job grade.")
                        end
                    end
                )
            else
                MySQL.rawExecute('INSERT INTO `lgf_jobs` (`name`, `label`, `grade`, `paycheck`) VALUES (?, ?, ?, ?)',
                    { name, label, grade, paycheck },
                    function(rowsChanged)
                        if rowsChanged then
                            if Config.EnableDebug then
                                print(("Job grade created successfully for '%s' at grade '%d' with label '%s' and paycheck '%d'.")
                                    :format(name, grade, label, paycheck))
                            end
                        else
                            print("Failed to create job grade.")
                        end
                    end
                )
            end
        end
    )
end

function Jobs:RemoveJobGrade(name, grade)
    MySQL.scalar('SELECT COUNT(*) AS count FROM `lgf_jobs` WHERE `name` = ? AND `grade` = ?', { name, grade },
        function(count)
            if count > 0 then
                MySQL.rawExecute('DELETE FROM `lgf_jobs` WHERE `name` = ? AND `grade` = ?',
                    { name, grade },
                    function(rowsChanged)
                        if rowsChanged then
                            if Config.EnableDebug then
                                print(("Job grade '%d' removed successfully for '%s'."):format(grade, name))
                            end
                        else
                            print("Failed to remove job grade.")
                        end
                    end
                )
            else
                print(("Error: Job grade '%d' for '%s' not found."):format(grade, name))
            end
        end
    )
end

function Jobs:GradeAndJobExists(jobName, jobGrade, callback)
    MySQL.scalar("SELECT COUNT(*) AS count FROM lgf_jobs WHERE name = ? AND grade = ?", { jobName, jobGrade },
        function(count)
            if count > 0 then
                callback(true)
            else
                callback(false)
            end
        end
    )
end

function Jobs:SetPlayerJob(id, jobName, jobGrade)
    local PlayerData = Legacy.DATA:GetPlayerDataBySlot(id)
    local PlayerIdentifier = PlayerData.identifier
    local PlayerSlot = Legacy.DATA:GetPlayerCharSlot(id)
    jobGrade = jobGrade or PlayerData.JobGrade
    local currJob = {name = PlayerData.JobName, grade = PlayerData.JobGrade}

    self:GradeAndJobExists(jobName, jobGrade, function(exists)
        if exists then
            MySQL.update('UPDATE users SET JobName = ?, JobGrade = ? WHERE identifier = ? AND charIdentifier = ?',
                { jobName, jobGrade, PlayerIdentifier, PlayerSlot },
                function(affectedRows)
                    TriggerEvent('LegacyCore:changeJob', -1, id, jobName, jobGrade, currJob)
                    TriggerClientEvent('LegacyCore:changeJob', -1,  id, jobName, jobGrade, currJob)

                    if affectedRows > 0 then
                        if Config.EnableDebug then
                            print(("User with ID '%d' job updated to '%s' with grade '%d'."):format(id, jobName, jobGrade))
                        end
                    else
                        print(("Failed to update user with ID '%d' job."):format(id))
                    end
                end
            )
        else
            print(("Error: Job '%s' with grade '%d' does not exist. Cannot update user job."):format(jobName, jobGrade))
        end
    end)
end

function Jobs:IsPlayerOnDuty(playerID)
    return OnDutyPlayers[playerID] or false
end

function Jobs:SetPlayerOnDuty(playerID, onDuty)
    OnDutyPlayers[playerID] = onDuty
end

RegisterNetEvent('LegacyCore:PlayerLogout', function()
    local playerID = source
    OnDutyPlayers[playerID] = false
end)



lib.callback.register('LegacyCore:IsPlayerOnDuty', function(source, target)
    local checkId = target or source
    return Jobs:IsPlayerOnDuty(checkId)
end)

exports('CreateJob', function(name, label, grade, paycheck)
    return Jobs:CreateJob(name, label, grade, paycheck)
end)

exports('RemoveJob', function(name)
    return Jobs:RemoveJob(name)
end)

exports('CreateOrUpdateJobGrade', function(name, label, grade, paycheck)
    return Jobs:CreateOrUpdateJobGrade(name, label, grade, paycheck)
end)

exports('RemoveJobGrade', function(name, grade)
    return Jobs:RemoveJobGrade(name, grade)
end)

exports('SetPlayerJob', function(id, jobName, jobGrade)
    return Jobs:SetPlayerJob(id, jobName, jobGrade)
end)

exports('GetJobAndGradeExist', function(jobName, jobGrade, callback)
    return Jobs:GradeAndJobExists(jobName, jobGrade, callback)
end)

exports('IsPlayerOnDuty', function(playerID)
    return Jobs:IsPlayerOnDuty(playerID)
end)

exports('SetPlayerOnDuty', function(playerID, onDuty)
    Jobs:SetPlayerOnDuty(playerID, onDuty)
end)

RegisterNetEvent('LegacyCore:SetPlayerOnDuty', function(playerID, onDuty)
    Jobs:SetPlayerOnDuty(playerID, onDuty)
end)

return Jobs
