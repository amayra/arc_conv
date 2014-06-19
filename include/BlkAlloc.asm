
	; 00 d next_mem
	; 04 d next_free
	; 08 d alloc_size-4

_BlkAlloc PROC		; base, size
	push	ebx
	push	esi
	push	edi
	push	0
	mov	edi, [esp+18h]
	mov	ebx, [esp+14h]
	add	edi, 3
	jc	@@9
	and	edi, -4
	je	@@9
	test	ebx, ebx
	je	@@9
	lea	eax, [ebx+4]
@@1:	mov	esi, eax
	mov	eax, [eax]
	test	eax, eax
	je	@@2
	cmp	[eax+4], edi
	jb	@@1
	mov	edx, [eax]
	mov	ecx, [eax+4]
@@4:	pop	ebx
	push	eax
	add	eax, edi
	sub	ecx, edi
	cmp	ecx, 8
	jb	@@3
	mov	[eax], edx
	mov	[eax+4], ecx
	xchg	edx, eax
@@3:	mov	[esi], edx
@@9:	pop	eax
	cmp	eax, 1
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@2:	mov	eax, [ebx+8]
	lea	ecx, [eax+4]
	cmp	eax, edi
	jae	@@5
	lea	eax, [ecx-1+4]
	xor	edx, edx
	add	eax, edi
	jc	@@9
	div	ecx
	imul	ecx, eax
	lea	eax, [ecx-4]
@@5:	push	eax
	call	_MemAlloc, ecx
	pop	ecx
	jc	@@9
	mov	edx, eax
	xchg	[ebx], edx
	mov	[eax], edx
	add	eax, 4
	xor	edx, edx
	jmp	@@4
ENDP

_BlkCreate PROC		; size
	pop	ecx
	pop	eax
	push	ecx
	add	eax, 0FFFh
	and	eax, -1000h
	push	eax
	call	_MemAlloc, eax
	pop	ecx
	jc	@@9
	lea	edx, [eax+0Ch]
	and	dword ptr [eax], 0
	sub	ecx, 4
	mov	[eax+4], edx
	mov	[eax+8], ecx
	sub	ecx, 8
	and	dword ptr [edx], 0
	mov	[edx+4], ecx
@@9:	cmp	eax, 1
	ret
ENDP

_BlkDestroy PROC	; base
	pop	ecx
	pop	eax
	push	ecx
	jmp	@@2
@@1:	push	dword ptr [eax]
	call	_MemFree, eax
	pop	eax
@@2:	test	eax, eax
	jne	@@1
	ret
ENDP
