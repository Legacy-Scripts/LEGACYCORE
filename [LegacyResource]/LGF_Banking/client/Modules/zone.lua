local BankingZone = lib.class('BankingZone')
EntityPed = {}
CurrentZone = {}
function BankingZone:constructor(zoneName, zoneData)
    self.zoneName = zoneName
    self.zoneData = zoneData

    self.point = lib.points.new({
        coords = {
            self.zoneData.DataPed.PedPosition.x,
            self.zoneData.DataPed.PedPosition.y,
            self.zoneData.DataPed.PedPosition.z
        },
        distance = 20.0,
    })


    self.point.onEnter = function() self:onEnter() end
    self.point.onExit = function() self:onExit() end
end

function BankingZone:spawnPed()
    local pedModel = self.zoneData.DataPed.PedModel
    lib.requestModel(pedModel, 5000)
    if HasModelLoaded(pedModel) then
        local pedPosition = self.zoneData.DataPed.PedPosition
        local ped = CreatePed(0, pedModel, pedPosition.x, pedPosition.y, pedPosition.z - 1, pedPosition.w, false, true)
        EntityPed[self.zoneName] = ped
        TaskStartScenarioInPlace(ped, self.zoneData.DataPed.PedScenario, 0, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        TaskSetBlockingOfNonTemporaryEvents(ped, true)
        return ped
    end
end

function BankingZone:onEnter()
    self.ped = self:spawnPed()

    exports.ox_target:addLocalEntity(self.ped, {
        {
            icon = 'fa-solid fa-handcuffs',
            label = ("Open %s"):format(self.zoneName),
            onSelect = function(data)
                local CoordsBank = self.zoneData.DataPed.PedPosition
                local PlayerCoords = Lgf.Player:Coords()
                local distance = Vdist(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, CoordsBank.x, CoordsBank.y,
                    CoordsBank.z)
                local maxDistance = 4.0
                if distance <= maxDistance then
                    OpenBankingComplete()
                else
                    print("no!")
                end
            end
        }
    })
end

function BankingZone:onExit()
    if DoesEntityExist(self.ped) then
        DeleteEntity(self.ped)
        EntityPed[self.zoneName] = nil
    end
end

CreateThread(function()
    for zoneName, zoneData in pairs(Config.ZoneBanking) do
        BankingZone:new(zoneName, zoneData)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if cache.resource == resource then
        for zoneName, ped in pairs(EntityPed) do
            if DoesEntityExist(ped) then
                DeleteEntity(ped)
                print('Deleted Ped for zone: ' .. zoneName)
            end
        end
        EntityPed = {}
    end
end)



local PinSetted = false


RegisterNUICallback("LGF_Banking.PinSetted", function(body, resultCallback)
    if body.new == true then
        TriggerServerEvent("LGF_Banking.UpdateDb.Pin.CreateNewPin", body.pin)
        Wait(2000)
        resultCallback(true)
        PinSetted = true
    elseif body.new == false then
        local Pin = Functions.getPlayerPin()
        if Pin == body.pin then
            Wait(2000)
            PinSetted = true
            resultCallback(true)
        else
            Wait(2000)
            Shared.Notification("Failed Login", "The pin Insered is Not Correct!", "top", "error")
            resultCallback(false)
        end
    end
end)

function OpenBankingComplete()
    local isPlayerNew = Lgf:TriggerServerCallback("LGF_Banking.isPlayerNew")
    Nui.openAccessPin(true, isPlayerNew)
    while not PinSetted do Wait(1000) end
    Nui.openAccessPin(false, nil)
    PinSetted = false
    Nui.toggleBanking(true, Data.GetPlayerInfo())
end

exports("openBank", OpenBankingComplete)
