
_FileEnum PROC

@@C = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]

@@stk = 0
@M0 @@B
@M0 @@L0, 0Ch
@M0 @@L1, 1Ch

	push	ebx
	push	esi
	push	edi
	enter	@@stk, 0
	call	_BlkCreate, 1000h
	jc	@@9a
	mov	[@@B], eax
	xchg	ebx, eax
	call	_BlkAlloc, ebx, 0Ch
	jc	@@9
	mov	[eax], ebx
	add	eax, 4
	xor	ecx, ecx
	mov	[@@L0], eax
	mov	[@@L0+4], eax
	mov	[@@L0+8], ecx
	mov	[eax], ecx

@@1:	mov	eax, [@@C]
	test	eax, eax
	je	@@7
	dec	eax
	mov	esi, [@@S]
	add	[@@S], 4
	mov	esi, [esi]
	cmp	eax, -2
	jne	@@1a
	inc	eax
	test	esi, esi
	je	@@7
@@1a:	mov	[@@C], eax

	xor	ebx, ebx
	test	esi, esi
	je	@@2a
	movzx	eax, word ptr [esi]
	test	eax, eax
	je	@@2a
	cmp	eax, '?'
	je	@@2
@@1b:	movzx	eax, word ptr [esi+ebx*2]
	inc	ebx
	cmp	eax, 2Ah
	je	@@4
	test	eax, eax
	jne	@@1b
	lea	edi, [ebx+ebx]
	call	@@Next
	call	@@Test
	jc	@@1
	call	@@Add
	jmp	@@1

@@7:	mov	edx, [@@L0]
	mov	ebx, [@@L0+8]
	mov	eax, [@@L0+4]
	and	dword ptr [edx], 0
	mov	[eax+4], ebx
	jmp	@@9a

@@9:	call	_BlkDestroy, [@@B]
	xor	eax, eax
@@9a:	cmp	eax, 1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@Add:	call	_BlkAlloc, [@@B], edi
	jc	@@9
	xchg	edi, eax
	mov	edx, [@@L0]
	xchg	ecx, eax
	mov	[edx+4], edi
	rep	movsb
	ret

@@Next:	cmp	dword ptr [@@L0+8], 100000h
	jae	@@9
	mov	edx, [@@L0]
	mov	eax, [edx]
	test	eax, eax
	jne	@@7a
	call	_BlkAlloc, [@@B], 8
	jc	@@9
	mov	edx, [@@L0]
	and	dword ptr [eax], 0
	mov	[edx], eax
@@7a:	mov	[@@L0], eax
	xor	ecx, ecx
	inc	[@@L0+8]
	mov	[eax], ecx
	mov	[eax+4], ecx
	ret

@@2:	inc	esi
	inc	esi
	cmp	word ptr [esi], 0
	je	@@2a
	mov	edx, esi
	call	@@Num
	test	eax, eax
	jne	@@2b
	test	ecx, ecx
	je	@@2b
	lea	ebx, [ecx-1]
@@2a:	call	@@Next
	dec	ebx
	jns	@@2a
@@2b:	jmp	@@1

@@4:	xor	eax, eax
	mov	[@@L1+4], eax
	mov	[@@L1+8], eax
	mov	[@@L1+0Ch], eax
	lea	edx, [esi+ebx*2]
	dec	ebx
	call	@@Num
	cmp	ecx, 10
	ja	@@2b
	mov	[@@L1], ecx
	cmp	eax, '+'
	jne	@@4a
	call	@@Num
	mov	[@@L1+4], ecx
@@4a:	cmp	eax, '-'
	je	@@4b
	cmp	eax, '='
	je	@@4b
	cmp	eax, '?'
	jne	@@4c
@@4b:	mov	[@@L1+8], eax
	call	@@Num
	test	ecx, ecx
	je	@@2b
	mov	[@@L1+0Ch], ecx
@@4c:	cmp	eax, 2Ah
	jne	@@2b

	xor	ecx, ecx
	mov	[@@L1+10h], edx
@@4d:	movzx	eax, word ptr [edx+ecx*2]
	inc	ecx
	test	eax, eax
	jne	@@4d
	mov	edx, [@@L0]
	mov	[@@L1+14h], ecx
	mov	[@@L1+18h], edx
	lea	eax, [ecx+ebx+10+1]
	shl	eax, 1
	and	al, -4
	cmp	eax, 1000h
	jae	@@5b
	sub	esp, eax
	mov	edi, esp
	mov	ecx, ebx
	rep	movsw
@@5a:	lea	edi, [esp+ebx*2]
	mov	eax, [@@L1+4]
	inc	[@@L1+4]
	call	@@Dec, [@@L1]
	mov	esi, [@@L1+10h]
	mov	ecx, [@@L1+14h]
	rep	movsw
	mov	esi, esp
	sub	edi, esp
	call	@@Test
	jc	@@5c
	call	@@Next
	call	@@Add
	mov	[@@L1+18h], edx
	jmp	@@5e
@@5c:	mov	eax, [@@L1+8]
	test	eax, eax
	je	@@5b
	cmp	eax, '?'
	je	@@5e
	call	@@Next
@@5e:	mov	eax, [@@L1+0Ch]
	dec	eax
	js	@@5a
	mov	[@@L1+0Ch], eax
	jne	@@5a

	cmp	[@@L1+8], '-'
	jne	@@5b
	mov	edx, [@@L1+18h]
	mov	[@@L0], edx
	or	ecx, -1
@@5d:	mov	edx, [edx]
	inc	ecx
	test	edx, edx
	jne	@@5d
	sub	[@@L0+8], ecx
@@5b:	lea	esp, [ebp-@@stk]
	jmp	@@1

@@Num PROC
	xor	ecx, ecx
	movzx	eax, word ptr [edx]
	inc	edx
	inc	edx
	sub	al, 30h
	cmp	eax, 0Ah
	jae	@@9
@@2:	lea	ecx, [ecx*4+ecx]
	lea	ecx, [ecx*2+eax]
	movzx	eax, word ptr [edx]
	inc	edx
	inc	edx
	cmp	ecx, 1999999Ah
	jae	@@9
	sub	al, 30h
	cmp	eax, 0Ah
	jb	@@2
	add	al, 30h
	ret
@@9:
ENDP
	jmp	@@1

@@Test PROC
	call	_FileCreate, esi, FILE_INPUT
	jc	@@9
	call	_FileClose, eax
	xor	eax, eax
@@9:	ret
ENDP

@@Dec PROC
	push	ebx
	push	edi
	cmp	eax, 10
	jb	@@2
	mov	ecx, 0CCCCCCCDh
@@1:	mov	ebx, eax
	mul	ecx
	shr	edx, 3
	mov	eax, edx
	lea	edx, [edx*4+edx-18h]
	add	edx, edx
	sub	ebx, edx
	mov	[edi], bx
	inc	edi
	inc	edi
	cmp	eax, 10
	jae	@@1
@@2:	pop	ebx
	add	al, 30h
	stosw
	mov	ecx, [esp+8]
	mov	edx, edi
	sub	edx, ebx
	shr	edx, 1
	sub	ecx, edx
	jbe	@@3
	add	edx, ecx
	mov	al, 30h
	rep	stosw
@@3:	shr	edx, 1
	je	@@5
	push	edi
@@4:	dec	edi
	dec	edi
	mov	ax, [ebx]
	mov	cx, [edi]
	mov	[edi], ax
	mov	[ebx], cx
	inc	ebx
	inc	ebx
	dec	edx
	jne	@@4
	pop	edi
@@5:	pop	ebx
	ret	4
ENDP

ENDP

