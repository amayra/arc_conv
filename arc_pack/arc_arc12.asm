
_arc_arc12 PROC

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
	movzx	eax, word ptr [esi]
	sub	al, 31h
	cmp	eax, 2
	jae	@@9a
	cmp	word ptr [esi+2], 0
	jne	@@9a
	mov	[@@L0], eax

	mov	esi, [@@FL]
	imul	ebx, [esi], 9
	add	ebx, [esi-8]
	lea	edi, [ebx+8]
	mov	[@@P], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax
	mov	eax, [@@L0]
	shl	eax, 18h
	add	eax, '1CRA'
	stosd
	movsd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	mov	eax, [@@P]
	stosd
	xor	ebx, ebx
	cmp	[@@L0], 0
	je	@@1a
	call	_ansi_ext, dword ptr [esi+8], dword ptr [esi+4]
	cmp	eax, 'ggo'
	je	@@1a
	mov	ebx, offset @@5
	cmp	eax, 'gnp'
	je	@@1a
	mov	eax, [esi+2Ch]
	stosd
	xchg	ecx, eax
	lea	edx, [esi+30h]
	lea	ebx, [ecx*8+ecx+7]
	shr	ebx, 3
	call	_ArcPackFile, [@@D], edx, ecx, ebx, 1, offset _lzss_pack, offset @@3
	jmp	@@1b

@@1a:	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, ebx
	stosd
@@1b:	add	[@@P], eax

	mov	eax, [esi+8]
	mov	ecx, 0FFh
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
	stosb
	xchg	ecx, eax
	mov	edx, [@@L0]
	push	esi
	mov	esi, [esi+4]
	dec	edx
	js	@@1e
	test	ecx, ecx
	je	@@1e
@@1f:	lodsb
	not	al
	stosb
	dec	ecx
	jne	@@1f
@@1e:	rep	movsb
	pop	esi
	jmp	@@1

@@5:	not	byte ptr [esi]
	inc	esi
	dec	ebx
	jne	@@5
	ret

@@3:	mov	edx, esi
	mov	ecx, ebx
	jmp	_arc12_lzss_crypt

@@7:	mov	esi, [@@M]
	mov	ebx, [@@D]
	sub	edi, esi
	call	_FileSeek, ebx, 0, 0
	call	_FileWrite, ebx, esi, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
