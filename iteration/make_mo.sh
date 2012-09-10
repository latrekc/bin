#! /bin/sh

cd ~/e.mail.ru/data/ru/locale

for i in `ls`; do
	cd $i/LC_MESSAGES/
	msgfmt -o messages.mo messages.po
	printf "%s\n------ changed $i  ---------%s\n"
	cd ../../
done

echo ""
echo "======== mo-files rebuilded =========="

cd ../.templates
echo >> default/blocks/_config.html
echo >> strings/strings
ls *.info | while read i; do echo >> $i; done
echo ""
echo "======== spaces intos string, config, info-files added  =========="
echo ""

