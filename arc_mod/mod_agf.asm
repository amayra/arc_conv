
_mod_agf PROC
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

	call	@@3, esi
	test	eax, eax
	je	@@9b
	xchg	esi, eax
	call	_MemFree, eax

	call	_FileCreate, dword ptr [ebp+10h], FILE_OUTPUT
	jc	@@9b
	xchg	edi, eax

	; "Yukioni-ya Onsen-ki"
	; PgsvTd.dll
	; 10003740 agf_unpack
	; 10003C30 agf_write

	call	_FileWrite, edi, esi, dword ptr [esi+8]
	call	_FileClose, edi
@@9b:	call	_MemFree, esi
@@9a:	leave
	ret

@@3 PROC

@@S = dword ptr [ebp+14h]

@@D = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	eax, [esi]
	imul	eax, [esi+4]
	mov	edx, eax
	shr	edx, 17h
	add	eax, edx
	shl	eax, 2
	add	eax, 74h+4
	call	_MemAlloc, eax
	push	eax	; @@D
	jc	@@9
	xchg	edi, eax

	mov	eax, 'FGA'
	stosd
	xor	eax, eax
	inc	eax
	stosd
	stosd
	mov	al, 74h
	stosd
	xor	eax, eax
	stosd
	stosd

	mov	al, 5Ch		; 18h+0
	stosd
	mov	eax, [esi]
	mov	edx, [esi+4]
	stosd
	xchg	eax, edx
	stosd
	xchg	eax, edx
	stosd
	xchg	eax, edx
	stosd

	xor	eax, eax	; 18h+14h
	stosd
	stosd
	stosd
	finit
	fild	dword ptr [esi]
	fstp	dword ptr [edi]
	fild	dword ptr [esi+4]
	fstp	dword ptr [edi+4]
	add	edi, 8
	mov	eax, 3F000000h
	stosd
	stosd
	mov	eax, 8101h
	stosd
	xor	eax, eax
	stosd
	mov	eax, 100h
	stosd
	xor	eax, eax
	lea	ecx, [eax+8]
	rep	stosd

	mov	ecx, [esi]
	imul	ecx, [esi+4]
	add	esi, 8
	call	_agf_pack, edi, -1, esi, ecx
	add	eax, 74h
	mov	[edi-74h+8], eax
@@9:	mov	eax, [@@D]
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
	add	eax, 8
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

	mov	ecx, edx
	mov	eax, [esi+0Ch]
	neg	ecx
	mov	esi, [esi+8]
	lea	eax, [eax+ecx*4]
	mov	[@@S], eax
@@1:	mov	ecx, edx
	rep	movsd
	add	esi, [@@S]
	dec	[@@H]
	jne	@@1
	pop	eax
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP

ENDP

_agf_pack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@M = dword ptr [ebp-4]
@@D = dword ptr [ebp-8]
@@L0 = dword ptr [ebp-0Ch]

@tblcnt = 1000h

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	call	_MemAlloc, 10000h*4+@tblcnt*2
	jc	@@9a
	push	eax
	mov	esi, [@@SB]
	xchg	edi, eax
	mov	ecx, 10000h
	lea	eax, [esi-(@tblcnt+1)*4]
	rep	stosd
	push	edi
	push	ecx
	mov	edi, [@@DB]
	cmp	[@@SC], ecx
	je	@@9b
@@1:	push	edi
	mov	ecx, [@@SC]
	lea	edi, [esi+4]
	dec	ecx
	mov	eax, 0FFFFFFh
	je	@@1c
	cmp	ecx, eax
	jb	$+3
	xchg	ecx, eax
	mov	eax, [esi]
	repe	scasd
	je	@@1c
	sub	edi, 4
@@1c:	lea	ecx, [edi-4]
	pop	edi
	sub	ecx, esi
	shr	ecx, 2
	jne	@@1d
@@1f:	inc	[@@L0]
	call	@@next
@@1a:	mov	ecx, [@@SC]
	cmp	ecx, 2
	jb	@@1
	call	@@match
	test	ecx, ecx
	je	@@1
	; ecx - address, eax - count
	push	eax
	call	@@2
	pop	eax
	neg	ecx
	mov	ebx, eax
	shl	eax, 14h
	shl	ecx, 8
	lea	eax, [eax+ecx+4]
	stosd
@@1b:	call	@@next
	dec	ebx
	jne	@@1b
	jmp	@@1a

@@1d:	cmp	ecx, 1
	jne	@@1e
	cmp	[@@L0], 0
	jne	@@1f
@@1e:	inc	ecx
	call	@@2
	mov	ebx, ecx
	shl	ecx, 8
	lea	eax, [ecx+2]
	stosd
	mov	eax, [esi]
	stosd
	jmp	@@1b

@@9:	lodsd
@@9b:	call	@@2
	call	_MemFree, [@@M]
	mov	esi, [@@SC]
	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@2:	push	ecx
	mov	ebx, [@@L0]
	test	ebx, ebx
	je	@@2b
	mov	ecx, ebx
	neg	ecx
	lea	esi, [esi+ecx*4]
@@2a:	mov	ecx, 0FFFFFFh
	sub	ebx, ecx
	jae	$+6
	add	ecx, ebx
	xor	ebx, ebx
	mov	eax, ecx
	shl	eax, 8
	inc	eax
	stosd
	rep	movsd
	test	ebx, ebx
	jne	@@2a
	mov	[@@L0], ebx
@@2b:	pop	ecx
	ret

@@next:	dec	[@@SC]
	je	@@9
	imul	eax, [esi], 4C11DB7h
	imul	edx, [esi+4], 4C11DB7h*5
	xor	eax, edx
	shr	eax, 10h
	mov	edx, [@@M]
	mov	ecx, esi
	xchg	ecx, [edx+eax*4]
	sub	ecx, esi
	shr	ecx, 2
	cmp	ecx, -@tblcnt+1
	sbb	eax, eax
	neg	ecx
	mov	edx, esi
	or	ecx, eax
	shr	edx, 2
	mov	eax, [@@D]
	and	edx, @tblcnt-1
	mov	[eax+edx*2], cx
	add	esi, 4
	ret

@@match PROC
	push	edi
	push	0	; D
	push	1	; C = min-1
	mov	ebx, 0FFFh
	cmp	ecx, ebx
	jae	$+4
	mov	ebx, ecx
	imul	eax, [esi], 4C11DB7h
	imul	edx, [esi+4], 4C11DB7h*5
	xor	eax, edx
	shr	eax, 10h
	mov	ecx, [ebp-4]
	mov	ecx, [ecx+eax*4]
	sub	ecx, esi
	sar	ecx, 2
	jmp	@@3

@@4:	lea	edi, [esi+ecx*4]
	push	ecx
	neg	ecx
	xor	edx, edx
	cmp	ecx, ebx
	jb	$+4
	mov	ecx, ebx
@@5:	mov	eax, [esi+edx*4]
	cmp	[edi+edx*4], eax
	jne	@@6
	inc	edx
	cmp	edx, ecx
	jb	@@5
@@6:	pop	ecx
	pop	eax
	cmp	eax, edx
	jae	@@2
	xchg	eax, edx
	pop	edx
	cmp	eax, ebx
	jae	@@9
	push	ecx
@@2:	push	eax
	shr	edi, 2
	and	edi, @tblcnt-1
	mov	edx, [ebp-8]
	movzx	edi, word ptr [edx+edi*2]
	sub	ecx, edi
@@3:	cmp	ecx, -0FFFh	; !!!
	jae	@@4
	pop	eax
	pop	ecx
@@9:	pop	edi
	ret
ENDP

ENDP
