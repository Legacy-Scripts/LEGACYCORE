<p >
    <img src="https://img.shields.io/badge/LEGACYCORE-Created%20by%20ENT510-%23D08F6A" alt="Welcome Badge" />
</p>

This project leverages the `ox_lib` resource to load and manage various modules dynamically. Below, you will find details on how to utilize the `LEGACYCORE` export to access core data and functions from both the client and server sides.

## Loading Core Data

To access the core data, you need to use the `GetCoreData` function provided by the `LEGACYCORE` export. This will load the available modules and their respective functions.

```lua
local Legacy = exports['LEGACYCORE']:GetCoreData()
```
# General Common / Exports

```lua
Available Class = {
    Server = [
        MAIN, -- Functions
        DATA, -- GetPlayerData + Functions Player Data

    ]
    Client = [
        MAIN, -- Use Function
        DATA, -- GetPlayerData + Functions Player Data
        PLAYERCACHE, -- GetPlayerData by State Bag
        PLAYERCACHE, -- Entity Cache (vehicle / ped)
    ]
}
```

## Example Shared Functions (request require)

```lua
local Legacy = exports['LEGACYCORE']:GetCoreData()

local SHARED = require('@LEGACYCORE.modules.shared.shared_functions')
local MyId = Legacy.MAIN:GetID()

SHARED.DebugData(MyId)
```

## Example Function Client Side(MAIN Class):

```lua
local Legacy = exports['LEGACYCORE']:GetCoreData()

local MyId = Legacy.MAIN:GetID()

print(MyId)
```

## Example Function Server Side(MAIN Class):

```lua
local Legacy = exports['LEGACYCORE']:GetCoreData()

local AllPlayers = Legacy.MAIN:GetPlayers()

print(json.encode(AllPlayers, { indent = true }))
```

--[[
If enabled, it will create a database with a unique ID and general users table with the following columns:
(Note that if the database or column or both already exist, no query will be executed.)

- `identifier`: Unique identifier for each user (VARCHAR(50)).
- `charIdentifier`: Character identifier or slot number (VARCHAR(50)).
- `inventory`: JSON formatted text field for storing inventory data (TEXT, default '{}').
- `firstName`: First name of the user (VARCHAR(50)).
- `lastName`: Last name of the user (VARCHAR(50)).
- `sex`: Gender of the user (VARCHAR(10)).
- `dob`: Date of birth of the user (DATE).
- `height`: Height of the user (DECIMAL(5,2)).
- `accounts`: JSON formatted text field for storing account information (TEXT, default '{}').
- `status`: Current status or state of the user (VARCHAR(50)).
- `skin`: JSON formatted text field for storing skin customization data (TEXT, default '{}').
- `lastSpawn`: JSON formatted text field for storing last spawn location data (TEXT, default '{}').
- `playerGroup`: Group or faction name of the user (VARCHAR(50)).
- `JobName`: Name of the current job or occupation (VARCHAR(50)).
- `JobLabel`: Label or description of the current job (VARCHAR(50)).
- `JobGrade`: Grade or level within the current job (INT).
- `is_dead`: Indicator for whether the user is currently deceased (INT).
  ]]

## Events Client Side

```lua
-- Triggered when the player logs out
TriggerEvent('LegacyCore:PlayerLogout')
TriggerServerEvent("LegacyCore:PlayerLogout")
```

```lua
-- Triggered when the player is fully loaded
TriggerServerEvent('LegacyCore:PlayerLoaded')
TriggerEvent('LegacyCore:PlayerLoaded')
```

## Example

`PlayerLoaded` provide at return the slot and playerdata for current player spawned

```lua
AddEventHandler('LegacyCore:PlayerLoaded', function(slot, playerdata,newPlayer)
    print(json.encode(playerdata))
    print(slot)
end)
```

## Get Player Data by State Bag (Client Side)

Get Player Data by State Bag: to retrieve player data client side you can use `LocalPlayer.state.GetPlayerObject`, Will come back a a table with the data properly.

```lua
RegisterCommand('bag', function()
    PlayerData = LocalPlayer.state.GetPlayerObject
    print(json.encode(PlayerData))
end)
```

Or You can request the cache via the player state `Legacy.PLAYERCACHE[LocalPlayer]`

```lua
RegisterCommand('cache', function(src)
    local Legacy = exports['LEGACYCORE']:GetCoreData()
    local ID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(cache.ped))
    local PlayerCache = Legacy.PLAYERCACHE[ID]
    print(json.encode(PlayerCache, { indent = true }))
end)
```

## OTHERS

```lua
---@field promise return [[value]]
---@field error return [[specified error]]
--[[
    Retrieves a specific piece of metadata for the player. This function allows you to query specific keys from the player's metadata and get their associated values.
-- ]]

local promise, error = Legacy.DATA:GetPlayerMetadata('accounts')
if promise then
    print("Player Accounts:" , json.encode(accounts))
else
    print("Error retrieving Accounts:", error )
end

```

## Get Player to available fields (Client Side)

