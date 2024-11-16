local FN = {}
local CAN_RELOG = false
AllSlots = {}
local Model = { 'mp_m_freemode_01', 'mp_f_freemode_01' }
StateLogin = LocalPlayer.state
Legacy = exports.LEGACYCORE:GetCoreData()
_G.PlayerIsNew = false
local SpawnCoords = nil
Characters = {}

function FN:StartThread()
    while true do
        Wait(100)
        if NetworkIsPlayerActive(PlayerId()) then
            exports["spawnmanager"]:setAutoSpawn(false)
            Utils:doScreenFade('out', 1000)
            Wait(100)
            ShutdownLoadingScreen()
            ShutdownLoadingScreenNui()
            FN:OpenMainMenu()
            Utils:doScreenFade('in', 1000)
            TriggerEvent('LegacyCore:PlayerLogout')
            break
        end
    end
end

CreateThread(FN.StartThread)

function FN:OpenMainMenu()
    TriggerServerEvent('LGF_OxCharacter:SetPlayerBucket')
    Utils:ToggleRadarMap(false)
    local CharacterCount = lib.callback.await('LGF_OxCharacter:GetPlayerCharacterCount', 100)
    Shared:DebugPrint(json.encode(CharacterCount))

    if CharacterCount <= 0 then
        for k, v in pairs(Config.SpawnSelector) do
            SpawnCoords = v.PositionSpawn
        end

        Utils:TeleportPlayer(SpawnCoords.x, SpawnCoords.y, SpawnCoords.z, SpawnCoords.w, PlayerPedId())
        Utils:doScreenFade('in', 1000)

        Utils:SetFreemodeModel(Model[1])
        SetEntityVisible(PlayerPedId(), true)
        FN:CreateNewCharacter()
        return
    end

    local CharacterData = lib.callback.await('LGF_OxCharacter:GetPlayerCharacter', 100)
    local maxSlots = Config.MaxCharacter
    local playerLicense = assert(CharacterData[1] and CharacterData[1].Identifier or
        'Error: Missing identifier in CharacterData[1]')

    playerLicense = playerLicense:gsub("license:", "")

    Shared:DebugPrint(string.format("Player License from Data: %s", playerLicense))

    for _, slotConfig in ipairs(Config.SlotForPlayer) do
        Shared:DebugPrint(string.format("Checking Slot Config - License: %s, MaxSlot: %d", slotConfig.License,
            slotConfig.MaxSlot))
        if slotConfig.License == playerLicense then
            maxSlots = slotConfig.MaxSlot
            break
        end
    end

    Shared:DebugPrint(string.format("Max Slots Available: %d", maxSlots))

    local spawnKeys = {}
    for key in pairs(Config.SpawnCharacterPosition) do table.insert(spawnKeys, key) end
    local randomIndex = math.random(#spawnKeys)
    local randomKey = spawnKeys[randomIndex]
    local spawnConfig = Config.SpawnCharacterPosition[randomKey]
    local SpawnChar = spawnConfig.SpawnChar

    Utils:TeleportPlayer(SpawnChar[1].x, SpawnChar[1].y, SpawnChar[1].z, SpawnChar[1].w, PlayerPedId())
    SetEntityVisible(PlayerPedId(), false)
    FreezeEntityPosition(PlayerPedId(), true)

    Characters = {}
    AllSlots = {}

    for A = 1, #CharacterData do
        if A > maxSlots then break end
        local DataChar = CharacterData[A]
        Characters[DataChar.slot] = DataChar

        local SkinData = json.decode(DataChar.skin)
        local ModelHash = SkinData.model

        print(json.encode(SkinData, { indent = true }))
        print(ModelHash)
        lib.requestModel(ModelHash)
        local Player = CreatePed(4, ModelHash, SpawnChar[A], false, false)
        Characters[DataChar.slot].ped = Player

        -- exports['LGF_appearance']:LoadCharacterSkin(Player, SkinData)
        FreezeEntityPosition(Player)
        TriggerEvent('ox_character:LoadAppearance', Player, SkinData)
        AllSlots[#AllSlots + 1] = DataChar.slot
    end



    local SlotBase = Legacy.DATA:GetFirstCharSlot()
    Shared:DebugPrint(string.format("First Slot Available: %d", SlotBase))
    Wait(1000)
    Utils:CameraMultichar(SlotBase, SpawnChar, spawnConfig)
    Utils:SetPlayerAlpha(SlotBase, 130)

    local existingCharacterCount = #CharacterData

    StateLogin:set('PlayerLogged', { StateLogin = true }, true)
    Shared:DebugPrint(LocalPlayer.state.PlayerLogged.StateLogin)
    lib.registerContext({
        id = 'main_menu',
        title = Locale:GetTranslation('context_title'),
        canClose = false,

        options = {
            {
                title = Locale:GetTranslation('select_character_title'),
                description = Locale:GetTranslation('select_character_description'),
                icon = 'floppy-disk',
                iconColor = 'white',
                arrow = true,
                onSelect = function()
                    FN:OpenCharacterMenu(spawnConfig, SpawnChar)
                end
            },
            {
                title = Locale:GetTranslation('create_character_title'),
                description = Locale:GetTranslation('create_character_description'),
                icon = 'plus',
                iconColor = 'white',
                arrow = true,
                onSelect = function()
                    if existingCharacterCount < maxSlots then
                        FN:CreateNewCharacter(CharacterData[1].Identifier)
                    else
                        local Peppe = lib.alertDialog({
                            header = Locale:GetTranslation('character_limit_reached_title'),
                            content = Locale:GetTranslation('character_limit_reached_message'),
                            centered = true,
                            cancel = false
                        })
                        if Peppe == 'confirm' then lib.showContext('main_menu') end
                    end
                end
            },
        }
    })

    lib.showContext('main_menu')
end

function FN:OpenCharacterMenu(spawnConfig, spawnChar)
    local CharacterData = Characters
    local icon, iconColor
    local options = {}

    if CharacterData then
        for k, v in pairs(CharacterData) do
            local character = v

            if character.sex == 'f' then
                icon = 'mars'
                iconColor = '#f06595'
            elseif character.sex == 'm' then
                icon = 'venus'
                iconColor = '#22b8cf'
            else
                icon = 'user'
                iconColor = '#6c757d'
            end


            local hungerProgress = character.status.hunger
            local thirstProgress = character.status.thirst


            local function getProgressColor(value)
                if value <= 20 then
                    return 'red'
                elseif value <= 60 then
                    return 'yellow'
                else
                    return 'green'
                end
            end

            local hungerColor = getProgressColor(hungerProgress)
            local thirstColor = getProgressColor(thirstProgress)

            local description = string.format("%s\n%s", Locale:GetTranslation('character_job') .. ": " .. character.job,
                Locale:GetTranslation('character_group') .. ": " .. character.group)
            local metadata = {
                {
                    label = Locale:GetTranslation('status_hunger'),
                    value = string.format("%.2f%%", hungerProgress),
                    progress = hungerProgress,
                    colorScheme = hungerColor
                },
                {
                    label = Locale:GetTranslation('status_thirst'),
                    value = string.format("%.2f%%", thirstProgress),
                    progress = thirstProgress,
                    colorScheme = thirstColor
                },
                {
                    label = Locale:GetTranslation('status_bank'),
                    value = string.format("$%s", character.accounts.Bank or "0")
                },
                {
                    label = Locale:GetTranslation('slot_label'),
                    value = string.format("(%s)", character.slot or "0")
                },
                {
                    label = Locale:GetTranslation('character_sex'),
                    value = (character.sex == 'f' and Locale:GetTranslation('sex_female') or Locale:GetTranslation('sex_male'))
                }
            }

            table.insert(options, {
                title = string.format('%s', character.name),
                description = description,
                icon = icon,
                iconColor = iconColor,
                metadata = metadata,
                arrow = true,
                onSelect = function()
                    FN:OpenCharacterActionsMenu(character)
                    Utils:CameraMultichar(character.slot, spawnChar, spawnConfig)
                    Utils:SetPlayerAlpha(character.slot, 130)

                    local animations = Config.RandomAnimation[character.sex] or {}
                    if #animations > 0 then
                        local randomIndex = math.random(1, #animations)
                        local selectedAnim = animations[randomIndex]
                        Wait(2000)
                        Utils:PlayAdvancedAnimation(Characters[character.slot].ped, selectedAnim.animDict,
                            selectedAnim.animName, 8.0, 8.0, selectedAnim.animTime, 1.0, false,
                            function()
                                ClearPedTasks(Characters[character.slot].ped)
                            end
                        )
                    else
                        Shared:DebugPrint("No animations available for sex: " .. character.sex)
                    end
                end
            })
        end


        lib.registerContext({
            id = 'character_menu',
            title = Locale:GetTranslation('select_character_title'),
            menu = 'main_menu',
            canClose = false,
            options = options
        })

        lib.showContext('character_menu')
    else
        Shared:DebugPrint("No character data found.")
    end
end

function FN:OpenCharacterActionsMenu(character)
    local DeleteCharacterPlayer = Config.PlayerCanDeleteChar

    lib.registerContext({
        id = 'character_actions_menu',
        title = character.name,
        canClose = false,
        menu = 'character_menu',
        options = {
            {
                title = Locale:GetTranslation('play_character_title'),
                description = Locale:GetTranslation('play_character_description'),
                icon = 'play',
                iconColor = 'white',
                arrow = true,
                onSelect = function()
                    Utils:DestroyngCamera()
                    SlotSelected = character.slot
                    local Skin = json.decode(character.skin)
                    local SpawnCoords = json.decode(character.lastcoords) or {}

                    if not (SpawnCoords and SpawnCoords.x and SpawnCoords.y and SpawnCoords.z) then
                        SpawnCoords = Config.FallBackSpawn
                    end

                    if SpawnCoords and SpawnCoords.x and SpawnCoords.y and SpawnCoords.z then
                        local x, y, z, w

                        if type(SpawnCoords) == 'table' and SpawnCoords.x and SpawnCoords.y and SpawnCoords.z then
                            x, y, z, w = SpawnCoords.x, SpawnCoords.y, SpawnCoords.z, SpawnCoords.w or 0
                        else
                            x, y, z, w = Config.FallBackSpawn.x, Config.FallBackSpawn.y, Config.FallBackSpawn.z,
                                Config.FallBackSpawn.w or 0
                        end

                        Utils:doScreenFade('out', 1000)
                        Utils:TeleportPlayer(x, y, z, w, PlayerPedId())

                        local Reverted = {
                            playerName = character.name,
                            skin = character.skin,
                            lastcoords = character.lastcoords or json.encode({ x = 0, y = 0, z = 0 }),
                            sex = character.sex,
                            dob = character.dob,
                            accounts = character.accounts,
                            playerGroup = character.group,
                            charIdentifier = tostring(SlotSelected),
                            source = character.source,
                            identifier = character.Identifier,
                            status = character.status,
                            JobName = character.JobName,
                            ped = character.ped,
                            JobGrade = character.JobGrade,
                            height = character.height,
                            JobLabel = character.JobLabel
                        }

                        TriggerEvent('LegacyCore:PlayerLoaded', SlotSelected, Reverted, false)
                        TriggerServerEvent('LegacyCore:PlayerLoaded', SlotSelected, Reverted, false)

                        print('cazzo dimodel', Skin.model)
                        local modello = lib.requestModel(Skin.model)
                        SetPlayerModel(cache.playerId, modello)
                        SetEntityVisible(PlayerPedId(), true)
                        TriggerEvent('ox_character:LoadAppearance', PlayerPedId(), Skin)
                        Utils:ToggleRadarMap(true)
                        Utils:clearPeds()
                        Wait(1000)
                        StateLogin:set('PlayerLogged', { StateLogin = false }, true)
                        Utils:ResetChar()
                        Wait(1000)
                        Utils:doScreenFade('in', 1000)
                        TriggerServerEvent('LGF_OxCharacter:ClearPlayerBucket')
                        if GetResourceState("LGF_LobbySystem"):find("start") then
                            exports["LGF_LobbySystem"]:OpenLobbyPanel(true)
                        end
                    else
                        Shared:DebugPrint("Invalid spawn coordinates.")
                    end
                end
            },
            {
                title = Locale:GetTranslation('delete_character_title'),
                description = Locale:GetTranslation('delete_character_description'),
                disabled = not DeleteCharacterPlayer,
                icon = 'delete-left',
                iconColor = 'white',
                arrow = true,
                onSelect = function()
                    Shared:DebugPrint(Locale:GetTranslation('deleting_character') .. character.name)
                    SLot_To_Delete = character.slot
                    FN:AllertCharacterDeleting(SLot_To_Delete, character)
                end
            },
            {
                title = 'Open Wardrobe',
                description = 'Open Wardrobe and change your outfit',
                icon = 'delete-left',
                iconColor = 'white',
                arrow = true,
                onSelect = function()
                    openWardrobePlayer(character)
                end
            },
        }
    })

    lib.showContext('character_actions_menu')
end

RegisterNetEvent('ox_character:LoadAppearance', function(ped, skin)
    local Ped = ped
    print('arriva', json.encode(skin))
    -- exports['LGF_appearance']:LoadCharacterSkin(Ped, skin)
    exports["fivem-appearance"]:setPedAppearance(Ped, skin)
end)

function openWardrobePlayer(character)
    local SkinInsert = {}
    local CharSLot = character.slot
    local AllPlayerSkin = lib.callback.await('LGF_OxCharacter:GetSkinToAdd', 100, CharSLot)

    for i = 1, #AllPlayerSkin do
        local v = AllPlayerSkin[i]
        table.insert(SkinInsert, {
            title = string.format('%s', v.name),
            icon = 'shirt',
            iconColor = 'clay',
            arrow = false,
            onSelect = function()
                exports['fivem-appearance']:setPedComponents(character.ped, json.decode(v.components))
                exports['fivem-appearance']:setPedProps(character.ped, json.decode(v.props))
                openWardrobePlayer(character)
            end
        })
    end

    lib.registerContext({
        id = 'characters_personal_outfit',
        title = 'My Outfit',
        canClose = false,
        menu = 'character_actions_menu',
        options = SkinInsert
    })
    lib.showContext('characters_personal_outfit')
end

local function formatCharacterInfo(character)
    return string.format(
        "**%s:** %s  \n**%s:** %s  \n**%s:** %s  \n**%s:** %s  \n**%s:** %s  \n**%s:** %s",
        Locale:GetTranslation('player_name_label'), character.name,
        Locale:GetTranslation('job_label'), character.job,
        Locale:GetTranslation('group_label'), character.group,
        Locale:GetTranslation('sex_label'), character.sex,
        Locale:GetTranslation('slot_label'), character.slot,
        Locale:GetTranslation('dob_label'), character.dob
    )
end





function FN:AllertCharacterDeleting(Slot_To_Delete, character)
    local formattedInfo = formatCharacterInfo(character)
    local DeletingAlert = lib.alertDialog({
        header = Locale:GetTranslation('delete_character_confirmation_title'),
        content = formattedInfo,
        centered = true,
        cancel = true
    })

    if DeletingAlert == 'cancel' then
        lib.showContext('character_menu')
    else
        TriggerServerEvent('LGF_OxCharacter:Login:DeleteCharacter', {
            slot = Slot_To_Delete,
            identifier = character.Identifier
        })
        Utils:doScreenFade('out', 1000)
        Wait(1000)
        FN:OpenMainMenu()

        Utils:doScreenFade('in', 1000)
    end
end

function FN:GetSlotSelected()
    return SlotSelected
end

exports('GetSlotCharacter', function()
    return SlotSelected
end)



function FN:CreateNewCharacter(identifier)
    local Identity = lib.inputDialog(Locale:GetTranslation('create_character_dialog_title'), {
        {
            type = 'input',
            label = Locale:GetTranslation('player_name_label'),
            description = Locale:GetTranslation('player_name_description'),
            required = true,
            min = 8,
        },
        {
            type = 'slider',
            label = Locale:GetTranslation('character_height_label'),
            min = 150,
            max = 220,
            step = 1,
            required = true
        },
        {
            type = 'date',
            label = Locale:GetTranslation('character_dob_label'),
            icon = { 'far', 'calendar' },
            default = false,
            format = "DD/MM/YYYY",
            min = "01/01/1960",
            max = "01/01/2003",
            returnString = true,
            required = true,
        },
        {
            type = 'select',
            label = Locale:GetTranslation('character_sex_label'),
            icon = 'fa-solid fa-venus-mars',
            required = true,
            options = {
                { label = Locale:GetTranslation('sex_male'),   value = 'm' },
                { label = Locale:GetTranslation('sex_female'), value = 'f' }
            }
        },
        {
            type = 'checkbox',
            label = Locale:GetTranslation('confirm_identity_label'),
            required = true
        },
    }
    )

    if not Identity then
        lib.showContext('main_menu')
        return
    end

    local CharacterName = Identity[1]
    local CharacterHeight = Identity[2]
    local CharacterDob = Identity[3]
    local CharacterSex = Identity[4]
    Utils:doScreenFade('out', 1000)
    Wait(1000)
    Utils:ResetChar()
    TriggerEvent('LGF_OxCharacter:StartCustomizationCharacter', CharacterName, CharacterHeight, CharacterDob,
        CharacterSex, identifier)
end

RegisterNetEvent('LGF_OxCharacter:StartCustomizationCharacter',
    function(CharacterName, CharacterHeigt, CharacterDob, CharacterSex, identifier)
        print('ca', CharacterSex)
        Wait(1000)
        Utils:TeleportPlayer(Config.CreationCharacter)
        SlotSelected = Utils:charToCreate(AllSlots)
        Utils:SetFreemodeModel(CharacterSex)
        Wait(1300)
        -- exports['LGF_appearance']:StartCharacterCustomization(function(appearance)
        --     if appearance then
        --         TriggerServerEvent('LEGACYCORE:QUERY:CreateCharId', cache.serverId, CharacterSex, CharacterHeigt,
        --             CharacterName, CharacterDob, json.encode(appearance), SlotSelected)
        --         Shared:DebugPrint(cache.serverId, CharacterSex, CharacterHeigt, CharacterName, CharacterDob,
        --             json.encode(appearance))
        --         Wait(1000)
        --         if Config.EnableSpawnSelector == true then
        --             Selector:OpenMainSelector()
        --         else
        --             Utils:SwitchingCameraSpawn()
        --         end

        --         Utils:clearPeds()
        --     end
        -- end)

        exports['fivem-appearance']:startPlayerCustomization(function(appearance)
            if (appearance) then
                TriggerServerEvent('LEGACYCORE:QUERY:CreateCharId', cache.serverId, CharacterSex, CharacterHeigt,
                    CharacterName, CharacterDob, json.encode(appearance), SlotSelected)
                Shared:DebugPrint(cache.serverId, CharacterSex, CharacterHeigt, CharacterName, CharacterDob,
                    json.encode(appearance))
                Wait(1000)
                if Config.EnableSpawnSelector == true then
                    Selector:OpenMainSelector()
                else
                    Utils:SwitchingCameraSpawn()
                end

                Utils:clearPeds()
            end
        end)
        Utils:doScreenFade('in', 1000)
    end)

local function SaveCoords(ped)
    local coords = GetEntityCoords(ped)
    TriggerServerEvent("LGF_OxCharacter:SaveCoords", coords, SlotSelected)
end

exports('SaveCoords', SaveCoords)

local function PerformRelog()
    local PlayerPed = Legacy.CACHE:GetCache('ped').pedId

    if not Legacy.DATA:IsPlayerLoaded() then
        Shared:DebugPrint(Locale:GetTranslation('cannot_relog_already_logged_out'))
        Shared:GetNotify(Locale:GetTranslation('relog_wait_title'),
            Locale:GetTranslation('cannot_relog_already_logged_out'), 'inform', 'info-circle')
        return
    end

    Utils:clearPeds()

    if not CAN_RELOG then
        Utils:doScreenFade('out', 1000)
        Wait(1000)
        CAN_RELOG = true
        TriggerEvent('LegacyCore:PlayerLogout')
        SaveCoords(PlayerPed)
        FN:OpenMainMenu()
        Wait(1000)
        SetEntityVisible(PlayerPed, false)
        Utils:doScreenFade('in', 1000)

        local timer = lib.timer(10000, function()
            CAN_RELOG = false
        end, true)
    else
        local waitMessage = Locale:GetTranslation('relog_wait_message')
        Shared:DebugPrint(waitMessage)
        Shared:GetNotify(Locale:GetTranslation('relog_wait_title'), waitMessage, 'inform', 'info-circle')
    end
end



RegisterNetEvent('LegacyCore:LGF_OxCharacter:RiempiTable', function(data)
    SlotSelected = data.charIdentifier
    Shared:DebugPrint("SlotSelected set to:", SlotSelected)
    _G.PlayerIsNew = true
    Shared:DebugPrint("PlayerIsNew set to:", _G.PlayerIsNew)
    TriggerEvent('LegacyCore:PlayerLoaded', SlotSelected, data, _G.PlayerIsNew)
    TriggerServerEvent('LegacyCore:PlayerLoaded', SlotSelected, data, _G.PlayerIsNew)
    exports.LEGACYCORE:SetPlayerHunger(100)
    exports.LEGACYCORE:SetPlayerThirst(100)
    TriggerServerEvent('LGF_OxCharacter:ClearPlayerBucket')
    local timer = lib.timer(10000, function()
        TriggerServerEvent('LegacyCore:StartInventoryPack', Legacy.MAIN:GetID(), SlotSelected)
        _G.PlayerIsNew = false
        Shared:DebugPrint("PlayerIsNew set to:", _G.PlayerIsNew)
    end, true)
end)


RegisterNetEvent('LGF_OxCharacter:Command:Relog', function()
    PerformRelog()
end)
