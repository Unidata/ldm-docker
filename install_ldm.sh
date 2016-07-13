#!/bin/bash

set -x

v=6.13.2

wget ftp://ftp.unidata.ucar.edu/pub/ldm/ldm-${v}.tar.gz

gunzip -c ldm-${v}.tar.gz | pax -r '-s:/:/src/:'

cd /home/ldm/ldm-${v}/src

./configure --disable-root-actions

make install > make.log 2>&1

sudo make root-actions

# optional
# make distclean

cd /home/ldm
