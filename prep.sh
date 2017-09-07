#!/bin/bash

set -eu

. common.sh

wget --continue https://www.python.org/ftp/python/${pkgver}/Python-${pkgver}.tar.xz

tar xf Python-${pkgver}.tar.xz

cd Python-${pkgver}

echo "Apply Ray Donnelly's should-be-upstreamed patches"
patch -Np1 -i "${patchdir}"/0000-make-_sysconfigdata.py-relocatable.patch
patch -Np1 -i "${patchdir}"/0001-fix-_nt_quote_args-using-subprocess-list2cmdline.patch

echo "Apply Roumen Petrov's core patches (14)"
patch -Np1 -i "${patchdir}"/0100-MINGW-BASE-use-NT-thread-model.patch
# these are created by the next patch
rm -f Misc/config_mingw Misc/cross_mingw32
patch -Np1 -i "${patchdir}"/0110-MINGW-translate-gcc-internal-defines-to-python-platf.patch
patch -Np1 -i "${patchdir}"/0130-MINGW-configure-MACHDEP-and-platform-for-build.patch
patch -Np1 -i "${patchdir}"/0140-MINGW-preset-configure-defaults.patch
patch -Np1 -i "${patchdir}"/0150-MINGW-configure-largefile-support-for-windows-builds.patch
patch -Np1 -i "${patchdir}"/0170-MINGW-add-srcdir-PC-to-CPPFLAGS.patch
patch -Np1 -i "${patchdir}"/0180-MINGW-init-system-calls.patch
patch -Np1 -i "${patchdir}"/0200-MINGW-build-in-windows-modules-winreg.patch
patch -Np1 -i "${patchdir}"/0210-MINGW-determine-if-pwdmodule-should-be-used.patch
patch -Np1 -i "${patchdir}"/0220-MINGW-default-sys.path-calculations-for-windows-plat.patch
# these are created by the next patch
rm -f Python/fileblocks.c
patch -Np1 -i "${patchdir}"/0230-MINGW-AC_LIBOBJ-replacement-of-fileblocks.patch
patch -Np1 -i "${patchdir}"/0240-MINGW-use-main-to-start-execution.patch

echo "Apply Roumen Petrov's compiler patch (2)"
patch -Np1 -i "${patchdir}"/0250-MINGW-compiler-customize-mingw-cygwin-compilers.patch
patch -Np1 -i "${patchdir}"/0260-MINGW-compiler-enable-new-dtags.patch

echo "Apply Roumen Petrov's extensions patches (23)"
patch -Np1 -i "${patchdir}"/0270-CYGWIN-issue13756-Python-make-fail-on-cygwin.patch
patch -Np1 -i "${patchdir}"/0290-issue6672-v2-Add-Mingw-recognition-to-pyport.h-to-al.patch
patch -Np1 -i "${patchdir}"/0300-MINGW-configure-for-shared-build.patch
patch -Np1 -i "${patchdir}"/0310-MINGW-dynamic-loading-support.patch
patch -Np1 -i "${patchdir}"/0320-MINGW-implement-exec-prefix.patch
patch -Np1 -i "${patchdir}"/0330-MINGW-ignore-main-program-for-frozen-scripts.patch
patch -Np1 -i "${patchdir}"/0340-MINGW-setup-exclude-termios-module.patch
patch -Np1 -i "${patchdir}"/0350-MINGW-setup-_multiprocessing-module.patch
patch -Np1 -i "${patchdir}"/0360-MINGW-setup-select-module.patch
patch -Np1 -i "${patchdir}"/0370-MINGW-setup-_ctypes-module-with-system-libffi.patch
patch -Np1 -i "${patchdir}"/0380-MINGW-defect-winsock2-and-setup-_socket-module.patch
patch -Np1 -i "${patchdir}"/0390-MINGW-exclude-unix-only-modules.patch
patch -Np1 -i "${patchdir}"/0400-MINGW-setup-msvcrt-and-_winapi-modules.patch
patch -Np1 -i "${patchdir}"/0410-MINGW-build-extensions-with-GCC.patch
patch -Np1 -i "${patchdir}"/0420-MINGW-use-Mingw32CCompiler-as-default-compiler-for-m.patch
patch -Np1 -i "${patchdir}"/0430-MINGW-find-import-library.patch
patch -Np1 -i "${patchdir}"/0440-MINGW-setup-_ssl-module.patch
patch -Np1 -i "${patchdir}"/0460-MINGW-generalization-of-posix-build-in-sysconfig.py.patch
patch -Np1 -i "${patchdir}"/0462-MINGW-support-stdcall-without-underscore.patch
patch -Np1 -i "${patchdir}"/0464-use-replace-instead-rename-to-avoid-failure-on-windo.patch
patch -Np1 -i "${patchdir}"/0470-MINGW-avoid-circular-dependency-from-time-module-dur.patch
patch -Np1 -i "${patchdir}"/0480-MINGW-generalization-of-posix-build-in-distutils-sys.patch
patch -Np1 -i "${patchdir}"/0490-MINGW-customize-site.patch

