#!/bin/sh

set -e
set -x

for version in $PYTHONS
do
	shortversion="$(echo "$version" | cut -d. -f 1-2)"
	shorterversion="$(echo "$version" | cut -d. -O "" -f 1-2)"

	echo "Installing modules for Python $version" > /dev/stderr
	/pyvenvs/venv-$shortversion/bin/pip install $PIPMODULES

done


