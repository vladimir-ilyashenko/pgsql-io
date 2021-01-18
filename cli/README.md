# README for IO #

IO is the API & CLI for PGSQL.IO

## Usage ##
```
io command [component] [options]
```

## Informational Commands ##
```
  help      - Display help file
  info      - Display OS or component information
  status    - Display status of installed server components
  list      - Display available/installed components 
```

## Service Control Commands ##
```
  start     - Start server components
  stop      - Stop server components
  reload    - Reload server configuration files (without a restart)
  restart   - Stop & then start server components
  enable    - Enable a component
  disable   - Disable a server server component from starting automatically
  config    - Configure a component
  init      - Initialize a component
```

## Hybrid & Multi-Cloud Commands ##
```
  provider  - Supported cloud providers
  region    - Supported provider regions (geographic areas)
  location  - A data center (Avaialbility Zone)
  key       - Manage SSH Keys
  cloud     - Credentialed connections to a provider/region
  bucket    - BLOB or Object storage
  node      - Virtual machines, containers or bare-metal
  volume    - Block Stores for attachment to nodes or containers
  cluster   - A set of nodes to perform an HA task
  dns       - DNS API
  balance   - Load Balancer API
  backup    - Backup API
```


## Software Install & Update Commands ##
```
  update    - Retrieve new lists of components
  upgrade   - Perform an upgrade of a component
  install   - Install (or re-install) a component  
  remove    - Un-install component   
  clean     - Delete downloaded component files
```

## Advanced Commands ##
```
  top        - Cross platform version of the "top" command 
  get        - Retrieve a setting
  set        - Populate a setting
  unset      - Remove a setting 
  bench      - run pgBench on a database
```
