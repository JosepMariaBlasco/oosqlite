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
find. From this directory:

```sh
REXX_PATH=$PWD/framework:$PWD/../src/rexx rexx ooSQLite.testGroup
```

On Windows, use `;` as the separator and `%CD%` instead of `$PWD`.

The tests currently create their temporary databases under `/tmp`.
