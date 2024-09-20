local warn = warn
local GetEntityHeading = GetEntityHeading
local DoesEntityExist = DoesEntityExist
local DeleteEntity = DeleteEntity
local GetFirstBlipInfoId = GetFirstBlipInfoId
local GetWaypointBlipEnumId = GetWaypointBlipEnumId
local GetBlipInfoIdCoord = GetBlipInfoIdCoord
local GetHeightmapTopZForPosition = GetHeightmapTopZForPosition
local GetGroundZFor_3dCoord = GetGroundZFor_3dCoord
local FreezeEntityPosition = FreezeEntityPosition
local DoScreenFadeIn = DoScreenFadeIn
local DoScreenFadeOut = DoScreenFadeOut
local Wait = Wait
local SetFocusEntity = SetFocusEntity
local SetFocusArea = SetFocusArea


RegisterNetEvent('LegacyCore:DATA:CreateVehicle', function(payload)
    if not payload then
        warn('Received nil payload')
        return
    end
    local PLY = Legacy.MAIN:GetPlayerPed()
    local MODEL = msgpack.unpack(payload)
    local PLAYERCOORDS = Legacy.MAIN:GetPlayerCoords()
    local HEADING = GetEntityHeading(PLY)
    Legacy.MAIN:CreateVehicle({
        VehicleModel = MODEL,
        Coords = PLAYERCOORDS,
        Heading = HEADING,
        SetStateBag = false,
        SetPedIntoVeh = true,
        AutoDelete = true,
        AutoDeleteDelay = 600000 * 1000,
        -- LevelFuel = 100
    })
end)


RegisterNetEvent('LegacyCore:DATA:DeleteVehicleRadius', function(radius)
    print(radius)
    local playerCoords = Legacy.MAIN:GetPlayerCoords()
    local nearbyVehicles = lib.getNearbyVehicles(playerCoords, radius, true)

    for _, vehicleInfo in pairs(nearbyVehicles) do
        local vehicle = vehicleInfo.vehicle
        if DoesEntityExist(vehicle) then DeleteEntity(vehicle) end
    end
end)

RegisterNetEvent('LegacyCore:DATA:TeleportPlayer', function()
    local playerPed = Legacy.MAIN:GetPlayerPed() or cache.ped
    local waypointBlip = GetFirstBlipInfoId(GetWaypointBlipEnumId())
    if waypointBlip == 0 then
        NOTIFY:SendClientNotification('WARNING', 'Provide A correct waypoint', 'ban', 5000, 'warning')
        return
    end
    DoScreenFadeOut(1000)
    Wait(1000)
    local blipPos = GetBlipInfoIdCoord(waypointBlip)
    local z = GetHeightmapTopZForPosition(blipPos.x, blipPos.y)
    local _, groundZ = GetGroundZFor_3dCoord(blipPos.x, blipPos.y, z, true)
    Legacy.MAIN:TeleportPlayer(blipPos.x, blipPos.y, z, 0.0)
    FreezeEntityPosition(playerPed, true)
    repeat
        Citizen.Wait(50)
        _, groundZ = GetGroundZFor_3dCoord(blipPos.x, blipPos.y, z, true)
    until groundZ ~= 0
    Legacy.MAIN:TeleportPlayer(blipPos.x, blipPos.y, groundZ, 0.0)
    FreezeEntityPosition(playerPed, false)
    SetFocusEntity(playerPed)
    SetFocusArea(blipPos.x, blipPos.y, groundZ)
    Wait(1000)
    DoScreenFadeIn(1000)
end)

RegisterNetEvent('LegacyCore:DATA:StartUpdateAppearance', function()
    local PlayerSlot = exports.LGF_OxCharacter:GetSlotCharacter()
    exports['fivem-appearance']:startPlayerCustomization(function(appearance)
        if appearance then
            TriggerServerEvent('LEGACYCORE:QUERY:UpdateAppearance', appearance, PlayerSlot)
        end
    end)
end)

RegisterNetEvent('LegacyCore:PrintPlayerInfo', function(data)
    if not Legacy.DATA:IsPlayerLoaded() then
        warn('You dont Have Selected Any Character! Player Is Not Loaded')
    elseif not data then
        assert(data, 'Error: No Player Data retrieved.')
    else
        local infoString = string.format(
            "Source: ^6[%s]^7, Name: ^6[%s]^7, Group: ^6[%s]^7, Job: ^6[%s]^7, Slot: ^6[%s]^7, Grade: ^6[%s]^7",
            tostring(cache.serverId),tostring(data.playerName),
            tostring(data.playerGroup),tostring(data.JobLabel),
            tostring(data.charIdentifier),tostring(data.JobGrade)
        )
        print(infoString)
    end
end)
