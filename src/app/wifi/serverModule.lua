print("### serverModule ### heap "..node.heap())

local serverModule, module = {}, ...

function serverModule.init()
    package.loaded[module]=nil
    if (s==nil) then 
        print("createServer")
        s=net.createServer(net.TCP,180) 
    end
    s:listen(80,function(c) 
        c:on("disconnection",function(c)  
            print("c disconnection")
        end)
     
        c:on("receive", function(c, request)
            local buf = ""
            function esp_update(request, postparse)
                mcu_do=string.sub(request,postparse[2]+1,#request)
                if mcu_do == "Clear" then
                    log.clear()
                end

                if mcu_do == "Remove+Init" then
                    file.remove("init.lua")
                    file.remove("init.lc")
                    node.restart()
                end
            end
            postparse={string.find(request,"mcu_do=")}
            if postparse[2]~=nil then 
                esp_update(request, postparse)
            end
            buf = buf.."HTTP/1.1 200 OK\r\n\r\n"
            buf = buf.."<html><body>"
            buf = buf.."<h1> PMT Racing Log</h1>\n"
            buf = buf.."<form action='' method='POST'>\n"
            buf = buf.."<input type='submit' name='mcu_do' value='Clear'>\n"
            buf = buf.."<input type='submit' name='mcu_do' value='Refresh'>\n"
            buf = buf.."<input type='submit' name='mcu_do' value='Remove Init'>\n"
            buf = buf.."<p>"
            local logValue = log.read("d", 100)
            if (logValue) then
                for x = 1, #logValue do
                    buf = buf..logValue[x].."<br>"
                    tmr.wdclr()
                end
            else
                buf = buf.."No log"
            end
            buf = buf.."</p>"
            buf = buf.."</body></html>"
            c:send(buf)
            c:close()
        end) 
    end)
end

return serverModule
