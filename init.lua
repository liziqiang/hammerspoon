-- 重置alert默认样式
hs.alert.defaultStyle.fillColor = { white = 0, alpha = 0.5 }
hs.alert.defaultStyle.strokeColor = { white = 0, alpha = 0.5 }

local directory = "modules"
for file in hs.fs.dir(directory) do
    -- 获取文件名称
    local filename = file:sub(0, -5);
    if string.len(filename) > 0
    then
        require(directory.."/"..filename)
    end
end
