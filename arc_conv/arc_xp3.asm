
; "Fate/stay night", "Fate/hollow ataraxia", "Smile Cubic!", "Swan Song", "Sharin no Kuni, Himawari no Shoujo", "Hagukumi Sacrifice 1" *.xp3

	dw _conv_xp3-$-2
_arc_xp3 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@P
@M0 @@L1, 14h
@M0 @@L2
@M0 @@L4, 0Ch

	enter	@@stk, 0
	call	_xp3_findsign, [@@S]
	mov	[@@P], eax
	lea	esi, [@@M]
	call	_xp3_arc_load, [@@S], eax, esi
	jc	@@9a
	xchg	ebx, eax
	mov	esi, [esi]
	call	_ArcDbgData, esi, ebx
	mov	[@@L1], esi
	mov	[@@L1+4], ebx
	call	@@5
	call	_ArcCount, ebx
	call	_ArcUnicode, 1

	call	_ArcParam
	db 'xp3', 0
	call	_xp3_select, eax
	mov	[@@L2], eax

@@1:	lea	edi, [@@L1]
	call	_xp3_next, edi
	jc	@@8
	mov	esi, [@@L1+8]
	movzx	ecx, word ptr [esi+14h]
	lea	edx, [esi+16h]
	call	_ArcName, edx, ecx
	and	[@@D], 0

	mov	ebx, [esi+4]
	cmp	dword ptr [esi+8], 0
	jne	@@1a
	mov	[@@L4], ebx
	call	_MemAlloc, ebx
	jc	@@1a
	mov	[@@D], eax

	mov	esi, [@@L1+0Ch]
	mov	ecx, [esi-8]
	xor	ebx, ebx
	mov	[@@L4+4], ecx
@@4:	xor	eax, eax
	sub	[@@L4+4], 1Ch
	jb	@@1a
	mov	edi, [esi+10h]
	cmp	[@@L4], eax
	je	@@1a
	neg	edi
	sbb	edi, edi
	or	edi, [esi+0Ch]
	je	@@4b
	cmp	dword ptr [esi], 2
	jae	@@1a
	mov	eax, [esi+4]
	mov	edx, [esi+8]
	add	eax, [@@P]
	adc	edx, 0
	jc	@@1a
	call	_FileSeek64, [@@S], eax, edx, 0
	jc	@@1a

	mov	eax, [@@L4]
	cmp	edi, eax
	jb	$+3
	xchg	edi, eax
	sub	[@@L4], edi

	cmp	dword ptr [esi], 0	; 1 == packed
	jne	@@4a
	mov	edx, [@@D]
	add	edx, ebx
	call	_FileRead, [@@S], edx, edi
	jmp	@@4b

@@4a:	cmp	dword ptr [esi+18h], 0
	jne	@@1a
	call	_MemAlloc, dword ptr [esi+14h]
	jc	@@1a
	mov	[@@L4+8], eax
	call	_FileRead, [@@S], eax, dword ptr [esi+14h]
	mov	edx, [@@D]
	add	edx, ebx
	call	_zlib_unpack, edx, edi, [@@L4+8], eax
	push	eax
	call	_MemFree, [@@L4+8]
	pop	eax
@@4b:	add	ebx, eax
	add	esi, 1Ch
	cmp	edi, eax
	je	@@4
@@1a:
	mov	edi, [@@L2]
	test	edi, edi
	je	@@1c
	call	_ArcGetName
	call	_xp3_crypt, 0, edi, [@@L1+10h], [@@D], ebx, eax
@@1c:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	cmp	[@@L1], 0
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5:	sub	esp, 0Ch
	push	ebx
	xor	ebx, ebx
@@5a:	push	esi
	call	_xp3_next, esp
	pop	esi
	sbb	ebx, -1
	test	esi, esi
	jne	@@5a
	add	esp, 10h
	ret
ENDP

; db "TLG0.0 sds",1Ah
; dd include_size

_conv_xp3 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'glt'
	je	@@1
	cmp	eax, 'sk'
	je	@@4
	cmp	eax, 'sjt'
	je	@@4
@@9:	stc
	leave
	ret

