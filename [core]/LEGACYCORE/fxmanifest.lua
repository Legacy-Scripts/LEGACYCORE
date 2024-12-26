fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'ENT510'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'common/configuration.lua',
    'locales/initLocales.lua',
    'locales/lang/*.lua',
    'initcore.lua',
    'modules/shared/shared_functions.lua',
}

client_scripts {
    'modules/client/main.lua',
    'modules/client/components/playerStatus.lua',
    'modules/client/events.lua',
    'modules/client/playerdata.lua',
    'modules/client/components/command.lua',
    'modules/client/components/cache.lua',
}

server_scripts {
    'common/sv-configuration.lua',
    'modules/server/components/connecting.lua',
    'modules/server/components/newPlayer.lua',
    'modules/server/main.lua',
    'modules/server/playerdata.lua',
    'modules/server/events.lua',
    'modules/server/callback.lua',
    'modules/server/components/command.lua',
    'modules/server/components/duty.lua',
}


files {
    'modules/client/constructor.lua',
}

dependencies {
    '/native:0xA61C8FC6',
}
