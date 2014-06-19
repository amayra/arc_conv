
; "Koi to Senkyo to Chocolate" *.cct

; dirapi.dll (Director Player 8.5.1 r104)

	dw _conv_xfir-$-2
_arc_xfir PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@SC
@M0 @@L0, 0Ch
@M0 @@L1, 14h

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	pop	eax
	pop	ecx
	pop	edx
	cmp	eax, 'RIFX'
	jne	@@9a
	cmp	edx, 'MV93'
	je	_mod_xfir39vm
	; 'CDGF', 'MDGF'
	sub	edx, 'FGDC'
	je	@@2a
	cmp	edx, 0Ah
	jne	@@9a
@@2a:	push	0Ch
	pop	edi
	call	@@3, 'Fver'
	call	@@3, 'Fcdr'
	mov	eax, edi
	sub	eax, ebx
	mov	[@@L1+4], ebx
	mov	[@@L1], eax
	call	@@3, 'ABMP'
	mov	[@@L1+8], edi
	mov	[@@L1+0Ch], ebx
	call	@@3, 'FGEI'
	test	ebx, ebx
	jne	@@9a
	mov	[@@P], edi
	mov	edi, [@@L1]
	mov	ebx, [@@L1+8]
	sub	ebx, edi
	call	_FileSeek, [@@S], edi, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	sub	ebx, [@@L1+0Ch]
	call	_zlib_unpack, 0, -1, esi, [@@L1+4]
	jc	@@9
	mov	[@@L0], eax
	mov	edi, [@@L1+0Ch]
	add	esi, ebx
	push	5*2
	pop	ebx
	cmp	edi, ebx
	jae	$+4
	mov	ebx, edi
	sub	edi, ebx
	call	@@4
	js	@@9
	mov	[@@L0+4], eax
	call	@@4
	js	@@9
	mov	[@@L0+8], eax
	add	edi, ebx
	mov	ebx, eax
	add	eax, [@@L0]
	jc	@@9
	call	_MemAlloc, eax
	jc	@@9
	mov	[@@L1], esi
	xchg	esi, eax
	call	_zlib_unpack, esi, ebx, eax, edi
	lea	edi, [esi+ebx]
	call	_zlib_unpack, edi, [@@L0], [@@M], [@@L1+4]
	mov	[@@M], esi

	xor	ecx, ecx
@@2b:	push	ecx
	call	@@4
	pop	ecx
	js	@@9
	mov	[@@L1+ecx*4], eax
	inc	ecx
	cmp	ecx, 3
	jb	@@2b
	lea	ecx, [eax-1]
	shr	ecx, 14h
	jne	@@9
	mov	[@@SC], ebx
	mov	[@@N], eax
	call	_ArcCount, eax
	call	_ArcDbgData, edi, [@@L0]
	call	_ArcDbgData, [@@M], [@@L0+8]
	call	_MemFree, [@@L1]

@@1:	mov	ebx, [@@SC]
	xor	ecx, ecx
@@2c:	push	ecx
	call	@@4
	pop	ecx
	js	@@9
	mov	[@@L1+ecx*4], eax
	inc	ecx
	cmp	ecx, 5
	jb	@@2c
	sub	ebx, 4
	jb	@@9
	lodsd
	mov	[@@SC], ebx
	test	eax, eax
	je	@@8
	and	[@@D], 0
	mov	edi, [@@L1+4]
	mov	ebx, [@@L1+8]
	cmp	edi, -1
	je	@@8
	add	edi, [@@P]
	jc	@@8

	call	_xfir_name, [@@L1], dword ptr [esi-4]

	call	_FileSeek, [@@S], edi, 0
	jc	@@1a
	mov	edi, [@@L1+0Ch]
	cmp	[@@L1+10h], 0
	je	$+4
	xor	edi, edi
	lea	eax, [@@D]
	call	_ArcMemRead, eax, edi, ebx, 0
	cmp	[@@L1+10h], 0
	jne	@@1b
	call	_zlib_unpack, [@@D], edi, edx, eax
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
	jmp	@@8a

@@8:	call	_ArcSkip, 1
@@8a:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	lea	esi, [@@L0]
	call	_FileRead, [@@S], esi, 9
	add	edi, eax
	jc	@@9a
	sub	eax, 4
	jb	@@9a
	xchg	ebx, eax
	lodsd
	cmp	eax, [esp+4]
	jne	@@9a
	call	@@4
	stc
	js	@@9a
	sub	edi, ebx
	add	edi, eax
	jc	@@9a
	xchg	ebx, eax
	call	_FileSeek, [@@S], edi, 0
	jc	@@9a
	ret	4

@@4:	xor	edx, edx
@@4a:	dec	ebx
	js	@@4b
	lodsb
	mov	ecx, eax
	and	eax, 7Fh
	shl	edx, 7
	add	edx, eax
	test	cl, cl
	js	@@4a
