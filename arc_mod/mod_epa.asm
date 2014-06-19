
_mod_epa PROC

@@L0 = dword ptr [ebp-4]

	push	ebp
	mov	ebp, esp
	sub	eax, 2
	mov	edi, [ebp+0Ch]
	shr	eax, 1
	jne	@@9a
	jc	@@2a
	xor	ebx, ebx
	call	_BmReadFile, 0, edi
	test	eax, eax
	xchg	esi, eax
	je	@@9a
	cmp	dword ptr [esi+18h], 0
	jne	@@2b
	inc	ebx
	call	@@Is24, esi
	add	eax, 1000000h
	sbb	ebx, -1
	jmp	@@2b

@@2a:	mov	esi, [ebp+14h]
	movzx	ebx, word ptr [esi]
	sub	ebx, 30h
	cmp	ebx, 3
	jae	@@9a
	cmp	word ptr [esi+2], 0
	jne	@@9a
	cmp	ebx, 1
	sbb	eax, eax
	lea	eax, [eax+eax+3]
	call	_BmReadFile, eax, edi
	test	eax, eax
	xchg	esi, eax
	je	@@9a
@@2b:	cmp	ebx, 1
	sbb	eax, eax
	lea	edx, [ebx+eax+2]
	not	eax
	and	eax, 3
	call	@@EPA, esi, ebx, eax, edx
	test	eax, eax
	je	@@9b
	xchg	esi, eax
	mov	ebx, edx
	call	_MemFree, eax

	call	_FileCreate, dword ptr [ebp+10h], FILE_OUTPUT
	jc	@@9b
	xchg	edi, eax
	call	_FileWrite, edi, esi, ebx
	call	_FileClose, edi
@@9b:	call	_MemFree, esi
@@9a:	leave
	ret

@@Is24 PROC

@@S = dword ptr [ebp+14h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@S]
	mov	edx, [esi]
	push	dword ptr [esi+4]
	mov	ecx, edx
	neg	ecx
	shl	ecx, 2
	add	ecx, [esi+0Ch]
	mov	[@@S], ecx

	mov	esi, [esi+8]
	or	eax, -1
@@2:	mov	ecx, edx
@@3:	and	eax, [esi]
	add	esi, 4
	dec	ecx
	jne	@@3
	add	esi, [@@S]
	dec	dword ptr [ebp-4]
	jne	@@2
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP

@@EPA PROC

@@S = dword ptr [ebp+14h]
@@F = dword ptr [ebp+18h]
@@A = dword ptr [ebp+1Ch]
@@N = dword ptr [ebp+20h]

@@D = dword ptr [ebp-4]
@@B = dword ptr [ebp-8]
@@T = dword ptr [ebp-44h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@S]
	mov	ecx, [esi]
	imul	ecx, [esi+4]
	mov	edx, 88888889h	; div(15), shr = 3
	lea	eax, [ecx+0Eh]
	mul	edx
	shl	edx, 1
	cmp	[@@F], 1
	sbb	eax, eax
	and	edx, -10h
	and	eax, 300h
	imul	edx, [@@N]
	lea	ebx, [eax+edx+10h+28h]
	add	ecx, ebx
	call	_MemAlloc, ecx
	jc	@@9
	push	eax	; @@D
	add	ebx, eax
	xchg	edi, eax
	push	ebx
	sub	esp, 3Ch
	call	_epa_dist, dword ptr [esi], 1, esp

	mov	eax, 1015045h
	stosd
	mov	eax, [@@F]
	stosd
	push	esi
	movsd
	movsd
	pop	esi
	mov	ecx, [esi+1Ch]
	cmp	ecx, 28h
	jne	@@2a
	inc	byte ptr [edi-10h+3]
	push	esi
	add	esi, 20h
	rep	movsb
	pop	esi
@@2a:	mov	eax, [@@F]
	test	eax, eax
	jne	@@2c
	mov	esi, [esi+18h]
@@2b:	movsd
	dec	edi
	add	al, 1
	jne	@@2b
@@2c:
	xor	esi, esi
@@1:	push	esi
	push	edi
	mov	edx, [@@S]
	mov	edi, [@@B]
	mov	ebx, [edx+4]
	add	esi, [edx+8]
@@3:	mov	ecx, [edx]
	push	esi
@@3a:	movsb
	add	esi, [@@A]
	dec	ecx
	jne	@@3a
	pop	esi
	add	esi, [edx+0Ch]
	dec	ebx
	jne	@@3
	pop	edi

	mov	ebx, [edx]
	mov	esi, [@@B]
	imul	ebx, [edx+4]
	xor	ecx, ecx
@@4:	push	ecx
	call	@@5
	cmp	eax, 1
	pop	ecx
	jb	@@4d
	jne	@@4f
	test	ecx, ecx
	jne	@@4d
@@4f:	call	@@4a
	add	esi, eax
	sub	ebx, eax
	shl	edx, 4
	cmp	eax, 8
	jb	@@4e
	xchg	al, ah
	lea	eax, [eax+edx+8]
	stosw
	jmp	@@4c

@@4e:	add	eax, edx
	stosb
	jmp	@@4c

@@4d:	dec	ebx
	inc	ecx
	inc	esi
	cmp	ecx, 15
	jne	@@4c
	call	@@4a
@@4c:	test	ebx, ebx
	jne	@@4
	call	@@4a

	pop	esi
	inc	esi
	cmp	esi, [@@N]
	jb	@@1

	mov	eax, [@@D]
	sub	edi, eax
	mov	edx, edi
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@4a:	test	ecx, ecx
	je	@@4b
	sub	esi, ecx
	mov	[edi], cl
	inc	edi
	rep	movsb
@@4b:	ret

@@5:	push	ebx
	push	edi
	mov	eax, 7FFh
	cmp	eax, ebx
	jae	$+3
	xchg	ebx, eax
	xor	edx, edx
	push	edx
	push	edx
@@5a:	mov	edi, [@@T+edx*4]
	inc	edx
	mov	ecx, esi
	sub	ecx, [@@B]
	add	ecx, edi
	jnc	@@5c
	add	edi, esi
	push	esi
	mov	ecx, ebx
	repe	cmpsb
	pop	esi
	je	$+3
	inc	ecx
	neg	ecx
	add	ecx, ebx
	pop	eax
	cmp	eax, ecx
	jae	@@5b
	mov	eax, ecx
	pop	ecx
	push	edx
@@5b:	push	eax
@@5c:	cmp	edx, 0Fh
	jb	@@5a
	pop	eax
	pop	edx
	pop	edi
	pop	ebx
	ret
ENDP

ENDP
