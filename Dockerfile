FROM node:8.11.1-stretch AS node
FROM debian:stretch-slim AS combined

ENV YARN_VERSION 1.5.1
ENV PYTHON_27_VERSION 2.7.14

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/bin/npm /usr/local/bin/npm
COPY --from=node /usr/local/bin/npx /usr/local/bin/npx
COPY --from=node /usr/local/include/node /usr/local/include/node
COPY --from=node /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=node /opt/yarn-v$YARN_VERSION /opt/yarn-v$YARN_VERSION

RUN set -ex \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  \
  && apt-get -qq update \
  && apt-get -qq install -y --no-install-recommends \
    git gcc make \
    libyaml-dev zlib1g-dev libssl-dev libbz2-dev libreadline-dev \
    libfontconfig1-dev libx11-dev libxcomposite-dev \
    libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev \
    curl ca-certificates ssh-client \
  \
  && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
  && apt-get -qq install git-lfs \
  \
  && mkdir -p /usr/local \
  && git clone https://github.com/tagomoris/xbuild.git /usr/local/xbuild \
  && /usr/local/xbuild/python-install -f $PYTHON_27_VERSION /usr/local/python-27 \
  \
  && /usr/local/python-27/bin/pip install pip --upgrade \
  && /usr/local/python-27/bin/pip install wheel --upgrade \
  \
  && rm -rf /usr/local/xbuild \
  && apt-get -qq autoremove -y \
  && apt-get -qq clean \
  && rm -rf ~/.cache/pip/ \
  && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

CMD ["/bin/bash"]
