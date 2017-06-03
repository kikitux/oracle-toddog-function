#!/usr/bin/env bash

if [ -d /usr/local/cmake-3.8.2-Linux-x86_64/bin ] ; then
PATH=${PATH}:/usr/local/cmake-3.8.2-Linux-x86_64/bin
fi

cd /project/build
cmake ..
make
