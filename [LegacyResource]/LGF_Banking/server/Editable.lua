Editable = {}


function Editable.AddPlayerItem(src, itemName, quantity, metadata)
    if GetResourceState("ox_inventory"):find("start") then
        return exports.ox_inventory:AddItem(src, itemName, quantity, metadata)
    elseif GetResourceState("qb-inventory"):find("start") then
        return exports['qb-inventory']:AddItem(src, itemName, quantity)
    elseif GetResourceState("codem-inventory"):find("start") then
        return exports['codem-inventory']:AddItem(src, itemName, quantity)
    end
end

function Editable.GetItemCount(src, itemName, metadata)
    if GetResourceState("ox_inventory"):find("start") then
        return exports.ox_inventory:GetItemCount(src, itemName, metadata)
    elseif GetResourceState("qb-inventory"):find("start") then
    elseif GetResourceState("codem-inventory"):find("start") then
    end
end

function Editable.RemovePlayerItem(src, itemName, quantity)
    if GetResourceState("ox_inventory"):find("start") then
        return exports.ox_inventory:RemoveItem(src, itemName, quantity)
    elseif GetResourceState("qb-inventory"):find("start") then
    elseif GetResourceState("codem-inventory"):find("start") then

    end
end
