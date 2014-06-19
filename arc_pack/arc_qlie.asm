
_arc_qlie PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L0, 10h

	enter	@@stk, 0
	cmp	[@@PC], 0
	jne	@@9a
	mov	esi, [@@FL]
	imul	ebx, [esi], 1Eh
	add	ebx, [esi-8]
	add	ebx, 1Ch
	and	[@@P], 0
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax

	lodsd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	mov	eax, [esi+8]
	stosw
	xchg	ecx, eax

	push	esi
	mov	esi, [esi+4]
	test	ecx, ecx
	je	@@1b
	xor	edx, edx
@@1a:	lea	eax, [ecx-6]	; -3Ch XOR 3Eh
	inc	edx
	xor	eax, edx
	add	eax, edx
	xor	al, [esi]
	inc	esi
	stosb
	cmp	edx, ecx
	jb	@@1a
@@1b:	pop	esi

	; checksum init
	pxor	mm0, mm0
	movq	qword ptr [@@L0], mm0
	movq	qword ptr [@@L0+8], mm0

	mov	eax, [@@P]
	stosd
	xor	eax, eax
	stosd
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, offset @@5
	add	[@@P], eax
	stosd
	stosd
	xor	eax, eax
	stosd
	stosd

	; checksum
	mov	eax, [@@L0]
	xor	eax, [@@L0+4]
	stosd
	jmp	@@1

@@7:	emms

	mov	eax, 'eliF'
	stosd
	mov	eax, 'kcaP'
	stosd
	mov	eax, '1reV'
	stosd
	mov	eax, '0.'
	stosd
	mov	esi, [@@FL]
	movsd
	mov	eax, [@@P]
	stosd
	xor	eax, eax
	stosd

	mov	esi, [@@M]
	mov	ebx, [@@D]
	sub	edi, esi
	call	_FileWrite, ebx, esi, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

	; checksum update
@@5:	shr	ebx, 3
	je	@@5b
	mov	eax, 3070307h
	movq	mm0, qword ptr [@@L0]
	movd	mm3, eax
	movq	mm2, qword ptr [@@L0+8]
	punpckldq mm3, mm3
@@5a:	paddw	mm2, mm3
	movq	mm1, [esi]
	add	esi, 8
	pxor	mm1, mm2
	paddw	mm0, mm1
	dec	ebx
	jne	@@5a
	movq	qword ptr [@@L0], mm0
	movq	qword ptr [@@L0+8], mm2
@@5b:	ret

ENDP
