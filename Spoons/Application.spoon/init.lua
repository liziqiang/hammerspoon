local obj = {}
obj.__index = obj

-- Metadata
obj.name = "App"
obj.version = "1.0"
obj.author = "liziqiang <ziqiang.lee@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

function obj:init()
    -- 定义需要加载的App
    local hspoon_list = {"Alfred 5", "Bartender 5", "Clash Verge", "iShot Pro", "PopClip"}

    -- 加载App
    for _, v in pairs(hspoon_list) do
        hs.application.launchOrFocus(v)
    end
end

return obj
