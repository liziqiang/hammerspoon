local obj = {}
obj.__index = obj

-- Metadata
obj.name = "WiFi"
obj.version = "1.0"
obj.author = "liziqiang <ziqiang.lee@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

function WiFiWatcherCallback()
    if ssidChangeTimer ~= nil then
        ssidChangeTimer:stop()
    end
    ssidChangeTimer = hs.timer.doAfter(1, function()
        -- 通过ping检测是否需要连接代理
        hs.network.ping.ping("google.com", 5, 1.0, 2.0, "any", function(server, eventType)
            local isProxyEnabled = obj:isProxyEnabled()
            -- 如果可以访问谷歌且代理打开则关闭代理
            if eventType == "receivedPacket" then
                if isProxyEnabled then
                    obj:toggleProxy()
                end
            else
                -- 如果不可以访问谷歌且代理未打开则打开代理
                if not isProxyEnabled then
                    obj:toggleProxy()
                end
            end
        end)
    end)
    ssidChangeTimer:start()
end

function obj:isProxyEnabled()
    local index = 0
    local isProxyEnabled
    local enabled = 'Enabled: Yes'
    local gateway = { 'Wi-Fi', 'USB 10/100/1000 LAN' }
    repeat
        index = index + 1
        local succ, output = hs.osascript.applescript('do shell script "networksetup -getwebproxy \\"' ..
            obj.gateway[index] .. '\\""')
        isProxyEnabled = succ and string.find(output, enabled) ~= nil
        print(index, output)
    until (isProxyEnabled or index >= #gateway)
end

function obj:toggleProxy()
    hs.eventtap.keyStroke({ "cmd", "shift", "alt", "ctrl" }, "m")
    -- hs.osascript.applescript('tell application "ClashX" to toggleProxy')
end

function obj:init()
    wifiWatcher = hs.wifi.watcher.new(WiFiWatcherCallback)
    wifiWatcher:start()
    WiFiWatcherCallback()
end

return obj
