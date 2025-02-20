Config = {}

Config.ProviderNotification = "ox_lib"
Config.ItemCashName = "money"
Config.EnableAtmsBlip = true
Config.ZoneBanking = {
    ["zone1"] = {
        DataPed = {
            PedModel = "cs_bankman",
            PedPosition = vec4(-570.8925, -954.0075, 23.2033, 0.0000),
            PedScenario = "WORLD_HUMAN_AA_SMOKE",
        }
    },
    ["zone2"] = {
        DataPed = {
            PedModel = "cs_bankman",
            PedPosition = vec4(300.0, 220.0, 101.0, 0.0),
            PedScenario = "WORLD_HUMAN_AA_SMOKE",
        }
    },
    ["zone3"] = {
        DataPed = {
            PedModel = "cs_bankman",
            PedPosition = vec4(350.0, 220.0, 101.0, 0.0),
            PedScenario = "WORLD_HUMAN_AA_SMOKE",
        }
    }
}
