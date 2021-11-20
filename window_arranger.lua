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

-- App watcher
function wa.appWatcherHandler(appName, eventType, appObject)
  if (eventType == hs.application.watcher.launched) and
    (#hs.screen.allScreens() == 3) then

    logger:d('appWatcherHandler', 'launched with screen 3', appName)

    -- A delay is added since Calendar wasn't found when running without a delay.
    -- https://www.hammerspoon.org/docs/hs.timer.html#usleep
    hs.timer.usleep(120 * 1000) -- 120 ms (failed at 100 ms)
    local win = hs.application.find(appName):mainWindow()

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

