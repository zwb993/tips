### 测试需要登录的接口

1. 右键 -> “添加” -> “配置元件" -> ”HTTP 消息头管理器“。然后右边添加"名称":"Content-Type"；对应的"值":"application/json"
2. 设置"HTTP cookie管理器"
3. 线程组添加"仅一次控制器"-"HTTP请求"，输入登录相关路径，账户密码等
4. 添加"循环控制器"-"HTTP请求"，输入相关接口信息
5. 点击开始执行，就可以得到相关测试数据



### 压测clickhouse

1. 将clickhouse的jar包和依赖放进jmeter的lib/ext文件夹下，可进入clickhouse查看它的依赖，具体的有

``` json
commons-codec, commons-logging
httpcore, httpmime, httpclient
jackson-core, jackson-databind, jackson-annotations
jaxb-api
lz4
slf4j-api
guava
```

2. 线程组添加"配置元件"-"JDBC Connection Configuration"，配置：

```properties
"Variable Name for created pool": "clickhouse-demo"		#之后会用到
"Database Url": "jdbc:clickhouse://ip:8123"
"JDBC Driver class": "ru.yandex.clickhouse.ClickHouseDriver"
"Username": "default"
"Password": 
```

3.  线程组添加"取样器"-"JDBC Request",配置

``` properties
"Variable Name of Pool··· Configuration": "clickhouse-demo"	#和上面的一样
"Query Type": "Prepared Select Statement"
"Query": "select 1"		# 测试的sql
```

4. 添加相关监听器，查看结果，ok！