#!/usr/bin/env bash
#sudo apt-get update
#sudo apt-get install -y --force-yes libgmp3-dev libdb-devsudo ca-certificates
sudo apt-get install -y --force-yes build-essential libgmp3-dev libdb-dev libncurses5-dev


echo "download GnuCOBOL"
mkdir ~/gnucobol3
mkdir ~/gnucobol3/latest
wget  -O ~/gnucobol3/latest.tar.gz --no-check-certificate "https://sourceforge.net/projects/open-cobol/files/gnu-cobol/3.0/gnucobol-3.0-rc1.tar.gz/download"
cd ~/gnucobol3
tar xvf latest.tar.gz -C ~/gnucobol3/latest --strip-components=1
cd latest/

./configure
make
sudo make install
sudo ldconfig
