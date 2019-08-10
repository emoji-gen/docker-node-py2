FROM node:12.8.0-stretch AS node
FROM python:2.7.16-stretch AS python
FROM debian:stretch-slim AS combined

ENV DEBIAN_FRONTEND noninteractive

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/include/node /usr/local/include/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /opt /opt

COPY --from=python /usr/local/bin/pip2.7 /usr/local/bin/pip2.7
COPY --from=python /usr/local/bin/python2.7 /usr/local/bin/python2.7
COPY --from=python /usr/local/bin/python2.7-config /usr/local/bin/python2.7-config
COPY --from=python /usr/local/lib/libpython2.7.so.1.0 /usr/local/lib/libpython2.7.so.1.0
COPY --from=python /usr/local/lib/python2.7 /usr/local/lib/python2.7
COPY --from=python /usr/local/include/python2.7 /usr/local/include/python2.7

RUN ["/bin/bash", "-c", "\
  set -eux -o pipefail \
    && apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends \
      git curl ca-certificates ssh-client \
      libyaml-dev zlib1g-dev libssl-dev libbz2-dev libreadline-dev \
    \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
    && ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
    && ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
    && ln -s /opt/yarn-*/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn-*/bin/yarnpkg /usr/local/bin/yarnpkg \
    && node -v \
    && yarn -v \
    && npm -v \
    \
    && ln -s /usr/local/bin/pip2.7 /usr/local/bin/pip2 \
    && ln -s /usr/local/bin/pip2 /usr/local/bin/pip \
    && ln -s /usr/local/bin/python2.7 /usr/local/bin/python2 \
    && ln -s /usr/local/bin/python2 /usr/local/bin/python \
    && ln -s /usr/local/bin/python2.7-config /usr/local/bin/python2-config \
    && ln -s /usr/local/bin/python2-config /usr/local/bin/python-config \
    && ln -s /usr/local/lib/libpython2.7.so.1.0 /usr/local/lib/libpython2.7.so \
    && ldconfig \
    \
    && pip install pip --upgrade \
    && pip install wheel==0.31.1 --upgrade \
    \
    && apt-get -qq autoremove -y \
    && apt-get -qq clean \
    && rm -rf ~/.cache/pip/ \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* \
"]

CMD ["/bin/bash"]
