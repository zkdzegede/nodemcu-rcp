print("### uartModule ### heap "..node.heap())

local uartModule, module = {}, ...

local clientModule
local count = 2
local fileCount = 0
local fileOpen = false
local maxFiles = 3

function uartModule.init()
    package.loaded[module]=nil
    
    local wifiModule = require "wifiModule"
    wifiModule.init()
    local loaded = wifiModule.loadWifiSettings()
    if (loaded) then
        wifiModule.setupWifi(uartModule.wifiCallback)
    else
        print("Could not load wifi settings")
    end
end

function uartModule.wifiCallback(success)
    if (success) then
        -- wifi connected
        if (clientModule == nil) then
            clientModule = require "clientModule"
        end
        clientModule.init(uartModule.streamingCallback)
    else
        -- wifi disconnected (not sure what to do with clientModule yet)
        uartModule.streamingCallback(false, 0)
    end
end

function uartModule.streamingCallback(startStreaming, c)
    count = c
    if (startStreaming) then
        print("start stream")
        tmr.alarm(2, 100, 1, function()
            -- TODO turn into uart callback
            local line = tempGetData()
            count = clientModule.sendSample(tempFormatData(line))
        end)
     else
        print("stop stream")
        tmr.stop(2)
     end
end

function tempGetData() 
    if (not fileOpen) then
        local fileToOpen = "testData"..(fileCount%maxFiles+1)..".txt"
        print("open "..fileToOpen)
        file.open(fileToOpen)
        fileOpen = true;
        fileCount = fileCount + 1
    end
    
    local lineString = file.readline()
    local newLineStart, newLineEnd = string.find(lineString, "\n")
    if (newLineStart == 3 and newLineEnd == 3) then 
        print("close file")
        file.close()
        fileOpen = false
        -- do next file
        return getLineFromFile()
    else
        return loadstring("return "..lineString)()
    end
end

function tempFormatData(line)
    return {
            Battery=12,
            Time=count/60,
            Longitude=line[1],
            Latitude=line[2],
            Distance=line[3],
            Speed=line[4],
            LapCount=math.floor(fileCount/maxFiles),
            CurrentLap=count/60,
            PredTime=count/60
           }
end

return uartModule
