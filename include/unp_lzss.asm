_lzss_unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
	test	edi, edi
	je	@@4
@@1:	dec	[@@DC]
	js	@@7
	shr	ebx, 1
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@1a:	jnc	@@1b
	dec	[@@SC]
	js	@@9
	movsb
	jmp	@@1

@@1b:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
	mov	cl, dh
	shr	dh, 4
	and	ecx, 0Fh
	add	ecx, 2
	sub	[@@DC], ecx
	jae	@@1c
	add	ecx, [@@DC]
@@1c:	inc	ecx
	mov	eax, edi
	add	edx, 12h
	sub	eax, [@@DB]
	sub	edx, eax
	or	edx, -1000h
	add	eax, edx
	jns	@@2b
@@2a:	mov	byte ptr [edi], 0
	inc	edi
	dec	ecx
	je	@@1
	inc	eax
	jne	@@2a
@@2b:	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@7:	mov	esi, [@@DC]
	inc	esi
@@9:	xchg	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@4:	cmp	[@@SC], 0
	je	@@7
	shr	ebx, 1
	jne	@@4a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@4a:	jnc	@@4b
	dec	[@@SC]
	js	@@9
	inc	esi
	inc	edi
	jmp	@@4

@@4b:	sub	[@@SC], 2
	jb	@@9
	inc	esi
	lodsb
	and	eax, 0Fh
	add	eax, 3
	add	edi, eax
	jmp	@@4
ENDP

