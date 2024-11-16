local Function = {}

function Function:GetHashKeyStreet()
    local pos = GetEntityCoords(cache.ped)
    local street1, street2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z)
    local streetName1 = GetStreetNameFromHashKey(street1)
    local streetName2 = GetStreetNameFromHashKey(street2) 
    return streetName1 .. (streetName2 ~= "" and " / " .. streetName2 or "")
end

for _, component in ipairs(Config.DisableComponentHud) do
    if component.index then
        SetHudComponentPosition(component.index, 999999.0, 999999.0)
    end
end


return Function
