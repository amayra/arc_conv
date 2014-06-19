
; [TinkerBell]
; "Kowaku no Toki", "Shellsaver" Arc04.dat, Arc05.dat, Arc06.dat
; kowakunotoki.exe
; 0040B6B8 bitmap_hook
; 00451770 bitmap_read
; SSaver.exe
; 0044F6E0 bitmap_read

; "Choumajuu! ~Seieki Juuten Dungeon Kouryaku~"
; magi.exe
; 0045A2E0 bitmap_read

; Arc01.dat Arc04.dat Script
; Arc02.dat Arc05.dat Bitmap
; Arc03.dat Arc06.dat Sound

	dw _conv_tink-$-2
_arc_tink PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	enter	@@stk, 0
	mov	esi, offset inFileName
	mov	edi, esi
	xor	eax, eax
	or	ecx, -1
	repne	scasw
	not	ecx
	mov	ebx, ecx
	push	eax
	shr	ecx, 1
	sub	eax, ecx
	lea	esp, [esp+eax*4]
	mov	edi, esp
	rep	movsd
	mov	edi, esp
@@3a:	dec	ebx
	js	@@9a
	movzx	eax, word ptr [edi+ebx*2]
	cmp	eax, 2Eh
	jne	@@3a
	dec	ebx
	js	@@9a
	movzx	eax, word ptr [edi+ebx*2]
	sub	eax, 34h
	cmp	eax, 3
	jae	@@9a
	sub	byte ptr [edi+ebx*2], 3

	call	_FileCreate, edi, FILE_INPUT
	lea	esp, [ebp-@@stk-10h]
	jc	@@9a
	xchg	edi, eax
	mov	esi, esp
	call	_FileRead, edi, esi, 10h
	jc	@@3b
	call	@@4
	xchg	ebx, eax
	call	@@4
	mov	esi, eax
	add	eax, ebx
	jc	@@3b
	call	_MemAlloc, eax
	jc	@@3b
	mov	[@@M], eax
	add	eax, ebx
	call	_FileRead, edi, eax, esi
	jc	@@3c
	mov	edx, [@@M]
	mov	eax, edx
	add	edx, ebx
	call	_lzss_unpack, eax, ebx, edx, esi
	jnc	@@3d
@@3c:	call	_MemFree, [@@M]
@@3b:	and	[@@M], 0
@@3d:	call	_FileClose, edi

	mov	esi, [@@M]
	test	esi, esi
	je	@@9
	call	_ArcDbgData, esi, ebx
	cmp	ebx, 4
	jb	@@9
	mov	ecx, [esi]
	lea	eax, [ecx-16h]
	mov	[@@L0], ecx
	shr	eax, 1		; 0x16, 0x17
	jne	@@9
	add	ecx, 4
	mov	eax, ebx
	xor	edx, edx
	div	ecx
	lea	ecx, [eax-1]
	shr	ecx, 14h
	or	edx, ecx
	jne	@@9
	mov	[@@N], eax
	call	_ArcCount, eax

@@1:	mov	eax, [@@L0]
	cmp	[esi], eax
	jne	@@9
	mov	edi, esp
	mov	al, '$'
	stosb
	call	_StrDec32, 7, dword ptr [esi+4], edi
	dec	edi
	movzx	edx, word ptr [esi+14h]
	mov	al, dh
	sub	al, 21h
	cmp	al, 5Fh
	sbb	al, al
	and	dh, al
	mov	al, dl
	sub	al, 21h
	cmp	al, 5Fh
	sbb	al, al
	and	dl, al
	and	al, 2Eh
	shl	edx, 8
	mov	dl, al
	mov	[edi+8], edx
	call	_ArcName, edi, -1
	mov	eax, [esi+10h]
	cmp	byte ptr [esi+14h], 'u'		; magi "u0"
	jne	@@1d
	add	eax, 0Ch
@@1d:	mov	edi, [esi+8]
	mov	ebx, [esi+0Ch]
	and	[@@D], 0
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	cmp	edi, ebx
	jne	@@1c
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, [@@L0]
	add	esi, 4
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

	; p, b, n, o
@@1c:	call	_ArcMemRead, eax, edi, ebx, 0
	call	_lzss_unpack, [@@D], edi, edx, eax
	jmp	@@1b

@@4:	push	8
	pop	ecx
	xor	edx, edx
@@4a:	xor	eax, eax
	lodsb
	xor	al, 7Fh
	cmp	al, 80h
	jne	$+4
	mov	al, 0
	lea	edx, [edx*4+edx]
	lea	edx, [edx*2+eax]
	dec	ecx
	jne	@@4a
	xchg	eax, edx
	ret
ENDP

