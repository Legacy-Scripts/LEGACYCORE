local Functions = {}
local Cam = require "modules.client.cl-cam"
local Config = require "shared.Config"
function Functions.doScreenFade(type, time)
    if type == "in" then
        DoScreenFadeIn(time)
        while not IsScreenFadedIn() do Wait(10) end
    elseif type == "out" then
        DoScreenFadeOut(time)
        while not IsScreenFadedOut() do Wait(10) end
    end
end

function Functions.setPlayerCoords(coords, entity, startCam)
    startCam = startCam or false
    SetEntityCoords(entity, coords.x, coords.y, coords.z, true, false, false, false)
    SetEntityHeading(entity, coords.w or 0.0)

    SetEntityVisible(entity, true)
    FreezeEntityPosition(entity, true)


    if startCam then
        CreateThread(function()
            Wait(1000)
            Cam.startCam(entity)
        end)
    end
end

function Functions.standStill(state, ped)
    TaskStandStill(ped, state and -1 or 1)
end

function Functions.SwitchCam(ped, coords)
    StopPlayerSwitch()
    Functions.doScreenFade("out", 1000)
    if not IsPlayerSwitchInProgress() then
        SwitchToMultiFirstpart(ped, 0, 1)
        Wait(1000)
        Functions.doScreenFade("in", 1000)

        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        RequestCollisionForModel(GetEntityModel(ped))
        RequestAdditionalCollisionAtCoord(coords.x, coords.y, coords.z)

        Functions.setPlayerCoords(coords, ped)

        Wait(2000)

        SwitchToMultiSecondpart(ped)
    end
end

function Functions.createPrevCar(coords)
    local RandomCars = {
        "technical3",
    }

    local vehicleModel = lib.requestModel(Config.EntityPrewiev.Model)
    local vehicle = CreateVehicle(vehicleModel, coords.x, coords.y, coords.z, coords.w or 0.0, false, false)
    SetEntityVisible(vehicle, true)
    SetVehicleOnGroundProperly(vehicle)


    lib.setVehicleProperties(vehicle, {
        plate = "REVORIA",
        color1 = 0,
        color2 = 0
    })


    SetModelAsNoLongerNeeded(vehicleModel)
    return vehicle
end

function Functions.createPrevObj(coords)
    local objectModel = lib.requestModel(Config.EntityPrewiev.Model)
    local object = CreateObject(objectModel, coords.x, coords.y, coords.z, true, true, false)
    SetEntityHeading(object, coords.w)
    SetEntityVisible(object, true)


    SetFocusEntity(object)
    TaskLookAtCoord(PlayerPedId(), coords.x, coords.y, coords.z, -1, 1, 1)

    SetModelAsNoLongerNeeded(objectModel)

    return object
end

function Functions.charToCreate(table)
    local smallest = math.huge
    local foundSmallest = false
    local numbers = {}

    for k, v in pairs(table) do
        local n = tonumber(v)
        if n then
            numbers[n] = true
            if n < smallest then
                smallest = n
                foundSmallest = true
            end
        end
    end

    if not foundSmallest then
        return 1
    end

    if smallest > 1 then
        return 1
    end

    for i = smallest + 1, math.huge do
        if not numbers[i] then
            return i
        end
    end
end

return Functions
