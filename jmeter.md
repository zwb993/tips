### 测试需要登录的接口

#### 方法1，使用循环控制器

1. 右键 -> “添加” -> “配置元件" -> ”HTTP 消息头管理器“。然后右边添加"名称":"Content-Type"；对应的"值":"application/json"
2. 设置"HTTP cookie管理器"
3. 线程组添加"仅一次控制器"-"HTTP请求"，输入登录相关路径，账户密码等
4. 添加"循环控制器"-"HTTP请求"，输入相关接口信息
5. 点击开始执行，就可以得到相关测试数据

#### 方法2， 使用正则提取器将cookie提取

一、配置登录线程组

1. 创建登录的线程组，线程数为1

2. 添加"配置元件"-"HTTP信息头管理器"设置相关信息，比如"Content-Type":"application/json"

3. 添加"取样器"-"HTTP请求"，设置相关参数

4. **HTTP请求下添加"后置处理器"-"正则表达式提取器"**

   ![jmeter-RE](E:\zwb\git_repo\tips\image\jmeter-RE.png)

   配置相应字段在信息头即返回头中

   引用名称：外部可使用的名称（例如使用$(auth_token)引用）

   正则表达式：需要提取的变量，(.+)中的是提取的，前后是匹配的

5. 添加"后置处理器"-"BeanShell PostProcessor"将变量配置到全局

   ![jmeter-Bean](E:\zwb\git_repo\tips\image\jmeter-Bean.png)

   parameters: 即上面的引用名称

   在脚本中将这个变量设置成全局变量

二、 配置请求线程组

1. 添加HTTP信息头管理器，并添加相关配置

2. 添加HTTP cookie管理器，并配置上面的变量

   ![jmeter-cookie](E:\zwb\git_repo\tips\image\jmeter-cookie.jpg)

3. 添加http请求，进行相关测试即可



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