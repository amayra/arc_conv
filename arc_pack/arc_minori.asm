
_arc_minori PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@P
@M0 @@M
@M0 @@DC
@M0 @@L0, 8
@M0 @@L1, 8
@M0 @@L2
@M0 @@L3
@M0 @@L4
@M0 @@L5
@M0 @@L6
@M0 @@L7, 8

	enter	@@stk, 0
	mov	eax, [@@PC]
	mov	esi, [@@PB]
	test	eax, eax
	je	@@4g
	dec	eax
	jne	@@9a
	call	_minori_select, dword ptr [esi]
	jc	@@9a
@@4g:	mov	[@@L0], eax
	call	_minori_table, eax
	mov	[@@L4], eax
	xchg	edi, eax

	call	_minori_test, [@@L0], dword ptr [esi-4]		; outFileName
	movzx	ecx, byte ptr [edi+ecx+1]
	shl	eax, 8
	mov	[@@L3], eax
	mov	[@@L5], ecx

	xor	ecx, ecx
	movzx	eax, word ptr [edx]
	or	al, 20h
	cmp	eax, 's'
	jne	@@4j
	movzx	eax, word ptr [edx+2]
	or	al, 20h
	cmp	eax, 'y'
	jne	@@4j
	movzx	eax, word ptr [edx+4]
	or	al, 20h
	cmp	eax, 's'
	jne	@@4j
	movzx	eax, word ptr [edx+6]
	cmp	eax, 2Eh
	je	@@4i
	sub	al, 30h
	cmp	eax, 0Ah
	jae	@@4j
@@4i:	inc	ecx
@@4j:	mov	[@@L0+4], ecx

	call	@@FindName, edi, edx
	mov	[@@L1], eax

	mov	esi, [@@FL]
	mov	ebx, [esi]
	add	esi, 4
	imul	ebx, 19h
	add	ebx, 4+7
@@4a:	mov	esi, [esi]
	test	esi, esi
	je	@@4b
	add	ebx, [esi+8]
	jmp	@@4a
@@4b:	add	ebx, [@@L3]
	and	ebx, -8
	mov	esi, [@@L4]
	movzx	ecx, byte ptr [esi]
	add	esi, ecx
	movzx	edx, byte ptr [esi]
	lea	ebx, [ebx+edx+4]
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, ebx
	mov	[@@P], ebx

	lodsw
	movzx	ecx, ah
	movzx	eax, al
	sub	ebx, eax
	sub	eax, ecx
	rep	movsb
	xchg	ecx, eax
	rep	stosb

	lea	eax, [ebx-4]
	mov	esi, [@@FL]
	stosd
	mov	[@@L6], edi
	movsd
	xor	eax, eax
	cmp	[@@L3], eax
	je	@@4d
	mov	[@@L3], edi
@@4c:	stosb
	add	al, 1
	jne	@@4c
@@4d:
	mov	ebx, [@@L1]
	test	ebx, ebx
	je	@@4e
	lea	eax, [ebx+20h]
	sub	esp, 0FFCh
	push	ecx
	sub	esp, 48h
	mov	ebx, esp
	call	_blowfish_set_key@12, ebx, eax, 20h
@@4e:	mov	[@@L1+4], ebx

@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@1a
	mov	ecx, [esi+8]
	inc	ecx
	mov	eax, [esi+4]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax

	mov	eax, [@@P]
	stosd
	xor	eax, eax
	stosd

	mov	[@@L7], esi
	call	_ansi_ext, dword ptr [esi+8], dword ptr [esi+4]
	xor	edx, edx
	mov	[@@L7+4], eax
	cmp	[@@L0], edx
	jne	@@1d
	cmp	eax, 'cs'
	jne	@@1d
	dec	edx
@@1d:
	mov	eax, [esi+2Ch]
	xor	ecx, ecx
	stosd
	stosd
	stosd
	xchg	eax, ecx
	stosd
	lea	ebx, [ecx*8+ecx+3Ah+7+7*8]
	shr	ebx, 3
	and	ebx, edx
	lea	edx, [esi+30h]
	lea	eax, [@@L2]
	call	_ArcLoadFile, eax, edx, 0, ecx, ebx
	jc	@@1c
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	test	ebx, ebx
	je	@@1b
	lea	eax, [edx+ecx]
	call	_zlib_pack, eax, ebx, edx, ecx
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	cmp	eax, ecx
	jae	@@1b
	add	edx, ecx
	xchg	eax, ecx
	inc	byte ptr [edi-4]
