
_arc_aoimy PROC

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
	call	_filelist_sort, esi, offset _fncmp_unicode_lower, 0
	imul	ebx, [esi], 28h
	add	ebx, 18h
	mov	[@@P], ebx
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, ebx

	push	esi
	mov	esi, offset _aoimy_sign
	movsd
	movsd
	movsd
	movsd
	pop	esi
	lodsd
	bswap	eax
	stosd
	xor	eax, eax
	stosd

@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	call	_string_copy_unicode, edi, 10h, dword ptr [esi+4]
	add	edi, 20h

	mov	eax, [@@P]
	bswap	eax
	stosd
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, offset @@5
	bswap	eax
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

@@5:	call	_aoimy_crypt, [@@P], esi, ebx
	add	[@@P], ebx
	ret
ENDP

_arc_vfs101 PROC

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
	mov	ebx, [esi]
	shl	ebx, 5
	add	ebx, 10h
	mov	[@@P], ebx
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, ebx
	mov	eax, 1014656h
	stosd
	movzx	ecx, word ptr [esi]
	add	esi, 4
	lea	eax, [ecx+200000h]
	stosd
	imul	eax, ecx, 20h
	stosd
	stosd

@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	call	_string_copy_ansi, edi, 0Dh, dword ptr [esi+4]
	add	edi, 0Dh
	push	20h
	pop	eax
	stosw
	lea	eax, [edi+2]
	lea	edx, [esi+0Ch+14h]	; LastWriteTime
	call	_FileTimeToDosDateTime, edx, edi, eax
	add	edi, 4

	mov	eax, [@@P]
	stosd
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
	add	[@@P], eax
	stosd
	stosd
	xor	eax, eax
	stosb
	jmp	@@1

@@7:	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	mov	edx, [@@M]
	mov	eax, [@@P]
	sub	edi, edx
	mov	[edx+0Ch], eax
	call	_FileWrite, ebx, edx, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_arc_vfs200 PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L0
@M0 @@L1
@M0 @@L2

	enter	@@stk, 0
	cmp	[@@PC], 0
	jne	@@9a

	mov	esi, [@@FL]
	call	_filelist_sort, esi, offset _fncmp_unicode_lower, 0
	mov	ecx, [esi]
	imul	ebx, ecx, 17h
	add	ecx, [esi-8]
	mov	[@@L0], ecx
	lea	ebx, [ebx+ecx*2+1Ah]
	mov	[@@P], ebx
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, ebx
	mov	esi, [@@FL]
	mov	eax, 2004656h
	stosd
	movzx	ecx, word ptr [esi]
	add	esi, 4
	lea	eax, [ecx+170000h]
	stosd
	imul	eax, ecx, 17h
	stosd
	stosd
	lea	eax, [edi+eax+8]
	xor	ecx, ecx
	mov	edx, [@@L0]
	mov	[@@L1], eax
	mov	[@@L0], ecx
	mov	[eax-8], edx
	mov	[eax-4], ecx
	mov	[eax+edx*2], cx

@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	mov	ecx, [esi+8]
	mov	eax, [@@L0]
	inc	ecx
	stosd
	add	[@@L0], ecx
	push	esi
	push	edi
	mov	esi, [esi+4]
	mov	edi, [@@L1]
	lea	edi, [edi+eax*2]
	rep	movsw
	pop	edi
	pop	esi

	lea	eax, [ecx+20h]
	stosw
	lea	eax, [edi+2]
	lea	edx, [esi+0Ch+14h]	; LastWriteTime
	call	_FileTimeToDosDateTime, edx, edi, eax
	add	edi, 4

	mov	eax, [@@P]
	stosd
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
	add	[@@P], eax
	stosd
	stosd
	xor	eax, eax
	stosb
	jmp	@@1

@@7:	mov	eax, [@@L0]
	lea	edi, [edi+eax*2+0Ah]
	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	mov	edx, [@@M]
	mov	eax, [@@P]
	sub	edi, edx
	mov	[edx+0Ch], eax
	call	_FileWrite, ebx, edx, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
