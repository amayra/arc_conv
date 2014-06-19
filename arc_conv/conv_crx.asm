
; "Princess Party", "Yaminabe Aries" *.crx
; Yaminabe Aries.exe
; 0042B950 unpack

; PURIPA.EXE
; 00402E4D transform

	dw _conv_crx-$-2
_arc_crx:
	ret
_conv_crx PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'xrc'
	jne	@@9
	sub	ebx, 14h
	jb	@@9
	mov	eax, [esi]
	sub	eax, 'GXRC'
	or	eax, [esi+4]
	je	@@1
@@9:	stc
	leave
	ret

@@1:	mov	eax, [esi+0Ch]
	sub	eax, 10001h
	shr	eax, 1
	jne	@@9
	mov	ecx, [esi+10h]
	lea	eax, [ecx*2+ecx]
	movzx	edi, word ptr [esi+8]
	movzx	edx, word ptr [esi+0Ah]
	jc	@@2
	sub	ebx, eax
	jb	@@9
	mov	[@@SC], ebx
	dec	ecx
	shr	ecx, 8
	jne	@@9
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 30h, edi, edx
	xchg	edi, eax
	mov	ecx, [esi+10h]
	mov	edx, [@@SC]
	mov	[edi+5], cx
	add	esi, 14h
	add	edi, 12h
@@1a:	lodsb
	inc	edi
	movsb
	stosb
	lodsb
	mov	[edi-3], al
	dec	ecx
	jne	@@1a
	call	@@Unpack, edi, ebx, esi, [@@SC]
	clc
	leave
	ret

@@2:	sub	ecx, 1
	jbe	@@3
	sub	ebx, eax
	jb	@@9
	mov	[@@SC], ebx
	shr	ecx, 8
	jne	@@9
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 30h, edi, edx
	xchg	edi, eax
	mov	ecx, [esi+10h]
	mov	edx, [@@SC]
	mov	[edi+5], cx
	add	esi, 14h
	add	edi, 12h
@@2a:	lodsb
	inc	edi
	movsb
	stosb
	lodsb
	mov	[edi-3], al
	dec	ecx
	jne	@@2a
	call	_zlib_unpack, edi, ebx, esi, [@@SC]
	clc
	leave
	ret

@@3:	add	ecx, 4
	push	ecx	; @@L0
	lea	ebx, [edi+1]
	imul	ebx, edx
	imul	ebx, ecx
	add	ecx, 20h-1
	call	_ArcTgaAlloc, ecx, edi, edx
	xchg	edi, eax
	call	_MemAlloc, ebx
	jc	@@9
	push	eax	; @@L1
	mov	ecx, [@@SC]
	add	esi, 14h
	sub	ecx, 14h
	call	_zlib_unpack, eax, ebx, esi, ecx
	mov	esi, [@@L1]
	mov	ebx, [@@L0]
	test	byte ptr [esi], NOT 4
	jne	@@3a
	mov	ecx, [edi+0Ch]
	add	edi, 12h
	call	@@5
@@3a:	call	_MemFree, [@@L1]
	clc
	leave
	ret

@@5 PROC
	push	ebp
	movzx	ebp, cx
	shr	ecx, 10h
	push	edi
@@1:	push	ecx
	xor	eax, eax
	xor	edx, edx
	lodsb
	dec	eax
	js	@@1a
	mov	ecx, ebp
	mov	edx, ebp
	je	@@1b
	dec	eax
	jne	@@1c
@@1a:	inc	edx
	mov	ecx, ebx
	rep	movsb
	mov	ecx, ebp
	dec	ecx
	je	@@8
@@1b:	call	@@5
	jmp	@@8

@@1c:	dec	eax
	jne	@@2
	dec	edx
	dec	ecx
	je	@@1d
	call	@@5
@@1d:	mov	ecx, ebx
	rep	movsb
@@8:	pop	ecx
	dec	ecx
	jne	@@1
	pop	edi
	cmp	ebx, 4
	jne	@@7b
	movzx	ecx, word ptr [edi-12h+0Eh]
	imul	ecx, ebp
@@7a:	mov	eax, [edi]
	not	al
	ror	eax, 8
	stosd
	dec	ecx
	jne	@@7a
@@7b:	clc
	pop	ebp
	ret

@@2:	dec	eax
	jne	@@9a
	mov	edx, ebx
	mov	ecx, ebp
	push	ebp
	imul	ebp, ebx
@@2a:	push	ecx
	push	edx
@@2b:	xor	edx, edx
	dec	ebp
	js	@@9
	lodsb
	dec	ecx
	je	@@2c
	test	ebp, ebp
	je	@@9
	cmp	al, [esi]
	jne	@@2c
	inc	esi
	sub	ebp, 2
	jb	@@9
	mov	dl, [esi]
	inc	esi
	sub	ecx, edx
	jb	@@9
@@2c:	mov	[edi], al
	add	edi, ebx
	dec	edx
	jns	@@2c
	test	ecx, ecx
	jne	@@2b
	pop	edx
	pop	ecx
	mov	eax, ebx
	inc	edi
	imul	eax, ecx
	sub	edi, eax
	dec	edx
	jne	@@2a
	pop	ebp
	sub	edi, ebx
	add	edi, eax
	jmp	@@8

@@9:	pop	ecx
	pop	ecx
	pop	ecx
@@9a:	pop	ecx
	pop	ecx
	stc
	pop	ebp
	ret

@@5:	imul	edx, ebx
	imul	ecx, ebx
	neg	edx
@@5a:	lodsb
	add	al, [edi+edx]
	stosb
	dec	ecx
	jne	@@5a
	ret
ENDP

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
	shr	ebx, 1
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@1a:	jnc	@@1b
	dec	[@@SC]
	js	@@9
	dec	[@@DC]
	js	@@9
	movsb
	jmp	@@1

@@1b:	xor	eax, eax
	dec	[@@SC]
	js	@@9
	lodsb
	mov	ecx, eax
	test	al, al
	jns	@@1e
	test	al, 40h
	je	@@1c
	dec	[@@SC]
	js	@@9
	shr	ecx, 2
	and	al, 3
	and	ecx, 0Fh
	mov	ah, al
	lodsb
	jmp	@@1g

@@1c:	shr	ecx, 5
	and	al, 1Fh
	jne	@@1d
	dec	[@@SC]
	js	@@9
	lodsb
@@1d:	and	ecx, 3
	jmp	@@1h

@@1e:	cmp	al, 7Fh
	jne	@@1f
	sub	[@@SC], 4
	jb	@@9
	lodsd
	movzx	ecx, ax
	shr	eax, 10h
	jmp	@@1h

@@1f:	sub	[@@SC], 2
	jb	@@9
	lodsw
@@1g:	inc	ecx
	inc	ecx
@@1h:	inc	ecx
	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
	neg	eax
	or	eax, 0FFFF0000h
	xchg	edx, eax
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jns	@@2b
@@2a:	mov	byte ptr [edi], 0
	inc	edi
	dec	ecx
	je	@@1
	inc	eax
	jne	@@2a
@@2b:	push	esi
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

ENDP