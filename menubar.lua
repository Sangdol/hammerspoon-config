--
-- Textbar replacement
--

local st = require('lib/string_lib')

local PATH_PREFIX = '$HOME/projects/osx/textbar'
local UPDATE_INTERVAL = 5

--local mailMenu = hs.menubar.new():setTitle('Mail…')
local pomoMenu = hs.menubar.new():setTitle('Pomo…')
local teaMenu = hs.menubar.new():setTitle('Tea…')

local function executeScript(scriptName)
  return st.trim(hs.execute(PATH_PREFIX .. '/' .. scriptName))
end

-- This has to be global not to be garbage collected.
MenubarTimer = hs.timer.new(UPDATE_INTERVAL, function()
  pomoMenu:setTitle(executeScript('pomo.sh'))
  teaMenu:setTitle(executeScript('tea.sh'))
end):start()

