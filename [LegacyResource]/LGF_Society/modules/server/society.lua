local Society = {}

if lib.context == 'server' then lib.load("@oxmysql/lib/MySQL") end

if Config.RunSqlSociety then
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `lgf_society` (
            `id` INT AUTO_INCREMENT PRIMARY KEY,
            `name` VARCHAR(255) NOT NULL,
            `funds` INT NOT NULL,
            `shared` BOOLEAN NOT NULL
        ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ]])
end


function Society:CreateSociety(name, initialFunds, shared)
    MySQL.scalar('SELECT COUNT(*) AS count FROM `lgf_society` WHERE `name` = ?', { name }, function(count)
        if count > 0 then
            if Config.EnableDebug then
                print(("Warning: A society with the name '%s' already exists."):format(name))
            end
        else
            local society = {
                name = name,
                funds = initialFunds,
                shared = shared
            }

            MySQL.rawExecute('INSERT INTO `lgf_society` (`name`, `funds`, `shared`) VALUES (?, ?, ?)', {
                society.name,
                society.funds,
                society.shared
            }, function(rowsChanged)
                if rowsChanged then
                    if Config.EnableDebug then
                        print(("Society '%s' created successfully with initial funds of %d."):format(society.name,
                            society.funds))
                    end
                else
                    print("Error: Failed to create the society.")
                end
            end)
        end
    end)
end

function Society:UpdateSocietyFunds(societyName, amount)
    MySQL.scalar('SELECT `funds` FROM `lgf_society` WHERE `name` = ?', { societyName }, function(currentFunds)
        if currentFunds then
            local newFunds = currentFunds + amount
            MySQL.rawExecute('UPDATE `lgf_society` SET `funds` = ? WHERE `name` = ?', { newFunds, societyName },
                function(rowsChanged)
                    if rowsChanged then
                        if Config.EnableDebug then
                            print(("Funds of society '%s' updated. New funds: %d"):format(societyName, newFunds))
                        end
                    else
                        print("Error: Failed to update funds of the society.")
                    end
                end)
        else
            print("Error: Society not found.")
        end
    end)
end

function Society:GetSocietyInfo(societyName)
    local query = MySQL.query.await('SELECT * FROM `lgf_society` WHERE `name` = ?', { societyName })

    if query and query[1] then
        local society = {
            name = query[1].name,
            funds = query[1].funds,
            shared = query[1].shared
        }
        return society
    else
        print(("Error: Society '%s' not found."):format(societyName))
    end
end

function Society:RemoveSocietyFunds(societyName, amount)
    MySQL.scalar('SELECT `funds` FROM `lgf_society` WHERE `name` = ?', { societyName }, function(currentFunds)
        if currentFunds then
            local newFunds = currentFunds - amount
            MySQL.rawExecute('UPDATE `lgf_society` SET `funds` = ? WHERE `name` = ?', { newFunds, societyName },
                function(rowsChanged)
                    if rowsChanged then
                        if Config.EnableDebug then
                            print(("Removed funds from society '%s'. New funds: %d"):format(societyName, newFunds))
                        end
                    else
                        print("Error: Failed to remove funds from the society.")
                    end
                end)
        else
            print("Error: Society not found.")
        end
    end)
end

function Society:RemoveSociety(societyName)
    MySQL.rawExecute('DELETE FROM `lgf_society` WHERE `name` = ?', { societyName }, function(rowsChanged)
        if rowsChanged then
            if Config.EnableDebug then
                print(("Society '%s' removed successfully."):format(societyName))
            end
        else
            print("Error: Failed to remove the society.")
        end
    end)
end

AddEventHandler('LegacyCore:GetSocietyInfo', function(societyName, callback)
    local societyInfo = Society:GetSocietyInfo(societyName)
    callback(societyInfo.name, societyInfo.funds, societyInfo.shared)
end)


exports('CreateSociety', function(name, initialFunds, shared)
    return Society:CreateSociety(name, initialFunds, shared)
end)

exports('GetSocietyInfo', function(name)
    return Society:GetSocietyInfo(name)
end)


lib.callback.register('LegacyCore:GetSocietyInfo', function(source, name)
    return Society:GetSocietyInfo(name)
end)

exports('UpdateSocietyFunds', function(name, amount)
    return Society:UpdateSocietyFunds(name, amount)
end)

exports('RemoveSocietyFunds', function(name, amount)
    return Society:RemoveSocietyFunds(name, amount)
end)

exports('RemoveSociety', function(name)
    return Society:RemoveSociety(name)
end)


Wait(3000)


if Config.CreateSociety then
    for _, data in ipairs(Config.SocietyToCreate) do
        Society:CreateSociety(data.Name, data.StartSocietyFunds, data.Shared)
    end
end