@@4:	cmp	ebx, 5
	jb	@@9
	cmp	word ptr [esi], 0FEFEh
	jne	@@9
	cmp	byte ptr [esi+2], 1
	jne	@@9
	cmp	word ptr [esi+3], 0FEFFh
	jne	@@9
	call	@@3
	cmp	eax, XP3_AVATAR		; "Gensou no Avatar"
	jne	@@9
	lea	ecx, [ebx-5]
	lea	edi, [esi+5]
	sub	ebx, 3
	add	esi, 3
	shr	ecx, 1
	je	@@4b
	push	ebx
	mov	ebx, 55555555h
@@4a:	movzx	eax, word ptr [edi]
	mov	edx, eax
	shr	eax, 1
	and	edx, ebx
	and	eax, ebx
	shl	edx, 1
	add	eax, edx
	stosw
	dec	ecx
	jne	@@4a
	pop	ebx
@@4b:	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@1:	mov	edi, offset @@sign
	push	0Bh
	pop	ecx
	cmp	ebx, ecx
	jb	@@1a
	push	esi
	rep	cmpsb
	pop	esi
	jne	@@1a
	sub	ebx, 0Fh
	jb	@@9
	mov	eax, [esi+0Bh]
	add	esi, 0Fh
	mov	[@@SB], esi
	sub	ebx, eax
	jb	@@9
	xchg	ebx, eax
@@1a:	add	edi, ecx
	call	@@3
	; "Okiba ga Nai!", "Lovely x Cation"
	cmp	ebx, 6
	jb	@@1c
	mov	eax, [esi]
	shl	eax, 8
	cmp	eax, 58585800h
	jne	@@1c
	movzx	eax, byte ptr [esi+3]
	mov	ah, al
	cmp	[esi+4], ax
	jne	@@1c
	sub	al, 'Y'
	mov	ah, 0
	cmp	al, 2
	jae	@@1c
	lea	ecx, [eax*2+eax+14h]
	cmp	ebx, ecx
	jb	@@1c
	xor	byte ptr [esi+ecx-8], 0ABh
	xor	byte ptr [esi+ecx-4], 0ACh
	shl	eax, 18h
	add	eax, '5GLT'
	mov	[esi], eax
	mov	word ptr [esi+4], '0.'
@@1c:
	sub	ebx, 18h
	jb	@@9
	cmp	byte ptr [esi+3], '6'
	je	@@2
	mov	ecx, '5GLT'
	mov	edx, 07200302Eh
	mov	eax, [esi+8]
	sub	edx, [esi+4]
	sub	eax, 0031A7761h
	sub	ecx, [esi]
	rol	eax, 8
	or	ecx, edx
	shr	eax, 1
	or	eax, ecx
	jne	@@9
	mov	edx, [esi+14h]
	mov	ecx, edx
	dec	edx
	shr	edx, 10h
	jne	@@9
	mov	edi, [esi+0Ch]
	mov	eax, [esi+10h]
	push	eax
	lea	eax, [eax+ecx-1]
	xor	edx, edx
	div	ecx
	shl	eax, 2
	pop	edx
	sub	ebx, eax
	jb	@@9
	movzx	ecx, byte ptr [esi+0Bh]
	lea	esi, [esi+18h+eax]
	push	ecx	; @@L0
	add	ecx, 20h-1
	call	_ArcTgaAlloc, ecx, edi, edx
	xchg	edi, eax
	add	edi, 12h
	call	@@TLG5, edi, 0, esi, ebx, [@@SB]
	clc
	leave
	ret

@@2:	sub	ebx, 7
	jb	@@9
	push	0Bh
	pop	ecx
	repe	cmpsb
	jne	@@9
	mov	ecx, [esi]
	sub	ecx, 3
	shr	ecx, 1
	jne	@@9
	mov	[@@SC], ebx
	mov	edi, [esi+4]
	mov	edx, [esi+8]
	lea	ebx, [edi*8+edi]
	lea	eax, [edi+7]
	lea	ecx, [edx+7]
	shr	eax, 3
	shr	ecx, 3
	imul	eax, ecx
	push	eax	; @@L0
	lea	ebx, [ebx*4+eax+1000h]
	call	_ArcTgaAlloc, 23h, edi, edx
	xchg	edi, eax
	add	edi, 12h
	call	_MemAlloc, ebx
	jc	@@9
	pop	ecx
	push	eax
	call	@@TLG6, edi, ecx, esi, [@@SC], eax
	call	_MemFree
	clc
	leave
	ret

