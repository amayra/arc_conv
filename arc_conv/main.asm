	.686
	.MMX
	.model flat, stdcall

	includelib import32.lib

WM_SETTEXT          = 0Ch
WM_CLOSE            = 10h
WM_TIMER            = 113h

OFN_HIDEREADONLY          =   00000004h
OFN_NOCHANGEDIR           =   00000008h
OFN_PATHMUSTEXIST         =   00000800h
OFN_FILEMUSTEXIST         =   00001000h
OFN_EXPLORER              =   00080000h

@SYS_EXTERN = 0011111b	; dispstr,exit,size,seek,write,read,mem
@SYS_UNICODE = 1

; 65001 CP_UTF8
; 932 Japan
; 936 Chinese (PRC, Singapore)
; 949 Korean

	.code

extrn	MultiByteToWideChar:PROC
extrn	GetSystemTimeAsFileTime:PROC
extrn	CreateDirectoryW:PROC
extrn	GetLastError:PROC
extrn	wvsprintfA:PROC
extrn	ExitProcess:PROC
extrn	GetFileAttributesW:PROC
_ExitProcess = ExitProcess

	.data?

inFileName	dw 240h dup(?)
outDirName	dw 240h dup(?)
outFileNameW	dw 400h+100h dup(?)
outFileNameA	db 400h+100h dup(?)

	.code

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
	include ..\include\Progress.asm

extrn	_mod_pack:PROC
extrn	_mod_select:PROC

_Start PROC
	call	_CmdLineArg
	cmp	eax, 3
	jb	_mod_conv
	mov	edi, offset @@T
	push	8
	pop	ecx
	mov	esi, [esp+8]
	repe	cmpsw
	lea	edi, [edi+ecx*2]
	jne	@@1a
	call	_string_num, dword ptr [esp+0Ch]
	call	_tga_alpha_mode
	pop	eax
	pop	ecx
	dec	eax
	pop	ecx
	dec	eax
	push	eax
	cmp	eax, 3
	jb	_mod_conv
@@1a:	push	7
	pop	ecx
	mov	esi, [esp+8]
	repe	cmpsw
	lea	edi, [edi+ecx*2]
	jne	@@1b
	pop	eax
	pop	ecx
	dec	eax
	push	eax
	jmp	_mod_pack

@@1b:	push	6
	pop	ecx
	mov	esi, [esp+8]
	repe	cmpsw
	jne	_mod_conv
	pop	eax
	pop	ecx
	dec	eax
	push	eax
	jmp	_mod_select

@@T:	unicode <--alpha>,0
	unicode <--pack>,0
	unicode <--mod>,0
ENDP

_mod_conv PROC

@M0 macro p0
@@stk=@@stk+4
p0=dword ptr [ebp-@@stk]
endm
@M1 macro
@@stk = 0
@M0 @@S
@M0 @@D
@M0 @@N
@M0 @@I
@M0 @@B
@M0 @@T
@M0 @@O
@M0 @@L0
@M0 @@L1
@M0 @@L2
@M0 @@L3
@M0 @@L5
@M0 @@U
endm

	@M1
	push	ebp
	mov	ebp, esp
	or	ecx, -1
	xor	edx, edx
	push	ecx	; @@S
	push	ecx	; @@D
	push	ecx	; @@N
	push	edx	; @@I
	push	edx	; @@B
	push	edx	; @@T
	push	edx	; @@O
	push	edx	; @@L0
	push	edx	; @@L1
	push	edx	; @@L2
	push	edx	; @@L3
	push	edx	; @@L5
	push	edx	; @@U
	mov	esi, offset inFileName
	push	esi
	dec	eax
	jle	@@1c
	xchg	ebx, eax
	lea	edx, [ebp+0Ch]
	sub	ebx, 2
	jb	@@1e
@@1d:	mov	edi, [edx]
	call	@@Short
	test	edi, edi
	je	@@9a
	mov	[edx], edi
	add	edx, 8
	sub	ebx, 2
	jae	@@1d
@@1e:	inc	ebx
	jne	@@1c
	mov	ecx, 200h
	mov	edi, esi
	mov	esi, [edx]
	xor	eax, eax
@@1f:	dec	ecx
	je	@@9a
	lodsw
	stosw
	test	eax, eax
	jne	@@1f
@@1c:
	push	ebp
	mov	ebp, esp
	call	_ArcParam
	db 'out', 0
	pop	ebp
	xchg	edi, eax
	mov	esi, offset @@out
	test	edi, edi
	je	@@2d
	push	2-1
	pop	edx
	mov	ebx, edx	; 1
	call	@@3
	je	@@9a
@@2d:	movzx	eax, word ptr [esi-2]
	add	esi, eax
	mov	[@@O], esi
	push	ebp
	mov	ebp, esp
	call	_ArcParamNum, 2
	db 'alpha', 0
	call	_tga_alpha_mode
	call	_ArcParamNum, 1
	db 'conv', 0
	xchg	ebx, eax
	jnc	@@2f
	call	GetFileAttributesW, offset inFileName
	cmp	eax, -1
	je	@@2f
	test	al, 10h
	je	@@2f
	mov	bl, 3
