-- Based on work by sancho and zeroday among many other open source authors
-- This code is public domain, attribution to gareth@l0l.org.uk appreciated.

id=0  -- need this to identify (software) IC2 bus?
gpio_pin= {5,4,0,2,14,12,13} -- this array maps internal IO references to GPIO numbers

-- user defined function: see if device responds with ACK to i2c start
function find_dev(i2c_id, dev_addr)
     i2c.start(i2c_id)
     c=i2c.address(i2c_id, dev_addr ,i2c.TRANSMITTER)
     i2c.stop(i2c_id)
     return c
end

--scl=3
--sda=4

function scan()
    -- initialize i2c, set pin1 as sda, set pin0 as scl
--    i2c.setup(id,sda,scl,i2c.SLOW)
--    
--    for i=0,127 do
--      i2c.start(id)
--      resCode = i2c.address(id, i, i2c.TRANSMITTER)
--      i2c.stop(id)
--      if resCode == true then print("We have a device on address 0x" .. string.format("%02x", i) .. " (" .. i ..")") end
--    end

     print("Scanning all pins for I2C Bus device")
     saveScan("start")
     for scl=1,7 do
          for sda=1,7 do
               tmr.wdclr() -- call this to pat the (watch)dog!
               if sda~=scl then -- if the pins are the same then skip this round
                    i2c.setup(id,sda,scl,i2c.SLOW) -- initialize i2c with our id and current pins in slow mode :-)
                    for i=0,127 do -- TODO - skip invalid addresses 
                         if (find_dev(id, i)==true) then
                         saveScan("i:"..i..":sda:"..sda.."scl"..scl)
                         print("Device found at address 0x"..string.format("%02X",i))
                         print("Device is wired: SDA to GPIO"..gpio_pin[sda].." - IO index "..sda)
                         print("Device is wired: SCL to GPIO"..gpio_pin[scl].." - IO index "..scl)
                         end
                    end
               end
          end
     end
     print("Done scanning")
     saveScan("end")
end

function readScan()
    if (file.open("scan.txt", "r") == nil) then return false end
    local wifijson = file.readline()
    while (wifijson) do
        decoded = cjson.decode(wifijson)
        if (decoded==nil) then
            print("Wifi settings empty")
        else
            wifiap = decoded.boom
            print(wifiap)
        end
        wifijson = file.readline()
     end
    file.close()
    return true;
end

function saveScan(result)
    file.open("scan.txt", "a+")
    file.writeline(cjson.encode({boom=result}))
    file.close()
end

scan()