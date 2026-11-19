#!/bin/sh
# Build ooRexx from the source exported by scripts/oorexx-source.sh and install
# it in <prefix>, a portable Rexx home: bin, include and lib on Linux and macOS;
# the programs in <prefix> and the headers and import libraries in <prefix>/api
# on Windows, which Makefile.win also looks in.  On Windows, run it from a
# shell with the MSVC environment (NMake).
#
#   scripts/oorexx-build.sh <source dir> <prefix>
set -eu
[ $# -eq 2 ] || { echo "usage: $0 <source dir> <prefix>" >&2; exit 2; }
src=$1
prefix=$2
build="$src-build"
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) generator="NMake Makefiles" ;;
  *) generator="Unix Makefiles" ;;
esac
jobs=$(getconf _NPROCESSORS_ONLN 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 2)
rm -rf "$build"
cmake -S "$src" -B "$build" -G "$generator" -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$prefix" >&2
if [ "$generator" = "NMake Makefiles" ]; then
  cmake --build "$build" >&2
else
  cmake --build "$build" -j "$jobs" >&2
fi
cmake --install "$build" >&2
echo "$prefix"