echo "Apply Ray Donnelly's general/cross patches (42)"
patch -Np1 -i "${patchdir}"/0500-add-python-config-sh.patch
patch -Np1 -i "${patchdir}"/0510-cross-darwin-feature.patch
patch -Np1 -i "${patchdir}"/0520-py3k-mingw-ntthreads-vs-pthreads.patch
patch -Np1 -i "${patchdir}"/0530-mingw-system-libffi.patch
patch -Np1 -i "${patchdir}"/0540-mingw-semicolon-DELIM.patch
patch -Np1 -i "${patchdir}"/0555-msys-mingw-prefer-unix-sep-if-MSYSTEM.patch
patch -Np1 -i "${patchdir}"/0560-mingw-use-posix-getpath.patch
patch -Np1 -i "${patchdir}"/0565-mingw-add-ModuleFileName-dir-to-PATH.patch
patch -Np1 -i "${patchdir}"/0570-mingw-add-BUILDIN_WIN32_MODULEs-time-msvcrt.patch
# 0610- changed to not using -DVPATH='"$(VPATH_b2h)"' anymore since VPATH is
# relative, therefore getpath.c:355: joinpath(prefix, vpath) works naturally
patch -Np1 -i "${patchdir}"/0610-msys-cygwin-semi-native-build-sysconfig.patch
patch -Np1 -i "${patchdir}"/0620-mingw-sysconfig-like-posix.patch
patch -Np1 -i "${patchdir}"/0630-mingw-_winapi_as_builtin_for_Popen_in_cygwinccompiler.patch
patch -Np1 -i "${patchdir}"/0640-mingw-x86_64-size_t-format-specifier-pid_t.patch
patch -Np1 -i "${patchdir}"/0650-cross-dont-add-multiarch-paths-if-cross-compiling.patch
patch -Np1 -i "${patchdir}"/0660-mingw-use-backslashes-in-compileall-py.patch
patch -Np1 -i "${patchdir}"/0670-msys-convert_path-fix-and-root-hack.patch
patch -Np1 -i "${patchdir}"/0690-allow-static-tcltk.patch
patch -Np1 -i "${patchdir}"/0710-CROSS-properly-detect-WINDOW-_flags-for-different-nc.patch
patch -Np1 -i "${patchdir}"/0720-mingw-pdcurses_ISPAD.patch
patch -Np1 -i "${patchdir}"/0730-mingw-fix-ncurses-module.patch
patch -Np1 -i "${patchdir}"/0740-grammar-fixes.patch
patch -Np1 -i "${patchdir}"/0750-builddir-fixes.patch
patch -Np1 -i "${patchdir}"/0760-msys-monkeypatch-os-system-via-sh-exe.patch
patch -Np1 -i "${patchdir}"/0770-msys-replace-slashes-used-in-io-redirection.patch
patch -Np1 -i "${patchdir}"/0790-mingw-add-_exec_prefix-for-tcltk-dlls.patch
patch -Np1 -i "${patchdir}"/0800-mingw-install-layout-as-posix.patch
patch -Np1 -i "${patchdir}"/0810-remove_path_max.default.patch
patch -Np1 -i "${patchdir}"/0820-dont-link-with-gettext.patch
patch -Np1 -i "${patchdir}"/0830-ctypes-python-dll.patch
patch -Np1 -i "${patchdir}"/0840-gdbm-module-includes.patch
patch -Np1 -i "${patchdir}"/0850-use-gnu_printf-in-format.patch
patch -Np1 -i "${patchdir}"/0860-fix-_Py_CheckPython3-prototype.patch
patch -Np1 -i "${patchdir}"/0870-mingw-fix-ssl-dont-use-enum_certificates.patch
patch -Np1 -i "${patchdir}"/0890-mingw-build-optimized-ext.patch
patch -Np1 -i "${patchdir}"/0900-cygwinccompiler-dont-strip-modules-if-pydebug.patch
patch -Np1 -i "${patchdir}"/0910-fix-using-dllhandle-and-winver-mingw.patch
patch -Np1 -i "${patchdir}"/0920-mingw-add-LIBPL-to-library-dirs.patch
patch -Np1 -i "${patchdir}"/0930-mingw-w64-build-overlapped-module.patch
patch -Np1 -i "${patchdir}"/0940-mingw-w64-Also-define-_Py_BEGIN_END_SUPPRESS_IPH-when-Py_BUILD_CORE_MODULE.patch
patch -Np1 -i "${patchdir}"/0950-mingw-w64-XP3-compat-GetProcAddress-GetTickCount64.patch
patch -Np1 -i "${patchdir}"/0960-mingw-w64-XP3-compat-GetProcAddress-GetFinalPathNameByHandleW.patch
patch -Np1 -i "${patchdir}"/0970-Add-AMD64-to-sys-config-so-msvccompiler-get_build_version-works.patch
patch -Np1 -i "${patchdir}"/0980-mingw-readline-features-skip.patch
patch -Np1 -i "${patchdir}"/0990-MINGW-link-with-additional-library.patch

