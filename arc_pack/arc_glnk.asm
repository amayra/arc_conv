
_arc_glnk PROC

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
	imul	ebx, eax, 0Dh
@@2a:	mov	esi, [esi]
	test	esi, esi
	je	@@2b
	mov	ecx, 0FFh
	mov	eax, [esi+8]
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
	add	ebx, eax
	jmp	@@2a
@@2b:	lea	edi, [ebx+12h]
	mov	[@@P], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax

	mov	esi, [@@FL]
	mov	eax, 'KNLG'
	stosd
	push	6Eh
	pop	eax
	stosw
	movsd
	mov	al, 12h
	stosd
	xchg	eax, ebx
	stosd

@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	mov	ecx, 0FFh
	mov	eax, [esi+8]
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
	mov	ecx, [esi+4]
	stosb
	xchg	ecx, eax
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax

	mov	eax, [@@P]
	stosd
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
	add	[@@P], eax
	stosd
	xor	eax, eax
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
