function Notification(data)
    local type = data.Type or 'info'
    local message = data.Message
    local duration = data.Duration or 3000
    local title = data.Title or 'LGF HUD'
    local position = data.Position or 'top-right'
    local transition = data.Transition or 'slide-left'

    SendNUIMessage({
        action = 'SendNotification',
        data = {
            type = type,
            message = message,
            duration = duration,
            title = title,
            position = position,
            transition = transition
        }
    })
end


RegisterNetEvent('LGF_HUD:Notify:SendNotification', Notification)

exports('SendNotification', function(data) return Notification(data)end)


RegisterCommand(Config.Command.TestNotify, function(source)
    local transition1 = 'slide-left'
    local transition2 = 'slide-right'
    local duration = 5000

    Notification({
        Type = 'success',
        Message ='Success notification at top-right.Success notification at top-right. Success notification at top-right.',
        Duration = duration,
        Title = 'Success',
        Position = 'top-right',
        Transition = transition1
    })


    Notification({
        Type = 'error',
        Message = 'Error notification at top-right. Error notification at top-right. Error notification at top-right.',
        Duration = duration,
        Title = 'Error',
        Position = 'top-right',
        Transition = transition1
    })


    Notification({
        Type = 'info',
        Message = 'Info notification at top-left. Info notification at top-left Info notification at top-left',
        Duration = duration,
        Title = 'Information',
        Position = 'top-left',
        Transition = transition2
    })


    Notification({
        Type = 'warning',
        Message = 'Warning notification at top-left. Warning notification at top-left. Warning notification at top-left.',
        Duration = duration,
        Title = 'Warning',
        Position = 'top-left',
        Transition = transition2
    })
end, false)
