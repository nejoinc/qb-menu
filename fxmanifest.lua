fx_version 'cerulean'
game 'gta5'

description 'QB-Menu'
version '1.0.0'



client_scripts {
    'client/*.lua'
}


server_scripts {
    'server/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css',
    'html/assets/images/*.*',
    'html/assets/sonido/*.*',
}

lua54 'yes'