@@2f:	call	_ArcParam
	db 'fmt', 0
	xchg	edi, eax
	pop	ebp
	cmp	ebx, 4
	jae	@@9a
	cmp	ebx, 2
	sbb	eax, eax
	or	eax, edi
	je	@@9a
	mov	[@@L1], ebx
	mov	[@@N], edi
	mov	esi, offset @@fmt
	test	edi, edi
	je	@@2e
	push	ebx
	shr	ebx, 1
	push	0Ch-1
	pop	edx
	inc	ebx
	inc	ebx
	call	@@3
	pop	ebx
	je	@@9a
	mov	eax, [esi-4]
	cmp	ebx, 2
	sbb	edx, edx
	or	dx, [eax+esi-2]
	je	@@9a
@@2e:	mov	[@@L2], esi

	pop	esi
	xor	eax, eax
	cmp	[esi], ax
	jne	@@1a
	xor	ecx, ecx
	sub	esp, 40h
@@1b:	mov	al, [@@strTitle+ecx]
	mov	[esp+ecx*2], ax
	inc	ecx
	test	eax, eax
	jne	@@1b
	mov	ecx, 200h
	mov	edx, esp
	cmp	ebx, 2
	jb	@@1i
	call	_GetOpenDirName, edx, esi, ecx
	jmp	@@1h

@@1i:	push	eax
	push	eax
	push	eax
	push	eax
	push	eax
	push	OFN_HIDEREADONLY OR OFN_FILEMUSTEXIST OR \
		OFN_PATHMUSTEXIST OR OFN_EXPLORER OR OFN_NOCHANGEDIR
	push	edx
	push	eax
	push	eax
	push	eax
	push	ecx	; size
	push	esi	; addr
	push	eax
	push	eax
	push	eax
	push	offset @@strFilt
	push	eax
	push	eax
	push	4Ch
	call	_comdlg32, esp
	db 'GetOpenFileNameW', 0
;	add	esp, 4Ch
@@1h:	lea	esp, [ebp-@@stk]
	test	eax, eax
	je	@@9a
@@1a:	cmp	ebx, 2
	jae	@@1g
	call	_FileCreate, esi, FILE_INPUT+8
	jc	@@9a
	mov	[@@S], eax
@@1g:
	push	ebp
	mov	ebp, esp
	call	_ArcParamNum, 1
	db 'progress', 0
	test	eax, eax
	je	@@2c
	call	_ProgressStart, offset @@strTitle
@@2c:	call	_ArcParamNum, 0
	db 'debug', 0
	pop	ebp
	neg	eax
	adc	byte ptr [@@L1+1], 0

	mov	edi, [@@N]
	mov	esi, [@@L2]
	test	edi, edi
	je	@@2a
	inc	byte ptr [@@L1+2]
	cmp	byte ptr [@@L1], 2
	jb	@@4
	push	esi
	add	esi, [esi-4]
	mov	[@@L2], esi
	mov	esi, offset _arc_dir
	mov	ebx, [@@L1]
	and	ebx, 1
	push	ebx
	jmp	@@4a

@@2a:	lea	ecx, [@@L0]
	call	_FileRead, [@@S], ecx, 4
	jc	@@9
@@2:	xor	eax, eax
	lodsb
	add	esi, eax
	test	eax, eax
	je	@@9
	lodsd
	and	eax, [@@L0]
	cmp	eax, [esi]
	lea	esi, [esi+8]
	jne	@@2
	call	_FileSeek, [@@S], 0, 0
@@4:	push	esi
	add	esi, [esi-4]
	mov	[@@L2], esi
	push	[@@S]
@@4a:	xor	eax, eax
	or	[@@N], -1
	mov	[@@U], 932 SHL 16
	mov	dword ptr [outFileNameA], eax
	mov	dword ptr [outFileNameW], eax
	call	esi
	lea	esp, [ebp-(@@stk+4)]
	call	_ArcLocalFree
	pop	esi
	cmp	byte ptr [@@L1+2], 0
	jne	@@9
	cmp	[@@B], 0
	jne	@@9
	cmp	[@@I], 0
	je	@@2

@@9:	call	_ProgressEnd
@@9c:	mov	eax, [@@D]
	inc	eax
	je	@@9b
	mov	edx, [@@O]
	movsx	ecx, word ptr [edx-4]
	add	ecx, edx
	call	ecx
@@9b:	call	_FileClose, [@@S]
@@9a:	leave
	call	_ExitProcess, 0

@@Short PROC
	cmp	word ptr [edi], 2Dh
	jne	@@9
	movzx	eax, word ptr [edi+2]
	cmp	eax, 2Dh
	je	@@7
	dec	eax
	cmp	eax, 7Fh
	jae	@@9
	inc	eax
	cmp	word ptr [edi+4], 0
	jne	@@9
	push	@@0-@@T
	pop	ecx
	mov	edi, offset @@T
	repne	scasb
	jne	@@9
	add	edi, ecx
	movsx	ecx, word ptr [edi+ecx*2]
	add	edi, ecx
@@7:	ret
@@9:	xor	edi, edi
	ret

@@T:	db 'cof'
@@0:	dw @@20-@@0
	dw @@21-@@0
	dw @@22-@@0
@@20:	unicode <--fmt>,0
@@21:	unicode <--out>,0
@@22:	unicode <--conv>,0
ENDP

@@3:	xor	eax, eax
	lodsb
	test	eax, eax
	je	@@3c
	push	edi
	mov	ecx, eax
@@3a:	lodsb
	scasw
	jne	@@3b
	dec	ecx
	jne	@@3a
	xor	eax, eax
	inc	ecx
	scasw
@@3b:	lea	esi, [esi+ecx]
	lea	esi, [esi+edx]
	pop	edi
	jne	@@3
	inc	eax
	ret

