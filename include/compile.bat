@echo off
..\bin\tasm32.exe /jlocals /m9 /ml /q /W-ALN main.asm
move main.obj include.obj
pause