#!/bin/bash

set -eu

. common.sh

if [ ! -d "lttng-analyses" ]; then
  git clone https://github.com/lttng/lttng-analyses.git
fi

cd "${srcdir}/lttng-analyses"

${pkgdir}${MINGW_PREFIX}/bin/python3 setup.py build

MSYS2_ARG_CONV_EXCL="--prefix=;--install-scripts=;--install-platlib=" \
  ${pkgdir}${MINGW_PREFIX}/bin/python3 setup.py install --prefix=${MINGW_PREFIX#\/} --root="${pkgdir}" --optimize=1 --skip-build
