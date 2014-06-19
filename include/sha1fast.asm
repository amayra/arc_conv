
_sha1_fast@12 PROC	; src, cnt, dest
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	push	0C3D2E1F0h
	mov	edx, 10325476h
	mov	eax, 98BADCFEh
	push	edx
	push	eax
	not	edx
	not	eax
	push	edx
	push	eax
	mov	edi, esp
	mov	esi, [ebp+14h]
	mov	ebx, [ebp+18h]
	sub	ebx, 40h
	jb	@@2
@@1:	call	_sha1_transform@8, edi, esi
	add	esi, 40h
	sub	ebx, 40h
	jae	@@1
@@2:	and	ebx, 3Fh

	sub	esp, 40h
	mov	edi, esp

	mov	ecx, ebx
	mov	eax, ecx
	shr	ecx, 2
	and	eax, 3
	cld
	rep	movsd
	xchg	ecx, eax
	rep	movsb
	mov	ecx, ebx
	mov	al, 80h
	stosb
	xor	ecx, 3Fh
	xor	eax, eax
	lea	esi, [ebp-14h]
	cmp	ecx, 8
	jae	@@3
	mov	edx, ecx
	shr	ecx, 2
	and	edx, 3
	rep	stosd
	mov	ecx, edx
	rep	stosb
	call	_sha1_transform@8, esi, esp
	xor	eax, eax
	mov	edi, esp
	lea	ecx, [eax+40h]
@@3:	sub	ecx, 8
	mov	edx, ecx
	shr	ecx, 2
	and	edx, 3
	rep	stosd
	mov	ecx, edx
	rep	stosb
	mov	eax, [ebp+18h]
	mov	edx, eax
	shr	eax, 32-3
	shl	edx, 3
	bswap	eax
	bswap	edx
	stosd
	xchg	eax, edx
	stosd
	call	_sha1_transform@8, esi, esp
	mov	edi, [ebp+1Ch]
rept 5
	lodsd
	bswap	eax
	stosd
endm
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP
