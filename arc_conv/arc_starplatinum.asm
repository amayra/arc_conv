
; "Star Platinum" sp.dat
; SP.EXE
; 0043BA10 open_archive
; 0043BB70 read_file

	dw _conv_starplatinum-$-2
_arc_starplatinum PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	movzx	ecx, word ptr [esi+2]
	imul	ebx, ecx, 0Ch
	test	ecx, ecx
	je	@@9a
	cmp	[esi+8], ebx
	jne	@@9a
	lea	eax, [ebx+10h]
	mov	[@@N], ecx
	mov	[@@P], eax
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	dword ptr [esi], 0
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	and	[@@D], 0
	mov	eax, [esi]
	mov	ebx, [esi+4]
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 0Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_starplatinum PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 0Ch
	jb	@@9
	mov	edx, 'EVAW'
	mov	eax, [esi]
	sub	edx, [esi+8]
	sub	eax, 'FFIR'
	or	eax, edx
	jne	@@1
	call	_ArcSetExt, 'vaw'
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 20h
	jb	@@9
	cmp	word ptr [esi], 0A183h
	jne	@@9
	movzx	eax, word ptr [esi+10h]
	movzx	edi, word ptr [esi+1Ch]
	movzx	edx, word ptr [esi+1Eh]
	add	esi, 20h
	cmp	eax, 2
	je	@@1a
	dec	ah
	shr	eax, 1
	jne	@@9
	sub	ebx, 4
	jb	@@9
	movzx	ecx, word ptr [esi]
	lea	eax, [ecx+ecx+3]
	dec	ecx
	and	al, -4
	shr	ecx, 8
	jne	@@9
	sub	ebx, eax
	jb	@@9
	call	_ArcTgaAlloc, 38h, edi, edx
	lea	edi, [eax+12h]
	lodsd
	movzx	ecx, ax
	mov	[edi-12h+5], cx
	push	ecx
@@1b:	movzx	eax, word ptr [esi]
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
	rol	eax, 8
	bswap	eax
	stosd
	dec	ecx
	jne	@@1b
	pop	ecx
	and	ecx, 1
	lea	esi, [esi+ecx*2]
	jmp	@@1c

@@1a:	call	_ArcTgaAlloc, 23h, edi, edx
	lea	edi, [eax+12h]
@@1c:	call	@@Unpack, edi, [@@SB], esi, ebx
	clc
	leave
	ret

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@L0 = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@stk = 0
@M0 @@L2
@M0 @@W
@M0 @@L1
@M0 @@DC
@M0 @@I

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	ebx, [@@L0]
	movzx	ecx, byte ptr [ebx+10h]
	movzx	eax, word ptr [ebx+1Ch]
	movzx	edx, word ptr [ebx+1Eh]
	push	ecx
	push	eax	; @@W
	imul	eax, edx
	push	eax	; @@L1
	push	eax	; @@DC

	cmp	ecx, 2
	jb	@@2a
	sub	esp, 204h
	mov	ecx, 204h/4
	mov	edi, esp
	xor	eax, eax
	rep	stosd
@@2a:
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
@@1:	call	@@3
	jnc	@@1e
	xor	edx, edx
	inc	edx
	call	@@3
	jnc	@@1c
	call	@@3
	jnc	@@1d
	call	@@4, 4
	inc	eax
	xchg	edx, eax
	call	@@5
	cmp	eax, [@@L1]
	je	@@7
@@1a:	sub	[@@DC], eax
	jb	@@9
	xchg	ecx, eax
	neg	edx
	cmp	[@@L2], 2
	jb	@@1b
	shl	ecx, 2
	shl	edx, 2
@@1b:	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@1c:	call	@@4, 4
	lea	edx, [eax+2]
@@1d:	call	@@4, 5
	imul	edx, [@@W]
	sub	eax, edx
	push	eax

	mov	eax, edi
	sub	eax, [@@DB]
	mov	ecx, [@@W]
	cmp	[@@L2], 2
	jb	@@1i
	shr	eax, 2
@@1i:	xor	edx, edx
	div	ecx
	cmp	edx, 10h
	jb	@@1k
	sub	edx, ecx
	cmp	edx, -10h
	jbe	@@1j
	add	edx, 20h
	cmp	ecx, 20h
	jae	@@1k
	lea	edx, [edx+ecx-20h]
	jmp	@@1k

@@1j:	push	10h
	pop	edx
@@1k:	pop	eax
	sub	edx, eax
	call	@@5
	jmp	@@1a

@@1e:	dec	[@@DC]
	js	@@9
	cmp	[@@L2], 1
	jb	@@1l
	je	@@1h
	dec	[@@SC]
	js	@@9
	xor	eax, eax
	lodsb
	test	al, al
	jns	@@1f
	call	@@3
	adc	al, al
	add	al, byte ptr [@@I]
	movzx	eax, word ptr [esp+eax*2]
	jmp	@@1g

@@1f:	dec	[@@SC]
	js	@@9
	mov	ah, al
	lodsb
	mov	edx, [@@I]
	dec	dl
	mov	[@@I], edx
	mov	[esp+edx*2], ax
@@1g:	ror	eax, 10
	shl	al, 3
	sbb	ah, ah
	rol	eax, 16
	shr	ax, 3
	shl	ah, 3
	mov	edx, 0E0E0E0E0h
	and	edx, eax
	shr	edx, 5
	or	eax, edx
	stosd
	jmp	@@1

@@1h:	dec	[@@SC]
	js	@@9
	movsb
	jmp	@@1

@@1l:	call	@@4, 4
	stosb
	jmp	@@1

@@7:	xor	esi, esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@3:	shl	bl, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@3a:	ret

@@4:	pop	eax
	pop	ecx
	push	eax
	xor	eax, eax
	jmp	@@4a

@@5:	xor	ecx, ecx
	xor	eax, eax
@@5a:	cmp	ecx, 1Eh
	jae	@@9
	inc	ecx
	call	@@3
	jc	@@5a
	inc	eax
	dec	ecx
	je	@@4b
@@4a:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@4a
@@4b:	ret
ENDP

ENDP
