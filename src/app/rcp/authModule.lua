local authModule, module = {}, ...

function authModule.init()
    package.loaded[module]=nil
end

function authModule.get_auth_msg(deviceId)
    return {cmd={schemaVer=2, auth={deviceId=deviceId}}}
end

return authModule
