print("### uartModule ### heap "..node.heap())

local uartModule, module = {}, ...

local clientModule
local count = 2
local fileCount = 0
local fileOpen = false
local maxFiles = 2

function uartModule.wifiCallback(success)
    if (success) then
        -- wifi connected
        clientModule = require "clientModule"
        clientModule.init(uartModule.streamingCallback)
    else
        -- wifi disconnected (not sure what to do with clientModule yet)
    end
end

function uartModule.streamingCallback(startStreaming, c)
    count = c
    if (startStreaming) then
        print("start stream")
        tmr.alarm(2, 100, 1, function()
            -- TODO turn into uart callback
            local line = getLineFromFile()
            count = clientModule.sendSample(getFakeChannelData(line))
        end)
     else
        print("stop stream")
        tmr.stop(2)
     end
end

function getLineFromFile() 
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

function getFakeChannelData(line)
    return {
              Battery=12,
              Distance=20*count,
              LapCount=math.floor(fileCount/maxFiles),
              CurrentLap=count/60,
              Latitude=line[2],
              Longitude=line[1],
              Sector=0,
              Speed=20*math.random(),
              Time=count/60,
              PredTime=count/60
              }
end

return uartModule
