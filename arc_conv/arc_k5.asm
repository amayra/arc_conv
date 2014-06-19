
; "Hoshi no Oujo" *.k3

	dw _conv_k5-$-2
_arc_k3 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ah
	jc	@@9a
	cmp	word ptr [esi], '3K'
	jne	@@9a
	mov	ebx, [esi+2]
	lea	eax, [ebx-1]
	shr	eax, 14h
	or	eax, [esi+6]
	jne	@@9a
	mov	[@@N], ebx
	shl	ebx, 6
	lea	eax, [ebx+6]
	sub	ebx, 4
	mov	[@@P], eax
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 4, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	and	dword ptr [esi], 0
	call	_ArcCount, [@@N]

@@1:	lea	edx, [esi+20h]
	call	_ArcName, edx, 20h
	and	[@@D], 0
	mov	eax, [esi]
	mov	ebx, [esi+4]
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 40h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

; "Hoshi no Oujo: Hikari no Tsubasa" *.k5
; 0040CF80 k4_read

	dw _conv_k5-$-2
_arc_k5 PROC

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
	pop	ebx
	pop	edi
	lea	ecx, [ebx-1]
	sub	eax, 1354Bh
	shr	ecx, 14h
	or	eax, ecx
	jne	@@9a
	mov	[@@N], ebx
	shl	ebx, 8
	call	_FileSeek, [@@S], edi, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	call	_ArcUnicode, 1

@@1:	sub	esi, -80h
	call	_ArcName, esi, 20h
	and	[@@D], 0
	mov	ebx, [esi+4Ch]
	call	_FileSeek, [@@S], dword ptr [esi+48h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	sub	esi, -80h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_k5 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, '4k'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 58h
	jb	@@9
	cmp	dword ptr [esi], 201344Bh
	jne	@@9
	lea	eax, [ebx+58h-30h]
	mov	edx, [esi+4]
	sub	eax, [esi+18h]
	sub	edx, [esi+30h]
	or	eax, edx
	jne	@@9
	mov	ecx, [esi+50h]	; bits
	mov	edx, [esi+54h]	; ((bits + 7) >> 3) + 0x10
	lea	eax, [ebx+58h-48h]
	add	ecx, 7
	sub	edx, 10h
	shr	ecx, 3
	cmp	eax, [esi+4Ch]	; data_size + 0x10
	jb	@@9
	cmp	ecx, edx
	jne	@@9
	sub	eax, 10h
	jb	@@9
	cmp	eax, ecx
	jb	@@9
	cmp	ebx, eax
	jb	@@9
	movzx	ecx, word ptr [esi+3Ch]
	ror	ecx, 3
	dec	ecx
	cmp	ecx, 4
	jae	@@9
	dec	ecx
	je	@@9
	lea	eax, [ecx+2]
	add	ecx, 19h+4
	movzx	edi, word ptr [esi+30h]
	movzx	edx, word ptr [esi+32h]
	imul	ebx, eax
	add	ebx, 3
	and	ebx, -4
	imul	ebx, edx
	cmp	eax, 3
	je	@@1b
	dec	eax
	jne	@@1a
	add	ebx, 400h
@@1a:	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	call	@@Unpack, edi, ebx, esi, [@@SC]
	call	_tga_align4, edi
	clc
	leave
	ret

@@1b:	cmp	dword ptr [esi+48h], 0
	je	@@1a
	mov	eax, [@@SC]
	sub	eax, 30h
	sub	eax, [esi+44h]
	jb	@@1a
	mov	ecx, [esi+48h]
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
	push	eax	; @@SC

	call	_ArcTgaAlloc, 3, edi, edx
	lea	edi, [eax+12h]
	call	@@Unpack, edi, ebx, esi, [@@SC]
	mov	edx, [esi+44h]
	lea	edx, [esi+30h+edx]
	call	@@Alpha, edi, edx
	clc
	leave
	ret

@@Alpha PROC

@@D = dword ptr [ebp+14h]
@@SB = dword ptr [ebp+18h]
@@SC = dword ptr [ebp+1Ch]

@@H = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@D]
	movzx	edx, word ptr [esi-12h+0Ch]
	movzx	ebx, word ptr [esi-12h+0Eh]
	lea	eax, [edx*2+edx+3]
	mov	edi, edx
	and	al, -4
	imul	edi, ebx
	imul	eax, ebx
	lea	edi, [esi+edi*4]
	add	esi, eax
	push	ebx	; @@H
