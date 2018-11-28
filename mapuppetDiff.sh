#!/bin/bash
. ~/bin/.tokens
MAPUPPET_PROJECT_ID="1937"

function checkDiff() {
	BRANCH=$1
	CNT=`curl -s --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "https://${GITLAB_HOST}/api/v4/projects/${MAPUPPET_PROJECT_ID}/repository/compare?to=master&from=${BRANCH}" | jq '.commits|length'`;
	echo -e "\t${CNT}\t${BRANCH}"
}

function checkList() {
	echo "$1"
	for BRANCH in $2
	do
		checkDiff $BRANCH
	done
	echo ""
}

checkList "Сервера с ветками" "omega_rc branch_fe"
checkList "Релизные сервера" "alpha_rc beta_rc gamma_rc iota_rc kappa_rc lambda_rc zeta_rc"
checkList "RC сервера" "rc_mail rc_mail2 rc_mail3"
checkList "Остальные сервера" "canaryfront iftest promf"

