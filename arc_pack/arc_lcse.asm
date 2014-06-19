
_arc_lcse PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L0, 8

	enter	@@stk, 0
	mov	ebx, [@@PC]
	shr	ebx, 1
	jne	@@9a
	mov	eax, 201h
	jnc	@@2a
	mov	esi, [@@PB]
	call	_string_num, dword ptr [esi]
	jc	@@9a
@@2a:	mov	[@@L0], eax
	movzx	eax, al
	imul	eax, 1010101h
	mov	[@@L0+4], eax

	mov	esi, [@@FL]
	mov	ebx, [esi]
	imul	ebx, 4Ch
	lea	edi, [ebx+4]
	and	[@@P], 0
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	lodsd
	xor	eax, [@@L0+4]
	stosd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	call	_ansi_ext, dword ptr [esi+8], dword ptr [esi+4]
	cmp	eax, 'ins'
	jne	$+7
	mov	eax, 'xns'
	push	5
	pop	ecx
	push	edi
	mov	edi, offset @@T
	repne	scasd
	pop	edi
	jne	@@1a
	inc	ecx
	mov	byte ptr [edx], 0
@@1a:	mov	ebx, ecx

	mov	ecx, offset @@5
	cmp	ebx, 1
	je	$+4
	xor	ecx, ecx

	mov	eax, [@@P]
	stosd
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, ecx
	add	[@@P], eax
	stosd

	call	_string_copy_ansi, edi, 40h, dword ptr [esi+4]
	mov	edx, [@@L0+4]
	xor	[edi-8], edx
	xor	[edi-4], edx
	push	40h
	pop	ecx
@@1b:	mov	al, [edi]
	test	al, al
	je	@@1c
	cmp	al, dl
	je	$+4
	xor	al, dl
	stosb
	dec	ecx
	jne	@@1b
@@1c:	add	edi, ecx
	xchg	eax, ebx
	stosd
	jmp	@@1

@@7:	mov	esi, [@@PB]
	call	_FileCreateExt, dword ptr [esi-4], FILE_OUTPUT, 'tsl'
	jc	@@9
	xchg	ebx, eax
	mov	edx, [@@M]
	sub	edi, edx
	call	_FileWrite, ebx, edx, edi
	call	_FileClose, ebx
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5:	mov	al, byte ptr [@@L0+1]
@@5a:	xor	[esi], al
	inc	esi
	dec	ebx
	jne	@@5a
	ret

@@T	db 'ogg',0, 'wav',0, 'png',0, 'bmp',0, 'snx',0
ENDP
