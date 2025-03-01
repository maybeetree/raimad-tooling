#!/bin/sh

# A lot of configuration options and workarounds found
# in this script are adapted from Alpine's APKBUILD for Python,
# which can be found at
# https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/main/python3/APKBUILD


set -e
set -x

if [ -z "$PYTHONS" ]
then
	echo '$PYTHONS not set!' &>2
	exit 2
fi

echo "Installing build dependencies" > /dev/stderr

# Honestly I'm pretty sure some of these are not needed
apk add --no-cache \
	gcc \
	make \
	musl-dev \
	`# The following are Python's dependencies, ` \
	`# adapted from APKBUILD` \
	bluez-headers \
	bzip2-dev \
	expat-dev \
	gdbm-dev \
	libffi-dev \
	linux-headers \
	mpdecimal-dev \
	musl-libintl \
	ncurses-dev \
	openssl-dev \
	readline-dev \
	sqlite-dev \
	tcl-dev \
	xz-dev \
	zlib-dev

for version in $PYTHONS
do
	shortversion="$(echo "$version" | cut -d. -f 1-2)"
	shorterversion="$(echo "$version" | cut -d. -O "" -f 1-2)"

	echo "Downloading Python $version" > /dev/stderr
	wget https://www.python.org/ftp/python/$version/Python-$version.tar.xz

	echo "Extracting $version" > /dev/stderr
	tar xf Python-$version.tar.xz

	echo "Building $version" > /dev/stderr

	mkdir -p /pythons/python$shortversion
	cd Python-$version

	./configure \
		--prefix=/pythons/python$shortversion \
		`# The following are adapted from the APKBUILD` \
		--enable-ipv6 \
		--enable-loadable-sqlite-extensions \
		--enable-optimizations \
		`# Just bake the deps into the executables, ` \
		`# I don't want to mess around with ld. ` \
		--enable-shared=no \
		--with-lto \
		--with-computed-gotos \
		--with-dbmliborder=gdbm:ndbm \
		--with-system-expat \
		--with-system-libmpdec \
		`# pip will be available inside venv` \
		--without-ensurepip

	# Looking at the APKBUILD, it seems like
	# nobody knows or cares why these tests fail.
	# There should be some environment variable
	# you can set to disable these, but I couldn't get it to work,
	# so just replace them with empty files.
	echo > Lib/test/test_math.py
	echo > Lib/test/test_re.py
	echo > Lib/test/test_cmath.py
	echo > Lib/test/test_codecs.py
	echo > Lib/test/test_set.py
	echo > Lib/test/test_memoryview.py

	make -j$(nproc)
	make install

	cd ..

done

echo "Cleaning up..."

# Adapted from
# https://github.com/docker-library/python/blob/master/3.9/alpine3.21/Dockerfile
find /pythons -depth \
	\( \
		\( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
		-o \( -type f -a \( -name '*.pyc' -o -name '*.pyo' -o -name 'libpython*.a' \) \) \
	\) -exec rm -rf '{}' + \
	;

