
_arc_nsa PROC

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
	imul	ebx, [esi], 0Eh
	add	ebx, [esi-8]
	add	ebx, 6
	and	[@@P], 0
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, ebx

	lodsd
	xchg	al, ah
	stosw
	mov	eax, ebx
	bswap	eax
	stosd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	mov	ecx, [esi+8]
	mov	eax, [esi+4]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	xchg	eax, ecx
	stosb
	stosb
	mov	eax, [@@P]
	bswap	eax
	stosd
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
	add	[@@P], eax
	bswap	eax
	stosd
	stosd
	jmp	@@1

@@7:	mov	esi, [@@M]
	mov	ebx, [@@D]
	sub	edi, esi
	call	_FileSeek, ebx, 0, 0
	call	_FileWrite, ebx, esi, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