@@3c:	dec	ebx
	jne	@@3
	ret

_ArcSetConv:
	pop	edx
	pop	eax
	push	edx
	push	ebp
	mov	ebp, [ebp]
	mov	[@@L2], eax
	pop	ebp
	ret	4

_ArcMemRead PROC
	@M1
	push	ebp
	mov	ebp, [ebp]
	push	ebx
	mov	ebx, [esp+0Ch]
	mov	eax, [esp+10h]
	add	eax, [esp+14h]
	jc	@@9
	add	eax, [esp+18h]
	jc	@@9
	call	_MemAlloc, eax
	jc	@@9
	xor	edx, edx
	mov	[ebx], eax
	xchg	eax, edx
	mov	ecx, [esp+14h]
	add	edx, [esp+10h]
	test	ecx, ecx
	je	@@8
	push	edx
	call	_FileRead, [@@S], edx, ecx
	pop	edx
@@8:	pop	ebx
	pop	ebp
	ret	10h

@@9:	xor	eax, eax
	cdq
	mov	[ebx], eax
	stc
	jmp	@@8
ENDP

_ArcParam PROC
	call	@@2
	ret

_ArcParamNum:
	call	@@2
	jc	@@3
	call	_string_num, eax
	jnc	@@4
@@3:	mov	eax, [esp+4]
@@4:	ret	4

@@2:	push	ebp
	mov	ebp, [ebp]
	push	ebx
	push	esi
	push	edi
	mov	edi, [esp+14h]
	or	ecx, -1
	xor	eax, eax
	mov	edx, edi
	repne	scasb
	mov	ebx, [ebp+4]
	mov	[esp+14h], edi
	dec	ebx
	js	@@9
	shr	ebx, 1
	je	@@9
@@1:	mov	edi, [ebp+0Ch+ebx*8-8]
	mov	esi, edx
	add	edi, 4
@@1a:	lodsb
	scasw
	jne	@@1b
	test	eax, eax
	jne	@@1a
	mov	eax, [ebp+0Ch+ebx*8-4]
	jmp	@@7
@@1b:	dec	ebx
	jne	@@1
@@9:	xor	eax, eax
@@7:	cmp	eax, 1
	pop	edi
	pop	esi
	pop	ebx
	pop	ebp
	ret
ENDP

_ArcSetCP:
	push	ebp
	mov	ebp, [ebp]
	mov	eax, [esp+8]
	mov	word ptr [@@U+2], ax
	sub	eax, 932	; Japan
	setne	al
	dec	eax
	mov	byte ptr [@@U+1], al
	pop	ebp
	ret	4

_ArcUnicode:
	push	ebp
	mov	ebp, [ebp]
	mov	eax, [esp+8]
	mov	byte ptr [@@U], al
	pop	ebp
	ret	4

_ArcBreak:
	push	ebp
	mov	ebp, [ebp]
	mov	eax, [@@B]
	pop	ebp
	neg	eax
	ret

_ArcCount:
	push	ebp
	mov	ebp, [ebp]
	mov	eax, [esp+8]
	mov	[@@N], eax
	pop	ebp
	ret	4

_ArcGetName PROC
	@M1
	push	ebp
	mov	ebp, [ebp]
	mov	al, byte ptr [@@U]
	pop	ebp
	add	al, -1
	mov	eax, offset outFileNameA
	jnc	@@1
	lea	eax, [eax+outFileNameW-outFileNameA]
@@1:	ret
ENDP

_ArcNameFmt PROC
	call	_ArcGetName
	@M1
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, [ebp]
	mov	ebx, [@@U]
	pop	ebp
	enter	404h, 0
	mov	[ebp-4], eax
	mov	esi, [ebp+10h]
	or	ecx, -1
	mov	edi, esi
	xor	eax, eax
	repne	scasb
	lea	edx, [ebp+18h]
	mov	[ebp+10h], edi
	mov	edi, esp
	call	wvsprintfA, edi, esi, edx
	xchg	ecx, eax
	mov	esi, esp

	mov	edi, [ebp+14h]
	mov	edx, edi
	sub	edx, [ebp-4]
	test	bl, bl
	jne	@@2
	mov	eax, 3FFh
	sub	eax, edx
	jbe	@@9
	cmp	ecx, eax
	jb	$+3
	xchg	ecx, eax
	rep	movsb
	xchg	eax, ecx
	stosb
	jmp	@@9

@@2:	shr	edx, 1
	mov	[ebp-4], edx
	lea	eax, [ecx+ecx+4]
	and	al, -4
	sub	esp, eax
	shr	ebx, 10h
	call	_ansi_to_unicode, ebx, esi, ecx, esp
	xchg	ecx, eax

	mov	edx, [ebp-4]
	mov	eax, 3FFh
	sub	eax, edx
	jbe	@@9
	cmp	ecx, eax
	jb	$+3
	xchg	ecx, eax
	mov	esi, esp
	rep	movsw
	xchg	eax, ecx
	stosw
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP

_ArcGetExt PROC
	call	_ArcGetName
	pop	edx
	push	eax
	push	-1
	push	edx
	jc	@@1a
	jmp	_ansi_ext
@@1a:	jmp	_unicode_ext

@@6:	@M1
	push	eax
	push	ebp
	mov	ebp, [ebp]
	call	_wsprintfA, eax, offset @@fmt, [@@I]
	add	esp, 0Ch
	pop	ebp
	pop	edx
	ret

