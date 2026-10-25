# ooSQLite test suite

Regression tests for ooSQLite, written for the ooRexxUnit framework that
the ooRexx test suite uses.

| File | Contents |
|---|---|
| `ooSQLite.testGroup` | The tests: OO and classic interfaces, callbacks, extensions and SQLite 3.52 features (371 tests, 1085 assertions). |
| `ooSQLite-TestSuite-Callbacks.cls` | Handler classes used by the callback tests. |
| `framework/` | The ooRexxUnit framework, copied from the ooRexx test suite (see `framework/README.md`). |

## Running the tests

You need ooRexx 5.x, a built ooSQLite library that the dynamic linker can
find, and the example extension libraries. After
`make -f Makefile.lin lib example_dlls` at the top of the repository, from
this directory:

```sh
LD_LIBRARY_PATH=$PWD/../bin/linux REXX_PATH=$PWD/framework:$PWD/../bin/linux \
  rexx ooSQLite.testGroup
```

On macOS, build with `Makefile.mac` and use `DYLD_LIBRARY_PATH` and
`bin/macos`. On Windows, build with `nmake /F Makefile.win lib example_dlls`,
put `bin\windows` on the `PATH`, and use `;` as the separator of
`REXX_PATH` and `%CD%` instead of `$PWD`. The workflows in
`.github/workflows` show the exact steps for each platform.

The suite exits with code 0 even when tests fail: read the summary
(`Failures` and `Errors`). With `OOSQLITE_TEST_HOOKS=1` in the environment,
as the workflows run it, the tests of section C13 force the race they test.

Temporary databases and files are created with the framework's
`.TemporaryTestFile` class in the platform's temporary directory
(`.File~temporaryPath`: `TMPDIR` or `/tmp` on Unix-like systems, `%TEMP%`
on Windows), as the ooRexx test suite does, and are deleted afterwards.
