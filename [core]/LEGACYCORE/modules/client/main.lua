Legacy = {
    MAIN = {},
    DATA = {},
    CACHE = {}
}

function Legacy.MAIN:GetID()
    return GetPlayerServerId(NetworkGetPlayerIndexFromPed(PlayerPedId()))
end

function Legacy.MAIN:GetPlayerPed()
    return PlayerPedId()
end

function Legacy.MAIN:TeleportPlayer(x, y, z, w)
    local playerPed = Legacy.MAIN:GetPlayerPed()
    FreezeEntityPosition(playerPed, true)
    StartPlayerTeleport(PlayerId(), x, y, z, w, true, true, false)
    while IsPlayerTeleportActive() do Citizen.Wait(0) end
    SetEntityCollision(playerPed, true, true)
    RequestCollisionAtCoord(x, y, z)
    FreezeEntityPosition(playerPed, false)
end

function Legacy.MAIN:GetPlayerCoords()
    local playerPed = Legacy.MAIN:GetPlayerPed()
    local coords = GetEntityCoords(playerPed)
    local formattedCoords = vec4(coords.x, coords.y, coords.z, GetEntityHeading(playerPed))
    return formattedCoords
end

function Legacy.MAIN:CreateVehicle(data)
    local VEHICLEMODEL = lib.requestModel(data.VehicleModel)
    local VEHICLE = nil
    local success = lib.waitFor(function()
        VEHICLE = CreateVehicle(VEHICLEMODEL, data.Coords.x, data.Coords.y, data.Coords.z, data.Heading, false, true)

        if not DoesEntityExist(VEHICLE) then return false end

        NetworkRegisterEntityAsNetworked(VEHICLE)
        SetVehicleOnGroundProperly(VEHICLE)
        SetEntityAsMissionEntity(VEHICLE, true, true)
        if data.LevelFuel then
            SetVehicleFuelLevel(VEHICLE, data.LevelFuel)
        end
        return NetworkGetNetworkIdFromEntity(VEHICLE) ~= 0
    end, "Timeout during vehicle creation.", 4000)

    if success then
        if data.SetStateBag then Entity(VEHICLE).state.NewVehicle = true end
        Wait(100)
        if data.SetPedIntoVeh and data.SetPedIntoVeh == true then
            TaskWarpPedIntoVehicle(Legacy.MAIN:GetPlayerPed(), VEHICLE, -1)
        end
        print(("Vehicle created successfully. Model: %s"):format(data.VehicleModel))
        if data.AutoDelete and data.AutoDeleteDelay then
            CreateThread(function()
                Wait(data.AutoDeleteDelay)
                if DoesEntityExist(VEHICLE) and IsEntityAVehicle(VEHICLE) then Legacy.MAIN:DeleteVehicle(VEHICLE) end
            end)
        end
    end
end

function Legacy.MAIN:DeleteVehicle(vehicle)
    if not DoesEntityExist(vehicle) or not IsEntityAVehicle(vehicle) then return end
    DeleteEntity(vehicle)
end

function Legacy.MAIN:SendClientNotification(title, msg, icon, duration, tipo)
    lib.notify({
        title = title or 'Legacy Core',
        description = msg,
        icon = icon,
        duration = duration,
        position = 'top-left',
        type = tipo,
    })
end

function Legacy.MAIN.SetPlayerBucket(data)
    local result, current_bucket = lib.callback.await("LegacyCore.setPlayerBucket", 100, data)
    return result, current_bucket
end

function Legacy.MAIN.ToggleDriveBy(enabled)
    if enabled then
        SetPlayerCanDoDriveBy(PlayerId(), true)
    else
        SetPlayerCanDoDriveBy(PlayerId(), false)
    end
end
