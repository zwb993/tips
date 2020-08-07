CREATE TABLE new_sensor_data (
 time        TIMESTAMPTZ       NOT NULL,
 kks    TEXT              NOT NULL,
 value DOUBLE PRECISION  NULL,
 status int not null,
 primary key (kks, time)
);

SELECT create_hypertable('new_sensor_data', 'time', 'kks', 2,  chunk_time_interval => 10000000000);