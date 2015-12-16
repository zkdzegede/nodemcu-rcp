print("appModule: heap "..node.heap())
local appModule, module = {}, ...

function appModule.run()
    package.loaded[module]=nil
    node.setcpufreq(node.CPU160MHZ)

    local uartModule = require "uartModule"
    uartModule.init()
end

return appModule
