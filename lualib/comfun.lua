--自己实现的功用函数

local skynet = require "skynet"
local log = require "log"

local comfun = {}

--number取整
function comfun.get_int_part(x)
    if x < 0 then
        return math.ceil(x)
    end
    if math.ceil(x) == x then
        x = math.ceil(x)
    else
        x = math.ceil(x) - 1
    end
    return x
end

--外部请求处理
function comfun.sock_handle(CMD, srv_name, cmd, fd, ...)
    local f = CMD[cmd]
    if f then
        local ret, msg_rsp_name, msg_rsp = f(fd, ...)
        skynet.send("watchdog", "lua", "socket", "send", fd, ret, msg_rsp_name, msg_rsp)
    else
        log.log("server_%s invalid_sock_cmd %s", srv_name, cmd)
    end
end

--内部请求处理
function comfun.inner_handle(CMD, srv_name, cmd, ...)
    local f = CMD[cmd]
    if f then
        --内部接口调用全部返回
        skynet.ret(skynet.pack(f(...)))
    else
        log.log("service_%s invalid_inner_cmd %s", srv_name, cmd)
    end
end

--消息处理
function comfun.dispatch(CMD, srv_name, cmd, subcom, ...)
    if cmd == "socket" then
        comfun.sock_handle(CMD, srv_name, subcom, ...)
    else
        comfun.inner_handle(CMD, srv_name, cmd, subcom, ...)
    end
end

--公用启动函数
function comfun.srv_start(CMD, srv_name)
    skynet.start(function()
        skynet.dispatch("lua", function(_, _, cmd, subcom, ...)
            comfun.dispatch(CMD, srv_name, cmd, subcom, ...)
        end)

        if srv_name then
            skynet.register(srv_name)
        end
    end)
end

return comfun