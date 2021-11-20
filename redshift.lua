--
-- https://www.hammerspoon.org/docs/hs.redshift.html
--

-- start redshift: 2800K + inverted from 21 to 5, very long transition duration (19->23 and 3->7)
-- Color Temperature https://en.wikipedia.org/wiki/Color_temperature
hs.redshift.start(2200, '20:00', '5:00', '4h', true, wfRedshift)

-- allow manual control of inverted colors
hs.hotkey.bind('ctrl-cmd-alt-shift', 'r', 'Invert', hs.redshift.toggle)
