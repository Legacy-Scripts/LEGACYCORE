local CINEMATIC_HEIGHT = 0.3
local CINEMATIC_SPEED = 0.01
local isCinematicActive = false
local isCinematicAnimating = false
local currentCinematicHeight = 0.0

local function DisableComponents()
    for i = 0, 22 do
        if IsHudComponentActive(i) then HideHudComponentThisFrame(i) end
    end
end

local function animateCinematic()
    isCinematicAnimating = true

    DisplayRadar(not isCinematicActive)

    local startHeight = currentCinematicHeight
    local endHeight = isCinematicActive and CINEMATIC_HEIGHT or 0.0
    local step = (endHeight > startHeight) and CINEMATIC_SPEED or -CINEMATIC_SPEED

    while math.abs(currentCinematicHeight - endHeight) > 0.01 do
        currentCinematicHeight = currentCinematicHeight + step
        if (step > 0 and currentCinematicHeight > endHeight) or (step < 0 and currentCinematicHeight < endHeight) then
            currentCinematicHeight = endHeight
        end
        Wait(10)
    end

    isCinematicAnimating = false
end


function ToggleCinematic()
    if IsPauseMenuActive() or isCinematicAnimating then return end

    isCinematicActive = not isCinematicActive
    CreateThread(animateCinematic)

    while currentCinematicHeight > 0.0 or isCinematicActive do
        for i = 0.0, 1.0, 1.0 do
            DrawRect(0.5, 0.0, 1.0, currentCinematicHeight, 0, 0, 0, 255) 
            DrawRect(0.5, 1.0, 1.0, currentCinematicHeight, 0, 0, 0, 255)
        end

        DisableComponents()
        Wait(0)
    end
end


function GetCinematicState()
    return isCinematicActive
end


RegisterCommand('cinematic', function()
    ToggleCinematic()
end, false)

