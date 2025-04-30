---@class PlayerManager : ManagerClass
local PlayerManager = lib.class('PlayerManager')

PlayerManager.PlayerData = nil
PlayerManager.PlyState = LocalPlayer.state
PlayerManager.PlayerLoaded = nil


function PlayerManager:constructor(data)
    self.charIdentifier = data.charIdentifier or nil
    self.playerGroup = data.playerGroup or "player"
    self.JobName = data.JobName or "unemployed"
    self.JobLabel = data.JobLabel or "Unemployed"
    self.JobGrade = data.JobGrade or 0
    self.is_dead = data.is_dead or false
    self.accounts = data.accounts or { Bank = 0, money = 0 }
    self.status = data.status
    self.identifier = data.identifier or nil
    self.sex = data.sex or nil
    self.dob = data.dob or nil
    self.height = data.height or nil
    self.playerName = data.playerName or nil
    self.skin = data.skin or {}
    self.source = data.source or nil
    self.inventory = {}
    self.inDuty = data.inDuty or false
end

RegisterNetEvent('LegacyCore:changeJob', function(target, jobName, jobGrade, currJobData)
    local self = PlayerManager
    if not self.PlayerData then return end
    self.PlayerData.JobName = jobName
    self.PlayerData.JobGrade = jobGrade
    self.PlyState:set("GetPlayerObject", self.PlayerData, true)
end)

function PlayerManager:handlePlayerLoaded(slot, playerdata, new)
    if type(playerdata) ~= "table" then
        error(string.format("Invalid playerdata: expected a table, got %s", type(playerdata)))
    end

    local __istance = PlayerManager:new(playerdata)

    self.PlayerData = __istance


    if self.PlayerData then
        self.PlyState:set('GetPlayerObject', self.PlayerData, true)
    end

    if Config.CoreInfo.EnablePVPmode then
        SetCanAttackFriendly(playerdata.ped, true, false)
        NetworkSetFriendlyFireOption(true)
    end

    if Config.CoreInfo.DisableWantedLevel then
        SetMaxWantedLevel(0)
    end


    Legacy.MAIN.ToggleDriveBy(true)


    self.charIdentifier = slot
    self.PlayerLoaded = true

    LocalPlayer.state.isOnDuty = self.PlayerData.inDuty or false


    if new then
        exports.LEGACYCORE:SetPlayerHunger(Config.HandlePlayer.StatusParameters.Hunger)
        exports.LEGACYCORE:SetPlayerThirst(Config.HandlePlayer.StatusParameters.Thirst)
    else
        exports.LEGACYCORE:SetPlayerHunger(playerdata.status.hunger)
        exports.LEGACYCORE:SetPlayerThirst(playerdata.status.thirst)
    end


    if GetResourceState("Revoria_Welcome"):find("start") then
        SetTimeout(3000, function()
            exports.Revoria_Welcome:sendWelcomePrompt({
                PlayerName = playerdata.playerName,
                Message = "Welcome To Revoria",
                Duration = 5000,
            })
        end)
    end

    self:handleRemoveDroop()
end

function PlayerManager:handlePlayerLogout()
    TriggerServerEvent('LegacyCore:PlayerLogout')
    self.PlyState:set('GetPlayerObject', {}, true)
    self.PlayerLoaded = false
    self.charIdentifier = nil
    self.PlayerData = {}
end

function PlayerManager:handleRemoveDroop()
    CreateThread(function()
        while self.PlayerLoaded do
            local coords = GetEntityCoords(cache.ped)
            local PedPool = lib.getNearbyPeds(coords, 50.0)

            for _, Ped in ipairs(PedPool) do
                if Ped.ped ~= nil then
                    SetPedDropsWeaponsWhenDead(Ped.ped, false)
                end
            end

            Wait(2000)
        end
    end)
end

function PlayerManager:IsPlayerLoaded()
    return self.PlayerLoaded
end

function PlayerManager:GetPlayerMetadata(key)
    assert(type(key) == 'string', 'Bad value, request type [string]')
    self.PlayerMeta = lib.callback.await('LegacyCore:DATA:GetPlayerDataBySlot', false)
    if not Legacy.DATA:IsPlayerLoaded() then return nil, 'Player data is not loaded.' end
    local value = self.PlayerMeta[key]
    if value == nil then return nil, string.format('Key not found in player data: %s', key) end
    return value
end

function PlayerManager:GetSkin()
    if not Legacy.DATA:IsPlayerLoaded() then return nil, 'Player data is not loaded.' end
    local skin = self.PlayerData.skin
    if not skin then return nil, 'Player skin data not found.' end
    return skin
end

function PlayerManager:GetPlayerCharId()
    return self.charIdentifier
end

return PlayerManager
