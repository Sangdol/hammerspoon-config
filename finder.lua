--
-- Better Finder
--

local function applicationWatcher(appName, eventType, appObject)
  if (eventType == hs.application.watcher.activated) then
    if (appName == "Finder") then
      -- Bring all Finder windows forward when one gets activated
      appObject:selectMenuItem({"Window", "Bring All to Front"})
    end
  end
end

AppWatcher = hs.application.watcher.new(applicationWatcher)
AppWatcher:start()
