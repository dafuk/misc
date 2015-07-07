#!/bin/sh
# some config
installer_path="/opt/install"
echo "Prepare yourself! Redis is coming in... Deps first..."
apt-get update 
apt-get install build-essential libtolua-dev libjemalloc-dev tcl mc -y
if [ !-d $installer_path ]
then mkdir $installer_path
fi
cd $installer_path
echo "Getting redis..."
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
echo "if no errors - compiled ok, now testing part"
echo "Installing..."
make install 
read -p "Using debian (y/n)?"
[ "$REPLY" == "y" ] || cd utils && ./install_server.sh



