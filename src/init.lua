--print("Wait 2 seconds to start app to allow PANIC loop override")

tmr.alarm(0, 2000, 1, function()
--    uart.setup(0, 115200, 8, 0, 1, 0)
    log = require "loggerModule"
    log.init()
    
    local appModule = require "appModule"
    appModule.run()
    tmr.stop(0);
end)

--function setupUart()
----        log.d("setupUart")
----        logNonAT = true
----        tmr.alarm(3, 2000, 1, function()
----            logNonAT = false
----            tmr.stop(3)
----        end)
----       
--        uart.on("data", 2, 
--          function(data)
----             if (logNonAT) then
----                log.d("receive uart ["..data.."]\n")
----             end
--             if data=="AT" then
--                log.d("receive uart ["..data.."]\n")
--                uart.write(0, "OK")
--                setupUartStream()
--             end
--        end, 0)
--end
--
---- dangerous but we need to try
--uart.setup(0, 115200, 8, 0, 1, 0)
--uart.on("data", 2, 
--          function(data)
--             if data=="AT" then
--                log.d("receive uart ["..data.."]\n")
--                uart.write(0, "OK")
--                setupUart()
--             end
--        end, 0)
--
--function setupUartStream()
--        log.d("setupUartStream")
----        uart.setup(0, 115200, 8, 0, 1, 0)
----        uart.on("data", 0, 
----          function(data)
------             if data=="AT" then
----                log.d("receive uart ["..data.."]\n")
----                uart.write(0, "OK")
------             end
----        end, 0)
--end
