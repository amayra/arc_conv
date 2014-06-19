
; "For Elise", "Mukuro", "Toubou", "Air" PDT\*.PDT

	dw _conv_pdt-$-2
_arc_pdt:
	ret
_conv_pdt PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'tdp'
	jne	@@9
	mov	ecx, ebx
	sub	ebx, 20h
	jb	@@9
	mov	eax, [esi]
	mov	edx, [esi+4]
	sub	ecx, [esi+8]
	sub	eax, '1TDP'
	sub	edx, 30h
	or	eax, edx
	or	eax, ecx
	je	@@1
@@9:	stc
	leave
	ret

@@1:	mov	[@@SC], ebx
	mov	edi, [esi+0Ch]
	mov	edx, [esi+10h]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 22h, edi, edx
	xchg	edi, eax
	lea	ecx, [esi+20h]
	add	edi, 12h
	call	@@Unpack, edi, ebx, ecx, [@@SC]
	clc
	leave
	ret

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
@@1:	cmp	[@@DC], 0
	je	@@7
	shl	bl, 1
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@1a:	jnc	@@1b
	sub	[@@SC], 3
	jb	@@9
	dec	[@@DC]
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
	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
	not	edx
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
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

ENDP