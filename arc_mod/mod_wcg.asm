
; 8 0x100 -> 0xC + 0x200 + 0x149
; 12 0x2000 -> 0xC + 0x2000 + 0x2409
; 16 0x20000 -> 0xC + 0x1FFFE + 0x26802

; max8 = 0x20C + ((c * 3) >> 1)
; max16 = 0x2000A + ((c * 5) >> 1)

_mod_lim PROC

@@L0 = dword ptr [ebp-4]

	push	ebp
	mov	ebp, esp
	cmp	eax, 3
	jne	@@9a
	mov	esi, [ebp+0Ch]
	movzx	eax, word ptr [esi]
	sub	eax, 31h
	cmp	eax, 3
	jae	@@9a
	cmp	word ptr [esi+2], 0
	jne	@@9a
	xchg	ebx, eax
	call	_Bm32ReadFile, dword ptr [ebp+10h]
	test	eax, eax
	je	@@9a
	xchg	esi, eax

	dec	ebx
	dec	ebx
	je	@@3

	call	@@Img16, esi
	test	eax, eax
	je	@@9b
	push	edx	; @@L0
	xchg	esi, eax
	call	_MemFree, eax

	inc	ebx
	jne	@@2

	mov	eax, [esi+8]
	lea	eax, [eax*4+eax]
	shr	eax, 1
	add	eax, 2000Ah
	call	_MemAlloc, eax
	test	eax, eax
	je	@@9b
	xchg	ebx, eax

	call	_FileCreate, dword ptr [ebp+14h], FILE_OUTPUT
	jc	@@9c
	xchg	edi, eax

	cmp	[@@L0], 1
	sbb	eax, eax
	lea	eax, [eax*2+eax+3]
	shl	eax, 18h
	add	eax, 000324D4Ch
	push	dword ptr [esi+4]
	push	dword ptr [esi]
	push	000080010h
	push	eax
	mov	edx, esp
	call	_FileWrite, edi, edx, 10h

	lea	edx, [esi+0Ch+2]
	call	_wcg_pack, ebx, -1, edx, dword ptr [esi+8], 1, 4
	call	_FileWrite, edi, ebx, eax

	cmp	[@@L0], 0
	je	@@9
	lea	edx, [esi+0Ch]
	call	_wcg_pack, ebx, -1, edx, dword ptr [esi+8], 0, 4
	call	_FileWrite, edi, ebx, eax

@@9:	call	_FileClose, edi
@@9c:	call	_MemFree, ebx
@@9b:	call	_MemFree, esi
@@9a:	leave
	ret

@@2:	call	_FileCreate, dword ptr [ebp+14h], FILE_OUTPUT
	jc	@@9b
	xchg	edi, eax
	push	dword ptr [esi+4]
	push	dword ptr [esi]
	push	000000010h
	push	000014D4Ch
	mov	edx, esp
	call	_FileWrite, edi, edx, 10h

	push	esi
	push	edi
	lea	edi, [esi+0Ch]
	mov	ecx, [esi+8]
	mov	esi, edi
@@2a:	lodsd
	shr	eax, 10h
	stosw
	dec	ecx
	jne	@@2a
	pop	edi
	pop	esi

	mov	ecx, [esi+8]
	lea	edx, [esi+0Ch]
	shl	ecx, 1
	call	_FileWrite, edi, edx, ecx
	call	_FileClose, edi
	jmp	@@9b

@@3:	call	@@Img32, esi
	test	eax, eax
	je	@@9b
	xchg	esi, eax
	call	_MemFree, eax

	mov	eax, [esi+8]
	lea	eax, [eax*2+eax]
	shr	eax, 1
	add	eax, 20Ch
	call	_MemAlloc, eax
	test	eax, eax
	je	@@9b
	xchg	ebx, eax

	call	_FileCreate, dword ptr [ebp+14h], FILE_OUTPUT
	jc	@@9c
	xchg	edi, eax
	push	dword ptr [esi+4]
	push	dword ptr [esi]
	push	000080018h
	push	0F5534D4Ch
	mov	edx, esp
	call	_FileWrite, edi, edx, 10h

	push	3
	pop	edx
@@3a:	push	edx
	lea	edx, [esi+0Ch+edx]
	call	_wcg_pack, ebx, -1, edx, dword ptr [esi+8], 0, 4
	call	_FileWrite, edi, ebx, eax
	pop	edx
	dec	edx
	jns	@@3a
	jmp	@@9

