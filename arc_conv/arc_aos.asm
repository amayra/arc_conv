
; "Dark Blue" *.aos
; sfa16.exe

	dw _conv_aos-$-2
_arc_aos PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	mov	edi, 111h
	pop	ecx
	pop	eax
	pop	ebx
	mov	[@@P], eax
	sub	eax, edi
	sub	eax, ebx
	or	eax, ecx
	jne	@@9a
	xor	edx, edx
	mov	eax, ebx
	lea	ecx, [edx+28h]
	div	ecx
	mov	[@@N], eax
	dec	eax
	shr	eax, 14h
	or	eax, edx
	jne	@@9a
	call	_FileSeek, [@@S], edi, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 20h
	and	[@@D], 0
	mov	eax, [esi+20h]
	mov	ebx, [esi+24h]
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 28h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_aos PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'mba'
	je	@@1
	cmp	eax, 'rcs'
	je	@@2
@@9:	stc
	leave
	ret

@@2:	sub	ebx, 4
	jb	@@9
	mov	edi, [esi]
	add	esi, 4
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	call	_huff_unpack, edi, eax, esi, ebx
	xchg	ebx, eax
	call	_ArcSetExt, 'txt'
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

@@1:	sub	ebx, 36h
	jb	@@9
	mov	[@@SC], ebx
	mov	eax, [esi+0Ah]
	mov	edx, [esi+0Eh]
	sub	eax, 36h
	sub	edx, 28h
	cmp	word ptr [esi], 'MB'
	jne	@@9
	or	eax, edx
	jne	@@9
	mov	eax, [esi+1Ah]
	dec	eax
	ror	eax, 10h
	mov	edi, [esi+12h]
	mov	edx, [esi+16h]
	mov	ebx, edi
	imul	ebx, edx
	cmp	eax, 20h	; 0x01,0x20,0xF8
	jne	@@9
	lea	ebx, [ebx*2+ebx]
	call	_ArcTgaAlloc, 23h, edi, edx
	lea	edi, [eax+12h]
	add	esi, 36h
	call	@@ABM_20, edi, ebx, esi, [@@SC]
	clc
	leave
	ret

if 0
@@1a:	call	_ArcTgaAlloc, 23h, edi, edx
	lea	edi, [eax+12h]
	add	esi, 36h
	call	@@ABM_F8, edi, ebx, esi, [@@SC]
	clc
	leave
	ret
endif

@@ABM_20 PROC	; 00410D40

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	xor	edx, edx
@@1:	xor	ecx, ecx
	xor	eax, eax
	inc	ecx
	cmp	[@@DC], eax
	je	@@7
	sub	[@@SC], 2
	jb	@@9
	lodsb
	test	al, al
	jne	@@1c
	mov	cl, [esi]
	inc	esi
	test	ecx, ecx
	je	@@1
	sub	[@@DC], ecx
	jb	@@9
@@1a:	stosb
	inc	edx
	cmp	edx, 3
	jne	@@1b
	stosb
	xor	edx, edx
@@1b:	dec	ecx
	jne	@@1a
	jmp	@@1

@@1c:	cmp	al, -1
	jne	@@1d
	mov	cl, [esi]
	inc	esi
	test	ecx, ecx
	je	@@1
	sub	[@@SC], ecx
	jb	@@9
@@1d:	sub	[@@DC], ecx
	jb	@@9
@@1e:	movsb
	inc	edx
	cmp	edx, 3
	jne	@@1f
	stosb
	xor	edx, edx
@@1f:	dec	ecx
	jne	@@1e
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
ENDP

if 0
@@ABM_F8 PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	mov	ecx, 400h
	mov	ebx, esi
	sub	[@@SC], ecx
	jb	@@9
	add	esi, ecx

@@1:	xor	eax, eax
	cmp	[@@DC], eax
	je	@@7
	sub	[@@SC], 2
	jb	@@9
	lodsb
	movzx	ecx, byte ptr [esi]
	inc	esi
	test	al, al
	jne	@@1b
	test	ecx, ecx
	je	@@1
	sub	[@@DC], ecx
	jb	@@9
@@1a:	mov	eax, [ebx]
	and	eax, 0FFFFFFh
	stosd
	dec	ecx
	jne	@@1a
	jmp	@@1

@@1b:	cmp	al, 0FFh
	jne	@@1d
	test	ecx, ecx
	je	@@1
	sub	[@@DC], ecx
	jb	@@9
	sub	[@@SC], ecx
	jb	@@9
@@1c:	movzx	eax, byte ptr [esi]
	inc	esi
	mov	eax, [ebx+eax*4]
	or	eax, 0FF000000h
	stosd
	dec	ecx
	jne	@@1c
	jmp	@@1

@@1d:	mov	ecx, dword ptr [ebx+ecx*4]
	dec	[@@DC]
	shl	ecx, 8
	add	eax, ecx
	ror	eax, 8
	stosd
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
ENDP
endif

ENDP
