FROM alpine:latest AS base
# This "base" stage just sets these args so that they persist into
# all other stages. Otherwise they would need to be re-specified
# in each stage
ARG PYTHONS="3.13.2 3.12.9 3.11.11 3.10.16"
ARG PIPMODULES="cift ruff coverage mypy"

ENV PYTHONS=${PYTHONS}
ENV PIPMODULES=${PIPMODULES}

# These are needed for all stages
RUN apk add --no-cache expat-dev sqlite-dev jq

FROM base AS build-pythons
COPY ./cache /
COPY ./stage-build-pythons /app
WORKDIR /app
RUN ./build-pythons.sh

FROM base AS make-venvs
COPY --from=build-pythons /pythons /pythons
COPY ./stage-make-venvs /app
WORKDIR /app
RUN ./make-venvs.sh

FROM base AS install-modules
COPY --from=build-pythons /pythons /pythons
COPY --from=make-venvs /pyvenvs /pyvenvs
COPY ./stage-install-modules /app
WORKDIR /app
RUN ./install-modules.sh

FROM base AS finalize
COPY --from=build-pythons /pythons /pythons
COPY --from=install-modules /pyvenvs /pyvenvs
COPY ./stage-finalize /app
WORKDIR /app
RUN ./finalize.sh
WORKDIR /pwd

