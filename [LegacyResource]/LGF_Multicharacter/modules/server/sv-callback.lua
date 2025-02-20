local Chars = require "modules.server.sv-characters"

lib.callback.register("Revoria_Multicharacter.GetCharacters", function(source)
    return Chars.GetPlayerCharacter(source)
end)

lib.callback.register("Revoria_Multicharacter.SetBucket", function(source, bucket)
    return Legacy.MAIN:SetPlayerBucket({
        enablePopulation = true,
        bucket = bucket,
        target = source
    })
end)


lib.callback.register("Revoria_Multicharacter.saveCoords", function(source, coords, slot)
    return Chars.saveCoords(source, coords, slot)
end)

lib.callback.register("Revoria_Multicharacter.CreateNewChar", function(source, data)
    return Chars.createChar(source, data)
end)

lib.callback.register("Revoria_Multicharacter.DeleteChar", function(source, slot)
    return Chars.deleteChar(source, slot)
end)
