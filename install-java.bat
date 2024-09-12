echo OFF
REM ------------------------------------------------------------------------------
REM 
REM   Install Azul Zulu Build of OpenJDK
REM   Version: 1.0
REM 
REM   MIT License
REM   Copyright (c) 2024 autumo GmbH
REM 
REM ------------------------------------------------------------------------------


REM 
REM  ROOT path; current directory
REM
set "ROOT=%cd%"


REM
REM Variables
REM
set "AZUL_URL=https://cdn.azul.com/zulu/bin/"
set "DIRECTORY=jvm"
REM Define your Azul Zulu runtime in this configuration file
set "CFG_FILE=java.cfg"
set "ENV_FILE=java.env"
set "DOWNLOAD_LINK=none"
set "ARCHITECTURE=win_x64"
set "JRE_ARCHIVE=none"
set "RUNTIME_DIR=none"
set "OS=none"
FOR /F "tokens=*" %%i in ('type %CFG_FILE%') do SET %%i


cls

echo.
echo ----------------------------------------------------------------
echo.
echo Installing Java
echo.
echo JVM: %ZULU_RUNTIME%
echo.
echo Azul Zulu Builds of OpenJDK Terms:
echo https://www.azul.com/products/core/openjdk-terms-of-use
echo.
echo Azul Platform Core and Azul Zulu Third Party Licenses:
echo https://docs.azul.com/core/tpl
echo.
echo ----------------------------------------------------------------

echo.
:ask
set /P "yn=Do you wish to install this JVM and accept its terms (y/n)? "
if /I "%yn%"=="y" goto install
if /I "%yn%"=="n" (
    echo.
    popd
    exit /B 0
)
echo Please answer with y (yes) or n (no).
goto ask


:install
echo Azul Zulu runtime: '%ZULU_RUNTIME%'
echo Operating system: Windows
echo Architecture: %ARCHITECTURE%

set "RUNTIME_DIR=%ZULU_RUNTIME%-%ARCHITECTURE%"
set "JRE_ARCHIVE=%ZULU_RUNTIME%-%ARCHITECTURE%.zip"
set "DOWNLOAD_LINK=%AZUL_URL%%JRE_ARCHIVE%"

echo.
echo Creating directory '%DIRECTORY%'...
mkdir %DIRECTORY%

echo.
echo Downloading '%DOWNLOAD_LINK%' into directory '%DIRECTORY%'...
cd %DIRECTORY%
curl -O %DOWNLOAD_LINK%

echo.
echo Extracting '%JRE_ARCHIVE%'...
tar -xf %JRE_ARCHIVE%
echo Removing '%JRE_ARCHIVE%'...
del %JRE_ARCHIVE%
cd ..

echo.
echo Adding new JAVA_HOME to environment file '%ENV_FILE%'...
echo JAVA_HOME=%ROOT%\%DIRECTORY%\%RUNTIME_DIR%>>%ENV_FILE%
echo PATH=%ROOT%\%DIRECTORY%\%RUNTIME_DIR%\bin;%%PATH%%>>%ENV_FILE%

echo.
echo Test Java environment:
REM Read this ENV file wherever you want to use the installed Azul Zulu runtime environment!
FOR /F "tokens=*" %%i in ('type %ENV_FILE%') do SET %%i
echo Java Home: '%JAVA_HOME%'.
java --version

echo.
echo Done.
echo.

