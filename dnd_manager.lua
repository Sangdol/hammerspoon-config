--
-- Enable / disable DND and Bluetooth based on conditions
--

local dnd = require('dnd_lib')
local bt = require('bluetooth_lib')
local tl = require('table_lib')
local st = require('string_lib')

local logger = hs.logger.new('dnd_manager', 5)

local dndApps = {'Melodics', 'Movist'}

local function appWatcherHandler(appName, eventType, appObject)
  if (not tl.isInList(dndApps, appName)) then
    return
  end

  if (eventType == hs.application.watcher.launched) and
    (tl.isInList(dndApps, appName)) then
    dnd.turnOn()
    bt.turnOff()
  elseif (eventType == hs.application.watcher.terminated) then
    dnd.turnOff()
    bt.conditionallyConnect()
  end
end

dndAppWatcher = hs.application.watcher.new(appWatcherHandler)
dndAppWatcher:start()
