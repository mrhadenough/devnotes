## PostgreSQL

```
sudo -u postgres psql
CREATE USER username LOGIN CREATEDB PASSWORD 'password'
CREATE DATABASE username;

\h - help
\? - system help
\q - quit
\dg  \du - list roles
\dt - table list
\l - list databases
\d+ tablename_to_see_schema
\x on - display long rows in expanded way (much better)

```

### Run postgres command inline

```
psql -U sonar -d sonar -c "drop database test;"

```

### Make Postgres dump

```
pg_dump --create --inserts -d sonar -t issues_compact -t rules -f sonar_all.sql

```

### Convert postgres database format to sqlite:
```
sed -i.old -E '/CREATE SEQUENCE.*$/,/^$/d;/^(SET|--|ALTER).*$/d;s/boolean DEFAULT/INT DEFAULT/g;/^SELECT.*$/d;/^ +ADD .*$/d;/CREATE UNIQUE.*$/d;s/, true,/, 1,/g;s/, false,/, 0,/g;/^$/d' sonar_all.sql

```

### Copy balk data from CSV to postgres in fastest way
copy table with certain headers and delimeter
```
COPY table_name (yymmdd,spyadjprc,"PERMNO","CUSIP","TICKER","SHRCD","SICCD","PRC","VOL","OPENPRC","ASKHI","BIDLO","SHROUT","MEDIANusdvol",adjustedprice) FROM '/Users/user/Downloads/dailyadjprc1980_201603.csv' WITH NULL AS '' CSV DELIMITER ',';

```

### Import CSV IN SQLite
```
$ sqlite3 airports.db
.mode csv
.separator ","
.import airports.csv airports
```
