
; "Vampirdzhija Vjedogonia" Data?\*.pck
; VJED.exe
; 0047A388 npi_unpack

	dw _conv_vjed-$-2
_arc_vjed PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@SC
@M0 @@L0

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	mov	ebx, [esi]
	mov	edx, [esi+4]
	dec	ebx
	lea	ecx, [ebx-1]
	shr	ecx, 14h
	jne	@@9a
	mov	[@@N], ebx
	mov	[@@SC], edx
	imul	ebx, 0Ch
	add	ebx, edx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	lea	edx, [ebx+0Ch]
	add	ebx, esi
	mov	[@@P], edx
	mov	[@@L0], ebx
	call	@@3
	jne	@@9

@@1:	call	@@3
	jne	@@1b
	mov	byte ptr [edi-1], 0
	call	_ArcName, edx, -1
@@1b:	and	[@@D], 0
	mov	eax, [esi]
	mov	ebx, [esi+4]
	add	eax, [@@P]
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

@@3:	mov	ecx, [@@SC]
	mov	edi, [@@L0]
	cmp	ecx, 1
	jb	@@3a
	sub	edi, ecx
	mov	al, 0Dh
	mov	edx, edi
	repne	scasb
	mov	[@@SC], ecx
	jne	@@3a
	mov	byte ptr [edi-1], 0
@@3a:	ret
ENDP

_conv_vjed PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'ipn'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 40h
	jb	@@9
	mov	eax, [esi+24h]
	cmp	ebx, [esi+30h]
	jne	@@9
	movzx	edi, word ptr [esi+2Ch]
	movzx	edx, word ptr [esi+28h]
	cmp	eax, 4
	je	@@1a
	mov	ecx, eax
	and	al, 0Fh
	shr	ecx, 4
	cmp	al, 3
	jne	@@9
	cmp	ecx, 3
	jae	@@9
@@1a:	lea	ecx, [eax+20h-1]
	call	_ArcTgaAlloc, ecx, edi, edx
	xchg	edi, eax
	mov	eax, [esi+24h]
	add	esi, 40h
	add	edi, 12h
	call	@@Unpack, edi, 0, esi, ebx, dword ptr [edi-12h+0Ch]
	clc
	leave
	ret

@@Unp04 PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]

@@2:	sub	[@@SC], 2
	jb	@@9
	xor	eax, eax
	lodsw
	xchg	ebx, eax
	movzx	edx, word ptr [@@L0]
	sub	[@@SC], ebx
	jb	@@9
@@1:	sub	ebx, 2
	jb	@@9
	xor	eax, eax
	lodsw
	mov	ecx, eax
	and	ch, 0Fh
	sub	edx, ecx
	jb	@@9
	shr	eax, 0Ch
	jne	@@1a
	xor	eax, eax
	rep	stosd
	jmp	@@1c

@@1a:	dec	eax
	jne	@@1b
	sub	ebx, 4
	jb	@@9
	lodsd
	rep	stosd
	jmp	@@1c

@@1b:	cmp	al, 0Eh
	jne	@@1c
	mov	eax, ecx
	shl	eax, 2
	sub	ebx, eax
	jb	@@9
	rep	movsd
@@1c:	test	edx, edx
	jne	@@1
	add	esi, ebx
	dec	word ptr [@@L0+2]
	jne	@@2

	xor	esi, esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

@@Unpack:
	cmp	al, 4
	je	@@Unp04
	cmp	al, 13h
	je	@@Unp13
	ja	@@Unp23

@@Unp03 PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]

@@2:	sub	[@@SC], 2
	jb	@@9
	xor	eax, eax
	lodsw
	xchg	ebx, eax
	movzx	edx, word ptr [@@L0]
	sub	[@@SC], ebx
	jb	@@9
@@1:	sub	ebx, 2
	jb	@@9
	xor	eax, eax
	lodsw
	mov	ecx, eax
	and	ch, 0Fh
	sub	edx, ecx
	jb	@@9
	lea	ecx, [ecx*2+ecx]
	shr	eax, 0Ch
	jne	@@1a
	sub	ebx, 3
	jb	@@9
	add	esi, 3
	sub	ecx, 3
	jb	@@1b
	sub	esi, 3
	mov	eax, edi
	movsb
	movsb
	movsb
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1b

