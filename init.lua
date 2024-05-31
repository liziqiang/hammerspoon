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
