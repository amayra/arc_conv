	.686
	.MMX
	.model flat, stdcall
	.code

@SYS_EXTERN = 0011111b	; dispstr,exit,size,seek,write,read,mem
@SYS_UNICODE = 1

	.code

	include SysGeneric.asm
public _CmdLineArg
	include CmdLineArg.asm
public _BlkAlloc
public _BlkCreate
public _BlkDestroy
	include BlkAlloc.asm
public _FindFile
	include FindFile.asm
public _GetOpenDirName
	include GetOpenDirName.asm
public _CheckPeHdr
	include CheckPeHdr.asm
public _RVAToFile
	include RVAToFile.asm

public _comdlg32
_comdlg32 PROC
	push	ebx
	push	esi
	push	edi
	mov	edi, [esp+0Ch]
	or	ecx, -1
	xor	eax, eax
	mov	esi, edi
	repne	scasb
	mov	[esp+0Ch], edi
	call	@@1
	db 'COMDLG32.DLL', 0
@@1:	call	LoadLibraryA
	test	eax, eax
	je	@@9
	xchg	ebx, eax
	call	GetProcAddress, ebx, esi
	test	eax, eax
	je	@@8
	call	eax, dword ptr [esp+10h]
@@8:	xchg	esi, eax
	call	FreeLibrary, ebx
	xchg	esi, eax
@@9:	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP

public _FileSeek64
extrn	GetLastError:PROC
extrn	SetFilePointer:PROC
_FileSeek64 PROC	; handle, low, high, flags
	push	dword ptr [esp+0Ch]
	mov	ecx, esp
	call	SetFilePointer, dword ptr [ecx+8], \
		dword ptr [ecx+0Ch], ecx, dword ptr [ecx+14h]
	mov	ecx, esp
	push	eax
	inc	eax
	je	@@3
	cmp	dword ptr [ecx+14h], 0
	jne	@@2	; cf=0
	dec	eax
	mov	edx, [ecx]
	sub	eax, [ecx+0Ch]
	sub	edx, [ecx+10h]
	or	eax, edx
@@1:	neg	eax
@@2:	pop	eax
	pop	edx
	ret	10h

@@3:	call	GetLastError
	jmp	@@1
ENDP

public _FileTimeToDosDateTime
extrn	FileTimeToSystemTime:PROC
_FileTimeToDosDateTime PROC
	sub	esp, 10h
	mov	ecx, esp
	call	FileTimeToSystemTime, dword ptr [ecx+14h], ecx
	mov	ecx, esp
	mov	eax, [ecx]
	mov	edx, [ecx+0Ch]
	add	al, 44h
	shr	edx, 1
	shl	eax, 4
	add	al, [ecx+2]
	shl	eax, 5
	or	al, [ecx+6]	; Day
	shl	eax, 5
	or	al, [ecx+8]	; Hour
	shl	eax, 6
	or	al, [ecx+0Ah]	; Minute
	shl	eax, 5
	add	esp, 10h
	add	al, dl
	mov	edx, [ecx+1Ch]
	mov	ecx, [ecx+18h]
	mov	[edx], ax
	shr	eax, 10h
	mov	[ecx], ax
	ret	0Ch
ENDP

public _unicode_to_ansi
extrn	WideCharToMultiByte:PROC
_unicode_to_ansi PROC	; codepage, src, num, dest
	mov	edx, esp
	push	ebx
	push	esi
	push	edi
	mov	esi, [edx+8]
	mov	ebx, [edx+0Ch]
	mov	edi, [edx+10h]
	xor	eax, eax
	test	ebx, ebx
	je	@@9
@@1:	lodsw
	test	ah, ah
	jne	@@2
	stosb
	dec	ebx
	jne	@@1
@@9:	mov	byte ptr [edi], 0
	xchg	eax, edi
	sub	eax, [esp+1Ch]
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@2:	dec	esi
	dec	esi
	mov	ecx, edi
	sub	ecx, [edx+10h]
	lea	ecx, [ecx+ebx*2]
	call	WideCharToMultiByte, dword ptr [edx+4], 0, esi, ebx, edi, ecx, 0, 0
	add	edi, eax
	jmp	@@9
ENDP

public _ansi_to_unicode
extrn	MultiByteToWideChar:PROC
_ansi_to_unicode PROC
	mov	edx, esp
	push	ebx
	push	esi
	push	edi
	mov	esi, [edx+8]
	mov	ebx, [edx+0Ch]
	mov	edi, [edx+10h]
	xor	eax, eax
	test	ebx, ebx
	je	@@9
