
@sha512_size = 0C8h

_sha512_init@4 PROC	; ctx
	xchg	edi, eax
	push	10h
	pop	ecx
	pop	edx
	pop	edi
	push	edx
	push	esi
	mov	esi, offset @@T
	cld
	rep	movsd
	pop	esi
	xchg	ecx, eax
	stosd
	stosd
	mov	edi, ecx
	ret

ALIGN 8
@@T:
dq 06a09e667f3bcc908h,0bb67ae8584caa73bh
dq 03c6ef372fe94f82bh,0a54ff53a5f1d36f1h
dq 0510e527fade682d1h,09b05688c2b3e6c1fh
dq 01f83d9abfb41bd6bh,05be0cd19137e2179h
ENDP

_sha512_update@12 PROC	; ctx, src, cnt
	mov	edx, esp
	push	ebx
	push	esi
	push	edi
	mov	edi, [edx+4]
	mov	esi, [edx+8]
	mov	ebx, [edx+0Ch]
	cld
	mov	edx, [edi+40h]
	add	[edi+40h], ebx
	adc	dword ptr [edi+44h], 0
	and	edx, 7Fh
	lea	edi, [edi+48h+edx]
	je	@@1
	lea	ecx, [edx-80h]
	neg	ecx
	cmp	ebx, ecx
	jb	@@2
	sub	ebx, ecx
	mov	eax, ecx
	shr	ecx, 2
	and	eax, 3
	rep	movsd
	xchg	ecx, eax
	rep	movsb
	add	edi, -80h
	lea	eax, [edi-48h]
	call	_sha512_transform@8, eax, edi
@@1:	add	ebx, -80h
	jnc	@@3
@@2:	lea	eax, [edi-48h]
	call	_sha512_transform@8, eax, esi
	sub	esi, -80h
	add	ebx, -80h
	jc	@@2
@@3:	and	ebx, 7Fh
	mov	ecx, ebx
	mov	eax, ecx
	shr	ecx, 2
	and	eax, 3
	rep	movsd
	xchg	ecx, eax
	rep	movsb
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

_sha512_final@8 PROC	; ctx, dest
	push	esi
	push	edi
	mov	esi, [esp+0Ch]
	mov	ecx, [esi+40h]
	and	ecx, 7Fh
	lea	edi, [esi+48h+ecx]
	mov	al, 80h
	cld
	stosb
	xor	ecx, 7Fh
	xor	eax, eax
	sub	ecx, 10h
	jae	@@1
	add	ecx, 10h
	mov	edx, ecx
	shr	ecx, 2
	and	edx, 3
	rep	stosd
	mov	ecx, edx
	rep	stosb
	add	edi, -80h
	call	_sha512_transform@8, esi, edi
	xor	eax, eax
	lea	ecx, [eax+70h]
@@1:	mov	edx, ecx
	shr	ecx, 2
	and	edx, 3
	rep	stosd
	mov	ecx, edx
	rep	stosb
	stosd
	stosd
	mov	edx, [esi+40h]
	mov	ecx, [esi+44h]
	mov	eax, edx
	shl	edx, 3
	shr	eax, 32-3
	lea	eax, [eax+ecx*8]
	bswap	edx
	bswap	eax
	stosd
	xchg	eax, edx
	stosd
	add	edi, -80h
	call	_sha512_transform@8, esi, edi
	mov	edi, [esp+10h]
	push	8
	pop	ecx
@@2:	mov	eax, [esi]
	mov	edx, [esi+4]
	add	esi, 8
	bswap	eax
	bswap	edx
	mov	[edi+4], eax
	mov	[edi], edx
	add	edi, 8
	dec	ecx
	jne	@@2
	pop	edi
	pop	esi
	ret	8
ENDP

