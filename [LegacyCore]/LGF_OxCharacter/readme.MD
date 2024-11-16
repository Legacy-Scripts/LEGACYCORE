# LGF OX MULTICHARACTER (Multicharacter for LegacyCore)

Notes
Ensure you are using the correct parameters to avoid errors.
These functions are essential for managing player `characters` within the multicharacter system of `LegacyCore`.

## Available Commons

### Server-Side Functions

#### GetCharacters

The `GetCharacters` function retrieves all characters associated with a specific player.

**Syntax:**

```lua
---@param src number - Source of the player
---@return table[] | nil - Al Player Characters or nil if not found
exports.LGF_OxCharacter:GetCharacters(source)
```

```lua
local source = 1
local characters = exports.LGF_OxCharacter:GetCharacters(source)

if characters then
    for _, character in ipairs(characters) do
        print("Character Name:", character.name)
        print("Slot:", character.slot)
    end
else
    print("No characters found for player with ID", source)
end
```

#### DeleteCharacter

The `DeleteCharacter` function deletes a specific character based on the slot and identifier.

**Syntax:**

```lua
---@param slot number - Slot of the player character to be deleted
---@param identifier string - The player Identifier
---@return boolean - If player character is deleted
exports.LGF_OxCharacter:DeleteCharacter(slot, identifier)
```

```lua
exports.LGF_OxCharacter:DeleteCharacter(2, "license:1234567890abcdef" )
print(string.format('Character in slot %s has been deleted for identifier %s', slot, identifier))
```

### Client-Side Functions

#### OpenSelector

The `OpenSelector` function open The Ox Lib Spawn Selector.

**Syntax:**

```lua
---@param ped entity - Player Ped Handle
exports.LGF_OxCharacter:OpenSelector()
```

```lua
RegisterCommand('spawnselector', function()
    exports.LGF_OxCharacter:OpenSelector()
end)
```

#### SaveCoords

The `SaveCoords` function save the coords for the specific characters.

**Syntax:**

```lua
exports.LGF_OxCharacter:SaveCoords(ped)
```

```lua
RegisterCommand('savecoords', function()
    exports.LGF_OxCharacter:SaveCoords()
end)
```

#### GetSlotCharacter

The `GetSlotCharacter` function return the current player slot used.

**Syntax:**

```lua
exports.LGF_OxCharacter:GetSlotCharacter()
```

```lua
RegisterCommand('myslot', function()
    local Slot = exports.LGF_OxCharacter:GetSlotCharacter()
    print(string.format('My Slot: %s', Slot))
end)
```

