Config                         = {}

-- Enable or disable debug mode (true = enabled, false = disabled)
Config.Debug                   = true
-- Set the default language for translations ('en' = English, 'it' = Italian, etc.)
Config.Locales                 = 'en'
-- Allow players to delete personal characters (true = allowed, false = not allowed)
Config.PlayerCanDeleteChar     = false
-- Default maximum number of characters a player can create
Config.MaxCharacter            = 6
-- System used for character appearance customization (e.g., 'fivem-appearance')
Config.AppearanceSystem        = 'fivem-appearance'
-- Default spawn location for character creation skin
Config.CreationCharacter       = vec4(-2041.9454, -373.3573, 44.1065, 328.2534)
-- Fallback spawn location if no other spawn point is specified (x, y, z, heading)
Config.FallBackSpawn           = vec4(-616.2140, -747.6472, 36.2805, 324.1704)
-- Enable Or Disable Spawn Selector after Character Skin Creation (true = enabled, false = disabled)
Config.EnableSpawnSelector     = false
-- If EnableSpawnSelector is false, Use This Coords for Spawn character After Skin Creation
Config.FirstSpawnAfterCreation = vec4(-585.1137, -778.1562, 25.0172, 86.7087)
-- Prefix Bucket for Player (Basically is 0)
Config.PrefixBucket            = 0
-- Restrict access to certain groups (true = allowed, false = not allowed)
Config.RestrictionGroup        = {
    ['admin'] = true, -- Admins are allowed
    ['mod'] = true,   -- Moderators are allowed
    ['user'] = false, -- Regular users are not allowed
}

-- Command settings for various character actions
Config.Command                 = {
    Relog       = 'relog',      -- Command for relogging
    CharPannel  = 'login',      -- Command for opening the character panel
    DeleteChar  = 'delchar',    -- Command for deleting_character from the Database
    RelogForced = 'forceRelog', -- Command for relog forced
}

-- Spawn location options available to players
Config.SpawnSelector           = {
    ['vinewood_hills'] = {
        PositionSpawn = vec4(-986.1100, -385.8901, 45.3840, 121.6965),
        Description   = 'Vinewood Hills: The famous neighborhood with a great view of Los Santos.',
        Title         = 'Vinewood Hills',
    },

}


-- Character spawn positions for different locations
Config.SpawnCharacterPosition = {
    ['rancho'] = {
        SpawnChar = {
            vec4(-986.1100, -385.8901, 45.3840, 121.6965),

        },
        DistanceCam = 2.00, -- Camera distance from the character
    },
}

-- Random animations to be played based on character's gender
Config.RandomAnimation        = {
    ['m'] = {
        { animDict = 'anim@mp_player_intcelebrationmale@thumbs_up', animName = 'thumbs_up',  animTime = 5000 },
        { animDict = 'anim@miss@low@fin@vagos@',                    animName = 'idle_ped06', animTime = -1 },
        { animDict = 'anim@mp_player_intuppersuck_it',              animName = 'idle_a',     animTime = 5000 }
    },
    ['f'] = {
        { animDict = 'anim@mp_player_intcelebrationfemale@finger', animName = 'finger',     animTime = 5000 },
        { animDict = 'anim@miss@low@fin@vagos@',                   animName = 'idle_ped06', animTime = 5000 },
    }
}

-- Custom slot limits for specific players based on their license
Config.SlotForPlayer          = {
    {
        License = '', -- Player license identifier
        MaxSlot = 1   -- Maximum number of character slots for this player
    },
}
