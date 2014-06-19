@echo off
..\bin\cl.exe /nologo /Gzf /Oxs main.c -I../bin/include /link /LIBPATH:../bin/lib /RELEASE /OUT:text_conv.exe
del main.obj
pause
