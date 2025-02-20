Config = {}

-- Enable debug mode for printing debug messages
Config.EnableDebug = true

-- Run SQL to create the lgf_society table if it doesn't exist
Config.RunSqlSociety = true

-- Run SQL to create the lgf_jobs table if it doesn't exist
Config.RunSqlJob = true

-- Flag to indicate whether to create societies based on SocietyToCreate data
Config.CreateSociety = false

-- List of societies to create, each with specified parameters
Config.SocietyToCreate = {
    {
        Name = 'police',                 -- Name of the society (e.g., police)
        StartSocietyFunds = 3000,        -- Initial funds allocated to the society
        Shared = true                    -- Flag indicating if funds are shared among members
    },
    {
        Name = 'ambulance',            
        StartSocietyFunds = 3000,       
        Shared = false                   
    },
}


