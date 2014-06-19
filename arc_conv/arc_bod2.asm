
; "Blaze of Destiny II -The Beginning of the Fate-" *.grp

	dw _conv_bod2-$-2
_arc_bod2 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	edi
	lea	ecx, [edi-4]
	ror	ecx, 2
	mov	[@@N], ecx
	dec	ecx
	shr	ecx, 14h
	jne	@@9a
	lea	ebx, [edi-4]
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	dword ptr [esi+ebx-4], 0
	jne	@@9
	call	_ArcCount, [@@N]

	sub	esi, 4
	xchg	eax, edi
	jmp	@@1c

@@1:	mov	eax, [esi]
@@1c:	mov	ebx, [esi+4]
	sub	ebx, eax
	jb	@@9
	je	@@1b
	and	[@@D], 0
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	cmp	ebx, 8
	jb	@@1a
	mov	edi, [@@D]
	mov	edx, offset @@Unpack
	mov	eax, [edi+4]
	mov	ecx, [edi]
	cmp	eax, 'JDH'
	je	@@1d
	cmp	al, 'W'
	jne	@@1a
	cmp	ah, 'A'
	je	@@1f
	cmp	ah, 'S'
	jne	@@1a
@@1f:	cmp	ebx, 0Ch
	jb	@@1a
	cmp	dword ptr [edi+8], 'FFIR'
	jne	@@1a
	mov	edx, offset @@UnpackW
@@1d:	push	edx
	call	_MemAlloc, ecx
	pop	ecx
	jc	@@1a
	mov	[@@D], eax
	lea	edx, [edi+8]
	sub	ebx, 8
	call	ecx, eax, dword ptr [edi], edx, ebx
@@1e:	xchg	ebx, eax
	call	_MemFree, edi
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 4
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@1b:	call	_ArcSkip, 1
	jmp	@@8

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
	push	ebx
	push	ebx
@@1:	cmp	[@@DC], 0
	je	@@7
	call	@@3
	jc	@@1a
	dec	[@@DC]
	call	@@4
	stosb
	jmp	@@1

@@1a:	call	@@3
	jc	@@1b
	call	@@4
	mov	edx, -100h
	xor	ecx, ecx
	or	edx, eax
	call	@@3
	adc	ecx, ecx
	inc	ecx
	call	@@3
	adc	ecx, ecx
	cmp	ecx, 5
	jmp	@@1d

@@1b:	mov	edx, [@@L1]
	mov	eax, edx
	shr	edx, 10h
	jne	@@1c
	sub	[@@SC], 4
	jb	@@9
	or	eax, -1
	mov	edx, [esi]
	add	esi, 4
	xchg	dx, ax
	ror	edx, 10h
@@1c:	mov	[@@L1], edx
	movzx	ecx, ax
	mov	edx, -2000h
	shr	ecx, 0Dh
	or	edx, eax
	add	ecx, 3
	cmp	ecx, 0Ah
@@1d:	jb	@@2d
	push	edx
	xor	edx, edx
	xor	eax, eax
@@2a:	inc	edx
	call	@@3
	jc	@@2a
	dec	edx
	je	@@2c
@@2b:	call	@@3
	adc	eax, eax
	dec	edx
	jne	@@2b
	inc	eax
@@2c:	pop	edx
	add	ecx, eax
@@2d:	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@7:	xor	esi, esi
@@9:	xchg	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@3:	shl	ebx, 1
	jne	@@3a
	sub	[@@SC], 4
	jb	@@9
	mov	ebx, [esi]
	add	esi, 4
	stc
	adc	ebx, ebx
@@3a:	ret

@@4:	mov	edx, [@@L0]
	mov	eax, edx
	shr	edx, 8
	jne	@@4a
	sub	[@@SC], 4
	jb	@@9
	or	eax, -1
	mov	edx, [esi]
	add	esi, 4
	xchg	dl, al
	ror	edx, 8
@@4a:	mov	[@@L0], edx
	ret
ENDP

@@UnpackW PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
	movzx	eax, byte ptr [esi-2]
	movzx	ecx, byte ptr [esi-1]
	shl	eax, 1
	neg	eax
	push	eax
	sub	[@@SC], ecx
	jb	@@9
	sub	[@@DC], ecx
	jb	@@9
	mov	al, [esi-3]
	rep	movsb
	push	eax
@@1:	cmp	[@@DC], 0
	je	@@7
	sub	[@@DC], 2
	jb	@@9
	xor	eax, eax
	cmp	byte ptr [@@L1], 'A'
	je	@@2a
	call	@@3
	jc	@@1b
	call	@@3
	sbb	edx, edx
	mov	al, 10h
@@1a:	call	@@3
	adc	al, al
	jnc	@@1a
	shl	eax, 6
	xor	eax, edx
	sub	eax, edx
	mov	edx, [@@L0]
	mov	ecx, edi
	sub	ecx, [@@DB]
	add	ecx, edx
	jnc	@@9
	add	ax, [edi+edx]
	jmp	@@1d

@@1b:	call	@@3
	jnc	@@1d
@@2a:	mov	al, 40h
@@1c:	call	@@3
	adc	ax, ax
	jnc	@@1c
	shl	eax, 6
@@1d:	stosw
	jmp	@@1

@@7:	xor	esi, esi
@@9:	xchg	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@3:	shl	ebx, 1
	jne	@@3a
	sub	[@@SC], 4
	jb	@@9
	mov	ebx, [esi]
	add	esi, 4
	stc
	adc	ebx, ebx
@@3a:	ret
ENDP

ENDP

_conv_bod2 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 10h
	jb	@@9
	mov	ecx, 'vaw'
	mov	eax, [esi]
	mov	edx, 'EVAW'
	sub	eax, 'FFIR'
	sub	edx, [esi+8]
	or	eax, edx
	je	@@7
	mov	ecx, 'pmb'
	cmp	ebx, 36h
	jb	@@9
	cmp	word ptr [esi], 'MB'
	jne	@@9
	cmp	dword ptr [esi+0Eh], 28h
	jne	@@9
	cmp	dword ptr [esi+0Ah], 36h
	jb	@@9
@@7:	call	_ArcSetExt, ecx
@@9:	stc
	leave
	ret
ENDP
