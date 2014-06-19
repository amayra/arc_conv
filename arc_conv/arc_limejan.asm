
; "Lime Iro Jankitan" *.arc
; mahjong.exe
; 004E4730 rng_decode

	dw _conv_limejan-$-2
_arc_limejan PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+2Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 2Ch
	jc	@@9a
	lodsd
	mov	ebx, eax
	dec	eax
	shr	eax, 14h
	jne	@@9a
	mov	[@@N], ebx
	imul	ebx, 28h
	lea	eax, [ebx+4]
	xor	eax, 10204080h
	cmp	eax, [esi+20h]
	jne	@@9a
	sub	ebx, 28h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 28h, ebx, 0
	jc	@@9
	mov	edi, [@@M]
	mov	edx, edi
	push	28h/4
	pop	ecx
	rep	movsd
	mov	esp, esi
	add	ebx, 28h

	mov	ecx, ebx
	mov	esi, edx
	shr	ecx, 3
@@2a:	xor	dword ptr [edx], 10204080h
	xor	dword ptr [edx+4], 1020408h
	add	edx, 8
	dec	ecx
	jne	@@2a

	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	call	_ArcName, esi, 20h
	and	[@@D], 0
	mov	ebx, [esi+24h]
	call	_FileSeek, [@@S], dword ptr [esi+20h], 0
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

_conv_limejan PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'sem'
	je	@@2
	cmp	eax, 'gnr'
	jne	@@9
	sub	ebx, 31Ch
	jb	@@9
	mov	eax, [esi]
	cmp	eax, '  nR'
	je	@@1
	sub	eax, ' 0mR'
	ror	eax, 10h
	shr	eax, 1
	je	@@1
@@9:	stc
	leave
	ret

@@2:	test	ebx, ebx
	je	@@9
	mov	edx, esi
	mov	ecx, ebx
@@2a:	xor	byte ptr [edx], 55h
	inc	edx
	dec	ecx
	jne	@@2a
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@1:	sub	ebx, [esi+0Ch]
	jb	@@9
	sub	ebx, [esi+10h]
	jb	@@9
	sub	ebx, [esi+14h]
	jb	@@9
	sub	ebx, [esi+18h]
	jb	@@9
	movzx	edi, word ptr [esi+8]
	movzx	edx, word ptr [esi+0Ah]
	cmp	byte ptr [esi+1], 'm'
	je	@@1a
	call	_ArcTgaAlloc, 22h, edi, edx
	lea	edi, [eax+12h]
	mov	eax, [esi+4]
	mov	[edi-12h+8], eax
	call	@@RNG, edi, esi, 3
	clc
	leave
	ret

@@1a:	call	_ArcTgaAlloc, 23h, edi, edx
	lea	edi, [eax+12h]
	mov	eax, [esi+4]
	mov	[edi-12h+8], eax
	call	@@RNG, edi, esi, 4
	cmp	byte ptr [esi+2], '0'
	jne	@@1b
	call	@@RM0, edi, esi, ebx, 4
	clc
	leave
	ret

@@1b:	movzx	eax, word ptr [esi+8]
	movzx	edx, word ptr [esi+0Ah]
	imul	eax, edx
	call	_MemAlloc, eax
	jc	@@1c
	xchg	esi, eax
	call	@@RM0, esi, eax, ebx, 1
	call	@@RM1, edi, esi
	call	_MemFree, esi
@@1c:	clc
	leave
	ret

@@RNG PROC	; 004E4730

@@DB = dword ptr [ebp+14h]
@@SB = dword ptr [ebp+18h]
@@A = dword ptr [ebp+1Ch]

@@stk = 0
@M0 @@W
@M0 @@H
@M0 @@DC
@M0 @@SC
@M0 @@L0, 18h

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@SB]
	lodsd
	lodsd
	lodsd
	movzx	edx, ax
	shr	eax, 10h
	push	edx
	push	eax
	imul	eax, edx
	lea	edx, [esi+310h]
	push	eax	; @@DC
	lodsd
	push	eax
	add	edx, eax
	lodsd
	push	edx
	push	eax	; @@L0+10h
	add	edx, eax
	lodsd
	push	edx
	push	eax	; @@L0+8
	add	edx, eax
	lodsd
	push	edx
	push	eax	; @@L0
	lea	ebx, [@@L0+10h]
	call	@@2
	lea	ebx, [@@L0+8]
	call	@@2
	lea	ebx, [@@L0]
	call	@@2
	and	[@@L0+4], 0

	mov	edi, [@@DB]
	xor	ebx, ebx
@@1:	call	@@3
	jnc	@@1c
	xor	edx, edx
	lea	ecx, [edx+3]
	call	@@3
	jc	@@1a
	call	@@5
	not	eax
	add	eax, 8
	jmp	@@1b

