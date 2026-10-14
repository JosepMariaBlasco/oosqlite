# ooSQLite

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

## License

ooSQLite is distributed under the Common Public License, version 1.0
(see [`LICENSE`](LICENSE)), the license of ooRexx.
