
_arc_arcx PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L2

	enter	@@stk, 0
	cmp	[@@PC], 0
	jne	@@9a
	mov	esi, [@@FL]
	mov	ebx, [esi]
	shl	ebx, 7
	add	ebx, 10h
	mov	[@@P], ebx
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, ebx
	mov	eax, 'XCRA'
	stosd
	movsd
	push	10h
	pop	eax
	stosd
	xchg	eax, ebx
	stosd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	call	_string_copy_ansi, edi, 64h, dword ptr [esi+4]
	add	edi, 64h

	mov	eax, [@@P]
	stosd
	mov	eax, [esi+2Ch]
	stosd
	stosd
	xchg	ecx, eax
	xor	eax, eax
	stosd
	stosd
	stosd
	stosd

	lea	ebx, [ecx*8+ecx+7]
	shr	ebx, 3
	lea	edx, [esi+30h]
	lea	eax, [@@L2]
	call	_ArcLoadFile, eax, edx, 0, ecx, ebx
	jc	@@1b
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	test	ebx, ebx
	je	@@1a
	lea	eax, [edx+ecx]
	call	_lzss_pack, eax, ebx, edx, ecx
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	cmp	eax, ecx
	jae	@@1a
	add	edx, ecx
	xchg	eax, ecx
	inc	byte ptr [edi-9]
@@1a:	mov	[edi-18h], ecx
	add	[@@P], ecx
	call	_FileWrite, [@@D], edx, ecx
@@1b:	call	_MemFree, [@@L2]
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
