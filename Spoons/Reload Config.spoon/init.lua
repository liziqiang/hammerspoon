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
    function reloadConfig()
        configFileWatcher:stop()
        configFileWatcher = nil
        hs.reload()
    end
    configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon", reloadConfig)
    configFileWatcher:start()
    hs.alert.show("Config Reloaded", {
        textSize = 30,
        padding = 30
    }, 1)
end

return obj
