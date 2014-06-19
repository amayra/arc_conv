
@arc4_size = 104h

_arc4_set_key@12 PROC		; state, key, len
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ecx, [ebp+14h]
	xor	edx, edx
	mov	edi, ecx
	mov	eax, 3020100h
	mov	[ecx], edx
@@1:	mov	[ecx+4], eax
	add	ecx, 4
	add	eax, 4040404h
	jnc	@@1
	xor	ecx, ecx
	xor	ebx, ebx
	mov	esi, [ebp+18h]
@@2:	mov	al, [edi+ecx+4]
	add	bl, [esi+edx]
	add	bl, al
	mov	ah, [edi+ebx+4]
	mov	[edi+ebx+4], al
	mov	[edi+ecx+4], ah
	inc	edx
	cmp	edx, [ebp+1Ch]
	sbb	eax, eax
	and	edx, eax
	inc	cl
	jne	@@2
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

_arc4_crypt@12 PROC	; state, buf, len
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [ebp+14h]
	mov	esi, [ebp+18h]
	mov	ebp, [ebp+1Ch]
	movzx	ecx, byte ptr [edi]
	movzx	edx, byte ptr [edi+2]
	xor	eax, eax
@@1:	inc	cl
	mov	al, [edi+ecx+4]
	add	dl, al
	mov	bl, al
	mov	al, [edi+edx+4]
	mov	[edi+edx+4], bl
	mov	[edi+ecx+4], al
	add	al, bl
	mov	al, [edi+eax+4]
	xor	[esi], al
	inc	esi
	dec	ebp
	jne	@@1
	mov	[edi], cl
	mov	[edi+2], dl
	pop	ebp
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP
