
local function hasIdentifierOfType(identifiers, identifierType)
    if not identifiers or type(identifiers) ~= "table" then return false end
    for _, v in ipairs(identifiers) do if string.find(v, identifierType) then return true end end return false
end

local function asyncWait(milliseconds)
    local startTime = GetGameTimer() while GetGameTimer() - startTime < milliseconds do Wait(0) end
end

function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local identifiers = GetPlayerIdentifiers(player)

    if not identifiers or #identifiers == 0 then
        deferrals.done("No identifiers found.")
        setKickReason("No identifiers found.")
        CancelEvent()
        return
    end

    deferrals.defer()

    if Config.ConnectionData.RequireSteam then
        deferrals.update(LANG.CoreLang("Connection_SteamCheck"):format(name))

        asyncWait(3000)

        local foundSteam = hasIdentifierOfType(identifiers, "steam:")

        if not foundSteam then
            deferrals.done(LANG.CoreLang("Connection_NoSteam"))
            setKickReason(LANG.CoreLang("Connection_SteamKickReason"))
            CancelEvent()
            return
        end
    end

    asyncWait(1000)

    if Config.ConnectionData.CheckLicense then
        deferrals.update(LANG.CoreLang("Connection_LicenseCheck"):format(name))

        asyncWait(2000)

        local validLicense = hasIdentifierOfType(identifiers, "license:")

        if not validLicense then
            deferrals.done(LANG.CoreLang("Connection_NoLicense"))
            setKickReason(LANG.CoreLang("Connection_LicenseKickReason"))
            CancelEvent()
            return
        end
    end

    deferrals.done()
end

AddEventHandler("playerConnecting", OnPlayerConnecting)
