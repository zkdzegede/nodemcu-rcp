print("### wifiModule ### heap "..node.heap())

local wifiModule, module = {}, ...
local wifiap = ""
local wifipassword = ""

function wifiModule.init()
    package.loaded[module]=nil
    wifiap = ""
    wifipassword = ""
    wifi.setmode(wifi.STATIONAP)
end

function wifiModule.scanWifi()
    print("Scan wifi")
    function listap(t) -- (SSID : Authmode, RSSI, BSSID, Channel)
     print("\n\t\t\tSSID\t\t\t\t\tBSSID\t\t\t  RSSI\t\tAUTHMODE\t\tCHANNEL")
      for bssid,v in pairs(t) do
       local ssid, rssi, authmode, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]*)")
        print(string.format("%32.s",ssid).."\t"..bssid.."\t  "..rssi.."\t\t"..authmode.."\t\t\t"..channel)
      end
    end
    wifi.sta.getap(1, listap)
end

function wifiModule.loadWifiSettings()
    print("Load wifi settings:")
    if (file.open("wifisettings.txt", "r") == nil) then return false end
    local wifijson = cjson.decode(file.readline())
    if (wifijson==nil) then
        print("Wifi settings empty")
    else
        wifiap = wifijson.ap
        wifipassword = wifijson.pass
        print("Loaded:"..wifiap..":"..wifipassword)
    end
    file.close()
    return true;
end

function wifiModule.saveWifiSettings(ap, pass)
    print("Saving wifi settings: "..ap..":"..pass)
    wifiap = ap
    wifipassword = pass
    file.open("wifisettings.txt", "w+")
    file.writeline(cjson.encode({ap=ap, pass=pass}))
    file.close()
end

function wifiModule.setupWifi(callback)
    
    wifi.sta.eventMonReg(wifi.STA_IDLE, function() print("Wifi: idle") end)
    wifi.sta.eventMonReg(wifi.STA_WRONGPWD, function() print("Wifi: wrong password") end)
    wifi.sta.eventMonReg(wifi.STA_APNOTFOUND, function() print("Wifi: AP not found") end)
    wifi.sta.eventMonReg(wifi.STA_FAIL, function() print("Wifi: connect fail") end)

    wifi.sta.eventMonReg(wifi.STA_CONNECTING, function(previousState)
        if(previousState==wifi.STA_GOTIP) then 
          print("Wifi: Reconnecting")
          callback(false) -- flag disconnect
        else
          print("Wifi: Connecting")
        end
    end)

    wifi.sta.eventMonReg(wifi.STA_GOTIP, function()
        ip = wifi.sta.getip()
        print("Wifi: Connected as: "..ip)
        callback(true) -- flag connect

--            local serverModule = require "serverModule"
--            serverModule.init()
    end)

    print("Wifi: config with: "..wifiap..":"..wifipassword)
    wifi.sta.config(wifiap, wifipassword, 1)
    wifi.sta.eventMonStart(1000)
end

return wifiModule
