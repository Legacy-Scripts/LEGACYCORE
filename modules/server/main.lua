Legacy = {
    MAIN = {},
    DATA = {}
}

function Legacy.MAIN:GetPlayers()
    local players = {}
    for _, player in ipairs(GetPlayers()) do
        local playerInfo = {
            id = player,
            name = GetPlayerName(player)
        }
        table.insert(players, playerInfo)
    end
    return players
end

function Legacy.MAIN:GetNameIDE(src)
    return GetPlayerName(src)
end

function Legacy.MAIN:GetPlayerCount()
    return #GetPlayers()
end

function Legacy.MAIN:IsPlayerOnline(source)
    for _, player in ipairs(GetPlayers()) do
        if tostring(player) == tostring(source) then
            return true
        end
    end
    return false
end

