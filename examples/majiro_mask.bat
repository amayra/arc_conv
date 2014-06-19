@echo off
for %%i in (*.tga) do (
arc_conv.exe --mod rctfix "%%i" 0xFF0000
if exist "%%~ni_.tga" (
arc_conv.exe --mod mskn "%%i" "%%~ni_.tga" "%%i"
del /q "%%~ni_.tga"
)
)
pause