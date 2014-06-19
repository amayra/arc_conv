
_arc_rlseen PROC

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
	mov	edi, 2710h*8
	mov	[@@P], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	push	eax
	push	edi
	xchg	ecx, eax
	xor	eax, eax
	shr	ecx, 2
	rep	stosd
	call	_FileWrite, [@@D]

	mov	esi, [@@FL]
	lodsd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	call	_file_index
	jc	@@1
	mov	edi, [@@M]
	lea	edi, [edi+eax*8]
	cmp	dword ptr [edi], 0
	jne	@@1
	mov	eax, [@@P]
	mov	[edi], eax

	mov	ebx, [esi+2Ch]
	lea	edx, [esi+30h]
	lea	eax, [@@L2]
	call	_ArcLoadFile, eax, edx, 0, ebx, 0
	jc	@@1h
	lea	eax, [@@L2]
	call	@@Conv, eax, ebx
	xchg	ebx, eax
	call	_FileWrite, [@@D], [@@L2], ebx
	mov	[edi+4], eax
	add	[@@P], eax
@@1h:	call	_MemFree, [@@L2]
	jmp	@@1

@@7:	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	call	_FileWrite, ebx, [@@M], 2710h*8
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@Conv PROC

@@D = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]

@@L0 = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edx, [@@D]
	mov	ebx, [@@C]
	mov	esi, [edx]
	mov	eax, 1D0h
	cmp	ebx, eax
	jb	@@9
	mov	edi, [esi+20h]
	cmp	edi, eax
	jb	@@9
	sub	ebx, edi
	jb	@@9
	cmp	dword ptr [esi+28h], 0
	jne	@@9
	cmp	ebx, [esi+24h]
	jne	@@9
	lea	eax, [ebx*8+ebx+7]
	shr	eax, 3
	push	eax	; @@L0
	lea	eax, [edi+eax+8]
	call	_MemAlloc, eax
	jc	@@9
	push	eax
	xchg	edi, eax
	xchg	ecx, eax
	rep	movsb
	xchg	eax, ebx
	stosd
	stosd
	call	_reallive_pack, edi, [@@L0], esi, eax
	lea	ebx, [eax+8]
	sub	edi, 8
	mov	[edi], ebx
	call	_rlseen_xor, edi, ebx
	pop	edi
	mov	edx, [@@D]
	mov	[edi+28h], ebx
	add	ebx, [edi+20h]
	mov	[edx], edi
	mov	[@@C], ebx
@@9:	mov	eax, [@@C]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

ENDP
