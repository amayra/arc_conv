
; "Castle Fantasia", "Castle Fantasia 2" game00.dat
; "Pia Carrot" GPC\*.IPF

	dw _conv_ipf-$-2
_arc_ipf PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	pop	ebx
	mov	eax, [esi+4]
	mov	edx, [esi+8]
	cmp	eax, 0Eh
	jb	@@9a
	sub	edx, 4
	sub	edx, ebx
	jne	@@9a
	cmp	ebx, 0Eh
	jb	@@9a
	lea	ecx, [ebx-8]
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 8, ecx, 0
	jc	@@9
	mov	esi, [@@M]
	pop	dword ptr [esi]
	pop	dword ptr [esi+4]
	call	@@5
	test	eax, eax
	je	@@9
	mov	[@@N], eax
	call	_ArcCount, eax

@@1:	lea	edx, [esi+0Ch]
	call	_ArcName, edx, -1
	and	[@@D], 0
	mov	ebx, [esi+8]
	call	_FileSeek, [@@S], dword ptr [esi+4], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, [esi]
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5 PROC
	push	ebx
	push	edi
	mov	edi, esi
	xor	edx, edx
@@1:	mov	ecx, [edi]
	add	edi, 0Ch
	sub	ebx, ecx
	jb	@@9
	cmp	ecx, 0Eh
	jb	@@9
	sub	ecx, 0Ch
	xor	eax, eax
	repne	scasb
	jne	@@9
	test	ecx, ecx
	jne	@@9
	inc	edx
	jmp	@@1

@@9:	xchg	eax, edx
	pop	edi
	pop	ebx
	ret
ENDP

ENDP

_conv_ipf PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'fpi'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	cmp	ebx, 64h
	jb	@@9
	lea	edi, [ebx-8]
	mov	eax, 'FFIR'
	mov	ecx, ' FPI'
	mov	edx, ' tmf'
	sub	eax, [esi]
	sub	edi, [esi+4]
	sub	ecx, [esi+8]
	sub	edx, [esi+0Ch]
	or	eax, ecx
	or	edx, edi
	or	eax, edx
	jne	@@9
	mov	ecx, ' lap'
	mov	eax, [esi+10h]
	xor	ecx, [esi+38h]
	sub	eax, 24h
	or	eax, ecx
	jne	@@9
	xor	edi, edi
	lea	edx, [edi+7]
@@1a:	mov	ecx, [esi+44h+edx*4]
@@1b:	shr	ecx, 1
	adc	edi, 0
	test	ecx, ecx
	jne	@@1b
	dec	edx
	jns	@@1a
	cmp	edi, [esi+40h]
	jne	@@9
	lea	ecx, [edi*2+edi+24h+3]
	and	ecx, -4
	cmp	ecx, [esi+3Ch]
	jne	@@9
	add	ecx, 60h
	sub	ebx, ecx
	jb	@@9
	add	ecx, esi
	cmp	dword ptr [ecx-20h], ' pmb'
	jne	@@9
	mov	[@@SC], ebx
	push	ecx	; @@L0
	movzx	edi, word ptr [ecx-20h+8]
	movzx	edx, word ptr [ecx-20h+0Ah]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 30h, edi, edx
	xchg	edi, eax
	add	esi, 44h
	add	edi, 12h
	xor	ecx, ecx
	mov	cl, 80h
	lea	edx, [esi+20h]
@@1c:	xor	eax, eax
	test	[esi], cl
	je	@@1d
	movzx	eax, word ptr [edx+1]
	shl	eax, 8
	mov	al, [edx]
	add	edx, 3
@@1d:	mov	[edi+2], al
	shr	eax, 8
	mov	[edi+1], al
	mov	[edi], ah
	add	edi, 3
	ror	cl, 1
	adc	esi, 0
	inc	ch
	jne	@@1c
	pop	esi	; @@L0
	call	@@Unpack, edi, ebx, esi, [@@SC]
	clc
	leave
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
@@1:	xor	eax, eax
	dec	[@@SC]
	js	@@9
	lodsb
	cmp	al, 0Eh
	jb	@@1b
	je	@@1a
	sub	al, 10h
	jb	@@7	; 0xF
	cmp	al, 10h
	jb	@@1c
@@1a:	dec	[@@DC]
	js	@@9
	stosb
	jmp	@@1

@@1b:	sub	[@@SC], 2
	jb	@@9
	movzx	ecx, byte ptr [esi]
	mov	ch, al
	inc	esi
	lodsb
	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
	rep	stosb
	jmp	@@1

@@1c:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, byte ptr [esi]
	mov	dh, al
	inc	esi
	movzx	ecx, byte ptr [esi]
	inc	esi
	not	edx
	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	push	esi
	lea	esi, [edi+edx]
	rep	movsb
	pop	esi
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
ENDP

ENDP