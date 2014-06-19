
; "Flyable Heart" *.pac

; dll\PAL.dll
; 1000DEA0 PalCopyFileToSpriteRGB
; 10017B90
; 10015F60 Unpack

	dw _conv_softpal_fh-$-2
_arc_softpal_fh PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	ebx
	lea	ecx, [ebx-1]
	shr	ecx, 14h
	jne	@@9a
	mov	edi, 3FEh
@@2a:	mov	[@@N], ebx
	call	_FileSeek, [@@S], edi, 0
	jc	@@9a
	xchg	edi, eax
	imul	ebx, 28h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	add	edi, ebx
	mov	esi, [@@M]
	cmp	[esi+24h], edi
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 20h
	and	[@@D], 0
	mov	ebx, [esi+20h]
	call	_FileSeek, [@@S], dword ptr [esi+24h], 0
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

; "Flyable CandyHeart" *.pac

	dw _conv_softpal_fh-$-2
_arc_softpal_fch:
	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	pop	eax
	pop	edx
	pop	ebx
	sub	eax, ' CAP'
	or	eax, edx
	jne	@@9a
	lea	ecx, [ebx-1]
	shr	ecx, 14h
	jne	@@9a
	mov	edi, 804h
	jmp	@@2a
ENDP

_conv_softpal_fh PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'ggo'
	je	@@4
	cmp	eax, 'dgp'
	jne	@@9
	sub	ebx, 28h
	jb	@@9
	mov	ecx, ebx
	mov	eax, [esi]
	sub	ecx, [esi+24h]
	sub	eax, 204547h
	or	eax, ecx
	je	@@1
@@9:	stc
	leave
	ret

@@4:	cmp	ebx, 14h
	jb	@@9
	mov	edx, 'SggO'
	mov	eax, [esi]
	sub	edx, [esi+0Ch]
	sub	eax, ' MGB'
	or	eax, edx
	jne	@@9
	sub	ebx, 0Ch
	add	esi, 0Ch
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@1:	movzx	ecx, word ptr [esi+1Ch]
	mov	[@@SC], ebx
	mov	edi, [esi+0Ch]
	mov	edx, [esi+10h]
	mov	ebx, [esi+20h]
	dec	ecx
	je	@@2
	dec	ecx
	je	@@5
	dec	ecx
	jne	@@9
	mov	eax, edi
	shl	eax, 2
	inc	eax
	imul	eax, edx
	add	eax, 8
	cmp	ebx, eax
	jne	@@1a
	call	_ArcTgaAlloc, 23h, edi, edx
	xchg	edi, eax
	call	_MemAlloc, ebx
	jc	@@9
	push	eax
	push	4
@@1b:	push	eax
	mov	edx, [esi+8]
	shl	edx, 10h
	mov	dx, [esi+4]
	mov	[edi+8], edx
	add	esi, 28h
	add	edi, 12h
	call	@@Unpack, eax, ebx, esi, [@@SC]
	call	@@Decode3, edi
	call	_MemFree
	clc
	leave
	ret

@@1a:	lea	eax, [edi*2+edi+1]
	imul	eax, edx
	add	eax, 8
	cmp	ebx, eax
	jne	@@9
	call	_ArcTgaAlloc, 22h, edi, edx
	xchg	edi, eax
	call	_MemAlloc, ebx
	jc	@@9
	push	eax
	push	3
	jmp	@@1b

@@2:	mov	eax, edi
	imul	eax, edx
	shl	eax, 2
	cmp	ebx, eax
	jne	@@9
	call	_ArcTgaAlloc, 23h, edi, edx
	xchg	edi, eax
	mov	eax, [esi+8]
	shl	eax, 10h
	mov	ax, [esi+4]
	mov	[edi+8], eax
	add	esi, 28h
	add	edi, 12h
	call	_MemAlloc, ebx
	jc	@@9
	push	eax
	push	eax
	call	@@Unpack, eax, ebx, esi, [@@SC]
	call	@@Decode1, edi
	call	_MemFree
	clc
	leave
	ret

@@5:	mov	eax, edi
	or	eax, edx
	shr	eax, 1
	jc	@@9
	mov	eax, edi
	imul	eax, edx
	lea	eax, [eax*2+eax]
	shr	eax, 1
	cmp	ebx, eax
	jne	@@9
	call	_ArcTgaAlloc, 22h, edi, edx
	xchg	edi, eax
	mov	eax, [esi+8]
	shl	eax, 10h
	mov	ax, [esi+4]
	mov	[edi+8], eax
	add	esi, 28h
	add	edi, 12h
	call	_MemAlloc, ebx
	jc	@@9
	push	eax
	push	eax
	call	@@Unpack, eax, ebx, esi, [@@SC]
	call	@@Decode2, edi
	call	_MemFree
	clc
	leave
	ret

if 0
@@3:	mov	edi, [esi+20h]
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	add	esi, 28h
	call	@@Unpack, edi, eax, esi, [@@SC]
	xchg	ebx, eax
	call	_ArcSetExt, 'nib'
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret
endif

@@Unpack PROC

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
	xor	ebx, ebx
@@1:	xor	eax, eax
	cmp	[@@DC], eax
	je	@@7
	shr	ebx, 1
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@1a:	jc	@@1b
	dec	[@@SC]
	js	@@9
	lodsb
	sub	[@@SC], eax
	jb	@@9
	sub	[@@DC], eax
	jb	@@9
	xchg	ecx, eax
	rep	movsb
	jmp	@@1

