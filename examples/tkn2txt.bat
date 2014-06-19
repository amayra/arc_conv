@echo off
for %%i in (*.tkn) do text_conv.exe tkn2txt "%%i" > "%%~ni.txt"
pause