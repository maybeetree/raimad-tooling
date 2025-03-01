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
TODO
```

Or, build the container locally:

```shell
git clone https://github.com/tifuun/raimad-tooling
cd raimad-tooling
docker build -t raimad-tooling .
```
Note: this will take hours.

The default container command is to launch the built-in
`tooling.sh` script and generate an overview
of RAIMAD's code quality:

```shell
docker run -v "/path/to/raimad/repo:/pwd:ro" raimad-tooling
```

Sample output:
```
TODO
```

To find out more, you can run different pieces of tooling individually:

```
# Run the test suite in different python versions

docker run -v "/path/to/raimad/repo:/pwd:ro" raimad-tooling python3.10 -m unittest
docker run -v "/path/to/raimad/repo:/pwd:ro" raimad-tooling python3.11 -m unittest
docker run -v "/path/to/raimad/repo:/pwd:ro" raimad-tooling python3.12 -m unittest

# Run mypy
docker run -v "/path/to/raimad/repo:/pwd:ro" raimad-tooling python3.12 -m mypy

# Run ruff
docker run -v "/path/to/raimad/repo:/pwd:ro" raimad-tooling python3.12 -m ruff

# Run coverage
docker run -v "/path/to/raimad/repo:/pwd:ro" raimad-tooling python3.12 -m coverage -m unittest

TODO verify commands

```





