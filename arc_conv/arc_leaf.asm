
; "Utawarerumono", "Full Ani" *.a

	dw _conv_leaf-$-2
_arc_leaf PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	eax
	cmp	ax, 0AF1Eh
	jne	@@9a
	shr	eax, 10h
	je	@@9a
	mov	[@@N], eax
	imul	ebx, eax, 20h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	dword ptr [esi+1Ch], 0
	jne	@@9
	call	_ArcCount, [@@N]
	lea	eax, [ebx+4]
	mov	[@@P], eax

@@1:	call	_ArcName, esi, 17h
	mov	eax, [esi+1Ch]
	mov	ebx, [esi+18h]
	add	eax, [@@P]
	and	[@@D], 0
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	cmp	byte ptr [esi+17h], 1
	je	@@2a
	; w 12h -> wav 2Ch
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 1Ah
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 20h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	sub	ebx, 4
	jb	@@1a
	push	ecx
	mov	edx, esp
	call	_FileRead, [@@S], edx, 4
	pop	edi
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, edi, ebx, 0
	call	_lzss_unpack, [@@D], edi, edx, eax
	jmp	@@1b
ENDP

_conv_leaf PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'w'
	je	@@5
	cmp	eax, 'xp'
	jne	@@9
	sub	ebx, 20h
	jbe	@@9
	mov	edx, 'AUQA'
	mov	ecx, 'SULP'
	mov	eax, [esi+14h]
	sub	edx, [esi+18h]
	sub	ecx, [esi+1Ch]
	sub	eax, 'faeL'
	or	edx, ecx
	mov	ecx, [esi+4]
	or	eax, [esi+8]
	or	edx, [esi+0Ch]
	dec	ecx
	or	edx, eax
	shr	ecx, 0Fh	; image_cnt
	mov	eax, [esi+10h]
	or	edx, ecx
	mov	ecx, [esi]
	sub	al, 90h
	dec	ecx
	or	eax, edx
	shr	ecx, 0Fh
	or	eax, ecx
	je	@@2

	call	@@Check0B, esi, ebx
	jnc	@@3
	call	@@Check0C, esi, ebx
	jnc	@@4

	mov	eax, [esi]
	mov	ecx, [esi+4]
	sub	eax, [esi+14h]
	sub	ecx, [esi+18h]
	or	eax, [esi+8]
	or	ecx, [esi+0Ch]
	or	eax, [esi+1Ch]
	or	eax, ecx
	jne	@@9
	mov	edx, [esi]
	mov	eax, [esi+10h]
	imul	edx, [esi+4]
	push	38h
	pop	ecx
	cmp	eax, 200001h
	je	@@1a
	add	edx, 400h
	cmp	eax, 80007h
	je	@@1b
@@9:	stc
	leave
	ret

@@1a:	shl	edx, 2
	add	ecx, 3
@@1b:	cmp	ebx, edx
	jne	@@9
	call	_ArcTgaAlloc, ecx, dword ptr [esi], dword ptr [esi+4]
	xchg	edi, eax
	add	esi, 20h
	mov	ecx, ebx
	add	edi, 12h
	rep	movsb
	clc
	leave
	ret

@@2:	mov	[@@SC], ebx
	mov	ecx, [esi+4]
	add	esi, 20h
	push	ecx
	xor	ebx, ebx
	dec	ecx
	je	@@2c
	call	_ArcSetExt, 0
	push	edx	; @@L1
@@2a:	call	_ArcNameFmt, [@@L1], ebx
	db '\%05i',0
	pop	ecx
@@2c:	sub	[@@SC], 20h
	jb	@@2b
	mov	eax, [esi]
	mov	ecx, [esi+4]
	sub	eax, [esi+14h]
	sub	ecx, [esi+18h]
	or	eax, [esi+8]
	or	ecx, [esi+0Ch]
	or	eax, [esi+1Ch]
	or	eax, ecx
	jne	@@2b
	mov	edx, [esi]
	mov	eax, [esi+10h]
	imul	edx, [esi+4]
	shl	edx, 2
	cmp	eax, 20000Ah
	jne	@@2b
	sub	[@@SC], edx
	jb	@@2b
	push	edx
	call	_ArcTgaAlloc, 23h, dword ptr [esi], dword ptr [esi+4]
	xchg	edi, eax
	pop	ecx
	add	esi, 20h
	add	edi, 12h
	rep	movsb
	call	_ArcTgaSave
	call	_ArcTgaFree
	inc	ebx
	dec	[@@L0]
	jne	@@2a
