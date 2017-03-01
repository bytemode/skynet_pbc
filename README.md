skynet使用pbc解析protobuf,使用socket和客户端通信。

#  服务器编译步骤:             
clone完整的代码 代码中引用了skynet和pbc           
git clone https://github.com/gameloses/skynet_pbc.git  
   
cd skynet_pbc      
git submodule init  
git submodule update 
      
cd skynet   
git submodule init  
git submodule update   

# 编译skynet  
cd skynet   
make linux   

# 编译pbc  
cd ../3rd/pbc   
make
  
cd binding      
cd lua53    
make    

如果提示找不到lua.h则需要安装一下lua5.3. make && make install  
（或者修改一下Makefile文件，设置lua.h的路径）  

将protobuf.lua复制到根目录的lualib目录  
protobuf.so文件复制到根目录的luaclib目录     

# 编译proto文件  
回到根目录  
make  

如果没有安装protobuf的话会报错，因为要使用到protoc    
yum install protobuf-devel.x86_64  
yum install protobuf.x86_64  

# 运行  
. run.sh  
具体教程见wiki  

# 使用cocos2dx 测试一下连接。
clinet的地址：
https://github.com/gameloses/cocos2dx_lua_skynet_client.git