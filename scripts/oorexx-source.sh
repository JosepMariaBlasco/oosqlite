#!/bin/sh
# Export ooRexx's source from Subversion (oorexx/code-0, main/trunk) at the
# revision the CI pins (OOREXX_REV in .github/workflows/ci.yml), ready for
# scripts/oorexx-build.sh.  Used while SourceForge publishes no builds of that
# revision (its build machine was down in November 2026).  Needs svn.
#
#   scripts/oorexx-source.sh <dir>
#
# An export has no working copy, so CMake cannot ask Subversion for the
# revision and would build "r0", which ooSQLite.cls refuses: ORX_BLD_LVL is
# set in CMakeLists.txt to the revision exported.
set -eu
[ $# -eq 1 ] || { echo "usage: $0 <dir>" >&2; exit 2; }
dir=$1
here=$(cd "$(dirname "$0")/.." && pwd)
rev=$(sed -n 's/^ *OOREXX_REV: *"\{0,1\}\([0-9]*\)"\{0,1\} *$/\1/p' "$here/.github/workflows/ci.yml" | head -1)
[ -n "$rev" ] || { echo "OOREXX_REV not found in ci.yml" >&2; exit 1; }
rm -rf "$dir"
svn export -q -r "$rev" https://svn.code.sf.net/p/oorexx/code-0/main/trunk "$dir"
sed -i.orig "s/^set (ORX_BLD_LVL 0)/set (ORX_BLD_LVL $rev)/" "$dir/CMakeLists.txt"
rm -f "$dir/CMakeLists.txt.orig"
grep -q "^set (ORX_BLD_LVL $rev)" "$dir/CMakeLists.txt" || { echo "ORX_BLD_LVL not set in CMakeLists.txt" >&2; exit 1; }
echo "ooRexx r$rev exported to $dir" >&2
