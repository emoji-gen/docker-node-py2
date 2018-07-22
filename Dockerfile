FROM node:8.11.1-stretch AS node
FROM python:2.7.15-stretch AS python
FROM debian:stretch-slim AS combined

ENV YARN_VERSION 1.5.1

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/bin/npm /usr/local/bin/npm
COPY --from=node /usr/local/bin/npx /usr/local/bin/npx
COPY --from=node /usr/local/include/node /usr/local/include/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /opt/yarn-v$YARN_VERSION /opt/yarn-v$YARN_VERSION

COPY --from=python /usr/local/bin/pip2.7 /usr/local/bin/pip2.7
COPY --from=python /usr/local/bin/python2.7 /usr/local/bin/python2.7
COPY --from=python /usr/local/bin/python2.7-config /usr/local/bin/python2.7-config
COPY --from=python /usr/local/lib/libpython2.7.so.1.0 /usr/local/lib/libpython2.7.so.1.0
COPY --from=python /usr/local/lib/python2.7 /usr/local/lib/python2.7
COPY --from=python /usr/local/include /usr/local/include

RUN ["/bin/bash", "-c", "\
  set -eux -o pipefail \
    && apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends \
      libyaml-dev zlib1g-dev libssl-dev libbz2-dev libreadline-dev \
    \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
    && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
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
    && pip install wheel --upgrade \
    \
    && apt-get -qq autoremove -y \
    && apt-get -qq clean \
    && rm -rf ~/.cache/pip/ \
    && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* \
"]

CMD ["/bin/bash"]
