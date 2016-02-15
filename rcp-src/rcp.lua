setTickRate(2)
initSer(4, 9600, 8, 0, 1)

WIFI_NOT_READY = 0
WIFI_READY = 1
META_READY = 2
STREAM_READY = 3
STREAM_NOT_READY = 4
IDLE = 100
state = WIFI_NOT_READY

function checkLogging()
    if getGpsSpeed() > 10 then
        startLogging()
    else
        -- Do not stop logging until the bike is turned off!
        -- This is to keep 1 big log even if I pit
      --stopLogging()
    end
end

function readUart() 
    local read = readSer(4, 100)
    if (read == "wifiNotReady") then 
       state = WIFI_NOT_READY
    elseif (read == "wifiReady") then
        state = WIFI_READY
    elseif (read == "metaReady") then
        state = META_READY
    elseif (read == "streamReady") then
        state = STREAM_READY
    elseif (read == "streamNotReady") then
        state = STREAM_NOT_READY
    end
end

function writeUart()
    if (state == WIFI_READY) then
        writeSer(4, "meta")
    end
end 

function onTick()
    checkLogging()
    writeUart()
    readUart()
end
