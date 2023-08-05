--
-- This is a hack to avoid an issue where the input sources toggle key is not working
-- after triggering Vimac's shortcut, especially for iTerm2 and browsers.
--

local function toggleInputSources()
    local app = hs.application.frontmostApplication()
    if app:name() ~= "Alfred" then
      -- This assumes that the following key combination
      -- is the key to trigger Vimac.
       hs.eventtap.keyStroke({"cmd"}, "space")
       hs.eventtap.keyStroke({"cmd"}, "space")
    end

    -- This assuems that the following key combination 
    -- is the key to toggle input sources.
    hs.eventtap.keyStroke({}, "f18")
end

hs.hotkey.bind({"ctrl", "shift", "alt", "cmd"}, "I", toggleInputSources)

