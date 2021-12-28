# C++ docker开发环境

## 介绍
在C++开发时，经常需要使用linux环境，而本地环境一般是windows或者macos系统，这就需要自己搭建linux虚拟机（或者远程linux服务器），然后在虚拟机或者服务器上进行开发和调试。这样就不能使用自己熟悉的环境来开发和调试。

这里使用docker容器+clion IDE的方式来做开发。

## 启动容器
```shell
docker run -d --cap-add sys_ptrace -p2222:22 -p7777:7777 --name clion_remote_dev docker-cpp-remote-dev
```
-d容器作为守护程序运行
--cap-add sys_ptrace添加了ptrace功能，这对于调试是必需的。默认情况下，Docker容器通常非常小，因此有时您需要启用基本功能。

-p2222:22指定SSH的端口映射

-p7777:7777指定GDB调试服务的端口映射

## CLION配置
### 配置Toolchains
到设置面板的Build, Execution, Deployment -> Toolchains。添加新的toolchains，叫Docker，如下所示，设置为Remote Host。
![](/images/clion-step1.png)
Credentials配置为如下所示，User name为dev，Password也为dev
![](/images/clion-step1.1.png)
### 配置Cmake
到设置面板的Build, Execution, Deployment -> CMake。添加新的配置，取名为Debug-Docker，Build type选择Debug，Toolchain选择前面创建的Docker。如下所示
![](/images/clion-step2.png)
### 配置Deployment
到设置面板的Build, Execution, Deployment -> Deployment。可以看到已经存在了Docker的配置，确认Root path是否为```/```。
![](/images/clion-step3.png)
切换到Mappings页面，填写Local path指向本地代码路径，Deployment path指向Docker容器里的路径，这里指定的是/home/dev/test
![](/images/clion-step3.1.png)
保存以上配置

### 使用Debug-Docker调试
切换到Debug-Docker配置，之后就跟在本地开发一样了
![](/images/clion-step4.png)