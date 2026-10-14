/******************************************************************************/
/*                                                                            */
/* ooSQLite-TestSuite-Callbacks.cls - Callback handler classes for testing    */
/* ====================================================================       */
/*                                                                            */
/* These classes are used by the ooSQLite test suite to test the callback-    */
/* based features of ooSQLiteConnection: commitHook, rollbackHook,           */
/* updateHook, trace, profile, progressHandler, busyHandler,                 */
/* setAuthorizer, createCollation, and collationNeeded.                       */
/*                                                                            */
/* Each class implements the default callback method expected by ooSQLite     */
/* and accumulates information about invocations so that the test methods     */
/* can verify correct behavior.                                               */
/*                                                                            */
/* Copyright (c) 2026 Rexx Language Association. All rights reserved.         */
/*                                                                            */
/* This program and the accompanying materials are made available under       */
/* the terms of the Common Public License v1.0 which accompanies this         */
/* distribution. A copy is also available at the following address:           */
/* https://www.oorexx.org/license.html                                        */
/*                                                                            */
/* Redistribution and use in source and binary forms, with or                 */
/* without modification, are permitted provided that the following            */
/* conditions are met:                                                        */
/*                                                                            */
/* Redistributions of source code must retain the above copyright             */
/* notice, this list of conditions and the following disclaimer.              */
/* Redistributions in binary form must reproduce the above copyright          */
/* notice, this list of conditions and the following disclaimer in            */
/* the documentation and/or other materials provided with the distribution.   */
/*                                                                            */
/* Neither the name of Rexx Language Association nor the names                */
/* of its contributors may be used to endorse or promote products             */
/* derived from this software without specific prior written permission.      */
/*                                                                            */
/* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS        */
/* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT          */
/* LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS          */
/* FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   */
/* OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,      */
/* SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED   */
/* TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,        */
/* OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY     */
/* OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING    */
/* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS         */
/* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.               */
/*                                                                            */
/* Version history:                                                           */
/*                                                                            */
/* Date     Version Details                                                   */
/* -------- ------- --------------------------------------------------------- */
/* 20260331    0.1  First version — 8 callback handler classes                */
/* 20260331    0.2  Added 10 UDF handler classes for Tier 3B:                 */
/*                  ScalarIntDoubleHandler, ScalarConcatHandler,              */
/*                  ScalarUserDataHandler, ScalarHalfHandler,                 */
/*                  ScalarNullHandler, ScalarTypeHandler,                     */
/*                  ScalarCountArgsHandler, ScalarBytesHandler,               */
/*                  AggregateSumHandler, AggregateAvgHandler.                 */
/* 20260331    0.3  Added 3 collation handler classes for Tier 3C:            */
/*                  CollationCaseInsensitiveHandler,                          */
/*                  CollationReverseHandler,                                  */
/*                  CollationNeededHandler.                                   */
/*                                                                            */
/******************************************************************************/

::Options NoProlog
::Requires 'ooSQLite.cls'

/******************************************************************************/
/*                                                                            */
/* CommitHookHandler — receives commit notifications                          */
/*                                                                            */
/* commitHookCallBack(userData) must return 0 to allow the commit, or         */
/* non-zero to convert it into a rollback.                                    */
/*                                                                            */
/******************************************************************************/

::Class "CommitHookHandler" Public

::Attribute callCount Get
::Attribute lastUserData Get

::Method init
  Expose callCount lastUserData
  callCount = 0
  lastUserData = .nil

::Method commitHookCallBack Unguarded
  Expose callCount lastUserData
  Use Strict Arg userData
  callCount += 1
  lastUserData = userData
  Return 0

::Method reset
  Expose callCount lastUserData
  callCount = 0
  lastUserData = .nil

/******************************************************************************/
/*                                                                            */
/* VetoingCommitHookHandler — like CommitHookHandler but vetoes the commit    */
/*                                                                            */
/* Returns non-zero to force a rollback instead of a commit.                  */
/*                                                                            */
/******************************************************************************/

::Class "VetoingCommitHookHandler" Public

