# RAIMAD Tooling Docker

This repository contains the dockerfile for the `raimad-tooling` image,
a container image that can be used to easily run tests and lint
the RAIMAD codebase.

> [!TIP]
> The instructions below use docker,
> but they should work with podman just as well.

## Usage

First, pull the image from github:

```shell
docker pull ghcr.io/maybeetree/raimad-tooling:latest
```

Or, build the container locally:

```shell
git clone https://github.com/tifuun/raimad-tooling
cd raimad-tooling
docker build -t raimad-tooling .
```
Note: this will take hours.

The default container command is to launch the built-in
`tooling-summary.sh` script and generate an overview
of RAIMAD's code quality:

```shell
docker run -v "/path/to/raimad/repo:/pwd" raimad-tooling
```
# TODO make it work with mount /pwd as ro

Sample output:
```
TOOLING_UNITTEST_3.13=true  # Did unittests pass?
TOOLING_UNITTEST_3.12=true  # Did unittests pass?
TOOLING_UNITTEST_3.11=true  # Did unittests pass?
TOOLING_UNITTEST_3.10=true  # Did unittests pass?
TOOLING_MYPY=true  # Were there NO mypy issues?
TOOLING_COVERAGE=89  # Percentage of codebase covered by tests
TOOLING_TODOS=67  # How many TODOs and FIXMEs are in the code?
TOOLING_RUFF=107  # How many issues reported by ruff?
```

The script should exit with code 0,
otherwise that means an error occurred.

To find out more, you can run different pieces of tooling individually:

```
# Run the test suite in different python versions

docker run -v "/path/to/raimad/repo:/pwd" raimad-tooling python3.10 -m unittest
docker run -v "/path/to/raimad/repo:/pwd" raimad-tooling python3.11 -m unittest
docker run -v "/path/to/raimad/repo:/pwd" raimad-tooling python3.12 -m unittest

# Run mypy
docker run -v "/path/to/raimad/repo:/pwd" raimad-tooling python3.12 -m mypy

# Run ruff
docker run -v "/path/to/raimad/repo:/pwd" raimad-tooling python3.12 -m ruff

```

## Manual caching

If you're making any major changes to the dockerfile,
it can be a pain to wait for the pythons to rebuild every time.
You can re-use python builds from previous iterations
of the docker image by copying them into the `cache`
directory in the root of this repo:

```
docker run -ti -v ./cache:/cache raimad-tooling sh -c 'cp -r /pythons /cache/ && cp -r /pyvenvs /cache/'
```

On subsequent builds of the image,
compiling the pythons should be skipped.

This isn't an optimal solution tho,
as it will result in duplicating the python build directory
on disk.
I can't think of any way to avoid this
(mount a volume while building? Hardlink? Reflink?)
that works without going behind docker/podman's back.





