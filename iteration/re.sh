#! /bin/sh
export GIT_RELEASE_BRANCH='re-231';
GIT_BRANCH="$1"
export GIT_BRANCH_ALPHA='alpha-231';

[ x$GIT_RELEASE_BRANCH == x ] && echo "GIT_RELEASE_BRANCH is required" && exit;
[ x$GIT_BRANCH == x ] && echo "GIT_BRANCH is required" && exit;

if [ "$GIT_BRANCH" != "" ];
then
	cd ~/e.mail.ru
	gitgo $GIT_BRANCH
	gitgo $GIT_RELEASE_BRANCH
	gitm $GIT_BRANCH
	if(( `git status | grep "both modified" | wc -l` == 0 )); then
		git status | grep '\.css' | awk '{print $3}' | while read i; do git checkout $GIT_RELEASE_BRANCH --  $i; done
		printf "%s\n{noformat}%s\n"
		echo "Merge branch" $GIT_BRANCH "into" $GIT_RELEASE_BRANCH
		printf "%s\n"
		git status
		printf "{noformat}%s\n"
	else
		echo "Conflict detected"
		git reset --hard HEAD
		git clean -fd
		echo "Try to actualize"
		gitgo $GIT_BRANCH
		gitm $GIT_BRANCH_ALPHA
		if(( `git status | grep "both modified" | wc -l` == 0 )); then
			echo "Merge branch succes!!"
		else
			echo "Merge branch failed!!"
		fi;
	fi;
else
	echo "Wrong params"
	echo ""
fi;
echo ""
echo "Bye"
echo ""
