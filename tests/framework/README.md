# ooRexxUnit framework

These files are copied unchanged from the ooRexx test suite, in the ooRexx
Subversion repository on SourceForge (`oorexx/code-0`, `test/trunk`,
exported at r13271). They are distributed under the Common Public License
1.0, like the rest of this repository.

| File | Path in `test/trunk` |
|---|---|
| `OOREXXUNIT.CLS` | `framework/OOREXXUNIT.CLS` |
| `ooTest.frm` | `ooTest.frm` |
| `worker.rex` | `worker.rex` |
| `PLEASE.READ` | `framework/PLEASE.READ` |

They are kept here so that the tests can run, including in continuous
integration, without a checkout of the ooRexx test suite. To refresh them:

```sh
B=https://svn.code.sf.net/p/oorexx/code-0/test/trunk
svn export --force $B/framework/OOREXXUNIT.CLS
svn export --force $B/ooTest.frm
svn export --force $B/worker.rex
```
