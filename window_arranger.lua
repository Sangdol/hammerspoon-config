--
-- Move apps to a position of a screen when they start or a new screen is connected.
--
local logger = hs.logger.new('window_arranger', 5)

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
screen3Apps = {'Calendar', 'Affinity Photo', 'iTerm2', 'IntelliJ IDEA', 'Safari', 'Google Chat', 'Brave Browser'}

function arrangeWindows(appName)
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
      arrangeWindows(appName)
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
  end
end

wa.appWatcher = hs.application.watcher.new(wa.appWatcherHandler)
wa.appWatcher:start()

wa.screenWatcher = hs.screen.watcher.new(wa.screenWatcherHandler)
wa.screenWatcher:start()

