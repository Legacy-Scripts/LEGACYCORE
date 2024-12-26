---@class PlayerManager : ManagerClass
local PlayerManager = lib.class('PlayerManager')

PlayerManager.PlayerData = nil
PlayerManager.PlyState = LocalPlayer.state
PlayerManager.PlayerLoaded = nil


function PlayerManager:constructor(data)
    self.charIdentifier = data.newCharIdentifier or nil
    self.playerGroup = data.playerGroup or "player"
    self.JobName = data.jobName or "unemployed"
    self.JobLabel = data.jobLabel or "Unemployed"
    self.JobGrade = data.jobGrade or 0
    self.is_dead = data.is_dead or false
    self.accounts = data.accounts or {}
    self.status = data.status or {}
    self.identifier = data.identifier or nil
    self.sex = data.sex or nil
    self.dob = data.dob or nil
    self.height = data.height or nil
    self.playerName = data.name or nil
    self.skin = data.appearance or {}
    self.source = data.src or nil
    self.inventory = {}
    self.inDuty = data.inDuty or false
end

function PlayerManager:handlePlayerLoaded(slot, playerdata, new)
    if type(playerdata) ~= "table" then
        error(string.format("Invalid playerdata: expected a table, got %s", type(playerdata)))
    end

    local __istance = PlayerManager:new(playerdata)

    if __istance then
        print("Debug: PlayerManager instance created successfully")
    else
        print("Debug: PlayerManager instance creation failed")
    end

    self.PlayerData = __istance


    if self.PlayerData then
        self.PlyState:set('GetPlayerObject', self.PlayerData, true)
        print("Debug: Player state set with GetPlayerObject")
    end

    if Config.CoreInfo.EnablePVPmode then
        SetCanAttackFriendly(playerdata.ped, true, false)
        NetworkSetFriendlyFireOption(true)
    end

    if Config.CoreInfo.DisableWantedLevel then
        SetMaxWantedLevel(0)
    end


    self.charIdentifier = slot
    self.PlayerLoaded = true

    print("Debug: charIdentifier set to", self.charIdentifier)
    print("Debug: PlayerLoaded set to", self.PlayerLoaded)


    LocalPlayer.state.isOnDuty = self.inDuty or false


    print("Debug: Player isOnDuty:", LocalPlayer.state.isOnDuty)


    if new then
        exports.LEGACYCORE:SetPlayerHunger(100)
        exports.LEGACYCORE:SetPlayerThirst(100)
    end
end

function PlayerManager:handlePlayerLogout()
    TriggerServerEvent('LegacyCore:PlayerLogout')
    self.PlyState:set('GetPlayerObject', {}, true)
    self.PlayerLoaded = false
    self.charIdentifier = nil
    self.PlayerData = {}
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
