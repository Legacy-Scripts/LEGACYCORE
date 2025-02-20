Config = {}

-- [[COMMAND TO MANAGE THE HUD]]
Config.Command = {
    CinematicMode = 'cinematic',
    PannelHud = 'hud',
    TestNotify = 'noty'
}

-- [[CAR HUD ELEMENTS TO HIDE O SHOW]]
Config.CarHudComponent = {
    Temperature_HUD = false, -- Show Progress Temperature vehicle HUD
    Health_HUD = false,      -- Show Progress Body Healt vehicle HUD
}


-- [[ SUPPORT MULTICOLOR AND MULTIFORMAT]]
Config.ColorRingProgress = {
    Health = '#FF6F61',  -- Coral
    Stamina = '#9BCA3E', -- Light Green
    Thirst = '#5DADE2',  -- Light Blue
    Hunger = '#F7C6C7',  -- Light Peach
}

-- [[SUPPORT ONLY BADGE COLOR MANTINE (https://v6.mantine.dev/core/badge/)]]
Config.BadgeColor = {
    Job = 'violet',
    PlayerBank = 'orange',
    PlayerID = 'teal',
}


--[[COMPONENT TO DISABLE IN HUD]]
Config.DisableComponentHud = {
    { name = "WANTED_STARS",         index = 1 },
    { name = "WEAPON_ICON",          index = 2 },
    { name = "CASH",                 index = 3 },
    { name = "MP_CASH",              index = 4 },
    { name = "MP_MESSAGE",           index = 5 },
    { name = "VEHICLE_NAME",         index = 6 },
    { name = "AREA_NAME",            index = 7 },
    { name = "VEHICLE_CLASS",        index = 8 },
    { name = "STREET_NAME",          index = 9 },
    { name = "HELP_TEXT",            index = 10 },
    { name = "FLOATING_HELP_TEXT_1", index = 11 },
    { name = "FLOATING_HELP_TEXT_2", index = 12 },
    { name = "CASH_CHANGE",          index = 13 },
    { name = "SUBTITLE_TEXT",        index = 15 },
    { name = "SAVING_GAME",          index = 17 },
    { name = "GAME_STREAM",          index = 18 },
    { name = "W_WHEEL",              index = 19 },
    { name = "W_WHEEL_STATS",        index = 20 },
    { name = "HUD_COMPONENTS",       index = 21 },
}
