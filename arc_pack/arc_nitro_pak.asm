
_arc_nitro_pak PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@P
@M0 @@M
@M0 @@L0, 8
@M0 @@L1, 8

	enter	@@stk, 0
	cmp	[@@PC], 2
	jne	@@9a
	mov	esi, [@@PB]
	mov	esi, [esi]
	movzx	eax, word ptr [esi]
	lea	ecx, [eax-30h]
	sub	al, 33h
	shr	eax, 1
	jne	@@9a
	sbb	eax, eax
	and	eax, 3F0h
	add	eax, 10h
	cmp	word ptr [esi+2], 0
	jne	@@9a
	mov	[@@L0], ecx
	mov	[@@L0+4], eax

	mov	esi, [@@FL]
	imul	ebx, [esi], 18h
	add	ebx, [esi-8]
	lea	eax, [ebx*8+ebx+3Ah+7]
	shr	eax, 3
	mov	[@@L1+4], eax
	add	eax, 114h
	mov	edi, eax
	add	eax, ebx
	call	_MemAlloc, eax
	jb	@@9a
	mov	[@@M], eax
	add	edi, eax
	and	[@@P], 0
	mov	[@@L1], edi

	mov	esi, [@@FL]
	lodsd
@@4a:	mov	esi, [esi]
	test	esi, esi
	je	@@4b
	mov	eax, [esi+8]
	stosd
	xchg	ecx, eax
	mov	eax, [esi+4]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	call	_nitro_pak_checksum, dword ptr [esi+8], dword ptr [esi+4]
	xchg	ebx, eax

	mov	ecx, [esi+2Ch]
	mov	eax, [@@P]
	add	[@@P], ecx
	xor	eax, ebx
	xor	ecx, ebx
	stosd
	xchg	eax, ecx
	stosd
	xchg	eax, ecx
	lea	eax, [edi+0Ch]
	sub	eax, [@@L1]
	xor	eax, ebx
	stosd
	mov	eax, ebx
	stosd
	xchg	eax, ecx
	stosd
	jmp	@@4a
@@4b:
	mov	ebx, edi
	mov	eax, [@@L0]
	sub	ebx, [@@L1]
	mov	edi, [@@M]
	stosd
	mov	esi, 100h
	mov	edx, [@@PB]
	push	edi
	mov	edi, [edx+4]
	or	ecx, -1
	xor	eax, eax
	repne	scasw
	pop	edi
	not	ecx
	dec	ecx
	cmp	ecx, esi
	jb	$+4
	mov	ecx, esi
	call	_unicode_to_ansi, 932, dword ptr [edx+4], ecx, edi
	call	_nitro_pak_checksum, esi, edi
	lea	edi, [edi+esi+10h]
	xchg	esi, eax
	call	_zlib_pack, edi, [@@L1+4], [@@L1], ebx
	lea	ecx, [eax+114h]
	push	64h
	pop	edx
	push	ecx
	mov	ecx, [@@FL]
	xor	eax, edx
	mov	ecx, [ecx]
	xor	ebx, esi
	xor	ecx, esi
	mov	[edi-10h], edx
	mov	[edi-0Ch], ebx
	mov	[edi-8], ecx
	mov	[edi-4], eax
	call	_FileWrite, [@@D], [@@M]

	and	[@@P], 0
	mov	edi, [@@L1]
	mov	esi, [@@FL]
	lodsd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@1a
	add	edi, [edi]
	mov	ecx, [@@L0+4]
	add	edi, 18h
	mov	eax, [edi-8]
	mov	[@@L1], ecx
	mov	[@@L1+4], eax
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, offset @@5
	add	[@@P], eax
	jmp	@@1
@@1a:

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5:	mov	eax, [@@L1]
	sub	eax, ebx
	jae	$+6
	add	ebx, eax
	xor	eax, eax
	mov	[@@L1], eax
	test	ebx, ebx
	je	@@5b
	mov	eax, [@@L1+4]
@@5a:	xor	[esi], al
	inc	esi
	ror	eax, 8
	dec	ebx
	jne	@@5a
	mov	[@@L1+4], eax
@@5b:	ret
ENDP
