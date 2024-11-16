Shared = {}

local Context = Lgf:GetContext()

Shared.Notification = function(title, message, position, type, source)
    if Context == "client" then
        if Config.ProviderNotification == "ox_lib" and GetResourceState("ox_lib"):find("start") then
            lib.notify({
                title = title,
                description = message,
                type = type,
                duration = 5000,
                position = position or 'top',
            })
        elseif Config.ProviderNotification == "utility" and GetResourceState("LGF_Utility"):find("start") then
            TriggerEvent('LGF_Utility:SendNotification', {
                id = math.random(111111111, 3333333333),
                title = title,
                message = message,
                icon = type,
                duration = 5000,
                position = 'top-right',
            })
        end
    elseif Context == "server" then
        if Config.ProviderNotification == "ox_lib" and GetResourceState("ox_lib"):find("start") then
            TriggerClientEvent('ox_lib:notify', source, {
                title = title,
                description = message,
                type = type,
                duration = 5000,
                position = position or 'top-right',
            })
        elseif Config.ProviderNotification == "utility" and GetResourceState("LGF_Utility"):find("start") then
            Lgf:TriggerClientEvent('LGF_Utility:SendNotification', source, {
                id = math.random(111111111, 3333333333),
                title = title,
                message = message,
                icon = type,
                duration = 5000,
                position = 'top-right',
            })
        end
    end
end
