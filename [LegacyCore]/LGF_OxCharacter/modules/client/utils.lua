Utils = {}
local cams = {}
local activeCamIndex = 1
local cam = nil


function Utils:TeleportPlayer(x, y, z, w, Ped)
    print(x, y, z, w)
    SetEntityCoordsNoOffset(Ped, x, y, z, false, false, false, true)
    SetEntityHeading(Ped, w)
end

function Utils:CameraMultichar(slot, datacoords, spawnConfig)
    local entity = Characters[slot]?.ped
    local distance = spawnConfig.DistanceCam
   print()
    local entityCoords = GetOffsetFromEntityInWorldCoords(entity, 0, distance, 0)
    local currentSlot = slot or 1
    local camCoords = datacoords[currentSlot]?.camPos or vector3(entityCoords.x, entityCoords.y, entityCoords.z + (start and 0.0 or 0.90))
    local camRot = datacoords[currentSlot]?.camRot or vector3(-24.0, 0.0, GetEntityHeading(entity) + 180)
    local camZoom = datacoords[currentSlot]?.camZoom or 100.0


    if cams[activeCamIndex] and cams[activeCamIndex].coords == camCoords then
        return
    end


    if cams[activeCamIndex] then
        SetCamActive(cams[activeCamIndex].cam, false)
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(cams[activeCamIndex].cam)
        cams[activeCamIndex] = nil
    end

    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camCoords, camRot, camZoom, false, 1)
    cams[activeCamIndex] = { cam = cam, coords = camCoords }
    if cams[activeCamIndex - 1] then
        SetCamActiveWithInterp(cam, cams[activeCamIndex - 1].cam, 3000, true, true)
    else
        SetCamActive(cam, true)
    end

    RenderScriptCams(true, true, 2500, true, true)
    SetFocusArea(camCoords, 0.0, 0.0, 0.0)
    SetFocusEntity(entity)
    activeCamIndex = activeCamIndex + 1
end

function Utils:DestroyngCamera()
    RenderScriptCams(false, true, 2000, 1, 0)
    DestroyCam(cam, false)
    ClearPedTasks(Legacy.CACHE:GetCache('ped')?.pedId)
    PreviewCam = nil
end

function Utils.requestModel(model, WAIT)
    RequestModel(model)

    while not HasModelLoaded(model) do
        Wait(WAIT)
    end
end

function Utils:SetFreemodeModel(sex)
    local model = sex == "m" and `mp_m_freemode_01` or `mp_f_freemode_01`
    Utils.requestModel(model)
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)

    local playerPed = PlayerPedId()
    SetPedAoBlobRendering(playerPed, true)
    ResetEntityAlpha(playerPed)
    SetEntityVisible(playerPed, true)
    FreezeEntityPosition(playerPed, false)
    SetFocusArea(GetEntityCoords(playerPed), 0.0, 0.0, 0.0)
end

AddEventHandler("onResourceStop", function(resource)
    if cache.resource == resource and DoesCamExist(cam) then
        Utils:DestroyngCamera()
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        Utils:clearPeds()
    end
end)

function Utils:doScreenFade(type, time)
    if type == "in" then
        DoScreenFadeIn(time)
        while not IsScreenFadedIn() do Wait(10) end
    elseif type == "out" then
        DoScreenFadeOut(time)
        while not IsScreenFadedOut() do Wait(10) end
    end
end

function Utils:clearPeds()
    for index, slot in pairs(Characters) do
        if slot.ped and DoesEntityExist(slot.ped) then
            DeleteEntity(slot.ped)
        end
    end
end

function Utils:ResetChar()
    local playerPed = Legacy.CACHE:GetCache('ped').pedId
    SetEntityVisible(playerPed, true)
    FreezeEntityPosition(playerPed, false)
    SetNuiFocus(false, false)
    SetFocusEntity(playerPed)
end

function Utils:PlayAdvancedAnimation(ped, animDict, animName, blendIn, blendOut, duration, playbackRate, loop, onComplete)
    lib.requestAnimDict(animDict, 10000)
    if not HasAnimDictLoaded(animDict) then
        Shared:DebugPrint(string.format("Failed to load animation dictionary %s", animDict))
        return
    end

    ClearPedTasks(ped)

    TaskPlayAnim(ped, animDict, animName, blendIn, blendOut, duration, 1, playbackRate, false, false, false)

    if loop then
        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                if not IsEntityPlayingAnim(ped, animDict, animName, 3) then
                    TaskPlayAnim(ped, animDict, animName, blendIn, blendOut, duration, 1, playbackRate, false, false,
                        false)
                end
            end
        end)
    end

    if duration > 0 then
        Citizen.CreateThread(function()
            Citizen.Wait(duration)
            ClearPedTasks(ped)
            if onComplete then
                onComplete()
            end
        end)
    end
end

-- BY ARS LOGIN
function Utils:charToCreate(table)
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

function Utils:SetPlayerAlpha(slot, alpha)
    for _, char in pairs(Characters) do
        if char.ped then
            if char.slot == slot then
                ResetEntityAlpha(char.ped)
            else
                SetEntityAlpha(char.ped, alpha)
            end
        end
    end
end

function Utils:ToggleRadarMap(state)
    DisplayRadar(state)
end

function Utils:SwitchingCameraSpawn()
    Utils:DestroyngCamera()
    StopPlayerSwitch()
    Utils:doScreenFade('out', 1000)
    if not IsPlayerSwitchInProgress() then
        SwitchToMultiFirstpart(Legacy.CACHE:GetCache('ped')?.pedId, 0, 1)
        Wait(1000)
        Utils:doScreenFade('in', 1000)
        RequestCollisionAtCoord(Config.FirstSpawnAfterCreation.x, Config.FirstSpawnAfterCreation.y,
            Config.FirstSpawnAfterCreation.z)
        RequestCollisionForModel(GetEntityModel(Legacy.CACHE:GetCache('ped')?.pedId))
        RequestAdditionalCollisionAtCoord(Config.FirstSpawnAfterCreation.x, Config.FirstSpawnAfterCreation.y,
            Config.FirstSpawnAfterCreation.z)
        SetEntityCoordsNoOffset(Legacy.CACHE:GetCache('ped')?.pedId, Config.FirstSpawnAfterCreation.x,
            Config.FirstSpawnAfterCreation.y, Config.FirstSpawnAfterCreation.z, false, false, false, true)
        SetEntityHeading(Legacy.CACHE:GetCache('ped')?.pedId, Config.FirstSpawnAfterCreation.w)
        Wait(3500)
        SwitchToMultiSecondpart(Legacy.CACHE:GetCache('ped')?.pedId)
    end
end

return Utils
