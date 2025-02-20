Legacy = exports.LEGACYCORE:GetCoreData()

local Functions = require "modules/client/cl-functions"
local Nui = require "modules.client.cl-nui"
local Config = require "shared.Config"
local Cam = require "modules.client.cl-cam"
SlotSelected = nil
---@diagnostic disable: duplicate-set-field

Login = {}

setmetatable(Login, {
    __index = function(table, key)
        return rawget(Login, "_index")[key]
    end
})

mp_m_freemode_01 = `mp_m_freemode_01`
mp_f_freemode_01 = `mp_f_freemode_01`

Login.player = {}
Login.player.characters = {}
Login.player.canRelog = true
Login.player.maxSlots = 3
Login.player.currentSelectedChar = {}
Login.player.entityPrev = nil
Login.player.scenario = "WORLD_HUMAN_COP_IDLES"

CreateThread(function()
    while true do
        Wait(100)

        if NetworkIsPlayerActive(PlayerId()) then
            exports["spawnmanager"]:setAutoSpawn(false)

            Functions.doScreenFade("out", 1000)
            ShutdownLoadingScreen()
            ShutdownLoadingScreenNui()
            Login:InitializeData()
            TriggerEvent('LegacyCore:PlayerLogout')
            break
        end
    end
end)

local function isPedFreemodeModel(ped)
    local model = GetEntityModel(ped)
    return model == `mp_m_freemode_01` or model == `mp_f_freemode_01`
end


RegisterNUICallback("Revoria_Multicharacter.confirmCharacterCreation", function(data, resultCallback)
    local CharacterSex = data.sex
    local CharacterHeight = data.height
    local CharacterName = ("%s %s"):format(data.firstName, data.lastName)
    local CharacterDob = data.age
    local Model = nil

    if CharacterSex == "m" then
        Model = mp_m_freemode_01
    else
        Model = mp_f_freemode_01
    end

    Nui.ShowNui("openMultichar", {
        Visible = false,
        Characters = Login.player.characters
    })

    Wait(200)

    Nui.ShowNui("openIdentity", { Visible = false })

    Wait(400)

    SlotSelected = Functions.charToCreate(AllSlots)

    lib.requestModel(Model)

    exports['fivem-appearance']:setPlayerModel(Model)
    Wait(359)
    if isPedFreemodeModel(cache.ped) then
        SetPedDefaultComponentVariation(cache.ped)

        if Model == mp_m_freemode_01 then
            SetPedHeadBlendData(cache.ped, 0, 0, 0, 0, 0, 0, 0, 0, 0, false)
        elseif Model == mp_f_freemode_01 then
            SetPedHeadBlendData(cache.ped, 45, 21, 0, 20, 15, 0, 0.3, 0.1, 0, false)
        end
    end

    exports['fivem-appearance']:startPlayerCustomization(function(appearance)
        if appearance then
            lib.callback.await("Revoria_Multicharacter.CreateNewChar", false, {
                Sex = CharacterSex,
                Height = CharacterHeight,
                Name = CharacterName,
                Dob = CharacterDob,
                Appearance = json.encode(appearance),
                CharIdentifier = SlotSelected,
            })

            Functions.SwitchCam(PlayerPedId(), Config.FirstSpawnNewCharacter)

            Login:clearData(true)
            local MaxHealt = GetEntityMaxHealth(PlayerPedId())
            SetEntityHeading(PlayerPedId(), MaxHealt)
            if GetResourceState("LGF_StarterPack"):find("start") then
                Wait(6500)
                exports.LGF_StarterPack:handleStarterPack({
                    UseConfigCards = true,
                    Display = true
                })
            end
        else
            Login:InitializeData()
        end
    end)

    resultCallback(true)
end)

AllSlots = {}

