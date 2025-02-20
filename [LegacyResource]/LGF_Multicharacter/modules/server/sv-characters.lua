local Chars = {}
Legacy = exports.LEGACYCORE:GetCoreData()

function Chars.GetPlayerCharacter(source)
    local Players = {}
    local Identifier = GetPlayerIdentifierByType(source, 'license')


    local PlayerData = MySQL.query.await('SELECT * FROM `users`')
    if PlayerData then
        for _, v in ipairs(PlayerData) do
            if string.find(v.identifier, Identifier) then
                if not Players[Identifier] then
                    Players[Identifier] = {}
                end

                local Data = {
                    playerName = v.playerName,
                    dob = v.dob,
                    playerGroup = v.playerGroup,
                    sex = v.sex,
                    skin = v.skin,
                    charIdentifier = v.charIdentifier,
                    lastcoords = v.lastSpawn,
                    identifier = v.identifier,
                    status = json.decode(v.status),
                    source = source,
                    accounts = json.decode(v.accounts),
                    JobName = v.JobName,
                    JobGrade = v.JobGrade,
                    JobLabel = v.JobLabel,
                    height = v.Height,
                    ped = GetPlayerPed(source)

                }


                Players[Identifier][#Players[Identifier] + 1] = Data
            end
        end

        if Players[Identifier] then
            table.sort(Players[Identifier], function(a, b)
                return a.charIdentifier < b.charIdentifier
            end)
        end
    end

    return Players[Identifier] or {}
end

function Chars.relog(target)
    local source = target
    TriggerClientEvent('RevoriaMultichar:playerLogout', source)
end

function Chars.saveCoords(source, coords, slot)
    local playerIdentifier = GetPlayerIdentifierByType(source, 'license')
    local slotChar = slot
    local success = MySQL.update.await('UPDATE users SET lastSpawn = ? WHERE identifier = ? AND charIdentifier = ?',
        {
            json.encode(coords),
            playerIdentifier,
            slotChar
        })
end

function Chars.deleteChar(source, slot)
    local identifier = GetPlayerIdentifierByType(source, 'license')

    local charIdentifier = MySQL.prepare.await(
        'SELECT `identifier` FROM `users` WHERE `charIdentifier` = ? AND `identifier` = ?', { slot, identifier })

    if not charIdentifier or #charIdentifier == 0 then
        return false
    end

    local result = MySQL.prepare.await('DELETE FROM `users` WHERE `charIdentifier` = ? AND `identifier` = ?',
        { slot, identifier })
        
    if result then
        return true
    end

    return false
end

function Chars.createChar(source, data)
    exports.LEGACYCORE:createCharacter({
        src = source,
        sex = data.Sex,
        height = data.Height,
        name = data.Name,
        dob = data.Dob,
        appearance = data.Appearance,
        slot = data.CharIdentifier
    })
end

return Chars
