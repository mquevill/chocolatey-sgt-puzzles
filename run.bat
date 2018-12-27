@echo off

set /p VERS=Have you updated the .nuspec version number (y/[n])?
if /i "%VERS%" neq "y" goto END

cd tools
for /f %%i in ('dir *.msi /b/a-d/od/t:c') do set MSI=%%i
checksum -t=sha512 %MSI%
cd ..

set /p PACK=Have you updated tools/chocolateyinstall.ps1 with the URL and the above checksum (y/[n])?
if /i "%PACK%" neq "y" goto END

cpack sgt-puzzles.nuspec
for /f %%i in ('dir *.nupkg /b/a-d/od/t:c') do set PKG=%%i

set /p PUSH=Are you ready to push (y/[n])?
if /i "%PUSH%" neq "y" goto END

cpush %PKG%

:END
