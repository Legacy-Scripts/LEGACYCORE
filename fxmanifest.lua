fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'ENT510'
version '1.0.0'


repository 'https://github.com/Legacy-Framework/LEGACYCORE'

shared_script {'initcore.lua'}
shared_scripts {
    '@ox_lib/init.lua',
    'configuration.lua',
    'locales/initLocales.lua',
    'locales/lang/*.lua',
    'modules/shared/shared_functions.lua',
}

client_scripts {
    'modules/client/components/utils.lua',
    'modules/client/main.lua',
    'modules/client/components/playerStatus.lua',
    'modules/client/events.lua',
    'modules/client/playerdata.lua',
    'modules/client/components/command.lua',
    'modules/client/components/cache.lua',
}

server_scripts {
    'modules/server/components/connecting.lua',
    'modules/server/components/query.lua',
    'modules/server/components/utils.lua',
    'modules/server/main.lua',
    'modules/server/playerdata.lua',
    'modules/server/events.lua',
    'modules/server/components/command.lua',
}


files {
    'modules/client/constructor.lua',
    'eventWhitelist.json',
}

dependencies {
    '/native:0xA61C8FC6',
}