@@3:	push	esi
	call	_ArcLocal, 0
	xchg	esi, eax
	jnc	@@3a
	call	_ArcParam
	db 'xp3', 0
	call	_xp3_select, eax
	mov	[esi], eax
@@3a:	lodsd
	pop	esi
	ret

@@TLG5 PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]

@@W = dword ptr [ebp-4]
@@H = dword ptr [ebp-8]
@@Y = dword ptr [ebp-0Ch]
@@A = dword ptr [ebp-10h]
@@L1 = dword ptr [ebp-14h]
@@L2 = dword ptr [ebp-18h]
@@L3 = dword ptr [ebp-1Ch]
@@L4 = dword ptr [ebp-20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@L0]

	movzx	ecx, byte ptr [esi+0Bh]
	xor	eax, eax
	dec	ecx
	push	dword ptr [esi+0Ch]
	push	dword ptr [esi+10h]
	push	dword ptr [esi+14h]
	push	ecx
	push	eax
	push	eax
	push	eax
	push	dword ptr [esi+10h]
	sub	esp, 0FFCh
	push	ecx	; 24h
	mov	edi, esp
	mov	ecx, 1000h/4
	rep	stosd

	mov	edi, [@@DB]
	mov	esi, [@@SB]
@@2:	mov	eax, [@@Y]
	mov	ecx, [@@H]
	mov	ebx, [@@W]
	cmp	ecx, eax
	jb	$+3
	xchg	ecx, eax
	imul	ebx, ecx
	mov	[@@L0], ebx
	sub	[@@SC], 5
	jb	@@9
	movzx	edx, byte ptr [esi]
	inc	esi
	lodsd
	test	edx, edx
	je	@@2b
	sub	ebx, eax
	jb	@@9
	test	eax, eax
	je	@@2d
	xchg	ecx, eax
	sub	[@@SC], ecx
	jb	@@9
@@2a:	movsb
	add	edi, [@@A]
	dec	ecx
	jne	@@2a
	jmp	@@2d

@@2b:	mov	[@@DC], ebx
	sub	[@@SC], eax
	jb	@@9
	mov	[@@L3], eax
	xor	ebx, ebx
@@1:	cmp	[@@L3], 0
	je	@@2c
	shr	bl, 1
	jne	@@1c
	dec	[@@L3]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@1c:	jc	@@1a
	dec	[@@DC]
	js	@@9
	dec	[@@L3]
	js	@@9
	lodsb
	mov	edx, [@@L1]
	and	edx, 0FFFh
	mov	[esp+edx], al
	inc	edx
	stosb
	add	edi, [@@A]
	mov	[@@L1], edx
	jmp	@@1

@@1a:	sub	[@@L3], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	add	esi, 2
	mov	ecx, edx
	shr	ecx, 0Ch
	add	ecx, 3
	cmp	ecx, 12h
	jb	@@1b
	dec	[@@L3]
	js	@@9
	xor	eax, eax
	lodsb
	movzx	eax, al
	add	ecx, eax
@@1b:	sub	[@@DC], ecx
	jb	@@9
	push	esi
	mov	esi, [@@L1]
@@1d:	and	edx, 0FFFh
	and	esi, 0FFFh
	mov	al, [esp+4+edx]
	inc	edx
	mov	[esp+4+esi], al
	inc	esi
	stosb
	add	edi, [@@A]
	dec	ecx
	jne	@@1d
	mov	[@@L1], esi
	pop	esi
	jmp	@@1

