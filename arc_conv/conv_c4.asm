
; "Yarasete! Teacher" GDS\*.GD
; C4.EXE 00401560

	dw _conv_c4-$-2
_arc_c4:
	ret
_conv_c4 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'dg'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 6
	jb	@@9
	cmp	word ptr [esi], 'DG'
	jne	@@9
	cmp	byte ptr [esi+3], 1Ah
	jne	@@9
	mov	al, [esi+2]
	add	esi, 6
	mov	ecx, 2340h
	mov	edi, 640
	mov	edx, 480
	cmp	al, 32h
	je	@@1c
	cmp	al, 33h
	jne	@@9
	mov	ecx, 3750h
	mov	edi, 800
	mov	edx, 600
@@1c:	sub	ebx, ecx
	jb	@@9
	add	esi, ecx
	cmp	byte ptr [esi-1], 1Ah
	jne	@@9
	mov	[@@SC], ebx
	mov	ebx, edi
	imul	ebx, edx
	lea	ebx, [ebx*2+ebx]
	call	_ArcTgaAlloc, 2, edi, edx
	lea	edi, [eax+12h]
	mov	al, [esi-2]
	cmp	al, 'l'
	je	@@1a
	cmp	al, 'p'
	je	@@1b
	cmp	al, 'b'
	jne	@@9
	call	_null_unpack, edi, ebx, esi, [@@SC]
	clc
	leave
	ret

@@1a:	call	@@UnpL, edi, ebx, esi, [@@SC]
	clc
	leave
	ret

@@1b:	call	@@UnpP, edi, ebx, esi, [@@SC]
	clc
	leave
	ret

@@UnpL PROC

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
@@1:	call	@@3
	jnc	@@1a
	push	8
	pop	ecx
	call	@@5
	dec	[@@DC]
	js	@@9
	stosb
	jmp	@@1

@@1a:	push	10h
	pop	ecx
	call	@@5
	test	eax, eax
	xchg	edx, eax
	je	@@7
	push	4
	pop	ecx
	call	@@5
	lea	ecx, [eax+3]
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	dec	edx
	sub	eax, [@@DB]
	sub	edx, eax
	or	edx, -10000h
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
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

@@5:	xor	eax, eax
@@5a:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@5a
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
ENDP

@@UnpP PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	ecx, [@@DC]
	movzx	edx, word ptr [edi-12h+0Ch]
	lea	edx, [edx*2+edx]
	sub	edx, 3
	push	0		; @@L0
	push	edx
	or	eax, -1
	rep	stosb

	xor	ebx, ebx
@@1:	push	2
	pop	ecx
	call	@@5
	mov	cl, 2
	cmp	al, 2
	jb	@@1b
	jne	@@1a
	call	@@5
	add	al, 2
	jmp	@@1b

@@1a:	inc	ecx
	cmp	ecx, 18h
	jae	@@7
	call	@@3
	jc	@@1a
	xor	eax, eax
	inc	eax
	call	@@5a
	sub	eax, 2
@@1b:
	mov	edi, [@@L0]
	lea	eax, [eax*2+eax]
	add	edi, eax
	lea	edx, [edi+3]
	cmp	edi, [@@DC]
	jae	@@7
	add	edi, [@@DB]
	mov	[@@L0], edx
	push	8
	pop	ecx
	call	@@5
	stosb
	push	8
	pop	ecx
	call	@@5
	stosb
	push	8
	pop	ecx
	call	@@5
	stosb
	call	@@3
	jnc	@@1

@@2:	push	2
	pop	ecx
	call	@@5
	test	eax, eax
	lea	eax, [eax*2+eax-6]
	jne	@@2a
	call	@@3
	jnc	@@1
	push	6
	pop	eax
	call	@@3
	jc	$+4
	neg	eax
@@2a:	add	eax, [@@L1]
	push	esi
	lea	esi, [edi-3]
	add	edi, eax
	mov	eax, edi
	sub	eax, [@@DB]
	cmp	eax, [@@DC]
	jae	@@7
	movsb
	movsb
	movsb
	pop	esi
	jmp	@@2

@@7:	push	0
	mov	edi, [@@DB]
	mov	esi, esp
	movzx	edx, word ptr [edi-12h+0Ch]
	movzx	ecx, word ptr [edi-12h+0Eh]
	mov	al, 0FFh
	imul	ecx, edx
@@7a:	cmp	[edi], al
	jne	@@7b
	cmp	[edi+1], al
	jne	@@7b
	cmp	[edi+2], al
	jne	@@7b
	movsb
	movsb
	movsb
	jmp	@@7c
@@7b:	mov	esi, edi
	add	edi, 3
@@7c:	dec	ecx
	jne	@@7a
@@9:	sub	edi, [@@DB]
	xchg	eax, edi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@5:	xor	eax, eax
@@5a:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@5a
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
ENDP

ENDP