@@1b:	sub	[@@SC], 2
	jb	@@9
	lodsw
	mov	edx, eax
	and	eax, 0Fh
	shr	edx, 4
	lea	ecx, [eax-4]
	test	al, 8
	jne	@@1c
	mov	ah, al
	dec	[@@SC]
	js	@@9
	lodsb
	lea	ecx, [eax+4]
@@1c:	neg	edx
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
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

@@Decode1 PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]

@@H = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@D]
	mov	esi, [@@S]
	movzx	ebx, word ptr [edi-12h+0Ch]
	movzx	eax, word ptr [edi-12h+0Eh]
	imul	ebx, eax
	mov	ecx, ebx
	lea	edx, [ebx*2+ebx]
@@1:	mov	al, [esi+edx]
	stosb
	mov	al, [esi+ebx*2]
	stosb
	mov	al, [esi+ebx]
	stosb
	movsb
	dec	ecx
	jne	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

@@Decode2 PROC	; 100161F0

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]

@@W = dword ptr [ebp-4]
@@A = dword ptr [ebp-8]
@@H = dword ptr [ebp-0Ch]
@@L1 = dword ptr [ebp-10h]
@@L2 = dword ptr [ebp-14h]
@@L0 = dword ptr [ebp-24h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	edi, [@@D]
	mov	esi, [@@S]
	movzx	eax, word ptr [edi-12h+0Ch]
	movzx	ecx, word ptr [edi-12h+0Eh]
	lea	edx, [eax*2+eax]
	push	eax
	shr	ecx, 1
	shr	eax, 1
	push	edx
	push	ecx
	imul	eax, ecx
	push	esi		; @@L1
	add	esi, eax
	push	esi		; @@L2
	add	esi, eax

@@1:	mov	ecx, [@@W]
	shr	ecx, 1
@@2:	push	ecx
	mov	eax, [@@L1]
	movsx	ebx, byte ptr [eax]
	inc	eax
	mov	[@@L1], eax
	mov	eax, [@@L2]
	movsx	ecx, byte ptr [eax]
	inc	eax
	mov	[@@L2], eax

	imul	edx, ebx, 0E2h
	imul	eax, ecx, 59h
	imul	ebx, -2Bh
	imul	ecx, 0B3h
	sub	ebx, eax
	sar	edx, 7
	sar	ebx, 7
	sar	ecx, 7
	push	edx
	push	ebx
	push	ecx	; @@L0

	call	@@3
	call	@@3
	dec	esi
	dec	esi
	sub	edi, 6
	add	esi, [@@W]
	add	edi, [@@A]
	call	@@3
	call	@@3
	add	esp, 0Ch
	pop	ecx
	sub	esi, [@@W]
	sub	edi, [@@A]
	dec	ecx
	jne	@@2
	add	esi, [@@W]
	add	edi, [@@A]
	dec	[@@H]
	jne	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@3:	movzx	eax, byte ptr [esi]
	inc	esi
	mov	edx, [@@L0+8]
	mov	ecx, [@@L0+4]
	add	edx, eax
	jns	$+4
	xor	edx, edx
	add	ecx, eax
	jns	$+4
	xor	ecx, ecx
	add	eax, [@@L0]
	jns	$+4
	xor	eax, eax
	test	dh, dh
	je	$+4
	mov	dl, 0FFh
	test	ch, ch
	je	$+4
	mov	cl, 0FFh
	test	ah, ah
	je	$+4
	mov	al, 0FFh
	mov	[edi], dl
	mov	[edi+1], cl
	mov	[edi+2], al
	add	edi, 3
	ret
ENDP

@@Decode3 PROC	; 100173B0

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@L0 = dword ptr [ebp+1Ch]

@@H = dword ptr [ebp-4]
@@W = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	edi, [@@D]
	mov	esi, [@@S]
	movzx	eax, word ptr [edi-12h+0Ch]
	movzx	ecx, word ptr [edi-12h+0Eh]
	imul	eax, [@@L0]
	add	esi, 8
	mov	ebx, eax
	mov	edx, esi
	add	esi, ecx
	neg	ebx
	push	ecx
	push	eax
	mov	al, 1
	jmp	@@1e

@@1:	mov	al, [edx]
@@1e:	inc	edx
	mov	ecx, [@@W]
	push	edx
	mov	edx, [@@L0]
	neg	edx
	test	al, 1
	jne	@@1c
	test	al, 2
	jne	@@1b
	mov	eax, [@@L0]
	sub	ecx, eax
	xchg	ecx, eax
	rep	movsb
	xchg	ecx, eax
	test	ecx, ecx
	je	@@7
@@1a:	mov	al, [edi+ebx]
	add	al, [edi+edx]
	rcr	al, 1
	sub	al, [esi]
	inc	esi
	stosb
	dec	ecx
	jne	@@1a
	jmp	@@7

@@1b:	mov	al, [edi+ebx]
	sub	al, [esi]
	inc	esi
	stosb
	dec	ecx
	jne	@@1b
	jmp	@@7

@@1c:	mov	eax, [@@L0]
	sub	ecx, eax
	xchg	ecx, eax
	rep	movsb
	xchg	ecx, eax
	test	ecx, ecx
	je	@@7
@@1d:	mov	al, [edi+edx]
	sub	al, [esi]
	inc	esi
	stosb
	dec	ecx
	jne	@@1d
@@7:	pop	edx
	dec	[@@H]
	jne	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

ENDP