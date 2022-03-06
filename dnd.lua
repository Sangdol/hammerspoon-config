--
-- Enable / disable Do Not Disturb and Bluetooth based on conditions
--

local dnd = require('lib/dnd_lib')
local bt = require('lib/bluetooth_lib')
local tl = require('lib/table_lib')
local st = require('lib/string_lib')

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

DndAppWatcher = hs.application.watcher.new(appWatcherHandler)
DndAppWatcher:start()
