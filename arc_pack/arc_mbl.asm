
_arc_mbl PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@P
@M0 @@M
@M0 @@L0, 8
@M0 @@L2, 8

	enter	@@stk, 0
	cmp	[@@PC], 0
	jne	@@9a
	mov	esi, [@@PB]
	call	_marble_check, dword ptr [esi-4]	; outFileName
	mov	[@@L0+4], eax
	xchg	edi, eax

	mov	esi, [@@FL]
	lodsd
	xchg	ebx, eax
	test	edi, edi
	jne	@@2d
@@2b:	mov	esi, [esi]
	test	esi, esi
	je	@@2c
	call	_ansi_ext, dword ptr [esi+8], dword ptr [esi+4]
	sub	edx, [esi+4]
	cmp	edi, edx
	jae	$+4
	mov	edi, edx
	jmp	@@2b
@@2c:	inc	edi
@@2d:	mov	[@@L0], edi
	imul	edi, ebx
	lea	edi, [ebx*8+edi+8]
	mov	[@@P], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax
	mov	esi, [@@FL]
	movsd
	cmp	[@@L0+4], 0
	jne	@@1
	mov	eax, [@@L0]
	stosd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	call	_ansi_ext, dword ptr [esi+8], dword ptr [esi+4]
	mov	byte ptr [edx], 0
	xchg	ebx, eax
	call	_string_copy_ansi, edi, [@@L0], dword ptr [esi+4]
	add	edi, [@@L0]

	mov	eax, [@@P]
	stosd
	lea	edx, [esi+30h]
	cmp	ebx, 'txt'
	je	@@1a
	cmp	ebx, 's'
	je	@@1a
	call	_ArcAddFile, [@@D], edx, 0
@@1c:	stosd
	add	[@@P], eax
	jmp	@@1

@@1a:	mov	[@@L2+4], ebx
	push	edi
	lea	edi, [@@L2]
	xor	ebx, ebx
	call	_ArcLoadFile, edi, edx, ebx, dword ptr [esi+2Ch], ebx
	xchg	ebx, eax
	mov	edi, [edi]
	jc	@@1b
	cmp	[@@L2+4], 's'
	je	@@3b
	push	esi
	push	edi
	mov	esi, edi
@@3a:	lodsb
	cmp	al, 0Ah
	jne	$+4
	xor	eax, eax
	cmp	al, 0Dh
	je	$+3
	stosb
	dec	ebx
	jne	@@3a
	mov	ebx, edi
	pop	edi
	pop	esi
	sub	ebx, edi
@@3b:
	call	_marble_crypt, edi, ebx
	call	_FileWrite, [@@D], edi, ebx
@@1b:	call	_MemFree, edi
	pop	edi
	xchg	eax, ebx
	jmp	@@1c

@@7:	xor	eax, eax
	cmp	[@@L0+4], eax
	je	$+3
	stosd

	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	mov	edx, [@@M]
	sub	edi, edx
	call	_FileWrite, ebx, edx, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