@@2b:	clc
	leave
	ret

@@3:	mov	ecx, [esi]
	push	ecx
	xor	ebx, ebx
	dec	ecx
	je	@@3c
	call	_ArcSetExt, 0
	push	edx	; @@L1
@@3a:	call	_ArcNameFmt, [@@L1], ebx
	db '\%05i',0
	pop	ecx
@@3c:	call	_ArcTgaAlloc, 23h, dword ptr [esi+14h], dword ptr [esi+18h]
	xchg	edi, eax
	add	edi, 12h
	call	@@Deblock0B, esi, edi, ebx
	call	_ArcTgaSave
	call	_ArcTgaFree
	inc	ebx
	dec	[@@L0]
	jne	@@3a
	clc
	leave
	ret

@@4:	mov	ecx, [esi]
	push	ecx
	xor	ebx, ebx
	dec	ecx
	je	@@4c
	call	_ArcSetExt, 0
	push	edx	; @@L1
@@4a:	call	_ArcNameFmt, [@@L1], ebx
	db '\%05i',0
	pop	ecx
@@4c:	movzx	edx, word ptr [esi+16h]
	movzx	eax, word ptr [esi+14h]
	call	_ArcTgaAlloc, 23h, eax, edx
	xchg	edi, eax
	add	edi, 12h
	call	@@Deblock0C, esi, edi, ebx
	call	_ArcTgaSave
	call	_ArcTgaFree
	inc	ebx
	dec	[@@L0]
	jne	@@4a
	clc
	leave
	ret

@@9a:	stc
	leave
	ret

@@5:	sub	ebx, 12h
	jb	@@9a
	cmp	[esi+0Ah], ebx
	jne	@@9a
	movzx	eax, word ptr [esi+4]
	movzx	ecx, byte ptr [esi]
	ror	eax, 3
	imul	ecx, eax
	dec	eax
	cmp	eax, 2
	jae	@@9a
	movzx	eax, byte ptr [esi+1]
	movzx	edx, word ptr [esi+2]
	cmp	ecx, eax
	jne	@@9a
	imul	eax, edx
	cmp	eax, [esi+6]
	jne	@@9a
	lea	esi, [esi+ebx+12h]
	mov	ecx, ebx
	lea	edi, [esi+19h]
	dec	esi
	std
	rep	movsb
	cld
	sub	edi, 2Bh
	add	ebx, 2Ch
	mov	dword ptr [edi+24h], 'atad'
	mov	[edi+28h], ebx

	movzx	eax, byte ptr [edi]
	movzx	edx, word ptr [edi+2]
	shl	eax, 10h
	inc	eax
	mov	[edi+14h], eax
	mov	[edi+18h], edx
	movzx	edx, word ptr [edi+4]
	mov	eax, [edi+6]
	shl	edx, 10h
	mov	dl, [edi+1]
	mov	[edi+1Ch], eax
	mov	[edi+20h], edx

	mov	eax, 'FFIR'
	stosd
	mov	eax, ebx
	stosd
	mov	eax, 'EVAW'
	stosd
	mov	eax, ' tmf'
	stosd
	lea	eax, [ecx+10h]
	stosd
	call	_ArcSetExt, 'vaw'
	call	_ArcData, [@@SB], ebx
	clc
	leave
	ret

@@Check0B PROC

@@S = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ebx, [@@C]
	mov	esi, [@@S]
	mov	ecx, [esi]
	mov	edx, 20000Bh
	movzx	eax, word ptr [esi+4]
	dec	ecx
	sub	edx, [esi+10h]
	shr	ecx, 0Fh	; image_cnt
	lea	edi, [eax-1]
	or	edx, ecx
	ror	eax, 4
	lea	ecx, [eax+3]	; 10h,20h -> 4,5
	dec	eax
	shr	eax, 1
	or	eax, edx
	jne	@@9
	mov	eax, [esi+14h]
	mov	edx, [esi+18h]
	add	eax, edi
	add	edx, edi
	movsx	edi, word ptr [esi+6]
	shr	eax, cl
	shr	edx, cl
	shr	edi, 0Fh	; pal_count
	sub	ax, [esi+1Ch]
	sub	dx, [esi+1Eh]
	or	eax, [esi+8]
	or	edx, [esi+0Ch]
	or	eax, edi
	or	eax, edx
	je	@@1
