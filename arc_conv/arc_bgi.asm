
; "Shuffle!", "Platinum Wind" *.arc

	dw _conv_bgi-$-2
_arc_bgi PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ecx
	pop	ebx
	sub	eax, 'kcaP'
	sub	edx, 'eliF'
	sub	ecx, 20202020h
	or	eax, edx
	lea	edx, [ebx-1]
	or	eax, ecx
	mov	[@@N], ebx
	shr	edx, 14h
	or	eax, edx
	jne	@@9a
	shl	ebx, 5
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	edx, [ebx+10h]
	cmp	byte ptr [esi], 0
	je	@@9
	mov	eax, [esi+18h]
	or	eax, [esi+1Ch]
	jne	@@9
	mov	[@@P], edx
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 10h
	and	[@@D], 0
	mov	eax, [esi+18h]
	or	eax, [esi+1Ch]
	jne	@@9
	mov	eax, [esi+10h]
	mov	ebx, [esi+14h]
	add	eax, [@@P]
	jc	@@9
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	cmp	ebx, 220h
	jb	@@1a
	push	4
	pop	ecx
	mov	edi, [@@D]
	push	esi
	mov	esi, offset @@sign
	repe	cmpsd
	pop	esi
	jne	@@1a
	mov	ecx, [edi+4]
	cmp	ecx, [edi+8]
	jb	@@1a
	test	ecx, ecx
	je	@@1a
	call	_MemAlloc, ecx
	jc	@@1a
	xchg	edi, eax

	sub	esp, 0FFCh
	call	@@DSC1, [@@D], esp
	jc	@@1b
	call	@@DSC2, edi, [@@D], ebx, esp
	xchg	ebx, eax
	xchg	[@@D], edi
@@1b:	call	_MemFree, edi
	lea	esp, [ebp-@@stk]
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

@@DSC1 PROC	; 0043E270

@@S = dword ptr [ebp+14h]
@@T = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	enter	400h+800h, 0

	mov	esi, [ebp+14h]
	mov	edi, esp
	xor	eax, eax
	mov	ecx, 100h
	rep	stosd
	mov	ebx, [esi+10h]
@@1:	call	@@4
	je	@@1a
	inc	dword ptr [esp+eax*4]
@@1a:	inc	ecx
	cmp	ch, 2
	jb	@@1
	xor	edx, edx
	xor	ecx, ecx
@@1b:	mov	eax, [esp+edx*4]
	mov	[esp+edx*4], ecx
	add	ecx, eax
	inc	dl
	jne	@@1b
	mov	[@@S], ecx

	xor	ecx, ecx
	mov	ebx, [esi+10h]
@@2:	call	@@4
	je	@@2a
	mov	edx, [esp+eax*4]
	inc	dword ptr [esp+eax*4]
	shl	eax, 10h
	add	eax, ecx
	mov	[edi+edx*4], eax
@@2a:	inc	ecx
	cmp	ch, 2
	jb	@@2
	mov	esp, edi

	xor	edi, edi
	xor	edx, edx
	lea	esi, [edi+1]
	mov	ecx, [@@T]
	mov	[@@T], edi
	jmp	@@3a
@@3:	movzx	ebx, word ptr [esp+edx*4]
	inc	edx
	or	bh, 80h
	mov	[ecx+edi*4], ebx
	inc	edi
	dec	esi
	je	@@9
@@3a:	cmp	edx, [@@S]
	je	@@9
	movzx	eax, word ptr [esp+edx*4+2]
	cmp	[@@T], eax
	je	@@3
	inc	[@@T]

	mov	eax, esi
	lea	ebx, [edi+esi]
	shl	esi, 1
@@3b:	mov	[ecx+edi*4], bx
	inc	ebx
	mov	[ecx+edi*4+2], bx
	inc	ebx
	inc	edi
	dec	eax
	jne	@@3b
	jmp	@@3a

@@9:	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@4:	imul	ebx, 15A4E35h
	mov	edx, ebx
	inc	ebx
	shr	edx, 10h
	movzx	eax, byte ptr [esi+ecx+20h]
	sub	al, dl
	ret
ENDP

@@DSC2 PROC	; 0043E420

@@DB = dword ptr [ebp+14h]
@@SB = dword ptr [ebp+18h]
@@SC = dword ptr [ebp+1Ch]
@@T = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-4]
@@DC = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	mov	edx, [esi+18h]
	test	edx, edx
	je	@@9
	mov	ecx, 220h
	mov	eax, [esi+14h]
	xor	ebx, ebx
	sub	eax, edx
	push	edx
	push	eax
	add	esi, ecx
	sub	[@@SC], ecx
@@1:	mov	edx, [@@T]
	xor	ecx, ecx
@@1a:	call	@@3
	adc	ecx, ecx
	movzx	ecx, word ptr [edx+ecx*2]
	movsx	eax, word ptr [edx+ecx*4]
	test	eax, eax
	jns	@@1a
	shr	ah, 1
	jnc	@@1c
	movzx	ecx, al
	mov	edx, 100000h
	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