::Attribute callCount Get
::Attribute lastUserData Get

::Method init
  Expose callCount lastUserData
  callCount = 0
  lastUserData = .nil

::Method commitHookCallBack Unguarded
  Expose callCount lastUserData
  Use Strict Arg userData
  callCount += 1
  lastUserData = userData
  Return 1

/******************************************************************************/
/*                                                                            */
/* RollbackHookHandler — receives rollback notifications                      */
/*                                                                            */
/* rollbackHookCallBack(userData) return value is ignored by SQLite.          */
/*                                                                            */
/******************************************************************************/

::Class "RollbackHookHandler" Public

::Attribute callCount Get
::Attribute lastUserData Get

::Method init
  Expose callCount lastUserData
  callCount = 0
  lastUserData = .nil

::Method rollbackHookCallBack Unguarded
  Expose callCount lastUserData
  Use Strict Arg userData
  callCount += 1
  lastUserData = userData
  Return 0

::Method reset
  Expose callCount lastUserData
  callCount = 0
  lastUserData = .nil

/******************************************************************************/
/*                                                                            */
/* UpdateHookHandler — receives INSERT/UPDATE/DELETE notifications            */
/*                                                                            */
/* updateHookCallBack(op, dbName, tableName, rowID, userData) return value    */
/* is ignored by SQLite.                                                      */
/*                                                                            */
/******************************************************************************/

::Class "UpdateHookHandler" Public

::Attribute callCount Get
::Attribute events Get

::Method init
  Expose callCount events
  callCount = 0
  events = .Array~new

::Method updateHookCallBack Unguarded
  Expose callCount events
  Use Strict Arg op, dbName, tableName, rowID, userData
  callCount += 1
  event = .Directory~new
  event~setEntry("op", op)
  event~setEntry("dbName", dbName)
  event~setEntry("tableName", tableName)
  event~setEntry("rowID", rowID)
  event~setEntry("userData", userData)
  events~append(event)
  Return 0

::Method reset
  Expose callCount events
  callCount = 0
  events = .Array~new

/******************************************************************************/
/*                                                                            */
/* TraceHandler — receives SQL text as statements begin executing             */
/*                                                                            */
/* traceCallBack(sql, userData) return value is ignored by SQLite.            */
/*                                                                            */
/******************************************************************************/

::Class "TraceHandler" Public

::Attribute callCount Get
::Attribute statements Get

::Method init
  Expose callCount statements
  callCount = 0
  statements = .Array~new

::Method traceCallBack Unguarded
  Expose callCount statements
  Use Strict Arg sql, userData
  callCount += 1
  statements~append(sql)
  Return 0

::Method reset
  Expose callCount statements
  callCount = 0
  statements = .Array~new

/******************************************************************************/
/*                                                                            */
/* ProfileHandler — receives SQL text and timing as statements finish         */
/*                                                                            */
/* profileCallBack(sql, nanoSeconds, userData) return value is ignored by     */
/* SQLite.                                                                    */
/*                                                                            */
/******************************************************************************/

::Class "ProfileHandler" Public

::Attribute callCount Get
::Attribute entries Get

::Method init
  Expose callCount entries
  callCount = 0
  entries = .Array~new

::Method profileCallBack Unguarded
  Expose callCount entries
  Use Strict Arg sql, nanoSeconds, userData
  callCount += 1
  entry = .Directory~new
  entry~setEntry("sql", sql)
  entry~setEntry("nanoSeconds", nanoSeconds)
  entries~append(entry)
  Return 0

::Method reset
  Expose callCount entries
  callCount = 0
  entries = .Array~new

/******************************************************************************/
/*                                                                            */
/* ProgressHandler — receives periodic progress notifications                 */
/*                                                                            */
/* progressCallBack(userData) must return 0 to continue, or non-zero to      */
/* interrupt the operation.                                                   */
/*                                                                            */
/******************************************************************************/

::Class "ProgressHandler" Public

::Attribute callCount Get

::Method init
  Expose callCount
  callCount = 0

::Method progressCallBack Unguarded
  Expose callCount
  Use Strict Arg userData
  callCount += 1
  Return 0

