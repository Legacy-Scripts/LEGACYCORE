---@class PlayerManager : ManagerClass
local PlayerManager = lib.class('PlayerManager')

PlayerManager.PlayerData = nil
PlayerManager.PlayerStatus = nil
PlayerManager.PlyState = LocalPlayer.state
PlayerManager.PlayerLoaded = nil
CHARID = nil

function PlayerManager:constructor()
end

function PlayerManager:handlePlayerLoaded(slot, playerdata, new)
 
    if type(playerdata) ~= "table" then error(string.format("Invalid playerdata: expected a table, got %s", type(playerdata))) end

    self.PlayerData = playerdata

    if self.PlayerData then
        self.PlyState:set('GetPlayerObject', self.PlayerData, true)
        Legacy.PLAYERCACHE[playerdata.source or cache.serverId] = self.PlayerData
    end


    if Config.CoreInfo.EnablePVPmode then
        SetCanAttackFriendly(playerdata.ped, true, false)
        NetworkSetFriendlyFireOption(true)
    end

    if Config.CoreInfo.DisableWantedLevel then
        SetMaxWantedLevel(0)
    end

    self.CHARID = slot
    self.PlayerLoaded = true

    if new then
        print('is New')
    end
end

function PlayerManager:handlePlayerLogout()
    TriggerServerEvent('LegacyCore:PlayerLogout')
    Legacy.PLAYERCACHE = {}
    self.PlyState:set('GetPlayerObject', {}, true)
    self.PlayerLoaded = false
    CHARID = nil
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
    return CHARID
end

return PlayerManager
