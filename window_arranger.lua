--
-- Window Arranger
--
--   Arrange applications when they start up
--

local logger = hs.logger.new('window_arranger', 'info')

-- Global for debugging
Wa = {}

-- Screen 1 right
local center1Apps = {'KakaoTalk', 'Anki', 'Notes'}

-- Screen 2 left
local center2Apps = {'Terminal', 'Reminders'}

-- Fullscreen
local screen1Apps = {'Google Chrome'}
local screen2Apps = {'Microsoft Edge', 'Slack', 'Safari', 'iTerm2'}

local function arrangeWindowsForOneScreen(app, appName)
  local win = app:mainWindow()

  if (tl.isInList(center1Apps, appName) or tl.isInList(center2Apps, appName)) then
    sc.moveWindowToCenter1(win)
  elseif (tl.isInList(screen1Apps, appName)) then
    wl.fullscreen(win)
  elseif (tl.isInList(screen2Apps, appName)) then
    wl.fullscreen(win)
  end
end

local function arrangeWindowsForMultiScreens(app, appName)
  local win = app:mainWindow()

  if (tl.isInList(center1Apps, appName)) then
    sc.moveWindowToCenter1(win)
  elseif (tl.isInList(center2Apps, appName)) then
    sc.moveWindowToCenter2(win)
  elseif (tl.isInList(screen1Apps, appName)) then
    sc.moveAllWindowsToBiggestScreenWithAppName(appName, 1, true)
  elseif (tl.isInList(screen2Apps, appName)) then
    sc.moveAllWindowsToBiggestScreenWithAppName(appName, 2, true)
  end
end

local function arrangeWindows(appName)
  logger:d('Arranging: ' .. appName)
  local app = hs.application.find(appName, true)

  if (not app) then
    logger:d("Couldn't get the app: " .. appName)
    return
  else
    logger:d(app, "App found: " .. appName)
  end

  local screenCount = #hs.screen.allScreens()
  if screenCount == 1 then
    arrangeWindowsForOneScreen(app, appName)
  elseif screenCount > 1 then
    arrangeWindowsForMultiScreens(app, appName)
  else
    logger:w('Do you have zero screen? Screen count: ' .. screenCount )
  end
end

-- App watcher
function Wa.appWatcherHandler(appName, eventType)
  logger:d('appWatcher', appName, eventType)

  if (eventType == hs.application.watcher.launched) then
    logger:d('appWatcherHandler', 'launched with all screens', appName)

    local function launchCompleted()
      logger:d('Waiting an app to be launched: ' .. appName)
      return hs.application.get(appName):mainWindow()
    end

    local function onLaunchCompleted()
      arrangeWindows(appName)
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

Wa.appWatcher = hs.application.watcher.new(Wa.appWatcherHandler)
Wa.appWatcher:start()

