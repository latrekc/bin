#!/bin/bash

reset() {
	git reset --hard HEAD
	git clean -fd
}

pushd ~/mpop/ > /dev/null

# на всякий случай откатим все изменения в папке
reset

git fetch
git checkout prerelease-mail


# запускать нужно из своей копии mpop
./build_fe_utf.sh

./autogen.sh
./configure --enable-mail --enable-perl --enable-spamdelclient --enable-mysqlproc --enable-uri-list --enable-mail-ajax --enable-pro --enable-utf --enable-kav8 --enable-httplib --enable-kas5
make -j 4

sudo make install
sudo /etc/init.d/httpd restart

# после этого нужно откатить все изменения в папке
reset

popd > /dev/null