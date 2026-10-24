#!/bin/sh
# Install ooRexx from SourceForge's .deb at the revision the CI pins
# (OOREXX_REV in .github/workflows/ci.yml), so that a local setup and the
# CI never differ.  Ubuntu 24.04, x86_64.  Run as root.
set -eu
here=$(cd "$(dirname "$0")/.." && pwd)
rev=$(sed -n 's/^ *OOREXX_REV: *"\{0,1\}\([0-9]*\)"\{0,1\} *$/\1/p' "$here/.github/workflows/ci.yml" | head -1)
[ -n "$rev" ] || { echo "OOREXX_REV not found in ci.yml" >&2; exit 1; }
deb="oorexx-5.3.0-$rev.ubuntu2404.x86_64.deb"
tmp=${TMPDIR:-/tmp}/$deb
curl -fsSL -o "$tmp" "https://downloads.sourceforge.net/project/oorexx/oorexx/5.3.0beta/$deb"
dpkg-deb -I "$tmp" >/dev/null   # an HTML error page is not a package
dpkg -i "$tmp"
ldconfig
rexx -v