@@2c:	mov	ebx, [@@DC]
@@2d:	mov	edx, [@@A]
	inc	edx
	imul	ebx, edx
	add	edi, ebx
	mov	ebx, [@@L0]
	inc	edi
	imul	ebx, edx
	sub	edi, ebx
	mov	ecx, [@@L2]
	inc	ecx
	cmp	ecx, edx
	mov	[@@L2], ecx
	jb	@@2
	sub	edi, ecx
	mov	eax, [@@Y]
	add	edi, ebx
	and	[@@L2], 0
	sub	[@@H], eax
	ja	@@2
	mov	edi, [@@DB]
	mov	ebx, [@@W]
	mov	esi, ebx
	imul	esi, ecx
	neg	esi
	xor	eax, eax
	xor	edx, edx
@@4a:	mov	ecx, [edi]
	add	al, ch
	add	ah, ch
	add	dl, ch
	add	al, cl
	shr	ecx, 10h
	add	dl, cl
	add	dh, ch
	mov	[edi], ax
	mov	[edi+2], dl
	add	edi, 3
	cmp	[@@A], 3
	jne	@@4d
	mov	[edi], dh
	inc	edi
@@4d:	dec	ebx
	jne	@@4a
@@4b:	mov	ebx, [@@W]
	dec	[@@L4]
	je	@@7
	xor	eax, eax
	xor	edx, edx
@@4c:	mov	ecx, [edi]
	add	al, ch
	add	ah, ch
	add	dl, ch
	add	al, cl
	shr	ecx, 10h
	add	dl, cl
	add	dh, ch
	mov	ecx, [edi+esi]
	add	cl, al
	add	ch, ah
	mov	[edi], cx
	shr	ecx, 10h
	add	cl, dl
	add	ch, dh
	mov	[edi+2], cl
	add	edi, 3
	cmp	[@@A], 3
	jne	@@4e
	mov	[edi], ch
	inc	edi
@@4e:	dec	ebx
	jne	@@4c
	jmp	@@4b

@@7:	xor	esi, esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

@@TLG6 PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]

@@L1 = dword ptr [ebp-4]
@@L2 = dword ptr [ebp-8]
@@H = dword ptr [ebp-0Ch]
@@W = dword ptr [ebp-10h]
@@C = dword ptr [ebp-14h]
@@L3 = dword ptr [ebp-18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@SB]
	mov	edi, [@@L0]
	mov	eax, [esi+10h]
	sub	[@@SC], eax
	jb	@@9
	push	eax			; @@L1
	push	dword ptr [esi+0Ch]	; @@L2
	push	dword ptr [esi+8]	; @@H
	push	dword ptr [esi+4]	; @@W
	push	dword ptr [esi]		; @@C
	add	esi, 14h

	mov	eax, [@@W]
	lea	eax, [eax*8+eax]
	lea	edi, [edi+eax*4]

	xor	ecx, ecx
	mov	edx, 1010101h
@@2a:	xor	eax, eax
@@2b:	mov	[edi], ecx
	mov	[edi+4], eax
	add	eax, edx
	add	edi, 8
	cmp	al, 10h
	jb	@@2b
	add	ecx, edx
	cmp	cl, 20h
	jb	@@2a
	push	edi	; @@L3

	xor	ebx, ebx
@@1:	cmp	[@@DC], 0
	je	@@2c
	call	@@3
	jc	@@1a
	dec	[@@L1]
	js	@@9
	movsb
	dec	[@@DC]
	jmp	@@1

@@1a:	sub	[@@L1], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	add	esi, 2
	mov	ecx, edx
	shr	ecx, 0Ch
	add	ecx, 3
	cmp	ecx, 12h
	jb	@@1b
	dec	[@@L1]
	js	@@9
	xor	eax, eax
	lodsb
	add	ecx, eax
@@1b:	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@L3]
	sub	edx, eax
	or	edx, -1000h
	push	esi
	lea	esi, [edi+edx]
	rep	movsb
	pop	esi
	jmp	@@1

@@2c:	cmp	[@@L1], 0
	jne	@@9

	; 005A21A8
	push	esi
	xor	ebx, ebx
	mov	esi, offset @@T
@@2d:	mov	edi, [@@L0]		; 006B2A38
	xor	eax, eax
	add	edi, ebx
@@2e:	movzx	ecx, word ptr [esi]
	add	esi, 2
