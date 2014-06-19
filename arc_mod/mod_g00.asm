
_mod_g00 PROC

@@stk = 0
@M0 @@B
@M0 @@H
@M0 @@N
@M0 @@D
@M0 @@P
@M0 @@I

	push	ebp
	mov	ebp, esp
	mov	esi, eax
	dec	eax
	dec	eax
	shr	eax, 1
	jne	@@9a
	call	_Bm32ReadFile, dword ptr [ebp+8+esi*4-4]
	test	eax, eax
	je	@@9b
	push	eax
	xchg	ebx, eax

	cmp	esi, 3
	je	@@2b
	call	_MemAlloc, 11h+18h
	jc	@@9a
	mov	ecx, [ebx]
	mov	edx, [ebx+4]
	mov	byte ptr [eax], 2
	mov	[eax+1], cx
	mov	[eax+3], dx
	dec	ecx
	dec	edx
	mov	[eax+11h], ecx
	mov	[eax+15h], edx
	xor	ecx, ecx
	mov	[eax+9], ecx
	mov	[eax+0Dh], ecx
	mov	[eax+19h], ecx
	mov	[eax+1Dh], ecx
	inc	ecx
	mov	[eax+5], ecx
	jmp	@@2c

@@2b:	call	@@Header, dword ptr [ebp+0Ch]
	test	eax, eax
	je	@@9a
@@2c:	push	eax
	xchg	ebx, eax

	lea	edi, [ebx+9]
	mov	ebx, [ebx+5]
	lea	esi, [ebx+ebx+1]
	push	ebx	; @@N
@@2:	call	@@3, edi
	jc	@@2a
	mov	eax, [edi+8]
	mov	edx, [edi+0Ch]
	sub	eax, [edi]
	sub	edx, [edi+4]
	inc	eax
	inc	edx
	imul	eax, edx
	lea	esi, [esi+eax+(74h+5Ch)/4]
@@2a:	add	edi, 18h
	dec	ebx
	jne	@@2
	shl	esi, 2
	call	_MemAlloc, esi
	jc	@@9c
	push	eax	; @@D
	xchg	edi, eax

	mov	eax, [@@N]
	stosd
	shl	eax, 3
	add	eax, 4
	push	eax	; @@P
	push	0	; @@I
@@1:	mov	ecx, [@@I]
	mov	edi, [@@D]
	mov	esi, [@@H]
	add	edi, [@@P]
	lea	ecx, [ecx*2+ecx]
	lea	esi, [esi+9+ecx*8]
	call	@@3, esi
	jc	@@1a
	xor	eax, eax
	mov	edx, edi
	lea	ecx, [eax+(74h+5Ch)/4]
	rep	stosd

	mov	eax, [esi+10h]
	mov	ecx, [esi+14h]
	mov	[edx+14h], eax
	mov	[edx+18h], ecx
	mov	ecx, [esi+8]
	mov	eax, [esi+0Ch]
	sub	ecx, [esi]
	sub	eax, [esi+4]
	inc	ecx
	inc	eax
	mov	dword ptr [edx], 20001h
	mov	[edx+0Ch], ecx
	mov	[edx+10h], eax
	mov	[edx+1Ch], ecx
	mov	[edx+20h], eax
	inc	byte ptr [edx+74h+4]
	mov	[edx+74h+6], ecx
	mov	[edx+74h+8], eax
	push	ecx	; @@W
	push	eax
	mov	ebx, [@@B]
	mov	eax, [esi+4]
	mov	edx, [ebx+0Ch]
	mov	esi, [esi]
	imul	eax, edx
	neg	ecx
	lea	esi, [eax+esi*4]
	lea	edx, [edx+ecx*4]
	add	esi, [ebx+8]
	pop	ebx
	pop	eax
@@1b:	mov	ecx, eax
	rep	movsd
	add	esi, edx
	dec	ebx
	jne	@@1b
