local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Weather"
obj.version = "1.0"
obj.author = "liziqiang <ziqiang.lee@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

weaEmoji = {
    lei = '⚡️',
    qing = '☀️',
    shachen = '😷',
    wu = '🌫',
    xue = '❄️',
    yu = '🌧',
    yujiaxue = '🌨',
    yun = '⛅️',
    zhenyu = '🌧',
    yin = '☁️',
    default = ''
}

function obj:init()
    self.urlApi = 'https://www.tianqiapi.com/api/?version=v1&appid=46231859&appsecret=JLhEg5LS'
    self.menuData = {};
    self.menubar = hs.menubar.new(true)
    self.bindCaffeinate()
    self:delayGetWeather()
    self:checkWithInterval()
end

function obj:updateMenubar()
    self.menubar:setTooltip("天气预报")
    self.menubar:setMenu(self.menuData)
end

-- 定时更新数据
function obj:checkWithInterval()
    if obj.pollTimer then
        obj.pollTimer:stop()
    end
    obj.pollTimer = hs.timer.new(1800, function()
        self:delayGetWeather()
    end)
    obj.pollTimer:start()
end

function obj:bindCaffeinate()
    obj.cw = hs.caffeinate.watcher.new(function(eventType)
        if (eventType == hs.caffeinate.watcher.screensDidUnlock) then
            obj:delayGetWeather()
            obj:checkWithInterval()
        end
    end)
    obj.cw:start()
end

function obj:delayGetWeather()
    self:updateMenubar()
    self.menubar:setTitle('⌛')
    -- 定时更新数据
    obj.tm = hs.timer.doAfter(1, function()
        self:getWeather()
    end)
    obj.tm:start()
end

function obj:getWeather()
    print(string.format('-- %s: fetch weather data', obj.name))
    hs.http.doAsyncRequest(self.urlApi, "GET", nil, nil, function(code, body, htable)
        if code ~= 200 then
            hs.alert.show('fetch weather error:' .. code)
            return
        end
        rawjson = hs.json.decode(body)
        city = rawjson.city
        self.menuData = {}
        print(string.format('-- %s: update time is %s', obj.name, rawjson.update_time))
        local weatherItem = "%s %s %s %s~%s %s"
        for k, v in pairs(rawjson.data) do
            if k == 1 then
                self.menubar:setTitle(weaEmoji[v.wea_img] .. "  " .. v.tem)
                table.insert(self.menuData, {
                    title = string.format("%s七日天气预报 - 更新时间%s", rawjson.city, rawjson.update_time),
                    fn = function()
                        obj:delayGetWeather()
                    end
                })
                table.insert(self.menuData, {
                    title = '-'
                })
            end
            titlestr = string.format(weatherItem, weaEmoji[v.wea_img], v.date, v.week, v.tem2, v.tem1, v.wea)
            table.insert(self.menuData, {
                title = titlestr
            })
        end
        self:updateMenubar()
    end)
end

return obj
