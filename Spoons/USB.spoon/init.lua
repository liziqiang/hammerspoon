local obj = {}
obj.__index = obj

-- Metadata
obj.name = "Usb"
obj.version = "1.0"
obj.author = "liziqiang <ziqiang.lee@gmail.com>"
obj.homepage = "https://github.com/Hammerspoon/Spoons"
obj.license = "MIT - https://opensource.org/licenses/MIT"

function isInTable(value, tb)
    for k,v in pairs(tb) do
        for kk,vv in pairs(v) do
            if vv == value then
                return true
            end
        end
    end
    return false
end

function obj:init()
    local usbWatcher
    function handleWifi(devices)
        local hasUsb = isInTable('AX88179A', hs.usb.attachedDevices())
        hs.wifi.setPower(not hasUsb)
        print('WiFi: '..(hasUsb and 'off' or 'on'))
    end
    usbWatcher = hs.usb.watcher.new(handleWifi)
    usbWatcher:start()
end

return obj
