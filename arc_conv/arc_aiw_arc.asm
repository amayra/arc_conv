
; "Shusaku" *.arc
; AIWIN.EXE .00414BAA

; 00,02 = x,y
; 04,06 = w,h
; 08 = reverse(0,1)
; 0A = pal(size=0xEC*3)

	dw _conv_aiw_arc-$-2
_arc_aiw_arc PROC

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
	jne	@@9
	mov	[@@N], ebx
	imul	ebx, 18h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	byte ptr [esi], 0
	je	@@9
	add	ebx, 4
	cmp	[esi+10h], ebx
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 10h
	and	[@@D], 0
	mov	ebx, [esi+14h]
	call	_FileSeek, [@@S], dword ptr [esi+10h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 18h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_aiw_arc PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]
@@L0 = dword ptr [ebp-4]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'xpg'
	jne	@@9
	sub	ebx, 2CEh
	jb	@@9
	movzx	eax, word ptr [esi+8]
	shr	eax, 1
	je	@@1
@@9:	stc
	leave
	ret

@@1:	mov	[@@SC], ebx
	movzx	edi, word ptr [esi+4]
	movzx	edx, word ptr [esi+6]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 30h, edi, edx
	xchg	edi, eax
	xor	ecx, ecx
	mov	eax, [esi]
	mov	cl, 0ECh
	mov	[edi+8], eax
	mov	[edi+5], cx
	add	edi, 12h
	movzx	edx, word ptr [esi+8]
	push	dword ptr [esi+4]	; @@L0
	add	esi, 0Ah
@@1a:	lodsb
	inc	edi
	movsb
	stosb
	lodsb
	mov	[edi-3], al
	dec	ecx
	jne	@@1a
	dec	edx
	je	@@1b
	call	@@Unpack, edi, ebx, esi, [@@SC]
	clc
	leave
	ret

@@1b:	call	_MemAlloc, ebx
	jc	@@9
	mov	edx, [@@L0]
	xchg	esi, eax
	rol	edx, 10h
	call	@@Unpack, esi, ebx, eax, [@@SC], edx
	pop	ecx
	movzx	ebx, cx
	shr	ecx, 10h
	push	esi
	lea	edx, [ebx-1]
@@1c:	push	ecx
	push	edi
@@1d:	movsb
	add	edi, edx
	dec	ecx
	jne	@@1d
	pop	edi
	pop	ecx
	inc	edi
	dec	ebx
	jne	@@1c
	call	_MemFree
	clc
	leave
	ret

@@Unpack PROC

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
	xor	ebx, ebx
	xor	ecx, ecx
@@2:	movzx	eax, word ptr [@@L0]
	mov	[@@DC], eax
@@1:	cmp	[@@DC], 0
	je	@@7
	call	@@3
	jnc	@@1a
	mov	cl, 8
	call	@@4
	sub	al, 0Ah
	cmp	al, 0ECh
	jae	@@9
	stosb
	dec	[@@DC]
	jmp	@@1

@@1a:	xor	edx, edx
	call	@@3
	jnc	@@1c
	call	@@3
	jc	@@1b
	mov	cl, 3
	call	@@4
	movsx	edx, [@@T+9+eax]
	jmp	@@1f
@@1b:	inc	edx
	jmp	@@1e
@@1c:	call	@@3
	jnc	@@1d
	call	@@3
	adc	edx, 2
	jmp	@@1e
@@1d:	mov	cl, 2
	call	@@4
	lea	edx, [eax+4]
@@1e:	movzx	eax, word ptr [@@L0]
	imul	edx, eax
	mov	cl, 4
	call	@@4
	movsx	eax, [@@T+eax]
	neg	edx
	sub	edx, eax
@@1f:	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	call	@@5
	xchg	ecx, eax
	sub	[@@DC], ecx
	jb	@@9
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@7:	dec	word ptr [@@L0+2]
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

@@3:	shl	bl, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@3a:	ret

@@4:	xor	eax, eax
@@4a:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@4a
	ret

@@5:	call	@@3
	jnc	@@5a
	call	@@3
	sbb	eax, eax
	neg	eax
	add	eax, 2
	ret
@@5a:	call	@@3
	jnc	@@5b
	mov	cl, 2
	call	@@4
	add	eax, 4
	ret
@@5b:	call	@@3
	jnc	@@5c
	mov	cl, 3
	call	@@4
	add	eax, 8
	ret
@@5c:	call	@@3
	jnc	@@5d
	mov	cl, 6
	call	@@4
	add	eax, 10h
	ret
@@5d:	call	@@3
	jnc	@@5e
	mov	cl, 8
	call	@@4
	add	eax, 50h
	ret
@@5e:	mov	cl, 0Ah
	call	@@4
	add	eax, 150h
	ret

@@T	db 14h,10h,0Ch,8,6,4,2,1,0,-1,-2,-4,-6,-8,-0Ch,-10h,-14h
ENDP

ENDP