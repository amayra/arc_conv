
; "Akogare" *.fa2
; advak.exe
; 0040C280 open_archive
; 00415AD0 unpack
; 00415390 c25_unpack
; 004162E0 pad_header_check
; 004167C0 pad_decode

	dw _conv_fa2-$-2
_arc_fa2 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	pop	edi
	pop	esi
	lea	ecx, [esi-1]
	sub	eax, '2AF'
	shr	ecx, 14h
	or	eax, ecx
	jne	@@9a
	mov	[@@N], esi
	shl	esi, 5
	xor	ebx, ebx
	shr	edx, 1
	jnc	@@2a
	call	_FileSeek, [@@S], 0, 2
	jc	@@9a
	sub	eax, edi
	jb	@@9a
	xchg	esi, eax
	xchg	ebx, eax
@@2a:	call	_FileSeek, [@@S], edi, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, ebx, esi, 0
	jc	@@9
	mov	esi, [@@M]
	test	ebx, ebx
	je	@@2b
	call	@@Unpack, esi, ebx, edx, eax
	jc	@@9
	call	_ArcDbgData, esi, ebx
@@2b:	call	_ArcCount, [@@N]
	call	_FileSeek, [@@S], 10h, 0
	jc	@@1a

@@1:	call	_ArcName, esi, 0Fh
	and	[@@D], 0

	mov	eax, [esi+1Ch]
	mov	edi, [esi+18h]
	mov	ebx, eax
	add	eax, 0Fh
	and	al, 0F0h
	test	byte ptr [esi+0Fh], 2
	jne	$+4
	xor	edi, edi

	lea	edx, [@@D]
	call	_ArcMemRead, edx, edi, eax, 0
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	test	byte ptr [esi+0Fh], 2
	je	@@1a
	call	@@Unpack, [@@D], edi, edx, ebx
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 20h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

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
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
	call	@@3b
	shl	ebx, 1
	jne	@@3a
	sub	[@@SC], 4
	jb	@@9
	mov	ebx, [esi]
	add	esi, 4
	stc
	adc	ebx, ebx
@@3a:	ret
@@3b:	pop	edx

@@1:	dec	[@@SC]
	js	@@9
	call	edx
	jnc	@@1a
	dec	[@@DC]
	js	@@9
	movsb
	jmp	@@1

@@1a:	xor	ecx, ecx
	xor	eax, eax
	inc	ecx
	call	edx
	jnc	@@1c
	inc	ecx
	call	edx
	lodsb
	jnc	@@1b
	add	eax, 20h
	call	edx
	adc	eax, eax
	call	edx
	adc	eax, eax
	call	edx
	adc	eax, eax
	cmp	eax, 8FFh
	je	@@7
@@1b:	not	eax
	sub	[@@DC], ecx
	jb	@@9
	push	edx
	mov	edx, edi
	sub	edx, [@@DB]
	add	edx, eax
	pop	edx
	jnc	@@9
	add	eax, edi
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@7:	mov	esi, [@@DC]
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@1c:	call	edx
	jc	@@1d
	mov	ah, 1
@@1f:	call	edx
	jc	@@1d
	inc	ecx
	cmp	ecx, 4
	jb	@@1f
@@1d:	lodsb
@@1e:	call	edx
	adc	eax, eax
	dec	ecx
	jne	@@1e

	call	edx
	jc	@@2a	; 0
	inc	ecx
	call	edx
	jc	@@2a	; 1
	call	edx
	jc	@@2b	; bits(1) + 2
	call	edx
	jc	@@2c	; bits(2) + 4
	call	edx
	jc	@@2d	; bits(4) + 8
	dec	[@@SC]
	js	@@9
	mov	cl, [esi]
	inc	esi
	add	ecx, 18h+3
	jmp	@@1b

@@2d:	call	edx
	adc	ecx, ecx
	dec	ecx
	call	edx
	adc	ecx, ecx
@@2c:	call	edx
	adc	ecx, ecx
@@2b:	call	edx
	adc	ecx, ecx
@@2a:	add	ecx, 3
	jmp	@@1b
ENDP

ENDP

_conv_fa2 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'dap'
	je	@@4
	cmp	eax, '52c'
	jne	@@9
	sub	ebx, 8
	jb	@@9
	mov	eax, [esi]
	mov	ecx, [esi+4]
	sub	eax, '52C'
	lea	edx, [ecx-1]
	shr	edx, 10h
	or	eax, edx
	jne	@@9
	mov	edi, ecx
	shl	ecx, 2
	sub	ebx, ecx
	jb	@@9
	xor	ebx, ebx
	dec	edi
	jne	@@2
	call	@@3
	leave
	ret

