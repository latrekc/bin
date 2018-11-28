#!/bin/bash

case $1 in
	win105)
		;;

	tornado)
		;;

	fdev16)
		;;

	*)
		echo "Bad servername $1";
		exit 1;
		;;
esac

mkdir -p ~/.Volumes/$1/
sshfs $1:/home/s.tugovikov/ /Users/tugovikov-new/.Volumes/$1 -o volname=$1
open /Users/tugovikov-new/.Volumes/$1