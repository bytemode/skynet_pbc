--客户端请求处理，负责客户端请求的分发

local skynet = require "skynet"
local utils = require "utils"

local funs = {}
local login
local agentmgr
local roommgr

local handler_arr = {
    ["PbLogin.MsgLoginReq"] = function(...) funs.login_req(...) end,
}

--------------------------------------------------------------------------------

--登录
function funs.login_req(fd, msg)
    --skynet.send(login, "lua", "socket", "login", fd, msg)
    local MsgLoginRsp = {
        platform = 1,
        user_id = "fdasfad",
        char_id = 1111, 
        char_name = "dsfa"
    }      
    skynet.send("watchdog", "lua", "socket", "send", fd, 0, "PbLogin.MsgLoginRsp",  MsgLoginRsp)
end

--创建房间
function funs.room_create_req(fd, msg)
    skynet.send(roommgr, "lua", "socket", "create", fd, msg)
end

--进入房间
function funs.room_enter_req(fd, msg)
    skynet.send(roommgr, "lua", "socket", "enter", fd, msg)
end

--------------------------------------------------------------------------------

local CMD = {}

function CMD.init()
    --login = skynet.uniqueservice("login")
    --roommgr = skynet.uniqueservice("roommgr")
    --agentmgr = skynet.uniqueservice("agentmgr")
end

--根据协议名，调用对用处理函数
function CMD.handle(fd, msg_name, msg)
    local f = handler_arr[msg_name]
    f(fd, msg)
end

--------------------------------------------------------------------------------

skynet.start(function()
    CMD.init()
    
    skynet.dispatch("lua", function(_, _, cmd, ...)
        local f = CMD[cmd]
        if f then
            f(...)
        else
            log.log("service_clienthandler invalid_cmd %s", cmd)
        end
    end)
end)