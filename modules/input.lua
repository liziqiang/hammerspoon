-- 自动切换输入法
function watchApplicationSwitch()
    local ime2Source = {
        ABC = 'com.apple.keylayout.ABC',
        RIME = 'im.rime.inputmethod.Squirrel.Rime',
    }

    -- app to expected ime config
    -- app和对应的输入法
    local app2Ime = {
        ['/Applications/Alfred.app'] = 'ABC',
        ['/Applications/iTerm.app'] = 'ABC',
        ['/Applications/Visual Studio Code.app'] = 'ABC',
        ['/Applications/Xcode.app'] = 'ABC',
        ['/Applications/Microsoft Edge.app'] = 'ABC',
    }

    function updateFocusAppInputMethod()
        local focusAppPath = hs.window.frontmostWindow():application():path()
        local applicationIme = app2Ime[focusAppPath]

        if applicationIme then
            hs.keycodes.currentSourceID(ime2Source[applicationIme])
        end
    end

    -- helper hotkey to figure out the app path and name of current focused window
    -- 当选中某窗口按下ctrl+command+.时会显示应用的路径等信息
    -- hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
    --     hs.alert.show("App path:        "
    --     ..hs.window.focusedWindow():application():path()
    --     .."\n"
    --     .."App name:      "
    --     ..hs.window.focusedWindow():application():name()
    --     .."\n"
    --     .."IM source id:  "
    --     ..hs.keycodes.currentSourceID())
    -- end)

    -- Handle cursor focus and application's screen manage.
    -- 窗口激活时自动切换输入法
    function applicationWatcher(appName, eventType, appObject)
        if (eventType == hs.application.watcher.activated or eventType == hs.application.watcher.launched) then
            updateFocusAppInputMethod()
        end
    end

    appWatcher = hs.application.watcher.new(applicationWatcher)
    appWatcher:start()
end

-- 输入法切换提示
function watchInputSourceChange()
    hs.keycodes.inputSourceChanged(function()
        local currentSourceID = hs.keycodes.currentSourceID()
        local currentSourceText = currentSourceID:sub(string.find(currentSourceID, '%w+$')):upper()
        
        -- 关闭重复提示
        hs.alert.closeSpecific(showUUID)

        showUUID = hs.alert.show(currentSourceText, {
            textSize = 40,
            padding = 50
        })

    end)
end

watchApplicationSwitch()
watchInputSourceChange()
