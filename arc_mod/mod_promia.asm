
_mod_promia PROC
	push	ebp
	mov	ebp, esp
	dec	eax
	shr	eax, 1
	jne	@@9a
	call	_FileCreate, dword ptr [ebp+0Ch], FILE_INPUT
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

	; promia.exe 00454A60
	test	ebx, ebx
	je	@@1a
	mov	edx, edi
	mov	ecx, ebx
	mov	al, 0C5h
@@1:	xor	[edx], al
	inc	edx
	add	al, 5Ch
	dec	ecx
	jne	@@1
@@1a:
	mov	eax, [ebp+8]
	call	_FileCreate, dword ptr [ebp+8+eax*4], FILE_OUTPUT
	jc	@@9
	xchg	esi, eax
	call	_FileWrite, esi, edi, ebx
	call	_FileClose, esi
@@9:	call	_MemFree, edi
@@9a:	leave
	ret
ENDP