@@2f:	stosb
	add	edi, 3
	dec	ecx
	jne	@@2f
	inc	eax
	cmp	eax, 9
	jb	@@2e
	inc	ebx
	cmp	ebx, 4
	jb	@@2d
	pop	esi
	sub	edi, 3
	mov	ecx, [@@W]
	xor	eax, eax
	rep	stosd

	xor	ecx, ecx
@@2g:	mov	ebx, [@@H]		; height
	push	8
	pop	eax
	sub	ebx, ecx
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	mov	edx, [@@W]		; width
	imul	ebx, edx
	mov	edi, [@@L3]
	shl	edx, 3
@@2h:	neg	edx
	push	ebx
	push	ecx
	lea	edi, [edi+edx*4]
	sub	[@@SC], 4
	jb	@@9
	lodsd
	lea	edx, [eax+7]
	shr	eax, 1Eh
	jne	@@9
	shr	edx, 3
	sub	[@@SC], edx
	jb	@@9
	xor	ecx, ecx
	mov	[@@L1], edx
	mov	[@@DC], ebx
	push	ecx
	xor	ebx, ebx
	call	@@3
	jc	@@5b
@@5:	call	@@4
	sub	[@@DC], eax
	jb	@@9
	xchg	ecx, eax
	xor	eax, eax
@@5a:	stosb
	add	edi, 3
	dec	ecx
	jne	@@5a
	cmp	[@@DC], ecx
	je	@@5j
@@5b:	call	@@4
	sub	[@@DC], eax
	jb	@@9
	xchg	ecx, eax
@@5c:	push	ecx
	xor	ecx, ecx
	call	@@3
	jc	@@5f
	lea	eax, [ebx-1]
	xor	edx, edx
	and	eax, ebx
@@5d:	test	eax, eax
	jne	@@5e
	dec	[@@L1]
	js	@@9
	movzx	eax, byte ptr [esi]
	inc	edx
	inc	esi
	cmp	edx, 4
	jb	@@5d
	xchg	ecx, eax
	xor	ebx, ebx
	jmp	@@5f
@@5e:	sub	esi, edx	
	add	[@@L1], edx
	call	@@4a
@@5f:	xchg	eax, ecx
	movzx	ecx, word ptr [esp+4]
	movzx	edx, word ptr [esp+6]
	cmp	ch, 4
	lea	ecx, [ecx*4+edx]
	jae	@@9
	add	ecx, [@@L0]
	movzx	ecx, byte ptr [ecx]
	test	ecx, ecx
	je	@@5h
	shl	eax, cl
	push	ecx
@@5g:	call	@@3
	rcr	eax, 1
	dec	ecx
	jne	@@5g
	pop	ecx
	rol	eax, cl
@@5h:	pop	ecx
	shr	eax, 1
	cmc
	sbb	edx, edx
	add	[esp], eax
	xor	eax, edx
	lea	eax, [eax+edx+1]
	stosb
	add	edi, 3
	inc	byte ptr [esp+2]
	and	byte ptr [esp+2], 3
	jne	@@5i
	shr	dword ptr [esp], 1
@@5i:	dec	ecx
	jne	@@5c
	cmp	[@@DC], ecx
	jne	@@5
@@5j:	pop	ecx
	mov	eax, [@@L1]
	cmp	eax, 4
	jae	@@9
	add	esi, eax
	pop	ecx
	pop	ebx
	inc	ecx
	inc	edi
	mov	eax, ecx
	mov	edx, ebx
	and	eax, 7
	cmp	eax, [@@C]
	jb	@@2h
	sub	ecx, eax
	push	ecx
	call	@@6, ecx, [@@L3], [@@DB], [@@W], [@@H]
	pop	ecx
	add	ecx, 8
	cmp	ecx, [@@H]		; height
	jb	@@2g

	cmp	[@@C], 4
	je	@@7
	mov	edi, [@@DB]
	mov	ecx, [@@W]
	imul	ecx, [@@H]
@@7a:	mov	byte ptr [edi+3], 0FFh
	add	edi, 4
	dec	ecx
	jne	@@7a
@@7:	xor	esi, esi
@@9:	xor	eax, eax
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h

@@3:	shr	ebx, 1
	jne	@@3a
	dec	[@@L1]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@3a:	ret

