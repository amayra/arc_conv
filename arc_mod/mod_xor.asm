
_mod_xor PROC

@@stk = 0
@M0 @@L0
@M0 @@L1
@M0 @@L2
@M0 @@S
@M0 @@D

	push	ebp
	mov	ebp, esp
	dec	eax
	dec	eax
	mov	ebx, eax
	shr	eax, 1
	jne	@@9a
	mov	esi, [ebp+0Ch]
	xor	eax, eax
	lea	edi, [esi+2]
	push	eax	; @@L0
	push	edi	; @@L1
@@4b:	call	@@2
	shl	eax, 4
	xchg	edx, eax
	call	@@2
	add	eax, edx
	stosb
	cmp	word ptr [esi], 0
	jne	@@4b
	mov	edx, [@@L1]
	sub	edi, edx
	push	edi
	and	word ptr [edx-2], 0

	lea	esi, [ebp+10h]
	lodsd
	call	_FileCreate, eax, FILE_PATCH
	jc	@@9a
	push	eax
	or	eax, -1
	dec	ebx
	js	@@4a
	lodsd
	call	_FileCreate, eax, FILE_OUTPUT
	jc	@@9b
@@4a:	push	eax

	mov	ebx, 100000h
	call	_MemAlloc, ebx
	jc	@@9
	xchg	edi, eax
@@1:	call	_FileRead, [@@S], edi, ebx
	test	eax, eax
	je	@@9
	xchg	esi, eax

	push	ebx
	push	esi
	push	edi
	mov	ebx, [@@L0]
	mov	edx, [@@L1]
	mov	ecx, [@@L2]
@@5:	mov	al, [edx+ebx]
	inc	ebx
	xor	[edi], al
	inc	edi
	cmp	ebx, ecx
	sbb	eax, eax
	and	ebx, eax
	dec	esi
	jne	@@5
	mov	[@@L0], ebx
	pop	edi
	pop	esi
	pop	ebx

	mov	eax, [@@D]
	cmp	eax, -1
	jne	@@1a
	mov	eax, esi
	neg	eax
	call	_FileSeek, [@@S], eax, 1
	mov	eax, [@@S]
@@1a:	call	_FileWrite, eax, edi, esi
	cmp	esi, ebx
	je	@@1
	call	_MemFree, edi

@@9:	call	_FileClose, [@@D]
@@9b:	call	_FileClose, [@@S]
@@9a:	leave
	ret

@@2:	xor	eax, eax
	lodsw
	sub	al, 30h
	cmp	eax, 0Ah
	jb	@@2a
	or	al, 20h
	sub	al, 31h
	cmp	eax, 6
	jae	@@9a
	add	al, 0Ah
@@2a:	ret
ENDP
