
_mod_mjoscan PROC

@@stk = 0
@M0 @@M
@M0 @@N
@M0 @@L0
@M0 @@S
@M0 @@D

	enter	8, 0
	push	2	; @@L0
	cmp	eax, 2
	jne	@@9a
	call	_FileCreate, dword ptr [ebp+0Ch], FILE_INPUT
	jc	@@9a
	push	eax	; @@S
	call	_FileCreate, dword ptr [ebp+10h], FILE_ADD
	jc	@@9b
	push	eax	; @@D
	call	_FileSeek, eax, 0, 2

	lea	eax, [@@M]
	call	_majiro_arc_load, [@@S], eax
	mov	esi, edx
	mov	[@@N], eax
	test	eax, eax
	jne	@@2
	mov	[@@M], eax
	inc	eax
	mov	[@@N], eax
	call	_FileGetSize, [@@S]
	xchg	ebx, eax
	xor	eax, eax
	jmp	@@2a

@@2:	call	_ansi_ext, -1, dword ptr [esi]
	cmp	eax, 'ojm'
	jne	@@2c
	mov	eax, [esi+4]
	mov	ebx, [esi+8]
@@2a:	call	_FileSeek, [@@S], eax, 0
	jc	@@2c
	call	_MemAlloc, ebx
	jc	@@2c
	push	esi
	xchg	esi, eax
	call	_FileRead, [@@S], esi, ebx
	xchg	ebx, eax
	call	_majiro_mjo_decrypt, esi, ebx
	test	eax, eax
	je	@@2b
	push	esi
	call	@@3
	pop	esi
@@2b:	call	_MemFree, esi
	pop	esi
@@2c:	add	esi, 0Ch
	dec	[@@N]
	jne	@@2
	call	_MemFree, [@@M]
	call	_FileClose, [@@D]
@@9b:	call	_FileClose, [@@S]
@@9a:	mov	eax, [@@L0]
	leave
	call	ExitProcess, eax

@@3:	cmp	[@@L0], 2
	jne	@@3a
	dec	[@@L0]
@@3a:	mov	eax, [esi+18h]
	shl	eax, 3
	add	eax, 20h
	sub	ebx, eax
	add	esi, eax
@@3b:	cmp	ebx, 4
	jb	@@3d
	cmp	word ptr [esi], 801h
	jne	@@3c
	movzx	ecx, word ptr [esi+2]
	lea	edx, [ecx+0Ch]
	test	ecx, ecx
	je	@@3c
	cmp	ebx, edx
	jb	@@3c
	cmp	dword ptr [esi+ecx+6], 07A7B6ED4h
	jne	@@3c
	cmp	word ptr [esi+ecx+4], 835h
	jne	@@3c
	lea	edi, [esi+4]
	xor	eax, eax
	repne	scasb
	jne	@@3c
	test	ecx, ecx
	jne	@@3c
	call	@@4
@@3c:	inc	esi
	dec	ebx
	jne	@@3b
@@3d:	ret

@@4:	sub	esp, 10h
	mov	edi, esp

	mov	al, '0'
	stosb
	mov	al, 'x'
	stosb

	movzx	ecx, word ptr [esi+2]
	lea	edx, [esi+4]
	dec	ecx
	call	_crc32@12, 0, edx, ecx
	call	_hex32_upper, eax, edi
	add	edi, 8
	mov	eax, 0A0D2220h
	stosd
	sub	edi, 3

	mov	edx, esp
	call	_FileWrite, [@@D], edx, 0Ch
	movzx	ecx, word ptr [esi+2]
	lea	edx, [esi+4]
	dec	ecx
	call	_FileWrite, [@@D], edx, ecx
	call	_FileWrite, [@@D], edi, 3
	add	esp, 10h
	and	[@@L0], 0
	ret
ENDP
