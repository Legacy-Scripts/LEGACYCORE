Legacy = {
    MAIN = {},
    DATA = {},
    CACHE = {},
    PLAYERCACHE = {}
}


function Legacy.MAIN:GetID()
    return GetPlayerServerId(NetworkGetPlayerIndexFromPed(cache.ped))
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
    return coords
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
            Citizen.CreateThread(function()
                Citizen.Wait(data.AutoDeleteDelay)
                if DoesEntityExist(VEHICLE) and IsEntityAVehicle(VEHICLE) then Legacy.MAIN:DeleteVehicle(VEHICLE) end
            end)
        end
    else
        print("Vehicle creation failed or timed out.")
    end
end

function Legacy.MAIN:DeleteVehicle(vehicle)
    if not DoesEntityExist(vehicle) or not IsEntityAVehicle(vehicle) then
        print("Invalid vehicle entity provided.")
        return
    end
    DeleteEntity(vehicle)
    print("Vehicle deleted successfully.")
end
