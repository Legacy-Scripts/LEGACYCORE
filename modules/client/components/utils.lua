NOTIFY = {}
WEBHOOK = {}
function NOTIFY:SendClientNotification(title, msg, icon, duration, tipo)
    lib.notify({
        title = title or 'Legacy Core',
        description = msg,
        icon = icon,
        duration = duration,
        position = 'top-left',
        type = tipo,
    })
end

