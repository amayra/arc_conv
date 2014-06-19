
_mod_filecat PROC

@@stk = 0
@M0 @@D
@M0 @@S
@M0 @@C, 8
@M0 @@M

@@C0 = 100000h

	push	ebp
	mov	ebp, esp
	lea	ebx, [eax-2]
	lea	esi, [ebp+0Ch]
	cmp	ebx, 4
	jae	@@9a
	lodsd
	call	_FileCreate, eax, FILE_ADD+8
	jc	@@9a
	push	eax	; @@D
	xchg	edi, eax
	dec	ebx
	js	@@4a
	call	@@2
	jmp	@@4b

@@4a:	xor	eax, eax
	cdq
	call	@@3
@@4b:	jc	@@9b
	lodsd
	call	_FileCreate, eax, FILE_INPUT+8
	jc	@@9b
	push	eax	; @@S
	xchg	edi, eax
	dec	ebx
	js	@@4c
	call	@@2
	jc	@@9c
@@4c:	or	eax, -1
	cdq
	dec	ebx
	js	@@4d
	lodsd
	call	_string_num64, eax
	jc	@@9c
@@4d:	push	edx
	push	eax

	mov	ebx, @@C0
	call	_MemAlloc, ebx
	jc	@@9c
	push	eax	; @@M
@@1:	mov	eax, [@@C]
	cmp	[@@C+4], 0
	jne	@@1a
	cmp	eax, ebx
	jb	$+4
@@1a:	mov	eax, ebx
	sub	[@@C], eax
	sbb	[@@C+4], 0
	call	_FileRead, [@@S], [@@M], eax
	test	eax, eax
	je	@@9
	xchg	edi, eax
	call	_FileWrite, [@@D], [@@M], edi
	cmp	edi, ebx
	je	@@1

@@9:	call	_MemFree, [@@M]
@@9c:	call	_FileClose, [@@S]
@@9b:	call	_FileClose, [@@D]
@@9a:	leave
	ret

@@2:	lodsd
	movzx	ecx, word ptr [eax]
	push	ecx
	call	_string_num64, eax
	pop	ecx
	jc	@@2b
	cmp	ecx, '-'
	push	0
	pop	ecx
	jne	@@2a
@@3:	push	2
	pop	ecx
@@2a:	call	_FileSeek64, edi, eax, edx, ecx
@@2b:	ret
ENDP
