#!/bin/bash

set -x

wget https://www.unidata.ucar.edu/downloads/ldm/ldm-${LDM_VERSION}.tar.gz

gunzip -c ldm-${LDM_VERSION}.tar.gz | pax -r '-s:/:/src/:'

rm ldm-${LDM_VERSION}.tar.gz

cd /home/ldm/ldm-${LDM_VERSION}/src

./configure --disable-root-actions

make install > make.log 2>&1

# optional
# make distclean

cd /home/ldm