@@9:	stc
	leave
	ret

@@2:	push	edi	; @@L0
	call	_ArcSetExt, 0
	push	edx	; @@L1
@@2a:	call	_ArcNameFmt, [@@L1], ebx
	db '\%05i',0
	pop	ecx
	push	ebx
	call	@@3
	jc	@@2b
	call	_ArcTgaSave
	call	_ArcTgaFree
@@2b:	pop	ebx
	inc	ebx
	cmp	ebx, [@@L0]
	jbe	@@2a
@@2c:	clc
	leave
	ret

@@3:	mov	esi, [@@SB]
	mov	ecx, [@@SC]
	mov	eax, [esi+ebx*4+8]
	test	eax, eax
	je	@@3a
	sub	ecx, eax
	jb	@@3a
	add	esi, eax
	sub	ecx, 10h
	jb	@@3a
	mov	edi, [esi]
	mov	edx, [esi+4]
	mov	eax, edx
	shl	eax, 2
	sub	ecx, eax
	jb	@@3a
	call	_ArcTgaAlloc, 40h+23h, edi, edx
	jc	@@3a
	lea	edi, [eax+12h]
	mov	ecx, [esi+0Ch-2]
	mov	cx, [esi+8]
	mov	[edi-12h+8], ecx
	call	@@C25, edi, ebx, [@@SB], [@@SC]
	clc
	ret

@@3a:	stc
	ret

@@4a:	jmp	@@9

@@4:	sub	ebx, 2Ch
	jb	@@4a
	mov	edx, 'EVAW'
	mov	ecx, ' tmf'
	mov	eax, [esi]
	sub	edx, [esi+8]
	sub	ecx, [esi+0Ch]
	sub	eax, 'DAP'
	or	edx, ecx
	or	eax, edx
	jne	@@4a
	mov	edi, [esi+28h]
	add	edi, 2Ch
	jc	@@4a
	mov	edx, [esi+10h]
	mov	eax, [esi+24h]
	movzx	ecx, word ptr [esi+22h]		; wBitsPerSample
	sub	edx, 10h
	sub	ecx, 10h
	sub	eax, 'atad'
	or	edx, ecx
	or	eax, edx
	movzx	ecx, word ptr [esi+16h]		; nChannels
	movzx	edx, word ptr [esi+14h]		; wFormatTag
	dec	ecx
	dec	edx
	shr	ecx, 1
	or	edx, ecx
	or	eax, edx
	jne	@@4a
	call	_MemAlloc, edi
	jc	@@4a
	xchg	edi, eax
	lea	edx, [eax-8]
	push	24h/4
	pop	ecx
	push	edi
	lodsd
	lodsd
	mov	eax, 'FFIR'
	stosd
	xchg	eax, edx
	stosd
	rep	movsd
	sub	eax, 24h

	movzx	edx, word ptr [esi-2Ch+16h]		; nChannels
	shl	edx, 1
	call	@@PAD, edi, eax, esi, ebx, edx
	pop	edi
	lea	ebx, [eax+2Ch]
	call	_ArcSetExt, 'vaw'
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

@@C25 PROC

