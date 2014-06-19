_adler32@12 PROC	; adler(def=1), buf, cnt
	mov	edx, esp
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	edi, [edx+4]
	mov	ecx, [edx+8]
	mov	ebp, [edx+0Ch]
	movzx	esi, di
	shr	edi, 10h
	test	ebp, ebp
	je	@@9
@@1:	mov	edx, 15B0h
	sub	ebp, edx
	sbb	ebx, ebx
	and	ebx, ebp
	add	edx, ebx
	sub	ebp, ebx

	mov	eax, edx
	sub	edi, esi
	shr	edx, 2
	je	@@3
@@2:	movzx	ebx, byte ptr [ecx]
	add	edi, esi
	add	esi, ebx
	movzx	ebx, byte ptr [ecx+1]
	add	edi, esi
	add	esi, ebx
	movzx	ebx, byte ptr [ecx+2]
	add	edi, esi
	add	esi, ebx
	movzx	ebx, byte ptr [ecx+3]
	add	edi, esi
	add	esi, ebx
	add	ecx, 4
	dec	edx
	jne	@@2
@@3:	and	eax, 3
	je	@@5
@@4:	movzx	ebx, byte ptr [ecx]
	add	edi, esi
	add	esi, ebx
	inc	ecx
	dec	eax
	jne	@@4
@@5:	add	edi, esi

	mov	ebx, 0FFF1h
	xchg	eax, esi	; edx=0
	div	ebx
	mov	esi, edx
	xchg	eax, edi
	xor	edx, edx
	div	ebx
	test	ebp, ebp
	mov	edi, edx
	jne	@@1
@@9:	xchg	eax, edi
	shl	eax, 10h
	pop	ebp
	pop	edi
	add	eax, esi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP
