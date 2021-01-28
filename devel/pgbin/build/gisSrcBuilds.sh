sudo mkdir -p /opt/gis-tools
sudo chown $USER:$USER /opt/gis-tools

function buildGDAL {
  cd /opt/gis-tools
  rm -rf gdal*
  VER=3.2.1
  wget https://github.com/OSGeo/gdal/releases/download/v$VER/gdal-$VER.tar.gz
  tar -xvf gdal-$VER.tar.gz
  cd gdal-$VER
  ./configure
  sudo make -j8
  sudo make install
  return
}

function buildGeos {
  cd /opt/gis-tools
  VER=3.8.1
  wget http://download.osgeo.org/geos/geos-$VER.tar.bz2
  tar -xvf geos-$VER.tar.bz2
  cd geos-$VER
  ./configure
  sudo make -j8
  sudo make install
  return
}

############# MAINLINE ###################
#buildGeos
buildGDAL

