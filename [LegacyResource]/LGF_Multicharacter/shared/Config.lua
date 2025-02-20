local Config = {}


Config.SelectCharacter        = vec4(456.6404, -763.5005, 26.3578, 168.0270)
Config.StartCreationCharacter = vec4(-1690.7140, -1100.0498, 13.1523, 226.1274)
Config.FirstSpawnNewCharacter = vec4(257.0374, -1198.1539, 29.2893, 8.3260)

Config.CamParameters          = {
    rotation = 180.0,
    height   = 0.0,
    distance = 4.2,
    offset   = 1.0
}

Config.EntityPrewiev          = {
    EnablespawnEntity = false, -- "Vehicle" or "object" "or" false
    Model             = "technical3",
    EntityCoordSpawn  = vec4(458.2321, -743.3803, 26.3576, 6.4221)
}




return Config
