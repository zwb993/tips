

### fpm 

#### 用于制作rpm安装包 

```bash
curl -O -L https://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.2.tar.gz	#安装ruby,版本要求大于2.3
yum install openssl-devel -y
tar xf ruby-2.3.2.tar.gz
cd ruby-2.3.2
./configure --prefix=/usr/local/ruby-2.3.2
make && make install
ln -s /usr/local/ruby-2.3.2/bin/ruby /usr/bin/ruby	#创建软链接
ln -s /usr/local/ruby-2.3.2/bin/gem /usr/bin/gem	#需要的都创建链接
```

查看ruby版本

```bash
ruby -v
```

更换ruby仓库源

``` bash
gem sources -a http://mirrors.aliyun.com/rubygems/
gem sources --remove http://rubygems.org/
```

安装fpm:

``` bash
gem install fpm 							#或者 -v 1.4.0 指定安装版本
find / -type f -name 'fpm' -executable		#安装后如果还是无法找到fpm命令，执行这个命令找到fpm路径并创建链接以直接执行
```



以制作nginx的rpm为例：

```bash
wget http://nginx.org/download/nginx-1.6.3.tar.gz		#获取安装包
sed -i 's#keepcache=0#keepcache=1#g' /etc/yum.conf		#设置yum安装的包都会保存在本地
find /var/cache/ -type f -name "*rpm" | xargs rm 		#先删除本地rpm包
yum install pcre-devel openssl-devel -y					#安装nginx依赖
find /var/cache/ -type f -name "*rpm"|xargs cp -t /tmp/ #找到依赖包并拷贝到别的目录
cd /tmp/ && tar zcf nginx_yum.tar.gz *.rpm				#将依赖打包成tar包
```

安装nginx 

```bash
tar xf nginx-1.6.3.tar.gz
cd nginx-1.6.3
./configure --prefix=/usr/local/nginx
make && make install
ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx		#如果没有nginx就创建软链接
cp /usr/local/nginx/sbin/nginx /usr/local/sbin/nginx
```
如果报错
Need executable 'rpmbuild' to convert dir to rpm {:level=>:error}

解决：
``` bash
yum install rpm-build -y
```
制作nginx:
```bash
fpm -s dir -t rpm -n nginx -v 1.6.3 -d 'pcre-devel,openssl-devel'  -f /usr/local/nginx/
```

至此nginx安装包制作完成

``` 
-s 指定源类型
-t 指定目标类型，即想要制作为什么包
-n 指定包的名字
-v 指定包的版本号
-C 指定打包的相对路径 Change directory to here before searching forfiles
-d 指定依赖于哪些包
-f 第二次打包时目录下如果有同名安装包存在，则覆盖它
-p 输出的安装包的目录，不想放在当前目录下就需要指定
--post-install 软件包安装完成之后所要运行的脚本；同--after-install
--pre-install 软件包安装完成之前所要运行的脚本；同--before-install
--post-uninstall 软件包卸载完成之后所要运行的脚本；同--after-remove
--pre-uninstall 软件包卸载完成之前所要运行的脚本；同--before-remove
```



将两个包发送到需要安装的机器，解压依赖包，执行：

```bash
yum -y localinstall nginx-1.6.3-1.x86_64.rpm		#自动安装依赖再安装rpm
```

制作nginx自启动脚本：

``` bash
vi /lib/systemd/system/nginx.service
```

nginx.service:

```bash
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/usr/local/ningx/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

启动和设置自启动

```bash
systemctl start nginx
systemctl enable nginx
```



## 防火墙

### iptables 

```bash
service iptables status  	# 查看防火墙状态
service iptables stop 		# 停止防火墙
service iptables start 		# 启动防火墙
service iptables restart 	# 重启防火墙
chkconfig iptables off 		# 永久关闭防火墙
chkconfig iptables on　　		# 永久关闭后重启

#开启80端口
vim /etc/sysconfig/iptables
# 加入如下代码
-A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
#保存退出后重启防火墙
service iptables restart
```

### firewall 

firewall 是centos7里面的新的防火墙命令，它底层还是使用 iptables 对内核命令动态通信包过滤的，简单理解就是firewall是centos7下管理iptables的新命令

```bash
systemctl status firewalld		#查看firewall服务状态
firewall-cmd --state			#查看firewall的状态
service firewalld start			# 开启
service firewalld restart		# 重启
service firewalld stop			# 关闭
firewall-cmd --list-all			#查看防火墙规则
firewall-cmd --list-ports		#查看防火墙开放端口

firewall-cmd --query-port=8080/tcp					# 查询端口是否开放
firewall-cmd --permanent --add-port=80/tcp			# 开放80端口
firewall-cmd --permanent --remove-port=8080/tcp		# 移除端口
firewall-cmd --reload								#重启防火墙(修改配置后要重启防火墙)
# 参数解释
1、firwall-cmd：是Linux提供的操作firewall的一个工具；
2、--permanent：表示设置为持久；
3、--add-port：标识添加的端口；
```



### systemd

#### journal

日志存放地址：/run/log/journal/

设置日志保存时长（两天）：journalctl --vacuum-time=2d，具体可参考man journalctl

