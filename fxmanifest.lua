-- This resource is part of the default Cfx.re asset pack (cfx-server-data)
-- Altering or recreating for local use only is strongly discouraged.

version '1.0.0'
author 'Cfx.re <root@cfx.re>'
description 'A GTA Online-styled theme for the chat resource.'
repository 'https://github.com/citizenfx/cfx-server-data'

-- Theme files
file 'style.css'
file 'shadow.js'

-- Scripts
server_script 'sv_chat.lua'
client_script 'cl_chat.lua'
shared_script '@ox_lib/init.lua'

chat_theme 'gtao' {
    styleSheet = 'style.css',
    script = 'shadow.js',
    msgTemplates = {
        default = '<b>{0}</b><span>{1}</span>'
    }
}

game 'common'
fx_version 'adamant'