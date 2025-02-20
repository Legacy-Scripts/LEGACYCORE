fx_version 'cerulean'

game 'gta5'

version '1.1.0'

lua54 'yes'

shared_scripts {
  'shared/*.lua',
  '@ox_lib/init.lua',

}

client_scripts {
  'modules/client/cl-nui.lua',
  'modules/client/cl-functions.lua',
  'modules/client/cl-main.lua',
  'modules/client/cl-cam.lua',
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'modules/server/sv-characters.lua',
  'modules/server/sv-callback.lua',
  'modules/server/sv-main.lua',
}

files {
  'locales/*.json',
  'web/build/index.html',
  'web/build/**/*',
}

ox_libs { 'locale' }

ui_page 'web/build/index.html'
