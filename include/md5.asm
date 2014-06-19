
@md5_size = 58h

_md5_init@4 PROC	; ctx
	pop	eax
	pop	ecx
	push	eax
	mov	eax, 67452301h
	mov	edx, 0EFCDAB89h
	mov	[ecx], eax
	mov	[ecx+4], edx
	not	eax
	not	edx
	mov	[ecx+8], eax
	mov	[ecx+0Ch], edx
	and	dword ptr [ecx+10h], 0
	and	dword ptr [ecx+14h], 0
	ret
ENDP

_md5_update@12 PROC	; ctx, src, cnt
	mov	edx, esp
	push	ebx
	push	esi
	push	edi
	mov	edi, [edx+4]
	mov	esi, [edx+8]
	mov	ebx, [edx+0Ch]
	cld
	mov	edx, [edi+10h]
	add	[edi+10h], ebx
	adc	dword ptr [edi+14h], 0
	and	edx, 3Fh
	lea	edi, [edi+18h+edx]
	je	@@1
	lea	ecx, [edx-40h]
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
	sub	edi, 40h
	lea	eax, [edi-18h]
	call	_md5_transform@8, eax, edi
@@1:	cmp	ebx, 40h
	jb	@@3
@@2:	lea	eax, [edi-18h]
	call	_md5_transform@8, eax, esi
	sub	ebx, 40h
	add	esi, 40h
	cmp	ebx, 40h
	jae	@@2
@@3:	mov	ecx, ebx
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

_md5_final@8 PROC	; ctx, dest
	push	esi
	push	edi
	mov	esi, [esp+0Ch]
	mov	ecx, [esi+10h]
	and	ecx, 3Fh
	lea	edi, [esi+18h+ecx]
	mov	al, 80h
	cld
	stosb
	xor	ecx, 3Fh
	xor	eax, eax
	cmp	ecx, 8
	jae	@@1
	mov	edx, ecx
	shr	ecx, 2
	and	edx, 3
	rep	stosd
	mov	ecx, edx
	rep	stosb
	sub	edi, 40h
	call	_md5_transform@8, esi, edi
	xor	eax, eax
	lea	ecx, [eax+40h]
@@1:	sub	ecx, 8
	mov	edx, ecx
	shr	ecx, 2
	and	edx, 3
	rep	stosd
	mov	ecx, edx
	rep	stosb
	mov	eax, [edi-40h]
	mov	ecx, [edi-3Ch]
	mov	edx, eax
	shl	eax, 3
	shr	edx, 32-3
	lea	edx, [edx+ecx*8]
	stosd
	xchg	eax, edx
	stosd
	sub	edi, 40h
	call	_md5_transform@8, esi, edi
	mov	edi, [esp+10h]
	movsd
	movsd
	movsd
	movsd
	pop	edi
	pop	esi
	ret	8
ENDP
