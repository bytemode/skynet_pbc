local skynet = require "skynet"
require "skynet.manager"
local utils = require "utils"
local protobuf = require "protobuf"

local pb_files = {
    "./proto/pbhead.pb",
    "./proto/pblogin.pb",
}

local cmd = {}

function cmd.init()
    for _,v in ipairs(pb_files) do
        utils.print(protobuf.register_file(v))
    end
end

function cmd.encode(msg_name, msg)
    skynet.error("encode"..msg_name)
    return protobuf.encode(msg_name, msg)
end

function cmd.decode(msg_name, data)
    skynet.error("decode ".. msg_name.. " " .. type(data) .." " .. #data)
    return protobuf.decode(msg_name, data)
end

function cmd.test()
    skynet.error("pbc test...")
    local msg = {account = "name"}
    utils.print("msg = ",msg)
    skynet.error("encode")
    local data = cmd.encode("Login.Login", msg)
    skynet.error("decode"..#(data))
    local de_msg = cmd.decode("Login.Login", data)
    skynet.error(de_msg.account)
end

skynet.start(function ()
    skynet.error("init pbc...")
    cmd.init()

    skynet.dispatch("lua", function (session, address, command, ...)
        local f = cmd[command]
        if not f then
            skynet.ret(skynet.pack(nil, "Invalid command" .. command))
        end

        if command == "decode" then
            local name
            local buf
            name,buf = ...
            skynet.ret(skynet.pack(cmd.decode(name,buf)))
            return
        end
        local ret = f(...)
            skynet.ret(skynet.pack(ret))
    end)
end)