@@1a:	call	@@5
	not	eax
	imul	eax, [@@W]
	push	eax
	mov	cl, 4
	call	@@5
	pop	edx
@@1b:	movsx	eax, [@@T+eax]
	add	edx, eax
	push	edx
	call	@@4
	pop	edx
	lea	ecx, [eax+2]
	mov	eax, [@@A]
	sub	[@@DC], ecx
	jb	@@9
	imul	edx, eax
	imul	ecx, eax
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1e

@@1c:	call	@@4
	inc	eax
	sub	[@@DC], eax
	jb	@@9
	mov	[@@L0+4], eax
@@1d:	mov	eax, [@@L0+10h]
	call	@@6
	jc	@@9
	mov	[edi], al
	mov	eax, [@@L0+8]
	call	@@6
	jc	@@9
	mov	[edi+1], al
	mov	eax, [@@L0]
	call	@@6
	jc	@@9
	mov	[edi+2], al
	add	edi, [@@A]
	dec	[@@L0+4]
	jne	@@1d
@@1e:	cmp	[@@DC], 0
	jne	@@1
	xor	esi, esi
@@9:	mov	ebx, [@@W]
	mov	edi, [@@DB]
	imul	ebx, [@@H]
	xor	eax, eax
	xor	ecx, ecx
	xor	edx, edx
@@7a:	add	al, [edi]
	add	cl, [edi+1]
	add	dl, [edi+2]
	mov	[edi], al
	mov	[edi+1], cl
	mov	[edi+2], dl
	add	edi, [@@A]
	dec	ebx
	jne	@@7a

	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@2:	mov	ecx, [ebx]
	mov	edx, [ebx+4]
	sub	ecx, 4
	jb	@@9
	pop	eax
	sub	esp, 41Ch
	mov	edi, esp
	push	eax
	mov	[ebx], edi
	xor	ebx, ebx
	mov	[edi], edx		; 0x81C
	mov	[edi+4], ecx		; 0x00C
	mov	[edi+8], ebx		; 0x000 low
	or	dword ptr [edi+0Ch], -1	; 0x004 high
	mov	[edi+14h], ebx		; 0x414
	xor	ecx, ecx
	xor	eax, eax
	mov	dl, 80h
@@2a:	lodsb
	xor	al, dl
	ror	dl, 1
	add	ebx, eax
	mov	[edi+ecx*4+16h], ax	; 0x010
	mov	[edi+ecx*4+18h], bx	; 0x418
	inc	cl
	jne	@@2a
	inc	ebx
	mov	[edi+10h], ebx		; 0x818
	ret	

@@3:	shl	bl, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@3a:	ret

@@4:	xor	edx, edx
	lea	ecx, [edx+1]
	call	@@3	; 1, 0
	jc	@@5
	mov	dl, 2
	inc	ecx
	call	@@3	; 2, 2
	jc	@@5
	mov	dl, 6
	inc	ecx
	call	@@3	; 3, 6
	jc	@@5
	mov	dl, 0Eh
	mov	cl, 6
	call	@@3	; 6, 0Eh
	jc	@@5
	mov	dl, 4Eh
	mov	cl, 8
	call	@@3	; 8, 4Eh
	jc	@@5
	mov	dh, 1
	mov	cl, 0Ah
	call	@@3	; 0Ah, 14Eh
	jc	@@5
	mov	dh, 5
	mov	cl, 10h
@@5:	xor	eax, eax
@@5a:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@5a
	add	eax, edx
	ret

_limejan_sys:
@@T	db -14h, -10h, -0Ch, -8, -6, -4, -2, -1
	db 0, 1, 2, 4, 6, 8, 0Ch, 10h

@@6 PROC	; 004E4150
	push	ebx
	push	esi
	push	edi
	xchg	ebx, eax

	mov	esi, [ebx+10h]
	mov	eax, [ebx+0Ch]
	xor	edx, edx
	div	esi
	mov	edx, [ebx]
	xchg	edi, eax
	mov	eax, [edx]
	bswap	eax
	sub	eax, [ebx+8]
	xor	edx, edx
	div	edi
	mov	[ebx+0Ch], edi

	cmp	eax, esi
	jae	@@9
	xchg	ecx, eax

	xor	esi, esi
	mov	edx, 100h
@@1:	lea	eax, [edx+esi]
	shr	eax, 1
	cmp	[ebx+eax*4+18h], cx
	ja	@@1a
	lea	esi, [eax+1]
	jmp	@@1b
@@1a:	xchg	edx, eax
@@1b:	cmp	esi, edx
	jb	@@1
	cmp	esi, 100h
	jb	@@1c
@@9:	stc
	pop	edi
	pop	esi
	pop	ebx
	ret