_conv_tink PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-20h]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'b'
	jne	@@2e
	clc
	leave
	ret

@@2e:	sub	ah, 30h
	cmp	eax, 'b'
	je	@@1
	cmp	eax, 'n'
	je	@@1
	cmp	eax, 'o'
	je	@@1
	cmp	eax, 'u'
	je	@@2c
	cmp	eax, 'k'
	je	@@2c
	cmp	eax, 'j'
	jne	@@9
@@2c:	sub	ebx, 4
	jbe	@@9
	mov	eax, [esi]
	cmp	eax, 'kniT'
	jne	@@2d
	mov	dword ptr [esi], 'SggO'
	mov	eax, 0E1Bh
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	xor	ecx, ecx
	mov	edx, offset @@X
@@2a:	mov	al, [edx+ecx]
	xor	[esi+4], al
	inc	esi
	test	al, al
	jne	@@2b
	xor	ecx, ecx
@@2b:	inc	ecx
	dec	ebx
	jne	@@2a
	call	_ArcSetExt, 'ggo'
	call	_ArcData, [@@SB], [@@SC]
	clc
	leave
	ret

@@2d:	mov	edx, 'EVAW'
	cmp	ebx, 0Ch
	jb	@@9
	sub	eax, 'FFIR'
	sub	edx, [esi+8]
	or	eax, edx
	jne	@@9
	call	_ArcSetExt, 'vaw'
@@9:	stc
	leave
	ret

@@1a:	sub	ebx, 4
	jb	@@9
	lodsd
	bswap	eax
	cmp	ebx, eax
	jne	@@9
	call	_ArcSetExt, 'gnp'
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@1:	dec	ebx
	js	@@9
	lodsb
	cmp	al, 'c'
	je	@@1a
	cmp	al, 'a'		; b - ?, c - png
	jne	@@9
	call	_ArcLocal, 0
	xchg	edi, eax
	jnc	@@1b
	and	dword ptr [edi], 0
	call	_ArcParamNum, 0
	db 'tink', 0
	mov	edx, offset @@T
@@1f:	movzx	ecx, byte ptr [edx]
	test	ecx, ecx
	je	@@9
	dec	eax
	je	@@1g
	lea	edx, [edx+ecx+4]
	jmp	@@1f
@@1g:	mov	[edi], edx
@@1b:	mov	edi, [edi]
	test	edi, edi
	je	@@9
	sub	esp, 20h
	call	@@3
	jc	@@9
	mov	eax, [@@L0]		; flags
	mov	edi, [@@L0+10h]		; width
	mov	edx, [@@L0+0Ch]		; height
	mov	[@@SC], ebx
	mov	ebx, edi
	imul	ebx, edx
	mov	ecx, eax
	and	al, 6
	jne	@@1c
	test	ecx, ecx
	jne	@@9
	lea	eax, [ebx+ebx]
	sub	[@@SC], ebx
	jb	@@9
	cmp	[@@SC], eax
	jb	@@1e
	add	ebx, eax
	inc	ecx
	inc	ecx
@@1e:	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	mov	ecx, ebx
	rep	movsb
	clc
	leave
	ret

@@1c:	cmp	al, 2
	jne	@@1d
	call	_ArcTgaAlloc, 2, edi, edx
	lea	edi, [eax+12h]
	call	@@Unpack3, edi, ebx, esi, [@@SC], esp
	clc
	leave
	ret

@@1d:	cmp	al, 6
	jne	@@9
	call	_ArcTgaAlloc, 3, edi, edx
	lea	edi, [eax+12h]
	call	@@Unpack4, edi, ebx, esi, [@@SC], esp
	clc
	leave
	ret

@@3 PROC
	push	ebp
	mov	ebp, esp
	dec	ebx
	js	@@9
	lodsb
	xor	ecx, ecx
@@1:	call	@@3
	movsx	edx, byte ptr [edi+ecx+4]
	mov	[ebp+8+edx*4], eax
	inc	ecx
	cmp	cl, [edi]
	jb	@@1
	clc
@@8:	leave
	ret

@@9:	stc
	jmp	@@8

	; "COM, Picture load errer.[1]"
@@3:	xor	eax, eax
	dec	ebx
	js	@@9
	lodsb
	cmp	al, [edi+3]
	jne	$+4
	xor	eax, eax
	xor	edx, edx
	push	ecx
	push	eax
	xor	ecx, ecx
	jmp	@@3b
@@3a:	inc	edx
	cmp	al, [edi+1]
	je	@@3b
	dec	edx
	cmp	al, [edi+3]
	jne	$+4
	xor	eax, eax
	mov	ecx, eax