::Method reset
  Expose callCount
  callCount = 0

/******************************************************************************/
/*                                                                            */
/* InterruptingProgressHandler — like ProgressHandler but interrupts after    */
/* a configurable number of invocations                                       */
/*                                                                            */
/******************************************************************************/

::Class "InterruptingProgressHandler" Public

::Attribute callCount Get
::Attribute interruptAfter Get

::Method init
  Expose callCount interruptAfter
  Use Strict Arg interruptAfter = 5
  callCount = 0

::Method progressCallBack Unguarded
  Expose callCount interruptAfter
  Use Strict Arg userData
  callCount += 1
  If callCount >= interruptAfter Then Return 1
  Return 0

/******************************************************************************/
/*                                                                            */
/* BusyHandler — receives busy notifications when a database is locked        */
/*                                                                            */
/* busyCallBack(countInvoked, userData) must return 0 to stop retrying, or   */
/* non-zero to retry.                                                         */
/*                                                                            */
/******************************************************************************/

::Class "BusyHandler" Public

::Attribute callCount Get
::Attribute maxRetries Get

::Method init
  Expose callCount maxRetries
  Use Strict Arg maxRetries = 3
  callCount = 0

::Method busyCallBack Unguarded
  Expose callCount maxRetries
  Use Strict Arg countInvoked, userData
  callCount += 1
  If countInvoked >= maxRetries Then Return 0
  Return 1

::Method reset
  Expose callCount maxRetries
  callCount = 0

/******************************************************************************/
/*                                                                            */
/* AuthorizerHandler — receives authorization requests during SQL             */
/* compilation                                                                */
/*                                                                            */
/* authorizerCallBack(code, str1, str2, str3, str4, userData) must return    */
/* one of: OK, DENY, or IGNORE.                                              */
/*                                                                            */
/* By default, allows everything (returns OK). The denyAction attribute can  */
/* be set to an authorizer action constant to deny that specific action.      */
/*                                                                            */
/******************************************************************************/

::Class "AuthorizerHandler" Public Inherit ooSQLiteConstants

::Attribute callCount Get
::Attribute events Get
::Attribute denyAction Get
::Attribute denyAction Set

::Method init
  Expose callCount events denyAction
  callCount = 0
  events = .Array~new
  denyAction = .nil

::Method authorizerCallBack Unguarded
  Expose callCount events denyAction
  Use Strict Arg code, str1, str2, str3, str4, userData
  callCount += 1
  event = .Directory~new
  event~setEntry("code", code)
  event~setEntry("str1", str1)
  event~setEntry("str2", str2)
  event~setEntry("str3", str3)
  event~setEntry("str4", str4)
  events~append(event)
  If denyAction \= .nil, code = denyAction Then Return self~DENY
  Return self~OK

::Method reset
  Expose callCount events denyAction
  callCount = 0
  events = .Array~new
  denyAction = .nil

/******************************************************************************/
/*                                                                            */
/* Tier 3B: UDF handler classes for createFunction tests                      */
/*                                                                            */
/* These classes implement user-defined SQL functions (scalar and aggregate)   */
/* in Rexx, for use with ooSQLiteConnection~createFunction.                   */
/*                                                                            */
/******************************************************************************/

/******************************************************************************/
/*                                                                            */
/* ScalarIntDoubleHandler — scalar UDF: returns int(x) * 2                    */
/*                                                                            */
/* Callback: xFunc(db, sqlContext, userData, val1)                             */
/*                                                                            */
/******************************************************************************/

::Class "ScalarIntDoubleHandler" Public

::Attribute callCount

::Method init
  Expose callCount
  callCount = 0

::Method xFunc Unguarded
  Expose callCount
  Use Arg db, sqlContext, userData, val1
  callCount += 1
  x = .ooSQLValue~int(val1)
  .ooSQLResult~int(sqlContext, x * 2)
  Return 0

/******************************************************************************/
/*                                                                            */
/* ScalarConcatHandler — scalar UDF: concatenates two text arguments           */
/*                                                                            */
/* Callback: xFunc(db, sqlContext, userData, val1, val2)                       */
/*                                                                            */
/******************************************************************************/

