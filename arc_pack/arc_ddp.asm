
_arc_ddp PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L0, 0Ch
@M0 @@L2

	enter	@@stk, 0
	mov	ebx, [@@PC]
	dec	ebx
	shr	ebx, 1
	jne	@@9a
	; "DDP0" = 0x30504444
	; "SHS6" = 0x36534853
	mov	[@@L0], '0PDD'
	mov	esi, [@@PB]
	jnc	@@2c
	lodsd
	call	_string_num, eax
	jc	@@9a
	mov	[@@L0], eax
@@2c:	lodsd
	call	_string_num, eax
	jc	@@9a
	cmp	eax, -1
	jne	@@2g
	mov	esi, [@@FL]
	lodsd
	xor	edx, edx
	lea	ecx, [edx+5]
	div	ecx
	mov	cl, 20h
	cmp	eax, ecx
	jae	$+4
	mov	eax, ecx
	shl	ecx, 4
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
@@2g:	mov	[@@L0+4], eax	; min = 1, max = 0x200, def = filenum / 5
	test	eax, eax
	je	@@5
	lea	edi, [eax+1]
	dec	eax
	shl	edi, 3
	shr	eax, 9
	jne	@@9a
	inc	byte ptr [@@L0+3]

	mov	esi, [@@FL]
	lodsd
@@2a:	mov	esi, [esi]
	test	esi, esi
	je	@@2b
	mov	ebx, [esi+4]
	call	_ansi_ext, dword ptr [esi+8], ebx
	mov	byte ptr [edx], 0
	sub	edx, ebx
	mov	[esi+8], edx
	call	_sjis_lower, ebx
	mov	eax, [esi+8]
	mov	ebx, 0FFh
	add	eax, 6
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	add	edi, ebx
	jmp	@@2a
@@2b:	mov	[@@P], edi
	mov	[@@L0+8], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax

	mov	eax, [@@L0]
	stosd
	mov	eax, [@@L0+4]
	stosd
	lea	ecx, [eax+eax]
	xor	eax, eax
	rep	stosd

	mov	esi, [@@FL]
	lodsd
	push	esi
@@2d:	mov	esi, [esi]
	test	esi, esi
	je	@@2e
	call	@@NameHash
	add	[edi], ebx
	jmp	@@2d
@@2e:	pop	esi

	mov	ebx, [@@L0+4]
	mov	edi, [@@M]
	lea	edx, [ebx+1]
	add	edi, 8
	shl	edx, 3
@@2f:	mov	eax, [edi]
	cmp	eax, 1
	sbb	ecx, ecx
	inc	ecx
	mov	[edi], ecx
	mov	[edi+4], edx
	add	edx, eax
	add	edi, 8
	add	edx, ecx
	dec	ebx
	jne	@@2f

@@1a:	mov	esi, [esi]
	test	esi, esi
	je	@@1b
	call	@@NameHash
	mov	eax, [edi]
	dec	eax
	add	[edi], ebx
	add	eax, [edi+4]
	add	eax, [@@M]
	xchg	edi, eax
	mov	eax, ebx
	stosb
	mov	eax, esi
	stosd
	mov	eax, [esi+4]
	lea	ecx, [ebx-6]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	xchg	eax, ecx
	stosb
	stosb
	jmp	@@1a
@@1b:
	mov	edi, [@@M]
	mov	eax, [@@L0+4]
	lea	edi, [edi+eax*8+8]
@@1c:	mov	eax, edi
	sub	eax, [@@M]
	cmp	eax, [@@L0+8]
	jae	@@7
@@1d:	movzx	ebx, byte ptr [edi]
	inc	edi
	dec	ebx
	js	@@1c
	mov	eax, [@@P]
	bswap	eax
	mov	esi, [edi]
	mov	[edi], eax
	add	edi, ebx
	call	@@4
	jmp	@@1d

@@7:	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	call	_FileWrite, ebx, [@@M], [@@L0+8]
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5:	xor	edi, edi
	mov	esi, [@@FL]
	lodsd
