
_out_dir_create PROC
	@M1
	mov	ecx, edi
	mov	edi, offset outFileNameW
	sub	ecx, esi
	sub	edi, 4
	push	7Eh
	lea	eax, [edi+ebx*2]
	pop	dword ptr [edi]
	xchg	edi, eax
	sub	edi, ecx
	shr	ecx, 1

	lea	edx, [ecx-1]
	shr	edx, 9
	neg	edx
	jc	@@1

	mov	ebx, edi
	rep	movsw
	xchg	edi, eax
	call	CreateDirectoryW, ebx, 0
	mov	word ptr [edi+2], 5Ch
	test	eax, eax
	jne	@@1
	call	GetLastError
	sub	al, 0B7h	; ERROR_ALREADY_EXISTS
	neg	eax
@@1:	sbb	edx, edx
	or	[@@B], edx
	jne	@@9
	mov	[@@T], ebx
	and	[@@D], 0
@@9:	ret
ENDP

_out_dir_close:
	ret

	db 2
	dw _out_dir_close-$-4
	dw _out_dir_create-$-2
_out_dir PROC
	@M1
	mov	edi, offset outFileNameW
	mov	esi, edi
@@1a:	movzx	eax, word ptr [edi]
	cmp	eax, 2Fh
	jne	$+4
	mov	al, 5Ch
	stosw
	test	eax, eax
	jne	@@1a

	push	esi
	xor	eax, eax
@@2a:	lodsw
	cmp	eax, 2Eh
	jne	@@2c
	lodsw
	cmp	eax, 2Eh
	jne	@@2c
	lodsw
	test	eax, eax
	je	@@2b
	cmp	eax, 5Ch
	jne	@@2c
@@2b:	mov	dword ptr [esi-6], 5F005Fh
@@2c:	test	eax, eax
	je	@@2d
	cmp	eax, 5Ch
	je	@@2a
	lodsw
	jmp	@@2c
@@2d:	pop	esi

	call	_FileCreate, [@@T], FILE_OUTPUT
	jnc	@@1d
@@1b:	movzx	ebx, word ptr [esi]
	cmp	ebx, 5Ch
	jne	@@1c
	mov	[esi], bh
	call	CreateDirectoryW, [@@T], 0
	mov	[esi], bl
@@1c:	inc	esi
	inc	esi
	test	ebx, ebx
	jne	@@1b
	call	_FileCreate, [@@T], FILE_OUTPUT
	jc	@@9
@@1d:	xchg	esi, eax
	call	_FileWrite, esi, dword ptr [esp+18h+4], dword ptr [esp+1Ch]
	call	_FileClose, esi
@@9:	ret
ENDP
