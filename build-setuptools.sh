#!/bin/bash

set -eu

. common.sh

pkgver=36.2.7

wget --continue https://github.com/pypa/setuptools/archive/v${pkgver}.tar.gz

tar xf v${pkgver}.tar.gz

cd "${srcdir}/setuptools-${pkgver}"

patch -p1 -i ${patchdir}/setuptools/0001-mingw-python-fix.patch
patch -p1 -i ${patchdir}/setuptools/0002-Allow-usr-bin-env-in-script.patch
patch -p1 -i ${patchdir}/setuptools/0003-MinGW-w64-Look-in-same-dir-as-script-for-exe.patch
patch -p1 -i ${patchdir}/setuptools/0004-dont-execute-msvc.patch

${pkgdir}${MINGW_PREFIX}/bin/python3 bootstrap.py
${pkgdir}${MINGW_PREFIX}/bin/python3 setup.py build

MSYS2_ARG_CONV_EXCL="--prefix=;--install-scripts=;--install-platlib=" \
  ${pkgdir}${MINGW_PREFIX}/bin/python3 setup.py install --prefix=${MINGW_PREFIX#\/} --root="${pkgdir}" --optimize=1 --skip-build
