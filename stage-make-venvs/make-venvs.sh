#!/bin/sh

set -e
set -x

for version in $PYTHONS
do
	shortversion="$(echo "$version" | cut -d. -f 1-2)"
	shorterversion="$(echo "$version" | cut -d. -O "" -f 1-2)"

	echo "Making venv for Python $version" > /dev/stderr
	mkdir -p /pyvenvs
	/pythons/python$shortversion/bin/python$shortversion \
		-m venv /pyvenvs/venv-$shortversion

done


