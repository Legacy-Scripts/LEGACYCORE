local Cam = {}
local camera
local Config = require "shared.Config"


function Cam.startCam(entity)
    local coords = GetOffsetFromEntityInWorldCoords(entity, Config.CamParameters.offset, Config.CamParameters.distance,
        Config.CamParameters.height)
    camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(camera, true)
    RenderScriptCams(true, true, 1750, 1, 0)
    SetCamCoord(camera, coords.x, coords.y, coords.z)
    SetCamFov(camera, 38.0)
    SetCamRot(camera, 0.0, 0.0, GetEntityHeading(entity) + Config.CamParameters.rotation)

    ClearFocus()
    SetFocusPosAndVel(coords.x, coords.y, coords.z, 0.0, 0.0, 0.0)
    SetFocusEntity(entity)
    SetFocusEntity(Login.player.vehiclePrev)
    local coords = GetCamCoord(camera)
    TaskLookAtCoord(entity, coords.x, coords.y, coords.z, -1, 1, 1)
    SetCamUseShallowDofMode(camera, true)
    SetCamNearDof(camera, 0.5)
    SetCamFarDof(camera, 42.0)
    SetCamDofStrength(camera, 1.0)
    SetCamDofMaxNearInFocusDistance(camera, 1.0)
    CreateThread(function()
        repeat
            SetUseHiDof()
            Wait(0)
        until not DoesCamExist(camera)
    end)
end



function Cam.CloseCam()
    RenderScriptCams(false, true, 1000, 1, 0)
    DestroyCam(camera, false)
    camera = nil
end

function Cam.GetCam()
    return camera
end

return Cam
