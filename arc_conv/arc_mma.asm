
; "Kyou Kara Maou!" *.mma
; ARC.dll
; 100013A0 open_archive
; 10002E40 unpack

; db 'ARC!'
; dd 24h, 14h, 1, file_cnt, 0, file_max, 1, archive_size

; dd offset, size, packed_size, header_size, flags

	dw _conv_mma-$-2
_arc_mma PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 8

	enter	@@stk+24h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 24h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ecx
	sub	eax, '!CRA'
	sub	edx, 24h
	sub	ecx, 14h
	or	eax, edx
	or	eax, ecx
	jne	@@9a
	and	[@@L0], 0
	mov	ebx, [esi+10h]
	mov	[@@N], ebx
	imul	ebx, 14h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	push	dword ptr [esi+10h]
	or	byte ptr [esi+10h], 6
	call	@@1
	pop	eax
	xor	edx, edx
	xor	ecx, ecx
	test	edi, edi
	je	@@2a
	lea	ecx, [edi+ebx]
	lea	edx, [edi+8]
	mov	[edi+4], eax
@@2a:	mov	[@@L0+4], ecx
	mov	[@@L0], edx
	call	_ArcDbgData, edi, ebx
	call	@@4
	jmp	@@8

@@2:	call	@@4
	call	_ArcName, edx, ecx
	call	@@1
	call	_ArcConv, edi, ebx
	call	_MemFree, edi
@@8:	add	esi, 14h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@2
@@9:	call	_MemFree, [@@L0]
	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@1:	and	[@@D], 0
	mov	eax, [esi+4]
	mov	ebx, [esi+8]
	or	eax, [esi+0Ch]
	or	eax, ebx
	js	@@1a
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 8, ebx, 0
	xchg	ebx, eax

	mov	edi, [@@D]
	test	edi, edi
	je	@@1a
	mov	ecx, [esi+0Ch]
	mov	edx, [esi+10h]
	mov	[edi], ecx
	mov	[edi+4], edx
	sub	ebx, ecx
	jb	@@1c
	test	byte ptr [esi+10h], 4
	je	@@1c
	lea	edx, [edi+ecx+8]
	call	@@Decrypt, edx, ebx
@@1b:	test	byte ptr [esi+10h], 2
	je	@@1c
	mov	ecx, [esi+0Ch]
	add	ecx, 8
	mov	edi, [esi+4]
	add	ecx, edi
	jc	@@1c
	call	_MemAlloc, ecx
	jc	@@1c
	xchg	edi, eax
	mov	ecx, [esi+0Ch]
	add	ecx, 8
	push	esi
	mov	esi, [@@D]
	mov	[@@D], edi
	push	esi
	rep	movsb
	call	@@Unpack, edi, eax, esi, ebx
	xchg	ebx, eax
	call	_MemFree
	pop	esi
@@1c:	add	ebx, [esi+0Ch]
	add	ebx, 8
@@1a:	mov	edi, [@@D]
	ret

@@4:	push	ebx
	mov	edi, [@@L0]
	mov	ebx, [@@L0+4]
	mov	edx, edi
	cmp	edi, ebx
	je	@@4b
@@4a:	mov	al, [edi]
	cmp	al, 0Ah
	je	@@4b
	cmp	al, 0Dh
	je	@@4b
	inc	edi
	cmp	edi, ebx
	jne	@@4a
@@4b:	mov	ecx, edi
	cmp	edi, ebx
	je	@@4d
	xor	al, 7
	inc	edi
	cmp	edi, ebx
	je	@@4d
	cmp	[edi], al
	jne	@@4d
	inc	edi
@@4d:	sub	ecx, edx
	mov	[@@L0], edi
	pop	ebx
	ret

@@Decrypt PROC
	mov	ecx, [esp+8]
	mov	edx, [esp+4]
	test	ecx, ecx
	je	@@9
	push	ebx
	xor	ebx, ebx
@@1:	mov	al, [edx]
	xor	al, byte ptr [@@T+ebx]
	inc	ebx
	ror	al, 3
	mov	[edx], al
	inc	edx
	and	ebx, 1Fh
	dec	ecx
	jne	@@1
	pop	ebx
@@9:	ret	8

@@T	dd 7A6F2C77h,74254F71h,817A286Ch,5B81314Ch
	dd 794D8177h,6B456929h,2D687A79h,39296669h
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
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
	dec	[@@SC]
	js	@@9
	lodsb
	cmp	al, 18h
	je	@@1
	mov	[@@SB], esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	jmp	_null_unpack

@@1:	dec	[@@DC]
	js	@@7
	dec	[@@SC]
	js	@@9
	shl	bl, 1
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	rol	bl, 3
	stc
	adc	bl, bl
@@1a:	jc	@@1b
	movsb
	jmp	@@1

@@1b:	dec	[@@SC]
	js	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	xchg	dl, dh
	inc	esi
	rol	dl, 3
	rol	dh, 3
	mov	ecx, edx
	shr	edx, 5
	and	ecx, 1Fh
	inc	ecx
	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
	inc	ecx
	not	edx
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@7:	xor	esi, esi
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

_conv_mma PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	sub	ebx, 8
	jb	@@9
	mov	edx, [esi]
	mov	eax, [esi+4]
	sub	ebx, edx
	jb	@@9
	and	al, 38h
	lea	edi, [esi+edx+8]

	; 10-0F image
	; 08-1F mask
	; 00-2D ogg
	; 00-2F text, dir
	; 08-3D jpg

	cmp	al, 8
	je	@@1
	cmp	al, 18h
	je	@@3
	cmp	al, 28h
	je	@@2
	cmp	al, 38h
	jne	@@9
	cmp	edx, 8
	jne	@@9
	cmp	ebx, 2
	jb	@@9
	mov	ecx, 'gpj'
	cmp	word ptr [edi], 0D8FFh
	je	@@7
@@9:	stc
	leave
	ret

@@2:	test	edx, edx
	jne	@@9
	mov	ecx, 'txt'
	cmp	ebx, 8
	jb	@@7
	mov	eax, [edi]
	mov	edx, [edi+4]
	sub	eax, 'SggO'
	sub	dh, 2
	or	eax, edx
	jne	@@7
	mov	ecx, 'ggo'
@@7:	call	_ArcSetExt, ecx
	call	_ArcData, edi, ebx
	clc
	leave
	ret

@@1:	cmp	edx, 10h
	jne	@@9
	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	mov	ecx, [esi+10h]
	ror	ecx, 3
	lea	eax, [ecx-3]
	shr	eax, 1
	jne	@@9
	mov	eax, edi
	imul	eax, ecx
	add	eax, 3
	and	al, -4
	cmp	[esi+14h], eax
	jne	@@9
	imul	eax, edx
	cmp	ebx, eax
	jne	@@9
	add	ecx, 24h-1
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	push	edi
	mov	ecx, ebx
	add	esi, 18h
	rep	movsb
	call	_tga_align4
	clc
	leave
	ret

@@3:	cmp	edx, 8
	jne	@@9
	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	mov	eax, edi
	imul	eax, edx
	cmp	ebx, eax
	jne	@@9
	call	_ArcTgaAlloc, 20h, edi, edx
	lea	edi, [eax+12h]
	mov	ecx, ebx
	add	esi, 10h
	rep	movsb
	clc
	leave
	ret
ENDP
