--
-- Move apps to a position of a screen when they start or a new screen is connected.
--
local logger = hs.logger.new('window_arranger', 'info')

wl = require('window_lib')
tl = require('table_lib')
no = require('notification_lib')
timer = require('timer_lib')

wa = {}

-- Screen 2 right
center1Apps = {'Reminders', 'Notes'}

-- Screen 3 left
center2Apps = {'Anki', 'Terminal', 'KakaoTalk'}

-- Fullscreen
screen2Apps = {'Chrome'}
screen3Apps = {'Calendar', 'Affinity Photo', 'IntelliJ IDEA', 'Safari', 'Google Chat', 'Brave Browser', 'Google Chrome Canary'}

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

function arrangeAllWindows()
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

-- An app has a list of rules.
-- A rule returns a list of a list: {win, screen number}
local rules = {['iTerm2'] = {function()
  local targetScreen = 3
  local screen3AppTabCount = 4
  local allWins = hs.application.get('iTerm2'):allWindows()

  for _, win in ipairs(allWins) do
    if win:tabCount() == screen3AppTabCount then
      return {win, targetScreen}
    end
  end
end}}

function arrangeAllWindowsWithRules()
  for appName, appRules in pairs(rules) do
    for i, rule in ipairs(appRules) do
      local winAndTargetScreen = rule()

      -- This sometimes happens when starting up.
      -- Is it because win doesn't return proper tab count?
      if winAndTargetScreen and #winAndTargetScreen == 0 then
        logger:info(appName .. ': no matching window for the rule ' .. i)
        return
      end

      local win = winAndTargetScreen[1]
      local screenNumber = winAndTargetScreen[2]

      wl.moveWindowToDisplay(win, screenNumber)
      wl.fullscreen(win)
    end
  end
end

-- App watcher
function wa.appWatcherHandler(appName, eventType, appObject)
  --logger:d('appWatcher', appName, eventType, appObject)
  if (eventType == hs.application.watcher.launched) and
    (#hs.screen.allScreens() == 3) then

    logger:d('appWatcherHandler', 'launched with screen 3', appName)

    function launchCompleted()
      logger:d('Waiting an app to be launched: ' .. appName)
      return hs.application.get(appName):mainWindow()
    end

    function onLaunchCompleted()
      arrangeAllWindows(appName)
    end

    function onLaunchFailed()
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
function wa.screenWatcherHandler()
  logger:d('screenWatcherHandler', 'number of screens', #hs.screen.allScreens())

  if (#hs.screen.allScreens() == 3) then
    arrangeAllWindows()
    arrangeAllWindowsWithRules()
  end
end

wa.appWatcher = hs.application.watcher.new(wa.appWatcherHandler)
wa.appWatcher:start()

wa.screenWatcher = hs.screen.watcher.new(wa.screenWatcherHandler)
wa.screenWatcher:start()

