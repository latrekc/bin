#!/bin/bash

## storing current dir
pushd . > /dev/null

### Installing needed packages
sudo yum install advancecomp
sudo yum install perl-Image-ExifTool
sudo yum install ImageMagick
sudo yum install optipng
sudo yum install libjpeg-turbo
sudo yum install gifsicle
sudo rpm -ivh http://buildmail.dev.mail.ru/s.tugovikov/pngnq-1.1-8.el6.x86_64.rpm
sudo rpm -ivh http://buildmail.dev.mail.ru/s.tugovikov/pngcrush-1.7.69-2.el6.x86_64.rpm
sudo yum install libpng-devel



### Installing additional software
mkdir /tmp/imgo-installation/bin -p
cd /tmp/imgo-installation

### I reccomend to launch commands above manually! One by one. It could be very-very sad bad because you can catch some errors. Use it at your own risk!

# pngout
wget http://static.jonof.id.au/dl/kenutils/pngout-20120530-linux-static.tar.gz -O pngout.tar.gz
tar -xvf pngout.tar.gz
cp pngout-20120530-linux-static/`uname -m`/pngout-static ./bin/pngout

# defluff. WARNING! There are i686 and x86_64 binaries only
wget https://github.com/imgo/imgo-tools/raw/master/src/defluff/defluff-0.3.2-linux-`uname -m`.zip -O defluff.zip
unzip defluff.zip
chmod a+x defluff
cp defluff ./bin

# cryopng
wget http://frdx.free.fr/cryopng/cryopng-linux-x86.tgz -O cryo.tgz
tar -zxf cryo.tgz
cp cryo-files/cryopng ./bin

# pngrewrite. building from sources. binaries only for win
# Do you really need pngrewrite? http://entropymine.com/jason/pngrewrite/
## mkdir pngrewrite && cd pngrewrite/
## wget http://entropymine.com/jason/pngrewrite/pngrewrite-1.4.0.zip
## unzip pngrewrite-1.4.0.zip
## make
## cp pngrewrite ./bin
## cd ..

# imgo script. Yeah! Finally
git clone git://github.com/imgo/imgo.git
cp imgo/imgo ./bin

# copy binaries to your local ~/bin or global /usr/local/bin
# cp ./bin/* ~/bin # or
sudo cp ./bin/* /usr/local/bin

# dir restore and clean up
popd > /dev/null
rm -rf /tmp/imgo-installation