@@1a:	mov	eax, edx
	mov	ecx, edx
	and	eax, 3
	sub	esi, eax
@@1b:	sub	esi, 3
	sub	edi, 4
	mov	eax, [esi]
	or	eax, 0FF000000h
	mov	[edi], eax
	dec	ecx
	jne	@@1b
	dec	ebx
	jne	@@1a

	mov	eax, [@@H]
	shl	eax, 2
	mov	esi, [@@SB]
	cmp	[@@SC], eax
	jb	@@9
@@2:	mov	eax, [@@H]
	mov	esi, [@@SB]
	mov	ebx, [@@SC]
	mov	eax, [esi+eax*4-4]
	push	edx
	sub	ebx, eax
	jb	@@2d
	shr	ebx, 1
	add	esi, eax
@@2a:	dec	ebx
	js	@@2d
	lodsw
	movzx	ecx, ah
	mov	ah, 0
	test	ecx, ecx
	je	@@2c
	imul	eax, 0FFh
	shr	eax, 7
	sub	edx, ecx
	jae	$+6
	add	ecx, edx
	xor	edx, edx
@@2b:	add	edi, 3
	stosb
	dec	ecx
	jne	@@2b
@@2c:	test	edx, edx
	jne	@@2a
@@2d:	lea	edi, [edi+edx*4]
	pop	edx
	dec	[@@H]
	jne	@@2
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]
@@L2 = dword ptr [ebp-0Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx

	mov	edx, [esi+54h]
	mov	eax, [esi+4Ch]
	sub	eax, edx
	lea	edx, [esi+48h+edx]
	mov	[@@SC], eax

	movzx	eax, byte ptr [esi+3Eh]
	test	eax, eax
	je	@@4a
	movzx	eax, word ptr [esi+3Ch]
	shr	eax, 3
	neg	eax
@@4a:	push	eax	; @@L0
	push	dword ptr [esi+50h]
	push	edx
	add	esi, 58h

	xor	ecx, ecx
@@1:	call	@@3
	jnc	@@1a
	dec	[@@DC]
	js	@@9
	mov	edx, [@@L0]
	mov	cl, 8
	test	edx, edx
	jne	@@2a
@@2b:	call	@@5
	stosb
	jmp	@@1

@@2a:	inc	ecx
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@2b
	call	@@5
	inc	eax
	add	al, [edi+edx]
	stosb
	jmp	@@1

@@1a:	call	@@3
	jc	@@1b
	mov	cl, 9
	call	@@5
	xchg	edx, eax
	mov	cl, 3
	call	@@5
	lea	ecx, [eax+2]
	jmp	@@1c

@@1b:	mov	cl, 0Eh
	call	@@5
	xchg	edx, eax
	mov	cl, 4
	call	@@5
	lea	ecx, [eax+3]
@@1c:	not	edx
	mov	eax, [@@DC]
	test	eax, eax
	je	@@9
	cmp	ecx, eax
	jb	$+3
	xchg	ecx, eax
	sub	[@@DC], ecx
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	cmp	[@@L0], 0
	jne	@@2c
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@2c:	push	ebx
	mov	ebx, [@@L0]
@@2d:	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, ebx
	jc	@@2e
	mov	al, [edi+edx]
	stosb
	dec	ecx
	jne	@@2d
	jmp	@@2g

@@2e:	add	eax, edx
	jnc	@@9
	push	esi
	lea	esi, [edx+ebx]
@@2f:	mov	al, [edi+edx]
	sub	al, [edi+esi]
	add	al, [edi+ebx]
	stosb
	dec	ecx
	jne	@@2f
	pop	esi
@@2g:	pop	ebx
	jmp	@@1

@@3:	dec	[@@L1]
	js	@@9
	shl	bl, 1
	jne	@@3a
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@3a:	ret

@@5:	xor	eax, eax
	push	edx
	mov	edx, [@@L2]
@@5a:	shl	bh, 1
	jne	@@5b
	dec	[@@SC]
	js	@@9
	mov	bh, [edx]
	inc	edx
	stc
	adc	bh, bh
@@5b:	adc	eax, eax
	dec	ecx
	jne	@@5a
	mov	[@@L2], edx
	pop	edx
	ret
ENDP

ENDP
