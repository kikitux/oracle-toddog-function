#!/usr/bin/env bash

mkdir -p /usr/share/info/dir
yum install -y --setopt=tsflags='nodocs' gcc make which tar unzip gzip
yum clean all

which cmake 2>/dev/null || {
  mkdir -p tmp
  pushd tmp
  CMAKE="cmake-3.8.2-Linux-x86_64"
  curl -o $CMAKE.sh https://cmake.org/files/v3.8/${CMAKE}.sh
  sh $CMAKE.sh --skip-license --include-subdir --prefix=/usr/local
  [ -f /tmp/cmake-3.8.2-Linux-x86_64.sh ] && rm /tmp/cmake-3.8.2-Linux-x86_64.sh
  popd
}
