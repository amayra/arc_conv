
; "Littlewitch Romanesque (PS2)" image.bin

	dw _conv_lwrq_ps2-$-2
_arc_lwrq_ps2 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	eax
	pop	ebx
	lea	ecx, [ebx-1]
	sub	eax, 'KCAP'
	shr	ecx, 14h
	or	eax, ecx
	jne	@@9a
	mov	[@@N], ebx
	imul	ebx, 90h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	lea	edx, [esi+10h]
	call	_ArcName, edx, 80h
	and	[@@D], 0
	mov	ebx, [esi+0Ch]
	call	_FileSeek, [@@S], dword ptr [esi+8], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	mov	edi, [@@D]
	cmp	ebx, 8
	jb	@@1a
	cmp	dword ptr [edi], 'SSZL'
	jne	@@1a
	call	_MemAlloc, dword ptr [edi+4]
	jc	@@1a
	xchg	edi, eax
	add	eax, 8
	lea	ecx, [ebx-8]
	call	@@Unpack, edi, dword ptr [eax-4], eax, ecx
	xchg	ebx, eax
	call	_MemFree, [@@D]
	mov	[@@D], edi
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 90h
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
@@1:	cmp	[@@DC], 0
	je	@@7
	shr	ebx, 1
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@1a:	jnc	@@1b
	dec	[@@SC]
	js	@@9
	dec	[@@DC]
	js	@@9
	movsb
	jmp	@@1

@@1b:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
	mov	cl, dh
	shr	dh, 4
	and	ecx, 0Fh
	add	ecx, 3
	sub	[@@DC], ecx
	jae	@@1c
	add	ecx, [@@DC]
	and	[@@DC], 0
@@1c:	mov	eax, edi
	sub	eax, [@@DB]
	sub	edx, eax
	add	edx, 10h
	or	edx, -1000h
	add	eax, edx
	jns	@@2b
@@2a:	mov	byte ptr [edi], 0
	inc	edi
	dec	ecx
	je	@@1
	inc	eax
	jne	@@2a
@@2b:	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
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

ENDP

_conv_lwrq_ps2 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'dth'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 14h
	jb	@@9
	mov	ecx, [esi+10h]
	cmp	dword ptr [esi], 'DTH'
	jne	@@9
	sub	ebx, ecx
	jb	@@9
	movzx	edx, word ptr [esi+6]	; alpha_present
	movzx	eax, word ptr [esi+4]	; 0-pal16, 1-pal256, 2-32
	shr	edx, 1
	jne	@@9
	movzx	edi, word ptr [esi+8]
	movzx	edx, word ptr [esi+0Ah]
	mov	ebx, edi
	dec	eax
	js	@@2
	jne	@@1e
	cmp	ecx, 400h
	jne	@@9
	cmp	byte ptr [esi+6], 0
	je	@@1d
	call	@@1b
@@1a:	movzx	eax, byte ptr [esi]
	inc	esi
	mov	eax, [esp+eax*4]
	stosd
	dec	ebx
	jne	@@1a
	clc
	leave
	ret

@@1d:	imul	ebx, edx
	cmp	ebx, [esi+0Ch]
	jne	@@9
	call	_ArcTgaAlloc, 38h, edi, edx
	lea	edi, [eax+12h]
	add	esi, 14h
	push	ebx
	push	esi
	add	esi, ebx
	mov	ebx, 100h
	call	@@1c
	pop	esi
	pop	ecx
	rep	movsb
	clc
	leave
	ret

@@1e:	test	ecx, ecx
	jne	@@9
	imul	ebx, edx
	shl	ebx, 2
	cmp	ebx, [esi+0Ch]
	jne	@@9
	call	_ArcTgaAlloc, 23h, edi, edx
	lea	edi, [eax+12h]
	add	esi, 14h
	shr	ebx, 2
	call	@@1c
	clc
	leave
	ret

@@2:	cmp	ecx, 40h
	jne	@@9
	shr	ebx, 1
	jc	@@9
	call	@@1b
@@2a:	movzx	eax, byte ptr [esi]
	inc	esi
	mov	edx, eax
	and	eax, 0Fh
	shr	edx, 4
	mov	eax, [esp+eax*4]
	stosd
	mov	eax, [esp+edx*4]
	stosd
	dec	ebx
	jne	@@2a
	clc
	leave
	ret

@@1b:	imul	ebx, edx
	cmp	ebx, [esi+0Ch]
	jne	@@9
	call	_ArcTgaAlloc, 23h, edi, edx
	lea	edi, [eax+12h]
	pop	eax
	mov	ecx, [esi+10h]
	add	esi, 14h
	sub	esp, ecx
	shr	ecx, 2
	mov	edx, esp
	push	eax
	push	ebx
	push	esi
	push	edi
	add	esi, ebx
	mov	edi, edx
	mov	ebx, ecx
	call	@@1c
	pop	edi
	pop	esi
	pop	ebx
	ret

@@1c:	lodsd
	bswap	eax
	movzx	edx, al
	mov	ecx, edx
	shl	edx, 8
	sub	edx, ecx
	shr	edx, 7
	mov	al, dl
	ror	eax, 8
	stosd
	dec	ebx
	jne	@@1c
	ret
ENDP