@@1a:	mov	edx, [@@D]
	mov	eax, [@@P]
	sub	edi, edx
	mov	ecx, [@@I]
	mov	[@@P], edi
	sub	edi, eax
	mov	[edx+4+ecx*8], eax
	mov	[edx+8+ecx*8], edi
	inc	ecx
	cmp	ecx, [@@N]
	mov	[@@I], ecx
	jb	@@1

	mov	ebx, [@@P]
	lea	ebx, [ebx*8+ebx+7]
	shr	ebx, 3
	call	_MemAlloc, ebx
	jc	@@9d
	mov	esi, [@@D]
	mov	[@@D], eax
	call	_reallive_pack, eax, ebx, esi, [@@P]
	xchg	ebx, eax
	call	_MemFree, esi

	mov	eax, [ebp+8]
	call	_FileCreate, dword ptr [ebp+8+eax*4], FILE_OUTPUT
	jc	@@9d
	xchg	edi, eax

	mov	edx, [@@B]
	mov	esi, [@@H]
	mov	eax, [edx+4-2]
	mov	ecx, [@@N]
	mov	ax, [edx]
	imul	ecx, 18h
	mov	[esi+1], eax
	lea	eax, [ebx+8]
	add	ecx, 11h
	mov	edx, [@@P]
	mov	[esi+ecx-8], eax
	mov	[esi+ecx-4], edx
	call	_FileWrite, edi, esi, ecx
	call	_FileWrite, edi, [@@D], ebx
	call	_FileClose, edi
@@9d:	call	_MemFree, [@@D]
@@9c:	call	_MemFree, [@@B]
@@9b:	call	_MemFree, [@@H]
@@9a:	leave
	ret

@@3:	push	ebx
	push	esi
	mov	ebx, [esp+0Ch]
	mov	esi, [@@B]
	mov	eax, [ebx]
	mov	ecx, [esi]
	mov	edx, [ebx+8]
	dec	ecx
	cmp	ecx, eax
	jb	@@3a
	cmp	ecx, edx
	jb	@@3a
	cmp	edx, eax
	jb	@@3a
	mov	eax, [ebx+4]
	mov	ecx, [esi+4]
	mov	edx, [ebx+0Ch]
	dec	ecx
	cmp	ecx, eax
	jb	@@3a
	cmp	ecx, edx
	jb	@@3a
	cmp	edx, eax
	jb	@@3a
	mov	eax, [ebx]
	mov	edx, [ebx+8]
	or	eax, [ebx+4]
	or	edx, [ebx+0Ch]
	or	eax, edx
	cmp	eax, 1
@@3a:	pop	esi
	pop	ebx
	ret	4

@@Header PROC

@@S = dword ptr [ebp+14h]

@@L0 = dword ptr [ebp-0Ch]

	push	ebx
	push	esi
	push	edi
	enter	0Ch, 0
	xor	edi, edi
	mov	esi, esp
	call	_FileCreate, [@@S], FILE_INPUT
	jc	@@9a
	xchg	ebx, eax
	call	_FileRead, ebx, esi, 9
	jc	@@9
	cmp	byte ptr [esi], 2
	jne	@@9
	mov	esi, [esi+5]
	lea	eax, [esi-1]
	imul	esi, 18h
	shr	eax, 10h
	jne	@@9
	lea	eax, [esi+11h]
	call	_MemAlloc, eax
	jc	@@9
	xchg	edi, eax
	mov	eax, [@@L0]
	mov	edx, [@@L0+4]
	mov	[edi], eax
	mov	al, byte ptr [@@L0+8]
	mov	[edi+4], edx
	mov	[edi+8], al
	lea	edx, [edi+9]
	call	_FileRead, ebx, edx, esi
	jnc	@@9
	call	_MemFree, edi
	xor	edi, edi
@@9:	call	_FileClose, ebx
@@9a:	xchg	eax, edi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP

ENDP
