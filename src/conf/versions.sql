
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


CREATE TABLE service_types (
  svc_type       TEXT NOT NULL PRIMARY KEY,
  svc_group      TEXT NOT NULL,
  disp_name      TEXT NOT NULL,
  sort_order     SMALLINT NOT NULL
);
INSERT INTO service_types VALUES ('sql',         'db',  'Relational',       1);
INSERT INTO service_types VALUES ('time',        'db',  'Timeseries',       2);
INSERT INTO service_types VALUES ('nosql',       'db',  'NoSQL',            3);
INSERT INTO service_types VALUES ('big',         'db',  'Analytical',       4);
INSERT INTO service_types VALUES ('int',         'int', 'Integration',      5);


CREATE TABLE services (
  service        TEXT NOT NULL PRIMARY KEY REFERENCES projects(projects),
  svc_type       TEXT NOT NULL REFERENCES service_types(svc_type),
  sort_order     SMALLINT NOT NULL
);
INSERT INTO services VALUES ('pg',            'sql',   1);
INSERT INTO services VALUES ('mariadb',       'sql',   2);
INSERT INTO services VALUES ('sqlsvr',        'sql',   3);
INSERT INTO services VALUES ('oracle',        'sql',   4);
INSERT INTO services VALUES ('mongodb',       'sql',   5);
INSERT INTO services VALUES ('elasticsearch', 'big',   6);
INSERT INTO services VALUES ('prestosql',     'big',   7);

CREATE VIEW v_services AS
  SELECT t.sort_order as sort1, s.sort_order as sort2, t.svc_group, 
         t.svc_type, t.disp_name as svc_type_name,
         s.service, s.svc_type, s.sort_order, p.sources_url, p.short_name,
         p.image_file, p.description, p.project_url 
    FROM service_types t, services s, projects p 
   WHERE t.svc_type = s.svc_type
     AND s.service = p.project
ORDER BY 1, 2;


CREATE TABLE provider_types (
  provider_type  TEXT NOT NULL PRIMARY KEY,
  sort_order     SMALLINT NOT NULL,
  disp_name      TEXT
);
INSERT INTO provider_types VALUES ('public',    'Public Clouds',  1);
INSERT INTO provider_types VALUES ('private',   'Private Clouds', 2);
INSERT INTO provider_types VALUES ('container', 'Containers',     3);
INSERT INTO provider_types VALUES ('other',     'Other',          4);


CREATE TABLE providers (
  provider      TEXT     NOT NULL PRIMARY KEY,
  provider_type TEXT     NOT NULL REFERENCES provider_types(provider_type),
  sort_order    SMALLINT NOT NULL,
  status        TEXT     NOT NULL,
  short_name    TEXT     NOT NULL,
  disp_name     TEXT     NOT NULL,
  image_file    TEXT     NOT NULL
);
INSERT INTO providers VALUES ('aws',          'public',     1, 'prod', 'AWS',         'Amazon Web Services',   'aws.png');
INSERT INTO providers VALUES ('gcp',          'public',     2, 'test', 'GCP',         'Google Cloud Platform', 'gcp.png');
INSERT INTO providers VALUES ('azure',        'public',     3, 'test', 'Azure',       'Microsoft Azure',       'azure.png');
INSERT INTO providers VALUES ('ibm',          'public',     4, 'plan', 'IBM',         'IBM Cloud',             'ibm_cloud.png');
INSERT INTO providers VALUES ('alibaba',      'public',     5, 'plan', 'Alibaba',     'Alibaba Cloud',         'alibaba.png');
INSERT INTO providers VALUES ('digitalocean', 'public',     6, 'plan', 'DigtalOcean', 'Digital Ocean',         'digital_ocean.png');
INSERT INTO providers VALUES ('equinix',      'public',     7, 'test', 'Equinix',     'Equinix Metal',         'equinix.png');
INSERT INTO providers VALUES ('linode',       'public',     8, 'plan', 'Linode',      'Linode',                'linode.png');
INSERT INTO providers VALUES ('rackspace',    'public',     9, 'plan', 'Rackspace',   'Rackspace',             'rackspace');
INSERT INTO providers VALUES ('vultr',        'public',    10, 'plan', 'Vultr',       'Vultr',                 'vultr.png');
INSERT INTO providers VALUES ('pgsql',        'public',    11, 'prod', 'PGSQL',       'PGSQL.IO',              'postgresql.png');
INSERT INTO providers VALUES ('openstack',    'private',    1, 'test', 'OpenStack',   'OpenStack',             'open_stack.png');
INSERT INTO providers VALUES ('vsphere',      'private',    2, 'plan', 'vSphere',     'VMware vSphere',        'vsphere.png');
INSERT INTO providers VALUES ('docker',       'container',  1, 'test', 'Docker',      'Docker Engine',         'docker.png');
INSERT INTO providers VALUES ('lxd',          'container',  3, 'plan', 'LXD',         'LXD Containers',        'lxd.png');
INSERT INTO providers VALUES ('kvm',          'other',      1, 'plan', 'KVM',         'KVM Hypervisor',        'kvm.png');
INSERT INTO providers VALUES ('server',       'other',      2, 'test', 'BareMetal',   'Other Server',          'server.png');


CREATE TABLE volume_types (
  volume_type    TEXT     NOT NULL PRIMARY KEY,
  typical_iops   INTEGER  NOT NULL
);
INSERT INTO volume_types VALUES ('disk', 100);
INSERT INTO volume_types VALUES ('ssd',  10000);
INSERT INTO volume_types VALUES ('pcie', 100000);
INSERT INTO volume_types VALUES ('ram',  10000000);


CREATE TABLE metros (
  metro         TEXT       NOT NULL PRIMARY KEY,
  area          TEXT       NOT NULL,
  country       TEXT       NOT NULL,
  disp_name     TEXT       NOT NULL
);
INSERT INTO metros VALUES ('north-va', 'east', 'us', 'Northern Virginia');
INSERT INTO metros VALUES ('ohio',     'east', 'us', 'Ohio');
INSERT INTO metros VALUES ('north-nj', 'east', 'us', 'Northern New Jersey');
INSERT INTO metros VALUES ('north-ca', 'west', 'us', 'Northern California');
INSERT INTO metros VALUES ('oregon',   'west', 'us', 'Oregon');


CREATE TABLE regions (
  provider      TEXT       NOT NULL REFERENCES providers(provider),
  region        TEXT       NOT NULL,
  metro         TEXT       NOT NULL REFERENCES metros(metro),
  PRIMARY KEY (provider, region)
);
INSERT INTO regions VALUES ('aws',   'us-east-1', 'north-va');
INSERT INTO regions VALUES ('aws',   'us-east-2', 'ohio');
INSERT INTO regions VALUES ('aws',   'us-west-1', 'north-ca');
INSERT INTO regions VALUES ('aws',   'us-west-2', 'oregon');
INSERT INTO regions VALUES ('pgsql', 'nnj',       'north-nj');
INSERT INTO regions VALUES ('pgsql', 'col',       'ohio');


CREATE VIEW v_regions AS
  SELECT m.country, m.area, m.disp_name as metro_name, m.metro, 
         r.provider, r.region
    FROM regions r, metros m
   WHERE r.metro = m.metro
 ORDER BY 1, 2, 4, 5, 6;


CREATE TABLE locations (
  provider      TEXT       NOT NULL REFERENCES providers(provider),
  region        TEXT       NOT NULL REFERENCES regions(region),
  location      TEXT       NOT NULL,
  is_preferred  SMALLINT   NOT NULL,
  PRIMARY KEY (provider, region, location)
);
INSERT INTO locations VALUES ('aws',   'us-east-1', 'us-east-1a', 0);
INSERT INTO locations VALUES ('aws',   'us-east-1', 'us-east-1b', 0);
INSERT INTO locations VALUES ('aws',   'us-east-1', 'us-east-1c', 0);
INSERT INTO locations VALUES ('aws',   'us-east-1', 'us-east-1d', 1);
INSERT INTO locations VALUES ('aws',   'us-east-1', 'us-east-1e', 1);
INSERT INTO locations VALUES ('aws',   'us-east-1', 'us-east-1f', 1);
INSERT INTO locations VALUES ('aws',   'us-east-2', 'us-east-2a', 0);
INSERT INTO locations VALUES ('aws',   'us-east-2', 'us-east-2b', 0);
INSERT INTO locations VALUES ('aws',   'us-east-2', 'us-east-2c', 1);
INSERT INTO locations VALUES ('aws',   'us-east-2', 'us-east-2d', 1);
INSERT INTO locations VALUES ('pgsql', 'nnj',       'nnj2',       1);
INSERT INTO locations VALUES ('pgsql', 'nnj',       'nnj3',       1);
INSERT INTO locations VALUES ('pgsql', 'col',       'col1',       1);


