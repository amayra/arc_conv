_CheckPeHdr PROC
	push	esi
	mov	ecx, [esp+8]
	mov	esi, [ecx]
	mov	ecx, [ecx+4]
	cmp	ecx, 40h
	jb	@@1
	cmp	word ptr [esi], 'ZM'
	jne	@@1
	mov	edx, [esi+3Ch]
	lea	eax, [edx+18h+60h]
	test	edx, edx
	js	@@1
	cmp	ecx, eax
	jb	@@1
	cmp	dword ptr [esi+edx], 'EP'
	jne	@@1
	cmp	word ptr [esi+edx+18h], 10Bh	; magic optional header
	jne	@@1
	movzx	eax, word ptr [esi+edx+14h]	; size of optional header
	cmp	eax, 60h
	jb	@@1
	lea	eax, [edx+eax+18h]
	movzx	edx, word ptr [esi+edx+6]	; count of sections
	test	edx, edx
	je	@@1
	imul	edx, 28h
	add	eax, edx
	cmp	ecx, eax
	jb	@@1
	xchg	eax, esi
	jmp	$+4
@@1:	xor	eax, eax
	pop	esi
	ret	4
ENDP