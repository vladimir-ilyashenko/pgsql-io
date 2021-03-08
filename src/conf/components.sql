
DROP TABLE IF EXISTS volumes;
DROP TABLE IF EXISTS nodes;
DROP TABLE IF EXISTS clusters;
DROP TABLE IF EXISTS clouds;
DROP TABLE IF EXISTS keys;

DROP TABLE IF EXISTS settings;
DROP TABLE IF EXISTS hosts;

CREATE TABLE settings (
  section            TEXT      NOT NULL,
  s_key              TEXT      NOT NULL,
  s_value            TEXT      NOT NULL,
  PRIMARY KEY (section, s_key)
);
INSERT INTO settings VALUES ('GLOBAL', 'REPO', 'https://pgsql-io.s3.amazonaws.com/REPO');


CREATE TABLE hosts (
  host_id            INTEGER PRIMARY KEY,
  host               TEXT NOT NULL,
  name               TEXT UNIQUE,
  last_update_utc    DATETIME,
  unique_id          TEXT
);
INSERT INTO hosts (host_id, host) VALUES (1, 'localhost');


DROP TABLE IF EXISTS components;
CREATE TABLE components (
  component          TEXT     NOT NULL PRIMARY KEY,
  project            TEXT     NOT NULL,
  version            TEXT     NOT NULL,
  platform           TEXT     NOT NULL,
  port               INTEGER  NOT NULL,
  status             TEXT     NOT NULL,
  install_dt         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  autostart          TEXT,
  datadir            TEXT,
  logdir             TEXT,
  pidfile            TEXT,
  svcname            TEXT,
  svcuser            TEXT
);


CREATE TABLE keys (
  name           TEXT     NOT NULL PRIMARY KEY,
  username       TEXT     NOT NULL,
  pem_file       TEXT     NOT NULL,
  created_utc    DATETIME NOT NULL,
  updated_utc    DATETIME NOT NULL
);


CREATE TABLE clouds (
  name            TEXT     NOT NULL PRIMARY KEY,
  provider        TEXT     NOT NULL,
  region          TEXT     NOT NULL,
  default_ssh_key TEXT     REFERENCES keys(name),
  keys            TEXT     NOT NULL,
  created_utc     DATETIME NOT NULL,
  updated_utc     DATETIME NOT NULL
);


CREATE TABLE clusters (
  name           TEXT     NOT NULL PRIMARY KEY,
  service        TEXT     NOT NULL,
  created_utc    DATETIME NOT NULL,
  updated_utc    DATETIME NOT NULL
);


CREATE TABLE nodes (
  machine_id     TEXT     NOT NULL PRIMARY KEY,
  cloud          TEXT     NOT NULL REFERENCES clouds(name),
  service        TEXT,
  cluster_name   TEXT     REFERENCES clusters(name),
  describe       TEXT,
  os_info        TEXT,
  components     TEXT,
  created_utc    DATETIME NOT NULL,
  updated_utc    DATETIME NOT NULL
);


CREATE TABLE volumes (
  id             TEXT     NOT NULL PRIMARY KEY,
  cloud          TEXT     NOT NULL REFERENCES clouds(name),
  machine_id     TEXT     REFERENCES nodes(machine_id),
  volume_types   TEXT     NOT NULL,
  size_gb        INTEGER  NOT NULL,
  tested_iops    SMALLINT,
  created_utc    DATETIME NOT NULL,
  updated_utc    DATETIME NOT NULL
);