_mod_wcg:
	push	ebp
	mov	ebp, esp
	cmp	eax, 2
	jne	@@9a
	call	_Bm32ReadFile, dword ptr [ebp+0Ch]
	test	eax, eax
	je	@@9a
	xchg	esi, eax

	call	@@Img32, esi
	test	eax, eax
	je	@@9b
	xchg	esi, eax
	call	_MemFree, eax

	mov	eax, [esi+8]
	lea	eax, [eax*4+eax]
	shr	eax, 1
	add	eax, 2000Ah
	call	_MemAlloc, eax
	test	eax, eax
	je	@@9b
	xchg	ebx, eax

	call	_FileCreate, dword ptr [ebp+10h], FILE_OUTPUT
	jc	@@9c
	xchg	edi, eax
	push	dword ptr [esi+4]
	push	dword ptr [esi]
	push	000000020h
	push	002714757h
	mov	edx, esp
	call	_FileWrite, edi, edx, 10h

	lea	edx, [esi+0Ch+2]
	call	_wcg_pack, ebx, -1, edx, dword ptr [esi+8], 1, 4
	call	_FileWrite, edi, ebx, eax

	lea	edx, [esi+0Ch]
	call	_wcg_pack, ebx, -1, edx, dword ptr [esi+8], 1, 4
	call	_FileWrite, edi, ebx, eax
	jmp	@@9

@@Img16 PROC

@@S = dword ptr [ebp+14h]

@@H = dword ptr [ebp-4]
@@M = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@S]
	mov	eax, [esi]
	mov	ebx, [esi+4]
	imul	eax, ebx
	shl	eax, 2
	add	eax, 0Ch
	call	_MemAlloc, eax
	jc	@@9
	push	ebx
	push	eax
	xchg	edi, eax

	mov	eax, [esi]
	stosd
	xchg	edx, eax
	mov	eax, ebx
	stosd
	imul	eax, edx
	stosd

	mov	ecx, edx
	mov	eax, [esi+0Ch]
	neg	ecx
	mov	esi, [esi+8]
	lea	eax, [eax+ecx*4]
	mov	[@@S], eax
	xor	ebx, ebx
@@1:	mov	ecx, edx
@@2:	; 888 -> 565
	lodsd
	ror	eax, 8
	shr	ah, 3
	shr	ax, 2
	ror	eax, 0Bh
	shr	ax, 5
	xor	al, -1
	or	ebx, eax
	stosd
	dec	ecx
	jne	@@2
	add	esi, [@@S]
	dec	[@@H]
	jne	@@1
	pop	eax
@@9:	movzx	edx, bl
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP

@@Img32 PROC

@@S = dword ptr [ebp+14h]

@@H = dword ptr [ebp-4]
@@M = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@S]
	mov	eax, [esi]
	mov	ebx, [esi+4]
	imul	eax, ebx
	shl	eax, 2
	add	eax, 0Ch
	call	_MemAlloc, eax
	jc	@@9
	push	ebx
	push	eax
	xchg	edi, eax

	mov	eax, [esi]
	stosd
	xchg	edx, eax
	mov	eax, ebx
	stosd
	imul	eax, edx
	stosd

	mov	ecx, edx
	mov	eax, [esi+0Ch]
	neg	ecx
	mov	esi, [esi+8]
	lea	eax, [eax+ecx*4]
	mov	[@@S], eax
	xor	ebx, ebx
@@1:	mov	ecx, edx
@@2:	lodsd
	xor	eax, 0FF000000h
	stosd
	or	ebx, eax
	dec	ecx
	jne	@@2
	add	esi, [@@S]
	dec	[@@H]
	jne	@@1
	pop	eax
@@9:	mov	edx, ebx
	shr	edx, 18h
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP

ENDP

_wcg_pack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L3 = dword ptr [ebp+24h]
@@A = dword ptr [ebp+28h]

@@L5 = dword ptr [ebp-4]
@@L4 = dword ptr [ebp-8]
@@C = dword ptr [ebp-0Ch]
@@L1 = dword ptr [ebp-10h]
@@L0 = dword ptr [ebp-14h]

	push	ebx
	push	esi
	push	edi
	enter	14h, 0
	mov	ebx, [@@SC]
	cmp	[@@L3], 0
	je	@@2b
	call	_MemAlloc, 80000h
	jc	@@9a
	xchg	esi, eax
	mov	ecx, 20000h
	jmp	@@2d

@@2b:	sub	esp, 800h
	mov	esi, esp
	mov	ecx, 200h
@@2d:	mov	edi, esi
	xor	eax, eax
	rep	stosd

	mov	edx, [@@SB]
	or	edi, -1
@@4:	movzx	eax, byte ptr [edx]
	cmp	[@@L3], 0
	je	@@4a
	mov	ah, [edx+1]
@@4a:	add	edx, [@@A]
	cmp	eax, edi
	jne	@@4b
	inc	ecx
	cmp	ecx, 11h
	jb	@@4c
@@4b:	xor	ecx, ecx
	inc	dword ptr [esi+eax*8]
@@4c:	xchg	edi, eax
	dec	ebx
	jne	@@4

	xor	ecx, ecx
	mov	edi, 100h
	cmp	[@@L3], ecx
	je	@@2e
	shl	edi, 8
