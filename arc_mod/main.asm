	.686
	.model flat, stdcall

	includelib import32.lib

	.data

dd ?

	.code

extrn	MessageBoxA:PROC

ExeBase = offset $-1000h

unicode macro string,zero
irpc c,<string>
db '&c',0
endm
ifnb <zero>
dw zero
endif
endm

	include ..\include\include.asm

extrn	_CmdLineArg:PROC
extrn	_mod_select:PROC

_Start PROC
	call	_CmdLineArg
	cmp	eax, 3
	jb	@@1
	mov	edi, offset @@T
	push	8
	pop	ecx
	mov	esi, [esp+8]
	repe	cmpsw
	jne	@@1
	call	_string_num, dword ptr [esp+0Ch]
	call	_tga_alpha_mode
	pop	eax
	pop	ecx
	dec	eax
	pop	ecx
	dec	eax
	push	eax
@@1:	jmp	_mod_select

@@T:	unicode <--alpha>,0
ENDP

	end	_Start