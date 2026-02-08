fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'SenslessStudios'
description 'Modern Admin To-Do System for FiveM'
version '1.0.1'

escrow_ignore {
    'config.lua',
    'changelog.txt',
    'README.md',
    'server/discord.lua',
    'locals/*.lua'
}

shared_scripts {
    'config.lua',
    'server/locale.lua',
    'client/locale.lua',
    'locals/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/discord.lua',
    'server/framework.lua',
    'server/server.lua'
}

client_scripts {
    'client/framework.lua',
    'client/client.lua'
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/ui.css',
    'html/ui.js'
}
