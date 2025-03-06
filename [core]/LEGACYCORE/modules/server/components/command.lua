lib.addCommand(Config.Command.CreateVehicle, {
    help = LANG.CoreLang('CreateVehicle_Help'),
    params = {
        {
            name = 'model',
            type = 'string',
            help = LANG.CoreLang('CreateVehicle_Params_Model'),
        }
    },
}, function(source, args, raw)
    local model = args.model
    local payload = msgpack.pack(model)
    local PlayerGroup = Legacy.DATA:GetPlayerGroup(source)
    local GroupData = Config.GroupData.AdminGroup
    if GroupData[PlayerGroup] then
        lib.triggerClientEvent('LegacyCore:DATA:CreateVehicle', source, payload)
    else
        Legacy.MAIN:SendServerNotification(source, LANG.CoreLang('NoPermission_Notification_Title'),
            LANG.CoreLang('NoPermission_Notification_Message'), 'ban',
            5000, 'error')
    end
end)

lib.addCommand(Config.Command.DeleteVehicle, {
    help = LANG.CoreLang('DeleteVehicle_Help'),
    params = {
        {
            name = 'radius',
            type = 'number',
            help = LANG.CoreLang('DeleteVehicle_Params_Radius'),
        }
    },
}, function(source, args, raw)
    local radius = args.radius
    local PlayerGroup = Legacy.DATA:GetPlayerGroup(source)
    local GroupData = Config.GroupData.AdminGroup
    if GroupData[PlayerGroup] then
        lib.triggerClientEvent('LegacyCore:DATA:DeleteVehicleRadius', source, radius)
    else
        Legacy.MAIN:SendServerNotification(source, LANG.CoreLang('NoPermission_Notification_Title'),
            LANG.CoreLang('NoPermission_Notification_Message'), 'ban',
            5000, 'error')
    end
end)

lib.addCommand(Config.Command.TeleportPlayer, {
    help = LANG.CoreLang('TeleportPlayer_Help'),
}, function(source, args, raw)
    local PlayerGroup = Legacy.DATA:GetPlayerGroup(source)
    local GroupData = Config.GroupData.AdminGroup
    if GroupData[PlayerGroup] then
        lib.triggerClientEvent('LegacyCore:DATA:TeleportPlayer', source)
    else
        Legacy.MAIN:SendServerNotification(source, LANG.CoreLang('NoPermission_Notification_Title'),
            LANG.CoreLang('NoPermission_Notification_Message'), 'ban',
            5000, 'error')
    end
end)

lib.addCommand(Config.Command.SkinPlayer, {
    help = LANG.CoreLang('SkinPlayer_Help'),
    params = {
        {
            name = 'playerid',
            type = 'number',
            help = LANG.CoreLang('SkinPlayer_Params_PlayerID'),
            optional = false
        }
    },
}, function(source, args, raw)
    local targetPlayer = args.playerid
    local PlayerGroup = Legacy.DATA:GetPlayerGroup(source)
    local GroupData = Config.GroupData.AdminGroup
    if not targetPlayer then
        return Legacy.MAIN:SendServerNotification(source, LANG.CoreLang('NoID_Notification_Title'),
            LANG.CoreLang('NoID_Notification_Message'), 'ban', 5000,
            'warning')
    end
    if GroupData[PlayerGroup] then
        if not Legacy.MAIN:IsPlayerOnline(targetPlayer) then
            Legacy.MAIN:SendServerNotification(source, LANG.CoreLang('PlayerNotOnline_Notification_Title'),
                LANG.CoreLang('PlayerNotOnline_Notification_Message'):format(targetPlayer), 'info', 5000, 'inform')
            return
        end
        lib.triggerClientEvent('LegacyCore:DATA:StartUpdateAppearance', targetPlayer)
    else
        Legacy.MAIN:SendServerNotification(source, LANG.CoreLang('NoPermission_Notification_Title'),
            LANG.CoreLang('NoPermission_Notification_Message'), 'ban',
            5000, 'error')
    end
end)

