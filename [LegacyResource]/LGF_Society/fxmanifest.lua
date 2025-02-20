fx_version 'adamant'
game 'gta5'
lua54 'yes'
description 'Provider for Crete Job or Society and Management'
author 'ENT510'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'modules/client/society.lua',
    'modules/client/jobs.lua'
}

server_scripts {
    'modules/server/society.lua',
    'modules/server/jobs.lua'
}

