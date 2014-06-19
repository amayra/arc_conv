
_arc_n3pk PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L0, 8
@M0 @@L1
@M0 @@N

	enter	@@stk, 0
	cmp	[@@PC], 2
	jne	@@9a
	mov	esi, [@@PB]
	lodsd
	call	_string_num, eax
	jc	@@9a
	mov	[@@L0], eax
	lodsd
	call	_string_num, eax
	jc	@@9a
	mov	[@@L0+4], eax

	mov	esi, [@@FL]
	mov	eax, [esi]
	imul	ebx, eax, 98h
	mov	[@@N], eax
	add	ebx, 0Ch
	mov	[@@P], ebx
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, ebx

	mov	eax, 'kP3N'
	stosd
	movsd
	mov	eax, [@@L0+4]
	stosd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@1c
	mov	[edi], esi
	add	edi, 16h
	mov	ebx, [esi+4]
	call	_sjis_slash, ebx
	call	_sjis_name, ebx
	cmp	ebx, eax
	xchg	ebx, eax
	jne	@@1a
	xor	eax, eax
	lea	ecx, [eax+10h]
	rep	stosd
	jmp	@@1b

@@1a:	mov	byte ptr [ebx-1], 0
	call	_string_copy_ansi, edi, 40h, eax
	mov	byte ptr [edi+3Fh], 0
	add	edi, 40h
@@1b:	call	_string_copy_ansi, edi, 40h, ebx
	mov	byte ptr [edi+3Fh], 0
	lea	edx, [edi-40h]
	call	@@3
	mov	[edi-56h+14h], al
	mov	edx, edi
	call	@@3
	mov	[edi-56h+15h], al
	add	edi, 40h
	push	13h
	pop	eax
	stosw
	jmp	@@1
@@1c:
	mov	edi, [@@M]
	cmp	[@@L0], 0
	je	@@7a
	sub	esp, 400h
	mov	[@@L0], esp
	call	_n3pk_init, esp
	call	_n3pk_xor, edi, 0Ch, [@@L0], [@@L0+4]
@@7a:	add	edi, 0Ch

	cmp	[@@N], 0
	je	@@2a
@@2:	mov	esi, [edi]
	and	[@@L1], 0
	mov	eax, [@@P]
	stosd
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, offset @@5
	add	[@@P], eax
	stosd
	stosd
	mov	eax, [@@L1]
	stosd
	xor	eax, eax
	stosd

	cmp	[@@L0], 0
	je	@@7b
	lea	edx, [edi-14h]
	call	_n3pk_xor, edx, 98h, [@@L0], [@@L0+4]
@@7b:	add	edi, 98h-14h
	dec	[@@N]
	jne	@@2
@@2a:
	mov	esi, [@@M]
	mov	ebx, [@@D]
	sub	edi, esi
	call	_FileSeek, ebx, 0, 0
	call	_FileWrite, ebx, esi, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5:	call	_crc32@12, [@@L1], edi, ebx
	mov	[@@L1], eax
	ret

@@3:	xor	ecx, ecx
	jmp	@@3b
@@3a:	sub	al, 41h
	cmp	al, 1Ah
	sbb	ah, ah
	and	ah, 20h
	add	al, ah
	add	al, 41h
	add	cl, al
@@3b:	mov	al, [edx]
	inc	edx
	test	al, al
	jne	@@3a
	xchg	eax, ecx
	ret
ENDP
