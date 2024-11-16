--[[RETURN DIRECTLY THE PLAYER DATA FIELD BY DATABASE]]
---@return table|nil - The player data object or nil if not found.
function Legacy.DATA:GetPlayerObject()
    return lib.callback.await('LegacyCore:DATA:GetPlayerDataBySlot', 100)
end

--[[
    RETURN THE NUMBER OF THE FIRST CHARACTER SLOT ASSOCIATED WITH A GIVEN IDENTIFIER.
    Manage with example tostring(slot).
    Example:
    If you have 5 characters with slots 2, 3, 4, 6, and 7,
    it will return the lowest number associated with that player in this case '2'.
    You can check in LGF_Multicharacter for insights, maneuver the slot in Legacy Core,
    and it is essential to synchronize all player data.
]]
---@return number? - The number of the first available character slot or nil if no slot is available.
function Legacy.DATA:GetFirstCharSlot()
    return lib.callback.await('LegacyCore:DATA:GetFirstAvailableSlot', 100)
end
