
_arc_foris PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@P
@M0 @@M
@M0 @@DC
@M0 @@L0, 10h

	enter	@@stk, 0
	mov	eax, [@@PC]
	mov	esi, [@@PB]
	dec	eax
	shr	eax, 1
	jne	@@9a
	jnc	@@2a
	call	_ArcAddFile, [@@D], dword ptr [esi+4], 0
@@2a:	mov	[@@P], eax

	mov	esi, [esi]
	lea	edi, [@@L0]
	push	4
	pop	ecx
@@2b:	call	_repipack_int32
	jc	@@9a
	bswap	eax
	stosd
	dec	ecx
	jne	@@2b

	mov	esi, [@@FL]
;	call	_filelist_sort, esi, offset _fncmp_unicode_lower, 0
	mov	ecx, [esi-8]
	imul	eax, [esi], 4+15h
	lea	ebx, [eax+ecx*2+4]

	lea	eax, [ebx*8+ebx+3Ah+7]
	shr	eax, 3
	mov	[@@DC], eax

	lea	eax, [eax+ebx+24h]
	call	_MemAlloc, eax
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax

	mov	esi, [@@FL]
	lodsd
@@1a:	mov	esi, [esi]
	test	esi, esi
	je	@@1b
	call	_unicode_slash, dword ptr [esi+4]
	mov	eax, [esi+8]
	stosw
	inc	eax
	xchg	ecx, eax
	mov	eax, [esi+4]
	xchg	esi, eax
	rep	movsw
	xchg	esi, eax

	xor	eax, eax
	stosd
	mov	eax, [@@P]
	stosd
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
	add	[@@P], eax
	stosd
	mov	eax, 20202020h
	stosd
	xor	eax, eax
	stosd
	stosb
	jmp	@@1a

@@1b:	xor	eax, eax
	stosd
	mov	ebx, edi
	mov	eax, [@@M]
	sub	ebx, eax
	lea	edx, [edi+4]
	mov	[edi], ebx
	call	_zlib_pack, edx, [@@DC], eax, ebx
	add	eax, 4
	push	8
	pop	ecx
	push	edi
	add	edi, eax
	call	@@2c
	db 'STKFile0PIDX',0,0,0,0
	db 'STKFile0PACKFILE'
@@2c:	pop	esi
	rep	movsd
	mov	[edi-14h], eax
	pop	edi
	lea	ebx, [eax+20h]

	push	edi
	xchg	edx, eax
	xor	ecx, ecx
@@3a:	mov	al, byte ptr [@@L0+ecx]
	inc	ecx
	xor	[edi], al
	inc	edi
	and	ecx, 0Fh
	dec	edx
	jne	@@3a
	pop	edi

	call	_FileWrite, [@@D], edi, ebx
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
