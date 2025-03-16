#!/bin/sh

set -e
set -x

for version in $PYTHONS
do
	shortversion="$(echo "$version" | cut -d. -f 1-2)"
	shorterversion="$(echo "$version" | cut -d. -O "" -f 1-2)"

	venvdir="/pyvenvs/venv-$shortversion"

	if [ -d "$venvdir" ]
	then
		echo "SKIP MAKING VENV $versions -- EXISTS!" > /dev/stderr
		continue
	fi

	echo "Making venv for Python $version" > /dev/stderr
	mkdir -p /pyvenvs
	/pythons/python$shortversion/bin/python$shortversion \
		-m venv "$venvdir"

done


