
_arc_ego PROC

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
	lodsd
	imul	ebx, eax, 11h
	add	ebx, [esi-4-8]
	lea	edi, [ebx+4]
	mov	[@@P], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax
	xchg	eax, ebx
	stosd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	mov	ebx, [esi+8]
	lea	eax, [ebx+11h]
	inc	ebx
	stosd
	xor	eax, eax
	stosd
	mov	eax, [@@P]
	stosd
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
	add	[@@P], eax
	stosd
	mov	eax, [esi+4]
	mov	ecx, ebx
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
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
