CREATE TABLE temperatures (
    at      date,
    city    text,
    mintemp integer,
    maxtemp integer
)
PARTITION BY RANGE (at);

CREATE EXTENSION postgres_fdw;

-- wrap shard1
CREATE SERVER shard1 FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'shard1', dbname 'app');
CREATE USER MAPPING FOR postgres SERVER shard1
    OPTIONS (user 'postgres', password '123456789');

CREATE FOREIGN TABLE temperatures_2016
    PARTITION OF temperatures
    FOR VALUES FROM ('2016-01-01') TO ('2017-01-01')
    SERVER shard1;

-- wrap shard2
CREATE SERVER shard2 FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'shard2', dbname 'app');
CREATE USER MAPPING FOR postgres SERVER shard2
    OPTIONS (user 'postgres', password '123456789');

CREATE FOREIGN TABLE temperatures_2017
    PARTITION OF temperatures
    FOR VALUES FROM ('2017-01-01') TO ('2018-01-01')
    SERVER shard2;

INSERT INTO temperatures (at, city, mintemp, maxtemp) VALUES
    ('2016-08-03', 'London', 63, 73),
    ('2017-08-03', 'Hanoi', 21, 56);