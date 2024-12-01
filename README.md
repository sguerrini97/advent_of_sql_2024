## Setup
### Run PostgreSQL Docker container
```
docker image pull postgres
docker run --name postgres-aos24 -e POSTGRES_PASSWORD=aos24 -v aos24data:/var/lib/postgresql/data -p 5432:5432 -d postgres
```

### Connect to running PostgreSQL
```
docker run -it --rm --network=host -v /path/tp/advent_of_sql_day_N.sql:/tmp/db.sql postgres psql -h 127.0.0.1 -U postgres
```

### Create Advent Of SQL DB
```
CREATE DATABASE santa_workshop;
\c santa_workshop
\i db.sql
```
