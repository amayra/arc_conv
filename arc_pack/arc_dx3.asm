
_arc_dx3 PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@P
@M0 @@M
@M0 @@L0, 0Ch
@M0 @@L1, 10h

	enter	@@stk, 0
	mov	eax, [@@PC]
	lea	ebx, [@@L0]
	mov	[ebx], eax
	mov	[ebx+4], eax
	mov	[ebx+8], eax
	test	eax, eax
	je	@@2c
	dec	eax
	jne	@@9a
	mov	esi, [@@PB]
	mov	esi, [esi]
	call	@@SetKey
@@2c:
	mov	esi, [@@FL]
	mov	ecx, [esi-0Ch]
	lodsd
	shl	ecx, 1
	imul	ebx, eax, 2Ch
	lea	ebx, [ebx+ecx*8+2Ch+10h]
	push	4
	pop	edx
@@2a:	lodsd
	test	eax, eax
	je	@@2b
	mov	ecx, [eax+8]
	shr	ecx, 2
	lea	edx, [edx+ecx*8+0Ch]
	jmp	@@2a
@@2b:	mov	[@@L1+4], edx
	add	ebx, edx
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	and	[@@P], 0
	call	_FileWrite, [@@D], edi, 18h
	xor	eax, eax
	stosd
	mov	[@@L1], edi
	add	edi, [@@L1+4]
	sub	edi, 4
	mov	[@@L1+4], edi

	mov	esi, [@@FL]
	lodsd
	inc	eax
	imul	ebx, eax, 2Ch
	add	ebx, edi
	lea	eax, [ebx+10h]
	mov	[@@L1+8], ebx
	mov	[@@L1+0Ch], eax

	xor	eax, eax
	stosd
	mov	al, 10h
	stosd
	xor	eax, eax
	lea	ecx, [eax+8]
	rep	stosd
	mov	[ebx], eax
	dec	eax
	stosd
	mov	[ebx+4], eax

	push	0
@@3a:	mov	eax, edi
	sub	eax, [@@L1+4]
	mov	[ebx+0Ch], eax
	push	esi
@@1a:	mov	esi, [esi]
	test	esi, esi
	je	@@1b
	inc	dword ptr [ebx+8]
	push	ebx
	push	edi
	mov	edi, [@@L1]
	mov	ebx, [esi+8]
	call	_sjis_upper, dword ptr [esi+4]
	mov	edx, [esi+4]
	xor	ecx, ecx
@@1d:	movzx	eax, byte ptr [edx]
	inc	edx
	add	ecx, eax
	test	eax, eax
	jne	@@1d
	shl	ecx, 10h
	lea	eax, [ebx+4]
	shr	eax, 2
	add	eax, ecx
	stosd
	call	@@1e
	call	_sjis_lower, dword ptr [esi+4]
	call	@@1e
	mov	eax, [@@L1]
	mov	[@@L1], edi
	sub	eax, [@@M]
	pop	edi
	pop	ebx
	stosd
	lea	eax, [esi+0Ch]		; FileAttributes, CreationTime, LastAccessTime, LastWriteTime
	push	7
	pop	ecx
	xchg	esi, eax
	rep	movsd
	xchg	esi, eax
	mov	eax, [@@P]
	stosd
	xor	eax, eax
	stosd
	dec	eax
	stosd
	test	byte ptr [esi+0Ch], 10h
	jne	@@1f
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, offset @@5
	mov	[edi-8], eax
	neg	eax
	and	eax, 3
	je	@@1c
	push	0
	mov	edx, esp
	call	@@6, edx, eax
	pop	ecx
@@1c:	jmp	@@1a

@@1f:	lea	ecx, [edi-2Ch]
	mov	eax, ebx
	sub	ecx, [@@L1+4]
	sub	eax, [@@L1+8]
	mov	edx, [@@L1+0Ch]
	add	[@@L1+0Ch], 10h	
	mov	[edx], ecx
	mov	[edx+4], eax
	mov	[esi+4], edx
	sub	edx, [@@L1+8]
	mov	[edi-0Ch], edx
	jmp	@@1a

@@1b:	pop	esi
@@3b:	mov	esi, [esi]
	test	esi, esi
	je	@@3c
	test	byte ptr [esi+0Ch], 10h
	je	@@3b
	mov	ebx, [esi+4]
	push	esi
	lea	esi, [esi-4]
	jmp	@@3a

@@3c:	pop	esi
	test	esi, esi
	jne	@@3b

	mov	edi, [@@L1+0Ch]
	mov	esi, [@@M]
	sub	edi, esi
	mov	ebx, [@@P]
	call	@@6, esi, edi
	add	ebx, 18h

	and	[@@P], 0
	call	_FileSeek, [@@D], 0, 0
	mov	eax, [@@L1+8]
	mov	edx, [@@L1+4]
	sub	eax, esi
	sub	edx, esi
	push	eax
	push	edx
	push	ebx
	push	18h
	push	edi
	push	35844h
	mov	edx, esp
	call	@@6, edx, 18h

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@1e:	mov	eax, [esi+4]
	mov	ecx, ebx
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	xchg	eax, ecx
	mov	ecx, ebx
	not	ecx
	and	ecx, 3
	inc	ecx
	rep	stosb
	ret

@@5:	mov	ecx, [@@P]
	add	[@@P], ebx
	mov	eax, 0AAAAAAABh
	mul	ecx
	shr	edx, 3
	imul	edx, 0Ch
	sub	ecx, edx
@@5a:	mov	al, byte ptr [@@L0+ecx]
	inc	ecx
	xor	[esi], al
	inc	esi
	cmp	ecx, 0Ch
	sbb	eax, eax
	and	ecx, eax
	dec	ebx
	jne	@@5a
	ret

@@6:	push	ebx
	push	esi
	mov	ebx, [esp+10h]
	mov	esi, [esp+0Ch]
	call	@@5
	pop	esi
	pop	ebx
	call	_FileWrite, [@@D], dword ptr [esp+8], dword ptr [esp+8]
	ret	8

@@SetKey PROC
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	call	_stack_sjis_esc, esi
	test	eax, eax
	jne	@@1
	inc	eax
	push	-56h	; 0xAA
@@1:	mov	esi, esp
	push	0Ch
	pop	ecx
	cmp	eax, ecx
	jae	$+3
	xchg	ecx, eax
	lea	eax, [ecx-0Ch]
	mov	edi, ebx
	neg	eax
	rep	movsb
	leave
	xchg	ecx, eax
	mov	esi, ebx
	rep	movsb

	xor	dword ptr [ebx], 0FF8A00FFh
	xor	dword ptr [ebx+4], 0FFFFACFFh
	xor	dword ptr [ebx+8], 0CC6D7F00h
	rol	byte ptr [ebx+1], 4
	rol	byte ptr [ebx+3], 4
	rol	byte ptr [ebx+7], 5
	rol	byte ptr [ebx+8], 3
	rol	byte ptr [ebx+0Ah], 4
	pop	edi
	pop	esi
	pop	ebx
	ret
ENDP

ENDP