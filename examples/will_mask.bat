@echo off
for %%i in (*.tga) do if exist "%%~ni_msk.tga" (
arc_conv.exe --mod mask "%%i" "%%~ni_msk.tga" "%%i"
del /q "%%~ni_msk.tga"
)
for /D %%j in (*) do if exist "%%j_msk" (
for %%i in ("%%j\*.tga") do (
arc_conv.exe --mod mask "%%i" "%%j_msk\%%~nxi" "%%i"
del /q "%%j_msk\%%~nxi"
)
rmdir "%%j_msk"
)
pause