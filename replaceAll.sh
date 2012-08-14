#!/bin/bash
FROM="$1"
TO="$2"

for f in `ack "${FROM}" -l`;
do
	echo $f
	cat $f | sed -r "s:${FROM}:${TO}:g" > $f.fix;
	mv $f.fix $f;
done
