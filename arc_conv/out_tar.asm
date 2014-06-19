
_out_tar_create PROC
	@M1
	test	ebx, ebx
	jne	@@2a
	mov	dword ptr [edi], 74002Eh
	mov	dword ptr [edi+4], 720061h
	mov	[edi+8], ax
@@2a:	call	_FileCreate, esi, FILE_OUTPUT
	sbb	edx, edx
	test	ebx, ebx
	jne	@@2b
	and	word ptr [edi], 0
@@2b:	or	[@@B], edx
	jne	@@9
	mov	[@@D], eax
	xor	eax, eax
	call	GetSystemTimeAsFileTime, esp, eax, eax
	pop	ecx
	pop	eax
	sub	ecx, 0D53E8000h
	sbb	eax, 0019DB1DEh
	mov	ebx, 989680h
	xor	edx, edx
	div	ebx
	xchg	ecx, eax
	div	ebx
	mov	[@@T], eax
@@9:	ret
ENDP

_out_tar_close PROC
	@M1
	mov	esi, [@@D]
	mov	ebx, 400h
	sub	esp, ebx
	mov	ecx, ebx
	xor	eax, eax
	shr	ecx, 2
	mov	edi, esp
	rep	stosd
	mov	edi, esp
	call	_FileWrite, esi, edi, ebx
	add	esp, ebx
	call	_FileClose, esi
	ret
ENDP

	db 2
	dw _out_tar_close-$-4
	dw _out_tar_create-$-2
_out_utar PROC
	mov	edi, offset outFileNameA
	mov	ecx, 408h
	lea	edx, [edi+outFileNameW-outFileNameA]
	mov	esi, edi
@@2:	movzx	eax, word ptr [edx]
	inc	edx
	inc	edx
	cmp	eax, 5Ch
	jne	$+4
	mov	al, 2Fh
	mov	ebx, eax
	cmp	eax, 7Fh
	jb	@@2c
	cmp	ah, 8
	jae	@@2a
	shr	eax, 6
	or	al, 0C0h
	jmp	@@2b
@@2a:	shr	eax, 0Ch
	or	al, 0E0h
	dec	ecx
	js	@@2d
	stosb
	mov	eax, ebx
	shr	eax, 6
	and	al, 3Fh
	or	al, 80h
@@2b:	dec	ecx
	js	@@2d
	stosb
	lea	eax, [ebx-80h]
	and	al, 3Fh
	or	al, 80h
@@2c:	dec	ecx
	js	@@2d
	stosb
	test	ebx, ebx
	jne	@@2
@@2d:	mov	byte ptr [edi-1], 0
	jmp	@@1c

	db 1
	dw _out_tar_close-$-4
	dw _out_tar_create-$-2
_out_tar:
	@M1
	mov	edi, offset outFileNameA
	mov	esi, edi
	mov	ah, byte ptr [@@U+1]
@@1:	mov	al, [edi]
	test	ah, ah
	je	@@1a
	call	_sjis_test
	jc	@@1a
	inc	edi
	mov	al, [edi]
	jmp	@@1b
@@1a:	cmp	al, 5Ch
	jne	$+4
	mov	al, 2Fh
	mov	[edi], al
@@1b:	inc	edi
	test	al, al
	jne	@@1
@@1c:	sub	edi, esi
	cmp	edi, 65h
	jb	@@1d
	call	@@5, offset @@link, esi, edi, 'L'
@@1d:	call	@@5, esi, dword ptr [esp+18h+8], dword ptr [esp+1Ch+4], '0'
	ret

@@link	db '././@LongLink', 0

@@4:	add	edi, ecx
	push	edi
@@4a:	mov	edx, eax
	shr	eax, 3
	and	edx, 7
	add	edx, 30h
	dec	edi
	mov	[edi], dl
	add	ebx, edx
	dec	ecx
	jne	@@4a
	pop	edi
	mov	[edi], cl
	inc	edi
	ret

@@5:	push	ebx
	push	esi
	push	edi
	lea	esi, [esp+10h]
	xor	eax, eax
	xor	ebx, ebx
	lea	ecx, [eax+63h]
	sub	esp, 200h
	mov	edi, esp
	push	esi
	mov	esi, [esi]
@@5a:	lodsb
	stosb
	add	ebx, eax
	test	eax, eax
	je	@@5b
	dec	ecx
	jne	@@5a
	inc	ecx
	xor	eax, eax
@@5b:	pop	esi
	rep	stosb
	mov	eax, 6*40h+4*8+0
	mov	cl, 7
	call	@@4
	xor	eax, eax
	mov	cl, 7
	call	@@4
	mov	cl, 7
	call	@@4
	mov	eax, [esi+8]
	mov	cl, 0Bh
	call	@@4
	mov	eax, [@@T]
	mov	cl, 0Bh
	call	@@4
	lea	eax, [ebx+20h*8]
	add	eax, [esi+0Ch]
	mov	cl, 6
	call	@@4
	mov	al, 20h
	stosb
	mov	eax, [esi+0Ch]
	stosb
	xor	eax, eax
	mov	ecx, 200h-9Dh
	rep	stosb
	mov	ebx, 200h
	mov	edx, esp
	call	_FileWrite, [@@D], edx, ebx
	sbb	eax, eax
	or	[@@B], eax
	mov	edi, [esi+8]
	test	edi, edi
	je	@@5c
	call	_FileWrite, [@@D], dword ptr [esi+4], edi
	sbb	eax, eax
	or	[@@B], eax
	neg	edi
	and	edi, 1FFh
	je	@@5c
	lea	ecx, [edi+3]
	xor	eax, eax
	shr	ecx, 2
	mov	edx, esp
	push	edi
	mov	edi, edx
	rep	stosd
	call	_FileWrite, [@@D], edx
	sbb	eax, eax
	or	[@@B], eax
@@5c:	add	esp, ebx
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP
