lib.addCommand(Config.Command.Relog, {
    help = Locale:GetTranslation('relog_help'),
}, function(source, args, raw)
    lib.triggerClientEvent('LGF_OxCharacter:Command:Relog', source)
end)

lib.addCommand(Config.Command.CharPannel, {
    help = Locale:GetTranslation('charpannel_help'),
}, function(source, args, raw)
    local isLoaded = exports.LEGACYCORE:isLoadedServer(source)

    if not isLoaded then
        Shared:DebugPrint(Locale:GetTranslation('not_loaded'))
        return
    end

    local playerGroup = GetGroup(source)
    local AllowedGroup = Config.RestrictionGroup
    if AllowedGroup[playerGroup] then
        lib.triggerClientEvent('LGF_OxCharacter:Command:OpenCharPannel', source)
    else
        local accessDeniedMessage = Locale:GetTranslation('notify_access_denied_message')
        Shared:DebugPrint(string.format(Locale:GetTranslation('access_denied'), source, playerGroup))
        Shared:GetNotify(Locale:GetTranslation('notify_access_denied_title'), accessDeniedMessage, 'error',
            'exclamation-circle', source
        )
    end
end)


lib.addCommand(Config.Command.DeleteChar, {
    help = Locale:GetTranslation('deletechar_help'),
    params = {
        {
            name = 'id',
            type = 'number',
            help = Locale:GetTranslation('deletechar_id_help'),
        },
        {
            name = 'slot',
            type = 'number',
            help = Locale:GetTranslation('deletechar_slot_help'),
        },
    },
}, function(source, args, raw)
    local playerGroup = GetGroup(source)
    local AllowedGroup = Config.RestrictionGroup
    if AllowedGroup[playerGroup] then
        local characterId = args.id
        local slot = tonumber(args.slot)

        if not Legacy.MAIN:IsPlayerOnline(characterId) then
            Shared:GetNotify(Locale:GetTranslation('notify_error_title'),
                string.format(Locale:GetTranslation('notify_no_id_online'), characterId), 'warning', 'exclamation-circle',
                source)
            return
        end

        if characterId and slot then
            local exists = Legacy.DATA:GetCharacterExist(characterId, slot)
            if exists then
                local identifier = Legacy.DATA:GetPlayerDataBySlot(characterId) and
                Legacy.DATA:GetPlayerDataBySlot(characterId).identifier

                if identifier then
                    TriggerEvent('LGF_OxCharacter:Login:DeleteCharacter', { slot = slot, identifier = identifier })
                    Shared:GetNotify(Locale:GetTranslation('notify_success_title'),
                        string.format(Locale:GetTranslation('character_deleted_success'), slot, characterId), 'success',
                        'check-circle', source)
                else
                    Shared:GetNotify(Locale:GetTranslation('notify_error_title'),
                        Locale:GetTranslation('no_identifier_found'), 'error', 'exclamation-circle', source)
                end
            else
                Shared:GetNotify(Locale:GetTranslation('notify_error_title'),
                    string.format(Locale:GetTranslation('no_character_found'), slot, characterId), 'error',
                    'exclamation-circle', source)
            end
        else
            Shared:GetNotify(Locale:GetTranslation('notify_error_title'), Locale:GetTranslation('error_missing_params'),
                'error', 'exclamation-circle', source)
        end
    else
        Shared:GetNotify(Locale:GetTranslation('notify_access_denied_title'),
            Locale:GetTranslation('notify_access_denied_message'), 'error', 'exclamation-circle', source)
    end
end)

lib.addCommand(Config.Command.RelogForced, {
    help = Locale:GetTranslation('relog_help_forced'),
}, function(source, args, raw)
    lib.TriggerClientEvent('LegacyCore:PlayerLogout', source)
end)


if Config.Debug then
    RegisterCommand('getbuck', function(source)
        Shared:DebugPrint('My Bucket: ', GetEntityRoutingBucket(GetPlayerPed(source)))
    end)
end
