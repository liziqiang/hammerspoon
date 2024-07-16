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
    self.gateway = { 'Wi-Fi', 'USB 10/100/1000 LAN' }
    ssidChangedCallback()
    wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
    wifiWatcher:start()
end

function ssidChangedCallback()
    if ssidChangeTimer ~= nil then
        ssidChangeTimer:stop()
    end
    ssidChangeTimer = hs.timer.doAfter(1, function ()
        local index = 0
        local isProxyEnabled
        local enabled = 'Enabled: Yes'
        local ssid = hs.wifi.currentNetwork()
        repeat
           index = index + 1
           local succ, output = hs.osascript.applescript('do shell script "networksetup -getwebproxy \\"' .. obj.gateway[index] .. '\\""')
           isProxyEnabled = succ and string.find(output, enabled) ~= nil
           print(index, output)
        until( isProxyEnabled or index >= #obj.gateway )
        if hs.fnutils.contains(obj.ssidToEnableProxy, ssid) then
            if not isProxyEnabled then
                toggleProxy()
            end
        else
            if isProxyEnabled then
                toggleProxy()
            end
        end
    end)
    ssidChangeTimer:start()
end

-- 检测电源是否为AC，如果是则启动时间机器
function handleBattery()
    if batteryWatcher == nil then
        batteryWatcher = hs.battery.watcher.new(function ()
            if hs.battery.powerSource() == 'AC Power' then
                hs.osascript.applescript('do shell script "tmutil startbackup"')
            end
        end)
        batteryWatcher:start()
    end
end

function toggleProxy()
    hs.eventtap.keyStroke({"cmd", "shift", "alt", "ctrl"}, "m")
    -- hs.osascript.applescript('tell application "ClashX" to toggleProxy')
end

return obj
