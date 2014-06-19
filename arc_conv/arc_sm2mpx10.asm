
; "Pretty Soldier Wars A.D.2048" GGD, WMSC
; YJWARUS.EXE
; 0040BF50 ggp_open
; 0040BF10 ggp_decode

	dw _conv_sm2mpx10-$-2
_arc_sm2mpx10 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+20h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 20h
	jc	@@9a
	mov	ecx, [esi+1Ch]
	pop	eax
	pop	edx
	sub	eax, 'M2MS'
	sub	edx, '01XP'
	and	ecx, NOT 20h
	or	eax, edx
	or	eax, ecx
	jne	@@9a
	pop	ecx
	pop	ebx
	mov	[@@N], ecx
	imul	eax, ecx, 14h
	dec	ecx
	sub	ebx, 20h
	jb	@@9a
	shr	ecx, 14h
	jne	@@9a
	cmp	ebx, eax
	jb	@@9a
	xchg	ebx, eax
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 0Ch
	and	[@@D], 0
	mov	ebx, [esi+10h]
	call	_FileSeek, [@@S], dword ptr [esi+0Ch], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 7
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 14h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_sm2mpx10 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ax, 'gg'
	jne	@@9
	shr	eax, 10h
	cmp	eax, 'p'
	jne	@@3
	cmp	ebx, 1Ch
	jb	@@9
	mov	eax, 'FPGG'
	mov	edx, 'EKIA'
	sub	eax, [esi]
	sub	edx, [esi+4]
	or	eax, edx
	jne	@@9
	mov	eax, [esi+0Ch]
	mov	edx, [esi+10h]
	mov	ecx, eax
	or	ecx, edx
	je	@@1a
	xor	eax, [esi]
	xor	edx, [esi+4]
@@1a:	mov	ecx, [esi+14h]
	sub	ebx, ecx
	cmp	ebx, [esi+18h]
	jne	@@9
	add	esi, ecx
	cmp	ebx, 8
	jb	@@9
	push	edx
	push	eax
	xor	eax, [esi]
	xor	edx, [esi+4]
	sub	eax, 474E5089h
	sub	edx, 0A1A0A0Dh
	or	eax, edx
	pop	eax
	pop	edx
	jne	@@9
	lea	ecx, [ebx+7]
	mov	edi, esi
	shr	ecx, 3
@@1b:	xor	[edi], eax
	xor	[edi+4], edx
	add	edi, 8
	dec	ecx
	jne	@@1b
	call	_ArcSetExt, 'gnp'
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@9:	stc
	leave
	ret

@@3:	cmp	eax, 'd'
	jne	@@2
	cmp	ebx, 8
	jb	@@9
	mov	eax, [esi]
	cmp	eax, 0B8C9CACDh
	je	@@3a
	cmp	eax, 0B3B3AAB9h
	jne	@@9
	movzx	edi, word ptr [esi+4]
	movzx	edx, word ptr [esi+6]
	mov	eax, edi
	lea	ebx, [edi*2+edi+3]
	and	eax, 3
	and	ebx, -4
	neg	eax
	adc	edi, 0
	imul	ebx, edx
	call	_ArcTgaAlloc, 22h, edi, edx
	xchg	edi, eax
	add	esi, 8
	mov	ecx, [@@SC]
	add	edi, 12h
	sub	ecx, 8
	call	@@GGD, edi, ebx, esi, ecx
	movzx	eax, word ptr [esi-8+4]
	movzx	ebx, word ptr [esi-8+6]
	mov	esi, edi
	mov	[edi-12h+0Ch], ax
	lea	edx, [eax*2+eax]
	and	eax, 3
	je	@@3c
@@3b:	mov	ecx, edx
	rep	movsb
	add	esi, eax
	dec	ebx
	jne	@@3b
@@3c:	clc
	leave
	ret

@@3a:	mov	ecx, 430h
	sub	ebx, ecx
	jb	@@9
	mov	edx, 80001h
	mov	eax, [esi+4]
	sub	edx, [esi+10h]
	sub	eax, 28h
	or	eax, edx
	jne	@@9
	mov	[@@SC], ebx
	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	add	edi, 3
	and	edi, -4
	neg	edx
	mov	ebx, edi
	imul	ebx, edx
	mov	eax, [esi+ecx-4]
	cmp	eax, [esi+18h]
	jne	@@9
	cmp	eax, ebx
	jb	@@9
	call	_ArcTgaAlloc, 38h, edi, edx
	xchg	edi, eax
	add	esi, 2Ch
	push	edi
	add	edi, 12h
	mov	ecx, 100h
	rep	movsd
	mov	edx, edi
	lodsd
	pop	edi
	call	_lzss_unpack, edx, ebx, esi, [@@SC]
	clc
	leave
	ret

