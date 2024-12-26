---@field GetPlayerObject fun(): table|nil Retrieves the player's data object (PlayerData) or nil if not found.
---@field GetFirstCharSlot fun(): number? Returns the first available character slot for the player, or nil if no slot is available.
---@field SetPlayerDuty fun(target: number, state: boolean): boolean Sets the player's duty state. Returns true if the operation was successful.
---@field IsPlayerOnDuty fun(target: number): boolean Checks if a player is currently on duty. Returns true if on duty, false otherwise.



---@return table|nil
function Legacy.DATA:GetPlayerObject()
    return lib.callback.await('LegacyCore:DATA:GetPlayerDataBySlot', 100)
end

--- Returns the first available character slot for the player, or nil if no slot is available.
---@return number? - The first available character slot or nil if no slot is available.
function Legacy.DATA:GetFirstCharSlot()
    return lib.callback.await('LegacyCore:DATA:GetFirstAvailableSlot', 100)
end

--- Sets the player's duty state.
---@param target number - The identifier of the player whose duty state is being set.
---@param state boolean - The new duty state of the player (true for on duty, false for off duty).
---@return boolean - Whether the duty state was successfully updated (true if successful, false otherwise).
function Legacy.DATA:SetPlayerDuty(target, state)
    assert(type(state) == "boolean", "Invalid state type, required boolean value")

    LocalPlayer.state.isOnDuty = lib.callback.await("LegacyCore.SetPlayerDutyState", false, target, state)

    return LocalPlayer.state.isOnDuty
end

--- Checks if a player is currently on duty.
---@param target number - The target id of the player to check.
---@return boolean - Returns true if the player is on duty, false if not.
function Legacy.DATA:IsPlayerOnDuty(target)
    LocalPlayer.state.isOnDuty = lib.callback.await("LegacyCore.GetPlayerDutyState", false, target)
    return LocalPlayer.state.isOnDuty
end
