local LOG = {}




function LOG:GetCharacterList()
    local AllChar = lib.callback.await('LGF_OxCharacter:GetAllCharacters', 100)
    return AllChar
end

local actions = {
    { value = 'delete', label = 'Delete Character' }
}

function LOG:HandleCharacterAction(CharData)
    local input = lib.inputDialog('Character Action', {
        { type = 'select', label = 'Choose an action', options = actions }
    })

    if not input then return end

    local action = input[1]

    if action == 'delete' then
        local passwordInput = lib.inputDialog('Enter Password', {
            { type = 'input', label = 'Enter Password to Confirm', required = true, password = true }
        })

        if not passwordInput then return end

        local inputPassword = passwordInput[1]
        local correctPassword = GetConvar('LGF_OxCharacter:password:DeleteChar', 'ciaociao')

        if inputPassword == correctPassword then
            TriggerServerEvent('LGF_OxCharacter:Login:DeleteCharacter', {
                slot = CharData.charIdentifier,
                identifier = CharData.identifier
            })
            Shared:DebugPrint("Character deleted: " .. CharData.playerName)
        else
            Shared:DebugPrint("Password is not correct.")
        end
    else
        Shared:DebugPrint("Deletion confirmation failed or incorrect input.")
    end
end

function LOG:CreateCharacterMenu()
    local AllCharacters = LOG:GetCharacterList()
    local options = {}
    for I = 1, #AllCharacters do
        local CharData = AllCharacters[I]
        local icon, iconColor

        if CharData.sex == 'f' then
            icon = 'mars'
            iconColor = '#f06595'
        elseif CharData.sex == 'm' then
            icon = 'venus'
            iconColor = '#22b8cf'
        else
            icon = 'user'
        end


        table.insert(options, {
            title = CharData.playerName,
            description = string.format("Group: %s\nIdentifier: %s\nSlot: %d",
                CharData.playerGroup,
                CharData.identifier,
                CharData.charIdentifier),
            icon = icon,
            iconColor = iconColor,
            onSelect = function()
                LOG:HandleCharacterAction(CharData)
            end
        })
    end


    lib.registerContext({
        id = 'all_character_list',
        title = 'Character List',
        options = options
    })
    lib.showContext('all_character_list')
end

RegisterNetEvent('LGF_OxCharacter:Command:OpenCharPannel', function()
    if lib.getOpenContextMenu() then
        lib.hideContext(false)
    end
    LOG:CreateCharacterMenu()
end)


return LOG
