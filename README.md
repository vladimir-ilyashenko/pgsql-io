# OPENRDS 

Steps to setup devel environment

## 1.) ensure 'hostname --fqdn' works & u have passwdless priv's for 'sudo' & 'ssh localhost'.

## 2.) $ mkdir -p ~/dev; cd ~/dev; git clone https://github.com/pgsql-io/pgsql-io

## 3.) $ cd pgsql-io; ./setupIO.sh; source ~/.bashrc

## 4.) configure your ~/.aws & ~/.openstack credentials

## 5.) $ cd $IO; ./setupCLOUD.sh; ./setupIN.sh

## 6.) edit bp.sh io commands to create valid cloud keys & connnections


