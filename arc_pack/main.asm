	.686
	.model flat, stdcall

	includelib import32.lib

	.data

dd ?

	.code

extrn	_CmdLineArg:PROC
extrn	_mod_pack:PROC

_Start PROC
	call	_CmdLineArg
	jmp	_mod_pack
ENDP

	end	_Start