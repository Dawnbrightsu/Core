@ECHO OFF

REM ----------------------------------------------------------------------
REM PHP version 5
REM ----------------------------------------------------------------------
REM Copyright (c) 1997-2004 The PHP Group
REM ----------------------------------------------------------------------
REM  This source file is subject to version 3.0 of the PHP license, 
REM  that is bundled with this package in the file LICENSE, and is
REM  available at through the world-wide-web at
REM  http://www.php.net/license/3_0.txt. 
REM  If you did not receive a copy of the PHP license and are unable to
REM  obtain it through the world-wide-web, please send a note to
REM  license@php.net so we can mail you a copy immediately.
REM ----------------------------------------------------------------------
REM  Authors:     Alexander Merz (alexmerz@php.net)
REM ----------------------------------------------------------------------
REM
REM  Last updated 12/29/2004 ($Id$ is not replaced if the file is binary)

REM change this lines to match the paths of your system
REM -------------------


REM Test to see if this is a raw pear.bat (uninstalled version)
SET TMPTMPTMPTMPT=@includ
SET PMTPMTPMT=%TMPTMPTMPTMPT%e_path@
FOR %%x IN ("\AC Web Ultimate Repack\Server\php\pear") DO (if %%x=="%PMTPMTPMT%" GOTO :NOTINSTALLED)

:: Check PEAR global ENV, set them if they do not exist
IF "%PHP_PEAR_INSTALL_DIR%"=="" SET "PHP_PEAR_INSTALL_DIR=\AC Web Ultimate Repack\Server\php\pear"
IF "%PHP_PEAR_BIN_DIR%"=="" SET "PHP_PEAR_BIN_DIR=\AC Web Ultimate Repack\Server\php"
IF "%PHP_PEAR_PHP_BIN%"=="" SET "PHP_PEAR_PHP_BIN=%PHP_PEAR_BIN_DIR%\php.exe"
IF "%PHP_PEAR_SYSCONF_DIR%"=="" SET "PHP_PEAR_SYSCONF_DIR=%PHP_PEAR_BIN_DIR%"
IF "%PHP_PEAR_EXTENSION_DIR%"=="" SET "PHP_PEAR_EXTENSION_DIR=%PHP_PEAR_BIN_DIR%\ext"
IF "%PHP_PEAR_DOC_DIR%"=="" SET "PHP_PEAR_DOC_DIR=%PHP_PEAR_INSTALL_DIR%\docs"
IF "%PHP_PEAR_DATA_DIR%"=="" SET "PHP_PEAR_DATA_DIR=%PHP_PEAR_INSTALL_DIR%\data"
IF "%PHP_PEAR_TEST_DIR%"=="" SET "PHP_PEAR_TEST_DIR=%PHP_PEAR_INSTALL_DIR%\tests"
IF "%PHP_PEAR_CACHE_DIR%"=="" SET "PHP_PEAR_CACHE_DIR=\AC Web Ultimate Repack\Server\tmp"
GOTO :INSTALLED

:NOTINSTALLED
ECHO WARNING: This is a raw, uninstalled pear.bat

REM Check to see if we can grab the directory of this file (Windows NT+)
IF %~n0 == pear (
FOR %%x IN (cli\php.exe php.exe) DO (if "%%~$PATH:x" NEQ "" (
SET "PHP_PEAR_PHP_BIN=%%~$PATH:x"
echo Using PHP Executable "%PHP_PEAR_PHP_BIN%"
"%PHP_PEAR_PHP_BIN%" -v
GOTO :NEXTTEST
))
GOTO :FAILAUTODETECT
:NEXTTEST
IF "%PHP_PEAR_PHP_BIN%" NEQ "" (

REM We can use this PHP to run a temporary php file to get the dirname of pear

echo ^<?php $s=getcwd^(^);chdir^($a=dirname^(__FILE__^).'\\'^);if^(stristr^($a,'\\scripts'^)^)$a=dirname^(dirname^($a^)^).'\\';$f=fopen^($s.'\\~a.a','wb'^);echo$s.'\\~a.a';fwrite^($f,$a^);fclose^($f^);chdir^($s^);?^> > ~~getloc.php
"%PHP_PEAR_PHP_BIN%" ~~getloc.php
set /p PHP_PEAR_BIN_DIR=fakeprompt < ~a.a
DEL ~a.a
DEL ~~getloc.php
set "PHP_PEAR_INSTALL_DIR=%PHP_PEAR_BIN_DIR%pear"

REM Make sure there is a pearcmd.php at our disposal

IF NOT EXIST %PHP_PEAR_INSTALL_DIR%\pearcmd.php (
IF EXIST %PHP_PEAR_INSTALL_DIR%\scripts\pearcmd.php COPY %PHP_PEAR_INSTALL_DIR%\scripts\pearcmd.php %PHP_PEAR_INSTALL_DIR%\pearcmd.php
IF EXIST pearcmd.php COPY pearcmd.php %PHP_PEAR_INSTALL_DIR%\pearcmd.php
IF EXIST %~dp0\scripts\pearcmd.php COPY %~dp0\scripts\pearcmd.php %PHP_PEAR_INSTALL_DIR%\pearcmd.php
)
)
GOTO :INSTALLED
) ELSE (
REM Windows Me/98 cannot succeed, so allow the batch to fail
)
:FAILAUTODETECT
echo WARNING: failed to auto-detect pear information
:INSTALLED

