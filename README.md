🔨 Hammerspoon Config 🥄
===

[Hammerspoon](https://www.hammerspoon.org/) configuration for automating macOS using Lua.

Development Environment
---

I use Neovim with [coc](https://github.com/neoclide/coc.nvim) and [coc-lua](https://github.com/josa42/coc-lua) plugins to write Lua code.

Project structure
---

```lua
 init.lua                -- The starting point of Hammerspoon that loads all modules
 caffeinate.lua          -- Sleep and wakeup hooks
 dnd.lua                 -- Do Not Disturb management
 finder.lua              -- Better Finder behavior
 window_arranger.lua     -- Automating arranging application windows in multi-screen environment
 window_shortcuts.lua    -- Shortcuts to arrange and focus applications
 README.md
 LICENSE
 lib/                    -- Utility functions and wrappers that provide easier APIs
│  bluetooth_lib.lua
│  dnd_lib.lua
│  notification_lib.lua
│  string_lib.lua
│  table_lib.lua
│  timer_lib.lua
│  wifi_lib.lua
└  window_lib.lua
```

See also
---

* [Hammerspoon Homepage](http://www.hammerspoon.org/)
* [Hammerspoon GitHub Repository](https://github.com/Hammerspoon/hammerspoon)
* [Lua Test Driven Learning Project](https://github.com/Sangdol/lua-test-driven-learning)

License
---

MIT