@@1c:	movzx	edx, word ptr [ebx+esi*4+14h]
	movzx	ecx, word ptr [ebx+esi*4+16h]
	imul	edx, edi
	imul	ecx, edi
	add	edx, [ebx+8]
	mov	edi, 1000000h
	lea	eax, [edx+ecx]
	xor	eax, edx
	cmp	eax, edi
	jae	@@2a
@@2:	dec	dword ptr [ebx+4]
	js	@@9
	inc	dword ptr [ebx]
	shl	eax, 8
	shl	edx, 8
	shl	ecx, 8
	cmp	eax, edi
	jb	@@2
@@2a:	shr	edi, 8
	cmp	ecx, edi
	jae	@@3a
@@3:	movzx	ecx, dx
	dec	dword ptr [ebx+4]
	js	@@9
	inc	dword ptr [ebx]
	neg	cx
	shl	ecx, 8
	shl	edx, 8
	cmp	ecx, edi
	jb	@@3
@@3a:	mov	[ebx+8], edx
	mov	[ebx+0Ch], ecx
	xchg	eax, esi
	clc
	pop	edi
	pop	esi
	pop	ebx
	ret
ENDP

ENDP	; @@RNG

@@RM0 PROC

@@DB = dword ptr [ebp+14h]
@@SB = dword ptr [ebp+18h]
@@SC = dword ptr [ebp+1Ch]
@@A = dword ptr [ebp+20h]

@@stk = 0
@M0 @@L0
@M0 @@W
@M0 @@H
@M0 @@DC

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@SB]
	lodsd
	push	eax
	lodsd
	lodsd
	movzx	edx, ax
	shr	eax, 10h
	cmp	[@@A], 4
	je	$+3
	xchg	eax, edx
	push	edx
	push	eax
	imul	eax, edx
	lea	edx, [esi+310h]
	push	eax
	lodsd
	add	edx, eax
	lodsd
	add	edx, eax
	lodsd
	add	edx, eax
	lodsd
	lea	esi, [edx+eax]

	mov	edi, [@@DB]
	add	edi, [@@A]
	dec	edi
	xor	ebx, ebx
@@1:	call	@@3
	jc	@@1f
	xor	eax, eax
	xor	edx, edx
	call	@@3
	jnc	@@1a
	lea	ecx, [eax+3]
	call	@@3
	jc	@@1c
	call	@@5
	not	eax
	add	eax, 8
	jmp	@@1d

@@1a:	call	@@3
	jnc	@@1b
	call	@@3
	adc	eax, 1
	jmp	@@1c

@@1b:	lea	ecx, [eax+2]
	call	@@5
	add	eax, 3
@@1c:	not	eax
	mov	cl, 4
	imul	eax, [@@W]
	push	eax
	call	@@5
	pop	edx
@@1d:	movsx	eax, byte ptr [_limejan_sys+eax]
	add	edx, eax
	push	edx
	call	@@4
	lea	ecx, [eax+2]
	pop	edx
	sub	[@@DC], ecx
	jb	@@9
	imul	edx, [@@A]
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
@@1e:	mov	al, [edi+edx]
	mov	[edi], al
	add	edi, [@@A]
	dec	ecx
	jne	@@1e
	jmp	@@1h

@@1f:	dec	[@@DC]
	js	@@9
	mov	al, 1
@@1g:	call	@@3
	adc	al, al
	jnc	@@1g
	mov	[edi], al
	add	edi, [@@A]
@@1h:	cmp	[@@DC], 0
	jne	@@1	
	xor	esi, esi
@@9:	neg	esi
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

@@4:	xor	edx, edx
	lea	ecx, [edx+1]
	call	@@3	; 1, 0
	jc	@@5
	mov	dl, 2
	inc	ecx
	call	@@3	; 2, 2
	jc	@@5
	mov	dl, 6
	inc	ecx
	call	@@3	; 3, 6
	jc	@@5
	mov	dl, 0Eh
	mov	cl, 6
	call	@@3	; 6, 0Eh
	jc	@@5
	mov	dl, 4Eh
	mov	cl, 8
	call	@@3	; 8, 4Eh
	jc	@@5
	mov	dh, 1
	mov	cl, 0Ah
@@5:	xor	eax, eax
@@5a:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@5a
	add	eax, edx
	ret
ENDP

@@RM1 PROC

@@DB = dword ptr [ebp+14h]
@@SB = dword ptr [ebp+18h]

@@H = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	edi, [@@DB]
	movzx	ebx, word ptr [edi-12h+0Eh]
	movzx	edx, word ptr [edi-12h+0Ch]
	push	ebx
@@1:	mov	esi, [@@SB]
	inc	[@@SB]
	mov	ecx, edx
@@2:	mov	al, [esi]
	add	esi, ebx
	add	edi, 3
	stosb
	dec	ecx
	jne	@@2
	dec	[@@H]
	jne	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

ENDP