@@1b:	call	@@3
	adc	edx, edx
	jnc	@@1b
	inc	edx
	inc	ecx
	not	edx
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	push	esi
	lea	esi, [edi+edx]
	rep	movsb
	pop	esi
	jmp	@@1d

@@1c:	stosb
@@1d:	dec	[@@L0]
	jne	@@1
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@3:	shl	bl, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@3a:	ret
ENDP

@@sign	db 'DSC FORMAT 1.00', 0
ENDP

_conv_bgi PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	sub	ebx, 10h
	jb	@@9
	cmp	dword ptr [esi], 40h
	je	@@3
	movzx	eax, word ptr [esi+4]
	cmp	eax, 10h
	je	@@4a
	ror	eax, 3
	dec	eax
	shr	eax, 1
	or	ax, [esi+6]
	shr	eax, 1
	or	eax, [esi+8]
	or	eax, [esi+0Ch]
	je	@@4
@@4a:	sub	ebx, 20h
	jb	@@9
	mov	edi, offset @@sign
	push	4
	pop	ecx
	repe	cmpsd
	je	@@1
@@9:	stc
	leave
	ret

@@3:	cmp	ebx, 38h
	jb	@@9
	sub	ebx, 30h
	mov	edx, '  wb'
	mov	ecx, 'SggO'
	mov	eax, [esi+8]
	sub	edx, [esi+4]
	lea	edi, [esi+40h]
	sub	eax, ebx
	sub	ecx, [edi]
	or	eax, edx
	or	eax, ecx
	jne	@@9
	call	_ArcSetExt, 'ggo'
	call	_ArcData, edi, ebx
	clc
	leave
	ret

@@4:	movzx	edi, word ptr [esi]
	movzx	edx, word ptr [esi+2]
	movzx	ecx, word ptr [esi+4]
	mov	eax, edi
	shr	ecx, 3
	imul	eax, edx
	imul	eax, ecx
	cmp	ebx, eax
	jne	@@9
	add	ecx, 20h-1
	call	_ArcTgaAlloc, ecx, edi, edx
	xchg	edi, eax
	add	edi, 12h
	cmp	byte ptr [esi+6], 0
	je	@@4b
	call	@@BGDecode, edi, esi
	clc
	leave
	ret

@@4b:	mov	ecx, [@@SC]
	add	esi, 10h
	sub	ecx, 10h
	rep	movsb
	clc
	leave
	ret

@@1:	movzx	edx, word ptr [esi+4]
	ror	edx, 3
	push	edx	; @@L0
	dec	edx
	cmp	edx, 4
	jae	@@9
	dec	edx
	je	@@9
	mov	eax, [esi+18h]
	sub	ebx, eax
	jb	@@9
	dec	ah
	cmp	eax, 400h
	ja	@@9
	mov	[@@SC], ebx

	mov	ebx, [esi+14h]
	movzx	eax, word ptr [esi+1Ch]
	sub	esp, 0C00h
	push	eax
	push	dword ptr [esi+18h]
	add	esi, 20h
	xor	edx, edx
@@2a:	push	edx
	xor	ecx, ecx
	xor	edi, edi
@@2b:	dec	dword ptr [esp+4]
	js	@@9
	imul	ebx, 15A4E35h
	mov	edx, ebx
	inc	ebx
	shr	edx, 10h
	lodsb
	sub	al, dl
	sub	[esp+8], al
	xor	[esp+9], al
	mov	edx, eax
	and	edx, 7Fh
	shl	edx, cl
	add	ecx, 7
	or	edi, edx
	test	al, al
	js	@@2b
	pop	edx
	mov	[esp+8+edx*4], edi
	inc	dl
	jne	@@2a
	pop	eax
	pop	edx
	or	eax, edx
	jne	@@9
	mov	eax, esp
	call	@@HuffInit
	add	esp, 800h
	push	eax
	test	ecx, ecx
	je	@@9
	mov	eax, [@@SB]
	mov	ecx, [@@L0]
	movzx	edi, word ptr [eax+10h]
	movzx	edx, word ptr [eax+12h]
	mov	ebx, edi
	imul	ebx, edx
	imul	ebx, ecx
	add	ecx, 20h-1
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	mov	eax, [@@SB]
	call	@@Unpack, edi, ebx, esi, [@@SC], dword ptr [eax+20h]
	mov	ecx, [@@L0]
	movzx	esi, word ptr [edi-12h+0Ch]
	movzx	ebx, word ptr [edi-12h+0Eh]
	mov	[@@L0], esi
	mov	[@@SC], ebx
	movzx	esi, si
	imul	esi, ecx
	neg	esi
	xor	edx, edx
@@5a:	mov	ebx, [@@L0]
	mov	al, [edi]
	add	edi, ecx
	dec	ebx
	je	@@5c
@@5b:	add	al, [edi]
	mov	[edi], al
	add	edi, ecx
	dec	ebx
	jne	@@5b
@@5c:	inc	edx
	lea	edi, [edi+esi+1]
	cmp	edx, ecx
	jb	@@5a

@@5:	sub	edi, ecx
	sub	edi, esi
	dec	[@@SC]
	je	@@5g
	xor	edx, edx
