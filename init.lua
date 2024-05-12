--
-- Welcome to Hammerspoon
--

hs.loadSpoon("EmmyLua")

require('global')
require('custom_debug')
require('caffeinate')
require('window_mover')
require('window_arranger')
require('keyboard_shortcuts')
require('dnd')
require('menubar')
require('cursor')
require('volume')
require('quick_app')
require('keymou')

-- See custom_debug.lua for the reload trigger
no.notify('Hammerspoon loaded!')
