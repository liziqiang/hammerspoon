local obj={}
obj.__index = obj

-- Metadata
obj.name = "Reload"
obj.version = "1.0"
obj.author = "liziqiang <ziqiang.lee@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

function obj:init()
    -- http://www.hammerspoon.org/go/#fancyreload
	function reloadConfig(files)
		doReload = false
		for _, file in pairs(files) do
			if file:sub(-4) == ".lua" then
				doReload = true
			end
		end
		if doReload then
			hs.reload()
		end
	end

	hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon", reloadConfig):start()
	hs.alert.show("Config Reloaded", {
		textSize = 30,
		padding = 30
	}, 1)
end

return obj
