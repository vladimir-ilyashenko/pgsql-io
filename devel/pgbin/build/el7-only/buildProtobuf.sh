ver=3.14.0

url=https://github.com/protocolbuffers/protobuf/releases/download/v$ver/
gz=protobuf-all-$ver.tar.gz 

rm -f $gz
wget $url/$gz
tar xvf $gz
#rm $gz

dir=protobuf-$ver
cd $dir

./configure
make check
make -j4
sudo make install
sudo ldconfig # refresh shared library cache.