::Class "ScalarConcatHandler" Public

::Method xFunc Unguarded
  Use Arg db, sqlContext, userData, val1, val2
  s1 = .ooSQLValue~text(val1)
  s2 = .ooSQLValue~text(val2)
  .ooSQLResult~text(sqlContext, s1 || s2)
  Return 0

/******************************************************************************/
/*                                                                            */
/* ScalarUserDataHandler — scalar UDF: prepends userData to text argument      */
/*                                                                            */
/* Callback: xFunc(db, sqlContext, userData, val1)                             */
/*                                                                            */
/******************************************************************************/

::Class "ScalarUserDataHandler" Public

::Method xFunc Unguarded
  Use Arg db, sqlContext, userData, val1
  s = .ooSQLValue~text(val1)
  .ooSQLResult~text(sqlContext, userData || s)
  Return 0

/******************************************************************************/
/*                                                                            */
/* ScalarHalfHandler — scalar UDF: returns double(x) / 2                      */
/*                                                                            */
/* Tests ooSQLValue~double and ooSQLResult~double.                            */
/*                                                                            */
/******************************************************************************/

::Class "ScalarHalfHandler" Public

::Method xFunc Unguarded
  Use Arg db, sqlContext, userData, val1
  v = .ooSQLValue~double(val1)
  .ooSQLResult~double(sqlContext, v / 2)
  Return 0

/******************************************************************************/
/*                                                                            */
/* ScalarNullHandler — scalar UDF: always returns NULL                         */
/*                                                                            */
/******************************************************************************/

::Class "ScalarNullHandler" Public

::Method xFunc Unguarded
  Use Arg db, sqlContext, userData
  .ooSQLResult~null(sqlContext)
  Return 0

/******************************************************************************/
/*                                                                            */
/* ScalarTypeHandler — scalar UDF: returns ooSQLValue~type(val)               */
/*                                                                            */
/* Returns the SQLite type constant: 1=INTEGER, 2=FLOAT, 3=TEXT, 4=BLOB,      */
/* 5=NULL.                                                                    */
/*                                                                            */
/******************************************************************************/

::Class "ScalarTypeHandler" Public

::Method xFunc Unguarded
  Use Arg db, sqlContext, userData, val1
  t = .ooSQLValue~type(val1)
  .ooSQLResult~int(sqlContext, t)
  Return 0

/******************************************************************************/
/*                                                                            */
/* ScalarCountArgsHandler — scalar UDF with variable args (-1)                */
/*                                                                            */
/* Returns the number of SQL arguments passed.                                */
/*                                                                            */
/******************************************************************************/

::Class "ScalarCountArgsHandler" Public

::Method xFunc Unguarded
  Use Arg db, sqlContext, userData, ...
  nValues = Arg() - 3
  .ooSQLResult~int(sqlContext, nValues)
  Return 0

/******************************************************************************/
/*                                                                            */
/* ScalarBytesHandler — scalar UDF: returns ooSQLValue~bytes(val)             */
/*                                                                            */
/******************************************************************************/

::Class "ScalarBytesHandler" Public

::Method xFunc Unguarded
  Use Arg db, sqlContext, userData, val1
  b = .ooSQLValue~bytes(val1)
  .ooSQLResult~int(sqlContext, b)
  Return 0

/******************************************************************************/
/*                                                                            */
/* AggregateSumHandler — aggregate UDF: computes SUM of int values            */
/*                                                                            */
/* xStep(db, sqlContext, aggregateObj, userData, val1)                         */
/* xFinal(db, sqlContext, aggregateObj, userData)                              */
/*                                                                            */
/* NOTE: Do NOT use with empty result sets — causes SIGSEGV (known bug).      */
/*                                                                            */
/******************************************************************************/

::Class "AggregateSumHandler" Public

