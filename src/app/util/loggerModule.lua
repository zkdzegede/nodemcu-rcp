print("loggerModule: heap "..node.heap())
local loggerModule, module = {}, ...

function loggerModule.init()
    loggerModule.backup()
    loggerModule.d("---------------- init ------------------")
--    print = function(msg) 
--    end
end

function loggerModule.backup()
    print("Backup log")
    file.rename("logd_older.txt", "logd_oldest.txt")
    file.close()
    file.rename("logd.txt", "logd_older.txt")
    file.close()
    file.remove("logd.txt")
    return true;
end

function loggerModule.clear()
    print("Clear log")
    file.remove("logd.txt")
    return true;
end

function loggerModule.d(data)
    print(data)
    file.open("logd.txt", "a+")
    file.writeline(data)
    file.close()
end

function loggerModule.read(logType, chars)
    if (file.open("log"..logType..".txt", "r") == nil) then return false end
    local logReturn = {}
    file.seek("end", -chars)
    local temp = file.readline()
    local i = 1
    while (temp) do
      logReturn[i] = temp
      temp = file.readline()
      i = i+1
    end

    file.close()
    return logReturn;
end

return loggerModule