@@1:	lodsb
	test	al, al
	js	@@2
	stosw
	dec	ebx
	jne	@@1
@@9:	and	word ptr [edi], 0
	xchg	eax, edi
	sub	eax, [esp+1Ch]
	shr	eax, 1
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@2:	dec	esi
	call	MultiByteToWideChar, dword ptr [edx+4], 0, esi, ebx, edi, ebx
	lea	edi, [edi+eax*2]
	jmp	@@9
ENDP

public _string_num
_string_num PROC
	push	esi
	mov	esi, [esp+8]
	xor	edx, edx
	xor	eax, eax
	lodsw
	cmp	eax, '-'
	jne	@@1d
	lodsw
@@1d:	sub	eax, 30h
	jne	@@2c
	lodsw
	cmp	eax, 'x'
	je	@@1c
	cmp	eax, 'X'
	jne	@@2d
@@1c:	lodsw
	test	eax, eax
	je	@@9
@@1a:	sub	eax, 30h
	cmp	eax, 0Ah
	jb	@@1b
	or	eax, 20h
	sub	eax, 31h
	cmp	eax, 6
	jae	@@9
	add	eax, 0Ah
@@1b:	rol	edx, 4
	test	dl, 0Fh
	jne	@@9
	add	dl, al
	lodsw
	test	eax, eax
	jne	@@1a
@@8:	mov	esi, [esp+8]
	xchg	eax, edx
	cmp	byte ptr [esi], '-'
	jne	@@8a
	dec	eax
	js	@@9
	not	eax
@@8a:	clc
	pop	esi
	ret	4

@@2c:	cmp	eax, 0Ah
	jb	@@2b
@@9:	stc
	pop	esi
	ret	4

@@2a:	cmp	edx, 1999999Ah
	lea	edx, [edx*4+edx]
	lea	edx, [edx*2+eax]
	jae	@@9
	cmp	edx, eax
	jb	@@9
	lodsw
@@2d:	sub	eax, 30h
@@2b:	cmp	eax, 0Ah
	jb	@@2a
	cmp	eax, -30h
	je	@@8
	jmp	@@9
ENDP

public _string_num64
_string_num64 PROC
	push	esi
	mov	esi, [esp+8]
	xor	eax, eax
	cdq
	lodsw
	cmp	eax, '-'
	jne	@@1d
	lodsw
@@1d:	push	ebx
	xor	ebx, ebx
	sub	eax, 30h
	jne	@@2c
	lodsw
	cmp	eax, 'x'
	je	@@1c
	cmp	eax, 'X'
	jne	@@2d
@@1c:	lodsw
	test	eax, eax
	je	@@9
@@1a:	sub	eax, 30h
	cmp	eax, 0Ah
	jb	@@1b
	or	eax, 20h
	sub	eax, 31h
	cmp	eax, 6
	jae	@@9
	add	eax, 0Ah
@@1b:	test	ebx, 0F0000000h
	jne	@@9
	shld	ebx, edx, 4
	shl	edx, 4
	add	dl, al
	lodsw
	test	eax, eax
	jne	@@1a
@@8:	xchg	eax, ebx
	pop	ebx
	mov	esi, [esp+8]
	xchg	eax, edx
	cmp	byte ptr [esi], '-'
	jne	@@8a
	dec	edx
	js	@@9
	not	edx
	neg	eax
	sbb	edx, 0
@@8a:	clc
	pop	esi
	ret	4

@@2c:	cmp	eax, 0Ah
	jb	@@2b
@@9:	stc
	pop	esi
	ret	4

@@2a:	cmp	ebx, 19999999h
	lea	ebx, [ebx*4+ebx]
	ja	@@9
	xchg	eax, ecx
	push	10
	pop	eax
	mul	edx
	shl	ebx, 1
	add	eax, ecx
	adc	ebx, edx
	jc	@@9
	xchg	edx, eax
	xor	eax, eax
	lodsw
@@2d:	sub	eax, 30h
@@2b:	cmp	eax, 0Ah
	jb	@@2a
	cmp	eax, -30h
	je	@@8
	jmp	@@9
ENDP

public _ansi_select
_ansi_select PROC
	push	esi
	push	edi
	xor	ecx, ecx
	xor	eax, eax
	mov	esi, [esp+0Ch]
	cmp	[esp+10h], ecx
	je	@@9
@@1:	mov	edi, [esp+10h]
	inc	ecx
