local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Startup"
obj.version = "1.0"
obj.author = "liziqiang <ziqiang.lee@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

function obj:init()
    local index = 1
    -- 定义需要加载的App
    local app_list = { "Alfred 5", "Bartender 5", "Clash Verge", "iShot Pro", "PopClip", "AirBuddy" }
    repeat
        local script = 'id of app "' .. app_list[index] .. '"';
        local succ, bundle_id = hs.osascript.applescript(script)
        if succ then
            local isRunning = hs.application.get(bundle_id)
            if not isRunning then
                print(app_list[index], '未启动，启动中...')
                hs.application.launchOrFocusByBundleID(bundle_id)
            else
                print(app_list[index], '已启动')
            end
        end
        index = index + 1
    until (index > #app_list)
end

return obj
