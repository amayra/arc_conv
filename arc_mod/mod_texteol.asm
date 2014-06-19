
_mod_texteol PROC
	push	ebp
	mov	ebp, esp
	sub	eax, 2
	shr	eax, 1
	jne	@@9a
	mov	esi, [ebp+0Ch]
	movzx	eax, word ptr [esi]
	sub	eax, 31h
	cmp	eax, 2
	jae	@@9a
	cmp	word ptr [esi+2], 0
	jne	@@9a
	push	eax

	call	_FileCreate, dword ptr [ebp+10h], FILE_INPUT
	jc	@@9a
	xchg	esi, eax
	xor	edi, edi
	call	_FileGetSize, esi
	jc	@@4a
	test	eax, eax
	js	@@4a
	mov	ebx, eax
	cmp	eax, 1
	adc	eax, 0
	call	_MemAlloc, eax
	xchg	edi, eax
	jc	@@4a
	call	_FileRead, esi, edi, ebx
	xchg	ebx, eax
@@4a:	call	_FileClose, esi
	test	edi, edi
	je	@@9a

	pop	eax
	test	eax, eax
	jne	@@4d
	push	edi
	mov	esi, edi
	test	ebx, ebx
	je	@@4c
@@4b:	lodsb
	cmp	al, 0Dh
	je	$+3
	stosb
	dec	ebx
	jne	@@4b
@@4c:	xchg	eax, edi
	pop	edi
	sub	eax, edi
	jmp	@@4e

@@4d:	call	@@3, 0, edi, ebx
	test	eax, eax
	je	@@4e
	xchg	esi, eax
	call	_MemAlloc, esi
	jc	@@9
	xchg	edi, eax
	push	eax
	call	@@3, edi, eax, ebx
	xchg	ebx, eax
	call	_MemFree
	xchg	ebx, eax
@@4e:	xchg	ebx, eax

	mov	eax, [ebp+8]
	call	_FileCreate, dword ptr [ebp+8+eax*4], FILE_OUTPUT
	jc	@@9
	xchg	esi, eax
	call	_FileWrite, esi, edi, ebx
	call	_FileClose, esi
@@9:	call	_MemFree, edi
@@9a:	leave
	ret

@@3 PROC
	push	esi
	push	edi
	mov	edi, [esp+0Ch]
	mov	esi, [esp+10h]
	mov	ecx, [esp+14h]
	mov	edx, edi
@@1:	dec	ecx
	js	@@9
	lodsb
	cmp	al, 0Dh
	je	@@1
	cmp	al, 0Ah
	jne	@@2
	inc	edi
	test	edx, edx
	je	@@2
	mov	byte ptr [edi-1], 0Dh
@@2:	inc	edi
	test	edx, edx
	je	@@1
	mov	[edi-1], al
	jmp	@@1

@@9:	sub	edi, edx
	xchg	eax, edi
	pop	edi
	pop	esi
	ret	0Ch
ENDP

ENDP