::Method xStep Unguarded
  Use Arg db, sqlContext, aggregateObj, userData, val1
  x = .ooSQLValue~int(val1)
  If aggregateObj == .nil Then Do
    acc = .Directory~new
    acc["SUM"] = x
    Return acc
  End
  Else Do
    aggregateObj["SUM"] = aggregateObj["SUM"] + x
    Return aggregateObj
  End

::Method xFinal Unguarded
  Use Arg db, sqlContext, aggregateObj, userData
  If aggregateObj == .nil Then
    .ooSQLResult~int(sqlContext, 0)
  Else
    .ooSQLResult~int(sqlContext, aggregateObj["SUM"])
  Return 0

/******************************************************************************/
/*                                                                            */
/* AggregateAvgHandler — aggregate UDF: computes average of double values     */
/*                                                                            */
/* NOTE: Do NOT use with empty result sets — causes SIGSEGV (known bug).      */
/*                                                                            */
/******************************************************************************/

::Class "AggregateAvgHandler" Public

::Method xStep Unguarded
  Use Arg db, sqlContext, aggregateObj, userData, val1
  v = .ooSQLValue~double(val1)
  If aggregateObj == .nil Then Do
    acc = .Directory~new
    acc["SUM"] = v
    acc["COUNT"] = 1
    Return acc
  End
  Else Do
    aggregateObj["SUM"] = aggregateObj["SUM"] + v
    aggregateObj["COUNT"] = aggregateObj["COUNT"] + 1
    Return aggregateObj
  End

::Method xFinal Unguarded
  Use Arg db, sqlContext, aggregateObj, userData
  If aggregateObj == .nil Then
    .ooSQLResult~double(sqlContext, 0)
  Else
    .ooSQLResult~double(sqlContext, aggregateObj["SUM"] / aggregateObj["COUNT"])
  Return 0

/******************************************************************************/
/*                                                                            */
/* CollationCaseInsensitiveHandler — case-insensitive collation comparator    */
/*                                                                            */
/* collationCallBack(str1, str2, userData) must return negative, 0, or        */
/* positive. This handler compares strings case-insensitively.                */
/*                                                                            */
/******************************************************************************/

::Class "CollationCaseInsensitiveHandler" Public

::Attribute callCount Get
::Attribute lastUserData Get

::Method init
  Expose callCount lastUserData
  callCount = 0
  lastUserData = .nil

::Method collationCallBack Unguarded
  Expose callCount lastUserData
  Use Strict Arg str1, str2, userData
  callCount += 1
  lastUserData = userData
  Return str1~caselessCompareTo(str2)

::Method reset
  Expose callCount lastUserData
  callCount = 0
  lastUserData = .nil

/******************************************************************************/
/*                                                                            */
/* CollationReverseHandler — reverses normal lexicographic order              */
/*                                                                            */
/* Returns the negated result of compareTo, producing descending sort.        */
/*                                                                            */
/******************************************************************************/

::Class "CollationReverseHandler" Public

::Attribute callCount Get

::Method init
  Expose callCount
  callCount = 0

::Method collationCallBack Unguarded
  Expose callCount
  Use Strict Arg str1, str2, userData
  callCount += 1
  Return -(str1~compareTo(str2))

/******************************************************************************/
/*                                                                            */
/* CollationNeededHandler — dynamically registers collations on demand        */
/*                                                                            */
/* collationNeededCallBack(db, collationName, userData) is invoked when       */
/* SQLite encounters an unknown collation. This handler registers a           */
/* case-insensitive collation with the requested name.                        */
/*                                                                            */
/******************************************************************************/

::Class "CollationNeededHandler" Public

::Attribute callCount Get
::Attribute lastCollationName Get
::Attribute lastUserData Get

::Method init
  Expose callCount lastCollationName lastUserData
  callCount = 0
  lastCollationName = ""
  lastUserData = .nil

::Method collationNeededCallBack Unguarded
  Expose callCount lastCollationName lastUserData
  Use Strict Arg db, collationName, userData
  callCount += 1
  lastCollationName = collationName
  lastUserData = userData
  -- Dynamically register a case-insensitive collation
  ciHandler = .CollationCaseInsensitiveHandler~new
  db~createCollation(collationName, ciHandler)
  Return 0
