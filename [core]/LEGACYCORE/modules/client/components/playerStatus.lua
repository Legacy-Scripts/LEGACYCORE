Legacy.PLAYERSTATUS = { Thirst = 100, Hunger = 100 }

function Legacy.DATA:SetPlayerStatus(status, value)
    if status == 'thirst' then
        Legacy.PLAYERSTATUS.Thirst = value
    elseif status == 'hunger' then
        Legacy.PLAYERSTATUS.Hunger = value
    else
        print(("Unknown status type: %s "):format(tostring(status)))
    end
end

function Legacy.DATA:SetPlayerHunger(value)
    Legacy.PLAYERSTATUS.Hunger = math.min(value, 100)
end

function Legacy.DATA:SetPlayerThirst(value)
    Legacy.PLAYERSTATUS.Thirst = math.min(value, 100)
end

function Legacy.DATA:DecreasePlayerStatus()
    local decreaseThirst = Config.CoreInfo.StatusData.ValueReducer.DecreaseThirst
    local decreaseHunger = Config.CoreInfo.StatusData.ValueReducer.DecreaseHunger
    local currentThirst = Legacy.PLAYERSTATUS.Thirst
    local currentHunger = Legacy.PLAYERSTATUS.Hunger

    if currentThirst > 0 then
        local newThirst = currentThirst - decreaseThirst
        if newThirst < 0 then newThirst = 0 end
        Legacy.DATA:SetPlayerStatus('thirst', newThirst)
    else
        SetEntityHealth(cache.ped, GetEntityHealth(cache.ped) - 5)
    end

    if currentHunger > 0 then
        local newHunger = currentHunger - decreaseHunger
        if newHunger < 0 then newHunger = 0 end
        Legacy.DATA:SetPlayerStatus('hunger', newHunger)
    else
        SetEntityHealth(cache.ped, GetEntityHealth(cache.ped) - 5)
    end
end

if Config.CoreInfo.StatusData.EnableDecrease then
    CreateThread(function()
        while true do
            if Legacy.DATA:IsPlayerLoaded() and not Config.ReturnIsDead() then
                SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
                Legacy.DATA:DecreasePlayerStatus()
            end
            Wait(Config.CoreInfo.StatusData.ValueReducer.Thickness * 1000)
        end
    end)

    CreateThread(function()
        while true do
            Wait(30000)
            if Legacy.DATA:IsPlayerLoaded() then
                TriggerServerEvent('Legacy:QUERY:SavePlayerStatus', cache.serverId, Legacy.PLAYERSTATUS.Hunger,
                    Legacy.PLAYERSTATUS.Thirst)
            end
        end
    end)
end

function Legacy.DATA:UpdateStatus(status, change)
    if status == 'hunger' then
        local newHunger = Legacy.PLAYERSTATUS.Hunger + change
        Legacy.PLAYERSTATUS.Hunger = math.min(math.max(newHunger, 0), 100)
    elseif status == 'thirst' then
        local newThirst = Legacy.PLAYERSTATUS.Thirst + change
        Legacy.PLAYERSTATUS.Thirst = math.min(math.max(newThirst, 0), 100)
    else
        print(("Unknown status type: %s "):format(tostring(status)))
    end
end

-- Update Value
exports("UpdatePlayerStatus", function(status, value) return Legacy.DATA:UpdateStatus(status, value) end)

-- Set Value
exports('SetPlayerHunger', function(value) return Legacy.DATA:SetPlayerHunger(value) end)
exports('SetPlayerThirst', function(value) return Legacy.DATA:SetPlayerThirst(value) end)

-- Get Value
exports('GetPlayerHunger', function() return Legacy.PLAYERSTATUS.Hunger end)
exports('GetPlayerThirst', function() return Legacy.PLAYERSTATUS.Thirst end)
