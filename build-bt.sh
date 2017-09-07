#!/bin/bash

set -eu

. common.sh

if [ ! -d "babeltrace" ]; then
  git clone https://github.com/mjeanson/babeltrace.git
fi

cd babeltrace

git checkout port-staging

./bootstrap

SWIG_LIB="$(swig -swiglib | tail -n1)" \
  PYTHON="${pkgdir}${MINGW_PREFIX}/bin/python3" \
  ./configure --enable-python-bindings --prefix="${MINGW_PREFIX}"

make -j

MSYSTEM=MINGW \
  MSYS2_ARG_CONV_EXCL="--prefix=;--install-scripts=;--install-platlib=" \
  make install DESTDIR="${pkgdir}"
