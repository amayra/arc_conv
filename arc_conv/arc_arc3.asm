
; "Otoboku" *.bin
; otoboku.exe 00413C50
; 00411450 unpack1
; 00415C20 unpack2

	dw 0
_arc_arc3 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@A
@M0 @@P
@M0 @@SC
@M0 @@L3	; filetab size
@M0 @@L4	; longinfo
@M0 @@L5	; longinfo size
@M0 @@L0
@M0 @@L1
@M0 @@L2, 14h	; name buf

	enter	@@stk+30h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 2Eh
	jc	@@9a
	pop	eax
	cmp	eax, 33637261h
	jne	@@9a
	pop	eax		; version
	pop	ecx		; align
	pop	edx
	bswap	eax
	bswap	ecx
	bswap	edx
	dec	eax
	test	ecx, ecx
	je	@@9a
	cmp	eax, 2
	jae	@@9a
	mov	[@@A], ecx
	mov	[@@P], edx
	mov	ecx, [esi+24h]
	bswap	ecx
	sub	ecx, eax
	call	_ArcCount, ecx
	mov	ebx, [esi+1Ch]
	mov	eax, [esi+18h]
	bswap	ebx
	bswap	eax
	and	[@@L4], 0
	mul	[@@A]
	test	edx, edx
	jne	@@9
	call	_FileSeek, [@@S], eax, 0
	jc	@@9
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	[@@L3], ebx

@@7a:	lea	esp, [@@L2]
	mov	[@@SC], ebx
	mov	esi, [@@M]
	; 00414440
@@1:	sub	[@@SC], 7
	jb	@@7
	movsx	ecx, byte ptr [esi]
	inc	esi
	inc	ecx
	sub	ecx, -0Fh
	jbe	@@7
	sub	[@@SC], ecx
	jb	@@7
	mov	[@@L0], ecx
	mov	edi, esp
	rep	movsb
	call	@@3
	xor	eax, eax
	lodsw
	xchg	al, ah
	shl	eax, 8
	lodsb
	test	eax, eax
	jne	@@1e
	mov	eax, [@@SC]
	add	eax, esi
	sub	eax, [@@M]
@@1e:	mov	[@@L1], eax

@@1a:	mov	eax, esi
	sub	eax, [@@M]
	cmp	eax, [@@L1]
	jae	@@1d
	sub	[@@SC], 4
	jb	@@7
	movzx	ecx, byte ptr [esi]
	inc	esi
	mov	eax, ecx
	and	ecx, 0Fh
	shr	eax, 4
	mov	edx, [@@L0]
	cmp	eax, 0Fh
	jne	@@1b
	cmp	eax, ecx
	jne	@@7
	inc	byte ptr [esp+edx-1]
	jmp	@@1c

@@1b:	cmp	edx, eax
	jb	@@7
	lea	edi, [esp+eax]
	add	eax, ecx
	sub	[@@SC], ecx
	jb	@@7
	mov	[@@L0], eax
	dec	eax
	cmp	eax, 0Eh
	jae	@@7
	rep	movsb
@@1c:	call	@@3
	jmp	@@1a
@@1d:	je	@@1
@@7:	xor	ebx, ebx
	xchg	ebx, [@@L3]
	test	ebx, ebx
	jne	@@7a
@@9:	call	_MemFree, [@@L4]
	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	lea	edi, [@@L2]
	mov	edx, [@@L0]
	mov	ecx, [edi]
	shl	ecx, 8
	mov	cl, 2Eh
	xor	eax, eax
	mov	[edi+edx], ecx
	mov	[edi+edx+4], al
	lodsw
	xchg	al, ah
	shl	eax, 8
	lodsb
	mov	ebx, [@@L3]
	cmp	ecx, 2424242Eh
	jne	@@4a
	mov	ecx, [edi+3]
	sub	edx, 0Bh
	sub	ecx, 'gnol'
	or	ecx, edx
	mov	edx, [edi+7]
	sub	edx, 'ofni'
	or	ecx, edx
	je	@@4a
	test	ebx, ebx
	je	@@4b
@@4c:	ret
@@4a:	test	ebx, ebx
	je	@@4c
@@4b:	add	eax, [@@P]
	xor	ebx, ebx
	mul	[@@A]
	push	ebx
	sub	esp, 20h
	test	edx, edx
	jne	@@3a
	call	_FileSeek, [@@S], eax, 0
	jc	@@3a
	mov	edi, esp
	call	_FileRead, [@@S], edi, 20h
	jc	@@3a
	and	dword ptr [edi+1Ch], 0
	mov	ecx, [edi+4]
	cmp	ecx, [edi+8]
	jne	@@3a
	bswap	ecx
	mov	[edi+20h], ecx
	cmp	ecx, 0Ah
	jb	@@3c
	call	_FileRead, [@@S], edi, 8
	jc	@@3a
	mov	eax, [edi+4]
	mov	ax, [edi]
	xor	ecx, ecx
	cmp	eax, 657A7A6Ch
	jne	@@3d
	mov	ecx, [edi+2]
	bswap	ecx
	mov	[edi+1Ch], ecx
