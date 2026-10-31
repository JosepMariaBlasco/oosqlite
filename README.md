# ooSQLite

[![CI](https://github.com/JosepMariaBlasco/oosqlite/actions/workflows/ci.yml/badge.svg)](https://github.com/JosepMariaBlasco/oosqlite/actions/workflows/ci.yml)
[![Platforms](https://github.com/JosepMariaBlasco/oosqlite/actions/workflows/platforms.yml/badge.svg)](https://github.com/JosepMariaBlasco/oosqlite/actions/workflows/platforms.yml)

ooSQLite is the interface between [Open Object Rexx](https://www.oorexx.org/)
(ooRexx) and [SQLite](https://sqlite.org/), the embedded SQL database
engine. It was written by Mark Miesfeld within the ooRexx project, and its
reference is part of the ooRexx documentation
([*ooSQLite Reference*](https://www.oorexx.org/docs/pdf/oosqlite.pdf)).

## Goal

This project aims to **update and finish ooSQLite**:

- bring it up to date with the current SQLite release and with ooRexx 5.x;
- finish what was left incomplete, so that it can have a stable release;
- build it on Linux, macOS and Windows, with continuous integration on all
  three;
- give it a test suite and documentation that match the code.

## Status

The full history of ooSQLite has been imported from the ooRexx Subversion
repository on SourceForge (`oorexx/code-0`, path `incubator/ooSQLite`):
174 revisions, from r7815 (May 2012) to r13111 (March 2026). Each imported
commit keeps its original author and date, and a `git-svn-id` line that
points to its SVN revision. The tag `svn-r13111` marks the import point.

Work on the goals above starts from there.

## Building

ooSQLite builds on Linux, macOS and Windows. It needs **ooRexx 5.3.0 r13344
or later** (a 5.3.0 beta from SourceForge, for now): `ooSQLite.cls` checks
the revision when it is loaded, and stops with an error message on an older
ooRexx. You need it installed (its headers and the `rexx` and `rexxapi`
libraries) or its portable build. SQLite (3.52.0) and zlib are compiled into the library. From the top
of the repository:

| Platform | Command | Output folder |
|---|---|---|
| Linux (gcc) | `make -f Makefile.lin lib` | `bin/linux` |
| macOS (clang) | `make -f Makefile.mac lib REXX_HOME=<ooRexx>` | `bin/macos` |
| Windows (Visual C++) | `nmake /F Makefile.win lib` | `bin\windows` |

`lib` builds the library and copies it, together with `ooSQLite.cls`, to
the output folder. `REXX_HOME`, the folder of ooRexx, is optional when its
headers and libraries are where the compiler looks; `Makefile.win` takes
it from the environment. The target `all` also builds the shell
(`oosqlite3`, `ooSQLite3.exe` on Windows) and the example extension
libraries in `examples/user.extensions`, which the tests use
(`example_dlls` builds just those).

Then run the tests from `tests/` (see [`tests/README.md`](tests/README.md)).
On Linux:

```sh
make -f Makefile.lin example_dlls
cd tests
LD_LIBRARY_PATH=$PWD/../bin/linux REXX_PATH=$PWD/framework:$PWD/../bin/linux \
  rexx ooSQLite.testGroup
```

Continuous integration builds and tests every change on Linux
([`ci.yml`](.github/workflows/ci.yml)). The
[`platforms.yml`](.github/workflows/platforms.yml) workflow, run on demand,
does the same on Windows x64 and on macOS (arm64 and x86_64), with the
portable builds of ooRexx at the same revision.

## License

ooSQLite is distributed under the Common Public License, version 1.0
(see [`LICENSE`](LICENSE)), the license of ooRexx.