REM Check Folders and files
IF NOT EXIST "%PHP_PEAR_INSTALL_DIR%" GOTO PEAR_INSTALL_ERROR
IF NOT EXIST "%PHP_PEAR_INSTALL_DIR%\pearcmd.php" GOTO PEAR_INSTALL_ERROR2
IF NOT EXIST "%PHP_PEAR_BIN_DIR%" GOTO PEAR_BIN_ERROR
IF NOT EXIST "%PHP_PEAR_PHP_BIN%" GOTO PEAR_PHPBIN_ERROR
ATTRIB +R %PHP_PEAR_BIN_DIR%\pear.bat >nul
ATTRIB +R %PHP_PEAR_BIN_DIR%\peardev.bat >nul
ATTRIB +R %PHP_PEAR_BIN_DIR%\pecl.bat >nul
ATTRIB +R %PHP_PEAR_BIN_DIR%\phpdoc.bat >nul
ATTRIB +R %PHP_PEAR_BIN_DIR%\phpunit.bat >nul
ATTRIB -H %PHP_PEAR_INSTALL_DIR%\.depdb >nul
ATTRIB -H %PHP_PEAR_INSTALL_DIR%\.depdblock >nul
ATTRIB -H %PHP_PEAR_INSTALL_DIR%\.filemap >nul
ATTRIB -H %PHP_PEAR_INSTALL_DIR%\.lock >nul
REM launch pearcmd
GOTO RUN
:PEAR_INSTALL_ERROR
ECHO PHP_PEAR_INSTALL_DIR is not set correctly.
ECHO Please fix it using your environment variable or modify
ECHO the default value in pear.bat
ECHO The current value is:
ECHO %PHP_PEAR_INSTALL_DIR%
GOTO END
:PEAR_INSTALL_ERROR2
ECHO PHP_PEAR_INSTALL_DIR is not set correctly.
ECHO pearcmd.php could not be found there.
ECHO Please fix it using your environment variable or modify
ECHO the default value in pear.bat
ECHO The current value is:
ECHO %PHP_PEAR_INSTALL_DIR%
GOTO END
:PEAR_BIN_ERROR
ECHO PHP_PEAR_BIN_DIR is not set correctly.
ECHO Please fix it using your environment variable or modify
ECHO the default value in pear.bat
ECHO The current value is:
ECHO %PHP_PEAR_BIN_DIR%
GOTO END
:PEAR_PHPBIN_ERROR
ECHO PHP_PEAR_PHP_BIN is not set correctly.
ECHO Please fix it using your environment variable or modify
ECHO the default value in pear.bat
ECHO The current value is:
ECHO %PHP_PEAR_PHP_BIN%
GOTO END
:RUN
"%PHP_PEAR_PHP_BIN%" -C -d output_buffering=1 -f "%PHP_PEAR_INSTALL_DIR%\pearcmd.php" -- %1 %2 %3 %4 %5 %6 %7 %8 %9
:END
ATTRIB -R %PHP_PEAR_BIN_DIR%\pear.bat >nul
ATTRIB -R %PHP_PEAR_BIN_DIR%\peardev.bat >nul
ATTRIB -R %PHP_PEAR_BIN_DIR%\pecl.bat >nul
ATTRIB -R %PHP_PEAR_BIN_DIR%\phpdoc.bat >nul
ATTRIB -R %PHP_PEAR_BIN_DIR%\phpunit.bat >nul
@ECHO ON
