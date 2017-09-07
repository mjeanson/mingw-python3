#!/bin/bash

set -eu

MINGW_PACKAGE_PREFIX=mingw-w64-x86_64

py_depends=(
	"base-devel"
	"${MINGW_PACKAGE_PREFIX}-toolchain"
	"${MINGW_PACKAGE_PREFIX}-gcc"
	"${MINGW_PACKAGE_PREFIX}-gcc-libs"
         "${MINGW_PACKAGE_PREFIX}-expat"
         "${MINGW_PACKAGE_PREFIX}-bzip2"
         "${MINGW_PACKAGE_PREFIX}-gdbm"
         "${MINGW_PACKAGE_PREFIX}-libffi"
         "${MINGW_PACKAGE_PREFIX}-ncurses"
         "${MINGW_PACKAGE_PREFIX}-openssl"
         "${MINGW_PACKAGE_PREFIX}-readline"
         "${MINGW_PACKAGE_PREFIX}-tcl"
         "${MINGW_PACKAGE_PREFIX}-tk"
         "${MINGW_PACKAGE_PREFIX}-zlib"
         "${MINGW_PACKAGE_PREFIX}-xz"
         "${MINGW_PACKAGE_PREFIX}-sqlite3"
	 "${MINGW_PACKAGE_PREFIX}-pkg-config"
        )

bt_depends=(
	"${MINGW_PACKAGE_PREFIX}-glib2"
	"${MINGW_PACKAGE_PREFIX}-popt"
	"${MINGW_PACKAGE_PREFIX}-swig"
	"glib2-devel"
)

pacman -S "${py_depends[@]}" "${bt_depends[@]}"
