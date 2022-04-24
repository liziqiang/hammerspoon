-- 重置alert默认样式
hs.alert.defaultStyle.fillColor = {
    white = 0,
    alpha = 0.5
}
hs.alert.defaultStyle.strokeColor = {
    alpha = 0
}

-- 定义需要加载的spoon
if not hspoon_list then
    hspoon_list = {"BingDaily", "Input Switcher", "Weather", "Reload Config"}
end

-- 加载Spoon
for _, v in pairs(hspoon_list) do
    hs.loadSpoon(v)
end
