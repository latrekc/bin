export ICONS_DIR=~/temp/icons;
ICONS_BUILD="$1";
[ x$ICONS_BUILD == x ] && echo "ICONS_BUILD is required" && exit;

cd $ICONS_DIR;

for i in `ls _*_*.png` ;  do
	if [[ "$i" =~ "_[0-9]+._[0-9]+_(.[0-9]+)_?(.+)?.png" ]];
	then
		p1=${BASH_REMATCH[1]}
		p2=${BASH_REMATCH[2]}
	fi;
	if [[ "$i" == "_0000_default.png" ]];
	then
		p1=default;
	fi;

	[ x$p2 != x ] && p1=$p1/$p2;
	
	echo "Coping $ICONS_DIR/$i to ~/mail.ru.static/data/ru/images/themes/$p1/icons.$ICONS_BUILD.png";
	mkdir -p ~/mail.ru.static/data/ru/images/themes/$p1;
	cp $ICONS_DIR/$i ~/mail.ru.static/data/ru/images/themes/$p1/icons.$ICONS_BUILD.png
	echo "";
done

