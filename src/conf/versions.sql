
DROP VIEW  IF EXISTS v_versions;
DROP TABLE IF EXISTS versions;
DROP TABLE IF EXISTS releases;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS categories;

DROP TABLE IF EXISTS flavors;

DROP VIEW  IF EXISTS v_images;
DROP TABLE IF EXISTS images;
DROP TABLE IF EXISTS image_types;

DROP VIEW  IF EXISTS v_locations;
DROP TABLE IF EXISTS locations;
DROP VIEW  IF EXISTS v_regions;
DROP TABLE IF EXISTS regions;
DROP TABLE IF EXISTS metros;
DROP TABLE IF EXISTS volume_types;
DROP TABLE IF EXISTS providers;
DROP TABLE IF EXISTS provider_types;
DROP VIEW  IF EXISTS v_services;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS service_types;


CREATE TABLE categories (
  category    INTEGER  NOT NULL PRIMARY KEY,
  sort_order  SMALLINT NOT NULL,
  description TEXT     NOT NULL,
  short_desc  TEXT     NOT NULL
);


CREATE TABLE projects (
  project   	 TEXT     NOT NULL PRIMARY KEY,
  category  	 INTEGER  NOT NULL,
  port      	 INTEGER  NOT NULL,
  depends   	 TEXT     NOT NULL,
  start_order    INTEGER  NOT NULL,
  sources_url    TEXT     NOT NULL,
  short_name     TEXT     NOT NULL,
  is_extension   SMALLINT NOT NULL,
  image_file     TEXT     NOT NULL,
  description    TEXT     NOT NULL,
  project_url    TEXT     NOT NULL,
  FOREIGN KEY (category) REFERENCES categories(category)
);


CREATE TABLE releases (
  component     TEXT     NOT NULL PRIMARY KEY,
  sort_order    SMALLINT NOT NULL,
  project       TEXT     NOT NULL,
  disp_name     TEXT     NOT NULL,
  doc_url       TEXT     NOT NULL,
  stage         TEXT     NOT NULL,
  description   TEXT     NOT NULL,
  is_open       SMALLINT NOT NULL DEFAULT 1,
  license       TEXT     NOT NULL,
  is_available  TEXT     NOT NULL,
  available_ver TEXT     NOT NULL,
  FOREIGN KEY (project) REFERENCES projects(project)
);


CREATE TABLE versions (
  component     TEXT    NOT NULL,
  version       TEXT    NOT NULL,
  platform      TEXT    NOT NULL,
  is_current    INTEGER NOT NULL,
  release_date  DATE    NOT NULL,
  parent        TEXT    NOT NULL,
  pre_reqs      TEXT    NOT NULL,
  release_notes TEXT    NOT NULL,
  PRIMARY KEY (component, version),
  FOREIGN KEY (component) REFERENCES releases(component)
);

CREATE VIEW v_versions AS
  SELECT c.category as cat, c.sort_order as cat_sort, r.sort_order as rel_sort,
         c.description as cat_desc, c.short_desc as cat_short_desc,
         p.image_file, r.component, r.project, r.stage, r.disp_name as release_name,
         v.version, p.sources_url, p.project_url, v.platform, 
         v.is_current, v.release_date, p.description as proj_desc, 
         r.description as rel_desc, v.pre_reqs, r.license, p.depends, 
         r.is_available, v.release_notes
    FROM categories c, projects p, releases r, versions v
   WHERE c.category = p.category
     AND p.project = r.project
     AND r.component = v.component;

INSERT INTO categories VALUES (0,   0, 'Hidden', 'NotShown');
INSERT INTO categories VALUES (1,  10, 'Rock-Solid Postgres', 'PostgreSQL');
INSERT INTO categories VALUES (10, 96, 'Foreign Datastores', 'ForeignData');
INSERT INTO categories VALUES (2,  60, 'Advanced Applications', 'Applications');
INSERT INTO categories VALUES (4,  65, 'Workload Optimization', 'Optimization');
INSERT INTO categories VALUES (5,  70, 'Data Integration', 'Integration');
INSERT INTO categories VALUES (3,  80, 'Database Developers', 'DB-Devs');
INSERT INTO categories VALUES (9,  87, 'Management & Monitoring', 'Manage');

-- ## HUB ################################
INSERT INTO projects VALUES ('hub',0, 0, 'hub', 0, 'https://github.com/pgsql-io/pgsql-io','',0,'','','');
INSERT INTO releases VALUES ('hub', 1, 'hub', '', '', 'hidden', '', 1, '', '', '');
INSERT INTO versions VALUES ('hub', '6.48', '',  1, '20210518', '', '', '');
INSERT INTO versions VALUES ('hub', '6.47', '',  0, '20210513', '', '', '');
INSERT INTO versions VALUES ('hub', '6.46', '',  0, '20210504', '', '', '');
INSERT INTO versions VALUES ('hub', '6.45', '',  0, '20210427', '', '', '');
INSERT INTO versions VALUES ('hub', '6.44', '',  0, '20210419', '', '', '');
INSERT INTO versions VALUES ('hub', '6.43', '',  0, '20210413', '', '', '');
INSERT INTO versions VALUES ('hub', '6.42', '',  0, '20210412', '', '', '');
INSERT INTO versions VALUES ('hub', '6.41', '',  0, '20210408', '', '', '');

-- ##
INSERT INTO projects VALUES ('pg', 1, 5432, 'hub', 1, 'https://postgresql.org/download',
 'postgres', 0, 'postgresql.png', 'Best RDBMS', 'https://postgresql.org');

