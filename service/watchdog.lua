local skynet = require "skynet"
local log = require "log"
local protopack = require "protopack"
local socket = require "socket"
local utils = require "utils"
require "skynet.manager"

local gate
local SOCKET = {}
local pbc
local sock_handler
local redissrv

--------------------------------------------------------------------------------
function SOCKET.open(fd, addr)
    log.log("New client from : %s", addr)
    skynet.call(gate, "lua", "accept", fd)
end

function SOCKET.close(fd)
    log.log("socket close fd=%d", fd)
end

function SOCKET.error(fd, msg)
    log.log("socket error fd = %d msg=%s", fd, msg)
end

function SOCKET.warning(fd, size)
    -- size K bytes havn't send out in fd
    log.log("socket warning fd=%d size=%d", fd, size)
end

function SOCKET.data(fd, data)
    local name, msg = protopack.unpack(data)
    skynet.send(sock_handler, "lua", "handle", fd, name, msg)
end

function SOCKET.send(fd, ret, name, msg)
    local data = protopack.pack(ret, name, msg)
    socket.write(fd, data)
end

--------------------------------------------------------------------------------

local CMD = {}
function CMD.start(conf)
    skynet.call(gate, "lua", "open", conf)
    pbc = skynet.uniqueservice("pbc")
    protopack.pbc = pbc
    sock_handler = skynet.uniqueservice("sockhandler")
    --redissrv = skynet.uniqueservice("redissrv")
end

function CMD.close(fd)
end

--------------------------------------------------------------------------------

skynet.start(function()
    skynet.dispatch("lua", function(_, _, cmd, subcmd, ...)
        if cmd == "socket" then
            local f = SOCKET[subcmd]
            f(...)
        else
            local f = assert(CMD[cmd])
            skynet.ret(skynet.pack(f(subcmd, ...)))
        end
    end)

    gate = skynet.newservice("gate")
    skynet.register("watchdog")
end)