@@2:	lodsb
	scasb
	je	@@4
	test	al, al
	je	@@5
@@3:	lodsb
	test	al, al
	jne	@@3
@@5:	cmp	[esi], al
	jne	@@1
	jmp	@@9
@@4:	test	al, al
	jne	@@2
	xchg	eax, ecx
@@9:	cmp	eax, 1
	pop	edi
	pop	esi
	ret	8
ENDP

public _string_select
_string_select PROC
	push	esi
	push	edi
	xor	ecx, ecx
	xor	eax, eax
	mov	esi, [esp+0Ch]
	cmp	[esp+10h], ecx
	je	@@9
@@1:	mov	edi, [esp+10h]
	inc	ecx
@@2:	lodsb
	scasw
	je	@@4
	test	al, al
	je	@@5
@@3:	lodsb
	test	al, al
	jne	@@3
@@5:	cmp	[esi], al
	jne	@@1
	jmp	@@9
@@4:	test	al, al
	jne	@@2
	xchg	eax, ecx
@@9:	cmp	eax, 1
	pop	edi
	pop	esi
	ret	8
ENDP

public _filename_select
_filename_select PROC
	push	ebx
	push	esi
	push	edi
	xor	ecx, ecx
	xor	eax, eax
	mov	esi, [esp+10h]
	cmp	[esp+14h], ecx
	je	@@9
@@1:	mov	edi, [esp+14h]
	inc	ecx
@@1a:	lodsb
	cmp	al, 2Ah	; *
	je	@@7a
	movzx	edx, word ptr [edi]
	inc	edi
	inc	edi
	cmp	al, 3Fh	; ?
	je	@@1d
	sub	edx, 41h
	cmp	edx, 1Ah
	sbb	ebx, ebx
	and	ebx, 20h
	add	edx, ebx
	add	edx, 41h
	cmp	edx, eax
	je	@@7
	test	eax, eax
	je	@@1c
@@1b:	lodsb
	test	eax, eax
	jne	@@1b
@@1c:	cmp	[esi], al
	jne	@@1
	jmp	@@9

@@1d:	test	edx, edx
	jne	@@1a
	jmp	@@1b

@@7:	test	eax, eax
	jne	@@1a
@@7a:	xchg	eax, ecx
@@9:	cmp	eax, 1
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

public _sjis_test
_sjis_test PROC
	cmp	al, 81h
	jb	@@1
	cmp	al, 0A0h
	jb	@@2
	cmp	al, 0E0h
	jb	@@1
	cmp	al, 0FDh
@@2:	cmc
@@1:	ret
ENDP

public _sjis_upper
_sjis_upper PROC
	mov	edx, [esp+4]
@@1:	mov	al, [edx]
	call	_sjis_test
	jc	@@1a
	inc	edx
	mov	al, [edx]
	jmp	@@1b
@@1a:	sub	al, 61h
	cmp	al, 1Ah
	sbb	ah, ah
	and	ah, -20h
	add	al, ah
	add	al, 61h
	mov	[edx], al
@@1b:	inc	edx
	test	al, al
	jne	@@1
	ret	4
ENDP

public _sjis_lower
_sjis_lower PROC
	mov	edx, [esp+4]
@@1:	mov	al, [edx]
	call	_sjis_test
	jc	@@1a
	inc	edx
	mov	al, [edx]
	jmp	@@1b
@@1a:	sub	al, 41h
	cmp	al, 1Ah
	sbb	ah, ah
	and	ah, 20h
	add	al, ah
	add	al, 41h
	mov	[edx], al
@@1b:	inc	edx
	test	al, al
	jne	@@1
	ret	4
ENDP

public _ansi_ext
_ansi_ext PROC
	push	edi
	mov	ecx, [esp+8]
	mov	edi, [esp+0Ch]
	xor	eax, eax
	cmp	ecx, -1
	jne	@@3
	repne	scasb
	not	ecx
	sub	edi, ecx
	dec	ecx
	mov	[esp+8], ecx
@@3:	xchg	edx, eax
@@1:	dec	ecx
	jle	@@9
	mov	al, [edi+ecx]
	cmp	al, 2Fh
	je	@@9
	cmp	al, 5Ch
	je	@@9
	cmp	al, 2Eh
	je	@@2
	rol	edx, 8
	sub	al, 41h
	cmp	al, 1Ah
	sbb	ah, ah
	and	ah, 20h
	add	al, ah
	add	al, 41h
	test	dl, dl
	mov	dl, al
	je	@@1