CREATE VIEW v_locations AS
  SELECT m.country, m.area, m.disp_name as metro_name, m.metro, 
         r.provider, r.region, l.location, l.is_preferred
    FROM locations l, regions r, metros m
   WHERE l.provider = r.provider
     AND l.region   = r.region
     AND r.metro    = m.metro
 ORDER BY 4, 5, 6, 7;


CREATE TABLE image_types (
  image_type    TEXT NOT NULL PRIMARY KEY,
  disp_name     TEXT NOT NULL,
  os            TEXT NOT NULL
);
INSERT INTO image_types VALUES ('cos7',  'CentOS 7',     'linux');
INSERT INTO image_types VALUES ('cos8',  'CentOS 8',     'linux');
INSERT INTO image_types VALUES ('ubu18', 'Ubuntu 18.04 LTS', 'linux');
INSERT INTO image_types VALUES ('ubu20', 'Ubuntu 20.04 LTS', 'linux');


CREATE TABLE images (
  image_type         TEXT  NOT NULL,
  provider           TEXT  NOT NULL,
  region             TEXT  NOT NULL,
  platform           TEXT  NOT NULL,
  is_default         SMALLINT NOT NULL,
  image_id           TEXT  NOT NULL,
  PRIMARY KEY (image_type, provider, region, platform)
);
INSERT INTO images VALUES ('ubu20', 'aws',   'us-east-2', 'amd', 1, 'ami-0b287e7832eb862f8' );
INSERT INTO images VALUES ('cos8',  'pgsql', 'RegionOne', 'amd', 0, 'dbc325a0-cab8-4674-b8c2-d23711c26337');
INSERT INTO images VALUES ('ubu20', 'pgsql', 'RegionOne', 'amd', 1, 'caa7edd2-5f07-4382-a235-fde652e9894e');


CREATE VIEW v_images AS
  SELECT t.os, t.image_type, t.disp_name, i.provider, i.region, 
         i.platform, i.is_default, i.image_id  
    FROM image_types t, images i
   WHERE i.image_type = t.image_type
  ORDER BY 1, 2, 3, 4, 5, 6;


CREATE TABLE flavors (
  provider      TEXT     NOT NULL REFERENCES providers(provider),
  family        TEXT     NOT NULL,
  flavor        TEXT     NOT NULL,
  size          TEXT     NOT NULL,
  v_cpu         INTEGER  NOT NULL,
  mem_gb        INTEGER  NOT NULL,
  das_gb        INTEGER  NOT NULL,
  price_hr      DECIMAL(9,3) NOT NULL,
  PRIMARY KEY (provider, flavor)
);
INSERT INTO flavors VALUES ('pgsql', 'm5d', 'l',    'm5d.large',     2,   8,   75, 0.064);
INSERT INTO flavors VALUES ('pgsql', 'm5d', 'xl',   'm5d.xlarge',    4,  16,  150, 0.128);
INSERT INTO flavors VALUES ('pgsql', 'm5d', '2xl',  'm5d.2xlarge',   8,  32,  300, 0.256);
INSERT INTO flavors VALUES ('pgsql', 'm5d', '4xl',  'm5d.4xlarge',  16,  64,  600, 0.512);
INSERT INTO flavors VALUES ('pgsql', 'm5d', '8xl',  'm5d.8xlarge',  32, 128, 1200, 1.025);
INSERT INTO flavors VALUES ('pgsql', 'm5d', '12xl', 'm5d.12xlarge', 48, 192, 1800, 1.537);
INSERT INTO flavors VALUES ('pgsql', 'm5d', '16xl', 'm5d.16xlarge', 64, 256, 2400, 2.049);
INSERT INTO flavors VALUES ('pgsql', 'm5d', '24xl', 'm5d.24xlarge', 96, 384, 3600, 3.074);
INSERT INTO flavors VALUES ('aws',   'm5d', 'l',    'm5d.large',     2,   8,   75, 0.096);
INSERT INTO flavors VALUES ('aws',   'm5d', 'xl',   'm5d.xlarge',    4,  16,  150, 0.192);
INSERT INTO flavors VALUES ('aws',   'm5d', '2xl',  'm5d.2xlarge',   8,  32,  300, 0.384);
INSERT INTO flavors VALUES ('aws',   'm5d', '4xl',  'm5d.4xlarge',  16,  64,  600, 0.768);
INSERT INTO flavors VALUES ('aws',   'm5d', '8xl',  'm5d.8xlarge',  32, 128, 1200, 1.536);
INSERT INTO flavors VALUES ('aws',   'm5d', '12xl', 'm5d.12xlarge', 48, 192, 1800, 2.304);
INSERT INTO flavors VALUES ('aws',   'm5d', '16xl', 'm5d.16xlarge', 64, 256, 2400, 3.072);
INSERT INTO flavors VALUES ('aws',   'm5d', '24xl', 'm5d.24xlarge', 96, 384, 3600, 4.608);


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
INSERT INTO categories VALUES (1,  10, 'Strategic & Rock-Solid Postgres', 'PostgreSQL');
INSERT INTO categories VALUES (4, 100, 'Hybrid & Multi-Cloud', 'Multi-Cloud');
INSERT INTO categories VALUES (10, 96, 'Foreign Datastores', 'ForeignData');
INSERT INTO categories VALUES (2,  60, 'Advanced Applications', 'Applications');
INSERT INTO categories VALUES (5,  70, 'Data Integration', 'Integration');
INSERT INTO categories VALUES (3,  80, 'Procedural Programming', 'Procedural');
INSERT INTO categories VALUES (9,  87, 'Management & Monitoring', 'Manage');

-- ## HUB ################################
INSERT INTO projects VALUES ('hub',0, 0, 'hub', 0, 'https://github.com/bigsql/pgsql-io','',0,'','','');
INSERT INTO releases VALUES ('hub', 1, 'hub', '', '', 'hidden', '', 1, 'AGPLv3', '', '');
INSERT INTO versions VALUES ('hub', '6.35', '',  1, '20210127', '', '', '');
INSERT INTO versions VALUES ('hub', '6.34', '',  0, '20210127', '', '', '');
INSERT INTO versions VALUES ('hub', '6.33', '',  0, '20201212', '', '', '');
INSERT INTO versions VALUES ('hub', '6.32', '',  0, '20201119', '', '', '');

-- ##
INSERT INTO projects VALUES ('pg', 1, 5432, 'hub', 1, 'https://postgresql.org/download',
 'postgres', 0, 'postgresql.png', 'Best RDBMS', 'https://postgresql.org');