@@fmt db '$%07i',0

_ArcSetExt:
	call	_ArcGetName
	jc	@@3c
	cmp	byte ptr [eax], 0
	je	@@3a
	call	_ansi_ext, -1, eax
@@3b:	mov	eax, [esp+4]
	push	edi
	mov	edi, edx
	test	al, al
	je	@@3h
	mov	byte ptr [edi], 2Eh
	inc	edi
@@3g:	stosb
	shr	eax, 8
	test	al, al
	jne	@@3g
@@3h:	stosb
	pop	edi
	ret	4

@@3a:	call	@@6
	add	edx, eax
	jmp	@@3b

@@3c:	cmp	word ptr [eax], 0
	je	@@3d
	call	_unicode_ext, -1, eax
@@3f:	mov	eax, [esp+4]
	push	edi
	mov	edi, edx
	test	al, al
	je	@@3j
	mov	word ptr [edi], 2Eh
	inc	edi
	inc	edi
@@3i:	stosb
	mov	byte ptr [edi], 0
	inc	edi
	shr	eax, 8
	test	al, al
	jne	@@3i
@@3j:	stosb
	stosb
	pop	edi
	ret	4

@@3d:	call	@@6
	mov	edi, edx
	lea	edx, [edx+eax*2]
	push	edx
@@3e:	movzx	edx, byte ptr [edi+eax]
	mov	[edi+eax*2], dx
	dec	eax
	jns	@@3e
	pop	edx
	jmp	@@3f
ENDP

_ArcName PROC	; name, cnt
	@M1
	push	ebx
	push	esi
	push	edi
	mov	ebx, offset outFileNameA
	xor	eax, eax
	mov	edi, [esp+10h]
	mov	ecx, [esp+14h]
	mov	[ebx], eax
	test	edi, edi
	je	@@9
	test	ecx, ecx
	je	@@9
	mov	edx, 3FFh
	mov	esi, edi
	push	ebp
	mov	ebp, [ebp]
	cmp	byte ptr [@@U], al
	pop	ebp
	jne	@@2
	repne	scasb
	jne	$+3
	dec	edi
	sub	edi, esi
	cmp	edi, edx
	jb	$+4
	mov	edi, edx
	mov	ecx, edi
	mov	edi, ebx
	rep	movsb
	xchg	ecx, eax
	stosb
	jmp	@@9

@@2:	lea	ebx, [ebx+outFileNameW-outFileNameA]
	repne	scasw
	jne	$+4
	dec	edi
	dec	edi
	sub	edi, esi
	shr	edi, 1
	cmp	edi, edx
	jb	$+4
	mov	edi, edx
	mov	ecx, edi
	mov	edi, ebx
	rep	movsw
	xchg	ecx, eax
	stosw
@@9:	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

_ArcDbgData PROC
	@M1
	push	ebp
	mov	ebp, [ebp]
	test	byte ptr [@@L1+1], 1
	jne	@@4a
	pop	ebp
	xor	eax, eax
	ret	8
@@4a:	bts	[@@L1], 9
	pop	ebp
	call	_ArcData, dword ptr [esp+8], dword ptr [esp+8]
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, [ebp]
	inc	[@@I]
	inc	[@@L5]
	btr	[@@L1], 9
	jmp	@@9a

_ArcSkip:
	pop	eax
	pop	ecx
	push	eax
	push	eax
	push	eax
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, [ebp]
	dec	ecx
	add	[@@I], ecx
	jmp	@@8

_ArcConv:	; buf, size
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, [ebp]
	mov	esi, [esp+14h]
	cmp	esi, 1
	cmc
	sbb	ebx, ebx
	mov	edx, [@@L2]
	and	ebx, [esp+18h]
	cmp	byte ptr [@@L1], 1
	jb	@@3a
	movsx	eax, word ptr [edx-2]
	cmp	eax, 1
	jb	@@3a
	bts	[@@L1], 9
	add	eax, edx
	call	eax, esi, ebx
	sbb	eax, eax
	pop	ecx
	pop	ecx
	mov	edi, [@@L3]
	test	edi, edi
	je	@@3b
	push	eax
	inc	eax
	je	@@3c
	mov	eax, edi
	push	ebp
	mov	ebp, esp
	call	_ArcTgaSaveSys
	pop	ebp
@@3c:	call	_MemFree, edi
	and	[@@L3], 0
	pop	eax
@@3b:	and	al, 2
	btr	[@@L1], 9
	cmp	byte ptr [@@L1], al
@@3a:	jnc	@@8
	pop	ebp
	jmp	@@2

_ArcData:	; buf, size
	push	ebx
	push	esi
	push	edi
@@2:	call	_ArcGetName
	movzx	eax, word ptr [eax]
	jc	@@2a
	mov	ah, 0
@@2a:	test	eax, eax
	jne	@@2b
	call	_ArcSetExt, eax
@@2b:	push	ebp
	mov	ebp, [ebp]
	mov	edx, [@@O]
	mov	al, byte ptr [@@U]
	add	al, -1
	sbb	ebx, ebx
	add	ebx, 2
	and	bl, [edx-5]
	je	@@1b
	mov	esi, offset outFileNameA
	or	ecx, -1
	lea	edi, [esi+outFileNameW-outFileNameA]
	xor	eax, eax
	dec	ebx
	push	edi
	movzx	ebx, word ptr [@@U+2]
	je	@@1c
	mov	edi, esi
	repne	scasb
	pop	edi
	not	ecx
	dec	ecx
	call	_ansi_to_unicode, ebx, esi, ecx, edi
	jmp	@@1b

