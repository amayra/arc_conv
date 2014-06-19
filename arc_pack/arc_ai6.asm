
_arc_ai6 PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P

	enter	@@stk, 0
	cmp	[@@PC], 0
	jne	@@9a
	mov	esi, [@@FL]
	imul	ebx, [esi], 110h
	add	ebx, 4
	mov	[@@P], ebx
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, ebx
	movsd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	mov	ebx, 104h
	call	_string_copy_ansi, edi, ebx, dword ptr [esi+4]
	mov	edx, edi
	add	edi, ebx
	xchg	ecx, eax
	lea	eax, [ecx+1]
	test	ecx, ecx
	je	@@1e
@@1d:	add	[edx], al
	inc	edx
	dec	eax
	dec	ecx
	jne	@@1d
@@1e:
	call	_ansi_ext, dword ptr [esi+8], dword ptr [esi+4]
	lea	edx, [esi+30h]
	; akb,vsd-"Ningen Debris"
	cmp	eax, 'tmr'
	je	@@1f
	cmp	eax, 'bka'
	je	@@1f
	cmp	eax, 'dsv'
	je	@@1f
	cmp	eax, 'vaw'
	je	@@1f
	cmp	eax, 'ggo'
	jne	@@1g
@@1f:	call	_ArcAddFile, [@@D], edx, 0
	mov	ecx, eax
	bswap	eax
	stosd
	stosd
	mov	eax, [@@P]
	bswap	eax
	stosd
	add	[@@P], ecx
	jmp	@@1

@@1g:	mov	ecx, [esi+2Ch]
	mov	eax, ecx
	bswap	eax
	stosd
	stosd
	mov	eax, [@@P]
	bswap	eax
	stosd
	lea	ebx, [ecx*8+ecx+7]
	shr	ebx, 3
	call	_ArcPackFile, [@@D], edx, ecx, ebx, 0, offset _lzss_pack, 0
	add	[@@P], eax
	bswap	eax
	mov	[edi-0Ch], eax
	jmp	@@1

@@7:	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	mov	edx, [@@M]
	sub	edi, edx
	call	_FileWrite, ebx, edx, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