@@9:	xor	edx, edx
	mov	ecx, [esp+8]
@@2:	xchg	eax, edx
	lea	edx, [edi+ecx]
	pop	edi
	ret	8
ENDP

public _unicode_ext
_unicode_ext PROC
	push	edi
	mov	ecx, [esp+8]
	mov	edi, [esp+0Ch]
	xor	eax, eax
	cmp	ecx, -1
	jne	@@3
	push	edi
	repne	scasw
	not	ecx
	pop	edi
	dec	ecx
	mov	[esp+8], ecx
@@3:	xchg	edx, eax
@@1:	dec	ecx
	jle	@@9
	movzx	eax, word ptr [edi+ecx*2]
	test	ah, ah
	jne	@@9
	cmp	al, 2Fh
	je	@@9
	cmp	al, 5Ch
	je	@@9
	cmp	al, 2Eh
	je	@@2
	rol	edx, 8
	sub	al, 41h
	cmp	al, 1Ah
	sbb	ah, ah
	and	ah, 20h
	add	al, ah
	add	al, 41h
	test	dl, dl
	mov	dl, al
	je	@@1
@@9:	xor	edx, edx
	mov	ecx, [esp+8]
@@2:	xchg	eax, edx
	lea	edx, [edi+ecx*2]
	pop	edi
	ret	8
ENDP

public _sjis_name
_sjis_name PROC
	mov	ecx, [esp+4]
@@1:	mov	edx, ecx
@@2:	mov	al, [ecx]
	inc	ecx
	call	_sjis_test
	jc	@@3
	mov	al, [ecx]
	inc	ecx
	jmp	@@4
@@3:	cmp	al, '\'
	je	@@1
	cmp	al, '/'
	je	@@1
@@4:	test	al, al
	jne	@@2
	sub	ecx, edx
	dec	ecx
	xchg	eax, edx
	ret	4
ENDP

public _unicode_name
_unicode_name PROC
	mov	ecx, [esp+4]
@@1:	mov	edx, ecx
@@2:	movzx	eax, word ptr [ecx]
	inc	ecx
	inc	ecx
	cmp	eax, '\'
	je	@@1
	cmp	eax, '/'
	je	@@1
	test	eax, eax
	jne	@@2
	sub	ecx, edx
	shr	ecx, 1
	dec	ecx
	xchg	eax, edx
	ret	4
ENDP

public _stack_alloc
_stack_alloc PROC
	push	eax
	mov	eax, [esp+8]
	add	eax, 3
	and	al, -4
	sub	esp, eax
	push	dword ptr [esp+eax+4]
	mov	eax, [esp+eax+4]
	ret	0Ch
ENDP

public _stack_sjis
_stack_sjis PROC
	pop	eax
	pop	edx
	push	eax
	xor	eax, eax
	or	ecx, -1
	push	edi
	mov	edi, edx
	repne	scasw
	pop	edi
	not	ecx
	dec	ecx
	lea	eax, [ecx+ecx]
	and	eax, -4
	sub	esp, eax
	push	esp
	push	ecx
	push	edx
	push	932
	push	dword ptr [esp+eax+10h]
	jmp	_unicode_to_ansi
ENDP

public _stack_sjis_esc
_stack_sjis_esc PROC
	pop	eax
	pop	edx
	push	eax
	xor	eax, eax
	or	ecx, -1
	push	edi
	mov	edi, edx
	repne	scasw
	pop	edi
	not	ecx
	dec	ecx
	lea	eax, [ecx+ecx]
	and	eax, -4
	sub	esp, eax
	push	dword ptr [esp+eax]
	lea	eax, [esp+4]
	call	_unicode_to_ansi, 932, edx, ecx, eax
	push	esi
	push	edi
	lea	esi, [esp+0Ch]
	mov	edi, esi
@@1:	lodsb
	cmp	al, 5Ch
	je	@@1b
	call	_sjis_test
	jc	@@1a
	stosb
@@1c:	lodsb
@@1a:	stosb
	test	al, al
	jne	@@1
	lea	eax, [edi-1-0Ch]
	sub	eax, esp
	pop	edi
	pop	esi
	ret

@@2b:	mov	esi, edx
	jmp	@@1c

@@1b:	mov	edx, esi
	lodsb
	cmp	al, 'x'
	jne	@@1a
	call	@@2
	mov	ah, al
	call	@@2
	shl	ah, 4
	or	al, ah
	stosb
	jmp	@@1

