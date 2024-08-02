--[[RETURN DIRECTLY THE PLAYER DATA FIELD BY DATABASE]]
function Legacy.DATA:GetPlayerObject()
    return lib.callback.await('LegacyCore:DATA:GetPlayerDataBySlot', 100)
end

--[[SIMPLE RETURN THE FIRST CHARSLOT AVAILABLE (Usage for Dev)]]
function Legacy.DATA:GetFirstCharSlot()
    return lib.callback.await('LegacyCore:DATA:GetFirstAvailableSlot', 100)
end
