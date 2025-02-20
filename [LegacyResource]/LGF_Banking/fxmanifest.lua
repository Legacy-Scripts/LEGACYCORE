fx_version 'cerulean'

game 'gta5'

version '1.1.0'

lua54 'yes'

shared_scripts {
  'init.lua',
  'shared/Config.lua',
  'shared/Shared.lua',
  '@ox_lib/init.lua',

}

client_scripts {
  'client/Editable.lua',
  'client/Functions.lua',
  'client/Nui.lua',
  'client/Modules/zone.lua',
  'client/Modules/data.lua',
  'client/Modules/atm.lua',
  'client/Modules/invoice.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/Editable.lua',
  'server/Functions.lua',
  'server/main.lua'
}

files {
  'locales/*.json',
  'web/build/index.html',
  'web/build/**/*',
}

ui_page 'web/build/index.html'
