
	dw 0
_arc_leaf_am PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@L0
@M0 @@L1

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 9
	jc	@@9a
	pop	eax
	pop	ebx
	cmp	eax, '00ma'
	jne	@@9a
	cmp	ebx, 9
	jb	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	pop	eax
	mov	edx, esi
	mov	ecx, ebx
@@2a:	xor	[edx], al
	inc	edx
	dec	ecx
	jne	@@2a
	call	@@5
	lea	ecx, [eax-1]
	mov	[@@N], eax
	shr	ecx, 14h
	jne	@@9
	call	_ArcCount, eax
	call	_ArcDbgData, esi, ebx
	lea	eax, [ebx+9]
	mov	[@@P], eax

	call	_ArcParamNum, 1
	db 'leaf_am', 0
	cmp	eax, 3
	sbb	edx, edx
	and	eax, edx
	mov	[@@L1], eax
	cmp	eax, 2
	jne	@@1
	call	_LoadTable, 3
	mov	[@@L0], eax

@@1:	mov	edi, esi
	xor	eax, eax
	repne	scasb
	call	_ArcName, esi, -1
	and	[@@D], 0

	cmp	[@@L1], 1
	jne	@@2d
	call	_sjis_lower, esi
	xor	edx, edx
@@2b:	lodsb
	cmp	al, 2Eh
	je	@@2c
	xor	dl, al
	test	al, al
	jne	@@2b
@@2c:	mov	[@@L0], edx
@@2d:
	lea	esi, [edi+8]
	mov	eax, [edi]
	mov	ebx, [edi+4]
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	test	ebx, ebx
	je	@@1a
	mov	edx, [@@L0]
	mov	eax, [@@L1]
	mov	edi, [@@D]
	dec	eax
	jne	@@2f
	mov	ecx, ebx
@@2e:	xor	[edi], dl
	inc	edi
	dec	ecx
	jne	@@2e
	jmp	@@1a

@@2f:	dec	eax
	jne	@@1a
	test	edx, edx
	je	@@1a
	xor	ecx, ecx
	push	ebx
@@2g:	mov	al, [edx+ecx]
	xor	[edi], al
	inc	edi
	inc	cx
	dec	ebx
	jne	@@2g
	pop	ebx
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5:	push	edi
	mov	ecx, ebx
	mov	edi, esi
	xor	eax, eax
	cdq
@@5a:	sub	ecx, 8
	jbe	@@5b
	repne	scasb
	jne	@@5b
	add	edi, 8
	inc	edx
	jmp	@@5a

@@5b:	xchg	eax, edx
	pop	edi
	ret
ENDP
