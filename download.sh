#!/usr/bin/env bash

[ -f libtoddog.so ] && rm libtoddog.so*
curl -s https://api.github.com/repos/kikitux/oracle-toddog-function/releases/latest | grep "browser_download_url" | cut -d : -f 2,3 | tr -d \" | wget -i -
