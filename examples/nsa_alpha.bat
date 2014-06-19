@echo off
for %%i in (*.tga,*.bmp) do arc_conv.exe --mod nsa_alpha "%%i" "%%~ni.tga"
pause