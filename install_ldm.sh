#!/bin/bash

set -x

# wget https://www.unidata.ucar.edu/downloads/ldm/ldm-${LDM_VERSION}.tar.gz
wget ftp://ftp.unidata.ucar.edu/pub/ldm/ldm-${LDM_VERSION}.tar.gz

gunzip -c ldm-${LDM_VERSION}.tar.gz | pax -r '-s:/:/src/:'

rm ldm-${LDM_VERSION}.tar.gz

cd /home/ldm/ldm-${LDM_VERSION}/src

./configure --disable-root-actions 2>&1 | tee configure.log

make install 2>&1 | tee make.log

# optional
# make distclean

cd /home/ldm
