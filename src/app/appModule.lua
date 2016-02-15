local appModule, module = {}, ...

function appModule.run()
    package.loaded[module]=nil
    node.setcpufreq(node.CPU160MHZ)

    if (log == nil) then
        log = require "loggerModule"
        log.init()
    end

--    local uartModule = require "testuart"
    local uartModule = require "uartModule"
    uartModule.init()
end

return appModule
