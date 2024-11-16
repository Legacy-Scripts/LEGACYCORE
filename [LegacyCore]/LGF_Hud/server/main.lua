
RegisterNetEvent('LGF_HUD:Notify:SendNotification', function(data)
    local src = source
    local type = data.Type
    local message = data.Message
    local duration = data.Duration or 3000
    local title = data.Title or 'LGF HUD'
    local position = data.Position or 'top-right'
    local transition = data.Transition or 'slide-left'

    local target = data.Target or src

    lib.TriggerClientEvent('LGF_HUD:Notify:SendNotification', target, {
        Type = type,
        Message = message,
        Duration = duration,
        Title = title,
        Position = position,
        Transition = transition
    })
end)


