

启动服务，指定路径sudo timescaledb-tune --pg-config=/usr/pgsql-12/bin/pg_config

#### 查看是否是hypertable

``` sql
select * from _timescaledb_catalog.hypertable
```

