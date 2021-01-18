sudo rm -rf /opt/oracleinstantclient
ORACLE_HOME=/opt/oracleinstantclient/instantclient_19_8

sudo mkdir /opt/oracleinstantclient
sudo chown $USER:$USER /opt/oracleinstantclient

cp $IN/oracle/*.zip /opt/oracleinstantclient/.

cd /opt/oracleinstantclient
unzip instantclient-basic*.zip
unzip instantclient-sdk*.zip
unzip instantclient-sqlplus*.zip

cd $ORACLE_HOME
ln -s libnsl.so.2 libnsl.so.1

