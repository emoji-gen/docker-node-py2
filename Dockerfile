FROM python:2.7.14-stretch

RUN set -ex \
  && apt-get -qq update \
  && apt-get -qq install -y --no-install-recommends \
    curl ca-certificates \
  \
  && curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash \
  && apt-get -qq install git-lfs \
  \
  && apt-get -qq autoremove -y \
  && apt-get -qq clean \
  && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

CMD ["/bin/bash"]
