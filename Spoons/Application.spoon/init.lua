local obj = {}
obj.__index = obj

-- Metadata
obj.name = "App"
obj.version = "1.0"
obj.author = "liziqiang <ziqiang.lee@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

function obj:init()
    local index = 1
    -- 定义需要加载的App
    local app_list = { "Alfred 5", "Bartender 5", "Clash Verge", "iShot Pro", "PopClip" }
    repeat
        local script = 'id of app "' .. app_list[index] .. '"';
        local succ, bundle_id = hs.osascript.applescript(script)
        if succ then
            local isRunning = hs.application.get(bundle_id)
            if not isRunning then
                hs.application.launchOrFocusByBundleID(bundle_id)
            end
        end
        index = index + 1
    until (index >= #app_list)
end

return obj
