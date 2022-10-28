-- Nothing triggers

hs.window.filter.default:subscribe(hs.window.filter.windowChanged, function(win, appName)
    logger:d(appName, 'windowChanged')
end)

hs.window.filter.default:subscribe(hs.window.filter.windowUnfocused, function(win, appName)
    logger:d(appName, 'windowUnfocused')
end)

hs.window.filter.default:subscribe(hs.window.filter.windowVisible, function(win, appName)
    logger:d(appName, 'windowVisible')
end)
