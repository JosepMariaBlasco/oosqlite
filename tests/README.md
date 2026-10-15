# ooSQLite test suite

Regression tests for ooSQLite, written for the ooRexxUnit framework that
the ooRexx test suite uses.

| File | Contents |
|---|---|
| `ooSQLite.testGroup` | The tests: OO and classic interfaces, callbacks, extensions and SQLite 3.52 features (371 tests, 1085 assertions). |
| `ooSQLite-TestSuite-Callbacks.cls` | Handler classes used by the callback tests. |
| `framework/` | The ooRexxUnit framework, copied from the ooRexx test suite (see `framework/README.md`). |

## Running the tests

You need ooRexx 5.x and a built `liboosqlite` that the dynamic linker can
find. After `make -f Makefile.lin lib` at the top of the repository, from
this directory:

```sh
LD_LIBRARY_PATH=$PWD/../bin/linux REXX_PATH=$PWD/framework:$PWD/../bin/linux \
  rexx ooSQLite.testGroup
```

On Windows, use `;` as the separator and `%CD%` instead of `$PWD`.

Temporary databases and files are created with the framework's
`.TemporaryTestFile` class in the platform's temporary directory
(`.File~temporaryPath`: `TMPDIR` or `/tmp` on Unix-like systems, `%TEMP%`
on Windows), as the ooRexx test suite does, and are deleted afterwards.
