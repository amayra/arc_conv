@echo off
..\bin\tasm32.exe /jlocals /m9 /ml /q /W-ALN mod_pack.asm
if errorlevel 1 goto 90
..\bin\tasm32.exe /jlocals /m9 /ml /q /W-ALN /t main.asm
..\bin\tlink32 /Tpe /aa /c /x -V4.0 main.obj mod_pack.obj -L..\bin\lib ..\include\include.obj,arc_pack.exe
del main.obj
:90
pause