@@1c:	repne	scasw
	pop	edi
	not	ecx
	dec	ecx
	call	_unicode_to_ansi, ebx, edi, ecx, esi
@@1b:	cmp	[@@B], 0
	jne	@@9
	cmp	[@@D], -1
	jne	@@1a
	pop	ebp
	call	_ArcParam
	db 'dest', 0
	push	ebp
	mov	ebp, [ebp]
	mov	edi, offset inFileName
	sbb	ebx, ebx
	inc	ebx
	je	$+3
	xchg	edi, eax
	xor	eax, eax
	or	ecx, -1
	mov	esi, edi
	repne	scasw
	dec	edi
	dec	edi
	mov	edx, [@@O]
	movsx	ecx, word ptr [edx-2]
	add	ecx, edx
	call	ecx
	cmp	[@@B], 0
	jne	@@9
@@1a:	cmp	dword ptr [esp+14h], 1
	cmc
	sbb	eax, eax
	and	[esp+18h], eax
	call	[@@O]
@@8:	bt	[@@L1], 9
	jc	@@9
	inc	[@@I]
	mov	eax, [@@I]
	sub	eax, [@@L5]
	call	_ProgressUpdate, 1, eax
	call	_ProgressBreak
	or	[@@B], eax
	bts	[@@L1], 10
	jc	@@9a
	push	-2
	mov	eax, [@@N]
	pop	ecx
	test	eax, eax
	jns	@@1d
	mov	eax, offset @@fmt
	xor	ecx, ecx
@@1d:	call	_ProgressUpdate, ecx, eax
@@9a:	xor	eax, eax
	mov	dword ptr [outFileNameA], eax
	mov	dword ptr [outFileNameW], eax
@@9:	pop	ebp
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@fmt	db '%i', 0
ENDP

	dw _out_dir-$-2		; default
@@out:	db 3,'tar'
	dw _out_tar-$-2
	db 4,'utar'
	dw _out_utar-$-2
	db 3,'rar'
	dw _out_rar-$-2
	db 3,'dir'
	dw _out_dir-$-2
	db 0

	include out_tar.asm
	include out_rar.asm
	include out_dir.asm

_StrDec32 PROC		; num, uint, dest
	push	ebx
	push	edi
	mov	edi, [esp+14h]
	mov	eax, [esp+10h]
	mov	ecx, [esp+0Ch]
	test	ecx, ecx
	jg	@@5
	push	edi
	cmp	eax, 10
	jb	@@1a
	mov	ecx, 0CCCCCCCDh
@@1:	mov	ebx, eax
	mul	ecx
	shr	edx, 3
	mov	eax, edx
	lea	edx, [edx*4+edx-18h]
	add	edx, edx
	sub	ebx, edx
	mov	[edi], bl
	inc	edi
	cmp	eax, 10
	jae	@@1
@@1a:	pop	ebx
	add	al, 30h
	stosb
	mov	ecx, [esp+0Ch]
	mov	edx, edi
	neg	ecx
	sub	edx, ebx
	mov	al, 30h
	sub	ecx, edx
	jbe	@@1b
	add	edx, ecx
	rep	stosb
@@1b:	mov	[edi], ah

	mov	ecx, edx
	shr	ecx, 1
	je	@@3
@@2:	dec	edi
	mov	al, [ebx]
	mov	ah, [edi]
	mov	[edi], al
	mov	[ebx], ah
	inc	ebx
	dec	ecx
	jne	@@2
@@3:	xchg	eax, edx
	pop	edi
	pop	ebx
	ret	0Ch

@@5:	mov	edx, 0CCCCCCCDh
	mov	ebx, eax
	mul	edx
	shr	edx, 3
	mov	eax, edx
	lea	edx, [edx*4+edx-18h]
	add	edx, edx
	sub	ebx, edx
	dec	ecx
	mov	[edi+ecx], bl
	jne	@@5
	mov	edx, [esp+0Ch]
	neg	eax
	mov	[edi+edx], cl
	jmp	@@3
ENDP

_ArcInputExt:
	pop	edx
	push	FILE_INPUT
	push	offset inFileName
	push	edx
	jmp	_FileCreateExt

_ArcPngName PROC
	push	ebx
	push	esi
	push	edi
	call	_png_title, dword ptr [esp+14h], dword ptr [esp+14h]
	jc	@@9
	cmp	eax, 400h
	xchg	ecx, eax
	jae	@@9
	push	ebp
	mov	ebp, [ebp]
	push	ebp
	mov	ebp, esp
	lea	eax, [ecx+4]
	and	al, -4
	sub	esp, eax
	mov	edi, esp
	mov	esi, edx
	rep	movsb
	xchg	eax, ecx
	stosb
	call	_ArcGetName
	jc	@@1
	call	_sjis_name, eax
	jmp	@@2
@@1:	call	_unicode_name, eax
@@2:	call	_ArcNameFmt, eax, esp
	db '%s',0
	leave
	pop	ebp
@@9:	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

	include out_tga.asm

PURGE @M0,@M1

@@strFilt:
	unicode <All files (*.*)>,0
	unicode <*.*>,0
	dw 0
@@strTitle db 'arc_conv',0

