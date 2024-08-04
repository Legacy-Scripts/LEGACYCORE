NOTIFY = {}
UTILS = {}
local eventWhitelist = {}




function NOTIFY:SendServerNotification(source, title, msg, icon, duration, tipo)
    TriggerClientEvent('ox_lib:notify', source, {
        title = title or 'Legacy Core',
        description = msg,
        icon = icon,
        duration = duration,
        position = 'top-left',
        type = tipo,
    })
end

-- Load event  Whitelisted
local function LoadEventWhitelist()
    local SHARED = require 'modules.shared.shared_functions'
    local file = LoadResourceFile(GetCurrentResourceName(), 'eventWhitelist.json')
    if file then
        local data = json.decode(file)
        if data and data.events then
            eventWhitelist = data.events
            SHARED.DebugData(('Whitelisted events loaded successfully. Total events: %d'):format(#eventWhitelist))
        else
            SHARED.DebugData('Error: Invalid JSON format or missing events array.')
        end
    else
        SHARED.DebugData('Error: Unable to load eventWhitelist.json.')
    end
end

-- Load Event on Resource Start
AddEventHandler('onServerResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then LoadEventWhitelist() end
end)

-- Function to check if event is Authorized
function UTILS:IsEventAuthorized(eventName)
    for _, allowedEvent in ipairs(eventWhitelist) do
        if allowedEvent == eventName then return true end
    end
    return false
end

local function initializeCoreGroups()
    local coreGroups = {}
    for _, groupName in ipairs(Config.GroupData.GroupCore) do
        table.insert(coreGroups, groupName)
    end
    Config.GroupData.CoreGroups = coreGroups
end

Citizen.CreateThreadNow(function()
    initializeCoreGroups()
end)


function UTILS:CreateNewEmbed(webhookURL, embedData)
    PerformHttpRequest(webhookURL, function(statusCode, response, headers)
        if statusCode == 204 then
            print("Webhook sent successfully!")
        else
            print("Failed to send webhook. Status code: " .. statusCode)
            print(response)
        end
    end, 'POST', json.encode(embedData), { ['Content-Type'] = 'application/json' })
end

RegisterNetEvent('Legacy:DATA:SendWebhook', function(webhookURL, embedData)
    UTILS:CreateNewEmbed(webhookURL, embedData)
end)


local function CheckForIncompatibleResources()
    local stateHipster = GetResourceState("fivem-map-hipster")
    if stateHipster == "started" or stateHipster == "starting" then
        print(string.format("^1[ERROR] 'fivem-map-hipster' is currently %s. This resource conflicts with LegacyCore and must be removed.^0", stateHipster))
        StopResource('fivem-map-hipster')
    end

    local stateSkater = GetResourceState("fivem-map-skater")
    if stateSkater == "started" or stateSkater == "starting" then
        print(string.format("^1[ERROR] 'fivem-map-skater' is currently %s. This resource conflicts with LegacyCore and must be removed.^0", stateSkater))
        StopResource('fivem-map-skater')
    end

    local stateRedm = GetResourceState("redm-map-one")
    if stateRedm == "started" or stateRedm == "starting" then
        print(string.format("^1[ERROR] 'redm-map-one' is currently %s. This resource conflicts with LegacyCore and must be removed.^0", stateRedm))
        StopResource('redm-map-one')
    end
end

local timer = lib.timer(10000, function()
    CheckForIncompatibleResources()
end)