@@2e:	cmp	dword ptr [esi+ebx*8], 0
	je	@@2f
	mov	[esi+ecx*8+4], ebx
	inc	ecx
@@2f:	inc	ebx
	dec	edi
	jne	@@2e
	mov	[@@L4], esi
	mov	[@@C], ecx

	; Sort
	xor	ecx, ecx
	jmp	@@2h
@@2g:	mov	eax, [ebx-4]
	mov	edx, [ebx+4]
	mov	edi, [esi+eax*8]
	cmp	edi, [esi+edx*8]
	jae	@@2h
	mov	[ebx-4], edx
	mov	[ebx+4], eax
	sub	ebx, 8
	cmp	ebx, esi
	jne	@@2g
@@2h:	inc	ecx
	lea	ebx, [esi+ecx*8]	
	cmp	ecx, [@@C]
	jb	@@2g

	mov	eax, [@@C]
	mov	ecx, [@@L3]
	xor	edx, edx
	cmp	eax, 1001h
	sbb	eax, eax
	lea	edx, [edx+eax*8+0Eh]
	sub	eax, 1Fh-4
	neg	eax
	mov	[@@L1], edx
	mov	[@@L0], eax

	mov	eax, [@@SC]
	mov	edi, [@@DB]
	shl	eax, cl
	mov	[edi], eax
	add	edi, 8
	mov	eax, [@@C]
	mov	ecx, eax
	shr	ecx, 10h
	sub	eax, ecx
	stosd

	xor	ebx, ebx
@@6:	cmp	bx, -1
	mov	eax, [esi+ebx*8+4]
	jne	@@6a
	xor	al, 1
	mov	eax, [esi+eax*8]
	jmp	@@6c
@@6a:	stosb
	cmp	[@@L3], 0
	je	@@6b
	mov	al, ah
	stosb
@@6b:	call	@@5
	mov	edx, [esi+ebx*8+4]
@@6c:	mov	[esi+edx*8], eax
	inc	ebx
	cmp	ebx, [@@C]
	jne	@@6
	mov	[@@L5], edi

	xor	ebx, ebx
	mov	edx, [@@SB]
	inc	ebx
@@1:	or	ecx, -1
	cmp	[@@L3], 0
	je	@@1b
	movzx	eax, word ptr [edx]
	add	edx, [@@A]
@@1a:	cmp	[@@SC], 1
	je	@@1d
	cmp	ax, [edx]
	jne	@@1d
	dec	[@@SC]
	inc	ecx
	add	edx, [@@A]
	cmp	ecx, 0Fh
	jb	@@1a
	jmp	@@1d

@@1b:	movzx	eax, byte ptr [edx]
	add	edx, [@@A]
@@1c:	cmp	[@@SC], 1
	je	@@1d
	cmp	al, [edx]
	jne	@@1d
	dec	[@@SC]
	inc	ecx
	add	edx, [@@A]
	cmp	ecx, 0Fh
	jb	@@1c
@@1d:	test	ecx, ecx
	js	@@1e
	push	eax
	xchg	eax, ecx
	mov	ecx, [@@L0]
	shl	eax, 1
	sub	ecx, 4
	inc	eax
	shl	eax, cl
	call	@@3
	pop	eax
@@1e:	mov	eax, [esi+eax*8]
	call	@@3
	dec	[@@SC]
	jne	@@1

	mov	eax, ebx
	dec	ebx
	je	@@9c
@@9d:	add	al, al
	jnc	@@9d
	stosb
@@9c:	cmp	[@@L3], 0
	je	@@9b
	call	_MemFree, esi	; [@@L4]
@@9b:	mov	ecx, edi
	mov	eax, [@@DB]
	sub	ecx, [@@L5]
	mov	[eax+4], ecx
	sub	edi, eax
	xchg	eax, edi
@@9a:	cmp	eax, 1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	18h

@@3a:	adc	bl, bl
	jnc	@@3
	mov	[edi], bl
	inc	edi
	mov	bl, 1
@@3:	shl	eax, 1
	jne	@@3a
	ret

@@5:	push	esi
	push	edi
	xor	edx, edx
	mov	edi, [@@L1]
	xor	ecx, ecx
	bsr	edx, ebx
	mov	esi, [@@L0]
	cmp	edx, 1
	adc	ecx, edx
	lea	eax, [edx+1]
	sub	edx, edi
	jb	@@5b
	lea	eax, [edi+1]
@@5a:	shl	eax, 1
	dec	esi
	inc	eax
	dec	edx
	jns	@@5a
	dec	eax
@@5b:	pop	edi
	xor	edx, edx
	sub	esi, ecx
	inc	edx
	shl	edx, cl
	dec	edx
	and	edx, ebx
	shl	eax, cl
	mov	ecx, esi
	add	eax, edx
	pop	esi
	shl	eax, 1
	inc	eax
	shl	eax, cl
	ret
ENDP