@M1 macro p1,p2
local @1,@2,@3
db @1-$-0Dh,'&p2'
dd (1 SHL ((@3-@2)*8))-1
@2 db p1
@3:
if (4+@2-@3)
db (4+@2-@3) dup(0)
endif
dd _arc_&p2-@1
@1:
endm

@M2 macro p0,p1,p2
local @1
db @1-$-0Dh,'&p2'
dd p0,p1,_arc_&p2-@1
@1:
endm

@@fmt:	@M1 <'NEKO'>, neko_td2
	@M1 <'NEKO'>, neko_really
	@M1 <'N3Pk'>, n3pk
	@M1 <'LNK',0>, kid_lnk
	@M1 <'nitP'>, nitp
	@M1 <'arc3'>, arc3
	@M1 <'HyPa'>, hypack
	@M1 <'ADPA'>, adpack32
	@M1 <'Data'>, datapack5
	@M1 <'LPK1'>, lpk1
	@M1 <'SM2M'>, sm2mpx10
	@M1 <'vf',66h,0>, vf102
	@M1 <'LB',1,0>, liar
	@M1 <'LG',1,0>, liar
	@M1 <'XP3',0Dh>, xp3
	@M1 <'MZ'>, xp3
	@M1 <'NPA',1>, npa1
	@M1 <'PBG3'>, pbg3
	@M1 <'PBG4'>, pbg4
	@M1 <'PBGZ'>, pbgz
	@M1 <'RPA-'>, rpa3
	@M1 <'FA2',0>, fa2
	@M1 <'WARC'>, warc
	@M1 <'Repi'>, repipack
	@M1 <'Mast'>, ragnarok
	@M1 <'GCEX'>, gcex
	@M1 <'ARC!'>, mma
	@M1 <'arc2'>, arc2
	@M1 <'ARCX'>, arcx
	@M1 <'ARCG'>, arcg
	@M1 <'WSM4'>, wsm4
	@M1 <'yane'>, yanepk
	@M1 <'YPF',0>, ypf
	@M1 <'PAK0'>, egopak
	@M1 <'pack'>, erogos
	@M1 <'Pack'>, bgi
	@M1 <'Pack'>, pd_cc
	@M1 <'Pack'>, pd_sml
	@M1 <'PACK'>, klein
	@M1 <'PACK'>, moero
	@M1 <'PACK'>, noesis
	@M1 <'PAC'>, pac4
	@M1 <'IPAC'>, ipac
	@M1 <5,'PAC'>, sysadv
	@M1 <'LIB'>, malie
	@M1 <'CLS_'>, cls_dat
	@M1 <'GAME'>, gamedat
	@M1 <'ACSF'>, acsf
	@M1 <'AFS',0>, afs
	@M1 <'GPDA'>, gpda
	@M1 <'RESC'>, resc311
	@M1 <'PCRS'>, pcrs
	@M1 <'ARC',0>, mw2
	@M1 <'MDFI'>, mdfile
	@M1 <'MD00'>, md002
	@M1 <'Miko'>, mikostg
	@M1 <'VAFS'>, vafsh
	@M1 <'AOIB'>, aoibx
	@M1 <'A',0,'O',0>, aoimy
	@M1 <'VF',1,1>, vfs
	@M1 <'VF',0,2>, vfs
	@M1 <'FJSY'>, fjsys
	@M1 <'Maji'>, majiro
	@M1 <'SGS.'>, sgs1
	@M1 <'TPF '>, tpf
	@M1 <'GML_'>, gml
	@M1 <10h,33h,0D3h,47h>, glib2
	@M1 <'XARC'>, xarc2
	@M1 <'MIKO'>, xarc2
	@M1 <'XARC'>, xarc1
	@M1 <'GAF4'>, gaf4
	@M1 <'WAG@'>, gaf4
	@M1 <'KOTO'>, kotori
	@M1 <'IPF '>, gael
	@M1 <'GPK2'>, gpk2
	@M1 <'S3IC'>, eushully
	@M1 <'S4IC'>, eushully
	@M1 <'S4AC'>, eushully
	@M1 <'TCD2'>, tcd2
	@M1 <'TCD3'>, tcd3
	@M1 <'MPF2'>, mpf2
	@M1 <'KIF',0>, kif
	@M1 <'XFIR'>, xfir
	@M1 <'ESC-'>, escude
	@M1 <'ACPX'>, escude_acpx
	@M1 <'Enti'>, entis
	@M1 <'am00'>, leaf_am
	@M1 <'SHS'>, ddp
	@M1 <'DDP'>, ddp
	@M1 <'Nimr'>, nimrod
	@M1 <'tskf'>, taskforce
	@M1 <'PKFi'>, mbac
	@M1 <'ARC',1Ah>, azsys
	@M1 <'GLNK'>, glnk
	@M1 <'CHER'>, cherry
	@M1 <'FPK',0>, fpk0100
	@M1 <'MAI',0Ah>, mai
	@M1 <'K5',1,0>, k5
	@M1 <'RGSS'>, rgssad
	@M1 <'IGA0'>, iga0
	@M1 <'GXP',0>, gxp
	@M1 <'MRG',0>, overture
	@M1 <28h,20h,0A0h,24h>, agsi
	@M1 <'mrg0'>, mrg0
	@M1 <'vav',0>, vav
	@M1 <'WFL1'>, wfl1
	@M1 <'RFIL'>, hanamar
	@M1 <'BSAr'>, bsarc
	@M1 <'NSCF'>, nscf
	@M1 <'CPZ5'>, cpz5
	@M1 <'TGP0'>, tgp0
	@M1 <'YPAC'>, tgp0
	@M1 <'ISM '>, ism
	@M1 <0C9h,0C3h,0C6h,0D4h>, mgbpack
	@M1 <'YKC0'>, ykc
	@M1 <'AFAH'>, afa
	@M1 <'SLK',0>, alice_slk
	@M1 <'AAR',0>, alice_red
	@M1 <'HAPI'>, hapi
	@M1 <81h,8Bh,0B4h,0D9h>, deathspank
	@M1 <'OAF!'>, ds3_oaf
	@M1 <82h,75h,82h,62h>, vc_pak
	@M1 <0E9h,0D7h,0,40h>, asgaldh
	@M1 <28h,20h,0A0h,24h>, agsi
	@M1 <28h,20h,0A0h,24h>, agsi
	@M1 <2,0,0,0>, nitro2
	@M1 <3,0,0,0>, nitro_pak
	@M1 <4,0,0,0>, nitro_pak
	@M2 0FFFFh,0AF1Eh, leaf
	@M2 0FCFFFFFFh,'0CRA', arc12
	@M2 -1,0AD5CEAFCh, n3pk_enc
	@M2 0,0, dx3
	@M2 0,0, qlie
	@M2 0,0, ald
	@M2 0,0, vivid
	@M2 0,0, foris
	@M2 0,0, auto
	db 0
	; unsafe
	@M2 0,0, fbread
	@M2 0,0, ikura
	@M2 0,0, mbl		; auto
	@M2 0,0, th075
	@M2 0,0, th125
	@M2 0,0, tasofro
	@M2 0,0, crossnet
	@M2 0,0, minori
	@M2 0,0, will
	@M2 0,0, oozora
	@M2 0,0, twinkle
	@M1 <1,0,0,0>, guren
	@M2 0,0, ipf
	@M2 0,0, ego
	@M2 0,0, ciel
	@M2 0,0, softpal_ap
	@M2 0,0, softpal_fh
	@M2 0,0, softpal_fch
	@M2 0,0, aiw_arc
	@M2 0,0, ai5
	@M1 <'MP'>, mp_mika
	@M1 <0,0,0,0>, aos	; auto
	@M2 0,0, nsa		; auto
	@M2 0,0, mink		; auto
	@M2 0,0, mink_dat
	@M2 0,0, tink
	@M2 0,0, revive
	@M2 0,0, karte
	@M2 0,0, mpk
	@M2 0,0, illusion	; auto
	@M2 0,0, ai6
	@M2 0,0, npa_sg
	@M2 0,0, vjed
	@M2 0,0, body
	@M2 0,0, vc_pac
	@M2 0,0, cycsoft	; auto
	@M2 0,0, eac
	@M2 0,0, ail
	@M2 0,0, pmref
	@M2 0,0, pm2lbx
	@M2 0,0, route2
	@M2 0,0, mrg
	@M1 <'LAC',0>, leaf_setup
	@M1 <'LAC',0>, leaf_lac
	@M1 <'KCAP'>, leaf_pak1
	@M1 <'KCAP'>, leaf_pak2
	@M1 <'KCAP'>, lwrq_ps2
	@M2 0,0, rk1
	@M2 0,0, eagls
	@M2 0,0, ai5_dk4
	@M2 0,0, ai5_kakyu2
	@M2 0,0, limejan
	@M2 0,0, avking
	@M1 <'K3'>, k3		; auto
	@M2 0,0, system3
	@M2 0,0, system1
	@M2 0,0, advtry
	@M1 <0,0,0,0>, kif_zt	; auto
	@M1 <'PACK'>, hdoc
	@M2 0,0, twelve
	@M2 0,0, lcse
	@M2 0,0, bod2
	@M1 <'BOD3'>, bod3
	@M2 0,0, rlseen		; auto
	@M2 0,0, nfs
	@M2 0,0, hanafuda
	@M2 0,0, starplatinum
	@M2 0,0, libi
	@M2 0,0, debonosu
	@M2 0,0, asc3
	@M2 0,0, yumemisou
	@M2 0,0, grgr
	@M2 0,0, gsp		; auto
	db 0
	; conv
	@M2 0,0, copy
	@M2 0,0, zbm
	@M2 0,0, pdt
	@M2 0,0, g00
	@M2 0,0, eenc
	@M2 0,0, crx
	@M2 0,0, gbix
	@M2 0,0, isf
	@M2 0,0, gyu
	@M2 0,0, pmp
	@M2 0,0, pm2win
	@M2 0,0, syg
	@M2 0,0, c4
	db 0
