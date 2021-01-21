
DROP TABLE IF EXISTS settings;
CREATE TABLE settings (
  section            TEXT      NOT NULL,
  s_key              TEXT      NOT NULL,
  s_value            TEXT      NOT NULL,
  PRIMARY KEY (section, s_key)
);
INSERT INTO settings VALUES ('GLOBAL', 'REPO', 'https://pgsql-io.s3.amazonaws.com/REPO');


DROP TABLE IF EXISTS hosts;
CREATE TABLE hosts (
  host_id            INTEGER PRIMARY KEY,
  host               TEXT NOT NULL,
  name               TEXT UNIQUE,
  last_update_utc    DATETIME,
  unique_id          TEXT
);
INSERT INTO hosts (host) VALUES ('localhost');


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


DROP TABLE IF EXISTS volumes;
CREATE TABLE volumes (
  id             TEXT     NOT NULL PRIMARY KEY,
  cloud_id       TEXT     NOT NULL REFERENCES cloud(id),
  machine_id     TEXT     REFERENCES machine(id),
  volume_types   TEXT     NOT NULL REFERENCES volume_types(volume_type),
  size_gb        INTEGER  NOT NULL,
  tested_iops    SMALLINT,
  created_utc    DATETIME NOT NULL,
  updated_utc    DATETIME NOT NULL
);


DROP TABLE IF EXISTS nodes;
CREATE TABLE nodes (
  id             TEXT     NOT NULL PRIMARY KEY,
  cluster_name   TEXT     NOT NULL REFERENCES clusters(name),
  current_role   TEXT,
  components     TEXT,
  info           TEXT,
  created_utc    DATETIME NOT NULL,
  updated_utc    DATETIME NOT NULL
);


DROP TABLE IF EXISTS machines;
CREATE TABLE machines (
  id             TEXT     NOT NULL PRIMARY KEY,
  name           TEXT     NOT NULL,
  cloud          TEXT     NOT NULL REFERENCES cloud(name),
  key_name       TEXT     REFERENCES key(name),
  describe       TEXT,
  tags           TEXT,
  created_utc    DATETIME NOT NULL,
  updated_utc    DATETIME NOT NULL
);


DROP TABLE IF EXISTS clouds;
CREATE TABLE clouds (
  id             TEXT     NOT NULL PRIMARY KEY,
  name           TEXT     NOT NULL UNIQUE,
  provider       TEXT     NOT NULL,
  keys           TEXT     NOT NULL,
  created_utc    DATETIME NOT NULL,
  updated_utc    DATETIME NOT NULL
);


DROP TABLE IF EXISTS keys;
CREATE TABLE keys (
  id             TEXT     NOT NULL PRIMARY KEY,
  name           TEXT     NOT NULL UNIQUE,
  username       TEXT     NOT NULL,
  pub_key_path   TEXT     NOT NULL,
  priv_key_path  TEXT     NOT NULL,
  created_utc    DATETIME NOT NULL,
  updated_utc    DATETIME NOT NULL
);


DROP TABLE IF EXISTS clusters;
CREATE TABLE clusters (
  name           TEXT     NOT NULL PRIMARY KEY,
  service        TEXT     NOT NULL REFERENCES services(service),
  created_utc    DATETIME NOT NULL,
  updated_utc    DATETIME NOT NULL
);

