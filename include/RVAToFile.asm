_RVAToFile PROC	; ModuleHandle, Address
	push	esi
	push	edi
	mov	ecx, [esp+0Ch]
	mov	edi, [esp+10h]
	add	ecx, [ecx+3Ch]
	cmp	edi, [ecx+54h]		; size of header
	mov	eax, edi
	jb	@@2
	movzx	edx, word ptr [ecx+14h]	; size of optional header
	lea	edx, [ecx+edx+18h]	; object table
	movzx	esi, word ptr [ecx+6]	; count of sections
@@4:	mov	ecx, [edx+0Ch]		; virt address
	mov	eax, edi
	test	ecx, ecx
	je	@@5
	sub	eax, ecx
	jb	@@5
	cmp	eax, [edx+10h]		; file size
	jae	@@5
	add	eax, [edx+14h]		; file address
	jmp	@@2
@@5:	add	edx, 28h
	dec	esi
	jne	@@4
@@1:	or	eax, -1
@@2:	cmp	eax, -1
	cmc
	pop	edi
	pop	esi
	ret	8
ENDP
