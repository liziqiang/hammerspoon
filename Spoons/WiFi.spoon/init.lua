local obj = {}
obj.__index = obj

-- Metadata
obj.name = "WiFi"
obj.version = "1.0"
obj.author = "liziqiang <ziqiang.lee@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"



function obj:init()
    -- 需要自动启用代理的SSID列表
    self.ssidToEnableProxy = { 'bazinga' }
    ssidChangedCallback()
    wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
    wifiWatcher:start()
end

function ssidChangedCallback()
    if ssidChangeTimer ~= nil then
        ssidChangeTimer:stop()
    end
    ssidChangeTimer = hs.timer.doAfter(1, function ()
        obj.ssid = hs.wifi.currentNetwork()
        obj.succ, obj.output = hs.osascript.applescript('do shell script "networksetup -getwebproxy Wi-Fi"')
        local isProxyEnabled = obj.succ and string.find(obj.output, 'Enabled: Yes') ~= nil
        if hs.fnutils.contains(obj.ssidToEnableProxy, obj.ssid) then
            if not isProxyEnabled then
                hs.osascript.applescript('tell application "ClashX" to toggleProxy')
            end
        else
            if isProxyEnabled then
                hs.osascript.applescript('tell application "ClashX" to toggleProxy')
            end
        end
    end)
    ssidChangeTimer:start()
end

return obj
