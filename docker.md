### 停止并删除docker下所有容器
```bash
sudo docker ps -a -q // 查看所有容器ID
sudo docker stop $(sudo docker ps -a -q) //  stop停止所有容器
sudo docker  rm $(sudo docker ps -a -q) //   remove删除所有容器
```
一次性停止删除容器：
```
docker stop $(docker ps -q) & docker rm $(docker ps -aq)
```
### 容器和宿主机相互拷贝文件/文件夹
从容器中拷贝到宿主机
```bash
docker cp container_name:/filepath/(filename) /宿主机filepath
```
从宿主机拷贝到容器
```bash
docker cp /宿主机filepath container_name:/filepath/(filename) 