@@3d:	add	ecx, [edi+20h]
@@3c:	call	_MemAlloc, ecx
	jb	@@3a
	xchg	ebx, eax
	mov	ecx, [edi+20h]
	mov	edx, ebx
	cmp	ecx, 0Ah
	jb	@@3b
	add	edx, [edi+1Ch]
	mov	eax, [edi]
	mov	[edx], eax
	mov	eax, [edi+4]
	mov	[edx+4], eax
	sub	ecx, 8
	add	edx, 8
@@3b:	call	_FileRead, [@@S], edx, ecx
	jc	@@3e
	mov	ecx, [edi+1Ch]
	mov	eax, [edi+20h]
	test	ecx, ecx
	je	@@3e
	sub	eax, 6
	lea	edx, [ebx+ecx+6]
	call	@@Unpack, ebx, ecx, edx, eax
	mov	[edi+20h], eax
	jmp	@@3a

@@3e:	mov	[edi+20h], eax
	xchg	ecx, eax
	mov	eax, [edi+14h]
	bswap	eax
	cmp	eax, 2
	jne	@@3a
	mov	edi, ebx
@@3f:	not	byte ptr [edi]	
	inc	edi
	dec	ecx
	jne	@@3f
@@3a:	add	esp, 20h
	pop	ecx
	mov	eax, [@@L2]
	lea	edi, [@@L2+3]
	shl	eax, 8
	cmp	eax, 24242400h
	je	@@4d
@@4e:	push	ecx
	call	_ArcName, edi, -1
	call	_ArcData, ebx
	call	_MemFree, ebx
	call	_ArcBreak
	jc	@@9
	ret

@@4d:	mov	edx, [@@L4]
	cmp	[@@L3], 0
	je	@@4f
	test	edx, edx
	jne	@@4e
	mov	[@@L4], ebx
	mov	[@@L5], ecx
	ret

@@4f:	test	edx, edx
	je	@@4e
	push	ecx
	call	@@FindLong, edx, [@@L5], edi
	pop	ecx
	test	eax, eax
	je	@@4e
	xchg	edi, eax
	jmp	@@4e

@@FindLong PROC	; longinfo, size, filename

@@B = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]
@@F = dword ptr [ebp+1Ch]

@@N = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@B]
	sub	[@@C], 4
	jb	@@9
	lodsd
	mov	ebx, eax
	shl	eax, 3
	je	@@9
	sub	[@@C], eax
	jb	@@9
	add	eax, esi
	mov	edi, [@@F]
	mov	[@@B], eax
	xor	eax, eax
	or	ecx, -1
	repne	scasb
	not	ecx
	push	ecx
@@1:	lodsd
	mov	edx, [@@C]
	mov	edi, [@@B]
	mov	ecx, [@@N]
	sub	edx, eax
	jbe	@@1a
	cmp	edx, ecx
	jb	@@1a
	add	edi, eax
	push	esi
	mov	esi, [@@F]
	repe	cmpsb
	pop	esi
	jne	@@1a
	lodsd
	mov	ecx, [@@C]
	mov	edi, [@@B]
	sub	ecx, eax
	jbe	@@1a
	add	edi, eax
	xor	eax, eax
	push	edi
	repne	scasb
	jne	@@9
	pop	eax
	jmp	@@8

@@1a:	lodsd
	dec	ebx
	jne	@@1
@@9:	xor	eax, eax
@@8:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

@@Unpack PROC	; 00411450

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@C = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
@@2:	sub	[@@SC], 4
	jb	@@9
	lodsd
	cmp	ax, 657Ah	; 'ze'
	jne	@@9
	shr	eax, 10h
	je	@@9
	xchg	al, ah
	sub	[@@DC], eax
	jb	@@9
	push	eax
	xor	ebx, ebx
@@1:	call	@@4
	dec	eax
	je	@@1b
	sub	[@@C], eax
	jb	@@9
	xchg	edx, eax
@@1a:	lea	ecx, [ecx+8]
	call	@@5
	stosb
	dec	edx
	jne	@@1a
@@1b:	cmp	[@@C], ecx
	je	@@1c
	call	@@4
	xchg	edx, eax
	call	@@4
	sub	[@@C], eax
	jb	@@9
	xchg	ecx, eax
	mov	eax, edi
	sub	eax, [@@DB]
	cmp	eax, edx
	jb	@@9
	mov	eax, edi
	sub	eax, edx
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	cmp	[@@C], ecx
	jne	@@1
@@1c:	pop	eax
	cmp	[@@DC], ecx
	jne	@@2
	xor	esi, esi
@@9:	xchg	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@3:	shl	ebx, 1
	jne	@@3a
	sub	[@@SC], 2
	jb	@@9
	movzx	ebx, word ptr [esi]
	inc	esi
	inc	esi
	xchg	bl, bh
	shl	ebx, 10h
	mov	bh, 80h
	shl	ebx, 1
@@3a:	ret

@@4:	xor	ecx, ecx
	xor	eax, eax
@@4a:	cmp	ecx, 20h
	jae	@@9
	inc	ecx
	call	@@3
	jnc	@@4a
	inc	eax
	dec	ecx
	je	@@5a
@@5:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@5
@@5a:	ret
ENDP

ENDP