@@9:	stc
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@1:	movzx	eax, word ptr [esi+6]
	mov	edi, eax
	shl	eax, 2
	sub	ebx, eax
	jb	@@9
	push	ecx
	mov	ecx, [esi]
	movzx	eax, word ptr [esi+1Ch]
	movzx	edx, word ptr [esi+1Eh]
	shl	ecx, 1
	imul	eax, edx
	mul	ecx
	test	edx, edx
	jne	@@9
	sub	ebx, eax
	jb	@@9
	mov	[@@C], ebx
	shr	eax, 1
	xor	edx, edx
	xchg	ebx, eax
	lea	esi, [esi+edi*4+20h]
@@2:	movzx	eax, word ptr [esi]
	inc	esi
	inc	esi
	mov	ecx, eax
	add	cx, di
	jc	@@2a
	cmp	edx, eax
	jae	$+3
	xchg	edx, eax
@@2a:	dec	ebx
	jne	@@2
	pop	ecx
	push	4
	shl	ecx, 1
	pop	edi
	shl	edi, cl
	inc	edi
	inc	edi
	imul	edx, edi
	cmp	[@@C], edx
	jb	@@9
	clc
	jmp	@@9a
ENDP

@@Deblock0B PROC

@@S = dword ptr [ebp+14h]
@@D = dword ptr [ebp+18h]
@@I = dword ptr [ebp+1Ch]

@@stk = 0
@M0 @@L0
@M0 @@L1
@M0 @@Y
@M0 @@X
@M0 @@H
@M0 @@W
@M0 @@A

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ebx, [@@S]
	movzx	ecx, word ptr [ebx+4]
	movzx	esi, word ptr [ebx+6]
	imul	ecx, ecx
	movzx	edx, word ptr [ebx+1Eh]
	movzx	eax, word ptr [ebx+1Ch]
	shl	ecx, 2
	imul	eax, edx
	inc	ecx
	mov	edx, [ebx]
	inc	ecx
	lea	esi, [ebx+esi*4+20h]
	imul	edx, eax
	imul	eax, [@@I]
	lea	edx, [esi+edx*2]
	lea	esi, [esi+eax*2]
	push	ecx
	push	edx

	push	0	; @@Y
@@1a:	xor	eax, eax
@@1b:	push	eax	; @@X
	mov	edx, [@@Y]
	movzx	ecx, word ptr [ebx+4]
	mov	edi, [ebx+14h]
	imul	edx, ecx
	imul	eax, ecx
	imul	edi, edx
	sub	edx, [ebx+18h]
	add	edi, eax
	sub	eax, [ebx+14h]
	neg	edx
	neg	eax
	cmp	edx, ecx
	jb	$+4
	mov	edx, ecx
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
	mov	ecx, [ebx+14h]
	push	edx
	push	eax
	sub	ecx, eax
	shl	edi, 2
	shl	ecx, 2
	add	edi, [@@D]
	push	ecx
	movzx	eax, word ptr [esi]
	inc	esi
	inc	esi
	movzx	ecx, word ptr [ebx+6]
	test	eax, eax
	je	@@2b
	add	cx, ax
	jc	@@2a
	push	esi
	dec	eax
	imul	eax, [@@L0]
	add	eax, [@@L1]
	lea	esi, [eax+2]
	movzx	edx, word ptr [ebx+4]
	sub	edx, [@@W]
@@1c:	mov	ecx, [@@W]
	rep	movsd
	lea	esi, [esi+edx*4]
	add	edi, [@@A]
	dec	[@@H]
	jne	@@1c
	pop	esi
@@1d:	add	esp, 0Ch
	pop	eax
	inc	eax
	movzx	edx, word ptr [ebx+1Ch]
	cmp	eax, edx
	jb	@@1b
	inc	[@@Y]
	movzx	eax, word ptr [ebx+1Eh]
	cmp	[@@Y], eax
	jb	@@1a
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@2a:	not	ax
	mov	eax, [ebx+eax*4+20h]
@@2b:	mov	ecx, [@@W]
	rep	stosd
	add	edi, [@@A]
	dec	[@@H]
	jne	@@2b
	jmp	@@1d
ENDP

@@Check0C PROC