@@4a:	; ecx == 0
	xor	eax, eax
@@4b:	cmp	ecx, 20h
	jae	@@9
	inc	ecx
	call	@@3
	jnc	@@4b
	ret
@@4:	call	@@4a
	dec	ecx
	je	@@4d
	push	ecx
@@4c:	call	@@3
	rcr	eax, 1
	dec	ecx
	jne	@@4c
	pop	ecx
@@4d:	inc	eax
	rol	eax, cl
	ret

@@6 PROC

@@Y = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@D = dword ptr [ebp+1Ch]
@@W = dword ptr [ebp+20h]
@@H = dword ptr [ebp+24h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ebx, [@@Y]
	mov	edx, [@@H]
	lea	eax, [ebx+8]
	and	eax, -8
	cmp	eax, edx
	jb	$+3
	xchg	eax, edx
	push	eax	; y_max

@@1:	mov	ecx, [@@W]
	shr	ecx, 3
	je	@@1a
	xor	edx, edx
	lea	esi, [edx+8]
	call	@@5
@@1a:	mov	esi, [@@W]
	mov	edx, esi
	and	esi, 7
	je	@@1b
	shr	edx, 3
	lea	ecx, [edx+1]
	call	@@5
@@1b:	inc	ebx
	cmp	ebx, [ebp-4]
	jb	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h

@@5:	lea	eax, [ebx+1]
	push	eax	; (~y) & 1
	mov	edi, ebx
	and	edi, 7
	mov	eax, [ebp-4]
	sub	eax, ebx
	dec	eax
	sub	eax, edi
	push	eax	; y_max - y - 1 - (y & 7)
	push	0	; prev_color
	mov	eax, ebx
	and	eax, 7
	imul	esi, eax
	mov	eax, [@@W]
	shl	eax, 3
	sub	esi, eax
	shl	esi, 2
	add	esi, [@@S]
	push	esi	; coef
	mov	edi, ebx
	and	edi, -8
	mov	eax, [ebp-4]
	sub	eax, edi
	shl	eax, 3
	push	eax	; (y_max - (y & -8)) << 3
	mov	eax, [@@W]
	add	eax, 7
	shr	edi, 3
	shr	eax, 3
	imul	edi, eax
	add	edi, [@@S]
	push	edi	; coef_small + (y >> 3) * ((w + 7) >> 3)
	push	ecx	; end
	push	edx	; start
	mov	ecx, [@@W]
	push	ecx	; w
	mov	edi, ebx
	shl	ecx, 2
	imul	edi, ecx
	add	edi, [@@D]
	mov	edx, edi
	test	ebx, ebx
	jne	@@5a
	; zero line
	mov	edx, [@@W]
	mov	eax, [@@S]
	neg	edx
	lea	edx, [edx*8+edx]
	lea	edx, [eax+edx*4]
	jmp	@@5b
;	imul	ecx, [@@H]
;	neg	ecx
@@5a:	sub	edx, ecx
@@5b:	call	@@3, edx, edi	; prev_line, dest_line
	add	esp, 2Ch
	ret

@@3 PROC	; 005BEDCC

@@P0 = dword ptr [ebp+8]
@@D = dword ptr [ebp+0Ch]
@@W = dword ptr [ebp+10h]
@@I = dword ptr [ebp+14h]
@@N = dword ptr [ebp+18h]
@@P5 = dword ptr [ebp+1Ch]
@@P6 = dword ptr [ebp+20h]
@@S = dword ptr [ebp+24h]
@@P8 = dword ptr [ebp+28h]
@@P9 = dword ptr [ebp+2Ch]
@@A = dword ptr [ebp+30h]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]
@@C = @@D

@@MMX = 0

	enter	8, 0
	push	ebx
	push	esi
	push	edi
	mov	edi, [@@D]
	mov	esi, [@@S]
	mov	ecx, [@@P8]
	sub	[@@P0], edi
	mov	edx, ecx
	cmp	[@@I], 0
	je	@@1d
	mov	edx, [@@P6]
	imul	edx, [@@I]
	lea	esi, [esi+edx*4]
	mov	edx, [@@I]
	shl	edx, 3+2
	add	edi, edx
	mov	edx, [@@P0]
	mov	ecx, [edi-4]
	mov	edx, [edi+edx-4]
