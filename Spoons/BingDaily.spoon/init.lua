--- === BingDaily ===
---
--- Use Bing daily picture as your wallpaper, automatically.
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/BingDaily.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/BingDaily.spoon.zip)

local obj={}
obj.__index = obj

-- Metadata
obj.name = "BingDaily"
obj.version = "1.1"
obj.author = "ashfinal <ashfinal@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

--- BingDaily.uhd_resolution
--- Variable
--- If `true`, download image in UHD resolution instead of HD. Defaults to `false`.
obj.uhd_resolution = true

local function curl_callback(exitCode, stdOut, stdErr)
    if exitCode == 0 then
        obj.task = nil
        obj.last_pic = obj.file_name
        local localpath = os.getenv("HOME") .. "/.Trash/" .. obj.file_name

        -- set wallpaper for all screens
        allScreen = hs.screen.allScreens()
        for _,screen in ipairs(allScreen) do
            screen:desktopImageURL("file://" .. localpath)
        end
    else
        print(stdOut, stdErr)
    end
end

local function bingRequest()
    local user_agent_str = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.5060.114 Safari/537.36 Edg/103.0.1264.51"
    local json_req_url = "http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1"
    hs.http.asyncGet(json_req_url, {["User-Agent"]=user_agent_str}, function(stat,body,header)
        if stat == 200 then
            if pcall(function() hs.json.decode(body) end) then
                local decode_data = hs.json.decode(body)
                local pic_url = decode_data.images[1].url
                if obj.uhd_resolution then
                    pic_url = pic_url:gsub("1920x1080", "UHD")
                end
                local pic_name = "pic-temp-spoon.jpg"
                for k, v in pairs(hs.http.urlParts(pic_url).queryItems) do
                    if v.id then
                        pic_name = v.id
                        break
                    end
                end
                if obj.last_pic ~= pic_name then
                    obj.file_name = pic_name
                    obj.full_url = "https://www.bing.com" .. pic_url
                    if obj.task then
                        obj.task:terminate()
                        obj.task = nil
                    end
                    print(string.format('-- %s: image url: %s', obj.name, obj.full_url))
                    local localpath = os.getenv("HOME") .. "/.Trash/" .. obj.file_name
                    obj.task = hs.task.new("/usr/bin/curl", curl_callback, {"-A", user_agent_str, obj.full_url, "-o", localpath})
                    obj.task:start()
                end
            end
        else
            print("Bing URL request failed!")
        end
    end)
end

function obj:init()
    bingRequest()
    self:bindCaffeinate()
    self:checkWithInterval()
end

-- 定时更新数据
function obj:checkWithInterval()
    if obj.timer then
        obj.timer:stop()
    end
    obj.timer = hs.timer.new(10800, function() bingRequest() end)
    obj.timer:start()
end

function obj:bindCaffeinate()
    obj.cw = hs.caffeinate.watcher.new(function(eventType)
        if (eventType == hs.caffeinate.watcher.screensDidUnlock) then
            bingRequest()
            obj.checkWithInterval()
        end
        if (eventType == hs.caffeinate.watcher.systemWillSleep) then
            if obj.timer then
                obj.timer:stop()
            end
        end
    end)
    obj.cw:start()
end

return obj