function Login:InitializeData()
    Login:clearData(true)
    Functions.doScreenFade("out", 1000)

    Login.player.characters = lib.callback.await("Revoria_Multicharacter.GetCharacters", false)

    lib.callback.await("Revoria_Multicharacter.SetBucket", false, cache.serverId)

    for _, character in ipairs(Login.player.characters) do
        AllSlots[#AllSlots + 1] = character.charIdentifier
    end

    DisplayRadar(false)

    if not next(Login.player.characters) then
        Nui.ShowNui("openIdentity", { Visible = true })
        Functions.setPlayerCoords(Config.StartCreationCharacter, PlayerPedId(), true)
        SetEntityVisible(PlayerPedId(), false)
        Functions.doScreenFade("in", 1400)
        return
    end

    lib.requestModel(mp_m_freemode_01)
    lib.requestModel(mp_f_freemode_01)


    if Login.player.characters[1].skin then
        exports['fivem-appearance']:setPlayerAppearance(json.decode(Login.player.characters[1].skin))
    end

    if Config.EntityPrewiev.EnablespawnEntity then
        if Config.EntityPrewiev.EnablespawnEntity == "vehicle" then
            Login.player.entityPrev = Functions.createPrevCar(Config.EntityPrewiev.EntityCoordSpawn)
        elseif Config.EntityPrewiev.EnablespawnEntity == "object" then
            Login.player.entityPrev = Functions.createPrevObj(Config.EntityPrewiev.EntityCoordSpawn)
        end
    end

    Functions.setPlayerCoords(Config.SelectCharacter, PlayerPedId(), true)
    TaskStartScenarioInPlace(PlayerPedId(), Login.player.scenario, 0, true)

    Wait(1400)
    Functions.doScreenFade("in", 1400)


    Nui.ShowNui("openMultichar", {
        Visible = true,
        Characters = Login.player.characters
    })
    ClearFocus()
end

RegisterNUICallback("RevoriaMultichar.NUI.SelectedCharacter", function(data, cb)
    Login.player.currentSelectedChar = data

    if Login.player.currentSelectedChar.skin then
        exports['fivem-appearance']:setPlayerAppearance(json.decode(Login.player.currentSelectedChar.skin))
        Functions.standStill(true, PlayerPedId())
        Cam.startCam(PlayerPedId())
        TaskStartScenarioInPlace(PlayerPedId(), Login.player.scenario, 0, true)
    end

    cb(true)
end)



function Login.loadChar(data)
    if not data then return end
    SlotSelected = data.charIdentifier
    local Coords = json.decode(data.lastcoords)
    if not Coords then Coords = Config.FirstSpawnNewCharacter end

    Nui.ShowNui("openMultichar", {
        Visible = false,
        Characters = Login.player.characters
    })

    if Cam.GetCam() then
        Cam.CloseCam()
    end

    Functions.SwitchCam(PlayerPedId(), Coords)
    local maxH = GetEntityMaxHealth(PlayerPedId())

    SetEntityHealth(PlayerPedId(), maxH)

    TriggerEvent('LegacyCore:PlayerLoaded', SlotSelected, data, false)
    TriggerServerEvent('LegacyCore:PlayerLoaded', SlotSelected, data, false)
    lib.callback.await("Revoria_Multicharacter.SetBucket", false, 0)


    Login:clearData(true)
end

RegisterNUICallback("RevoriaMultichar.NUI.handleAction", function(data, cb)
    local Action = data.action
    local Character = data.character
    if Action == "play" then
        Login.loadChar(Character)
    elseif Action == "delete" then
        local success = lib.callback.await("Revoria_Multicharacter.DeleteChar", false, data.character.charIdentifier)
        if success then
            Nui.ShowNui("openMultichar", {
                Visible = false,
                Characters = Login.player.characters
            })
            Login:InitializeData()
        end
    elseif Action == "createChar" then
        if LocalPlayer.state.identityBusy then
            SendNUIMessage({ action = "openIdentity", data = { Visible = false } })
            LocalPlayer.state.identityBusy = false
            return
        end

        SendNUIMessage({ action = "openIdentity", data = { Visible = true } })
        LocalPlayer.state.identityBusy = true
    end

    cb(true)
end)



function Login:clearData(clearPed)
    clearPed = clearPed or false
    Login.player.characters = {}
    Login.player.currentSelectedChar = {}
    Login.player.canRelog = true

    if clearPed then
        local Ped = PlayerPedId()

        Functions.standStill(false, Ped)

        if IsEntityPositionFrozen(Ped) then
            FreezeEntityPosition(Ped, false)
        end

        local playerCoords = GetEntityCoords(Ped)
        ClearFocus()
        SetFocusArea(playerCoords.x, playerCoords.y, playerCoords.z, 0.0, 0.0, 0.0)
        ClearPedTasksImmediately(Ped)
        SetEntityVisible(Ped, true)

        SetPlayerControl(Ped, true)
    end

    if Login.player.entityPrev then
        DeleteEntity(Login.player.entityPrev)
    end
end

function Login:saveCoords()
    lib.callback.await("Revoria_Multicharacter.saveCoords", false, GetEntityCoords(PlayerPedId()), SlotSelected)
end

exports("saveCharCoords", function()
    return Login:saveCoords()
end)

RegisterNetEvent('RevoriaMultichar:playerLogout', function()
    if Login.player.canRelog and not LocalPlayer.state.multicharBusy and not LocalPlayer.state.dead then
        Login.player.canRelog = false

        Login:saveCoords()
        TriggerEvent('LegacyCore:PlayerLogout')
        Functions.doScreenFade("out", 1000)
        Login:InitializeData()

        SetTimeout(10000, function()
            Login.player.canRelog = true
        end)
    else
        print("You can not Relog Now!")
    end
end)


AddEventHandler("onResourceStop", function(resource)
    if cache.resource == resource then
        if Login.player.entityPrev then
            DeleteEntity(Login.player.entityPrev)
        end
    end
end)