@@5a:	mov	esi, [esi]
	test	esi, esi
	je	@@5b
	call	_file_index
	jc	@@5a
	inc	eax
	cmp	edi, eax
	jae	$+3
	xchg	edi, eax
	jmp	@@5a
@@5b:	mov	[@@L0+4], edi
	inc	edi
	inc	edi
	shl	edi, 2
	mov	[@@P], edi
	mov	[@@L0+8], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax

	mov	eax, [@@L0]
	stosd
	mov	eax, [@@L0+4]
	stosd
	test	eax, eax
	xchg	ecx, eax
	je	@@7
	push	edi
	xor	eax, eax
	rep	stosd
	pop	edi

	mov	esi, [@@FL]
	lodsd
@@5c:	mov	esi, [esi]
	test	esi, esi
	je	@@5d
	call	_file_index
	jc	@@5c
	mov	[edi+eax*4], esi
	jmp	@@5c
@@5d:
	xor	eax, eax
	mov	ecx, [@@L0+4]
	repne	scasd
	jne	@@5e
	push	eax
	push	eax
	mov	eax, esp
	call	_FileWrite, [@@D], eax, 8
	pop	ecx
	pop	ecx
@@5e:
	mov	edi, [@@M]
	add	edi, 8
@@3a:	mov	esi, [edi]
	mov	eax, [@@L0+8]
	test	esi, esi
	je	@@3b
	push	[@@P]
	call	@@4
	pop	eax
@@3b:	stosd
	dec	[@@L0+4]
	jne	@@3a
	jmp	@@7

@@4:	push	edi
	mov	ecx, [esi+2Ch]
	push	ecx
	push	0
	lea	ebx, [ecx*8+ecx+7]
	shr	ebx, 3
	lea	edx, [esi+30h]
	lea	eax, [@@L2]
	call	_ArcLoadFile, eax, edx, 0, ecx, ebx
	push	0
	pop	ecx
	jc	@@4a
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	cmp	ecx, 8
	jb	@@4b
	cmp	dword ptr [edx], 'SggO'
	jne	@@4b
	cmp	dword ptr [edx+4], 200h
	je	@@4a
@@4b:	lea	eax, [edx+ecx]
	call	@@Pack, eax, ebx, edx, ecx
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	cmp	eax, ecx
	jae	@@4a
	add	edx, ecx
	xchg	eax, ecx
	pop	eax
	push	ecx
@@4a:	mov	ebx, ecx
	mov	edi, edx
	lea	eax, [ebx+8]
	add	[@@P], eax
	mov	eax, esp
	call	_FileWrite, [@@D], eax, 8
	test	ebx, ebx
	je	@@4c
	call	_FileWrite, [@@D], edi, ebx
@@4c:	call	_MemFree, [@@L2]
	pop	ecx
	pop	ecx
	pop	edi
	ret

@@NameHash PROC
	mov	eax, [esi+8]
	mov	ebx, 0FFh
	add	eax, 6
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax

	xor	edi, edi
	mov	ecx, [esi+4]
	lea	edx, [edi+1]
	push	ebx
	sub	ebx, 6
	je	@@2
	; 00415440
@@1:	movsx	eax, byte ptr [ecx]
	inc	ecx
	imul	eax, edx
	add	edx, 1F3h
	xor	edi, eax
	dec	ebx
	jne	@@1
@@2:	pop	ebx
ENDP
	mov	eax, edi
	shr	eax, 0Bh
	xor	eax, edi
	xor	edx, edx
	mov	edi, [@@M]
	div	[@@L0+4]
	lea	edi, [edi+edx*8+8]
	ret

@@Pack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@M = dword ptr [ebp-4]
@@D = dword ptr [ebp-8]
@@L0 = dword ptr [ebp-0Ch]

@tblcnt = 2000h

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
	lea	eax, [esi-@tblcnt-1]
	rep	stosd
	push	edi
	push	ecx
	mov	edi, [@@DB]
	cmp	[@@SC], ecx
	je	@@9
@@1:	inc	[@@L0]
	call	@@next
