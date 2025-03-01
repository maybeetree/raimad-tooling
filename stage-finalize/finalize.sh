#!/bin/sh

set -e
set -x

for version in $PYTHONS
do
	shortversion="$(echo "$version" | cut -d. -f 1-2)"
	shorterversion="$(echo "$version" | cut -d. -O "" -f 1-2)"

	echo "Creating launcher for python $version" > /dev/stderr
	echo "\
#!/bin/sh
exec /pyvenvs/venv-$shortversion/bin/python "'"$@"'"
" > /usr/local/bin/python$shortversion
	chmod +x /usr/local/bin/python$shortversion
done

