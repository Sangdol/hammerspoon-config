--
-- Redshift - it's not being used due to a few issues.
-- https://www.hammerspoon.org/docs/hs.redshift.html
--

-- start redshift: 2800K + inverted from 21 to 5, very long transition duration (19->23 and 3->7)
-- Color Temperature https://en.wikipedia.org/wiki/Color_temperature
hs.redshift.start(2200, '20:00', '5:00', '4h', true)

-- allow manual control of toggle
hs.hotkey.bind('ctrl-cmd-alt-shift', 'r', 'Toggle', hs.redshift.toggle)

-- I don't know why but it was enabled once and couldn't revert without this.
hs.hotkey.bind('ctrl-cmd-alt-shift', 'i', 'ToggleInvert', hs.redshift.toggleInvert)
