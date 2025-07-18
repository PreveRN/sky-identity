fx_version 'cerulean'
game 'gta5'

description 'Sky Identity - Passport Registration System'
author 'SkyInside'
version '1.0.0'

shared_script '@es_extended/imports.lua'

client_script 'client.lua'
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

ui_page 'html/index.html'
