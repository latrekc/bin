#!/bin/bash

reset() {
	git checkout -- .
}

last_rev() {
	TYPE=$1
	git branch -a | grep "remotes/origin/${TYPE}-" | sort  | tail -n 1 | sed 's@remotes/origin/@@' | sed -r 's/\s+//g'
}



pushd ~/mpop/ > /dev/null

# на всякий случай откатим все изменения в папке
reset

# сначала нужно влить в последнюю итерацию изменения из prerelease
git fetch

LAST_ITERATION=`last_rev 'mail-iteration'`
LAST_PRERELEASE=`last_rev 'prerelease-mail'`

echo "iteration: ${LAST_ITERATION}, release: ${LAST_PRERELEASE}"

git checkout $LAST_ITERATION

git merge origin/$LAST_PRERELEASE


# запускать нужно из своей копии mpop
#bash build_fe_utf.sh;
#./autogen.sh;
#./build.sh fe-linux-utf;
./build-mail.sh
sudo make install;
cd -;
/etc/init.d/httpd restart;

# после этого нужно откатить все изменения в папке
reset

popd > /dev/null