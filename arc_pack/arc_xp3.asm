
_arc_xp3 PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@P
@M0 @@M
@M0 @@DC
@M0 @@L0
@M0 @@L1
@M0 @@L2
@M0 @@L3

	enter	@@stk, 0
	mov	eax, [@@PC]
	test	eax, eax
	je	@@2a
	dec	eax
	jne	@@9a
	mov	ebx, [@@PB]
	call	_xp3_select, dword ptr [ebx]
	jc	@@9a
@@2a:	mov	[@@L3], eax

	mov	esi, [@@FL]
	add	esi, 4
	xor	ebx, ebx
@@2b:	mov	esi, [esi]
	test	esi, esi
	je	@@2c
	mov	ecx, [esi+8]
	lea	ebx, [ebx+ecx*2+66h]
	jmp	@@2b
@@2c:
	lea	eax, [ebx*8+ebx+3Ah+7]
	shr	eax, 3
	mov	[@@L0], eax
	add	eax, ebx
	call	_MemAlloc, eax
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax

	push	13h
	pop	ecx
	mov	[@@P], ecx
	push	0
	push	0
	push	1678Bh
	push	1A0A200Ah
	push	0D335058h
	mov	edx, esp
	call	_FileWrite, [@@D], edx, ecx
	add	esp, 14h

	mov	esi, [@@FL]
	add	esi, 4
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@1a
	mov	ecx, [esi+8]
	mov	eax, 'eliF'
	stosd
	lea	eax, [ecx+ecx+5Ah]
	stosd
	xor	eax, eax
	stosd
	mov	eax, 'ofni'
	stosd
	lea	eax, [ecx+ecx+16h]
	stosd
	xor	eax, eax
	stosd
	mov	eax, [@@L3]
	neg	eax
	sbb	eax, eax
	shl	eax, 1Fh
	stosd	; crypt_flag
	xor	edx, edx
	mov	eax, [esi+2Ch]
	stosd
	xchg	edx, eax
	stosd
	mov	[@@L1], edi
	xchg	edx, eax
	stosd
	xchg	edx, eax
	stosd

	mov	eax, ecx
	stosw
	push	esi
	mov	esi, [esi+4]
	xor	eax, eax
	test	ecx, ecx
	je	@@1c
@@1b:	lodsw
	cmp	eax, 5Ch
	jne	$+4
	mov	al, 2Fh
	stosw
	dec	ecx
	jne	@@1b
@@1c:	pop	esi

	call	_unicode_ext, dword ptr [esi+8], dword ptr [esi+4]
	xor	ebx, ebx
	cmp	eax, 'gpm'
	je	@@1d
	cmp	eax, 'iva'
	je	@@1d
	dec	ebx
@@1d:
	mov	eax, 'mges'
	stosd
	push	1Ch
	pop	eax
	stosd
	xor	eax, eax
	stosd
	stosd	; pack_flag
	mov	eax, [@@P]
	stosd
	xor	eax, eax
	stosd
	xor	ecx, ecx
	mov	eax, [esi+2Ch]
	stosd
	xchg	ecx, eax
	stosd
	xchg	ecx, eax
	stosd
	xchg	ecx, eax
	stosd
	mov	eax, 'rlda'
	stosd
	push	4
	pop	eax
	stosd
	xor	eax, eax
	stosd
	inc	eax
	stosd	; adler32

	lea	eax, [ecx*8+ecx+3Ah+7]
	shr	eax, 3
	and	ebx, eax
	lea	edx, [esi+30h]
	lea	eax, [@@L2]
	call	_ArcLoadFile, eax, edx, 0, ecx, ebx
	jc	@@3c

	cmp	[@@L3], 1
	jne	@@5b
	call	_xp3_crypt, 1, [@@L3], eax, [@@L2], dword ptr [esi+2Ch], dword ptr [esi+4]
@@5b:
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	call	_adler32@12, 1, edx, ecx
	mov	[edi-4], eax

	cmp	[@@L3], 1
	je	@@5c
	call	_xp3_crypt, 1, [@@L3], eax, [@@L2], dword ptr [esi+2Ch], dword ptr [esi+4]
@@5c:
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	test	ebx, ebx
	je	@@3a
	lea	eax, [edx+ecx]
	call	_zlib_pack, eax, ebx, edx, ecx
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	cmp	eax, ecx
	jae	@@3a
	add	edx, ecx
	xchg	eax, ecx
	inc	dword ptr [edi-2Ch]
@@3a:
	mov	eax, [@@L1]
	mov	[edi-18h], ecx
	mov	[eax], ecx
	add	[@@P], ecx
	call	_FileWrite, [@@D], edx, ecx
@@3c:	call	_MemFree, [@@L2]
	jmp	@@1

@@1a:	mov	esi, edi
	mov	edx, [@@M]
	sub	esi, edx
	call	_zlib_pack, edi, [@@L0], edx, esi
	mov	ebx, [@@D]

	xor	ecx, ecx
	push	ecx
	push	ecx
	push	ecx
	push	ecx
	push	1
	mov	edx, esp
	mov	[edx+1], eax
	mov	[edx+9], esi
	xchg	esi, eax
	call	_FileWrite, ebx, edx, 11h
	add	esp, 14h
	call	_FileWrite, ebx, edi, esi

	call	_FileSeek, ebx, 0Bh, 0
	lea	edx, [@@P]
	call	_FileWrite, ebx, edx, 4

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

