#! /bin/sh
ITERATION_NO="$1"

[ x$ITERATION_NO == x ] && echo "ITERATION_NO is required" && exit;
error=0;
if [ "$ITERATION_NO" != "" ];
then
    cd ~/e.mail.ru
	gitgo alpha-$ITERATION_NO
	gitgo re-$ITERATION_NO
#	DIFF=$(git diff alpha alpha-$ITERATION_NO re-$ITERATION_NO --name-only)
	DIFF=$(git diff alpha alpha-$ITERATION_NO --name-only)
	for i in $DIFF 
	do 
		k=`i18n-check-template $i`;
		echo "$k";
		if [[ $k =~ ERROR ]];
		then
			error=`expr $error + 1`;
		fi;
	done
else
	echo "Wrong params"
	echo ""
fi;

if [ "$error" != "0" ];
then
	echo "------------------";
	echo "Error count: " $error;
	echo "PO-file generation failed";
else
	echo "------------------";
	echo "Check success. Starting generating new PO-file...";
	rm ~/messages.po;
	i18n-parse-template -s -e utf8 data/ > ~/messages.po;
fi;