PURGE @M1,@M2
ENDP

@M0 macro p0,p1
ifb <p1>
@@stk=@@stk+4
else
@@stk=@@stk+p1
endif
p0=dword ptr [ebp-@@stk]
endm

	include arc_dir.asm
	include arc_auto.asm
	include arc_neko_td2.asm
	include arc_neko_really.asm
	include arc_n3pk.asm
	include arc_kid_lnk.asm
	include arc_nitp.asm
	include arc_arc3.asm
	include arc_hypack.asm
	include arc_adpack32.asm
	include arc_datapack5.asm
	include arc_lpk1.asm
	include arc_sm2mpx10.asm
	include arc_vf102.asm
	include arc_liar.asm
	include arc_xp3.asm
	include arc_npa1.asm
	include arc_pbg3.asm
	include arc_pbg4.asm
	include arc_pbgz.asm
	include arc_rpa3.asm
	include arc_fa2.asm
	include arc_warc.asm
	include arc_repipack.asm
	include mod_repipack2.asm
	include mod_repipack4.asm
	include mod_repipack5.asm
	include arc_ragnarok.asm
	include arc_gcex.asm
	include arc_mma.asm
	include arc_arc2.asm
	include arc_arcx.asm
	include arc_arcg.asm
	include arc_yanepk.asm
	include arc_ypf.asm
	include arc_egopak.asm
	include arc_erogos.asm
	include arc_bgi.asm
	include arc_pd.asm
	include arc_klein.asm
	include arc_moero.asm
	include arc_noesis.asm
	include arc_pac4.asm
	include arc_ipac.asm
	include arc_sysadv.asm
	include arc_malie.asm
	include arc_cls_dat.asm
	include arc_gamedat.asm
	include arc_acsf.asm
	include arc_afs.asm
	include arc_gpda.asm
	include arc_resc311.asm
	include arc_pcrs.asm
	include arc_mw2.asm
	include arc_mdfile.asm
	include arc_md002.asm
	include arc_mikostg.asm
	include arc_vafsh.asm
	include arc_vfs.asm
	include arc_fjsys.asm
	include arc_majiro.asm
	include arc_sgs1.asm
	include arc_tpf.asm
	include arc_glib2.asm
	include arc_gml.asm
	include arc_xarc2.asm
	include arc_xarc1.asm
	include arc_gaf4.asm
	include arc_kotori.asm
	include arc_gael.asm
	include arc_gpk2.asm
	include arc_eushully.asm
	include arc_tcd2.asm
	include arc_tcd3.asm
	include arc_mpf2.asm
	include arc_kif.asm
	include arc_xfir.asm
	include arc_escude.asm
	include arc_entis.asm
	include arc_leaf_am.asm
	include arc_ddp.asm
	include arc_nimrod.asm
	include arc_taskforce.asm
	include arc_azsys.asm
	include arc_glnk.asm
	include arc_cherry.asm
	include arc_fpk0100.asm
	include arc_mai.asm
	include arc_k5.asm
	include arc_rgssad.asm
	include arc_iga0.asm
	include arc_gxp.asm
	include arc_overture.asm
	include arc_agsi.asm
	include arc_mrg0.asm
	include arc_vav.asm
	include arc_wfl1.asm
	include arc_hanamar.asm
	include arc_bsarc.asm
	include arc_nscf.asm
	include arc_cpz5.asm
	include arc_tgp0.asm
	include arc_ism.asm
	include arc_mgbpack.asm
	include arc_ykc.asm
	include arc_hapi.asm
	include arc_deathspank.asm
	include arc_ds3_oaf.asm
	include arc_vc_pak.asm
	include arc_nitro2.asm
	include arc_nitro_pak.asm
	include arc_fbread.asm
	include arc_leaf.asm
	include arc_arc12.asm
	include arc_n3pk_enc.asm
	include arc_illusion.asm
	include arc_dx3.asm
	include arc_qlie.asm
	include arc_system3.asm
	include arc_afa.asm
	include arc_ald.asm
	include arc_vivid.asm
	include arc_foris.asm

	include arc_ikura.asm
	include arc_mbl.asm
	include arc_th075.asm
	include arc_th125.asm
	include arc_tasofro.asm
	include arc_crossnet.asm
	include arc_minori.asm
	include arc_will.asm
	include arc_oozora.asm
	include arc_twinkle.asm
	include arc_guren.asm
	include arc_ipf.asm
	include arc_ego.asm
	include arc_ciel.asm
	include arc_softpal_ap.asm
	include arc_softpal_fh.asm
	include arc_aiw_arc.asm
	include arc_ai5.asm
	include arc_mp_mika.asm
	include arc_aos.asm
	include arc_nsa.asm
	include arc_mink.asm
	include arc_mink_dat.asm
	include arc_tink.asm
	include arc_revive.asm
	include arc_karte.asm
	include arc_mpk.asm
	include arc_ai6.asm
	include arc_npa_sg.asm
	include arc_vjed.asm
	include arc_body.asm
	include arc_vc_pac.asm
	include arc_cycsoft.asm
	include arc_eac.asm
	include arc_ail.asm
	include arc_pmref.asm
	include arc_pm2lbx.asm
	include arc_route2.asm
	include arc_mrg.asm
	include arc_leaf_lac.asm
	include arc_leaf_pak.asm
	include arc_lwrq_ps2.asm
	include arc_rk1.asm
	include arc_eagls.asm
	include arc_ai5_dk4.asm
	include arc_limejan.asm
	include arc_avking.asm
	include arc_advtry.asm
	include arc_hdoc.asm
	include arc_twelve.asm
	include arc_lcse.asm
	include arc_bod2.asm
	include arc_bod3.asm
	include arc_rlseen.asm
	include arc_nfs.asm
	include arc_starplatinum.asm
	include arc_libi.asm
	include arc_debonosu.asm
	include arc_yumemisou.asm
	include arc_grgr.asm
	include arc_gsp.asm
	include arc_systemc.asm
	include arc_rpd.asm

	include conv_zbm.asm
	include conv_pdt.asm
	include conv_g00.asm
	include conv_eenc.asm
	include conv_crx.asm
	include conv_isf.asm
	include conv_gyu.asm
	include conv_pmp.asm
	include conv_pm2win.asm
	include conv_syg.asm
	include conv_c4.asm

	end	_Start