lib.addCommand(Config.Command.SetJob, {
    help = LANG.CoreLang('SetJob_Help'),
    params = {
        {
            name = 'playerid',
            type = 'number',
            help = LANG.CoreLang('SetJob_Params_PlayerID'),
            optional = false
        },
        {
            name = 'jobname',
            type = 'string',
            help = LANG.CoreLang('SetJob_Params_JobName'),
            optional = false
        },
        {
            name = 'grade',
            type = 'number',
            help = LANG.CoreLang('SetJob_Params_JobGrade'),
            optional = false
        },
    },
}, function(source, args, raw)
    local targetPlayer = args.playerid
    local jobName = args.jobname
    local jobGrade = args.grade
    local currJob = Legacy.DATA:GetPlayerDataBySlot(targetPlayer)
    local PlayerGroup = Legacy.DATA:GetPlayerGroup(source)
    local GroupData = Config.GroupData.AdminGroup
    local Jobs = require '@LGF_Society.modules.server.jobs'
    if GroupData[PlayerGroup] then
        if not targetPlayer then
            return Legacy.MAIN:SendServerNotification(source, LANG.CoreLang('NoID_Notification_Title'),
                LANG.CoreLang('NoID_Notification_Message'), 'ban', 5000, 'warning')
        end
        if not Legacy.MAIN:IsPlayerOnline(targetPlayer) then
            Legacy.MAIN:SendServerNotification(source, LANG.CoreLang('PlayerNotOnline_Notification_Title'),
                LANG.CoreLang('PlayerNotOnline_Notification_Message'):format(targetPlayer), 'info', 5000, 'inform')
            return
        end
        Jobs:SetPlayerJob(targetPlayer, jobName, jobGrade)
        TriggerEvent('LegacyCore:changeJob', targetPlayer, id, jobName, jobGrade, currJob.JobName, currJob.JobGrade)             
        TriggerClientEvent('LegacyCore:changeJob', targetPlayer, id, jobName, jobGrade, currJob.JobName, currJob.JobGrade)
    else
        Legacy.MAIN:SendServerNotification(source, LANG.CoreLang('NoPermission_Notification_Title'),
            LANG.CoreLang('NoPermission_Notification_Message'), 'ban', 5000, 'error')
    end
end)


lib.addCommand(Config.Command.SetGroup, {
    help = LANG.CoreLang('SetGroup_Help'),
    params = {
        {
            name = 'playerid',
            type = 'number',
            help = LANG.CoreLang('SetGroup_Params_PlayerID'),
            optional = false
        },
        {
            name = 'groupname',
            type = 'string',
            help = LANG.CoreLang('SetGroup_Params_GroupName'),
            optional = false
        }
    },
}, function(source, args, raw)
    local targetPlayer = args.playerid
    local groupName = args.groupname


    local isConsole = (source == 0 or source == nil)
    local hasPermission = isConsole or
    (Legacy.DATA:GetPlayerGroup(source) and Config.GroupData.AdminGroup[Legacy.DATA:GetPlayerGroup(source)])

    if hasPermission then
        if not targetPlayer then
            if not isConsole then
                return Legacy.MAIN:SendServerNotification(source, LANG.CoreLang('NoID_Notification_Title'),
                    LANG.CoreLang('NoID_Notification_Message'), 'ban', 5000, 'warning')
            else
                print(LANG.CoreLang('NoID_Notification_Message'))
                return
            end
        end

        if not Legacy.MAIN:IsPlayerOnline(targetPlayer) then
            if not isConsole then
                Legacy.MAIN:SendServerNotification(source, LANG.CoreLang('PlayerNotOnline_Notification_Title'),
                    LANG.CoreLang('PlayerNotOnline_Notification_Message'):format(targetPlayer), 'info', 5000, 'inform')
            else
                print(LANG.CoreLang('PlayerNotOnline_Notification_Message'):format(targetPlayer))
            end
            return
        end

        local PlayerData = Legacy.DATA:GetPlayerDataBySlot(targetPlayer)
        local PlayerIdentifier = PlayerData.identifier
        local PlayerSlot = Legacy.DATA:GetPlayerCharSlot(targetPlayer)

        MySQL.update('UPDATE users SET playerGroup = ? WHERE identifier = ? AND charIdentifier = ?',
            { groupName, PlayerIdentifier, PlayerSlot },
            function(affectedRows)
                if affectedRows then
                    if Config.EnableDebug then
                        print(("User with ID '%d' group updated to '%s'."):format(targetPlayer, groupName))
                    end
                    if not isConsole then
                        Legacy.MAIN:SendServerNotification(source, LANG.CoreLang('SetGroup_Success_Title'),
                            LANG.CoreLang('SetGroup_Success_Message'):format(targetPlayer, groupName), 'check', 5000,
                            'success')
                    else
                        print(LANG.CoreLang('SetGroup_Success_Message'):format(targetPlayer, groupName))
                    end
                else
                    print(("Failed to update user with ID '%d' group."):format(targetPlayer))
                end
            end
        )
    else
        if not isConsole then
            Legacy.MAIN:SendServerNotification(source, LANG.CoreLang('NoPermission_Notification_Title'),
                LANG.CoreLang('NoPermission_Notification_Message'), 'ban', 5000, 'error')
        else
            print(LANG.CoreLang('NoPermission_Notification_Message'))
        end
    end
end)

lib.addCommand(Config.Command.MyInfo, {
    help = 'Get My Info',

}, function(source, args, raw)
    local PlayerData = Legacy.DATA:GetPlayerDataBySlot(source)
    lib.triggerClientEvent('LegacyCore:PrintPlayerInfo', source, PlayerData)
end)