@@1b:	lea	eax, [ecx+7]
	and	al, -8
	mov	[edi-0Ch], ecx
	mov	[edi-8], eax
	add	[@@P], eax
	push	eax
	push	edx
	push	eax
	push	edx
	push	edi
	lea	edi, [edx+ecx]
	neg	ecx
	and	ecx, 7
	xor	eax, eax
	rep	stosb
	pop	edi
	call	@@3
	call	_FileWrite, [@@D]
@@1c:	call	_MemFree, [@@L2]
	jmp	@@1

@@1a:	mov	eax, [@@L1]
	test	eax, eax
	je	@@1g
	call	_blowfish_set_key@12, [@@L1+4], eax, 20h
@@1g:
	mov	edx, [@@L6]
	mov	esi, [@@M]
	mov	ebx, edx
	mov	eax, [@@L5]
	sub	ebx, esi
	test	eax, eax
	je	@@1f
	push	esi
@@1e:	xor	[esi], al
	inc	esi
	dec	ebx
	jne	@@1e
	pop	esi
@@1f:
	mov	ecx, edx
	sub	ecx, edi
	and	ecx, 7
	xor	eax, eax
	rep	stosb
	mov	ecx, edi
	sub	ecx, edx
	sub	edi, esi
	and	[@@L7], 0
	call	@@3, edx, ecx
	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	call	_FileWrite, ebx, esi, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	push	ebx
	push	esi
	push	edi
	mov	edi, [esp+10h]
	mov	ebx, [esp+14h]
	test	ebx, ebx
	je	@@3g
	cmp	[@@L1+4], 0
	je	@@3b

	mov	esi, [@@L7]
	mov	eax, [@@L7+4]
	test	esi, esi
	je	@@3e
	cmp	[@@L0+4], 0
	je	@@3h
	cmp	eax, 'ggo'
	jne	@@3h
	cmp	ebx, 8
	jb	@@3h
	mov	ecx, 'SggO'
	mov	edx, 200h
	sub	ecx, [edi]
	sub	edx, [edi+4]
	or	ecx, edx
	je	@@3e
@@3h:	call	_minori_crypt, edi, ebx, dword ptr [esi+4], dword ptr [esi+2Ch], eax, [@@L3], [@@L4]
@@3e:
	mov	ecx, [@@L1+4]
	cmp	[@@L3], 0
	jne	@@3b
	shr	ebx, 3
	je	@@3b
@@3a:	mov	eax, [edi]
	mov	edx, [edi+4]
	call	_blowfish_encrypt
	mov	[edi], eax
	mov	[edi+4], edx
	add	edi, 8
	dec	ebx
	jne	@@3a
@@3b:	mov	edi, [esp+10h]
	mov	ebx, [esp+14h]
	mov	eax, [@@L5]
	test	eax, eax
	je	@@3g
@@3f:	xor	[edi], al
	inc	edi
	dec	ebx
	jne	@@3f
@@3g:	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@FindName PROC
	push	ebx
	push	esi
	push	edi
	mov	eax, [esp+10h]
	movzx	ecx, byte ptr [eax]
	add	eax, ecx
	movzx	ecx, byte ptr [eax+1]
	lea	edi, [eax+ecx+2]
	movzx	ebx, byte ptr [edi]
	inc	edi
	test	ebx, ebx
	je	@@9
@@1:	mov	esi, [esp+14h]
@@1a:	movzx	eax, word ptr [esi]
	inc	esi
	inc	esi
	test	eax, eax
	je	@@1b
	cmp	eax, 7Fh
	jae	@@1b
	sub	al, 41h
	cmp	al, 1Ah
	sbb	ah, ah
	and	ah, 20h
	add	al, ah
	add	al, 41h
	scasb
	je	@@1a
	cmp	byte ptr [edi-1], 0
	jne	@@1b
	cmp	al, 2Eh
	je	@@7
	sub	al, 30h
	cmp	al, 0Ah
	jb	@@7
@@1b:	xor	eax, eax
	or	ecx, -1
	repne	scasb
	add	edi, 40h
	dec	ebx
	jne	@@1
@@9:	xor	edi, edi
@@7:	xchg	eax, edi
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

ENDP