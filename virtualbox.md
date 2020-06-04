## VirtualBox 命令

在virtualBox 安装目录打开cmd 或者将**VBoxManage.exe** 路径加入path上，这样可以随时随地使用VBoxManage命令。

### 启动关闭命令：

**VBoxManage list vms**  列出所有的虚拟机

**VBoxManage list runningvms**  列出所有正在运行虚拟机

**VBoxManage startvm vms_name** 启动vms_name虚拟机

**VBoxManage controlvm vms_name**  +

+ acpipowerbutton  关闭虚拟机，等价于点击系统关闭按钮，正常关机

- poweroff # 关闭虚拟机，等价于直接关闭电源，非正常关机
- pause # 暂停虚拟机的运行
- resume # 恢复暂停的虚拟机
- savestate # 保存当前虚拟机的运行状态

