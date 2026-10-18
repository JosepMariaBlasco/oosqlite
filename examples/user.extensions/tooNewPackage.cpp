/*----------------------------------------------------------------------------*/
/*                                                                            */
/* Copyright (c) 2026-2026 Rexx Language Association. All rights reserved.    */
/*                                                                            */
/* This program and the accompanying materials are made available under       */
/* the terms of the Common Public License v1.0 which accompanies this         */
/* distribution. A copy is also available at the following address:           */
/* https://www.oorexx.org/license.html                                         */
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
/*----------------------------------------------------------------------------*/


/**
 * tooNewPackage.cpp
 *
 * A testing aid: a package that needs a version of ooSQLite that does not
 * exist yet, 99.0.0.  ooSQLExtensions~loadPackage must refuse to load it, and
 * say why in its lastErrCode and lastErrMsg attributes.
 */

#include "oosqlPackage.hpp"

#ifdef _WIN32
    #include <windows.h>
#endif

#include <string.h>

#define OOSQLITE_99_0_0          0x00630000

BEGIN_EXTERN_C()

void tooNewFunc(sqlite3_context *context, int argc, sqlite3_value **argv)
{
    sqlite3_result_int(context, 99);
}

END_EXTERN_C()

SQLiteFunctionEntry tooNewPackage_functions[] = {
    OOSQL_FUNCTION(tooNew, tooNewFunc, NULL, NULL, NULL, NULL, NULL, 0),
    OOSQL_LAST_FUNCTION()
};

ooSQLitePackageEntry tooNewPackage_package_entry =
{
    OOSQL_STANDARD_PACKAGE_HEADER
    OOSQLITE_99_0_0,              // needs ooSQLite 99.0.0
    SQLITE_VERSION_NUMBER,
    "tooNewPackage",              // name of the package
    "0.0.1",                      // package information
    NULL,                         // no collation needed function
    NULL,                         // no collations
    tooNewPackage_functions,      // the exported functions
    NULL                          // no modules
};

OOSQLITE_GET_PACKAGE(tooNewPackage);
