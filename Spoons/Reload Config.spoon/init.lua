local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Reload Config"
obj.version = "1.0"
obj.author = "liziqiang <ziqiang.lee@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

function obj:init()
    local configFileWatcher
    function reloadConfig(paths)
        local changed = hs.fnutils.some(paths, function (elem)
            local ending = '.lua'
            return elem:sub(-#ending) == ending
        end)
        if changed then
            configFileWatcher:stop()
            configFileWatcher = nil
            hs.alert.show("Config Reloaded", {
                textSize = 32,
                padding = 24
            }, 1)
            hs.timer.doAfter(1, function()
                hs.reload()
            end)
        end
    end
    configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon", reloadConfig)
    configFileWatcher:start()

end

return obj