@@1d:	mov	[@@P8], edx
	mov	[@@L1], ecx

	mov	edx, [@@A]
	and	edx, 1
	lea	edx, [edx+edx-1]
	shl	edx, 2
	mov	[@@A], edx

	mov	ebx, [@@I]
@@1:	mov	eax, ebx
	mov	ecx, [@@W]
	shl	eax, 3
	sub	ecx, eax
	cmp	ecx, 8
	jb	@@1a
	push	8
	pop	ecx
@@1a:	cmp	[@@A], 0
	jns	@@1b
	lea	esi, [esi+ecx*4-4]
@@1b:	test	bl, 1
	je	@@1c
	mov	eax, [@@P9]
	imul	eax, ecx
	lea	esi, [esi+eax*4]
@@1c:	mov	[@@I], ebx
	add	ebx, [@@P5]
	movzx	eax, byte ptr [ebx]
	cmp	al, 20h
	jae	@@9
	mov	ebx, [@@P0]
	mov	edx, [@@L1]
	mov	[@@C], ecx
	push	ecx
	shr	eax, 1
	mov	[@@L0], eax
	jc	@@4

if @@MMX
@@3:	mov	ecx, [@@L0]
	call	@@5
	movd	mm4, eax
	movd	mm1, [edi+ebx]
	movd	mm2, [@@P8]
	movd	[@@P8], mm1
	movd	mm0, edx
	movq	mm3, mm0
	pmaxub	mm0, mm1
	pminub	mm1, mm3
	paddb	mm4, mm0
	pminub	mm0, mm2
	paddb	mm4, mm1
	pmaxub	mm0, mm1
	psubb	mm4, mm0
	movd	[edi], mm4
	add	edi, 4
	movd	edx, mm4
	add	esi, [@@A]
	dec	[@@C]
	jne	@@3
	jmp	@@2

@@4:	mov	ecx, [@@L0]
	call	@@5
	movd	mm4, eax
	movd	mm1, [edi+ebx]
	movd	mm2, [@@P8]
	movd	[@@P8], mm1
	movd	mm0, edx
	pavgb	mm0, mm1
	paddb	mm4, mm0
	movd	[edi], mm4
	add	edi, 4
	movd	edx, mm4
	add	esi, [@@A]
	dec	[@@C]
	jne	@@4
else
@@3:	mov	ecx, [@@L0]
	call	@@5
	mov	ecx, [edi+ebx]
	mov	ebx, [@@P8]
	mov	[@@P8], ecx
rept 2
	cmp	dl, cl
	jae	$+4
	xchg	dl, cl
	cmp	dh, ch
	jae	$+4
	xchg	dh, ch
	add	al, dl
	add	ah, dh
	cmp	dl, bl
	jb	$+4
	mov	dl, bl
	cmp	dh, bh
	jb	$+4
	mov	dh, bh
	add	al, cl
	add	ah, ch
	cmp	dl, cl
	jae	$+4
	xchg	dl, cl
	cmp	dh, ch
	jae	$+4
	xchg	dh, ch
	sub	al, dl
	sub	ah, dh
	rol	ecx, 10h
	rol	eax, 10h
	rol	edx, 10h
	rol	ebx, 10h
endm
	mov	ebx, [@@P0]
	stosd
	add	esi, [@@A]
	xchg	edx, eax
	dec	[@@C]
	jne	@@3
	jmp	@@2

@@4:	mov	ecx, [@@L0]
	call	@@5
	mov	ecx, [edi+ebx]
	mov	[@@P8], ecx
rept 2
	stc
	adc	dl, cl
	rcr	dl, 1
	stc
	adc	dh, ch
	rcr	dh, 1
	add	al, dl
	add	ah, dh
	rol	ecx, 10h
	rol	eax, 10h
	rol	edx, 10h
endm
	stosd
	add	esi, [@@A]
	xchg	edx, eax
	dec	[@@C]
	jne	@@4
endif

