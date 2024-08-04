Config = {}



-- Core configuration information
Config.CoreInfo = {
    Locales            = GetConvar('LegacyCore.Locales', 'it'),
    -- Enable or Disable PVP mode for attacking all other players
    EnablePVPmode      = GetConvar('LegacyCore.EnablePVPMode', "true"),
    -- Disable Wanted Level in server
    DisableWantedLevel = GetConvar('LegacyCore.DisableWantedLevel', "true"),
    -- Enable debug print and other data
    EnableDebug        = true,
    -- Status data configuration
    StatusData         = {
        -- Enable decrease for hunger and thirst
        EnableDecrease = true,
        -- Value reducer settings
        ValueReducer = {
            -- Thickness == Seconds to wait before removing status
            -- Example: decrease amount hunger and thirst between 0.5 and 1.6
            Thickness = 30,
            DecreaseHunger = math.random(5, 16) / 10,
            DecreaseThirst = math.random(5, 16) / 10,
        }
    },
    -- Paycheck for player job configuration
    PayCheck           = {
        -- Enable or disable payment for players
        EnablePaycheck    = true,
        -- Time in seconds for paycheck
        ThicknessPaycheck = 20
    }
}

-- Player handling configuration
Config.HandlePlayer = {
    -- Account settings
    Accounts = {
        -- Starting cash quantity
        StartCashQuantity = 2000,
        -- Starting bank quantity
        StartBankQuantity = 3000
    },
    -- Status parameters
    StatusParameters = {
        -- Initial thirst level
        Thirst = 100,
        -- Initial hunger level
        Hunger = 100
    },
    -- Starting items for players
    StartPack = {
        { item = 'water',  count = 1 },
        { item = 'burger', count = 3 }
    }
}

-- Connection settings
Config.ConnectionData = {
    -- Require Steam to connect
    RequireSteam = false,
    -- Check that the player has a license (true is safer)
    CheckLicense = true
}

-- Database configuration
Config.QueryData = {
    -- Specific database name
    NameDB           = 'LegacyCore',
    -- Automatically create database and users table (CHECK README.MD)
    CreateUsersAndDB = false
}

-- Command configuration
Config.Command = {
    CreateVehicle  = 'car',      -- Command to create a vehicle (Params args(string) == model)
    DeleteVehicle  = 'dvcar',    -- Command to delete a vehicle in radius (Params args(number) == radius)
    TeleportPlayer = 'tpm',      -- Command to teleport player to selected waypoint (Params args(??) == Waypoint selected)
    SkinPlayer     = 'skin',     -- Command to set player skin (Params args(number) == id)
    SetJob         = 'setjob',   -- Command to set player job (/setjob [id] [jobname] [grade])
    SetGroup       = 'setgroup', -- Command to set player group (/setgroup [id] [group])
    MyInfo         = 'info'      -- Command to get information for the selected character
}

-- Group configuration
Config.GroupData = {
    -- Default group when player creates a new character
    FirstGroupAssigned = 'player',
    -- Framework groups
    GroupCore          = { 'owner', 'admin', 'mod', 'player' },
    -- Job data settings
    JobData            = {
        -- First job assigned to a player
        FirstJobAssigned = 'unemployed',
        -- Label for the assigned job
        LabelJobAssigned = 'Unemployed',
        -- Grade of the assigned job
        GradeJobAssigned = 0,
    },
    -- Admin group settings
    AdminGroup         = {
        ['owner']  = true, -- Owner
        ['admin']  = true, -- Admin
        ['mod']    = true, -- Moderator
        ['player'] = false -- Player
    }
}

-- Check if the player is dead
Config.ReturnIsDead = function()
    if GetResourceState('ars_ambulancejob'):find('start') then
        return LocalPlayer.state.dead
    else
        return IsEntityDead(cache.ped)
    end
end