@@5d:	mov	ebx, [@@L0]
	mov	al, [edi+esi]
	add	al, [edi]
	mov	[edi], al
	add	edi, ecx
	dec	ebx
	je	@@5f
@@5e:	add	al, [edi+esi]
	rcr	al, 1
	add	al, [edi]
	mov	[edi], al
	add	edi, ecx
	dec	ebx
	jne	@@5e
@@5f:	inc	edx
	lea	edi, [edi+esi+1]
	cmp	edx, ecx
	jb	@@5d
	jmp	@@5

@@5g:	clc
	leave
	ret

@@HuffInit PROC
	push	ebx
	push	esi
	push	edi
	push	ebp
	xchg	esi, eax
	mov	edi, esi
	xor	eax, eax
	xor	ecx, ecx
@@1:	add	ecx, [esi+eax*4]
	inc	al
	jne	@@1
	push	ecx
	lea	ebp, [esp-10h]
@@2:	mov	ah, 1
@@3:	xor	ebx, ebx
	xor	ecx, ecx
	or	edi, -1
@@4:	mov	edx, [esi+ecx*4]
	test	edx, edx
	je	@@5
	cmp	edx, edi
	jae	@@5
	mov	ebx, ecx
	mov	edi, edx
@@5:	inc	ecx
	cmp	ecx, eax
	jb	@@4
	push	ebx
	push	dword ptr [esi+ebx*4]
	and	dword ptr [esi+ebx*4], 0
	cmp	esp, ebp
	jne	@@3
	pop	edx
	pop	ebx
	pop	ecx
	add	edx, ecx
	pop	ecx
	mov	[esi+eax*4], edx
	mov	ah, 2
	xor	ch, 1
	xor	bh, 1
	mov	[esi+eax*4], cx
	mov	[esi+eax*4+2], bx
	inc	eax
	cmp	edx, [esp]
	jne	@@2
	dec	eax
	mov	ah, 0
	pop	ecx
	pop	ebp
	pop	edi
	pop	esi
	pop	ebx
	ret
ENDP

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]
@@L1 = dword ptr [ebp+28h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]

	xor	ecx, ecx
	xor	ebx, ebx
@@1:	cmp	[@@L0], ecx
	je	@@7
	push	ecx
@@1a:	call	@@4
	mov	dl, al
	and	edx, 7Fh
	shl	edx, cl
	add	ecx, 7
	or	[esp], edx
	test	al, al
	js	@@1a
	pop	ecx
	sub	[@@DC], ecx
	jb	@@9
	add	bh, 80h
	je	@@1c
	test	ecx, ecx
	je	@@1
@@1b:	call	@@4
	stosb
	dec	ecx
	jne	@@1b
	jmp	@@1

@@1c:	xor	eax, eax
	rep	stosb
	jmp	@@1

@@7:	xchg	eax, ecx
	mov	ecx, [@@DC]
	rep	stosb
	xor	esi, esi
@@9:	xchg	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h

@@5:	xor	ecx, ecx
	push	ecx
	cmp	[@@L0], ecx
	je	@@7
@@5a:	call	@@4
	mov	dl, al
	and	edx, 7Fh
	shl	edx, cl
	add	ecx, 7
	or	[esp], edx
	test	al, al
	js	@@5a
	pop	ecx
	sub	[@@DC], ecx
	jb	@@9
	ret

@@4:	dec	dword ptr [@@L0]
	js	@@9
	mov	eax, [@@L1]
@@4a:	shl	bl, 1
	jne	@@4b
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@4b:	adc	eax, eax
	movsx	eax, word ptr [@@L1+4+eax*2]
	test	ah, ah
	je	@@4a
	ret
ENDP

@@BGDecode PROC	; "Platinum Wind" *._bg
	
@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]

@@H = dword ptr [ebp-4]
@@W = dword ptr [ebp-8]
@@L0 = dword ptr [ebp-0Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@S]
	movzx	ebx, word ptr [esi+4]
	movzx	edx, word ptr [esi+2]
	movzx	eax, word ptr [esi]
	ror	ebx, 3
	push	edx
	push	eax
	push	0
	add	esi, 10h
@@1:	mov	edi, [@@D]
	add	edi, [@@L0]

	mov	edx, [@@H]
	mov	ah, 0
@@1a:	mov	ecx, [@@W]
@@1b:	lodsb
	add	al, ah
	mov	ah, al
	mov	[edi], al
	add	edi, ebx
	dec	ecx
	jne	@@1b
	dec	edx
	je	@@1d
	mov	ecx, [@@W]
	imul	ecx, ebx
	add	edi, ecx
	mov	ecx, [@@W]
	push	edi
@@1c:	sub	edi, ebx
	lodsb
	add	al, ah
	mov	ah, al
	mov	[edi], al
	dec	ecx
	jne	@@1c
	pop	edi
	dec	edx
	jne	@@1a

@@1d:	inc	[@@L0]
	cmp	[@@L0], ebx
	jne	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

@@sign	db 'CompressedBG___', 0
ENDP