@@2:	mov	[@@L1], edx
	pop	ecx
	mov	edx, [@@P6]
	mov	ebx, [@@I]
	cmp	[@@A], 0
	js	@@2a
	sub	edx, ecx
	dec	edx
@@2a:	lea	esi, [esi+edx*4+4]
	test	bl, 1
	je	@@2b
	mov	eax, [@@P9]
	imul	eax, ecx
	shl	eax, 2
	sub	esi, eax
@@2b:	inc	ebx
	cmp	ebx, [@@N]
	jb	@@1
@@9:
if @@MMX
	emms
endif
	pop	edi
	pop	esi
	pop	ebx
	leave
	ret

@@5 PROC
	mov	eax, offset @@T
	movzx	ecx, word ptr [eax+ecx*2]
	add	ecx, eax
	mov	eax, [esi]
	rol	eax, 10h
	jmp	ecx

@@T	dw @@0-@@T
	dw @@1-@@T
	dw @@2-@@T
	dw @@3-@@T
	dw @@4-@@T
	dw @@5-@@T
	dw @@6-@@T
	dw @@7-@@T
	dw @@8-@@T
	dw @@9-@@T
	dw @@A-@@T
	dw @@B-@@T
	dw @@C-@@T
	dw @@D-@@T
	dw @@E-@@T
	dw @@F-@@T

@@0:	rol	eax, 10h
	ret

@@1:	add	al, [esi+1]
	rol	eax, 10h
	add	al, [esi+1]
	ret

@@2:	add	al, [esi]
	add	al, [esi+1]
	rol	eax, 10h
	add	ah, [esi]
	ret

@@3:	rol	eax, 10h
	add	ah, [esi+2]
	add	al, [esi+1]
	add	al, [esi+2]
	ret

@@4:	add	al, [esi]
	add	al, [esi+1]
	add	al, [esi+2]
	rol	eax, 10h
	add	ah, [esi]
	add	ah, [esi+2]
	add	al, [esi+2]
	ret

@@5:	rol	eax, 10h
	add	ah, [esi]
	add	ah, [esi+2]
	add	al, [esi+2]
	ret

@@6:	rol	eax, 10h
	add	al, [esi+1]
	ret

@@7:	rol	eax, 10h
	add	ah, [esi]
	ret

@@8:	add	al, [esi+1]
	rol	eax, 10h
	ret

@@9:	add	al, [esi]
	rol	eax, 10h
	add	ah, [esi]
	add	ah, [esi+2]
	add	al, [esi]
	add	al, [esi+1]
	add	al, [esi+2]
	ret

@@A:	rol	eax, 10h
	add	ah, [esi+2]
	add	al, [esi+2]
	ret

@@B:	add	al, [esi]
	rol	eax, 10h
	add	ah, [esi]
	ret

@@C:	add	al, [esi]
	rol	eax, 10h
	add	ah, [esi]
	add	ah, [esi+2]
	ret

@@D:	add	al, [esi]
	add	al, [esi+1]
	rol	eax, 10h
	add	ah, [esi]
	add	ah, [esi+1]
	add	ah, [esi+2]
	add	al, [esi+1]
	ret

@@E:	add	al, [esi]
	add	al, [esi+1]
	add	al, [esi+2]
	rol	eax, 10h
	add	ah, [esi+2]
	add	al, [esi+1]
	add	al, [esi+2]
	ret

@@F:	add	al, [esi]
	add	al, [esi]
	rol	eax, 10h
	add	ah, [esi]
	add	ah, [esi]
	ret
ENDP	; @@5

ENDP	; @@3

ENDP	; @@6

ALIGN 4
@@T	dw 2, 3, 9, 12h, 21h, 3Dh, 81h, 102h, 1FFh	; sum = 0x400
	dw 2, 5, 0Ch, 15h, 27h, 56h, 9Bh, 140h, 180h
	dw 3, 5, 0Dh, 18h, 33h, 5Fh, 0C0h, 180h, 101h
	dw 3, 7, 0Fh, 1Bh, 3Fh, 6Ch, 0DFh, 1C0h, 82h
ENDP

@@sign	db 'TLG0.0',0,'sds',1Ah
	db 'TLG6.0',0,'raw',1Ah
ENDP