@@2:	lodsb
	sub	al, 30h
	cmp	al, 0Ah
	jb	@@2a
	or	al, 20h
	sub	al, 31h
	cmp	al, 6
	jae	@@2b
	add	al, 0Ah
@@2a:	ret
ENDP

public _null_pack
public _null_unpack
_null_pack:
_null_unpack PROC
	push	esi
	push	edi
	mov	edi, [esp+0Ch]
	mov	ecx, [esp+10h]
	mov	esi, [esp+14h]
	mov	edx, [esp+18h]
	mov	eax, ecx
	cmp	ecx, edx
	jb	$+4
	mov	ecx, edx
	sub	eax, ecx
	sub	edx, ecx
	push	ecx
	rep	movsb
	neg	eax
	pop	eax
	pop	edi
	pop	esi
	ret	10h
ENDP

public _lzss_unpack
	include unp_lzss.asm
public _zlib_raw_unpack
public _zlib_unpack
	include unp_zlib.asm
public _lzss_pack
	include pack_lzss.asm
public _zlib_raw_pack
public _zlib_pack
	include pack_zlib.asm
public _tga_optimize
public _tga_alpha_mode
	include tga_optimize.asm

public _crc32@12
	include crc32.asm
public _adler32@12
	include adler32.asm
public _md5_transform@8
	include md5trans.asm
public _sha1_transform@8
	include sha1trans.asm
public _sha512_transform@8
	include sha512trans.asm
public _arc4_set_key@12
public _arc4_crypt@12
	include arc4.asm
public _blowfish_set_key@12
public _blowfish_encrypt
public _blowfish_decrypt
	include blowfish.asm
public _des_swap@4
public _des_init@4
public _des_set_key@8
public _des_crypt@8
	include des.asm

public _md5_fast@12
	include md5fast.asm
public _md5_init@4
public _md5_update@12
public _md5_final@8
	include md5.asm
public _sha1_fast@12
	include sha1fast.asm
public _sha512_init@4
public _sha512_update@12
public _sha512_final@8
	include sha512.asm

	.data?

		dd ?, ?
_LocalData	db 40h dup(?)

	.code

public _ArcLocal
_ArcLocal PROC
	mov	ecx, [esp+4]
	mov	eax, offset _LocalData
	mov	edx, [eax-8]
	mov	[eax-4], ecx
	mov	[eax-8], eax
	cmp	edx, 1
	ret	4
ENDP

public _ArcLocalFree
_ArcLocalFree:
	mov	eax, offset _LocalData
	xor	ecx, ecx
	mov	edx, [eax-4]
	mov	[eax-8], ecx
	mov	[eax-4], ecx
	push	eax
	test	edx, edx
	je	$+4
	call	edx
	pop	eax
	ret

public _ArcLocalMem
_ArcLocalMem:
	call	_MemFree, dword ptr [eax]
	ret

extrn	GetModuleFileNameW:PROC
public _LoadTable
_LoadTable PROC
	push	ebx
	push	esi
	push	edi
	enter	3FCh+8, 0
	mov	edx, offset @@T-8
	mov	ecx, [ebp+14h]
	lea	esi, [edx+ecx*8]
	mov	eax, [esi]
	mov	ebx, [esi+4]
	test	eax, eax
	jne	@@9
	push	eax	; path[0] = 0
	mov	[esi], esi
@@2:	add	eax, [edx+ecx*8-4]
	dec	ecx
	jne	@@2
	mov	[ebp+14h], eax
	mov	edi, esp
	call	GetModuleFileNameW, 0, edi, 200h
	mov	ecx, eax
	dec	eax
	cmp	eax, 1FFh
	jae	@@9
	call	_unicode_ext, ecx, edi
	mov	dword ptr [edx], '.' + 'd' * 10000h
	mov	dword ptr [edx+4], 'a' + 't' * 10000h
	and	dword ptr [edx+8], 0
	call	_FileCreate, edi, FILE_INPUT
	jc	@@9
	xchg	edi, eax
	call	_FileSeek, edi, dword ptr [ebp+14h], 0
	jc	@@9a
	call	_MemAlloc, ebx
	jc	@@9a
	xchg	ebx, eax
	call	_FileRead, edi, ebx, eax
	jc	@@9b
	shr	eax, 2
	mov	[esi], ebx
	xchg	ecx, eax
	push	ebx
