## vagrant 

### vagrant 搭建（win10）

1. [vagrant官方下载路径](https://www.vagrantup.com/downloads.html) 选择想要的安装路径，一路点击安装即可

2. 下载package.box，[官方路径](http://www.vagrantbox.es/)

3. 将box加入vagrant中

   ```powershell
   vagrant box add box名字 box本地路径
   ```

   可以通过下面命令查看

   ```powershell
   vagrant box list
   ```

4. 创建虚拟机的目录下，初始化

   ```powershell
   vagrant init box名字
   ```

   之后在该目录下会生成VagrantFile, 启动虚拟机。
   
   如果有错误可以参考[文章](https://blog.csdn.net/u011781521/article/details/80275212)

5. **vagrant 命令大全**

   ```powershell
   vagrant box add	#添加box的操作
   vagrant init	#初始化box的操作，会生成vagrant的配置文件Vagrantfile
   vagrant up	#启动本地环境
   vagrant ssh	#通过 ssh 登录本地环境所在虚拟机
   vagrant halt	#关闭本地环境
   vagrant suspend	#暂停本地环境
   vagrant resume	#恢复本地环境
   vagrant reload	#修改了 Vagrantfile 后，使之生效（相当于先 halt，再 up）
   vagrant destroy	#彻底移除本地环境
   vagrant box list	#显示当前已经添加的box列表
   vagrant box remove	#删除相应的box
   vagrant package	#打包命令，可以把当前的运行的虚拟机环境进行打包
   vagrant plugin	#用于安装卸载插件
   vagrant status	#获取当前虚拟机的状态
   vagrant global-status	#显示当前用户Vagrant的所有环境状态
   ```

 ### virtualbox 安装使用（win10）

1. [下载路径](https://www.virtualbox.org/wiki/Downloads)

2. 直接安装

3. 在管理界面上管理vagrant 生成的虚拟机

4. **脚本化** : 在virtualBox 安装目录打开cmd 或者将**VBoxManage.exe** 路径加入path上，这样可以随时随地使用VBoxManage命令。

   启动关闭命令：

   **VBoxManage list vms**  列出所有的虚拟机

   **VBoxManage list runningvms**  列出所有正在运行虚拟机

   **VBoxManage startvm vms_name** 启动vms_name虚拟机

   **VBoxManage controlvm vms_name**  +

   + acpipowerbutton  关闭虚拟机，等价于点击系统关闭按钮，正常关机

   - poweroff # 关闭虚拟机，等价于直接关闭电源，非正常关机
   - pause # 暂停虚拟机的运行
   - resume # 恢复暂停的虚拟机
   - savestate # 保存当前虚拟机的运行状态


