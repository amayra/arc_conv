
; "Blaze of Destiny III -The Tears of the Blue Sea-" *.dat
; bod3.exe
; 00415590 unpack

	dw _conv_bod3-$-2
_arc_bod3 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@L1

	enter	@@stk+10h, 0
	mov	[@@N], 100000h
	mov	[@@P], 0
@@1:	mov	esi, esp
	call	_hex32_upper, [@@P], esi
	call	_ArcName, esi, 8
	and	[@@D], 0

	push	10h
	pop	[@@L1]
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@1a
	mov	eax, [esi]
	mov	edx, 'EVAW'
	sub	eax, 'FFIR'
	sub	edx, [esi+8]
	or	eax, edx
	jne	@@1c
	mov	ebx, [esi+4]
	sub	ebx, 8
	jb	@@8
	add	[@@L1], ebx
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 10h, ebx, 0
	lea	ebx, [eax+8]
	mov	edi, [@@D]
	movsd
	movsd
	movsd
	movsd
	jmp	@@1a

@@1c:	mov	ebx, [esi+8]
	cmp	dword ptr [esi], '3DOB'
	jne	@@8
	sub	ebx, 10h
	jb	@@8
	mov	edi, [esi+4]
	xor	ecx, ecx
	cmp	edi, -1
	je	@@1b
	mov	edx, [esi+0Ch]
	lea	eax, [edx-1]
	test	eax, edx
	jne	@@8
	cmp	eax, 2000h
	jae	@@8
	mov	ecx, edi
@@1b:	add	[@@L1], ebx
	lea	eax, [@@D]
	call	_ArcMemRead, eax, ecx, ebx, 0
	xchg	ebx, eax
	cmp	edi, -1
	je	@@1a
	call	@@Unpack, dword ptr [esi+0Ch], [@@D], edi, edx, ebx
	xchg	ebx, eax
@@1a:	cmp	[@@D], 0
	je	@@9
	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
	jmp	@@8a

@@8:	call	@@2
@@8a:	mov	eax, [@@P]
	add	eax, [@@L1]
	jc	@@9
	add	eax, 7FFh
	jc	@@9
	and	eax, -800h
	mov	[@@P], eax
	call	_FileSeek, [@@S], eax, 0
	jc	@@9
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	; ...
@@9a:	leave
	ret

@@2:	call	_FileSeek, [@@S], [@@P], 0
	jc	@@9
	xor	ebx, ebx
	mov	edi, 800h
	sub	esp, edi
	mov	esi, esp
@@2a:	call	_FileRead, [@@S], esi, edi
	cmp	eax, 10h
	xchg	ecx, eax
	jb	@@2b
	mov	eax, [esi]
	mov	edx, 'EVAW'
	sub	eax, 'FFIR'
	sub	edx, [esi+8]
	or	eax, edx
	je	@@2c
	cmp	dword ptr [esi], '3DOB'
	je	@@2c
@@2b:	add	ebx, ecx
	cmp	ecx, edi
	je	@@2a
@@2c:	add	esp, edi

	mov	[@@L1], ebx
	call	_FileSeek, [@@S], [@@P], 0
	jc	@@9
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	jmp	@@1a

@@Unpack PROC

@@L0 = dword ptr [ebp+14h]
@@DB = dword ptr [ebp+18h]
@@DC = dword ptr [ebp+1Ch]
@@SB = dword ptr [ebp+20h]
@@SC = dword ptr [ebp+24h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	neg	dword ptr [@@L0]
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
@@1:	dec	[@@DC]
	js	@@7
	shr	ebx, 1
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@1a:	jnc	@@1b
	dec	[@@SC]
	js	@@9
	movsb
	jmp	@@1

@@1b:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
	mov	cl, dh
	shr	dh, 4
	and	ecx, 0Fh
	add	ecx, 2
	sub	[@@DC], ecx
	jb	@@9
	inc	ecx
	mov	eax, edi
	sub	eax, [@@DB]
	sub	edx, eax
	add	edx, 12h
	or	edx, [@@L0]
	add	eax, edx
	jns	@@2b
@@2a:	mov	byte ptr [edi], 0
	inc	edi
	dec	ecx
	je	@@1
	inc	eax
	jne	@@2a
@@2b:	lea	eax, [edi+edx]
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
ENDP

ENDP

_conv_bod3 PROC

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
	jne	@@2
@@7:	call	_ArcSetExt, ecx
@@9:	stc
	leave
	ret

@@2:	mov	ecx, 'pmb'
	cmp	ebx, 36h
	jb	@@3
	cmp	word ptr [esi], 'MB'
	jne	@@3
	cmp	dword ptr [esi+0Eh], 28h
	jne	@@3
	cmp	dword ptr [esi+0Ah], 36h
	jae	@@7

@@3:	sub	ebx, 10h
	jb	@@9
	mov	eax, [esi]
	sub	eax, 14656h
	bswap	eax
	shr	eax, 1
	jne	@@9
	xchg	eax, ebx
	movzx	edi, word ptr [esi+4]
	movzx	edx, word ptr [esi+6]
	mov	ebx, edi
	imul	ebx, edx
	shr	eax, 1
	cmp	eax, ebx
	jb	@@9
	call	_ArcTgaAlloc, 23h, edi, edx
	lea	edi, [eax+12h]
	cmp	byte ptr [esi+3], 1
	lea	esi, [esi+10h]
	je	@@3b
@@3a:	movzx	eax, word ptr [esi]
	add	esi, 2
	ror	eax, 10
	shl	al, 3
	sbb	ah, ah
	rol	eax, 16
	shr	ax, 3
	shl	ah, 3
	mov	edx, 0E0E0E0E0h
	and	edx, eax
	shr	edx, 5
	or	eax, edx
	mov	[edi], eax
	add	edi, 4
	dec	ebx
	jne	@@3a
	clc
	leave
	ret

@@3b:	movzx	eax, word ptr [esi]
	add	esi, 2
	ror	eax, 8
	shl	ax, 4
	shr	al, 4
	rol	eax, 10h
	shr	ax, 4
	shr	al, 4
	imul	eax, 11h
	mov	[edi], eax
	add	edi, 4
	dec	ebx
	jne	@@3b
	clc
	leave
	ret
ENDP
