
	.data?

_crc32_table dd 100h dup(?)

	.code

_crc32@12 PROC	; crc_prev, src, cnt
	push	ebx
	mov	ebx, offset _crc32_table
	mov	ecx, [ebx]
	test	ecx, ecx
	jne	@@3
@@1:	mov	eax, ecx
	push	8
	pop	edx
@@2:	ror	eax, 1
	jc	$+7
	xor	eax, 06DB88320h
	dec	edx
	jne	@@2
	mov	[ebx+ecx*4], eax
	inc	cl
	jne	@@1
@@3:	push	esi
	mov	ecx, [esp+14h]
	mov	eax, [esp+0Ch]
	shr	ecx, 2
	mov	esi, [esp+10h]
	je	@@5
	xor	edx, edx
@@4:	xor	eax, [esi]
	add	esi, 4
	movzx	edx, al
	shr	eax, 8
	xor	eax, [ebx+edx*4]
	movzx	edx, al
	shr	eax, 8
	xor	eax, [ebx+edx*4]
	movzx	edx, al
	shr	eax, 8
	xor	eax, [ebx+edx*4]
	movzx	edx, al
	shr	eax, 8
	xor	eax, [ebx+edx*4]
	dec	ecx
	jne	@@4
@@5:	mov	ecx, [esp+14h]
	and	ecx, 3
	je	@@9
@@6:	movzx	edx, byte ptr [esi]
	inc	esi
	xor	dl, al
	shr	eax, 8
	xor	eax, [ebx+edx*4]
	dec	ecx
	jne	@@6
@@9:	pop	esi
	pop	ebx
	ret	0Ch
ENDP
