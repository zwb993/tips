## redis

单机版部署redis脚本，路径根据需要替换

```shell
for i in $(seq 1 6)
do
        if [ ! -f "/home/zwb/cluster/700"$i"/dump.rdb" ];then
                echo "dump.rdb"$i"文件不存在"
        else
                cmd='rm /home/zwb/cluster/700'$i'/dump.rdb'
                ${cmd}
                echo "删除"$i"dump.rdb"
        fi
        if [ ! -f "/home/zwb/cluster/700"$i"/appendonly.aof" ];then
                echo "appendonly"$i"文件不存在"
        else
                cmd='rm /home/zwb/cluster/700'$i'/appendonly.aof'
                ${cmd}
                echo "删除"$i"appendonly.aof"
        fi
        if [ ! -f "/home/zwb/cluster/700"$i"/nodes-700"$i".conf" ];then
                echo "node"$i"文件不存在"
        else
                cmd='rm /home/zwb/cluster/700'$i'/nodes-700'$i'.conf'
                ${cmd}
                echo "删除"$i"node"
        fi
        sserver='/home/zwb/redis-5.0.5/src/redis-server /home/zwb/cluster/700'$i'/redis.conf'
        ${sserver}
done
sleep 5s
rcluster='/home/zwb/redis-5.0.5/src/redis-cli --cluster create 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 127.0.0.1:7006 --cluster-replicas 1 --cluster-yes'  
# --cluster-yes 直接确定，不跳出选择
${rcluster}
```