#!/bin/sh
# Download and unpack ooRexx's portable build for this platform, at the
# revision the CI pins (OOREXX_REV in .github/workflows/ci.yml), so that every
# platform tests against the same ooRexx.  Used by the platforms workflow.
#
#   scripts/setup-oorexx-portable.sh <platform> <dir>
#
# <platform> is the part of SourceForge's file name after the revision, e.g.
# windows.x86_64 or macos.arm64.x86_64.  The build is unpacked in <dir>, and
# the folder it creates (with bin, include and lib) is printed.
set -eu
[ $# -eq 2 ] || { echo "usage: $0 <platform> <dir>" >&2; exit 2; }
platform=$1
dir=$2
here=$(cd "$(dirname "$0")/.." && pwd)
rev=$(sed -n 's/^ *OOREXX_REV: *"\{0,1\}\([0-9]*\)"\{0,1\} *$/\1/p' "$here/.github/workflows/ci.yml" | head -1)
[ -n "$rev" ] || { echo "OOREXX_REV not found in ci.yml" >&2; exit 1; }
name="oorexx-5.3.0-$rev.$platform-portable-release"
mkdir -p "$dir"
curl -fsSL -o "$dir/$name.zip" "https://downloads.sourceforge.net/project/oorexx/oorexx/5.3.0beta/portable/$name.zip"
if command -v unzip >/dev/null 2>&1; then
  unzip -q -o "$dir/$name.zip" -d "$dir" >&2
else
  7z x -y -o"$dir" "$dir/$name.zip" >&2   # Windows runners without unzip
fi
rm -f "$dir/$name.zip"
[ -d "$dir/$name/bin" ] || { echo "$dir/$name/bin not found after unzip" >&2; exit 1; }
echo "$dir/$name"
