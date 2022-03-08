--
-- Window Arranger
--
--   Arrange applications when they start up or multiple screens are connected.
--

local wl = require('lib/window_lib')
local tl = require('lib/table_lib')
local no = require('lib/notification_lib')
local timer = require('lib/timer_lib')
local logger = hs.logger.new('window_arranger', 'debug')

Wa = {}

-- Screen 2 right
local center1Apps = {'Reminders', 'Notes'}

-- Screen 3 left
local center2Apps = {'Anki', 'Terminal', 'KakaoTalk'}

-- Fullscreen
local screen2Apps = {'Google Chrome'}
local screen3Apps = {'Calendar', 'Affinity Photo', 'IntelliJ IDEA', 'Safari',
  'Google Chat', 'Brave Browser', 'Google Chrome Canary'}

local function arrangeWindows(appName)
  logger:d('Arranging ' .. appName)
  local app = hs.application.get(appName)

  if (not app) then
    logger:d("Couldn't get the app: " .. appName)
    return
  else
    logger:d(app, "App found: " .. appName)
  end

  local win = app:mainWindow()

  if (tl.isInList(center1Apps, appName)) then
    wl.moveWindowToCenter1(win)
  elseif (tl.isInList(center2Apps, appName)) then
    wl.moveWindowToCenter2(win)
  elseif (tl.isInList(screen2Apps, appName)) then
    -- For some reason, windows shrink to right or left.
    wl.moveWindowToDisplay(win, 2)
    wl.fullscreen(win)
  elseif (tl.isInList(screen3Apps, appName)) then
    wl.moveWindowToDisplay(win, 3)
    wl.fullscreen(win)
  end
end

function Wa.arrangeAllWindows()
  logger:d('Arranging all windows')

  for _, appNames in ipairs({center1Apps, center2Apps, screen2Apps, screen3Apps}) do
    for _, appName in ipairs(appNames) do
      -- pcall to ignore this error
      -- ERROR:   LuaSkin: hs.screen.watcher callback: ...oon.app/Contents/Resources/extensions/hs/window/init.lua:922: not a rect
      -- similar issue: https://github.com/Hammerspoon/hammerspoon/issues/2507
      local status, err = pcall(arrangeWindows, appName)

      if (not status) then
        print(err)
      end
    end
  end
end

-- Rules has AppRules.
--
--    rules = [appRules, appRules, ...]
--    appRules = [rule, rule, ...]
--
-- A rule returns {win, targetScrenNumber} or {}.
local rules = {['iTerm2'] = {function()
  local targetScreen = 3
  local screen3AppTabCount = 4

  return timer.safeBlockedTimer(function()
    -- When a laptop restarts win:tabCount() returns 0
    -- probably due to a race condition.
    -- This checks until the application is fully initialized
    -- so it can return a right tab count.
    local allWins = hs.application.get('iTerm2'):allWindows()

    if not tl.empty(allWins) then
      local tabCount = allWins[1]:tabCount()
      logger:d('Tab count checking: ' .. tabCount)
      return tabCount > 0
    else
      logger:d('allWins are empty.')
    end

    return false
  end, function()
    local allWins = hs.application.get('iTerm2'):allWindows()
    for _, win in ipairs(allWins) do
      logger:d('Tab count: ' .. win:tabCount())
      if win:tabCount() == screen3AppTabCount then
        return {win, targetScreen}
      end
    end

    return {}
  end, function()
    logger:w('Failed to load tab count of iTerm2.')
  end, 20)
end}}

function Wa.arrangeAllWindowsWithRules()
  for appName, appRules in pairs(rules) do
    for i, rule in ipairs(appRules) do
      local win, screenNumber = table.unpack(rule())

      if not win then
        logger:i(appName .. ': no matching window for the rule ' .. i)
        return
      end

      wl.moveWindowToDisplay(win, screenNumber)
      wl.fullscreen(win)
    end
  end
end

-- App watcher
function Wa.appWatcherHandler(appName, eventType)
  --logger:d('appWatcher', appName, eventType, appObject)
  if (eventType == hs.application.watcher.launched) and
    (#hs.screen.allScreens() == 3) then

    logger:d('appWatcherHandler', 'launched with screen 3', appName)

    local function launchCompleted()
      logger:d('Waiting an app to be launched: ' .. appName)
      return hs.application.get(appName):mainWindow()
    end

    local function onLaunchCompleted()
      Wa.arrangeAllWindows()
    end

    local function onLaunchFailed()
      no.notify('appWatcherHandler waited for ' .. appName .. ' too long')
    end

    local TRIAL = 10

    -- It takes time until hs can find an app after an app is launched.
    -- It depends on the app and it take longer if the app is heavy.
    -- This checks the predicate every second.
    -- https://www.hammerspoon.org/docs/hs.timer.html#waitUntil
    timer.safeWaitUntil(launchCompleted, onLaunchCompleted, onLaunchFailed, TRIAL)
  end
end

-- Screen watcher
function Wa.screenWatcherHandler()
  logger:d('screenWatcherHandler', 'number of screens', #hs.screen.allScreens())

  if (#hs.screen.allScreens() == 3) then
    Wa.arrangeAllWindows()
    Wa.arrangeAllWindowsWithRules()
  end
end

Wa.appWatcher = hs.application.watcher.new(Wa.appWatcherHandler)
Wa.appWatcher:start()

Wa.screenWatcher = hs.screen.watcher.new(Wa.screenWatcherHandler)
Wa.screenWatcher:start()