@@1a:	cmp	al, 0Fh
	jne	@@1b
	sub	ebx, ecx
	jb	@@9
	rep	movsb
@@1b:	test	edx, edx
	jne	@@1
	add	esi, ebx
	dec	word ptr [@@L0+2]
	jne	@@2

	xor	esi, esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

@@Unp13 PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]

@@C = dword ptr [ebp-4]
@@A = byte ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]

	mov	ecx, 180h
	sub	[@@SC], ecx
	jb	@@9
	add	esi, ecx
@@2:	sub	[@@SC], 2
	jb	@@9
	xor	eax, eax
	lodsw
	xchg	ebx, eax
	movzx	edx, word ptr [@@L0]
	sub	[@@SC], ebx
	jb	@@9
	push	edx
	push	0
@@1:	dec	ebx
	js	@@9
	xor	eax, eax
	lodsb
	cmp	al, 3Eh
	je	@@1d
	cmp	al, -1
	je	@@1c
	cmp	al, 7Fh
	jae	@@1d
	xor	edx, edx
	lea	ecx, [edx+5]
	div	ecx
	sub	edx, 2
	add	[@@A], dl
	xor	edx, edx
	div	ecx
	sub	edx, 2
	sub	eax, 2
	add	[@@A+1], dl
	add	[@@A+2], al
	jmp	@@1d

@@1c:	sub	ebx, 3
	jb	@@9
	lodsb
	mov	[@@A+2], al
	lodsb
	mov	[@@A+1], al
	lodsb
	mov	[@@A], al
@@1d:	mov	al, [@@A]
	stosb
	mov	al, [@@A+1]
	stosb
	mov	al, [@@A+2]
	stosb
	dec	[@@C]
	jne	@@1
	pop	ecx
	pop	ecx
	add	esi, ebx
	dec	word ptr [@@L0+2]
	jne	@@2

	xor	esi, esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

@@Unp23 PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]

@@C = dword ptr [ebp-4]
@@A = byte ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]

	mov	ecx, 180h
	sub	[@@SC], ecx
	jb	@@9
	add	esi, ecx
@@2:	sub	[@@SC], 2
	jb	@@9
	xor	eax, eax
	lodsw
	xchg	ebx, eax
	movzx	edx, word ptr [@@L0]
	sub	[@@SC], ebx
	jb	@@9
	push	edx
	push	0
@@1:	dec	ebx
	js	@@9
	xor	eax, eax
	lodsb
	cmp	al, 3Eh
	je	@@1d
	cmp	al, 7Fh
	je	@@1c
	test	al, al
	js	@@1b
	xor	edx, edx
	lea	ecx, [edx+5]
	div	ecx
	sub	edx, 2
	add	[@@A], dl
	xor	edx, edx
	div	ecx
	sub	edx, 2
	sub	eax, 2
	add	[@@A+1], dl
	add	[@@A+2], al
	jmp	@@1d

@@1b:	dec	ebx
	js	@@9
	and	al, 7Fh
	mov	ah, al
	lodsb
	mov	edx, eax
	sar	edx, 0Ah
	sub	edx, 0Fh
	add	[@@A], dl
	mov	edx, eax
	sar	edx, 5
	and	edx, 1Fh
	and	eax, 1Fh
	sub	edx, 0Fh
	sub	eax, 0Fh
	add	[@@A+1], dl
	add	[@@A+2], al
	jmp	@@1d

@@1c:	sub	ebx, 3
	jb	@@9
	lodsb
	mov	[@@A+2], al
	lodsb
	mov	[@@A+1], al
	lodsb
	mov	[@@A], al
@@1d:	mov	al, [@@A]
	stosb
	mov	al, [@@A+1]
	stosb
	mov	al, [@@A+2]
	stosb
	dec	[@@C]
	jne	@@1
	pop	ecx
	pop	ecx
	add	esi, ebx
	dec	word ptr [@@L0+2]
	jne	@@2

	xor	esi, esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

ENDP