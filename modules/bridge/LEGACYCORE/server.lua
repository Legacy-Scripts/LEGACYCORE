---@diagnostic disable: undefined-global, inject-field, need-check-nil, undefined-field
---@diagnostic disable-next-line: duplicate-set-field
if not lib.checkDependency('LEGACYCORE', '1.0.0', true) then return end


Legacy = exports["LEGACYCORE"]:GetCoreData()

local Inventory = require 'modules.inventory.server'


RegisterNetEvent('LegacyCore:PlayerLogout')
AddEventHandler('LegacyCore:PlayerLogout', function()
    server.playerDropped(source)
end)

RegisterNetEvent("LegacyCore:PlayerLoaded", function(slot, data, new)
    local Data = {
        source = data.source,
        identifier = data.identifier,
        name = data.playerName,
        playerGroup = data.playerGroup,
        sex = data.sex,
        dob = data.dob,
        JobName = data.JobName,
        charIdentifier = data.charIdentifier,
        accounts = json.encode(data.accounts)
    }
    server.setPlayerInventory(Data, Data.inventory)
end)




function server.syncInventory(inv)
    -- lib.print.info(msgpack.unpack(msgpack.pack(inv)))
    local money = table.clone(server.accounts)
    for _, v in pairs(inv.items) do if money[v.name] then money[v.name] = money[v.name] + v.count end end

    if next(money) ~= nil then
        local playerData = Legacy.DATA:GetPlayerDataBySlot(inv.id)
        if playerData then
            if playerData.accounts then
                local moneyAccounts = json.decode(playerData.accounts)

                if moneyAccounts.money then moneyAccounts.money = money["money"] or moneyAccounts.money end

                local updatedMoneyAccounts = json.encode(moneyAccounts)

                Legacy.DATA:SetPlayerData(inv.id, "accounts", updatedMoneyAccounts, inv.player.slot)
            end
        end
    end
end

function server.setPlayerData(player)
    local playerData = {
        source = source,
        identifier = player.identifier,
        name = player.playerName,
        groups = player.playerGroup,
        sex = player.sex,
        dateofbirth = player.dob,
        job = player.JobName,
        slot = player.charIdentifier,
    }
    return playerData
end

function server.isPlayerBoss(playerId)
    local Player = Legacy.DATA:GetPlayerDataBySlot(playerId)
    return Player.JobLabel == 'boss'
end
