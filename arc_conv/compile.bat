@echo off
..\bin\tasm32 /jlocals /m9 /ml /q /W-ALN /kh100000 main.asm
if errorlevel 1 goto 90
..\bin\tlink32 /Tpe /aa /c /x -V4.0 main.obj -L..\bin\lib ..\arc_pack\mod_pack.obj ..\arc_mod\arc_mod.obj ..\include\include.obj,arc_conv.exe
del main.obj
:90
pause
