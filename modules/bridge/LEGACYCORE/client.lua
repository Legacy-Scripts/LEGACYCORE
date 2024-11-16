if not lib.checkDependency('LEGACYCORE', '1.0.0', true) then return end


Legacy = exports["LEGACYCORE"]:GetCoreData()

AddEventHandler('LegacyCore:PlayerLogout', function()
    client.onLogout()
end)

function client.setPlayerStatus(values)
    for name, value in pairs(values) do
        if name == 'thirst' then
            Legacy.DATA:SetPlayerThirst(value)
        elseif name == 'hunger' then
            Legacy.DATA:SetPlayerHunger(value)
        end
    end
end
