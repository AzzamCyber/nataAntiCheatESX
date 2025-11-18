fx_version 'cerulean'
game 'gta5'

author 'ChatGPT x Pribzack'
description 'Anti Cheat: Spam & Mencurigakan Explosion Detection + Auto Ban + Discord Log'
version '1.0.0'

server_script {
    '@mysql-async/lib/MySQL.lua', -- atau ganti dengan oxmysql jika pakai itu
    'server.lua'
}
