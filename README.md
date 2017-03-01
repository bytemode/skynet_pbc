棋牌服务器框架，使用skynet

网络协议使用pbc版的protobuf

数据库使用mongodb

服务器编译步骤:

1、编译skynet
cd skynet
make linux

2、编译pbc
cd ../3rd/pbc
make

cd binding
cd lua53
修改一下Makefile文件，设置lua.h的路径
make

将protobuf.lua复制到根目录的lualib目录
protobuf.so文件复制到根目录的luaclib目录

3、编译proto文件
回到根目录
make

4、运行
. run.sh