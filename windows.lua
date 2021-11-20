function resize(ratio)
  return function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    margin = (1 - ratio) / 2

    f.w = max.w * ratio
    f.h = max.h * ratio
    f.x = max.x + (max.w * margin)
    f.y = max.y + (max.h * margin)
    win:setFrame(f)
  end
end

hs.hotkey.bind({"cmd", "alt"}, "1", resize(0.9))
hs.hotkey.bind({"cmd", "alt"}, "2", resize(0.8))
hs.hotkey.bind({"cmd", "alt"}, "3", resize(0.7))
hs.hotkey.bind({"cmd", "alt"}, "4", resize(0.6))

function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")
