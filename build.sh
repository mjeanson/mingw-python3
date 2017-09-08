#!/bin/bash

set -eu

. common.sh

#CFLAGS="-static -static-libgcc -static-libstdc++"
#CPPFLAGS="-static"

CFLAGS+=" -fwrapv -D__USE_MINGW_ANSI_STDIO=1 "
CXXFLAGS+=" -fwrapv -D__USE_MINGW_ANSI_STDIO=1"
CPPFLAGS+=" -I${PREFIX_WIN}/include/ncursesw "

export CFLAGS
export CXXFLAGS
export CPPFLAGS

# Workaround for conftest error on 64-bit builds
export ac_cv_working_tzset=no

[ -d "${builddir}" ] && rm -rf "${builddir}"
mkdir -p "${builddir}" && cd "${builddir}"

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

#sed -i '1s/^/*static*\n/' Modules/Setup

make -j

echo -e "\n\nDone with make\n\n"

MSYSTEM=MINGW \
  MSYS2_ARG_CONV_EXCL="--prefix=;--install-scripts=;--install-platlib=" \
  make install DESTDIR="$pkgdir"

echo -e "\n\nDone with install\n\n"

# gdb pretty printers for debugging Python itself; to use:
# python
# sys.path.append('C:/msys64/mingw64/share/gdb/python3')
# import python_gdb
# reload(python_gdb)
# end
[[ -d "${pkgdir}${MINGW_PREFIX}"/share/gdb/python3/ ]] || mkdir -p "${pkgdir}${MINGW_PREFIX}"/share/gdb/python3/
cp -f python.exe-gdb.py "${pkgdir}${MINGW_PREFIX}"/share/gdb/python3/python_gdb.py

rm "${pkgdir}${MINGW_PREFIX}"/bin/2to3
cp -f "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/config-${VERABI}/libpython${VERABI}.dll.a "${pkgdir}${MINGW_PREFIX}"/lib/libpython${VERABI}.dll.a

# Need for building boost python3 module
cp -f "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/config-${VERABI}/libpython${VERABI}.dll.a "${pkgdir}${MINGW_PREFIX}"/lib/libpython${_pybasever}.dll.a
cp -f "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/config-${VERABI}/libpython${VERABI}.dll.a "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/config-${VERABI}/libpython${_pybasever}.dll.a

# some useful "stuff"
install -dm755 "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/Tools/{i18n,scripts}
install -m755 "${srcdir}/Python-${pkgver}"/Tools/i18n/{msgfmt,pygettext}.py "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/Tools/i18n/
install -m755 "${srcdir}/Python-${pkgver}"/Tools/scripts/{README,*py} "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/Tools/scripts/

# clean up #!s
find "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/ -name '*.py' | \
  xargs sed -i "s|#[ ]*![ ]*/usr/bin/env python$|#!/usr/bin/env python3|"

# clean-up reference to build directory
sed -i "s#${srcdir}/Python-${pkgver}:##" "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/config-${VERABI}/Makefile

for fscripts in 2to3-${_pybasever} idle3 idle${_pybasever} pydoc3 pydoc${_pybasever} pyvenv pyvenv-${_pybasever}; do
  sed -e "s|${MINGW_PREFIX}/bin/python${_pybasever}.exe|/usr/bin/env python${_pybasever}.exe|g" -i "${pkgdir}${MINGW_PREFIX}"/bin/$fscripts
done

sed -i "s|#!${pkgdir}${MINGW_PREFIX}/bin/python${VERABI}.exe|#!/usr/bin/env python${_pybasever}.exe|" "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/config-${VERABI}/python-config.py

# fix permissons
find ${pkgdir}${MINGW_PREFIX} -type f \( -name "*.dll" -o -name "*.exe" \) | xargs chmod 0755

# Fix up two instances of MSYS2 paths in python-config.sh in-case the final consumer of the results are native executables.
sed -e "s|${MINGW_PREFIX}|${PREFIX_WIN}|" \
  -i "${pkgdir}${MINGW_PREFIX}"/bin/python${VERABI}-config \
  -i "${pkgdir}${MINGW_PREFIX}"/bin/python${_pybasever}-config \
  -i "${pkgdir}${MINGW_PREFIX}"/bin/python3-config

# replace paths in sysconfig
sed -i "s|${pkgdir}${MINGW_PREFIX}|${MINGW_PREFIX}|g" \
  "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/lib-dynload/_sysconfigdata*.py \
  "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/smtpd.py

# Create python executable with windows subsystem
cp -f "${pkgdir}${MINGW_PREFIX}"/bin/python3.exe "${pkgdir}${MINGW_PREFIX}"/bin/python3w.exe
${MINGW_PREFIX}/bin/objcopy --subsystem windows "${pkgdir}${MINGW_PREFIX}"/bin/python3w.exe


# Cleanup unwanted modules
rm "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/lib-dynload/_msi-cpython-${VERABI}.dll
rm "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/lib-dynload/_tkinter-cpython-${VERABI}.dll
rm "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/lib-dynload/_gdbm-cpython-${VERABI}.dll
rm "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/lib-dynload/_sqlite3-cpython-${VERABI}.dll
rm -rf "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/msilib
rm -rf "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/tkinter
rm -rf "${pkgdir}${MINGW_PREFIX}"/lib/python${_pybasever}/sqlite3

# Copy dll dependencies
cp ${MINGW_PREFIX}/bin/zlib1.dll "${pkgdir}${MINGW_PREFIX}"/bin/
cp ${MINGW_PREFIX}/bin/libbz2-1.dll "${pkgdir}${MINGW_PREFIX}"/bin/
cp ${MINGW_PREFIX}/bin/LIBEAY32.dll "${pkgdir}${MINGW_PREFIX}"/bin/
cp ${MINGW_PREFIX}/bin/libexpat-1.dll "${pkgdir}${MINGW_PREFIX}"/bin/
cp ${MINGW_PREFIX}/bin/libffi-6.dll "${pkgdir}${MINGW_PREFIX}"/bin/
cp ${MINGW_PREFIX}/bin/liblzma-5.dll "${pkgdir}${MINGW_PREFIX}"/bin/
cp ${MINGW_PREFIX}/bin/libreadline7.dll "${pkgdir}${MINGW_PREFIX}"/bin/
cp ${MINGW_PREFIX}/bin/libtermcap-0.dll "${pkgdir}${MINGW_PREFIX}"/bin/
cp ${MINGW_PREFIX}/bin/SSLEAY32.dll "${pkgdir}${MINGW_PREFIX}"/bin/
