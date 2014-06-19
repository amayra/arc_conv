
; "Neko Kawaigari", "Tomoyo After", "Planetarian" G00\*.g00
; Planetarian\RealLive.exe
; 00403A00 type0_unpack
; 00403920 type2_unpack
; 00523570 image32_copy

	dw _conv_g00-$-2
_arc_g00:
	ret
_conv_g00 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]
@@L2 = dword ptr [ebp-0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, '00g'
	jne	@@9
	cmp	ebx, 0Dh
	jb	@@9
	mov	al, [esi]
	test	al, al
	je	@@1
	cmp	al, 2
	je	@@2
@@9:	stc
	leave
	ret

@@1:	lea	ecx, [ebx-5]
	movzx	edi, word ptr [esi+1]
	movzx	edx, word ptr [esi+3]
	mov	ebx, edi
	imul	ebx, edx
	mov	eax, [esi+9]
	sub	ecx, [esi+5]
	ror	eax, 2
	sub	eax, ebx
	or	eax, ecx
	jne	@@9
	call	_ArcTgaAlloc, 22h, edi, edx
	xchg	edi, eax
	mov	ecx, [esi+5]
	add	esi, 0Dh
	sub	ecx, 8
	lea	edx, [edi+12h]
	call	@@Unp0, edx, ebx, esi, ecx
	clc
	leave
	ret

; db 2
; dw width, height
; dd image_count
; dd x, y, w-1, h-1, 0, 0	; * count
; dd data_size
; dd unp_size

@@2:	mov	ecx, [esi+5]
	lea	eax, [ecx-1]
	imul	ecx, 18h
	shr	eax, 10h
	jne	@@9
	add	ecx, 11h
	sub	ebx, ecx
	jb	@@9
	movzx	edi, word ptr [esi+1]
	movzx	edx, word ptr [esi+3]
	add	esi, ecx
	mov	eax, [esi-8]
	sub	eax, 8
	jb	@@9
	sub	ebx, eax
	jb	@@9
	xchg	ebx, eax
	call	_ArcTgaAlloc, 23h, edi, edx
	add	eax, 12h
	push	eax	; @@L0

	mov	edi, [esi-4]
	call	_MemAlloc, edi
	jc	@@9
	xchg	esi, eax
	call	_reallive_unpack, esi, eax, eax, ebx
	xchg	ebx, eax
	push	esi	; @@L1
	mov	[@@SC], ebx

	call	_ArcLocal, 0
	xchg	edi, eax
	jnc	@@2c
	call	_ArcParamNum, 0
	db 'debug', 0
	mov	[edi], eax
@@2c:	cmp	dword ptr [edi], 0
	je	@@2d
	call	_ArcSetExt, 'nib'
	call	_ArcData, esi, ebx
@@2d:
	sub	ebx, 4
	jb	@@9
	lodsd
	lea	ecx, [eax-1]
	shr	ecx, 10h
	jne	@@9
	mov	ecx, eax
	shl	ecx, 3
	sub	ebx, ecx
	jb	@@9
	add	ecx, 4
	cmp	ecx, [esi]
	jne	@@9
	push	eax	; @@L2
	xor	ebx, ebx
@@2a:	mov	esi, [@@L1]
	mov	edx, [esi+ebx*8+4]
	mov	eax, [esi+ebx*8+8]
	lea	ecx, [ebx*2+ebx]
	push	ebx
	mov	ebx, [@@SC]
	add	esi, edx
	sub	ebx, edx
	jb	@@2b
	cmp	ebx, eax
	jb	@@2b
	xchg	ebx, eax
	mov	eax, [@@SB]
	lea	ecx, [eax+9+ecx*8]
	call	@@Unpack, [@@L0], 0, esi, ebx, dword ptr [ecx], dword ptr [ecx+4]
	pop	ebx
	inc	ebx
	cmp	ebx, [@@L2]
	jb	@@2a
@@2b:	clc
	leave
	ret

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@X1 = dword ptr [ebp+24h]
@@Y1 = dword ptr [ebp+28h]

@@W = dword ptr [ebp-4]
@@H = dword ptr [ebp-8]
@@X2 = dword ptr [ebp-0Ch]
@@Y2 = dword ptr [ebp-10h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
	sub	[@@SC], 74h
	jb	@@9
	movzx	eax, word ptr [edi-12h+0Ch]
	movzx	edx, word ptr [edi-12h+0Eh]
	cmp	[@@X1], eax
	jae	@@9
	cmp	[@@Y1], edx
	jae	@@9
	push	eax	; @@W
	push	edx	; @@H
	push	ecx
	push	ecx
	add	esi, 74h
@@1:	sub	[@@SC], 5Ch
	jb	@@9
	movzx	edi, word ptr [esi+2]
	movzx	ecx, word ptr [esi]
	add	edi, [@@Y1]
	add	ecx, [@@X1]
	mov	ebx, edi
	imul	edi, [@@W]
	movzx	edx, word ptr [esi+8]
	movzx	eax, word ptr [esi+6]
	add	edi, ecx
	add	ecx, eax
	add	ebx, edx
	cmp	[@@W], ecx
	jb	@@9
	cmp	[@@H], ebx
	jb	@@9
	mov	[@@Y2], edx
	mov	[@@X2], eax
	imul	eax, edx
	mov	edx, [@@DB]
	shl	eax, 2
	je	@@9
	lea	edi, [edx+edi*4]
	sub	[@@SC], eax
	jb	@@9
;	mov	al, [esi+4]
	add	esi, 5Ch
;	test	al, al
;	jne	@@3a
@@2a:	mov	ecx, [@@X2]
	push	edi
	rep	movsd
	pop	edi
	mov	eax, [@@W]
	lea	edi, [edi+eax*4]
	dec	[@@Y2]
	jne	@@2a
	jmp	@@1

if 0
@@3a:	mov	ecx, [@@X2]
	push	edi
@@3b:	mov	al, [esi+3]
	test	al, al
	je	@@3e
	cmp	al, 0FFh
	je	@@3c
	push	ecx
	movzx	ecx, al
	call	@@4
	call	@@4
	call	@@4
	pop	ecx
	inc	esi
	inc	edi
	jmp	@@3d
@@3e:	add	esi, 4
	add	edi, 4
	jmp	@@3d
@@3c:	movsd
@@3d:	dec	ecx
	jne	@@3b
	pop	edi
	mov	eax, [@@W]
	lea	edi, [edi+eax*4]
	dec	[@@Y2]
	jne	@@3a
	jmp	@@1
endif

@@7:	xor	esi, esi
@@9:	xor	eax, eax
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	18h

if 0
@@4:	movzx	ebx, byte ptr [esi]
	movzx	eax, byte ptr [edi]
	inc	esi
	sub	ebx, eax
	imul	ebx, ecx
	mov	eax, 80808081h	; idiv 0xFF
	imul	ebx
	add	edx, ebx
	sar	edx, 7
	mov	eax, edx
	shr	eax, 1Fh
	add	eax, edx
	add	[edi], al
	inc	edi
	ret
endif
ENDP

@@Unp0 PROC

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
	sub	[@@SC], 3
	jb	@@9
	movsb
	movsb
	movsb
	jmp	@@1

@@1b:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
	mov	ecx, edx
	shr	edx, 4
	and	ecx, 0Fh
	sub	[@@DC], ecx
	jb	@@9
	inc	ecx
	neg	edx
	lea	edx, [edx*2+edx]
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	ecx, [ecx*2+ecx]
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
ENDP

ENDP