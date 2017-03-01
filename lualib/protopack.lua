--pb数据的序列化与反序列化

local utils = require "utils"
local skynet = require "skynet"
local retcode = require "retcode"

local M = {}

function M.pack(ret, name, msg)
    --pb协议头
    local ret = ret or 0
    local msg_head = {
        msgtype = 2,
        msgname = name,
        msgret = ret
    }
    local buf_head = skynet.call(M.pbc, "lua", "encode", "PbHead.MsgHead", msg_head)

    print("+++++++++++++++pack")
    utils.print(msg_head)
    utils.print(msg)

    --pb协议数据
    local len
    local pack
    if ret == 0 then
        local buf_body = skynet.call(M.pbc, "lua", "encode", name, msg)
        len = 2 + #buf_head + 2 + #buf_body + 1
        pack = string.pack(">Hs2s2c1", len, buf_head, buf_body, 't')
    else
        --返回码不为0时，只下发pb协议头
        len = 2 + #buf_head + 1
        pack = string.pack(">Hs2s1", len, buf_head, 't')
    end
    
    return pack
end

function M.unpack(data)
    print("---------------Unpack")
    local buf_head, buf_body, ch_end = string.unpack(">s2s2c1", data)
    local msg_head = skynet.call(M.pbc, "lua", "decode", "PbHead.MsgHead", buf_head)
    local msg_body = skynet.call(M.pbc, "lua", "decode", msg_head.msgname, buf_body)
    utils.print(msg_head)
    utils.print(msg_body)
    return msg_head.msgname, msg_body
end

return M