---@class LegacyData : CacheClass
local LegacyData = {}

LegacyData.VehicleCache = nil
LegacyData.PedCache = nil
LegacyData.IsVehicleThreadActive = false
LegacyData.IsPedThreadActive = false

local function PlayerIsInVehicle()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    return vehicle and vehicle ~= 0
end


function LegacyData:StartVehicleThread()
    if not self.IsVehicleThreadActive then
        self.IsVehicleThreadActive = true
        Citizen.CreateThread(function()
            while self.IsVehicleThreadActive do
                Citizen.Wait(1000)
                if PlayerIsInVehicle() then
                    local playerPed = PlayerPedId()
                    local vehicle = GetVehiclePedIsIn(playerPed, false)

                    if vehicle and vehicle ~= 0 then
                        local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                        local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)
                        self.VehicleCache = {
                            name = vehicleName,
                            entity = vehicle,
                            netId = vehicleNetId,
                            model = GetEntityModel(vehicle),
                            speed = GetEntitySpeed(vehicle),
                            plate = GetVehicleNumberPlateText(vehicle),
                            driver = GetPedInVehicleSeat(vehicle, -1),
                            isEngineOn = GetIsVehicleEngineRunning(vehicle),
                            isLocked = IsVehicleSeatFree(vehicle, -1),
                            coords = GetEntityCoords(vehicle)
                        }
                    else
                        self.VehicleCache = nil
                        print("No vehicle found.")
                    end
                else
                    self.VehicleCache = nil
                end
            end
        end)
    end
end

function LegacyData:StartPedThread()
    if not self.IsPedThreadActive then
        self.IsPedThreadActive = true
        Citizen.CreateThread(function()
            while self.IsPedThreadActive do
                Citizen.Wait(1000)
                local playerPed = PlayerPedId()
                if playerPed and playerPed ~= 0 then
                    self.PedCache = {
                        pedId  = playerPed,
                        coords = GetEntityCoords(playerPed),
                        health = GetEntityHealth(playerPed),
                        armor  = GetPedArmour(playerPed),
                        weapon = GetCurrentPedWeapon(playerPed),
                        source = GetPlayerServerId(NetworkGetPlayerIndexFromPed(playerPed))
                    }
                else
                    self.PedCache = nil
                    print("No ped found.")
                end
            end
        end)
    end
end

function LegacyData:StopVehicleThread()
    if self.IsVehicleThreadActive then
        self.IsVehicleThreadActive = false
        self.VehicleCache = nil
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if PlayerIsInVehicle() then
            LegacyData:StartVehicleThread()
        else
            LegacyData:StopVehicleThread()
            LegacyData:StartPedThread()
        end
    end
end)

---@param cacheType string
---@return table Cache

function LegacyData:GetCache(cacheType)
    if cacheType == 'vehicle' then
        return self.VehicleCache
    elseif cacheType == 'ped' then
        return self.PedCache
    else
        print("Unsupported cache type: " .. cacheType)
        return nil
    end
end

function Legacy.CACHE:GetCache(value)
    return LegacyData:GetCache(value)
end
