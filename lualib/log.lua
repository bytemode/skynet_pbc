local skynet = require "skynet"

local log = {}

function log.log(format, ...)
    skynet.error(string.format(format, ...))
end

return log