@@DB = dword ptr [ebp+14h]
@@L0 = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@W = dword ptr [ebp-4]
@@H = dword ptr [ebp-8]
@@L1 = dword ptr [ebp-0Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	eax, [@@L0]
	mov	esi, [@@SB]
	add	esi, [esi+eax*4+8]
	mov	edx, [esi+4]
	push	dword ptr [esi]
	push	edx
	add	esi, 10h
	push	esi
@@1:	mov	edi, [@@DB]
	dec	[@@H]
	js	@@7
	mov	edx, [@@W]
	mov	esi, [@@L1]
	lea	eax, [edi+edx*4]
	mov	[@@DB], eax
	lodsd
	mov	ebx, [@@SC]
	mov	[@@L1], esi
	sub	ebx, eax
	jb	@@1
	add	eax, [@@SB]
	xchg	esi, eax

@@2:	test	edx, edx
	je	@@1
	dec	ebx
	js	@@1
	movzx	ecx, byte ptr [esi]
	inc	esi
	test	cl, cl
	js	@@2a
	call	@@3
	xor	eax, eax
	rep	stosd
	jmp	@@2

@@2a:	add	ecx, -80h
	cmp	ecx, 70h
	jae	@@2c
	call	@@3
	lea	eax, [ecx*2+ecx]
	sub	ebx, eax
	jb	@@9a
	mov	al, 0FFh
@@2b:	movsb
	movsb
	movsb
	stosb
	dec	ecx
	jne	@@2b
	jmp	@@2

@@9a:	jmp	@@1

@@2c:	sub	ecx, 70h
	call	@@3
	mov	eax, ecx
	shl	eax, 2
	sub	ebx, eax
	jb	@@9a
	rep	movsd
	jmp	@@2

@@3b:	pop	ecx
	jmp	@@2

@@3:	test	ecx, ecx
	jne	@@3a
	sub	ebx, 2
	js	@@9a
	movzx	ecx, word ptr [esi]
	add	esi, 2
@@3a:	test	ecx, ecx
	je	@@3b
	sub	edx, ecx
	jae	$+6
	add	ecx, edx
	xor	edx, edx
	ret

@@7:	xor	esi, esi
@@9:	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

@@PAD PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@A = dword ptr [ebp+24h]

@@stk = 0
@M0 @@L0
@M0 @@L2, 20h
@M0 @@L4, 0Ch

	push	ebx
	push	esi
	push	edi
	enter	@@stk-0Ch, 0
	push	(7Fh-6) SHL 23	; @@L4
	push	(7Fh-1) SHL 23	; @@L5
	push	0E7F027Fh
	sub	esp, 70h

	xor	eax, eax
	lea	edi, [@@L2]
	lea	ecx, [eax+8]
	rep	stosd

	mov	esi, [@@SB]
	mov	edi, [@@DB]
	finit
	fldcw	word ptr [@@L4]
@@1:	mov	ecx, [@@A]
	shl	ecx, 3
	sub	[@@SC], ecx
	jb	@@9
	lodsb
	cmp	al, -1
	je	@@9
	lodsb
	cmp	al, 50h
	jae	@@9
	mov	byte ptr [esp], al
	cmp	ecx, 20h
	jne	@@1a
	lodsb
	lodsb
	cmp	al, 50h
	jae	@@9
	mov	byte ptr [esp+2], al
@@1a:	push	edi
	xor	ebx, ebx
	call	@@2
	cmp	[@@A], 4
	jne	@@1b
	inc	ebx
	call	@@2
@@1b:	pop	edi
	mov	ecx, [@@A]
	mov	ebx, [@@DC]
	imul	ecx, 0Eh*2
	mov	eax, esp
	sub	ebx, ecx
	jae	$+6
	add	ecx, ebx
	xor	ebx, ebx
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	mov	[@@DC], ebx
	test	ebx, ebx
	jne	@@1
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h

@@2:	lea	edi, [esp+8+ebx*2]
	movzx	eax, byte ptr [edi]
	mov	ecx, eax
	shr	eax, 4
	and	ecx, 0Fh
	movsx	edx, word ptr [@@T+eax*2]
	movzx	eax, dl
	sar	edx, 8
	mov	[@@L0], edx
	fild	[@@L0]
	fmul	[@@L4+8]
	mov	[@@L0], eax
	fild	[@@L0]
	fmul	[@@L4+8]
	fld	qword ptr [@@L2+ebx*8]
	fld	qword ptr [@@L2+ebx*8+10h]
	; t1, t0, m0, m1
	push	ebx
	push	0Eh
	pop	ebx
@@2a:	lodsb
	mov	edx, eax
	shl	eax, 0Ch
	and	edx, -10h
	shl	edx, 8
	call	@@2b
	xchg	eax, edx
	call	@@2b
	dec	ebx
	jne	@@2a
	pop	ebx
	fstp	qword ptr [@@L2+ebx*8+10h]
	fstp	qword ptr [@@L2+ebx*8]
	fcompp
	ret

@@2b:	movsx	eax, ax
	sar	eax, cl
	mov	[@@L0], eax
	fmul	st(0), st(3)
	fld	st(1)
	fmul	st(0), st(3)
	faddp	st(1), st(0)
	fiadd	[@@L0]
	fxch	st(1)
	fld	[@@L4+4]
	fadd	st(0), st(2)
	fldcw	word ptr [@@L4+2]
	fistp	[@@L0]
	fldcw	word ptr [@@L4]
	mov	eax, [@@L0]
	cmp	eax, 7FFFh
	jl	$+7
	mov	eax, 7FFFh
	cmp	eax, -8000h
	jge	$+7
	mov	eax, -8000h
	mov	[edi], ax
	add	edi, [@@A]
	ret

	; advak.exe 00420AF8
@@T	db 0,0, 60,0, 115,-52, 98,-55, 122,-60
ENDP

ENDP