```lua
RegisterCommand('data', function(source)
    local Legacy = exports['LEGACYCORE']:GetCoreData()
    -- Direct access to available fields
    local is_dead = Legacy.DATA:GetPlayerObject().is_dead               -- @type number: Indicates if the player is dead (1 or 0).
    local identifier = Legacy.DATA:GetPlayerObject().identifier         -- @type string: Player identifier.
    local charIdentifier = Legacy.DATA:GetPlayerObject().charIdentifier -- @type string: Character identifier.
    local playerName = Legacy.DATA:GetPlayerObject().playerName         -- @type string: Player character name.
    local sex = Legacy.DATA:GetPlayerObject().sex                       -- @type string: Player character gender ('m' or 'f').
    local dob = Legacy.DATA:GetPlayerObject().dob                       -- @type string: Player character date of birth (format YYYY-MM-DD).
    local height = Legacy.DATA:GetPlayerObject().height                 -- @type number: Player character height.
    local accounts = Legacy.DATA:GetPlayerObject().accounts             -- @type table: Player's account data (money and bank).
    local status = Legacy.DATA:GetPlayerObject().status                 -- @type string: Player character status.
    local skin = Legacy.DATA:GetPlayerObject().skin                     -- @type table: Player character skin data.
    local lastSpawn = Legacy.DATA:GetPlayerObject().lastSpawn           -- @type table: Player character last spawn position.
    local playerGroup = Legacy.DATA:GetPlayerObject().playerGroup       -- @type string: Player character group affiliation.
    local JobName = Legacy.DATA:GetPlayerObject().JobName               -- @type string: Player character job name.
    local JobLabel = Legacy.DATA:GetPlayerObject().JobLabel             -- @type string: Player character job label.
    local JobGrade = Legacy.DATA:GetPlayerObject().JobGrade             -- @type number: Player character job grade.
    local Inventory = Legacy.DATA:GetPlayerObject().inventory           -- @type number: Player character job grade.


    print("is_dead:", is_dead)
    print("identifier:", identifier)
    print("charIdentifier:", charIdentifier)
    print("playerName:", playerName)
    print("sex:", sex)
    print("dob:", dob)
    print("height:", height)
    print("accounts:", json.encode(accounts))
    print("status:", status)
    print("skin:", json.encode(skin))
    print("lastSpawn:", json.encode(lastSpawn))
    print("playerGroup:", playerGroup)
    print("JobName:", JobName)
    print("JobLabel:", JobLabel)
    print("JobGrade:", JobGrade)
end)
```

# Legacy Data Cache System

The Legacy Data Cache System provides a way to cache and manage data related to the player's vehicle and ped (player character) in a game. This system updates data periodically based on whether the player is in a vehicle or on foot.

## Available Classes

### `Legacy.CACHE:GetCache(cacheType)`

This function retrieves cached data based on the type specified.

#### Parameters

- `cacheType` (string): The type of cache to retrieve. Options are `'vehicle'` and `'ped'`.

#### Returns

- A table containing cached data for the specified type.

## Caching Data

### Vehicle Cache

When the player is in a vehicle, the system caches data about the vehicle. The following fields are available:

- **`name`**: The display name of the vehicle model.
- **`entity`**: The vehicle entity handle.
- **`netId`**: The network ID of the vehicle.
- **`model`**: The model ID of the vehicle.
- **`speed`**: The current speed of the vehicle.
- **`plate`**: The vehicle's license plate text.
- **`driver`**: The ped handle of the driver.
- **`isEngineOn`**: Boolean indicating if the vehicle's engine is running.
- **`isLocked`**: Boolean indicating if the vehicle is locked.
- **`coords`**: The current coordinates of the vehicle.

#### Example Usage

```lua
RegisterCommand('cache', function()
    local vehicleCache = Legacy.CACHE:GetCache('vehicle')
    if vehicleCache then
        print(string.format("Vehicle Name: %s", vehicleCache.name))
        print(string.format("Vehicle Model: %d", vehicleCache.model))
        print(string.format("Vehicle Speed: %.2f", vehicleCache.speed))
        print(string.format("Vehicle Plate: %s", vehicleCache.plate))
        print(string.format("Engine On: %s", tostring(vehicleCache.isEngineOn)))
        print(string.format("Locked: %s", tostring(vehicleCache.isLocked)))
        print(string.format("Coordinates: %s", json.encode(vehicleCache.coords, { indent = true })))
    else
        print("Not in vehicle or no vehicle data available.")
    end
end)
```

### Ped Cache

When the player is on foot, the system caches data about the player's ped (character). The following fields are available:

- **`pedId`**: The ped entity handle.
- **`coords`**: The current coordinates of the ped.
- **`health`**: The current health of the ped.
- **`armor`**: The current armor of the ped.
- **`weapon`**: The currently equipped weapon of the ped.
- **`source`**: The server ID of the player associated with the ped.

#### Example Usage

To retrieve and display the ped's data, use the following command:

```lua
RegisterCommand('pedcache', function()
    local pedCache = Legacy.CACHE:GetCache('ped')
    if pedCache then
        print(string.format("Ped Health: %d", pedCache.health))
        print(string.format("Ped Armor: %d", pedCache.armor))
        print(string.format("Ped Weapon: %d", pedCache.weapon))
        print(string.format("Ped Coordinates: %s", json.encode(pedCache.coords, { indent = true })))
    else
        print("No ped data available.")
    end
end)
```

In this example:

Command: /pedcache
Function: Retrieves and prints various ped details including health, armor, weapon, and coordinates.
Output: Displays the ped's health, armor, weapon, and coordinates in a formatted manner if data is available; otherwise, it indicates that no ped data is available.
