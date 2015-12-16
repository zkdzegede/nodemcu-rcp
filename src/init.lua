print("init: heap "..node.heap())
print("Wait 3 seconds to start app to allow PANIC loop override")
tmr.alarm(0, 3000, 1, function()
    local appModule = require "appModule"
    appModule.init()
    tmr.stop(0);
end)