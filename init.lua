-- 重置alert默认样式
hs.alert.defaultStyle.fillColor = {
    white = 0,
    alpha = 0.5
}
hs.alert.defaultStyle.strokeColor = {
    alpha = 0
}

-- 定义不需要加载的spoon，默认下载所有
hspoon_list = {"USB", "BingDaily", "Weather", "WiFi"}

-- 加载Spoon
for _, v in pairs(hs.spoons.list()) do
    if not hs.fnutils.contains(hspoon_list, v.name) then
        hs.loadSpoon(v.name)
    end
end

-- 检测电源是否为AC，如果是则启动时间机器
--function obj:handleBattery()
--    if batteryWatcher == nil then
--        batteryWatcher = hs.battery.watcher.new(function()
--            if hs.battery.powerSource() == 'AC Power' then
--                hs.osascript.applescript('do shell script "tmutil startbackup"')
--            end
--        end)
--        batteryWatcher:start()
--    end
--end
