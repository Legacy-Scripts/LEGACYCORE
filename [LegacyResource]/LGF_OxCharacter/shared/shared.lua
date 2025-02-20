Shared = {}
Locale = {}

function Shared:DebugPrint(...)
    if not Config.Debug then return end
    print("[^3DEBUG^7]", ...)
end

function Locale:GetTranslation(key)
    local lang = Config.Locales or 'en'
    local translation = Shared.Locales[lang] and Shared.Locales[lang][key]
    return translation or key
end

function Shared:GetNotify(title,message,type,icon,source)
    if lib.context == 'client' then
        lib.notify({
            title = title,
            description = message,
            type = type,
            duration = 5000,
            position = 'top',
            icon = icon
        })
    elseif lib.context == 'server' then
        TriggerClientEvent('ox_lib:notify', source, {
            title = title,
            description = message,
            type = type,
            duration = 5000,
            position = 'top',
            icon = icon
        })
    end
end
