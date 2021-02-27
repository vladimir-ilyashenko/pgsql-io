# OPENRDS 

Steps to setup a dev environment

## 1.) make sure 'hostname -f' works and that u have passwdless priv's for 'sudo' & 'ssh localhost'.

## 2.) mkdir ~/dev; cd ~/dev; git clone https://github.com/pgsql-io/pgsql-io

## 3.) cd pgsql-io; ./setupIO.sh

## 4.) ./setupCLOUD.sh

## 5.) configure your ~/.aws & ~/.openstack credentials

## 6.) run ./setupIN.sh to populate the IN directory from s3://pgsql-io-download/IN

## 7.) edit bp.sh io commands to create valid cloud keys & connnections


