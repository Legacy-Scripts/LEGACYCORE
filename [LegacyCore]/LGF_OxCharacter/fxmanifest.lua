fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'ENT510'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/shared.lua',
    'shared/traduction.lua',
}

client_scripts {
    'modules/client/utils.lua',
    'modules/client/main.lua',
    'modules/client/spawnSelector.lua',
    'modules/client/login.lua'
}


server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'modules/server/main.lua',
    'modules/server/command.lua'
}