@@4b:	xchg	edx, eax
	ret
ENDP

; "Sukisho 1 - First Limit" *.dxr, *.cxt

; dirapi.dll (Director Player 8.0.0 r187)

_mod_xfir39vm PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 8

	lea	esi, [@@L0]
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	mov	ebx, [esi+4]
	cmp	[esi], 'imap'
	jne	@@9a
	cmp	ebx, 18h
	jne	@@9a
	sub	esp, 18h
	mov	edi, esp
	call	_FileRead, [@@S], edi, 18h
	jc	@@9a
	call	_FileSeek, [@@S], dword ptr [edi+4], 0
	jc	@@9a
	lea	esp, [ebp-@@stk]
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	mov	ebx, [esi+4]
	cmp	[esi], 'mmap'
	jne	@@9a
	cmp	ebx, 18h+14h*3
	jb	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	dword ptr [esi+18h], 'RIFX'
	jne	@@9
	mov	eax, [esi+8]
	dec	eax
	imul	edx, eax, 14h
	lea	ecx, [eax-1]
	add	edx, 2Ch
	shr	ecx, 14h
	jne	@@9
	cmp	ebx, edx
	jb	@@9
	mov	[@@N], eax
	call	_ArcCount, eax
	add	esi, 2Ch

	and	[@@L0], 0
@@1:	inc	[@@L0]
	cmp	dword ptr [esi+4], 0
	je	@@8
	call	_xfir_name, [@@L0], dword ptr [esi]
	and	[@@D], 0
	mov	eax, [esi+8]
	mov	ebx, [esi+4]
	add	eax, 8
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
	jmp	@@8a

@@8:	call	_ArcSkip, 1
@@8a:	add	esi, 14h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_xfir_name PROC
	push	0
	sub	esp, 0Ch
	mov	edx, esp
	call	_StrDec32, 8, dword ptr [esp+14h+4], edx
	mov	eax, [esp+10h+8]
	bswap	eax
	push	4
	pop	ecx
@@1:	movzx	edx, al
	cmp	al, 30h
	jb	@@1a
	cmp	al, 3Ah
	jb	@@1b
	or	edx, 20h
	sub	edx, 61h
	cmp	edx, 1Ah
	jb	@@1b
@@1a:	mov	al, '_'
@@1b:	rol	eax, 8
	dec	ecx
	jne	@@1
	mov	edx, esp
	mov	dword ptr [edx+8], '.'
	mov	[edx+9], eax
	call	_ArcName, edx, -1
	add	esp, 10h
	ret	8
ENDP

_conv_xfir PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'dtib'
	je	@@1
	cmp	eax, 'mide'
	je	@@2
	cmp	eax, 'demx'
	je	@@3
@@9:	stc
	leave
	ret

@@2:	sub	ebx, 4
	jb	@@9
	lodsd
	bswap	eax
	sub	ebx, eax
	jb	@@9
	add	esi, eax
	call	_ArcSetExt, '3pm'
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@3:	call	@@XMED, 0, esi, ebx
	test	eax, eax
	je	@@9
	call	_MemAlloc, eax
	jc	@@9
	xchg	edi, eax
	call	@@XMED, edi, esi, ebx
	xchg	ebx, eax
	call	_ArcSetExt, 'txt'
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

@@1:	call	@@Detect, esi, ebx
	jc	@@9
	xchg	ebx, eax
	push	edx
	push	ecx
	call	_ArcTgaAlloc, 23h, ecx, edx
	xchg	edi, eax
	add	edi, 12h

	call	_MemAlloc, ebx
	jc	@@9
	xchg	esi, eax
	call	@@Unpack, esi, ebx, eax, [@@SC]
	push	esi
	mov	ebx, [@@L0]
	lea	edx, [ebx*2+ebx]
@@1a:	mov	ecx, ebx
@@1b:	mov	al, [esi+edx]
	stosb
	mov	al, [esi+ebx*2]
	stosb
	mov	al, [esi+ebx]
	stosb
	movsb
	dec	ecx
	jne	@@1b
	add	esi, edx
	dec	[@@L0+4]
	jne	@@1a
	call	_MemFree
	clc
	leave
	ret

@@Detect PROC

@@SB = dword ptr [ebp+14h]
@@SC = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@SB]
	xor	ebx, ebx
@@1:	dec	[@@SC]
	js	@@7
	lodsb
	movzx	ecx, al
	test	al, al
	jns	$+4
	neg	cl
	inc	ecx
	cmp	ecx, 7Fh	; 7F 80 81 - unused
	ja	@@9
	mov	edx, ecx
	test	al, al
	jns	$+4
	mov	dl, 1
	sub	[@@SC], edx
	jb	@@9
	add	esi, edx
	add	ebx, ecx
	js	@@9

	cmp	ebp, esp
	je	@@2c
	mov	edx, ebp
	mov	edi, ebp
	mov	[@@SB], esi
