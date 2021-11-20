--
-- Move apps to a position of a screen when they start or a new screen is connected.
--
logger = hs.logger.new('window_arranger', 5)

wl = require('window_lib')
tl = require('table_lib')

wa = {}

-- Screen 2 right
center1Apps = {'Reminders', 'Notes'}

-- Screen 3 left
center2Apps = {'Anki', 'Terminal', 'KakaoTalk'}

-- Fullscreen
screen2Apps = {'Chrome'}
screen3Apps = {'Calendar', 'Affinity Photo', 'iTerm2', 'IntelliJ IDEA', 'Safari', 'Google Chat'}

function arrangeWindows(appName)
    logger:d('Arranging ' .. appName)
    local win = hs.application.find(appName):mainWindow()
    assert(win, "Couldn't find the app: " .. appName)

    if (tl.isin(center1Apps, appName)) then
      wl.moveWindowToCenter1(win)
    elseif (tl.isin(center2Apps, appName)) then
      wl.moveWindowToCenter2(win)
    elseif (tl.isin(screen2Apps, appName)) then
      wl.moveWindowToDisplay(win, 2)
      wl.fullscreen(win)
    elseif (tl.isin(screen3Apps, appName)) then
      wl.moveWindowToDisplay(win, 3)
      wl.fullscreen(win)
    end
end

-- App watcher
function wa.appWatcherHandler(appName, eventType, appObject)
  if (eventType == hs.application.watcher.launched) and
    (#hs.screen.allScreens() == 3) then

    logger:d('appWatcherHandler', 'launched with screen 3', appName)

    function launchCompleted()
      logger:d('Waiting an app to be launched: ' .. appName)
      return hs.application.find(appName):mainWindow()
    end

    -- It takes time until hs can find an app after an app is launched.
    -- It depends on the app and it take longer if the app is heavy.
    -- This checks the predicate every second.
    -- https://www.hammerspoon.org/docs/hs.timer.html#waitUntil
    hs.timer.waitUntil(launchCompleted, function()
      arrangeWindows(appName)
    end)
  end
end

-- Screen watcher
function wa.screenWatcherHandler()
  logger:d('screenWatcherHandler', 'number of screens', #hs.screen.allScreens())

  if (#hs.screen.allScreens() == 3) then
    winLists1 = wl.moveAppsToDisplay(screen2Apps, 2)
    winLists2 = wl.moveAppsToDisplay(screen3Apps, 3)

    -- For some reason, windows shrink to right or left.
    -- Adding this to avoid it.
    for _, winList in ipairs(tl.concat(winLists1, winLists2)) do
      for _, win in ipairs(winList) do
        --logger:d('fullscreening', win)
        wl.fullscreen(win)
      end
    end
  end
end

appWatcher = hs.application.watcher.new(wa.appWatcherHandler)
appWatcher:start()

screenWatcher = hs.screen.watcher.new(wa.screenWatcherHandler)
screenWatcher:start()

