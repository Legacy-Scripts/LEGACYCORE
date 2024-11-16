local HUD_IS_OPEN = true
local isVehicleHudVisible = false
local vehicleThread = nil
local success, Function = pcall(function() return lib.load('client.modules.components.functions') end)
local success, Frame = pcall(function() return lib.load('client.modules.bridge.Framework') end)

function ShowNui(action, Show)
  SetNuiFocus(true, true)
  SendNUIMessage({ action = action, data = Show })
end

function SendNUI(action, data)
  SendNUIMessage({ action = action, data = data })
end

function Notification(data)
  local type = data.Type or 'info'
  local message = data.Message
  local duration = data.Duration or 3000
  local title = data.Title or 'LGF HUD'
  local position = data.Position or 'top-right'
  local transition = data.Transition or 'slide-left'

  SendNUIMessage({
    action = 'SendNotification',
    data = {
      type = type,
      message = message,
      duration = duration,
      title = title,
      position = position,
      transition = transition
    }
  })
end

RegisterNuiCallback('LGF_HUD:UI:CloseHud', function(data, cb)
  if data.name == 'HideHud' then HUD_IS_OPEN = false end
  cb(true)
end)


function GetDirectionText(direction)
  direction = direction % 360
  local directionText
  if direction >= 0 and direction <= 45 or direction > 315 and direction < 360 then
    directionText = 'North'
  elseif direction > 45 and direction <= 90 then
    directionText = 'North-East'
  elseif direction > 90 and direction <= 135 then
    directionText = 'East'
  elseif direction > 135 and direction <= 180 then
    directionText = 'South-East'
  elseif direction > 180 and direction <= 225 then
    directionText = 'South'
  elseif direction > 225 and direction <= 270 then
    directionText = 'South-West'
  elseif direction > 270 and direction <= 315 then
    directionText = 'West'
  end

  return directionText
end

RegisterNuiCallback('LGF_HUD:UI:GetPlayerData', function(data, cb)
  local playerPed = PlayerPedId()
  local playerHealth = GetEntityHealth(playerPed) / 2
  local playerStamina = GetPlayerStamina(PlayerId())
  local playerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(playerPed))
  local playerDirection = GetEntityHeading(playerPed)

  local formattedStamina = string.format("%.0f", playerStamina)
  local formattedThirst = string.format("%.0f", Frame:GetPlayerThirst())
  local formattedHunger = string.format("%.0f", Frame:GetPlayerHunger())

  local IsLoaded = Frame:IsPlayerLoaded()
  local GetCashBank = Frame:GetPlayerBankAmount()

  local responseData = {
    PlayerJob = Frame:GetPlayerJob() or 'Uknown',
    PlayerBank = GetCashBank or 0,
    PlayerID = playerId,
    PlayerHealt = playerHealth,
    PlayerStamina = formattedStamina,
    PlayerThirst = formattedThirst or 100,
    PlayerHunger = formattedHunger or 100,
    Colors = Config.ColorRingProgress,
    StreetName = Function:GetHashKeyStreet(),
    isLoaded = IsLoaded,
    ColorsBadge = Config.BadgeColor,
    StreetPosition = GetDirectionText(playerDirection)
  }

  cb(responseData)
end)


RegisterNuiCallback('GetActionHud', function(data, cb)
  if data.action == 'hideTotalHUD' then
    HUD_IS_OPEN = not HUD_IS_OPEN
    ShowNui('HideHud', HUD_IS_OPEN)

    Notification({
      Type = HUD_IS_OPEN and 'success' or 'warning',
      Message = 'The HUD has been ' ..
      (HUD_IS_OPEN and 'enabled. You can now see all the HUD elements on your screen.' or 'disabled. All HUD elements are now hidden from your screen.'),
      Duration = 5000,
      Title = 'HUD Visibility',
      Position = 'top-left',
      Transition = 'slide-right'
    })
  elseif data.action == 'cinematic' then
    HUD_IS_OPEN = GetCinematicState()
    ShowNui('HideHud', HUD_IS_OPEN)

    ToggleCinematic()
  end
  cb(true)
end)

RegisterCommand(Config.Command.PannelHud, function()
  ShowNui('OpenHudControlPanel', true)
end, false)




lib.onCache('vehicle', function(value)
  local SLEEP = 1000
  if GetCinematicState() then ShowNui('HideVehicleHud', false) end
  if value then
    if not isVehicleHudVisible then
      isVehicleHudVisible = true
      vehicleThread = CreateThread(function()
        while isVehicleHudVisible do
          Wait(SLEEP)
          local Vehicle = cache.vehicle
          if Vehicle then
            local vehicleSpeed = GetEntitySpeed(Vehicle) * 3.6
            local vehicleFuel = GetVehicleFuelLevel(Vehicle)
            local VehicleHealt = GetEntityHealth(Vehicle)
            local engineTemperature = GetVehicleEngineTemperature(Vehicle)
            local vehicleGear = GetVehicleCurrentGear(Vehicle)

            local FormattedVelocity = string.format("%.0f", vehicleSpeed)
            local FormattedFuel = string.format("%.0f", vehicleFuel)
            local FormattedVehicleHealt = string.format("%.0f", VehicleHealt)
            local FormattedEngineTemperature = string.format("%.0f", engineTemperature or 0)

            SendNUIMessage({
              action = 'OpenVehicleHud',
              data = {
                VehicleSpeed = FormattedVelocity,
                VehicleFuel = FormattedFuel,
                VehicleHealth = FormattedVehicleHealt,
                EngineTemperature = FormattedEngineTemperature,
                CurrentVehicleGear = vehicleGear,
                Comp_to_enable = Config.CarHudComponent
              }
            })
          else
            isVehicleHudVisible = false
          end
        end
      end)
    end
  else
    if isVehicleHudVisible then
      isVehicleHudVisible = false
      SendNUIMessage({ action = 'HideVehicleHud' })
    end
  end
end)

RegisterNuiCallback('CloseHudControlPanel', function(data, cb)
  ShowNui('OpenHudControlPanel', false)
  SetNuiFocus(false, false)
  cb(true)
end)

RegisterNuiCallback('GetHudState', function(data, cb)
  cb({
    HUD_IS_OPEN = IsHudOpen(),
    CINEMATIC_MODE = GetCinematicState()
  })
end)

function IsHudOpen()
  return HUD_IS_OPEN
end