INSERT INTO releases VALUES ('pg10', 4, 'pg', 'PostgreSQL', '', 'prod', 'works w/ python2, EL7+, Ubu18+', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pg10', '10.15-1', 'amd', 1, '20201112', '', 'LIBC-2.17', '');
INSERT INTO versions VALUES ('pg10', '10.14-1', 'amd', 0, '20200813', '', 'LIBC-2.17', '');

INSERT INTO releases VALUES ('pg11', 3, 'pg', 'PostgreSQL', '', 'prod', 'works w/ python2, EL7+, Ubu18+', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pg11', '11.10-1', 'amd', 1, '20201112', '', 'LIBC-2.17', '');
INSERT INTO versions VALUES ('pg11', '11.9-1',  'amd', 0, '20200813', '', 'LIBC-2.17', '');

INSERT INTO releases VALUES ('pg12', 2, 'pg', 'PostgreSQL', '', 'prod', 'works w/ python3, EL8, Ubu20', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pg12', '12.5-2', 'arm, amd', 1, '20201112', '', 'LIBC-2.28', '');
INSERT INTO versions VALUES ('pg12', '12.5-1', 'arm, amd', 0, '20201112', '', 'LIBC-2.28', '');
INSERT INTO versions VALUES ('pg12', '12.4-1', 'arm, amd', 0, '20200813', '', 'LIBC-2.28', '');
INSERT INTO versions VALUES ('pg12', '12.3-1', 'arm, amd', 0, '20200514', '', 'LIBC-2.28', '');

INSERT INTO releases VALUES ('pg13', 1, 'pg', 'PostgreSQL', '', 'prod', 'works w/ python3, EL8, Ubu20', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pg13', '13.1-2',  'arm, amd', 1, '20201112','', 'LIBC-2.28', '');
INSERT INTO versions VALUES ('pg13', '13.1-1',  'arm, amd', 0, '20201112','', 'LIBC-2.28', '');
INSERT INTO versions VALUES ('pg13', '13.0-1',  'arm, amd', 0, '20200924','', 'LIBC-2.28', '');

-- ##
INSERT INTO projects VALUES ('cassandra', 10, 9042, 'hub', 0, 'https://cassandra.apache.org/download', 
  'cassandra', 0, 'cstar.png', 'Multi-Master across Regions', 
  'https://cassandra.apache.org');
INSERT INTO releases VALUES ('cassandra', 5, 'cassandra','Cassandra 3.11.9', '', 'soon', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('cassandra', '3.11-1', '', 0, '20201104', '', '', '');

INSERT INTO projects VALUES ('cassandrafdw', 5, 0, 'hub', 0, 'https://github.com/pgsql-io/cassandra_fdw/releases', 
  'cstarfdw', 1, 'cstar.png', 'Cassandra from PG', 'https://github.com/pgsql-io/cassandra_fdw#cassandra_fdw');
INSERT INTO releases VALUES ('cassandrafdw-pg12', 12, 'cassandrafdw', 'CassandraFDW','','test', '', 1, 'AGPLv3', '', '');
INSERT INTO versions VALUES ('cassandrafdw-pg12', '3.1.5-1', 'amd', 0, '20191230', 'pg12', '', '');

INSERT INTO projects VALUES ('mongodb', 10, 27017, 'hub', 0, 'https://github.com/mongodb/mongo/releases', 
  'mongodb', 0, 'mongodb.png', 'Distributed Document Database', 'https://mongodb.org');
INSERT INTO releases VALUES ('mongodb', 4, 'mongodb', 'MongoDB', '', 'soon', '', 1, 'AGPLv3',
  'mongod --version', 'mongod --version | head -1 | awk ''{print $3}'' | sed s/v//g');
INSERT INTO versions VALUES ('mongodb', '4.4.3', '', 0, '20201221', '', 'EL8 AMD64', '');
INSERT INTO versions VALUES ('mongodb', '4.4.2', '', 0, '20201116', '', 'EL8 AMD64', '');
INSERT INTO versions VALUES ('mongodb', '4.4.1', '', 0, '20200909', '', 'EL8 AMD64', '');

INSERT INTO projects VALUES ('debezium', 5, 8080, 'kafka', 2, 'https://debezium.io/releases/1.2/', 
  'debezium', 0, 'debezium.png', 'Change Data Capture', 'https://debezium.io');
INSERT INTO releases VALUES ('debezium', 0, 'debezium', 'Debezium', '', 'test', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('debezium', '1.2.5', '', 0, '20200924', '', 'OPENJDK11', '');

INSERT INTO projects VALUES ('hivemeta', 10, 10000, 'hub', 0, 'https://hive.apache.org/downloads.html', 
  'hivemeta', 0, 'hive.png', 'Big Data SQL Metastore', 'https://hive.apache.org');
INSERT INTO releases VALUES ('hivemeta', 13, 'hivemeta', 'Hive Metastore', '', 'test', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('hivemeta', '3-1', '', 0, '20180607', '', 'OPENJDK11', '');

INSERT INTO projects VALUES ('kafka', 5, 9092, 'zookeeper', 1, 'https://kafka.apache.org/downloads', 
  'kafka', 0, 'kafka.png', 'Distributed Streaming Platform', 'https://kafka.apache.org');
INSERT INTO releases VALUES ('kafka', 0, 'kafka', 'Kafka', '', 'test', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('kafka', '2.7.0', '', 0, '20201221', '', 'EL8  OPENJDK11', 'https://downloads.apache.org/kafka/2.7.0/RELEASE_NOTES.html');

INSERT INTO projects VALUES ('mongofdw', 5, 0, 'hub', 0, 'https://github.com/EnterpriseDB/mongo_fdw/releases', 
  'mongofdw', 1, 'mongodb.png', 'MongoDB Queries from PG', 'https://github.com/EnterpriseDB/mongo_fdw#mongo_fdw');
INSERT INTO releases VALUES ('mongofdw-pg13', 14, 'mongofdw', 'MongoFDW', '', 'prod', '', 1, 'AGPLv3', '', '');
INSERT INTO versions VALUES ('mongofdw-pg13', '5.2.8-1', 'amd', 1, '20201027', 'pg13', '', '');

INSERT INTO projects VALUES ('hivefdw', 5, 0, 'hub', 0, 'https://github.com/pgsql-io/hive_fdw/releases', 
  'hivefdw', 1, 'hive.png', 'Big Data Queries from PG', 'https://github.com/pgsql-io/hive_fdw#hive_fdw');
INSERT INTO releases VALUES ('hivefdw-pg13', 14, 'hivefdw', 'HiveFDW', '', 'test', '', 1, 'AGPLv3', '', '');
INSERT INTO versions VALUES ('hivefdw-pg13', '4.0-1', 'amd', 1, '20200927', 'pg13', '', '');

INSERT INTO projects VALUES ('mariadb', 10, 3306, 'hub', 0, 'https://mariadb.org/downloads', 
  'mariadb', 0, 'mariadb.png', 'The MySQL Succesor', 'https://mariadb.org');
INSERT INTO releases VALUES ('mariadb', 1, 'mariadb', 'MySQL (MariaDB)', '', 'prod',  '', 1, 'GPLv2', '', '');
INSERT INTO versions VALUES ('mariadb', '10.5.8', '', 0, '20201111', '', 'EL8 AMD64', '');

INSERT INTO projects VALUES ('mysqlfdw', 5, 0, 'hub', 0, 'https://github.com/EnterpriseDB/mysql_fdw/releases', 
  'mysqlfdw', 1, 'mysql.png', 'Access MySQL, Percona & MariaDB', 'https://github.com/EnterpriseDb/mysql_fdw');
INSERT INTO releases VALUES ('mysqlfdw-pg13',  4, 'mysqlfdw', 'MySQL FDW',  '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('mysqlfdw-pg13', '2.5.5-1', 'amd', 1, '20201021', 'pg13', '', '');
INSERT INTO versions VALUES ('mysqlfdw-pg13', '2.5.4-1', 'amd', 0, '20200802', 'pg13', '', '');

INSERT INTO projects VALUES ('sqlsvr', 10, 1433, 'hub', 0, 'https://www.microsoft.com/en-us/sql-server/sql-server-2019',
  'sqlsvr', 0, 'sqlsvr.png', 'SQL Server 2019 for Linux', 'https://www.microsoft.com/en-us/sql-server/sql-server-2019');
INSERT INTO releases VALUES ('sqlsvr', 3, 'sqlsvr', 'SQL Server for Linux', '', 'proprietary',  '', 0, 'MICROSOFT', '', '');
INSERT INTO versions VALUES ('sqlsvr', '2019-1', 'amd', 0, '20200801', '', 'EL8 AMD64', '');

INSERT INTO projects VALUES ('sybase', 11, 0, 'hub', 0, 'https://sap.com/products/sybase-ase.html', 
  'sybase', 0, 'sybase.png', 'Sybase ASE', 'https://sap.com/products/sybase-ase.html');
INSERT INTO releases VALUES ('sybase', 21, 'sybase', 'SAP Sybase ASE', '', 'soon',  '', 0, 'SAP', '', '');
INSERT INTO versions VALUES ('sybase', '2019', 'amd', 0, '20191010', '', '', '');

INSERT INTO projects VALUES ('tdsfdw', 5, 0, 'hub', 0, 'https://github.com/tds-fdw/tds_fdw/releases',
  'tdsfdw', 1, 'tds.png', 'SQL Server & Sybase from PG', 'https://github.com/tds-fdw/tds_fdw/#tds-foreign-data-wrapper');
INSERT INTO releases VALUES ('tdsfdw-pg13', 3, 'tdsfdw', 'TDS FDW', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('tdsfdw-pg13', '2.0.2-1', 'amd',  1, '20200926', 'pg13', '', 'https://github.com/tds-fdw/tds_fdw/releases/tag/v2.0.2');

INSERT INTO projects VALUES ('proctab', 9, 0, 'hub', 0, 'https://github.com/markwkm/pg_proctab/releases',
  'proctab', 1, 'proctab.png', 'Monitoring Functions for pgTop', 'https://github.com/markwkm/pg_proctab');
INSERT INTO releases VALUES ('proctab-pg12', 8, 'proctab', 'pgProcTab', '', 'prod', '', 1, 'BSD-3', '', '');
INSERT INTO versions VALUES ('proctab-pg12', '0.0.9-1', 'amd',  0, '20200508', 'pg12', '', '');

INSERT INTO projects VALUES ('pgtop', 9, 0, 'proctab', 0, 'https://github.com/markwkm/pg_top/releases',
  'pgtop', 1, 'pgtop.png', '"top" for Postgres', 'https://github.com/markwkm/pg_top/');
INSERT INTO releases VALUES ('pgtop-pg12', 8, 'pgtop', 'pgTop', '', 'prod', '', 1, 'BSD-3', '', '');
INSERT INTO versions VALUES ('pgtop-pg12', '4.0.0-1', 'amd',  0, '20201008', 'pg12', '', '');

INSERT INTO projects VALUES ('hadoop', 10, 0, 'hub', 1, 'https://hadoop.apache.org/releases.html',
  'hadoop', 0, 'hadoop.png', 'Hadoop', 'https://hadoop.apache.org');
INSERT INTO releases VALUES ('hadoop', 20, 'hadoop', 'Hadoop', '', 'soon', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('hadoop', '3.3.0', '',  0, '20200714', '', '', '');
INSERT INTO versions VALUES ('hadoop', '3.2.1', '',  0, '20200923', '', '', '');

INSERT INTO projects VALUES ('zookeeper', 13, 2181, 'hub', 1, 'https://zookeeper.apache.org/releases.html#releasenotes',
  'zookeeper', 0, 'zookeeper.png', 'Distributed Key-Store for HA', 'https://zookeeper.apache.org');
INSERT INTO releases VALUES ('zookeeper', 5, 'zookeeper', 'Zookeeper', '', 'prod', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('zookeeper', '3.6.2', '',  0, '20200909', '', 'OPENJDK11',
  'https://zookeeper.apache.org/doc/r3.6.2/releasenotes.html');

INSERT INTO projects VALUES ('prestosql', 10, 1515, 'hub', 1, 'https://github.com/prestosql/presto/releases',
  'prestosql', 0, 'presto.png', 'Distributed SQL Query Engine', 'https://github.com/prestosql/presto');
INSERT INTO releases VALUES ('prestosql', 13, 'prestosql', 'PrestoSQL (Trino)', '', 'soon', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('prestosql', '351', '',  0, '20210103', '', 'OPENJDK11', '');
INSERT INTO versions VALUES ('prestosql', '350', '',  0, '20201229', '', 'OPENJDK11', '');
INSERT INTO versions VALUES ('prestosql', '347', '',  0, '20201126', '', 'EL7 OPENJDK11', '');
INSERT INTO versions VALUES ('prestosql', '346', '',  0, '20201110', '', 'EL7 OPENJDK11', '');

INSERT INTO projects VALUES ('elasticsearch', 10, 9200, 'hub', 1, 'https://www.elastic.co/downloads/elasticsearch',
  'elasticsearch', 0, 'elastic-search.png', 'ElasticSearch', 'https://github.com/elastic/elasticsearch#elasticsearch');
INSERT INTO releases VALUES ('elasticsearch', 5, 'elasticsearch', 'ElasticSearch', '', 'soon', '', 1, 'Apache', 
  'curl -sXGET ''http://127.0.0.1:9200/?pretty'' | grep number',
  'curl -sXGET ''http://127.0.0.1:9200/?pretty'' | grep number | awk ''{print $3}'' | sed s/\"//g | sed s/,//g');
INSERT INTO versions VALUES ('elasticsearch', '7.10.1', '',  0, '20201209', '', 'EL8 OPENJDK11', '');
INSERT INTO versions VALUES ('elasticsearch', '7.10.0', '',  0, '20201111', '', 'EL8 OPENJDK11', '');

INSERT INTO projects VALUES ('kibana', 9, 5601, 'elasticsearch', 1, 'https://www.elastic.co/downloads/kibana',
  'kibana', 0, 'kibana.png', 'Window into the Elastic Stack', 'https://github.com/elastic/kibana#kibana');
INSERT INTO releases VALUES ('kibana', 5, 'kibana', 'Kibana', '', 'test', '', 1, 'Apache', 
  '/usr/share/kibana/bin/kibana --version',
  '/usr/share/kibana/bin/kibana --version');
INSERT INTO versions VALUES ('kibana', '7.10.1', '',  0, '20201209', '', 'OPENJDK11', '');

INSERT INTO projects VALUES ('logstash', 9, 5601, 'kibana', 1, 'https://www.elastic.co/downloads/logstash',
  'logstash', 0, 'logstash.png', 'Server-side Processing Pipeline', 'https://github.com/elastic/logstash#logstash');
INSERT INTO releases VALUES ('logstash', 5, 'logstash', 'Logstash', '', 'test', '', 1, 'Apache', 
  'unset JAVA_HOME; /usr/share/logstash/bin/logstash --version',
  'unset JAVA_HOME; /usr/share/logstash/bin/logstash --version  | grep ''logstash '' | awk ''{print $2}''');
INSERT INTO versions VALUES ('logstash', '7.10.1', '',  0, '20201209', '', 'OPENJDK11', '');

INSERT INTO projects VALUES ('etcd',  4, 2379, 'hub', 1, 'https://github.com/etcd-io/etcd/releases',
  'etcd', 0, 'etcd.png', 'Distributed Key-Store', 'https://github.com/etcd-io/etcd#etcd');
INSERT INTO releases VALUES ('etcd', 5, 'etcd', 'Etcd', '', 'bring-own', '', 1, 'Apache', 
  '/usr/local/bin/etcd --version',
  '/usr/local/bin/etcd --version | head -1 | awk ''{print $3}''');
INSERT INTO versions VALUES ('etcd', '3.4.14', '',  0, '20201125', '', 'EL8', '');

INSERT INTO projects VALUES ('haproxy',  4, 1, 'hub', 1, 'https://git.centos.org/rpms/haproxy/releases',
  'haproxy', 0, 'haproxy.png', 'Load Balancer', 'https://haproxy.org');
INSERT INTO releases VALUES ('haproxy', 5, 'haproxy', 'HAProxy', '', 'bring-own', '', 1, 'GPLv2', 
  'haproxy -v', 'haproxy -v | head -1 | awk ''{print $3}''');
INSERT INTO versions VALUES ('haproxy', '1.8.23', '',  0, '20201128', '', '', '');

INSERT INTO projects VALUES ('rabbitmq', 9, 5672, 'hub', 1, 'https://github.com/rabbitmq/rabbitmq-server/releases',
  'rabbitmq', 0, 'rabbitmq.png', 'Message Broker', 'https://github.com/rabbitmq/rabbitmq-server');
INSERT INTO releases VALUES ('rabbitmq', 5, 'rabbitmq', 'RabbitMQ', '', 'test', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('rabbitmq', '3.8.9', '',  0, '20200924', '', 'EL8', '');

INSERT INTO projects VALUES ('esfdw', 5, 0, 'multicorn', 1, 'https://github.com/matthewfranglen/postgres-elasticsearch-fdw/releases',
  'esfdw', 1, 'esfdw.png', 'Elastic Search from PG', 'https://github.com/matthewfranglen/postgres-elasticsearch-fdw#postgresql-elastic-search-foreign-data-wrapper');
INSERT INTO releases VALUES ('esfdw-pg13', 99, 'esfdw', 'ElasticSearchFDW', '', 'test', '', 1, 'MIT', '', '');
INSERT INTO versions VALUES ('esfdw-pg13', '0.10.2', 'amd',  1, '20201027', 'pg13', 'PYTHON3', '');
INSERT INTO versions VALUES ('esfdw-pg13', '0.10.0', 'amd',  0, '20201018', 'pg13', 'PYTHON3', '');

INSERT INTO projects VALUES ('ora2pg', 5, 0, 'hub', 0, 'https://github.com/darold/ora2pg/releases',
  'ora2pg', 0, 'ora2pg.png', 'Migrate from Oracle to PG', 'https://ora2pg.darold.net');
INSERT INTO releases VALUES ('ora2pg', 2, 'ora2pg', 'Oracle to PG', '', 'prod', '', 1, 'GPLv2', '', '');
INSERT INTO versions VALUES ('ora2pg', '21.0', '', 1, '20201012', '', 'GCC PERL',
  'https://github.com/darold/ora2pg/releases/tag/v21.0');
INSERT INTO versions VALUES ('ora2pg', '20.0', '', 0, '20200829', '', 'GCC PERL',
  'https://github.com/darold/ora2pg/releases/tag/v20.0');

INSERT INTO projects VALUES ('oraclefdw', 5, 0, 'hub', 0, 'https://github.com/laurenz/oracle_fdw/releases',
  'oraclefdw', 1, 'oracle_fdw.png', 'Oracle from PG', 'https://github.com/laurenz/oracle_fdw');
INSERT INTO releases VALUES ('oraclefdw-pg13', 2, 'oraclefdw', 'Oracle FDW', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('oraclefdw-pg13','2.3.0-1', 'amd', 1, '20200924', 'pg13', '', 'https://github.com/laurenz/oracle_fdw/releases/tag/ORACLE_FDW_2_3_0');

INSERT INTO projects VALUES ('oracle', 10, 1521, 'hub', 0, 'https://www.oracle.com/downloads/licenses/database-11g-express-license.html', 
  'oracle', 0, 'oracle.png', 'Oracle 19c', 'https://www.oracle.com/downloads/licenses/database-11g-express-license.html');
INSERT INTO releases VALUES ('oracle', 2, 'oracle', 'Oracle', '', 'proprietary','', 0, 'ORACLE', '', '');
INSERT INTO versions VALUES ('oracle', '19c', 'amd', 0, '20200801', '', '', '');

-- ##
INSERT INTO projects VALUES ('orafce', 5, 0, 'hub', 0, 'https://github.com/orafce/orafce/releases',
  'orafce', 1, 'larry.png', 'Ora Built-in Packages', 'https://github.com/orafce/orafce#orafce---oracles-compatibility-functions-and-packages');
INSERT INTO releases VALUES ('orafce-pg13', 2, 'orafce', 'OraFCE', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('orafce-pg13', '3.14.0-1',  'amd', 1, '20201222', 'pg13', '', '');

INSERT INTO projects VALUES ('fixeddecimal', 5, 0, 'hub', 0, 'https://github.com/pgsql-io/fixeddecimal/releases',
  'fixeddecimal', 1, 'fixeddecimal.png', 'Much faster than NUMERIC', 'https://github.com/pgsql-io/fixeddecimal');
INSERT INTO releases VALUES ('fixeddecimal-pg13', 2, 'fixeddecimal', 'FixedDecimal', '', 'prod', '', 1, 'POSTGRES', '', '');
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
INSERT INTO releases VALUES ('plpython3', 1, 'plpython', 'PL/Python','', 'included', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('plpython3', '13', 'arm, amd', 1, '20200213', 'pg13', '', '');

INSERT INTO projects VALUES ('plperl', 3, 0, 'hub', 0, 'https://www.postgresql.org/docs/13/plperl.html',
	'plperl', 1, 'perl.png', 'Perl Stored Procedures', 'https://www.postgresql.org/docs/13/plperl.html');
INSERT INTO releases VALUES ('plperl', 2, 'plperl', 'PL/Perl','', 'included', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('plperl', '13', 'arm, amd', 1, '20200213', 'pg13', '', '');

INSERT INTO projects VALUES ('pljava', 3, 0, 'hub', 0, 'https://github.com/tada/pljava/releases', 
  'pljava', 1, 'pljava.png', 'Java Stored Procedures', 'https://github.com/tada/pljava');
INSERT INTO releases VALUES ('pljava-pg13', 3, 'pljava', 'PL/Java', '', 'test', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pljava-pg13', '1.6.2-1',  'amd',  1, '20201127', 'pg13', '', '');

INSERT INTO projects VALUES ('pldebugger', 3, 0, 'hub', 0, 'https://github.com/bigsql/pldebugger2/releases',
  'pldebugger', 1, 'debugger.png', 'Procedural Language Debugger', 'https://github.com/bigsql/pldebugger2#pldebugger2');
INSERT INTO releases VALUES ('pldebugger-pg12', 4, 'pldebugger', 'PL/Debugger', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pldebugger-pg12', '2.0-1',  'amd',  1, '20200224', 'pg12', '', '');

INSERT INTO projects VALUES ('plpgsql', 3, 0, 'hub', 0, 'https://www.postgresql.org/docs/13/plpgsql-overview.html',
  'plpgsql', 0, 'jan.png', 'Postgres Procedural Language', 'https://www.postgresql.org/docs/13/plpgsql-overview.html');
INSERT INTO releases VALUES ('plpgsql', 0, 'plpgsql', 'PL/pgSQL', '', 'included', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('plpgsql', '13',  'arm, amd',  1, '20200213', '', '', '');

INSERT INTO projects VALUES ('pgtsql', 3, 0, 'hub', 0, 'https://github.com/bigsql/pgtsql/releases',
  'pgtsql', 1, 'tds.png', 'Transact-SQL Procedures', 'https://github.com/bigsql/pgtsql#pgtsql');
INSERT INTO releases VALUES ('pgtsql-pg13', 3, 'pgtsql', 'PL/pgTSQL','', 'soon', '', 1, 'AGPLv3', '', '');
INSERT INTO versions VALUES ('pgtsql-pg13', '3.0-1', 'amd', 0, '20191119', 'pg13', '', '');

INSERT INTO projects VALUES ('plprofiler', 3, 0, 'hub', 7, 'https://github.com/bigsql/plprofiler/releases',
  'plprofiler', 1, 'plprofiler.png', 'Stored Procedure Profiler', 'https://github.com/bigsql/plprofiler#plprofiler');
INSERT INTO releases VALUES ('plprofiler-pg13', 4, 'plprofiler',    'PL/Profiler',  '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('plprofiler-pg13', '4.1-1', 'amd', 1, '20190823', 'pg13', '', '');

INSERT INTO projects VALUES ('backrest', 2, 0, 'hub', 0, 'https://pgbackrest.org/release.html',
  'backrest', 0, 'backrest.png', 'Backup & Restore', 'https://pgbackrest.org');
INSERT INTO releases VALUES ('backrest', 9, 'backrest', 'pgBackRest', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('backrest', '2.31-1', 'amd', 1, '20201208', '', '', '');
INSERT INTO versions VALUES ('backrest', '2.30-1', 'amd', 0, '20201005', '', '', '');
INSERT INTO versions VALUES ('backrest', '2.29-1', 'amd', 0, '20200821', '', '', '');

INSERT INTO projects VALUES ('grafana', 9, 0, 'hub', 0, 'https://grafana.com/grafana/download',
  'grafana', 0, 'grafana.png', 'Monitoring Dashboard', 'https://grafana.com');
INSERT INTO releases VALUES ('grafana', 9, 'grafana', 'Grafana', '', 'soon', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('grafana', '7.3.6', 'amd', 0, '20201217', '', 'EL8', '');

INSERT INTO projects VALUES ('audit', 2, 0, 'hub', 0, 'https://github.com/pgaudit/pgaudit/releases',
  'audit', 1, 'audit.png', 'Audit Logging', 'https://github.com/pgaudit/pgaudit');
INSERT INTO releases VALUES ('audit-pg13', 10, 'audit', 'pgAudit', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('audit-pg13', '1.5.0-1', 'amd', 1, '20200921', 'pg13', '',
  'https://github.com/pgaudit/pgaudit/releases/tag/1.5.0');

INSERT INTO projects VALUES ('anon', 2, 0, 'ddlx', 1, 'https://gitlab.com/dalibo/postgresql_anonymizer/-/tags',
  'anon', 1, 'anon.png', 'Anonymization & Masking', 'https://gitlab.com/dalibo/postgresql_anonymizer/blob/master/README.md');
INSERT INTO releases VALUES ('anon-pg13', 11, 'anon', 'Anonymizer', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('anon-pg13', '0.7.1-1', 'amd', 1, '20200929', 'pg13', '', '');

INSERT INTO projects VALUES ('citus', 2, 0, 'hub',0, 'https://github.com/citusdata/citus/releases',
  'citus', 1, 'citus.png', 'Multi Node Data & Queries', 'https://github.com/citusdata/citus');
INSERT INTO releases VALUES ('citus-pg13', 99, 'citus', 'Citus', '', 'test', '', 1, 'AGPLv3', '', '');
INSERT INTO versions VALUES ('citus-pg13', '9.5.1-1', 'amd', 0, '20201202', 'pg13', '', 'https://github.com/citusdata/citus/releases/tag/v9.5.1');

INSERT INTO projects VALUES ('cron', 2, 0, 'hub',0, 'https://github.com/citusdata/pg_cron/releases',
  'cron', 1, 'cron.png', 'Scheduler as Background Worker', 'https://github.com/citusdata/pg_cron');
INSERT INTO releases VALUES ('cron-pg13', 5, 'cron', 'pgCron', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('cron-pg13', '1.3.0-1', 'amd', 1, '20201006', 'pg13', '', '');

-- ##

INSERT INTO projects VALUES ('timescaledb', 2, 0, 'hub', 1, 'https://github.com/timescale/timescaledb/releases',
   'timescaledb', 1, 'timescaledb.png', 'Time Series Data', 'https://github.com/timescale/timescaledb/#timescaledb');
INSERT INTO releases VALUES ('timescaledb-pg12',  1, 'timescaledb', 'TimescaleDB', '', 'prod', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('timescaledb-pg12', '2.0.0-1',  'amd', 1, '20201221', 'pg12', '',
  'https://github.com/timescale/timescaledb/releases/tag/2.0.0');
INSERT INTO versions VALUES ('timescaledb-pg12', '1.7.4-1',  'amd', 0, '20200907', 'pg12', '',
  'https://github.com/timescale/timescaledb/releases/tag/1.7.4');
INSERT INTO versions VALUES ('timescaledb-pg12', '1.7.2-1',  'amd', 0, '20200707', 'pg12', '',
  'https://github.com/timescale/timescaledb/releases/tag/1.7.2');

INSERT INTO projects VALUES ('pglogical', 2, 0, 'hub', 2, 'https://github.com/2ndQuadrant/pglogical/releases',
  'pglogical', 1, 'spock.png', 'Logical & Bi-Directional Replication', 'https://github.com/2ndQuadrant/pglogical');
INSERT INTO releases VALUES ('pglogical-pg13', 2, 'pglogical', 'pgLogical', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pglogical-pg13', '2.3.3-1',  'amd', 1, '20201005', 'pg13', '',
  'https://github.com/2ndQuadrant/pglogical/releases/tag/REL2_3_3');

INSERT INTO projects VALUES ('postgis', 2, 1, 'hub', 3, 'http://postgis.net/source',
  'postgis', 1, 'postgis.png', 'Spatial Extensions', 'http://postgis.net');
INSERT INTO releases VALUES ('postgis-pg13', 3, 'postgis', 'PostGIS', '', 'prod', '', 1, 'GPLv2', '', '');
INSERT INTO versions VALUES ('postgis-pg13', '3.1.0-1', 'amd', 1, '20201210', 'pg13', '', 'https://git.osgeo.org/gitea/postgis/postgis/raw/tag/3.1.0/NEWS');
INSERT INTO versions VALUES ('postgis-pg13', '3.0.3-1', 'amd', 0, '20201119', 'pg13', '', 'https://git.osgeo.org/gitea/postgis/postgis/raw/tag/3.0.3/NEWS');
INSERT INTO versions VALUES ('postgis-pg13', '3.0.2-1', 'amd', 0, '20200815', 'pg13', '', 'https://git.osgeo.org/gitea/postgis/postgis/raw/tag/3.0.2/NEWS');

INSERT INTO projects VALUES ('pgadmin', 9, 80, 'docker', 1, 'https://pgadmin.org',
  'pgadmin', 0, 'pgadmin.png', 'PG Admin for Docker', 'https://pgadmin.org');
INSERT INTO releases VALUES ('pgadmin', 0, 'pgadmin', 'pgAdmin 4.29', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pgadmin', '4', '', 0, '20201210', '', '', '');

INSERT INTO projects VALUES ('bulkload', 9, 0, 'hub', 5, 'https://github.com/ossc-db/pg_bulkload/releases',
  'bulkload', 1, 'bulkload.png', 'High Speed Data Loading', 'https://github.com/ossc-db/pg_bulkload');
INSERT INTO releases VALUES ('bulkload-pg12', 6, 'bulkload', 'pgBulkLoad',  '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('bulkload-pg12', '3.1.16-1', 'amd', 0, '20200121', 'pg12', '', '');

INSERT INTO projects VALUES ('repack', 2, 0, 'hub', 5, 'https://github.com/reorg/pg_repack/releases',
  'repack', 1, 'repack.png', 'Remove Table/Index Bloat' , 'https://github.com/reorg/pg_repack');
INSERT INTO releases VALUES ('repack-pg13', 6, 'repack', 'pgRepack',  '', 'prod','',  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('repack-pg13', '1.4.6-1', 'amd', 1, '20200930', 'pg13', '', '');

INSERT INTO projects VALUES ('partman', 2, 0, 'hub', 4, 'https://github.com/pgpartman/pg_partman/releases',
  'partman', 1, 'partman.png', 'Partition Managemnt', 'https://github.com/pgpartman/pg_partman#pg-partition-manager');
INSERT INTO releases VALUES ('partman-pg13', 6, 'partman', 'pgPartman',   '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('partman-pg13', '4.4.1-1',  'amd', 1, '20201223', 'pg13', '', '');

INSERT INTO projects VALUES ('hypopg', 2, 0, 'hub', 8, 'https://github.com/HypoPG/hypopg/releases',
  'hypopg', 1, 'whatif.png', 'Hypothetical Indexes', 'https://hypopg.readthedocs.io/en/latest/');
INSERT INTO releases VALUES ('hypopg-pg13', 7, 'hypopg', 'HypoPG', '', 'prod','',  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('hypopg-pg13', '1.1.4-1',  'amd', 1, '20200711', 'pg13', '', '');

INSERT INTO projects VALUES ('pgbadger', 2, 0, 'hub', 6, 'https://github.com/darold/pgbadger/releases',
  'badger', 0, 'badger.png', 'Performance Reporting', 'https://pgbadger.darold.net');
INSERT INTO releases VALUES ('pgbadger', 8, 'pgbadger','pgBadger','', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('pgbadger', '11.4', '', 1, '20201125', '', '', '');
INSERT INTO versions VALUES ('pgbadger', '11.3', '', 0, '20200726', '', '', '');
INSERT INTO versions VALUES ('pgbadger', '11.2', '', 0, '20200311', '', '', '');

INSERT INTO projects VALUES ('bouncer',  2, 0, 'hub', 3, 'http://pgbouncer.org',
  'bouncer',  0, 'bouncer.png', 'Lightweight Connection Pooler', 'http://pgbouncer.org');
INSERT INTO releases VALUES ('bouncer', 2, 'bouncer',  'pgBouncer', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('bouncer', '1.15.0-1', 'amd', 1, '20201119', '', '', '');
INSERT INTO versions VALUES ('bouncer', '1.14.0-1', 'amd', 0, '20200611', '', '', '');
INSERT INTO versions VALUES ('bouncer', '1.13.0-1', 'amd', 0, '20200427', '', '', '');

INSERT INTO projects VALUES ('agent', 9, 0, 'hub', 3, 'http://github.com/postgres/pgagent/releases',
  'agent',  0, 'agent.png', 'Job Scheduler for pgAdmin4', 'http://github.com/postgres/pgagent');
INSERT INTO releases VALUES ('agent', 4, 'agent',  'pgAgent', '', 'soon', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('agent', '4.0.0', 'amd', 0, '20180712', '', '', '');

-- ##

INSERT INTO projects VALUES ('docker', 4, 0, 'hub', 1, 'https://github.com/docker/cli/releases', 'docker', 0, 'docker.png', 
  'Container Runtime', 'https://github.com/docker/cli#dockercli');
INSERT INTO releases VALUES ('docker', 3, 'docker', 'Docker CE', '', 'prod', '', 1, 'Apache',
  'docker --version', 'docker --version | awk ''{print $3}'' | sed s/,//');
INSERT INTO versions VALUES ('docker', '20.10.2', '', 0, '20210104', '', '', 'https://docs.docker.com/engine/release-notes/#20102');
INSERT INTO versions VALUES ('docker', '20.10.1', '', 0, '20201215', '', '', 'https://docs.docker.com/engine/release-notes/#20101');
INSERT INTO versions VALUES ('docker', '20.10.0', '', 0, '20201208', '', '', 'https://docs.docker.com/engine/release-notes/#20100');
INSERT INTO versions VALUES ('docker', '19.03.13', '', 0, '20200916', '', '', 'https://docs.docker.com/engine/release-notes/#190313');

INSERT INTO projects VALUES ('compose', 7, 0, 'docker', 1, 'https://github.com/docker/compose/releases', 'compose', 0, 'compose.png', 
  'Multi-Container Development', 'https://docs.docker.com/compose');
INSERT INTO releases VALUES ('compose', 3, 'compose', 'Docker Compose', '', 'prod', '', 1, 'Apache',
  'docker-compose --version', 'docker-compose --version | awk ''{print $3}'' | sed s/,//');
INSERT INTO versions VALUES ('compose', '1.27.4', '', 0, '20200924', '', 'EL8', 'https://docs.docker.com/compose/release-notes/#1274');

INSERT INTO projects VALUES ('minikube', 4, 0, 'docker', 2, 'https://github.com/kubernetes/minikube/releases', 'minikube', 0, 'minikube.png', 
  'Run Kubernetes locally', 'https://minikube.sigs.k8s.io/');
INSERT INTO releases VALUES ('minikube', 7, 'minikube', 'MiniKube', '', 'prod', '', 1, 'Apache', 
  'minikube version', '');
INSERT INTO versions VALUES ('minikube', '1.16.0', '', 0, '20201217', '', '', 'https://github.com/kubernetes/minikube/releases/tag/v1.16.0');

INSERT INTO projects VALUES ('kubectl', 4, 0, 'docker', 2, 'https://github.com/kubernetes/kubectl/releases', 'kubectl', 0, 'kubernetes.png', 
  'Container Orchestration', 'https://k8s.io/');
INSERT INTO releases VALUES ('kubectl', 2, 'kubectl', 'Kubernetes', '', 'bring-own', '', 1, 'Apache', 
  'kubectl version', '');
INSERT INTO versions VALUES ('kubectl', '1.20.1', '', 0, '20201218', '', '', 'https://github.com/kubernetes/kubectl/releases/tag/kubernetes-1.20.1');
INSERT INTO versions VALUES ('kubectl', '1.19.4', '', 0, '20201112', '', '', 'https://github.com/kubernetes/kubectl/releases/tag/kubernetes-1.19.4');
INSERT INTO versions VALUES ('kubectl', '1.18.10', '', 0, '20201014', '', '', 'https://github.com/kubernetes/kubectl/releases/tag/kubernetes-1.18.10');

INSERT INTO projects VALUES ('openebs', 4, 0, 'rancher', 2, 'https://github.com/openebs/openebs/releases', 'openebs', 0, 'openebs.png', 
  'Container Attached Storage', 'https://openebs.io/');
INSERT INTO releases VALUES ('openebs', 3, 'openebs', 'OpenEBS', '', 'bring-own', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('openebs', '2.4.0', '', 0, '20201216', '', '', 'https://github.com/openebs/openebs/releases/tag/v2.4.0');

INSERT INTO projects VALUES ('rancher', 4, 0, 'kubectl', 2, 'https://github.com/rancher/rancher/releases', 'rancher', 0, 'rancher.png', 
  'K8''s Container Mgmt', 'https://rancher.com/');
INSERT INTO releases VALUES ('rancher', 2, 'rancher', 'Rancher', '', 'bring-own', '', 1, 'Apache', 'rancher version', '');
INSERT INTO versions VALUES ('rancher', '2.5.5', '', 0, '20210108', '', '', 'https://github.com/rancher/rancher/releases/tag/v2.5.5');
INSERT INTO versions VALUES ('rancher', '2.5.2', '', 0, '20201109', '', '', 'https://github.com/rancher/rancher/releases/tag/v2.5.2');

INSERT INTO projects VALUES ('helm', 4, 0, 'hub', 3, 'https://github.com/helm/helm/releases', 'helm', 0, 'helm.png',
  'K8s Package Manager', 'https://helm.sh');
INSERT INTO releases VALUES ('helm', 3, 'helm', 'Helm', '', 'prod', '', 1, 'Apache',
  'helm version', 'helm version | awk -F''"'' ''{print $2}'' | sed s/v//g');
INSERT INTO versions VALUES ('helm', '3.5.0', '', 0, '20210113', '', '', 'https://github.com/helm/helm/releases/tag/v3.5.0');
INSERT INTO versions VALUES ('helm', '3.4.2', '', 0, '20201209', '', '', 'https://github.com/helm/helm/releases/tag/v3.4.2');
INSERT INTO versions VALUES ('helm', '3.4.1', '', 0, '20201111', '', '', 'https://github.com/helm/helm/releases/tag/v3.4.1');

-- ##

INSERT INTO projects VALUES ('patroni',  2, 0, 'haproxy', 4, 'https://github.com/zalando/patroni/releases',
  'patroni', 0, 'patroni.png', 'Postgres HA Template', 'https://github.com/zalando/patroni');
INSERT INTO releases VALUES ('patroni', 1, 'patroni', 'Patroni', '', 'test', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('patroni', '2.0.1', '', 0, '20201001', '', '', 'https://github.com/zalando/patroni/releases/tag/v2.0.1');
INSERT INTO versions VALUES ('patroni', '2.0.0', '', 0, '20200902', '', '', 'https://github.com/zalando/patroni/releases/tag/v2.0.0');

INSERT INTO projects VALUES ('kvm', 4, 0, 'hub', 0, 'http://linux-kvm.org', 'kvm', 0, 'kvm.png', 
  'Kernel-based Virtual Machines', 'http://linux-kvm.org');
INSERT INTO releases VALUES ('kvm', 11, 'kvm', 'KVM', '', 'test', '', 1, 'Apache', 
  'qemu-io --version', 'qemu-io --version | head -1 | awk ''{print $3}''');
INSERT INTO versions VALUES ('kvm', '4.2.0', '', 0, '20200829', '', 'EL8 AMD64 PYTHON3 GCC', '');

INSERT INTO projects VALUES ('openstack', 4, 0, 'hub', 0, 'https://www.rdoproject.org/', 'openstack', 0, 'openstack.png',
  'Cloud Infrastructure', 'https://www.openstack.org/software/project-navigator/openstack-components#openstack-services');
INSERT INTO releases VALUES ('openstack', 10, 'openstack', 'OpenStack Ussuri', '', 'bring-own', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('openstack', '20.06-1', '', 0, '20200829', '', 'EL8 AMD64 PYTHON3', '');

INSERT INTO projects VALUES ('ansible',  4, 0, 'hub', 0, 'https://pypi.org/project/ansible/#files',
  'ansible', 0, 'ansible.png', 'IT Automation', 'https://pypi.org/project/ansible');
INSERT INTO releases VALUES ('ansible', 12, 'ansible', 'Ansible', '', 'bring-own', '', 1, 'Apache',
  '/usr/bin/ansible --version', '/usr/bin/ansible --version | head -1 | awk ''{print $2}''');
INSERT INTO versions VALUES ('ansible', '2.10.5', '', 0, '20200105', '', '', '');
INSERT INTO versions VALUES ('ansible', '2.10.4', '', 0, '20201201', '', 'EL8 PYTHON3', '');
INSERT INTO versions VALUES ('ansible', '2.10.3', '', 0, '20201104', '', 'EL8 PYTHON3', '');

INSERT INTO projects VALUES ('mistio',  4, 0, 'hub', 0, 'https://github.com/mistio/mist-ce/releases',
  'mistio', 0, 'mist-io.png', 'Multi-Cloud Managment Platform', 'https://mist.io');
INSERT INTO releases VALUES ('mistio', 12, 'mistio', 'mist.io', '', 'bring-own', '', 1, 'Apache', '', '');
INSERT INTO versions VALUES ('mistio', '4.3.8', '', 0, '20200825', '', 'PYTHON3',
  'https://github.com/mistio/mist-ce/releases/tag/v4.3.8');

INSERT INTO projects VALUES ('cloud', 4, 0, 'hub', 0, 'https://github.com/apache/libcloud/releases',
  'cloud', 0, 'libcloud.png', 'Python Cloud SDK', 'https://libcloud.apache.org');
INSERT INTO releases VALUES ('cloud', 4, 'cloud', 'Apache Libcloud', '', 'prod', '', 1, 'Apache', 
  'pip3 show apache-libcloud', 'pip3 show apache-libcloud | grep Version: | awk ''{print $2}''');
INSERT INTO versions VALUES ('cloud', '3.3.0', '', 0, '20210102', '', 'PYTHON3',
  'https://libcloud.readthedocs.io/en/latest/changelog.html#changes-in-apache-libcloud-3-3-0');
INSERT INTO versions VALUES ('cloud', '3.2.0', '', 0, '20200927', '', 'PYTHON3',
  'https://libcloud.readthedocs.io/en/latest/changelog.html#changes-in-apache-libcloud-3-2-0');

INSERT INTO projects VALUES ('llvm', 7, 0, 'hub', 3, 'https://releases.llvm.org', 
  'llvm', 0, 'llvm.png', 'Just in Time Compilation', 'https://llvm.org');
INSERT INTO releases VALUES ('llvm', 5, 'llvm', 'LLVM', '', 'bring-own', '', 1, '', '', '');
INSERT INTO versions VALUES ('llvm', '11.0.0', '', 0, '20201012', '', '', '');

INSERT INTO projects VALUES ('bison', 7, 0, 'hub', 4, 'http://ftp.gnu.org/gnu/bison/',
  'bison', 0, 'gnu.png', 'Parser-Generator', 'https://gnu.org/software/bison/');
INSERT INTO releases VALUES ('bison', 6, 'bison', 'Bison', '', 'bring-own', '', 1, '', '', '');
INSERT INTO versions VALUES ('bison', '3.7.4', '', 0, '20201114', '', '', '');
INSERT INTO versions VALUES ('bison', '3.7.3', '', 0, '20201013', '', '', '');

INSERT INTO projects VALUES ('gcc', 7, 0, 'hub', 4, 'http://ftp.gnu.org/gnu/gcc/',
  'gcc', 0, 'gcc.png', 'the GNU Compiler Collection', 'https://gnu.org/software/gcc/');
INSERT INTO releases VALUES ('gcc', 6, 'gcc', 'GCC', '', 'prod', '', 1, '', '', '');
INSERT INTO versions VALUES ('gcc', '10.2.0', '', 0, '20200723', '', '', 
  'https://gcc.gnu.org/gcc-10/changes.html');

INSERT INTO projects VALUES ('valgrind', 7, 0, 'hub', 4, 'http://valgrind.org',
  'valgrind', 0, 'valgrind.png', 'Memory Checker & Profiler', 'http://valgrind.org');
INSERT INTO releases VALUES ('valgrind', 8, 'valgrind', 'Valgrind', '', 'bring-own', '', 1, '', '', '');
INSERT INTO versions VALUES ('valgrind', '3.16.1', '', 0, '20200622', '', '', '');

INSERT INTO projects VALUES ('gdb', 7, 0, 'hub', 4, 'http://ftp.gnu.org/gnu/gdb/',
  'gdb', 0, 'gdb.png', 'the GNU Debugger', 'https://gnu.org/software/gdb/');
INSERT INTO releases VALUES ('gdb', 7, 'gdb', 'GDB', '', 'bring-own', '', 1, '', '', '');
INSERT INTO versions VALUES ('gdb', '10.1', '', 0, '20201024', '', '', '');

-- ##
INSERT INTO projects VALUES ('omnidb', 9, 8000, 'docker', 2, 'https://github.com/omnidb/omnidb/releases', 'omnidb', 0, 'omnidb.png', 'RDBMS Admin for Docker', 'https://github.com/omnidb/omnidb/#omnidb');
INSERT INTO releases VALUES ('omnidb', 1, 'omnidb', 'OmniDB', '', 'soon', '', 1, 'MIT', '', '');
INSERT INTO versions VALUES ('omnidb', '3.0.3b', '', 0, '20201217', '', '', '');
INSERT INTO versions VALUES ('omnidb', '3.0.2b', '', 0, '20201028', '', '', '');
INSERT INTO versions VALUES ('omnidb', '3.0.1b', '', 0, '20201026', '', '', '');
INSERT INTO versions VALUES ('omnidb', '3.0.0b', '', 0, '20201024', '', '', '');
INSERT INTO versions VALUES ('omnidb', '2.17',   '', 0, '20191205', '', '', '');

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
INSERT INTO releases VALUES ('psqlodbc', 8, 'psqlodbc',  'psqlODBC', '', 'prod', '', 1, 'LIBGPLv2', '', '');
INSERT INTO versions VALUES ('psqlodbc', '13.00-1', 'amd', 1, '20201119', '', '', '');

INSERT INTO projects VALUES ('http', 3, 0, 'hub', 6, 'https://github.com/pramsey/pgsql-http/releases', 'http',  1, 'http.png', 'Invoke Web Services', 'https://github.com/pramsey/pgsql-http');
INSERT INTO releases VALUES ('http-pg12', 13, 'http', 'HTTP Client', '', 'prod', '', 1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('http-pg12', '1.3.1-1', 'amd', 1, '20191225', 'pg12', '', '');

INSERT INTO projects VALUES ('ddlx',      7, 0, 'hub', 0, 'https://github.com/lacanoid/pgddl/releases', 'ddlx',  1, 'ddlx.png', 'DDL Extractor', 'https://github.com/lacanoid/pgddl#ddl-extractor-functions--for-postgresql');
INSERT INTO releases VALUES ('ddlx-pg13', 2, 'ddlx', 'DDLeXtact', '', 'prod','',  0, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('ddlx-pg13', '0.17-1', 'amd', 1, '20200911', 'pg13', '', '');

INSERT INTO projects VALUES ('multicorn', 7, 0, 'hub', 0, 'https://github.com/Segfault-Inc/Multicorn/releases',
  'multicorn', 1, 'multicorn.png', 'Python FDW Library', 'http://multicorn.org');
INSERT INTO releases VALUES ('multicorn-pg12', 1, 'multicorn', 'Multicorn', '', 'prod','',  1, 'POSTGRES', '', '');
INSERT INTO versions VALUES ('multicorn-pg12', '1.4.0-1', 'amd', 1, '20200318', 'pg12', '', '');