patch -Np1 -i "${patchdir}"/1010-install-msilib.patch

echo "Apply patch contributed by Frode Solheim from FS-UAE project (1)"
patch -Np1 -i "${patchdir}"/1500-mingw-w64-dont-look-in-DLLs-folder-for-python-dll.patch

echo "New patches added for the update from 3.5.3 to 3.6.1"
patch -Np1 -i "${patchdir}"/1600-fix-disable-blake2-sse.patch
patch -Np1 -i "${patchdir}"/1610-fix-have-wspawnv.patch
patch -Np1 -i "${patchdir}"/1620-fix-signal-module-build.patch
patch -Np1 -i "${patchdir}"/1630-build-winconsoleio.patch
patch -Np1 -i "${patchdir}"/1640-dont-include-consoleapi-h.patch
patch -Np1 -i "${patchdir}"/1650-expose-sem_unlink.patch

# Extend some isatty calls to check for mintty when checking for
# a terminal output. Disable the readline module under non-mintty as it
# breaks things with a real console (like conemu or winpty)
# https://github.com/Alexpux/MINGW-packages/issues/2645
# https://github.com/Alexpux/MINGW-packages/issues/2656
patch -Np1 -i "${patchdir}"/1700-cygpty-isatty-disable-readline.patch

autoreconf -vfi

# Temporary workaround for FS#22322
# See https://bugs.python.org/issue10835 for upstream report
#sed -i "/progname =/s/python/python${_pybasever}/" Python/pythonrun.c

touch Include/graminit.h
touch Python/graminit.c
touch Parser/Python.asdl
touch Parser/asdl.py
touch Parser/asdl_c.py
touch Include/Python-ast.h
touch Python/Python-ast.c
echo \"\" > Parser/pgen.stamp

# Ensure that we are using the system copy of various libraries (expat, zlib and libffi),
# rather than copies shipped in the tarball
rm -r Modules/expat
rm -r Modules/zlib
rm -r Modules/_ctypes/{darwin,libffi}*
