Data = {}
Legacy = exports.LEGACYCORE:GetCoreData()

function Data:GetPlayerCharacter(source)
    local Players = {}
    local Identifier = GetPlayerIdentifierByType(source, 'license')

    local PlayerData = MySQL.query.await('SELECT * FROM `users`')
    if PlayerData then
        for _, v in ipairs(PlayerData) do
            if string.find(v.identifier, Identifier) then
                if not Players[Identifier] then Players[Identifier] = {} end
                local Data = {
                    name = v.playerName,
                    dob = v.dob,
                    group = v.playerGroup,
                    job = v.JobLabel,
                    sex = v.sex,
                    skin = v.skin,
                    slot = v.charIdentifier,
                    lastcoords = v.lastSpawn,
                    Identifier = v.identifier,
                    status = json.decode(v.status),
                    source = source,
                    accounts = json.decode(v.accounts),
                    JobName = v.JobName,
                    JobGrade = v.JobGrade,
                    JobLabel = v.JobLabel,
                    Height = v.Height,
                }
                table.insert(Players[Identifier], Data)
            end
        end

        table.sort(Players[Identifier], function(a, b)
            return a.slot < b.slot
        end)

        return Players[Identifier]
    else
        return {}
    end
end

lib.callback.register('LGF_OxCharacter:GetPlayerCharacter', function(source)
    -- Shared:DebugPrint(Data:GetPlayerCharacter(source))
    return Data:GetPlayerCharacter(source)
end)

exports('GetCharacters', function(target)
    if not target then return end
    if Legacy.MAIN:IsPlayerOnline(target) then
        return Data:GetPlayerCharacter(target)
    else
        return print(string.format('Player with id %d is not online', target))
    end
end)


lib.callback.register('LGF_OxCharacter:GetPlayerCharacterCount', function(source)
    local Identifier = GetPlayerIdentifierByType(source, 'license')

    local Identifier = Identifier
    local CharacterCount = MySQL.query.await('SELECT * from `users` WHERE `identifier` = ?', {
        Identifier
    })

    return #CharacterCount
end)

local function DeleteCharacter(slot, identifier)
    local source = source
    local identifier = identifier

    if not identifier then
        local noIdentifierMessage = Locale:GetTranslation('no_identifier_found')
        Shared:DebugPrint(string.format(noIdentifierMessage, source))
        return
    end

    local charIdentifier = MySQL.prepare.await(
        'SELECT `identifier` FROM `users` WHERE `charIdentifier` = ? AND `identifier` = ?', { slot, identifier })

    if not charIdentifier or #charIdentifier == 0 then
        local noCharacterMessage = Locale:GetTranslation('no_character_found')
        Shared:DebugPrint(string.format(noCharacterMessage, slot, identifier))
        return
    end

    local result = MySQL.prepare.await('DELETE FROM `users` WHERE `charIdentifier` = ? AND `identifier` = ?',
        { slot, identifier })

    if result then
        local deleteSuccessMessage = Locale:GetTranslation('character_deleted_success')
        Shared:DebugPrint(string.format(deleteSuccessMessage, slot, identifier))
    else
        local deleteFailureMessage = Locale:GetTranslation('character_deleted_failure')
        Shared:DebugPrint(string.format(deleteFailureMessage, slot, identifier))
    end
end

RegisterNetEvent('LGF_OxCharacter:SaveCoords', function(coords, slot)
    local source = source
    local playerIdentifier = GetPlayerIdentifierByType(source, 'license')
    local slotChar = slot
    if slotChar then
        local success = MySQL.update.await('UPDATE users SET lastSpawn = ? WHERE identifier = ? AND charIdentifier = ?',
            {
                json.encode(coords),
                playerIdentifier,
                slotChar
            })

        if success then
            Shared:DebugPrint(string.format('Coordinates successfully saved for slot: %s', slotChar))
        else
            Shared:DebugPrint(string.format('Error saving coordinates for slot: %s', slotChar))
        end
    else
        Shared:DebugPrint(string.format('Error: unable to find slotChar for character: %s', playerIdentifier))
    end
end)


lib.callback.register('LGF_OxCharacter:GetAllCharacters', function()
    local AllData = MySQL.query.await('SELECT * FROM `users`')
    return AllData
end)

RegisterNetEvent('LGF_OxCharacter:Login:DeleteCharacter', function(data)
    DeleteCharacter(data.slot, data.identifier)
end)

exports('DeleteCharacter', function(slot, identifier)
    return DeleteCharacter(slot, identifier)
end)


function GetGroup(src)
    return Legacy.DATA:GetPlayerDataBySlot(src).playerGroup
end

RegisterNetEvent('LGF_OxCharacter:SetPlayerBucket', function()
    local src = source
    SetPlayerRoutingBucket(src, src)
    Shared:DebugPrint(string.format('Player with id %d is in bucket %s', src, src))
    SetRoutingBucketPopulationEnabled(
        src --[[ integer ]],
        false --[[ boolean ]]
    )
end)

RegisterNetEvent('LGF_OxCharacter:ClearPlayerBucket', function()
    local src = source
    local PrefixBucket = Config.PrefixBucket
    SetPlayerRoutingBucket(src, PrefixBucket)
    Shared:DebugPrint(string.format('Player with id %d is returned in bucket %s', src, PrefixBucket))
    SetRoutingBucketPopulationEnabled(
        src --[[ integer ]],
        true --[[ boolean ]]
    )
end)



lib.callback.register('LGF_OxCharacter:GetSkinToAdd', function(source, slot)
    local Identifier = GetPlayerIdentifierByType(source, 'license')
    local allSKin = MySQL.query.await('SELECT * FROM `outfits` WHERE `charIdentifier` = ? AND `identifier` = ? ',
        { slot, Identifier })
    return allSKin
end)
