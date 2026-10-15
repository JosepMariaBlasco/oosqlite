# APICommon

Helper routines for ooRexx native extensions, shared by several ooRexx
projects. These files are copied unchanged from the ooRexx Subversion
repository on SourceForge (`oorexx/code-0`, `incubator/APICommon/src`,
exported at r13271; last changed in r12623). They are distributed under
the Common Public License 1.0, like the rest of this repository.

This is the ooSQLite flavour of APICommon: its error messages talk about
database connections, not dialogs. ooDialog keeps its own variant.

The ooSQLite build used to expect a prebuilt APICommon in a sibling
directory (`../APICommon/bin.release64/linux`). Keeping the source here
lets ooSQLite build on its own.

To refresh the files:

```sh
B=https://svn.code.sf.net/p/oorexx/code-0/incubator/APICommon/src
svn export --force $B/APICommon.cpp
svn export --force $B/APICommon.hpp
```
