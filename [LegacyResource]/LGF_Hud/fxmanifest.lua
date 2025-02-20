fx_version 'cerulean'

game 'gta5'

version '1.0.0'

lua54 'yes'

shared_scripts {
  'shared/*.lua',
  '@ox_lib/init.lua',
}

client_scripts {
  'client/modules/components/notify.lua',
  'client/modules/callback.lua',
  'client/modules/components/minimap.lua',
  'client/modules/components/cinematic.lua',
}


server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/**/*'
}

files {
  'client/modules/bridge/qbSpawn.lua',
  'client/modules/bridge/Framework.lua',
  'client/modules/components/functions.lua',
  'locales/*.json',
  'web/build/index.html',
  'web/build/**/*',
}

ox_libs { 'locale' }

ui_page 'web/build/index.html'
