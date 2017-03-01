--给客户端请求的返回码

local ret_arr = {
    OK = 0,                                         --成功
    
    --登录
    LOGIN_GUEST_REGISTER_FAIL = 201,                --游客用户创建失败
    LOGIN_PLATFORM_ERROR = 202,                     --平台编号错误
    
    --创建房间
    ROOM_CREATE_FAIL = 211,                         --创建房间失败
    ROOM_CREATE_IN_ROOM = 212,                      --在房间内
    ROOM_HAD_CREATE= 213,                           --已经创建了房间

    --进入房间
    ROOM_ENTER_NUM_NOT_EXIST = 221,                 --房间号不存在
    ROOM_ENTER_NOT_OPEN = 222,                      --房间未开启
    ROOM_ENTER_NO_POSITION = 223,                   --房间已满
    ROOM_ENTER_HAD_START = 224,                     --牌局已经开始，不能进入房间
    ROOM_ENTER_IN_OTHER_ROOM = 225,                 --已经在其它房间内
    ROOM_ENTER_IN_THIS_ROOM = 226,                  --已经在此房间内

    --离开房间
    ROOM_LEAVE_HAVE_NO_ROOM = 241,                  --没有房间
    ROOM_LEAVE_IN_OTHER_ROOM = 242,                 --在其它房间
    ROOM_LEAVE_NOT_IN_ROOM = 243,                   --不在此房间
    ROOM_LEAVE_HAD_START = 244,                     --牌局已经开始，不能离开房间


    --解散房间
    ROOM_DISSOLVE_NOT_OWNER = 251,                  --不是房主

    --准备
    ROOM_READY_HAVE_NO_ROOM = 261,                  --没有房间
    ROOM_READY_NUM_NOT_EXIST = 262,                 --房间号不存在
    ROOM_READY_NOT_IN_ROOM = 263,                   --不在房间内
    ROOM_READY_IN_OTHER_ROOM = 264,                 --在其它房间
    ROOM_READY_HAD_READY = 265,                     --已经准备
}

return ret_arr