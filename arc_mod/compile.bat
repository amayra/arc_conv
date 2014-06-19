@echo off
..\bin\tasm32 /jlocals /m9 /ml /q /W-ALN arc_mod.asm
if errorlevel 1 goto 90
..\bin\tasm32 /jlocals /m9 /ml /q /W-ALN /t main.asm
..\bin\tlink32 /Tpe /aa /c /x -V4.0 main.obj arc_mod.obj -L..\bin\lib ..\include\include.obj,arc_mod.exe
del main.obj
:90
pause