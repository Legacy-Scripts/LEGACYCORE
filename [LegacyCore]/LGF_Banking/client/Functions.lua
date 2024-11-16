Functions = {}

function Functions.GetHashKeyStreet(coords)
    local pos = coords
    local street1, street2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local streetName1 = GetStreetNameFromHashKey(street1)
    local streetName2 = GetStreetNameFromHashKey(street2)
    return streetName1 .. (streetName2 ~= "" and " " .. streetName2 or "")
end

function Functions.getPlayerPin()
    return Lgf:TriggerServerCallback("LGF_Banking.GetPlayerPin")
end

function Functions.GetNearbyPlayer()
    local Players = lib.getNearbyPlayers(Lgf.Player:Coords(), 3, true)
    local AllPlayers = {}
    for playerId, v in pairs(Players) do
        local Data = {
            PlayerName = Lgf:TriggerServerCallback("LGF_Banking.GetNearbyPlayerName", playerId),
            PlayerId = playerId
        }
        table.insert(AllPlayers, Data)
    end
    return AllPlayers
end

function Functions.startPlayerAnim(anim, dict, prop)
    local dict = lib.requestAnimDict(dict)
    local success, model = Lgf:RequestEntityModel(prop, 5000)
    if not success then return end
    local Ped = Lgf.Player:Ped()
    local PlayerCoords = GetEntityCoords(Ped)
    TaskPlayAnim(Ped, dict, anim, 2.0, 2.0, -1, 51, 0, false, false, false)
    local props = CreateObject(model, PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 0.2, true, true, true)
    AttachEntityToEntity(props, Ped, GetPedBoneIndex(Ped, 28422), 0.0, -0.03, 0.0, 20.0, -90.0, 0.0, true, true, false,
        true, 1, true)
    return props
end

function Functions.ClearPed()
    if TabletEntity then
        DeleteEntity(TabletEntity)
        ClearPedTasks(Lgf.Player:Ped())
        TabletEntity = nil
    end
end