INSERT INTO releases VALUES ('pg95', 6, 'pg', 'PostgreSQL', '', 'prod', 
  '<font size=-1>New in <a href=https://www.postgresql.org/docs/release/9.5.0/>v9.5</a></font>&nbsp;<font size=-2>07-Jan-2016</font>', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pg95', '9.5.26-1', 'amd', 0, '20210211', '', 'LIBC-2.17', '');

INSERT INTO releases VALUES ('pg96', 5, 'pg', 'PostgreSQL', '', 'prod', 
  '<font size=-1>New in <a href=https://www.postgresql.org/docs/release/9.6.0/>v9.6</a></font>&nbsp;<font size=-2>29-Sep-2016</font>', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pg96', '9.6.21-1', 'amd', 0, '20210211', '', 'LIBC-2.17', '');

INSERT INTO releases VALUES ('pg10', 4, 'pg', 'PostgreSQL', '', 'prod', 
  '<font size=-1>New in <a href=https://www.postgresql.org/docs/10/release-10.html>v10</a></font>&nbsp;<font size=-2>05-Oct-2017</font>', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pg10', '10.16-1', 'amd', 0, '20210211', '', 'LIBC-2.17', '');

INSERT INTO releases VALUES ('pg11', 3, 'pg', 'PostgreSQL', '', 'prod', 
  '<font size=-1>New in <a href=https://www.postgresql.org/docs/11/release-11.html>v11</a></font>&nbsp;<font size=-2>08-Oct-2018</font>', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pg11', '11.12-1', 'amd', 1, '20210513', '', 'LIBC-2.17', '');
INSERT INTO versions VALUES ('pg11', '11.11-3', 'amd', 0, '20210211', '', 'LIBC-2.17', '');
INSERT INTO versions VALUES ('pg11', '11.11-2', 'amd', 0, '20210211', '', 'LIBC-2.17', '');
INSERT INTO versions VALUES ('pg11', '11.11-1', 'amd', 0, '20210211', '', 'LIBC-2.17', '');

INSERT INTO releases VALUES ('pg12', 2, 'pg', 'PostgreSQL', '', 'prod', 
  '<font size=-1>New in <a href=https://www.postgresql.org/docs/12/release-12.html>v12</a></font>&nbsp;<font size=-2>03-Oct-2019</font>', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pg12', '12.7-1', 'amd', 1, '20210513', '', 'LIBC-2.17', '');
INSERT INTO versions VALUES ('pg12', '12.6-3', 'amd', 0, '20210211', '', 'LIBC-2.17', '');
INSERT INTO versions VALUES ('pg12', '12.6-2', 'amd', 0, '20210211', '', 'LIBC-2.17', '');
INSERT INTO versions VALUES ('pg12', '12.6-1', 'amd', 0, '20210211', '', 'LIBC-2.17', '');

INSERT INTO releases VALUES ('pg13', 1, 'pg', 'PostgreSQL', '', 'prod', 
  '<font size=-1>New in <a href=https://www.postgresql.org/docs/13/release-13.html>v13</a>
  </font>&nbsp;<font size =-2>24-Sep-2020</sup></font>', 
  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pg13', '13.3-1',  'amd', 1, '20210513','', 'LIBC-2.17', '');
INSERT INTO versions VALUES ('pg13', '13.2-3',  'amd', 0, '20210211','', 'LIBC-2.17', '');
INSERT INTO versions VALUES ('pg13', '13.2-2',  'amd', 0, '20210211','', 'LIBC-2.17', '');
INSERT INTO versions VALUES ('pg13', '13.2-1',  'amd', 0, '20210211','', 'LIBC-2.17', '');

INSERT INTO releases VALUES ('pg14', 4, 'pg', 'PostgreSQL', '', 'test', '',
  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pg14', '14beta1-1',  'amd', 1, '20210520','', 'LIBC-2.17', '');

INSERT INTO projects VALUES ('debezium',  5, 8080, 'kafka', 3, 'https://debezium.io/releases/1.5/',
  'Debezium', 0, 'debezium.png', 'Stream DB Changes', 'https://debezium.io');
INSERT INTO releases VALUES ('debezium', 0, 'debezium', 'Debezium', '', 'test', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('debezium', '1.5.0', '', 1, '20210408', '', '', '');
INSERT INTO versions VALUES ('debezium', '1.2.5', '', 0, '20200924', '', '', '');

INSERT INTO projects VALUES ('kafka', 10, 9092, 'zookeeper', 2, 'https://kafka.apache.org/downloads',
  'Kafka', 0, 'kafka.png', 'Streaming Platform', 'https://kafka.apache.org');
INSERT INTO releases VALUES ('kafka', 0, 'kafka', 'Kafka', '', 'test', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('kafka', '2.8.0', '', 1, '20210502', '', '', 'https://downloads.apache.org/kafka/2.8.0/RELEASE_NOTES.html');
INSERT INTO versions VALUES ('kafka', '2.7.0', '', 0, '20201221', '', '', 'https://downloads.apache.org/kafka/2.7.0/RELEASE_NOTES.html');

INSERT INTO projects VALUES ('redis', 10, 6379, 'hub', 2, 'https://github.com/redis/redis/releases',
  'Redis', 0, 'redis.png', 'Hi-Speed Cache', 'https://redis.io');
INSERT INTO releases VALUES ('redis', 0, 'redis', 'Redis', '', 'test', '', 1, 'BSD', '', '');
INSERT INTO versions VALUES ('redis', '6', '',   1, '20210503', '', '', '');

INSERT INTO projects VALUES ('zookeeper', 10, 2181, 'hub', 1, 'https://zookeeper.apache.org/releases.html#releasenotes',
  'zookeeper', 0, 'zookeeper.png', 'Distributed Key-Store for HA', 'https://zookeeper.apache.org');
INSERT INTO releases VALUES ('zookeeper', 5, 'zookeeper', 'Zookeeper', '', 'test', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('zookeeper', '3.7.0', '',  1, '20210327', '', '',
  'https://zookeeper.apache.org/doc/r3.7.0/releasenotes.html');
INSERT INTO versions VALUES ('zookeeper', '3.6.2', '',  0, '20200909', '', '',
  'https://zookeeper.apache.org/doc/r3.6.2/releasenotes.html');

INSERT INTO projects VALUES ('cassandrafdw', 5, 0, 'hub', 0, 'https://github.com/pgsql-io/cassandra_fdw/releases', 
  'cstarfdw', 1, 'cstar.png', 'Cassandra from PG', 'https://github.com/pgsql-io/cassandra_fdw#cassandra_fdw');
INSERT INTO releases VALUES ('cassandrafdw-pg12', 12, 'cassandrafdw', 'CassandraFDW','','test', '', 1, 'AGPLv3', '', '');
INSERT INTO versions VALUES ('cassandrafdw-pg12', '3.1.5-1', 'amd', 1, '20191230', 'pg12', '', '');

INSERT INTO projects VALUES ('wal2json', 5, 0, 'hub', 0, 'https://github.com/eulerto/wal2json/releases', 
  'wal2json', 1, 'wal2json.png', 'Output plugin for logical decoding', 'https://github.com/eulerto/wal2json#introduction');
INSERT INTO releases VALUES ('wal2json-pg13',  3, 'wal2json', 'wal2json', '', 'prod', '', 1, 'BSD', '', '');
INSERT INTO versions VALUES ('wal2json-pg13', '2.3-1', 'amd', 1, '20200809', 'pg13', '', '');

INSERT INTO projects VALUES ('mongofdw', 5, 0, 'hub', 0, 'https://github.com/EnterpriseDB/mongo_fdw/releases', 
  'mongofdw', 1, 'mongodb.png', 'MongoDB Queries from PG', 'https://github.com/EnterpriseDB/mongo_fdw#mongo_fdw');
INSERT INTO releases VALUES ('mongofdw-pg13',  3, 'mongofdw', 'MongoFDW', '', 'prod', '', 1, 'AGPLv3', '', '');
INSERT INTO versions VALUES ('mongofdw-pg13', '5.2.8-1', 'amd', 1, '20201027', 'pg13', '', '');

INSERT INTO projects VALUES ('hivefdw', 5, 0, 'hub', 0, 'https://github.com/pgsql-io/hive_fdw/releases', 
  'hivefdw', 1, 'hive.png', 'Big Data Queries from PG', 'https://github.com/pgsql-io/hive_fdw#hive_fdw');
INSERT INTO releases VALUES ('hivefdw-pg13', 14, 'hivefdw', 'HiveFDW', '', 'test', '', 1, 'AGPLv3', '', '');
INSERT INTO versions VALUES ('hivefdw-pg13', '4.0-1', 'amd', 1, '20200927', 'pg13', '', '');

INSERT INTO projects VALUES ('redisfdw', 5, 0, 'hub', 0, 'https://github.com/pgsql-io/redis_fdw/releases', 
  'redisfdw', 1, 'redis.png', 'Access Redis', 'https://github.com/pgsql-io/redis_fdw');
INSERT INTO releases VALUES ('redisfdw-pg13',  4, 'redisfdw', 'RedisFDW',  '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('redisfdw-pg13', '1.13-1', 'amd', 1, '20200608', 'pg13', '', '');

INSERT INTO projects VALUES ('mysqlfdw', 5, 0, 'hub', 0, 'https://github.com/EnterpriseDB/mysql_fdw/releases', 
  'mysqlfdw', 1, 'mysql.png', 'Access MySQL, Percona & MariaDB', 'https://github.com/EnterpriseDb/mysql_fdw');
INSERT INTO releases VALUES ('mysqlfdw-pg13',  4, 'mysqlfdw', 'MySQL FDW',  '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('mysqlfdw-pg13', '2.6.0-1', 'amd', 1, '20210502', 'pg13', '', '');
INSERT INTO versions VALUES ('mysqlfdw-pg13', '2.5.5-1', 'amd', 0, '20201021', 'pg13', '', '');
INSERT INTO versions VALUES ('mysqlfdw-pg13', '2.5.4-1', 'amd', 0, '20200802', 'pg13', '', '');

INSERT INTO projects VALUES ('tdsfdw', 5, 0, 'hub', 0, 'https://github.com/tds-fdw/tds_fdw/releases',
  'tdsfdw', 1, 'tds.png', 'SQL Server & Sybase from PG', 'https://github.com/tds-fdw/tds_fdw/#tds-foreign-data-wrapper');
INSERT INTO releases VALUES ('tdsfdw-pg13', 4, 'tdsfdw', 'TDS FDW', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('tdsfdw-pg13', '2.0.2-1', 'amd',  1, '20200926', 'pg13', '', 'https://github.com/tds-fdw/tds_fdw/releases/tag/v2.0.2');

INSERT INTO projects VALUES ('proctab', 9, 0, 'hub', 0, 'https://github.com/markwkm/pg_proctab/releases',
  'proctab', 1, 'proctab.png', 'Monitoring Functions for pgTop', 'https://github.com/markwkm/pg_proctab');
INSERT INTO releases VALUES ('proctab-pg12', 8, 'proctab', 'pgProcTab', '', 'prod', '', 1, 'BSD-3', '', '');
INSERT INTO versions VALUES ('proctab-pg12', '0.0.9-1', 'amd',  0, '20200508', 'pg12', '', '');

INSERT INTO projects VALUES ('pgtop', 9, 0, 'proctab', 0, 'https://github.com/markwkm/pg_top/releases',
  'pgtop', 1, 'pgtop.png', '"top" for Postgres', 'https://github.com/markwkm/pg_top/');
INSERT INTO releases VALUES ('pgtop-pg12', 8, 'pgtop', 'pgTop', '', 'prod', '', 1, 'BSD-3', '', '');
INSERT INTO versions VALUES ('pgtop-pg12', '4.0.0-1', 'amd',  0, '20201008', 'pg12', '', '');

INSERT INTO projects VALUES ('esfdw', 5, 0, 'multicorn', 1, 'https://github.com/matthewfranglen/postgres-elasticsearch-fdw/releases',
  'esfdw', 1, 'esfdw.png', 'Elastic Search from PG', 'https://github.com/matthewfranglen/postgres-elasticsearch-fdw#postgresql-elastic-search-foreign-data-wrapper');
INSERT INTO releases VALUES ('esfdw-pg13',  3, 'esfdw', 'ElasticSearchFDW', '', 'prod', '', 1, 'MIT', '', '');
INSERT INTO versions VALUES ('esfdw-pg13', '0.11.1', 'amd',  1, '20210409', 'pg13', 'PYTHON3', '');

INSERT INTO projects VALUES ('ora2pg', 5, 0, 'hub', 0, 'https://github.com/darold/ora2pg/releases',
  'ora2pg', 0, 'ora2pg.png', 'Migrate from Oracle to PG', 'https://ora2pg.darold.net');
INSERT INTO releases VALUES ('ora2pg', 2, 'ora2pg', 'Oracle to PG', '', 'test', '', 1, 'GPLv2', '', '');
INSERT INTO versions VALUES ('ora2pg', '21.1', '', 1, '20210401', '', 'GCC PERL',
  'https://github.com/darold/ora2pg/releases/tag/v21.1');
INSERT INTO versions VALUES ('ora2pg', '21.0', '', 0, '20201012', '', 'GCC PERL',
  'https://github.com/darold/ora2pg/releases/tag/v21.0');
INSERT INTO versions VALUES ('ora2pg', '20.0', '', 0, '20200829', '', 'GCC PERL',
  'https://github.com/darold/ora2pg/releases/tag/v20.0');

INSERT INTO projects VALUES ('oraclefdw', 5, 0, 'hub', 0, 'https://github.com/laurenz/oracle_fdw/releases',
  'oraclefdw', 1, 'oracle_fdw.png', 'Oracle from PG', 'https://github.com/laurenz/oracle_fdw');
INSERT INTO releases VALUES ('oraclefdw-pg13', 2, 'oraclefdw', 'OracleFDW', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('oraclefdw-pg13','2.3.0-1', 'amd', 1, '20200924', 'pg13', '', 'https://github.com/laurenz/oracle_fdw/releases/tag/ORACLE_FDW_2_3_0');

INSERT INTO projects VALUES ('oracle', 10, 1521, 'hub', 0, 'https://www.oracle.com/database/technologies/oracle-database-software-downloads.html#19c', 
  'oracle', 0, 'oracle.png', 'Oracle Database', 'https://www.oracle.com/database/technologies');
INSERT INTO releases VALUES ('oracle', 2, 'oracle', 'Oracle', '', 'test','', 0, 'ORACLE', '', '');
INSERT INTO versions VALUES ('oracle', '19c', 'amd', 1, '20200801', '', '', '');

-- ##
INSERT INTO projects VALUES ('orafce', 5, 0, 'hub', 0, 'https://github.com/orafce/orafce/releases',
  'orafce', 1, 'larry.png', 'Ora Built-in Packages', 'https://github.com/orafce/orafce#orafce---oracles-compatibility-functions-and-packages');
INSERT INTO releases VALUES ('orafce-pg13', 2, 'orafce', 'OraFCE', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('orafce-pg13', '3.15.1-1',  'amd', 1, '20210506', 'pg13', '', '');
INSERT INTO versions VALUES ('orafce-pg13', '3.15.0-1',  'amd', 0, '20210311', 'pg13', '', '');
INSERT INTO versions VALUES ('orafce-pg13', '3.14.0-1',  'amd', 0, '20201222', 'pg13', '', '');

INSERT INTO projects VALUES ('fixeddecimal', 4, 0, 'hub', 0, 'https://github.com/pgsql-io/fixeddecimal/releases',
  'fixeddecimal', 1, 'fixeddecimal.png', 'Much faster than NUMERIC', 'https://github.com/pgsql-io/fixeddecimal');
INSERT INTO releases VALUES ('fixeddecimal-pg13', 90, 'fixeddecimal', 'FixedDecimal', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('fixeddecimal-pg13', '1.1.0-1',  'amd', 1, '20201119', 'pg13', '', '');

INSERT INTO projects VALUES ('plr', 3, 0, 'hub', 0, 'https://github.com/postgres-plr/plr/releases',
  'plr',   1, 'r-project.png', 'R Stored Procedures', 'https://github.com/postgres-plr/plr');
INSERT INTO releases VALUES ('plr-pg12', 4, 'plr', 'PL/R 8.4.1', '', 'soon', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('plr-pg12', '8.4-1', 'amd', 0, '20200912', 'pg12', '', '');

INSERT INTO projects VALUES ('plv8', 3, 0, 'hub', 0, 'https://github.com/plv8/plv8/releases',
  'plv8',   1, 'v8.png', 'Javascript Stored Procedures', 'https://github.com/plv8/plv8');
INSERT INTO releases VALUES ('plv8-pg12', 4, 'plv8', 'PL/V8', '', 'soon', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('plv8-pg12', '2.3.15-1', 'amd', 0, '20200711', 'pg12', '', '');

INSERT INTO projects VALUES ('plpython', 3, 0, 'hub', 0, 'https://www.postgresql.org/docs/13/plpython.html',
  'plpython', 1, 'python.png', 'Python3 Stored Procedures', 'https://www.postgresql.org/docs/13/plpython.html');
INSERT INTO releases VALUES ('plpython3', 5, 'plpython', 'PL/Python','', 'included', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('plpython3', '13', 'amd', 1, '20200213', 'pg13', '', '');

INSERT INTO projects VALUES ('plperl', 3, 0, 'hub', 0, 'https://www.postgresql.org/docs/13/plperl.html',
	'plperl', 1, 'perl.png', 'Perl Stored Procedures', 'https://www.postgresql.org/docs/13/plperl.html');
INSERT INTO releases VALUES ('plperl', 6, 'plperl', 'PL/Perl','', 'included', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('plperl', '13', 'amd', 1, '20200213', 'pg13', '', '');

INSERT INTO projects VALUES ('pljava', 3, 0, 'hub', 0, 'https://github.com/tada/pljava/releases', 
  'pljava', 1, 'pljava.png', 'Java Stored Procedures', 'https://github.com/tada/pljava');
INSERT INTO releases VALUES ('pljava-pg13', 7, 'pljava', 'PL/Java', '', 'test', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pljava-pg13', '1.6.2-1',  'amd',  1, '20201127', 'pg13', '', '');

INSERT INTO projects VALUES ('pldebugger', 3, 0, 'hub', 0, 'https://github.com/bigsql/pldebugger2/releases',
  'pldebugger', 1, 'debugger.png', 'Procedural Language Debugger', 'https://github.com/bigsql/pldebugger2#pldebugger2');
INSERT INTO releases VALUES ('pldebugger-pg12', 2, 'pldebugger', 'PL/Debugger', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pldebugger-pg12', '2.0-1',  'amd',  1, '20200224', 'pg12', '', '');

INSERT INTO projects VALUES ('plpgsql', 3, 0, 'hub', 0, 'https://www.postgresql.org/docs/13/plpgsql-overview.html',
  'plpgsql', 0, 'jan.png', 'Postgres Procedural Language', 'https://www.postgresql.org/docs/13/plpgsql-overview.html');
INSERT INTO releases VALUES ('plpgsql', 1, 'plpgsql', 'PL/pgSQL', '', 'included', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('plpgsql', '13',  'amd',  1, '20200213', '', '', '');

INSERT INTO projects VALUES ('pgtsql', 3, 0, 'hub', 0, 'https://github.com/bigsql/pgtsql/releases',
  'pgtsql', 1, 'tds.png', 'Transact-SQL Procedures', 'https://github.com/bigsql/pgtsql#pgtsql');
INSERT INTO releases VALUES ('pgtsql-pg13', 3, 'pgtsql', 'PL/pgTSQL','', 'soon', '', 1, 'AGPLv3', '', '');
INSERT INTO versions VALUES ('pgtsql-pg13', '3.0-1', 'amd', 0, '20191119', 'pg13', '', '');

INSERT INTO projects VALUES ('plprofiler', 4, 0, 'hub', 7, 'https://github.com/bigsql/plprofiler/releases',
  'plprofiler', 1, 'plprofiler.png', 'Stored Procedure Profiler', 'https://github.com/bigsql/plprofiler#plprofiler');
INSERT INTO releases VALUES ('plprofiler-pg13', 0, 'plprofiler',    'PL/Profiler',  '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('plprofiler-pg13', '4.1-1', 'amd', 1, '20190823', 'pg13', '', '');

INSERT INTO projects VALUES ('backrest', 2, 0, 'hub', 0, 'https://github.com/pgbackrest/pgbackrest/releases',
  'backrest', 0, 'backrest.png', 'Backup & Restore', 'https://pgbackrest.org');
INSERT INTO releases VALUES ('backrest', 9, 'backrest', 'pgBackRest', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('backrest', '2.33-1', 'amd', 1, '20210405', '', '', 'https://pgbackrest.org/release.html#2.33');
INSERT INTO versions VALUES ('backrest', '2.32-1', 'amd', 0, '20210208', '', '', 'https://pgbackrest.org/release.html#2.32');
INSERT INTO versions VALUES ('backrest', '2.31-1', 'amd', 0, '20201208', '', '', '');

INSERT INTO projects VALUES ('audit', 2, 0, 'hub', 0, 'https://github.com/pgaudit/pgaudit/releases',
  'audit', 1, 'audit.png', 'Audit Logging', 'https://github.com/pgaudit/pgaudit');
INSERT INTO releases VALUES ('audit-pg13', 10, 'audit', 'pgAudit', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('audit-pg13', '1.5.0-1', 'amd', 1, '20200921', 'pg13', '',
  'https://github.com/pgaudit/pgaudit/releases/tag/1.5.0');

INSERT INTO projects VALUES ('anon', 2, 0, 'ddlx', 1, 'https://gitlab.com/dalibo/postgresql_anonymizer/-/tags',
  'anon', 1, 'anon.png', 'Anonymization & Masking', 'https://gitlab.com/dalibo/postgresql_anonymizer/blob/master/README.md');
INSERT INTO releases VALUES ('anon-pg13', 11, 'anon', 'Anonymizer', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('anon-pg13', '0.8.1-1', 'amd', 1, '20210210', 'pg13', '', '');
INSERT INTO versions VALUES ('anon-pg13', '0.7.1-1', 'amd', 0, '20200929', 'pg13', '', '');

INSERT INTO projects VALUES ('citus', 2, 0, 'hub',0, 'https://github.com/citusdata/citus/releases',
  'citus', 1, 'citus.png', 'Multi Node Data & Queries', 'https://github.com/citusdata/citus');
INSERT INTO releases VALUES ('citus-pg13',  5, 'citus', 'Citus', '', 'prod', '', 1, 'AGPLv3', '', '');
INSERT INTO versions VALUES ('citus-pg13', '10.0.3-1', 'amd', 1, '20210315', 'pg13', '', 'https://github.com/citusdata/citus/releases/tag/v10.0.3');

INSERT INTO projects VALUES ('cron', 4, 0, 'hub',0, 'https://github.com/citusdata/pg_cron/releases',
  'cron', 1, 'cron.png', 'Scheduler as Background Worker', 'https://github.com/citusdata/pg_cron');
INSERT INTO releases VALUES ('cron-pg13', 10, 'cron', 'pgCron', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('cron-pg13', '1.3.1-1', 'amd', 1, '20210330', 'pg13', '', '');
INSERT INTO versions VALUES ('cron-pg13', '1.3.0-1', 'amd', 0, '20201006', 'pg13', '', '');

INSERT INTO projects VALUES ('timescaledb', 2, 0, 'hub', 1, 'https://github.com/timescale/timescaledb/releases',
   'timescaledb', 1, 'timescaledb.png', 'Time Series Data', 'https://github.com/timescale/timescaledb/#timescaledb');
INSERT INTO releases VALUES ('timescaledb-pg13',  1, 'timescaledb', 'TimescaleDB', '', 'prod', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('timescaledb-pg13', '2.2.1-1',  'amd', 1, '20210505', 'pg13', '',
  'https://github.com/timescale/timescaledb/releases/tag/2.2.1');
INSERT INTO versions VALUES ('timescaledb-pg13', '2.2.0-1',  'amd', 0, '20210413', 'pg13', '',
  'https://github.com/timescale/timescaledb/releases/tag/2.2.0');
INSERT INTO versions VALUES ('timescaledb-pg13', '2.1.1-1',  'amd', 0, '20210329', 'pg13', '',
  'https://github.com/timescale/timescaledb/releases/tag/2.1.1');
INSERT INTO versions VALUES ('timescaledb-pg13', '2.1.0-1',  'amd', 0, '20210222', 'pg13', '',
  'https://github.com/timescale/timescaledb/releases/tag/2.1.0');

INSERT INTO projects VALUES ('pglogical', 2, 0, 'hub', 2, 'https://github.com/2ndQuadrant/pglogical/releases',
  'pglogical', 1, 'spock.png', 'Logical Replication', 'https://github.com/2ndQuadrant/pglogical');
INSERT INTO releases VALUES ('pglogical-pg13', 2, 'pglogical', 'pgLogical', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pglogical-pg13', '2.3.4-1',  'amd', 1, '20210503', 'pg13', '',
  'https://github.com/2ndQuadrant/pglogical/releases/tag/REL2_3_4');
INSERT INTO versions VALUES ('pglogical-pg13', '2.3.3-1',  'amd', 0, '20201005', 'pg13', '',
  'https://github.com/2ndQuadrant/pglogical/releases/tag/REL2_3_3');

INSERT INTO projects VALUES ('postgis', 2, 1, 'hub', 3, 'http://postgis.net/source',
  'postgis', 1, 'postgis.png', 'Spatial Extensions', 'http://postgis.net');
INSERT INTO releases VALUES ('postgis-pg13', 3, 'postgis', 'PostGIS', '', 'prod', '', 1, 'GPLv2', '', '');
INSERT INTO versions VALUES ('postgis-pg13', '3.1.1-1', 'amd', 1, '20210128', 'pg13', '', 'https://git.osgeo.org/gitea/postgis/postgis/raw/tag/3.1.1/NEWS');
INSERT INTO versions VALUES ('postgis-pg13', '3.1.0-1', 'amd', 0, '20201210', 'pg13', '', 'https://git.osgeo.org/gitea/postgis/postgis/raw/tag/3.1.0/NEWS');
INSERT INTO versions VALUES ('postgis-pg13', '3.0.3-1', 'amd', 0, '20201119', 'pg13', '', 'https://git.osgeo.org/gitea/postgis/postgis/raw/tag/3.0.3/NEWS');
INSERT INTO versions VALUES ('postgis-pg13', '3.0.2-1', 'amd', 0, '20200815', 'pg13', '', 'https://git.osgeo.org/gitea/postgis/postgis/raw/tag/3.0.2/NEWS');

INSERT INTO projects VALUES ('omnidb', 9, 8000, '', 1, 'https://omnidb.org',
  'omnidb', 0, 'omnidb.png', 'OmniDB', 'https://omnidb.org');
INSERT INTO releases VALUES ('omnidb', 0, 'omnidb', 'OmniDB', '', 'test', '', 1, '', '', '');
INSERT INTO versions VALUES ('omnidb', '2.17.0', '', 1, '20191205', '', '', '');

INSERT INTO projects VALUES ('pgadmin', 9, 80, '', 1, 'https://pgadmin.org',
  'pgadmin', 0, 'pgadmin.png', 'PG Admin', 'https://pgadmin.org');
INSERT INTO releases VALUES ('pgadmin', 0, 'pgadmin', 'pgAdmin 4', '', 'test', '', 1, '', '', '');
INSERT INTO versions VALUES ('pgadmin', '5.2', '', 1, '20210422', '', '', '');
INSERT INTO versions VALUES ('pgadmin', '5.1', '', 0, '20210325', '', '', '');

INSERT INTO projects VALUES ('bulkload', 4, 0, 'hub', 5, 'https://github.com/ossc-db/pg_bulkload/releases',
  'bulkload', 1, 'bulkload.png', 'High Speed Data Loading', 'https://github.com/ossc-db/pg_bulkload');
INSERT INTO releases VALUES ('bulkload-pg13', 6, 'bulkload', 'pgBulkLoad',  '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('bulkload-pg13', '3.1.17-1', 'amd', 1, '20210205', 'pg13', '', '');

INSERT INTO projects VALUES ('repack', 4, 0, 'hub', 5, 'https://github.com/reorg/pg_repack/releases',
  'repack', 1, 'repack.png', 'Remove Table/Index Bloat' , 'https://github.com/reorg/pg_repack');
INSERT INTO releases VALUES ('repack-pg13', 6, 'repack', 'pgRepack',  '', 'prod','',  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('repack-pg13', '1.4.6-1', 'amd', 1, '20200930', 'pg13', '', '');

INSERT INTO projects VALUES ('partman', 4, 0, 'hub', 4, 'https://github.com/pgpartman/pg_partman/releases',
  'partman', 1, 'partman.png', 'Partition Managemnt', 'https://github.com/pgpartman/pg_partman#pg-partition-manager');
INSERT INTO releases VALUES ('partman-pg13', 6, 'partman', 'pgPartman',   '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('partman-pg13', '4.5.1-1',  'amd', 1, '20210513', 'pg13', '', '');
INSERT INTO versions VALUES ('partman-pg13', '4.5.0-1',  'amd', 0, '20210331', 'pg13', '', '');
INSERT INTO versions VALUES ('partman-pg13', '4.4.1-1',  'amd', 0, '20201223', 'pg13', '', '');

INSERT INTO projects VALUES ('hypopg', 4, 0, 'hub', 8, 'https://github.com/HypoPG/hypopg/releases',
  'hypopg', 1, 'whatif.png', 'Hypothetical Indexes', 'https://hypopg.readthedocs.io/en/latest/');
INSERT INTO releases VALUES ('hypopg-pg13', 99, 'hypopg', 'HypoPG', '', 'prod','',  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('hypopg-pg13', '1.2.0-1',  'amd', 1, '20210226', 'pg13', '', '');
INSERT INTO versions VALUES ('hypopg-pg13', '1.1.4-1',  'amd', 0, '20200711', 'pg13', '', '');

INSERT INTO projects VALUES ('badger', 4, 0, 'hub', 6, 'https://github.com/darold/pgbadger/releases',
  'badger', 0, 'badger.png', 'Performance Reporting', 'https://pgbadger.darold.net');
INSERT INTO releases VALUES ('badger', 101, 'badger','pgBadger','', 'test', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('badger', '11.5', '', 2, '20210218', '', '', '');

INSERT INTO projects VALUES ('bouncer',  4, 0, 'hub', 3, 'http://pgbouncer.org',
  'bouncer',  0, 'bouncer.png', 'Lightweight Connection Pooler', 'http://pgbouncer.org');
INSERT INTO releases VALUES ('bouncer', 1, 'bouncer',  'pgBouncer', '', 'test', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('bouncer', '1.15.0-1', 'amd', 1, '20201119', '', '', '');
INSERT INTO versions VALUES ('bouncer', '1.14.0-1', 'amd', 0, '20200611', '', '', '');
INSERT INTO versions VALUES ('bouncer', '1.13.0-1', 'amd', 0, '20200427', '', '', '');

INSERT INTO projects VALUES ('patroni',  2, 0, 'haproxy', 4, 'https://github.com/zalando/patroni/releases',
  'patroni', 0, 'patroni.png', 'Postgres HA Template', 'https://github.com/zalando/patroni');
INSERT INTO releases VALUES ('patroni', 1, 'patroni', 'Patroni', '', 'test', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('patroni', '2.0.2', '', 1, '20210222', '', '', 'https://github.com/zalando/patroni/releases/tag/v2.0.2');
INSERT INTO versions VALUES ('patroni', '2.0.1', '', 0, '20201001', '', '', 'https://github.com/zalando/patroni/releases/tag/v2.0.1');
INSERT INTO versions VALUES ('patroni', '2.0.0', '', 0, '20200902', '', '', 'https://github.com/zalando/patroni/releases/tag/v2.0.0');

INSERT INTO projects VALUES ('pgjdbc', 7, 0, 'hub', 1, 'https://jdbc.postgresql.org', 'jdbc', 0, 'java.png', 'JDBC Driver', 'https://jdbc.postgresql.org');
INSERT INTO releases VALUES ('pgjdbc', 7, 'jdbc', 'JDBC', '', 'bring-own', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pgjdbc', '42.2.18', '', 0, '20201015', '', '',
  'https://jdbc.postgresql.org/documentation/changelog.html#version_42.2.18');

INSERT INTO projects VALUES ('npgsql', 7, 0, 'hub', 2, 'https://www.nuget.org/packages/Npgsql/', 'npgsql', 0, 'npgsql.png', '.NET Provider', 'https://www.npgsql.org');
INSERT INTO releases VALUES ('npgsql', 20, 'npgsql', '.net PG', '', 'bring-own', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('npgsql', '5.0.1.1', '', 0, '20201211', '', '', '');
INSERT INTO versions VALUES ('npgsql', '5.0.0', '', 0, '20201115', '', '', '');
INSERT INTO versions VALUES ('npgsql', '4.1.5', '', 0, '20200929', '', '', '');

INSERT INTO projects VALUES ('psycopg', 7, 0, 'hub', 3, 'https://pypi.org/project/psycopg2/', 'psycopg', 0, 'psycopg.png', 'Python Adapter', 'http://psycopg.org');
INSERT INTO releases VALUES ('psycopg', 6, 'psycopg', 'Psycopg2', '', 'bring-own', '', 1, 'LGPLv2', '', '');
INSERT INTO versions VALUES ('psycopg', '2.8.6', '', 0, '20200906', '', '', '');

INSERT INTO projects VALUES ('ruby', 7, 0, 'hub', 4, 'https://rubygems.org/gems/pg', 'ruby', 0, 'ruby.png', 'Ruby Interface', 'https://github.com');
INSERT INTO releases VALUES ('ruby', 7, 'ruby', 'Ruby', '', 'bring-own', '', 1, 'BSD-2', '', '');
INSERT INTO versions VALUES ('ruby', '1.2.3', '', 0, '20200318', '', '', '');

INSERT INTO projects VALUES ('psqlodbc', 3, 0, 'hub', 5, 'https://www.postgresql.org/ftp/odbc/versions/msi/', 'psqlodbc', 0, 'odbc.png', 'ODBC Driver', 'https://odbc.postgresql.org');
INSERT INTO releases VALUES ('psqlodbc', 2, 'psqlodbc',  'psqlODBC', '', 'prod', '', 1, 'LIBGPLv2', '', '');
INSERT INTO versions VALUES ('psqlodbc', '13.01-1', 'amd', 1, '20210502', '', '', '');
INSERT INTO versions VALUES ('psqlodbc', '13.00-1', 'amd', 0, '20201119', '', '', '');

INSERT INTO projects VALUES ('http', 3, 0, 'hub', 6, 'https://github.com/pramsey/pgsql-http/releases', 'http',  1, 'http.png', 'Invoke Web Services', 'https://github.com/pramsey/pgsql-http');
INSERT INTO releases VALUES ('http-pg12', 13, 'http', 'HTTP Client', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('http-pg12', '1.3.1-1', 'amd', 0, '20191225', 'pg12', '', '');

INSERT INTO projects VALUES ('ddlx',      7, 0, 'hub', 0, 'https://github.com/lacanoid/pgddl/releases', 'ddlx',  1, 'ddlx.png', 'DDL Extractor', 'https://github.com/lacanoid/pgddl#ddl-extractor-functions--for-postgresql');
INSERT INTO releases VALUES ('ddlx-pg13', 2, 'ddlx', 'DDLeXtact', '', 'prod','',  0, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('ddlx-pg13', '0.17-1', 'amd', 1, '20200911', 'pg13', '', '');

INSERT INTO projects VALUES ('wa',      4, 0, 'hub', 1, 'https://github.com/powa-team/powa-archivist/releases', 'powa',  1, 'powa.png', 'WorkLoad Analyzer', 'https://powa.readthedocs.io/en/latest/components/powa-archivist/index.html');
INSERT INTO releases VALUES ('wa-pg13', 97, 'wa', 'WA', '', '','', '', 'POSTGRES', '', '');
INSERT INTO versions VALUES ('wa-pg13', '2.1-1', 'amd', 2, '20210508', 'pg13', '', '');

INSERT INTO projects VALUES ('archivist',      4, 0, 'hub', 1, 'https://github.com/powa-team/powa-team/releases', 'archivist',  1, 'archivist.png', 'Snapshot Workloads', 'https://powa.readthedocs.io/en/latest/components/archivist-archivist/index.html');
INSERT INTO releases VALUES ('archivist-pg13', 97, 'archivist', 'POWA-Archivist', '', 'prod','',  0, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('archivist-pg13', '4.1.2-1', 'amd', 1, '20201220', 'pg13', '', '');

INSERT INTO projects VALUES ('qualstats', 4, 0, 'powa', 2, 'https://github.com/powa-team/pg_qualstats/releases',
  'qualstats', 1, 'qualstats.png', 'Predicate Stats', 'https://github.com/powa-team/pg_qualstats');
INSERT INTO releases VALUES ('qualstats-pg13', 98, 'qualstats', 'POWA-QualStats', '', 'prod','',  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('qualstats-pg13', '2.0.2-1', 'amd', 1, '20200523', 'pg13', '', '');

INSERT INTO projects VALUES ('statkcache', 4, 0, 'powa', 3, 'https://github.com/powa-team/pg_stat_kcache/releases',
  'statkcache', 1, 'statkcache.png', 'Filesystem Stats', 'https://github.com/powa-team/pg_stat_kcache');
INSERT INTO releases VALUES ('statkcache-pg13', 98, 'statkcache', 'POWA-StatKcache', '', 'prod','',  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('statkcache-pg13', '2.2.0-1', 'amd', 1, '20201210', 'pg13', '', '');

INSERT INTO projects VALUES ('waitsampling', 4, 0, 'powa', 4, 'https://github.com/postgrespro/pg_wait_sampling/releases',
  'waitsampling', 1, 'waitsampling.png', 'Stats for Wait Events', 'https://github.com/postgrespro/pg_wait_sampling');
INSERT INTO releases VALUES ('waitsampling-pg13', 98, 'waitsampling', 'WaitSampling', '', 'prod','',  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('waitsampling-pg13', '1.1.3-1', 'amd', 1, '20210127', 'pg13', '', '');

INSERT INTO projects VALUES ('multicorn', 5, 0, 'hub', 0, 'https://github.com/pgsql-io/Multicorn/',
  'multicorn', 1, 'multicorn.png', 'Python FDW Library', 'http://multicorn.org');
INSERT INTO releases VALUES ('multicorn-pg13', 99, 'multicorn', 'Multicorn', '', 'prod','',  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('multicorn-pg13', '1.4.1-1', 'amd', 1, '20210412', 'pg13', '', '');
