fx_version 'cerulean'
game 'gta5'
author 'dnj'
lua54 "on"
shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua'
}
client_scripts {
    'client/*.lua'
}
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}