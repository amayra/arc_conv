
_mod_dx3dec PROC

@@stk = 0
@M0 @@L0, 0Ch
@M0 @@S
@M0 @@D
@M0 @@L1

	enter	0Ch, 0
	dec	eax
	jne	@@4a
	call	_FileCreate, dword ptr [ebp+0Ch], FILE_PATCH
	jc	@@9a
	push	eax
	push	-1
	jmp	@@4b

@@4a:	dec	eax
	jne	@@9a
	call	_FileCreate, dword ptr [ebp+0Ch], FILE_INPUT
	jc	@@9a
	push	eax
	call	_FileCreate, dword ptr [ebp+10h], FILE_OUTPUT
	jc	@@9b
	push	eax
@@4b:	push	0

	mov	ebx, 0FFCh
	sub	esp, ebx
	push	ecx
	add	ebx, 4
	mov	edi, esp
	push	ebx
	call	_FileRead, [@@S], edi, ebx
	cmp	eax, 18h
	jb	@@9
	xchg	esi, eax
	call	_FileGetSize, [@@S]
	jc	@@9
	xchg	ebx, eax

	; dd 'XD' + 30000h, dir_size, 18h
	; dd dir_offs, dir_mid, dir_tail

	mov	edx, [edi+8]
	mov	eax, [edi]
	xor	edx, 18h
	xor	eax, 35844h
	mov	[@@L0+8], edx
	xor	edx, [edi+14h]
	mov	[@@L0], eax
	xor	eax, [edi+0Ch]
	sub	ebx, eax
	lea	ecx, [ebx-10h]
	xor	ebx, [edi+4]
	sub	ecx, edx
	mov	[@@L0+4], ebx
	xor	ebx, [edi+10h]
	ror	ecx, 4
	cmp	ebx, edx
	jae	@@9
	shr	ecx, 14h
	jne	@@9
	pop	ebx
	mov	eax, [@@L0]
	or	eax, [@@L0+4]
	or	eax, [@@L0+8]
	je	@@9
	jmp	@@1a

@@1:	call	_FileRead, [@@S], edi, ebx
	test	eax, eax
	je	@@9
	xchg	esi, eax
@@1a:
	mov	ecx, [@@L1]
	push	esi
@@2:	mov	al, byte ptr [@@L0+ecx]
	xor	[edi], al
	inc	edi
	inc	ecx
	cmp	ecx, 0Ch
	sbb	eax, eax
	and	ecx, eax
	dec	esi
	jne	@@2
	pop	esi
	mov	[@@L1], ecx
	mov	edi, esp

	mov	eax, [@@D]
	cmp	eax, -1
	jne	@@1b
	mov	eax, esi
	neg	eax
	call	_FileSeek, [@@S], eax, 1
	mov	eax, [@@S]
@@1b:	call	_FileWrite, eax, edi, esi
	cmp	esi, ebx
	je	@@1

@@9:	call	_FileClose, [@@D]
@@9b:	call	_FileClose, [@@S]
@@9a:	leave
	ret
ENDP
