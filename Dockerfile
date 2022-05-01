FROM ubuntu:18.04

ARG RUNNER_VERSION="2.290.1"
RUN useradd -m noel && \
    apt-get update -y && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip

WORKDIR /build/runner

RUN curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    chown -R noel /build/runner && \
    ./bin/installdependencies.sh

COPY start.sh .
RUN chmod +x ./start.sh

USER noel
ENTRYPOINT ["./start.sh"]

# This doesn't work :(
# FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine

# ARG RUNNER_VERSION="2.290.1"

# ENV PYTHONUNBUFFERED=1
# RUN adduser -D noel
# RUN apk update && \
#     apk add --no-cache curl jq libffi-dev libressl-dev python3 bash libc6-compat gcompat icu-libs krb5-libs libgcc libintl libssl1.1 libstdc++ zlib --repository=http://dl-cdn.alpinelinux.org/alpine/edge/main && \
#     apk add --no-cache libgdiplus --repository=https://dl-3.alpinelinux.org/alpine/edge/testing/ \
#     ln -sf python3 /usr/bin/python && \
#     python3 -m ensurepip && \
#     pip3 install --no-cache --upgrade pip setuptools && \
#     apk add --update --no-cache python3 && \
#     ln -sf python3 /usr/bin/python && \
#     python3 -m ensurepip && \
#     pip3 install --no-cache --upgrade pip setuptools

# WORKDIR /build/runner

# RUN curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
# RUN tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
# RUN chown -R noel /build/runner
# RUN ./bin/installdependencies.sh
# COPY start.sh .
# RUN chmod +x ./start.sh

# USER noel
# ENTRYPOINT ["./start.sh"]