@@2:	mov	eax, [edx-4]
	sub	edx, 4
	sub	ax, cx
	jb	@@2b
	jne	@@2a
	mov	esi, eax
	shr	eax, 10h
	add	eax, esi
@@2a:	mov	[edi-4], eax
	sub	edi, 4
@@2b:	cmp	edx, esp
	jne	@@2
	mov	esi, [@@SB]
	mov	esp, edi
@@2c:
	cmp	ebx, 800h
	jae	@@1a
	mov	eax, ebx
	shl	eax, 10h
	add	eax, ebx
	push	eax
@@1a:	cmp	ebp, esp
	je	@@9
	jmp	@@1

@@7:	test	bl, 3
	jne	@@9
	cmp	ebp, esp
	je	@@9
	mov	edi, ebp
@@7a:	mov	ecx, [edi-4]
	sub	edi, 4
	movzx	eax, cx
	shr	ecx, 10h
	cmp	eax, ecx
	jne	@@7b
	cmp	ecx, 8
	jb	@@7b
	mov	eax, ebx
	xor	edx, edx

	shr	eax, 2
	div	ecx
	lea	esi, [eax-8]
	cmp	esi, 800h-8
	jae	@@7b
	test	edx, edx
	xchg	edx, eax
	je	@@8
@@7b:	cmp	edi, esp
	jne	@@7a
	jmp	@@9

@@9:	stc
@@8:	xchg	eax, ebx
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@SB]
	mov	edi, [@@DB]
@@1:	cmp	[@@DC], 0
	je	@@7
	dec	[@@SC]
	js	@@9
	lodsb
	movzx	ecx, al
	test	al, al
	jns	$+4
	neg	cl
	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
	test	al, al
	jns	@@1a
	dec	[@@SC]
	js	@@9
	lodsb
	rep	stosb
	jmp	@@1

@@1a:	sub	[@@SC], ecx
	jb	@@9
	rep	movsb
	jmp	@@1

@@7:	xor	esi, esi
@@9:	xchg	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

@@XMED PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@C = dword ptr [ebp+1Ch]

@@L0 = @@S

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ebx, [@@C]
	mov	esi, [@@S]
	mov	edi, [@@D]
@@2:	sub	ebx, 14h
	jb	@@9
	; type, size, ?
	; FFFF - header
	; 0002 - text (offset)
	; 0008 - font (count)
	call	@@3
	mov	[@@L0], ecx
	call	@@3
	mov	edx, ecx
	call	@@3
	shl	edx, 10h
	add	esi, 8
	add	edx, ecx
	cmp	[@@L0], 2
	jne	@@2b
@@2a:	dec	ebx
	js	@@9
	; 00 - data, 03 - end
	lodsb
	cmp	al, 3
	je	@@2
	test	al, al
	jne	@@2a
	xor	ecx, ecx
@@1a:	dec	ebx
	js	@@9
	lodsb
	cmp	al, 2Ch
	je	@@1c
	sub	al, 30h
	cmp	al, 0Ah
	jb	@@1b
	sub	al, 11h
	cmp	al, 6
	jae	@@9
	add	al, 0Ah
@@1b:	rol	ecx, 4
	test	cl, 0Fh
	jne	@@9
	add	cl, al
	jmp	@@1a

@@2b:	sub	ebx, edx
	jb	@@9
	add	esi, edx
	jmp	@@2

@@1c:	sub	ebx, ecx
	jae	$+6
	add	ecx, ebx
	xor	ebx, ebx
@@4a:	xor	eax, eax
@@4:	dec	ecx
	je	@@2a
	lodsb
	cmp	al, 0Ah
	je	@@4b
	cmp	al, 0Dh
	je	@@4b
	inc	edi
	cmp	[@@D], 0
	je	@@4a
	mov	[edi-1], al
	jmp	@@4a

@@4b:	cmp	al, ah
	je	@@4a
	xor	al, 7
	mov	ah, al
	inc	edi
	inc	edi
	cmp	[@@D], 0
	je	@@4
	mov	word ptr [edi-2], 0A0Dh
	jmp	@@4

@@9:	xchg	eax, edi
	sub	eax, [@@D]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@3:	mov	ecx, 0FFFF0000h
@@3a:	lodsb
	sub	al, 30h
	cmp	al, 0Ah
	jb	@@3b
	sub	al, 11h
	cmp	al, 6
	jae	@@9
	add	al, 0Ah
@@3b:	shl	ecx, 4
	add	cl, al
	test	ecx, ecx
	js	@@3a
	ret
ENDP

ENDP