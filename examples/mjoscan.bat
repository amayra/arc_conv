@echo off
if exist majiro_key.txt del /q majiro_key.txt
for %%i in (*.mjo,*.arc) do (
arc_conv.exe --mod mjoscan "%%i" majiro_key.txt
if not errorlevel 1 echo # %%i >> majiro_key.txt
)
pause