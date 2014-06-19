
_arc_afa PROC

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
	cmp	[@@PC], 0
	jne	@@9a
	xor	ebx, ebx
	mov	esi, [@@FL]
	lodsd
@@2a:	mov	esi, [esi]
	test	esi, esi
	je	@@2b
	mov	ecx, [esi+8]
	shr	ecx, 2
	lea	ebx, [ebx+ecx*4+4+1Ch]
	jmp	@@2a
@@2b:	lea	eax, [ebx*8+ebx+3Ah+7]
	shr	eax, 3
	mov	[@@L0], eax
	add	eax, 2Ch+8+0FFFh
	and	eax, -1000h
	lea	ebx, [ebx+8+eax]
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax

	and	[@@L1], 0
	push	8
	pop	[@@P]
	mov	esi, [@@FL]
	lodsd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	mov	eax, [esi+8]
	stosd
	add	eax, 4
	and	al, -4
	stosd
	xchg	ebx, eax
	call	_string_copy_ansi, edi, ebx, dword ptr [esi+4]
	add	edi, ebx

	call	_ald_index
	jnc	@@1a
	mov	eax, [@@L1]
@@1a:	inc	eax
	mov	[@@L1], eax
	stosd

	xchg	esi, eax
	lea	esi, [eax+0Ch+14h]	; LastWriteTime
	movsd
	movsd
	xchg	esi, eax

	mov	eax, [@@P]
	stosd
	mov	eax, [esi+2Ch]	; FileSizeLow
	add	[@@P], eax
	stosd
	jmp	@@1

@@7:	mov	ebx, edi
	mov	edx, [@@M]
	sub	ebx, edx

	mov	eax, 'HAFA'
	stosd
	push	1Ch
	pop	eax
	stosd
	mov	eax, 'cilA'
	stosd
	mov	eax, 'hcrA'
	stosd
	xor	eax, eax
	inc	eax
	stosd
	stosd
	stosd
	mov	eax, 'OFNI'
	stosd
	stosd
	mov	eax, ebx
	stosd
	mov	esi, [@@FL]
	movsd
	call	_zlib_pack, edi, [@@L0], edx, ebx
	lea	ecx, [eax+10h]
	lea	esi, [edi-2Ch]
	mov	[edi-0Ch], ecx
	add	edi, eax
	add	eax, 2Ch+8

	lea	ecx, [eax+0FFFh]
	and	ecx, -1000h
	mov	[esi+18h], ecx
	sub	ecx, eax
	mov	eax, 'MMUD'
	stosd
	lea	eax, [ecx+8]
	stosd
	xor	eax, eax
	rep	stosb
	mov	eax, 'ATAD'
	stosd
	mov	eax, [@@P]
	stosd
	sub	edi, esi

	mov	ebx, [@@D]
	call	_FileWrite, ebx, esi, edi

	mov	esi, [@@FL]
	lodsd
	mov	edi, [@@M]
@@1b:	mov	esi, [esi]
	test	esi, esi
	je	@@9
	mov	ecx, [edi+4]
	lea	edi, [edi+ecx+1Ch]
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
	cmp	[edi-4], eax
	je	@@1b

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
