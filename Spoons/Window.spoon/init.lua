local hk = require "hs.hotkey"
-- -----------------------------------------------------------------------
--                         ** Something Global **                       --
-- -----------------------------------------------------------------------
-- Comment out this following line if you wish to see animations
local windowMeta = {}
window = require "hs.window"
hs.window.animationDuration = 0
grid = require "hs.grid"
grid.setMargins('0, 0')

module = {}

-- Bind new method to windowMeta
function windowMeta.new()
    local self = setmetatable(windowMeta, {
        -- Treate table like a function
        -- Event listener when windowMeta() is called
        __call = function(cls, ...)
            return cls.new(...)
        end
    })

    self.window = window.focusedWindow()
    self.screen = window.focusedWindow():screen()
    -- 使用16 * 12网格
    self.screenGrid = grid.getGrid(self.screen)

    return self
end

-- -----------------------------------------------------------------------
--                   ** ALERT: GEEKS ONLY, GLHF  :C **                  --
--            ** Keybinding configurations locate at bottom **          --
-- -----------------------------------------------------------------------

-- 窗口最大化
module.maximizeWindow = function()
    local this = windowMeta.new()
    hs.grid.maximizeWindow(this.window)
end

-- 窗口剧中
module.centerOnScreen = function()
    local this = windowMeta.new()
    this.window:centerOnScreen(this.screen)
end
-- 自定义窗口尺寸
module.locate = function()
    local this = windowMeta.new()
    local cell = hs.geometry(this.screenGrid.w * 1 / 8, this.screenGrid.h * 1 / 12, this.screenGrid.w * 12 / 16, this.screenGrid.h * 8 / 12)
    grid.set(this.window, cell, this.screen)
end

-- 绑定快捷键
hk.bind({"shift", "cmd"}, "return", module.maximizeWindow)
hk.bind({"shift", "cmd"}, "space", module.centerOnScreen)
hk.bind({"shift", "cmd"}, "\\", module.locate)

return module
