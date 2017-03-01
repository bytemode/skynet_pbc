local M = {}

local function serialize(obj)
    local lua = ""  
    local t = type(obj)  
    if t == "number" then  
        lua = lua .. obj  
    elseif t == "boolean" then  
        lua = lua .. tostring(obj)  
    elseif t == "string" then  
        lua = lua .. string.format("%q", obj)  
    elseif t == "table" then  
        lua = lua .. "{\n"  
        for k, v in pairs(obj) do  
            lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"  
        end  
        local metatable = getmetatable(obj)  
        if metatable ~= nil and type(metatable.__index) == "table" then  
            for k, v in pairs(metatable.__index) do  
                lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"  
            end
        end
        lua = lua .. "}"  
    elseif t == "nil" then  
        return "nil"  
    elseif t == "userdata" then
        return "userdata"
    elseif t == "function" then
        return "function"
    else  
        error("can not serialize a " .. t .. " type.")
    end  
    return lua
end

function M.print(...)
    local t = {...}
    local ret = {}
    for _,v in pairs(t) do
        table.insert(ret, serialize(v))
    end
    print(table.concat(ret, ", "))
end

function M.split(str, delimiter)
    if str == nil or str == '' or delimiter == nil then
        return nil
    end

    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

function M.hex(str)
    local len = #str
    local ret = ""
    for i=1,len do
        local c = tonumber(str:byte(i))
        local cstr = string.format("%02X ", c)
        ret = ret .. cstr
    end
    print(ret)
end

return M