@@1:	mov	eax, [ebx]
	mov	edx, eax
	and	eax, 3F3F3F3Fh
	shl	eax, 2
	xor	eax, edx
	mov	[ebx], eax
	add	ebx, 4
	dec	ecx
	jne	@@1
	pop	ebx
	jmp	@@9
@@9b:	call	_MemFree, ebx
@@9a:	call	_FileClose, edi
@@9:	mov	eax, [esi]
	cmp	eax, esi
	jne	$+4
	xor	eax, eax
	cmp	eax, 1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4

	.data

	dd 0
@@T	dd 0, 22800h		; 1 warc
	dd 0, 8000h		; 2 xp3_avatar
	dd 0, 10000h		; 3 leaf_am
	dd 0, XP3_DECC*1000h	; 4 xp3_vm_table

	.code
ENDP

public _LocalFileCreate
_LocalFileCreate PROC
	enter	3FCh, 0
	push	0
	mov	eax, esp
	call	GetModuleFileNameW, 0, eax, 200h
	dec	eax
	cmp	eax, 1FFh
	jae	@@9
	mov	ecx, esp
@@1:	mov	edx, ecx
@@2:	movzx	eax, word ptr [ecx]
	inc	ecx
	inc	ecx
	cmp	eax, '\'
	je	@@1
	test	eax, eax
	jne	@@2
	mov	ecx, [ebp+8]
@@3:	cmp	edx, ebp
	je	@@9
	movzx	eax, byte ptr [ecx]
	inc	ecx
	mov	[edx], ax
	inc	edx
	inc	edx
	test	eax, eax
	jne	@@3
	mov	ecx, esp
	call	_FileCreate, ecx, dword ptr [ebp+0Ch]
@@8:	leave
	ret	8

@@9:	or	eax, -1
	stc
	jmp	@@8
ENDP

public _FileCreateExt
_FileCreateExt PROC
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [ebp+14h]
	call	_unicode_ext, -1, esi
	sub	edx, esi
	lea	ecx, [edx+2]
	xor	eax, eax
	and	ecx, -4
	push	eax
	push	eax
	push	eax
	sub	esp, ecx
	shr	ecx, 2
	mov	edi, esp
	rep	movsd
	lea	edi, [esp+edx]

	mov	edx, [ebp+1Ch]
	test	edx, edx
	je	@@1b
	mov	al, '.'
	stosb
	inc	edi
	xchg	eax, edx
@@1a:	stosb
	inc	edi
	shr	eax, 8
	jne	@@1a
@@1b:	stosb
	mov	edx, esp

	call	_FileCreate, edx, dword ptr [ebp+18h]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

public _hex32_upper
_hex32_upper PROC
	pop	ecx
	pop	eax
	pop	edx
	push	ecx
	push	8
	pop	ecx
@@1:	rol	eax, 4
	push	eax
	and	al, 0Fh
	add	al, -10
	sbb	ah, ah
	add	al, 3Ah
	and	ah, 027h-020h
	add	al, ah
	mov	[edx], al
	inc	edx
	dec	ecx
	pop	eax
	jne	@@1
	mov	[edx], cl
	lea	eax, [ecx+8]
	ret
ENDP

public _escude_crypt
public _arc12_lzss_crypt
public _marble_check
public _marble_crypt
public _exhibit_crypt
public _exhibit_scan
public _png_title
public _xp3_arc_load
public _xp3_next
public _exe_size
public _xp3_findsign
public _aoimy_crypt
public _aoimy_sign
public _nitro_pak_checksum
public _n3pk_xor
public _n3pk_init
public _qlie_checksum
public _epa_dist
	include other.asm
public _rlseen_xor
public _reallive_pack
	include reallive.asm

public _repipack_table
public _repipack_md5
	include repipack.asm
public _ypf_crypt
	include ypf_crypt.asm
public _th123_crypt_init
public _th123_crypt
public _twister_init
public _twister_next
public _twister_one
	include twister.asm
public _exe_timestamp
public _warc_init
public _warc_scan
public _warc_readkey
public _warc_crypt
	include warc_crypt.asm
public _pp_select
public _pp_crypt
	include pp_crypt.asm
public _minori_select
public _minori_test
public _minori_crypt
public _minori_table
	include minori_crypt.asm
public _npa1_select
public _npa1_crypt_names
public _npa1_crypt_init
	include npa1_crypt.asm
public _xp3_select
public _xp3_crypt
	include xp3_crypt.asm
public _majiro_arc_load
public _majiro_mjo_decrypt
	include majiro_crypt.asm
public _glib2_tab
_glib2_tab:
	include glib2.inc

	end
