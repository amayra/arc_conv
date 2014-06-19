
_arc_sysadv PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L0
@M0 @@L1

	enter	@@stk, 0
	cmp	[@@PC], 1
	jne	@@9a
	mov	esi, [@@PB]
	mov	esi, [esi]
	movzx	eax, word ptr [esi]
	sub	eax, 30h
	cmp	eax, 2
	jae	@@9a
	cmp	word ptr [esi+2], 0
	jne	@@9a
	mov	[@@L0], eax

	mov	esi, [@@FL]
	imul	ebx, [esi], 9
	add	ebx, [esi-8]
	lea	edi, [ebx+0Ah]
	mov	[@@P], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax

	mov	eax, 43415005h
	stosd
	mov	ax, 324Bh
	stosw
	movsd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	mov	eax, [esi+8]
	mov	ecx, 0FFh
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
	stosb
	xchg	ecx, eax
	push	esi
	mov	esi, [esi+4]
	test	ecx, ecx
	je	@@1e
@@1f:	lodsb
	not	al
	stosb
	dec	ecx
	jne	@@1f
@@1e:	rep	movsb
	pop	esi

	cmp	[@@L0], 0
	je	@@1a
	mov	eax, [@@P]
	stosd
	call	_ansi_ext, dword ptr [esi+8], dword ptr [esi+4]
	cmp	eax, 'gnp'
	jne	@@1a
	mov	ebx, [esi+2Ch]
	lea	edx, [esi+30h]
	lea	eax, [@@L1]
	call	_ArcLoadFile, eax, edx, 0, ebx, 0
	push	0
	jc	@@1d
	pop	eax
	mov	edx, [@@L1]
	cmp	ebx, 10h
	jb	@@1c
	xor	dword ptr [edi-8], 'agp.' XOR 'gnp.'
	add	edx, 5
	sub	ebx, 5
	mov	dword ptr [edx], 'PAGP'
	mov	dword ptr [edx+3], 'HAGP'
	mov	dword ptr [edx+7], 1700070Ah
@@1c:	call	_FileWrite, [@@D], edx, ebx
	push	eax
@@1d:	call	_MemFree, [@@L1]
	pop	eax
	jmp	@@1b

@@1a:	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
@@1b:	stosd
	add	[@@P], eax
	jmp	@@1

@@7:	mov	esi, [@@M]
	mov	ebx, [@@D]
	sub	edi, esi
	call	_FileSeek, ebx, 0, 0
	call	_FileWrite, ebx, esi, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
