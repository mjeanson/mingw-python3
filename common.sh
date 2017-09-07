#!/bin/bash

set -eu

srcdir="$(dirname $(readlink -f "$0"))"

_pybasever=3.6
pkgver=${_pybasever}.2

pkgdir="${srcdir}/out"
patchdir="${srcdir}/patches"
builddir="${srcdir}/build"

MINGW_CHOST="x86_64-w64-mingw32"

MINGW_PREFIX="/mingw64"
PREFIX_WIN="$(cygpath -wm ${MINGW_PREFIX})"
VERABI=${_pybasever}m

CFLAGS="-static-libgcc -static-libstdc++"