@@2:	sub	eax, 30h
	cmp	eax, 4
	jae	@@9
	cmp	ebx, 30h
	jb	@@9
	mov	eax, '0AGG'
	mov	edx, '0000'
	sub	eax, [esi]
	sub	edx, [esi+4]
	or	eax, edx
	jne	@@9
	mov	ecx, [esi+18h]
	lea	eax, [ecx-30h]
	add	ecx, [esi+1Ch]
	sub	ebx, ecx
	jb	@@9
	sub	ecx, [esi+10h]
	sub	ebx, [esi+14h]
	or	eax, ecx
	or	eax, ebx
	jne	@@9
	movzx	edi, word ptr [esi+8]
	movzx	edx, word ptr [esi+0Ah]
	mov	ebx, edi
	imul	ebx, edx
	shl	ebx, 2
	call	_ArcTgaAlloc, 23h, edi, edx
	xchg	edi, eax
	mov	ecx, [esi+10h]
	add	ecx, esi
	lea	edx, [edi+12h]
	call	@@GGA, edx, ebx, ecx, dword ptr [esi+14h], dword ptr [edi+0Ch]
	clc
	leave
	ret

@@GGD PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
@@1:	cmp	[@@DC], 0
	je	@@7
	dec	[@@SC]
	js	@@9
	movzx	edx, byte ptr [esi]
	inc	esi
	cmp	edx, 5
	jb	@@1a
	lea	ecx, [edx-4]
	lea	ecx, [ecx*2+ecx]
	sub	[@@DC], ecx
	jb	@@9
	sub	[@@SC], ecx
	jc	@@9
	rep	movsb
	jmp	@@1

@@1a:	xor	ecx, ecx
	inc	ecx
	cmp	edx, 3
	jae	@@1b
	dec	[@@SC]
	js	@@9
	mov	cl, [esi]
	inc	esi
	test	ecx, ecx
	je	@@9
@@1b:	xchg	eax, edx
	xor	edx, edx
	inc	edx
	dec	eax
	js	@@1d
	shr	eax, 1
	jc	@@1c
	dec	[@@SC]
	js	@@9
	mov	dl, [esi]
	inc	esi
	jmp	@@1d

@@1c:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
@@1d:	lea	edx, [edx*2+edx]
	lea	ecx, [ecx*2+ecx]
	neg	edx
	jnc	@@9
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	push	esi
	lea	esi, [edi+edx]
	rep	movsb
	pop	esi
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

; KANG2US.EXE .40F2A0
; "Kango Shicyauzo 2" TRGRP

; 00 cc (d = 1)
; 01 cc cc (d = 1)
; 02 dd (c = 1)
; 03 dd dd (c = 1)
; 04 dd cc
; 05 dd cc cc
; 06 dd dd cc
; 07 dd dd cc cc
; 08 (d = 1, c = 1)
; 09 (d = w, c = 1)
; 0A (d = w+1, c = 1)
; 0B (d = w-1, c = 1)

@@GGA PROC

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
@@1:	cmp	[@@SC], 0
	je	@@7
	dec	[@@SC]
	movzx	ecx, byte ptr [esi]
	inc	esi
	cmp	ecx, 0Ch
	jb	@@1a
	sub	ecx, 0Bh
	shl	ecx, 2
	sub	[@@DC], ecx
	jb	@@9
	sub	[@@SC], ecx
	jb	@@9
	rep	movsb
	jmp	@@1

@@1a:	xor	edx, edx
	cmp	ecx, 8
	jae	@@1f
	shl	ecx, 2
	mov	ebx, 0A6952184h
	inc	edx
	shr	ebx, cl
	mov	ecx, edx
	shr	ebx, 1
	jnc	@@1b
	dec	[@@SC]
	js	@@9
	mov	dl, [esi]
	inc	esi
@@1b:	shr	ebx, 1
	jnc	@@1c
	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
@@1c:	shr	ebx, 1
	jnc	@@1d
	dec	[@@SC]
	js	@@9
	mov	cl, [esi]
	inc	esi
@@1d:	shr	ebx, 1
	jnc	@@1e
	sub	[@@SC], 2
	jb	@@9
	movzx	ecx, word ptr [esi]
	inc	esi
	inc	esi
@@1e:	shl	edx, 2
	shl	ecx, 2
	je	@@9
	neg	edx
	jnc	@@9
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	push	esi
	lea	esi, [edi+edx]
	rep	movsb
	pop	esi
	jmp	@@1

@@1f:	lea	eax, [ecx-8]
	inc	edx
	dec	eax
	mov	ecx, edx
	js	@@1e
	movzx	edx, word ptr [@@L0]
	je	@@1e
	neg	eax
	lea	edx, [edx+eax*2+3]
	jmp	@@1e

@@7:	mov	ecx, [@@DC]
	xor	eax, eax
	rep	stosd
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