@@3b:	dec	ebx
	js	@@9
	lodsb
	cmp	al, [edi+2]
	jne	@@3a
	movzx	eax, byte ptr [edi+1]
	imul	edx, eax
	add	edx, ecx
	imul	edx, eax
	pop	eax
	pop	ecx
	add	eax, edx
	ret
ENDP

@@X	db 'DBB3206F-F171-4885-A131-EC7FBA6FF491'
	db ' Copyright 2004 Cyberworks ',22h,'TinkerBell',22h,'., all rights reserved.',0

	; ?? - flags
	; 0C - height
	; 10 - width
	; 14 - data_size

	; 04 14 18 0C 10 1C 08 B0
	; 04 14 1C 08 10 A4 18 0C
	; 04 10 08 14 0C 18 20 28 24 DC 30 34 38 2C 3C 40 44 1C 48 04 (20 2C -> 18 1C)
	; 04 08 10 0C 1C 14 18 A4

@@T:	db 08,0E9h,0EFh,0FBh, 1,5,6,3,4,7,2,0
	db 08,0C7h,0FBh,0FAh, 1,5,7,2,4,0,6,3
	db 20,0E9h,0EFh,0FBh, 1,4,2,5,3,1,6,1, 1,0,1,1,1,7,1,1, 1,1,1,1
	db 08,0E9h,0C7h,0FBh, 1,2,4,3,7,5,6,0
	db 0

@@Unpack3 PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]

@@L1 = dword ptr [ebp-4]
@@L2 = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	edx, [@@DC]
	xor	esi, esi
	add	edx, 7
	mov	ebx, [@@L0]
	shr	edx, 3
	mov	eax, [ebx+1Ch]
	push	eax
	cmp	eax, edx
	jb	@@9
	shl	eax, 1
	sub	[@@SC], eax
	jb	@@9
	add	eax, [@@SB]
	push	eax
@@1:	xor	eax, eax
	mov	ecx, esi
	mov	edx, esi
	inc	eax
	and	ecx, 7
	shr	edx, 3
	shl	eax, cl
	add	edx, [@@SB]
	mov	ecx, [@@L1]
	movzx	ebx, byte ptr [edx+ecx]
	and	bl, al
	jne	@@1a
	and	al, [edx]
@@1a:	test	al, al
	je	@@1b
	sub	[@@SC], 3
	jb	@@9
	xchg	eax, esi
	mov	esi, [@@L2]
	movsb
	movsb
	movsb
	mov	[@@L2], esi
	xchg	esi, eax
	jmp	@@1c
@@1b:	stosb
	stosb
	stosb
@@1c:	inc	esi
	cmp	esi, [@@DC]
	jb	@@1
@@9:	sub	esi, [@@DC]
	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

@@Unpack4 PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]

@@L1 = dword ptr [ebp-4]
@@L2 = dword ptr [ebp-8]
@@L3 = dword ptr [ebp-0Ch]
@@L4 = dword ptr [ebp-10h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	edx, [@@DC]
	xor	esi, esi
	add	edx, 7
	mov	ebx, [@@L0]
	shr	edx, 3
	mov	eax, [ebx+1Ch]
	mov	ecx, [ebx+18h]
	push	eax
	cmp	eax, edx
	jb	@@9
	shl	eax, 1
	sub	[@@SC], eax
	jb	@@9
	sub	[@@SC], ecx
	jb	@@9
	add	eax, [@@SB]
	push	ecx
	add	ecx, eax
	push	eax
	push	ecx
@@1:	xor	eax, eax
	mov	ecx, esi
	mov	edx, esi
	inc	eax
	and	ecx, 7
	shr	edx, 3
	shl	eax, cl
	add	edx, [@@SB]
	mov	ecx, [@@L1]
	movzx	ebx, byte ptr [edx+ecx]
	and	bl, al
	jne	@@1a
	mov	bh, [edx]
	and	bh, al
@@1a:	mov	al, bl
	or	al, bh
	je	@@1b
	sub	[@@SC], 3
	jb	@@9
	xchg	eax, esi
	mov	esi, [@@L4]
	movsb
	movsb
	movsb
	mov	[@@L4], esi
	xchg	esi, eax
	jmp	@@1c
@@1b:	stosb
	stosb
	stosb
@@1c:	neg	bh
	sbb	al, al
	test	bl, bl
	je	@@1d
	sub	[@@L2], 3
	jb	@@9
	mov	edx, [@@L3]
	mov	al, [edx]
	add	edx, 3
	mov	[@@L3], edx
@@1d:	stosb
	inc	esi
	cmp	esi, [@@DC]
	jb	@@1
@@9:	sub	esi, [@@DC]
	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

ENDP
