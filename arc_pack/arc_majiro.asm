
_arc_majiro PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L0

	enter	@@stk, 0
	cmp	[@@PC], 1
	jne	@@9a
	mov	esi, [@@PB]
	mov	esi, [esi]
	movzx	ebx, word ptr [esi]
	sub	ebx, 31h
	cmp	ebx, 3
	jae	@@9a
	cmp	word ptr [esi+2], 0
	jne	@@9a
	mov	[@@L0], ebx
	mov	esi, [@@FL]
	lodsd
	lea	edx, [eax*2+eax]
	cmp	ebx, 1
	mov	ecx, eax
	adc	eax, 0
	shl	ebx, 2
	add	ebx, 8
	imul	ebx, eax
	add	ebx, 1Ch
	mov	[@@P], ebx
	add	ebx, ecx
@@4a:	mov	esi, [esi]
	test	esi, esi
	je	@@4b
	add	ebx, [esi+8]
	jmp	@@4a
@@4b:	lea	edx, [ebx+edx*8+8]
	call	_MemAlloc, edx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, ebx
	mov	esi, offset @@sign
	mov	eax, [@@L0]
	mov	edx, edi
	add	al, 31h
	movsd
	movsd
	movsd
	movsd
	mov	esi, [@@FL]
	mov	[edi-6], al
	lodsd
	stosd
	xchg	ecx, eax
	mov	eax, [@@P]
	mov	[@@P], ebx
	stosd
	xchg	eax, ebx
	stosd
	add	eax, edx
	add	edx, ebx
	lea	edi, [eax+ecx*4+8]
	push	eax
	push	edx
@@2a:	xchg	edi, eax
	mov	esi, [esi]
	test	esi, esi
	je	@@2e
	stosd
	push	edi
	xchg	edi, eax
	call	_sjis_lower, dword ptr [esi+4]
	mov	eax, [esi+4]
	cmp	[@@L0], 2
	je	@@2b
	call	_crc32@12, 0, eax, dword ptr [esi+8]
	xor	edx, edx
	jmp	@@2c
@@2b:	call	@@3
@@2c:	stosd
	xchg	eax, edx
	stosd
	mov	eax, [@@P]
	stosd
	cmp	[@@L0], 0
	je	@@2d
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
	add	[@@P], eax
@@2d:	stosd
	mov	eax, esi
	stosd
	pop	eax
	jmp	@@2a

@@2e:	pop	ebx
	pop	esi
	xor	eax, eax
	stosd
	stosd
	call	@@Sort

	mov	edi, [@@M]
	add	edi, 1Ch
@@1:	lodsd
	mov	edx, [@@L0]
	test	eax, eax
	je	@@7
	push	esi
	xchg	esi, eax
	movsd
	lodsd
	cmp	edx, 2
	jne	$+3
	stosd
	test	edx, edx
	jne	@@1a
	lodsd
	lodsd
	lodsd
	xchg	esi, eax
	mov	eax, [@@P]
	stosd
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
	add	[@@P], eax
	xchg	eax, esi
	jmp	@@1b
@@1a:	movsd
	movsd
	lodsd
@@1b:	mov	ecx, [eax+8]
	mov	esi, [eax+4]
	inc	ecx
	xchg	edi, ebx
	rep	movsb
	xchg	edi, ebx
	pop	esi
	jmp	@@1

@@7:	test	edx, edx
	jne	@@7a
	stosd
	mov	eax, [@@P]
	stosd
@@7a:	mov	edi, ebx
	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	mov	edx, [@@M]
	sub	edi, edx
	call	_FileWrite, ebx, edx, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@Sort PROC

@@S = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	push	esi
	xor	ecx, ecx
	jmp	@@4
@@1:	mov	esi, [ebx-4]
	mov	edx, [edi+4]
	mov	eax, [edi]
	cmp	[esi+4], edx
	jne	@@2
	cmp	[esi], eax
@@2:	jbe	@@4
	mov	[ebx-4], edi
	mov	[ebx], esi
	sub	ebx, 4
	cmp	ebx, [@@S]
	jne	@@1
@@4:	inc	ecx
	mov	ebx, [@@S]
	lea	ebx, [ebx+ecx*4]
	mov	edi, [ebx]
	test	edi, edi
	jne	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret
ENDP

@@3 PROC
	push	esi
	xchg	esi, eax
	or	eax, -1
	cdq
	jmp	@@4
@@1:	xor	eax, ecx
	push	8
	pop	ecx
@@2:	shr	edx, 1
	rcr	eax, 1
	jnc	@@3
	; 0x85E1C3D753D46D27 >> 1
	xor	edx, 042F0E1EBh
	xor	eax, 0A9EA3693h
@@3:	dec	ecx
	jne	@@2
@@4:	movzx	ecx, byte ptr [esi]
	inc	esi
	test	ecx, ecx
	jne	@@1
	not	eax
	not	edx
	pop	esi
	ret
ENDP

@@sign	db 'MajiroArcV0.000', 0
ENDP
