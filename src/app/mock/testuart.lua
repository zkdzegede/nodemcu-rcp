print("### testuartModule ### heap "..node.heap())

local uartModule, module = {}, ...


tempData = "Start:"

local clientModule
local count = 2
local fileCount = 0
local fileOpen = false
local maxFiles = 3

function uartModule.init()
    package.loaded[module]=nil
--    uartModule.setupUart()
    
    local wifiModule = require "wifiModule"
    wifiModule.init()
    local loaded = wifiModule.loadWifiSettings()
    if (loaded) then
        wifiModule.setupWifi(uartModule.wifiCallback)
    else
        log.d("Could not load wifi settings")
    end
end

function uartModule.wifiCallback(success)
end

return uartModule