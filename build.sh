#!/bin/bash

set -eu

pkgver=3.6.2

MINGW_CHOST="x86_64-w64-mingw32"

MINGW_PREFIX="/mingw64"
PREFIX_WIN="$(cygpath -wm ${MINGW_PREFIX})"

CFLAGS+=" -fwrapv -D__USE_MINGW_ANSI_STDIO=1 "
CXXFLAGS+=" -fwrapv -D__USE_MINGW_ANSI_STDIO=1"
CPPFLAGS+=" -I${PREFIX_WIN}/include/ncursesw "

export CFLAGS
export CXXFLAGS
export CPPFLAGS

# Workaround for conftest error on 64-bit builds
export ac_cv_working_tzset=no

[ -d "build" ] && rm -rf "build"
mkdir -p "build" && cd "build"

MSYSTEM=MINGW ../Python-${pkgver}/configure \
  --prefix=${MINGW_PREFIX} \
  --host=${MINGW_CHOST} \
  --build=${MINGW_CHOST} \
  --enable-shared \
  --with-threads \
  --with-system-expat \
  --with-system-ffi \
  --without-ensurepip \
  OPT=""

make -j
