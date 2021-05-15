# 搭建docker register 

直接只有docker 搭建私服，docker的安装过程在“单机版k8s的安装”一文中，不做赘述。
参考：
1、https://blog.51cto.com/ganbing/2080140
2、https://blog.csdn.net/weixin_44723434/article/details/97397091

### 1. 下载register 镜像

``` bash
docker pull registry
```

### 2.  ~~添加用户验证,启动docker-registry~~
使用htpasswd，生成用户名对应的密码加密文件

``` bash
yum  install httpd -y
 mkdir -p /usr/local/auth && htpassword -Bbn username password > /usr/local/auth/passwd
```

### 3.  启动docker register

``` bash
docker run -itd \
  -p 5000:5000 \
  -v /opt/registry:/var/lib/registry \
  -e REGISTRY_STORAGE_DELETE_ENABLED=true \
  --restart=always \
  --name registry-svc \
  registry
```

参数解析：

``` bash
-p 5000:5000，指定registry的端口是5000并映射成主机的5000端口。
-e REGISTRY_STORAGE_DELETE_ENABLED=true 允许删除镜像
-v /opt/registry:/var/lib/registry，将本地的/opt/registr挂载到镜像默认存储路径 /var/lib/registry。
–restart=always，重启方式为always。
–name registry，指定容器名称。
registry，镜像名称。
```

### 4. 测试

``` bash
curl http://127.0.0.1:5000/v2/_catalog
{"repositories":[]}
```

现在是空的，因为才刚运行，里面没有任何镜像内容。
接下来使用别的机器进行测试
首先先在机器2上安装docker，并修改镜像源并重启

``` bash
tee -a /etc/docker/daemon.json > /dev/null << EOF
{
  "registry-mirrors": [ "https://registry.docker-cn.com"]
}
EOF
systemctl restart docker
```

下载测试镜像busybox

``` bash
docker pull busybox
```

为这个镜像打上tag, 10.0.0.205是部署registry的机器

``` bash
docker tag busybox:latest  10.0.0.205:5000/demo/busybox:v1
```

上传到服务器

``` bash
docker push 10.0.0.205:5000/demo/busybox:v1
```

报错了，因为需要https,可以修改daemon.json，让

``` bash
tee /etc/docker/daemon.json > /dev/null << EOF
{
  "registry-mirrors": [ "https://registry.docker-cn.com"],
  "insecure-registries": [ "10.0.0.205:5000"]
}
EOF
```

重启docker

``` bash
systemctl  restart docker
```

再执行push，发现成功了
接下载测试pull
首先删除本地的镜像

``` bash
docker rmi 10.0.0.205:5000/demo/busybox:v1
```

然后执行pull

``` bash
docker pull 10.0.0.205:5000/demo/busybox:v1
```

发现可以pull下来
查看registry上的镜像

``` bash
curl 10.0.0.205:5000/v2/_catalog
{"repositories":["demo/busybox"]}

curl 10.0.0.205:5000/v2/demo/busybox/tags/list
{"name":"demo/busybox","tags":["v1"]}
```

### 5. 搭建docker-registry-web（这个没有删除功能，可以用下面的）

git地址：https://github.com/mkuchin/docker-registry-web

拉取镜像

``` bash
docker pull hyper/docker-registry-web
```

启动镜像，其中10.0.0.205是启动registry的机器（registry的容器不能使用registry为名字，不然会对这个前端产生冲突，所以改成registry-svc）

``` bash
docker run -itd --restart=always -p 8080:8080 --name registry-web --link registry-svc -e REGISTRY_URL=http://10.0.0.205:5000/v2 -e REGISTRY_NAME=localhost:5000 hyper/docker-registry-web 
```

打开10.0.0.205:8080即可浏览

### 6. 搭建 Joxit/docker-registry-ui

git地址：https://github.com/Joxit/docker-registry-ui

拉取镜像

``` bash
docker pull joxit/docker-registry-ui:1.5-static
```

创建docker network 

``` bash
docker network create registry-ui-net
```

修改相关端口，registry接口，启动镜像

``` bash
docker run -itd --net registry-ui-net --restart=always -p 8091:80 -e REGISTRY_URL=http://10.0.0.205:5000 -e DELETE_IMAGES=true -e REGISTRY_TITLE="My registry" joxit/docker-registry-ui:1.5-static
```

