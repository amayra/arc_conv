@echo off
for /D %%j in (*) do if exist "%%j\00000.tga" for %%i in ("%%j\*.tga") do (
if not "%%~ni" == "00000" arc_conv.exe --mod compose "%%j\00000.tga" "%%i" "%%i"
)
pause