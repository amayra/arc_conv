
_arc_escude PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L0
@M0 @@L1
@M0 @@L2
@M0 @@L3

	enter	@@stk, 0
	cmp	[@@PC], 1
	jne	@@9a
	mov	esi, [@@PB]
	call	_string_select, offset @@T, dword ptr [esi]
	jc	@@9a
	mov	[@@L0], eax
	cmp	eax, 3
	mov	esi, [@@FL]
	mov	ebx, [esi]
	jae	@@2
	dec	eax
	je	@@4a
	imul	ebx, 88h
	lea	edi, [ebx+10h]
	mov	[@@L0], edi
	mov	[@@P], edi
	mov	[@@L2], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax
	mov	eax, '-CSE'
	stosd
	mov	eax, '1CRA'
	stosd
	rdtsc
	xor	eax, edx
	stosd
	movsd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	mov	ebx, 80h
	call	_string_copy_ansi, edi, ebx, dword ptr [esi+4]
	add	edi, ebx
	call	@@5
	jmp	@@1

@@4a:	imul	ebx, 28h
	lea	edi, [ebx+0Ch]
	mov	[@@P], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax
	mov	eax, 'XPCA'
	stosd
	mov	eax, '10KP'
	stosd
	movsd
@@4:	mov	esi, [esi]
	test	esi, esi
	je	@@4b
	call	_string_copy_ansi, edi, 20h, dword ptr [esi+4]
	add	edi, 20h
	call	@@5
	jmp	@@4

@@4b:	mov	esi, [@@M]
	mov	ebx, [@@D]
	sub	edi, esi
	call	_FileSeek, ebx, 0, 0
	call	_FileWrite, ebx, esi, edi
	jmp	@@9

@@2:	imul	edi, ebx, 0Ch
	add	edi, 14h
	push	esi
	lodsd
@@2a:	mov	esi, [esi]
	test	esi, esi
	je	@@2b
	add	ebx, [esi+8]
	jmp	@@2a
@@2b:	pop	esi
	mov	[@@L0], edi
	add	edi, ebx
	mov	[@@P], edi
	mov	[@@L2], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax
	mov	eax, '-CSE'
	stosd
	mov	eax, '2CRA'
	stosd
	rdtsc
	xor	eax, edx
	stosd
	movsd
	xchg	eax, ebx
	stosd
	and	[@@L1], 0

@@3:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	mov	ecx, [esi+8]
	mov	eax, [@@L1]
	inc	ecx
	stosd
	add	eax, [@@L0]
	add	[@@L1], ecx
	add	eax, [@@M]
	push	esi
	mov	esi, [esi+4]
	xchg	edi, eax
	rep	movsb
	xchg	edi, eax
	pop	esi
	call	@@5
	jmp	@@3

@@7:	mov	esi, [@@M]
	mov	ebx, [@@D]
	mov	edi, [@@L2]
	call	_FileSeek, ebx, 0, 0
	mov	ecx, [@@L0]
	lea	edx, [esi+0Ch]
	sub	ecx, 0Ch
	shr	ecx, 2
	call	_escude_crypt, dword ptr [esi+8], ecx, edx
	call	_FileWrite, ebx, esi, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@T	db 'acpx',0, 'arc1',0, 'arc2',0, 0

@@5:	mov	eax, [@@P]
	stosd
	call	_ansi_ext, dword ptr [esi+8], dword ptr [esi+4]
	lea	edx, [esi+30h]
	cmp	eax, 'ggo'
	je	@@5a
	mov	ecx, [esi+2Ch]
	lea	ebx, [ecx+8]
	call	_ArcPackFile, [@@D], edx, ecx, ebx, 0, offset @@Pack, 0
	jmp	@@5b

@@5a:	call	_ArcAddFile, [@@D], edx, 0
@@5b:	add	[@@P], eax
	stosd
	ret

@@Pack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@M = dword ptr [ebp-4]
@@L0 = dword ptr [ebp-8]
@@L1 = dword ptr [ebp-0Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	call	_MemAlloc, 8000h*8
	jc	@@9a
	push	eax
	push	1
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	sub	[@@DC], 8
	jb	@@9c
	mov	eax, 'pca'
	stosd
	mov	eax, [@@SC]
	bswap	eax
	stosd
	jmp	@@2a

@@2:	mov	eax, 102h
	call	@@4
	pop	ecx
@@2a:	mov	ebx, 102h
	push	edi
	mov	edi, [@@M]
	lea	ecx, [ebx+ebx]
	xor	eax, eax
	rep	stosd
	pop	edi
	push	9	; @@L0
	mov	ecx, ebx

@@1:	cmp	[@@SC], 0
	je	@@9
	test	bh, bh
	js	@@2
	push	edi
	mov	edi, [@@M]
	movzx	edx, byte ptr [esi]
	movzx	eax, word ptr [edi+ecx*8+2]
	mov	[edi+ecx*8+2], bx
	mov	[edi+ebx*8], eax
	mov	[edi+ebx*8+4], edx
	inc	ebx
@@1a:	inc	esi
	mov	ecx, edx
	dec	[@@SC]
	je	@@1c
	movzx	edx, word ptr [edi+edx*8+2]
	movzx	eax, byte ptr [esi]
	test	edx, edx
	je	@@1c
@@1b:	cmp	[edi+edx*8+4], eax
	je	@@1a
	movzx	edx, word ptr [edi+edx*8]
	test	edx, edx
	jne	@@1b
@@1c:	pop	edi
	push	ecx
	xchg	eax, ecx
	call	@@4
	pop	ecx
	jmp	@@1

@@9:	call	_MemFree, [@@M]
	mov	eax, 100h
	call	@@4
	cmp	edx, 1
	je	@@9c
@@9b:	add	dl, dl
	jnc	@@9b
	dec	[@@DC]
	js	@@9c
	mov	[edi], dl
	inc	edi
@@9c:	xchg	eax, edi
	mov	esi, [@@SC]
	sub	eax, [@@DB]
	neg	esi
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@4a:	push	eax
	mov	eax, 101h
	call	@@4
	pop	eax
	inc	[@@L1]
@@4:	xor	edx, edx
	mov	ecx, [@@L1]
	inc	edx
	shl	edx, cl
	cmp	eax, edx
	jae	@@4a
	ror	eax, cl
	mov	edx, [@@L0]
@@4b:	shl	eax, 1
	adc	dl, dl
	jnc	@@4c
	dec	[@@DC]
	js	@@9c
	mov	[edi], dl
	inc	edi
	mov	dl, 1
@@4c:	dec	ecx
	jne	@@4b
	mov	[@@L0], edx
	ret
ENDP

ENDP
