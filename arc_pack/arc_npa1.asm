
_arc_npa1 PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L0, 0Ch
@M0 @@L1

	enter	@@stk, 0
	mov	ebx, [@@PC]
	dec	ebx
	je	@@2a
	cmp	ebx, 2
	jne	@@9a
@@2a:	mov	esi, [@@PB]
	mov	edx, [esi]
	movzx	eax, word ptr [edx]
	sub	al, 30h
	cmp	eax, 4
	jae	@@9a
	cmp	word ptr [edx+2], 0
	jne	@@9a
	mov	[@@L0], eax
	and	[@@L0+4], 0
	and	[@@L0+8], 0
	test	ebx, ebx
	je	@@2b
	call	_string_num, dword ptr [esi+4]
	jc	@@9a
	mov	[@@L0+4], eax
	call	_string_num, dword ptr [esi+8]
	jc	@@9a
	mov	[@@L0+8], eax
@@2b:
	mov	esi, [@@FL]
	lodsd
	imul	ebx, eax, 15h
	add	ebx, [esi-4-8]
	lea	edi, [ebx+29h]
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax

	mov	esi, [@@FL]
	mov	eax, 141504Eh
	stosd
	xor	eax, eax
	mov	[@@P], eax
	stosb
	stosb
	stosb
	mov	eax, [@@L0+4]
	stosd
	mov	eax, [@@L0+8]
	stosd
	mov	al, byte ptr [@@L0]
	and	al, 1
	stosb
	xor	eax, eax
	stosb

	mov	ecx, [esi-0Ch]
	lodsd
	stosd
	sub	eax, ecx
	xchg	eax, ecx
	stosd
	xchg	eax, ecx
	stosd
	xor	eax, eax
	stosd
	stosd
	xchg	eax, ebx
	stosd

	xor	ebx, ebx
	mov	[@@L1], ebx
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	mov	eax, [esi+8]
	mov	ecx, [esi+4]
	stosd
	xchg	ecx, eax
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	mov	al, 1
	stosb
	mov	eax, ebx
	stosd
	mov	eax, [@@P]
	stosd
	test	byte ptr [esi+0Ch], 10h
	je	@@1b
	inc	[@@L1]
	xor	eax, eax
	push	ebx
	mov	ebx, [@@L1]
	jmp	@@1d

@@1b:	inc	byte ptr [edi-9]
	lea	edx, [esi+30h]
	test	byte ptr [@@L0], 1
	je	@@1c
	mov	eax, [esi+2Ch]
	stosd
	stosd
	xchg	ecx, eax
	lea	eax, [ecx*8+ecx+3Ah+7]
	shr	eax, 3
	call	_ArcPackFile, [@@D], edx, ecx, eax, 1, offset _zlib_pack, 0
	add	[@@P], eax
	mov	[edi-8], eax
	jmp	@@1e

@@1c:	call	_ArcAddFile, [@@D], edx, 0
	add	[@@P], eax
@@1d:	stosd
	stosd
@@1e:
	movzx	ecx, word ptr [esi-2]
	push	ebx
	lea	esp, [esp+ecx*4]
	pop	ebx
	jmp	@@1

@@7:	mov	esi, [@@M]
	mov	ebx, [@@D]
	sub	edi, esi

	test	byte ptr [@@L0], 2
	mov	eax, [esi+7]
	mov	edx, [esi+0Bh]
	jne	@@7a
	imul	eax, edx
	xor	edx, edx
@@7a:	add	eax, edx

	lea	edx, [esi+29h]
	lea	ecx, [edi-29h]
	call	_npa1_crypt_names, 1, eax, -1, edx, ecx

	call	_FileSeek, ebx, 0, 0
	call	_FileWrite, ebx, esi, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