@@S = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ebx, [@@C]
	mov	esi, [@@S]
	mov	ecx, [esi]
	mov	edx, 20000Ch
	mov	eax, [esi+4]
	dec	ecx
	sub	edx, [esi+10h]
	mov	edi, [esi+18h]
	sub	eax, 1Eh
	shr	ecx, 0Fh	; image_cnt
	shr	edi, 10h
	or	eax, ecx
	or	edx, edi
	or	eax, edx
	jne	@@9
	push	1Eh
	pop	ecx
	movzx	eax, word ptr [esi+14h]
	lea	eax, [eax+ecx-1]
	xor	edx, edx
	div	ecx
	cmp	[esi+1Ch], ax
	jne	@@9
	movzx	eax, word ptr [esi+16h]
	lea	eax, [eax+ecx-1]
	xor	edx, edx
	div	ecx
	cmp	[esi+1Eh], ax
	je	@@1
@@9:	stc
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@1:	movzx	eax, word ptr [esi+6]
	mov	edi, eax
	shl	eax, 2
	sub	ebx, eax
	jb	@@9
	mov	ecx, [esi]
	movzx	eax, word ptr [esi+1Ch]
	movzx	edx, word ptr [esi+1Eh]
	shl	ecx, 1
	imul	eax, edx
	mul	ecx
	test	edx, edx
	jne	@@9
	sub	ebx, eax
	jb	@@9
	shr	eax, 1
	xchg	ecx, eax
	mov	edx, [esi+18h]
@@2:	movzx	eax, word ptr [esi+20h]
	inc	esi
	inc	esi
	cmp	eax, edx
	ja	@@9
	dec	ecx
	jne	@@2
	imul	edx, 1002h
	cmp	ebx, edx
	jb	@@9
	clc
	jmp	@@9a
ENDP

@@Deblock0C PROC

@@S = dword ptr [ebp+14h]
@@D = dword ptr [ebp+18h]
@@I = dword ptr [ebp+1Ch]

@@stk = 0
@M0 @@L0
@M0 @@L1
@M0 @@L2, 8
@M0 @@Y
@M0 @@X
@M0 @@H
@M0 @@W
@M0 @@A

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ebx, [@@S]
	movzx	edx, word ptr [ebx+1Eh]
	movzx	eax, word ptr [ebx+1Ch]
	imul	eax, edx
	mov	edx, [ebx]
	lea	esi, [ebx+20h]
	imul	edx, eax
	imul	eax, [@@I]
	lea	edx, [esi+edx*2]
	lea	esi, [esi+eax*2]
	push	1002h
	push	edx
	movzx	edx, word ptr [ebx+16h]
	movzx	eax, word ptr [ebx+14h]
	push	edx
	push	eax

	push	0	; @@Y
@@1a:	xor	eax, eax
@@1b:	push	eax	; @@X
	mov	edx, [@@Y]
	movzx	ecx, word ptr [ebx+4]
	mov	edi, [@@L2]
	imul	edx, ecx
	imul	eax, ecx
	imul	edi, edx
	sub	edx, [@@L2+4]
	add	edi, eax
	sub	eax, [@@L2]
	neg	edx
	neg	eax
	cmp	edx, ecx
	jb	$+4
	mov	edx, ecx
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
	mov	ecx, [@@L2]
	push	edx
	push	eax
	sub	ecx, eax
	shl	edi, 2
	shl	ecx, 2
	add	edi, [@@D]
	push	ecx
	movzx	eax, word ptr [esi]
	inc	esi
	inc	esi
	test	eax, eax
	je	@@2b
	push	esi
	dec	eax
	imul	eax, [@@L0]
	add	eax, [@@L1]
	mov	ecx, [@@W]
	lea	esi, [eax+2+ecx*4+0Ch]	; (1,1)
	push	20h-1Eh
	pop	edx
@@1c:	mov	ecx, [@@W]
	rep	movsd
	lea	esi, [esi+edx*4]
	add	edi, [@@A]
	dec	[@@H]
	jne	@@1c
	pop	esi
@@1d:	add	esp, 0Ch
	pop	eax
	inc	eax
	movzx	edx, word ptr [ebx+1Ch]
	cmp	eax, edx
	jb	@@1b
	inc	[@@Y]
	movzx	eax, word ptr [ebx+1Eh]
	cmp	[@@Y], eax
	jb	@@1a
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@2b:	mov	ecx, [@@W]
	rep	stosd
	add	edi, [@@A]
	dec	[@@H]
	jne	@@2b
	jmp	@@1d
ENDP

ENDP