@@1a:	mov	ecx, [@@SC]
	cmp	ecx, 3
	jb	@@1
	call	@@match
	test	ecx, ecx
	je	@@1
	; ecx - address, eax - count
	not	ecx
	xchg	ebx, eax
	push	ecx
	call	@@2
	pop	edx
	call	@@3
@@1b:	call	@@next
	dec	ebx
	jne	@@1b
	jmp	@@1a

@@9b:	inc	esi
	call	@@2
@@9:	call	_MemFree, [@@M]
	mov	esi, [@@SC]
	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@next:	dec	[@@SC]
	je	@@9b
	mov	ecx, esi
	mov	edx, [@@M]
	movzx	eax, word ptr [esi]
	xchg	ecx, [edx+eax*4]
	sub	ecx, esi
	cmp	ecx, -@tblcnt+1
	sbb	eax, eax
	neg	ecx
	mov	edx, esi
	or	ecx, eax
	mov	eax, [@@D]
	and	edx, @tblcnt-1
	mov	[eax+edx*2], cx
	inc	esi
	ret

@@2:	mov	ecx, [@@L0]
	test	ecx, ecx
	je	@@2b
	sub	esi, ecx
	and	[@@L0], 0
	lea	eax, [ecx-1]
	cmp	ecx, 1Eh
	jb	@@2a
	sub	eax, 11Dh
	jae	@@2c
	mov	al, 1Dh
	stosb
	lea	eax, [ecx-1Eh]
@@2a:	stosb
	rep	movsb
@@2b:	ret

@@2c:	cmp	eax, 10000h
	jae	@@2d
	xchg	edx, eax
	mov	al, 1Eh
	stosb
	mov	al, dh
	stosb
	xchg	eax, edx
	jmp	@@2a

@@2d:	mov	al, 1Fh
	stosb
	mov	eax, ecx
	bswap	eax
	stosd
	rep	movsb
	ret

@@3:	lea	eax, [ebx-3]
	cmp	eax, 4
	jae	@@3c
	cmp	edx, 8
	jae	@@3a
	lea	eax, [eax+edx*4+20h]
	stosb
	ret

@@3a:	shl	eax, 5
	add	al, dh
	add	al, 80h
@@3b:	stosb
	mov	al, dl
	stosb
	ret

@@3c:	sub	eax, 4
	cmp	eax, 20h
	jae	@@3d
	test	dh, dh
	jne	@@3d
	add	al, 40h
	jmp	@@3b

@@3d:	xchg	ecx, eax
	mov	al, dh
	add	al, 60h
	stosb
	xchg	eax, edx
	stosb
	mov	eax, 0FEh
	cmp	ecx, eax
	jae	@@3e
	xchg	eax, ecx
	stosb
	ret

@@3e:	sub	ecx, eax
	cmp	ecx, 10000h
	jae	@@3f
	mov	al, 0FEh
	stosb
	mov	al, ch
	stosb
	xchg	eax, ecx
	stosb
	ret

@@3f:	mov	al, 0FFh
	stosb
	mov	eax, ebx
	bswap	eax
	stosd
	ret

@@match PROC
	push	edi
	push	0	; D
	push	2	; C = min-1
	mov	ebx, ecx
	mov	ecx, [ebp-4]
	movzx	eax, word ptr [esi]
	mov	ecx, [ecx+eax*4]
	sub	ecx, esi
	jmp	@@3

@@4:	xor	edx, edx
	lea	edi, [esi+ecx]
	inc	edx
@@5:	inc	edx
	cmp	edx, ebx
	jae	@@6
	mov	al, [esi+edx]
	cmp	[edi+edx], al
	je	@@5
@@6:	pop	eax
	cmp	eax, edx
	jae	@@2
	xchg	eax, edx
	pop	edx
	cmp	eax, ebx
	jae	@@9
	push	ecx
@@2:	push	eax
	and	edi, @tblcnt-1
	mov	edx, [ebp-8]
	movzx	edi, word ptr [edx+edi*2]
	sub	ecx, edi
@@3:	cmp	ecx, -@tblcnt
	jae	@@4
	pop	eax
	pop	ecx
@@9:	pop	edi
	ret
ENDP

ENDP	; @@Pack

ENDP