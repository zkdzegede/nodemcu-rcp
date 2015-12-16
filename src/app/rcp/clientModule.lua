print("### clientModule ### heap "..node.heap())

local clientModule, module = {}, ...

local telemetryconnected = false
local isAuth = false
local count = 0
local streamingCallback

function clientModule.init(callback)
    streamingCallback = callback
    if (sk==nil) then 
        sk=net.createConnection(net.TCP,0) 
    end

    sk:on("receive", function(sck, c) 
        print("receive: "..c) 
        handleMessage(cjson.decode(c))
    end)

    sk:on("connection", function(sck) 
        print("on connection")
        telemetryconnected = true
        send_auth()
    end)

    sk:on("reconnection", function(sck) 
        print("on reconnection")
        telemetryconnected = true
        send_auth()
    end)
    
    sk:on("disconnection", function(sck) 
        print("on disconnection")
        telemetryconnected = false
        stopStream()
    end)

    connect()
end

function connect()
    print("do connect")
    if not telemetryconnected then
        sk:connect(8080, 'race-capture.com')
    elseif not isAuth then 
        send_auth()
    else
        clientModule.sendMeta()
        startStream()
    end
end

function send_auth()
        local authModule = require("authModule")
        authModule.init()
        local auth_msg = authModule.get_auth_msg("18YXQYZ")
        sendMessage(cjson.encode(auth_msg))
end

function startStream()
    if isAuth then
        streamingCallback(true, count)
    else
        print("Cannot start streaming without auth")
    end
end

function stopStream()
    streamingCallback(false, 1)
end

function sendMessage(msg_object)
--    print("do send_msg: "..msg_object)
    msg_object = msg_object.."\n"
    sk:send(msg_object)
    count = count + 1
end

function handleMessage(msg_object)
    print("do handle_msg")
    
    if msg_object.status then
        if msg_object.status == "ok" and not isAuth then
            print("TelemetryConnection: authorized to RaceCapture/Live")
            isAuth = true
            clientModule.sendMeta()
            startStream()
        elseif not isAuth then
            -- We failed, abort
            print("TelemetryConnection: failed to authorize, closing")
            -- TODO close connection or what?
            -- self.end()
        end
    else
        print("TelemetryConnection: unknown message. Msg: "..str(msg_object))
    end
    
    if msg_object.message then
        print("TelemetryConnection: got message: "..msg_object["message"])
    end
end

function clientModule.sendSample(sample)

     local metaModule = require("metaModule")
     metaModule.init()
     local channelmeta = metaModule.get_meta()
     
     local msg = {s={t=count,d={}}}
     local bitmasks = {}
     local channelData = sample
     local bitmasks_needed = math.max(0, math.floor((tablelength(channelmeta) - 1) / 32) + 1)
     local channel_bit_position = 0
     local bitmask_index = 1
     local data = {}

    for x = 1, bitmasks_needed do
        table.insert(bitmasks, 0)
    end

    for k, v in pairs(channelmeta) do
        if (channel_bit_position > 31) then
            bitmask_index = bitmask_index + 1
            channel_bit_position = 0
        end

        if (channelData[v.nm] ~= nil) then
            bitmasks[bitmask_index] = bit.bor(bitmasks[bitmask_index],(bit.lshift(1,channel_bit_position)))
            table.insert(data, channelData[v.nm])
        end

        channel_bit_position = channel_bit_position + 1
     end

    for index, bitmask in pairs(bitmasks) do
        table.insert(data, bitmask)
    end

    msg.s.d = data
    sendMessage(cjson.encode(msg))
    return count
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function clientModule.sendMeta()
    -- TODO handle meta update (where to get the list of meta info?)
    local metaModule = require("metaModule")
    metaModule.init()
    local channelmeta = metaModule.get_meta_msg(count)
    sendMessage(cjson.encode(channelmeta))
end

return clientModule
