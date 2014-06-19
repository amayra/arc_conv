
; "Episode of the Clovers" *.dat

_mod_repipack2 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	lea	esp, [ebp-@@stk]
	mov	[@@L0], edi
@@1:	mov	eax, [@@L0]
	push	40h
	pop	ebx
	cmp	byte ptr [eax], 1
	jne	@@1b
	add	ebx, 4
@@1b:	call	_ArcName, esi, ebx
	mov	eax, [esi+ebx]
	mov	edi, [esi+ebx+4]
	mov	ebx, [esi+ebx+8]
	and	[@@D], 0
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	cmp	ebx, edi
	jne	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	call	@@3
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 50h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	call	_ArcMemRead, eax, edi, ebx, 0
	xchg	ebx, eax
	call	@@3
	call	_lzss_unpack, [@@D], edi, edx, ebx
	xchg	ebx, eax
	jmp	@@1a

@@3:	push	edx
	push	ebx
	push	edi
	mov	ecx, ebx
	mov	edi, edx
	mov	ebx, [@@L0]
	mov	edx, [ebx+0Ch]
	cmp	byte ptr [ebx], 1
	je	@@3d
	mov	eax, [esi+4Ch]
	dec	eax
	shr	eax, 1
	jne	@@3b
	jc	@@4
@@3d:	shr	ecx, 2
	je	@@3b
	cmp	byte ptr [ebx+1], 0
	mov	ebx, [ebx+4]
	jne	@@3c
@@3a:	mov	eax, [edi]
	xor	eax, edx
	mov	[edi], eax
	add	edi, 4
	rol	eax, 10h
	xor	eax, ebx
	add	edx, eax
	dec	ecx
	jne	@@3a
@@3b:	pop	edi
	pop	ebx
	pop	edx
	ret

@@3c:	mov	eax, [edi]
	xor	eax, edx
	mov	[edi], eax
	add	edi, 4
	add	edx, eax
	add	edx, ebx
	dec	ecx
	jne	@@3c
	jmp	@@3b

@@4d:	xor	[edi], dl
	inc	edi
	dec	ecx
	jne	@@4d
	jmp	@@3b

@@4:	cmp	byte ptr [ebx+1], 0
	jne	@@4d
	movzx	ebx, dl
	sub	ecx, 4
	jb	@@3b
	imul	ebx, 1010101h
@@4a:	mov	eax, [edi]
	mov	edx, eax
	shr	eax, 2
	shl	edx, 6
	xor	eax, ebx
	xor	eax, edx
	and	eax, 3F3F3F3Fh
	xor	eax, edx
	mov	[edi], eax
	add	edi, 4
	sub	ecx, 4
	jae	@@4a
@@4b:	and	ecx, 3
	je	@@3b
@@4c:	mov	al, [edi]
	ror	al, 2
	xor	al, bl
	mov	[edi], al
	inc	edi
	dec	ecx
	jne	@@4c
	jmp	@@3b
ENDP
