
; "Xchange", "Tokimeki Check in!" *.zbm

; xc3.exe
; 00407590 sce_decrypt

	dw _conv_zbm-$-2
_arc_zbm:
	ret
_conv_zbm PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'ecs'
	je	@@4
	cmp	eax, 'pwc'
	je	@@3
	cmp	eax, 'lwc'
	je	@@2
	cmp	eax, 'mbz'
	jne	@@9
	cmp	ebx, 0Eh+4
	jb	@@9
	sub	ebx, 0Eh
	mov	eax, [esi+0Eh]
	mov	ecx, [esi+0Ah]
	cmp	dword ptr [esi], 'DDZS'
	je	@@1
@@9:	stc
	leave
	ret

@@4:	call	@@SCE, esi, ebx
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@1:	and	eax, 0FFFF03h
	cmp	eax, 0B2BD03h
	jne	@@9
	cmp	ecx, 64h
	jb	@@9
	call	_MemAlloc, ecx
	jc	@@9
	xchg	edi, eax

	add	esi, 0Eh
	call	@@Unpack, edi, dword ptr [esi-4], esi, ebx
	xchg	ebx, eax

	mov	ecx, 64h/4
@@1a:	not	dword ptr [edi+ecx*4-4]
	dec	ecx
	jne	@@1a

	push	'pmb'
@@1b:	call	_ArcSetExt
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

@@8:	call	_MemFree, esi
	jmp	@@9

@@2:	cmp	ebx, 0Eh+4
	jb	@@9
	sub	ebx, 0Eh
	mov	eax, [esi+0Eh]
	mov	ecx, [esi+0Ah]
	cmp	dword ptr [esi], 'DDZS'
	jne	@@9
	cmp	eax, 0647763FFh
	jne	@@9
	cmp	ecx, 38h
	jb	@@9
	call	_MemAlloc, ecx
	jc	@@9
	xchg	edi, eax

	add	esi, 0Eh
	call	@@Unpack, edi, dword ptr [esi-4], esi, ebx
	xchg	ebx, eax
	mov	esi, edi
	push	edi	; @@L0]
	mov	edi, offset @@T
	push	1Dh
	pop	ecx
	push	esi
	repe	cmpsb
	pop	esi
	jne	@@8
	xchg	eax, ebx

	movzx	ecx, byte ptr [esi+34h]
	mov	edi, [esi+2Ch]
	mov	edx, [esi+30h]
	add	ecx, 259Ah
	add	edi, ecx
	add	edx, ecx
	mov	ebx, edi
	imul	ebx, edx
	lea	ecx, [ebx+ebx+38h]
	cmp	eax, ecx
	jb	@@8
	call	_ArcTgaAlloc, 40+3, edi, edx
	jc	@@8
	xchg	edi, eax
	add	esi, 38h
	add	edi, 12h
@@2a:	; 1555
	movzx	eax, word ptr [esi]
	add	esi, 2
	ror	eax, 10
	shl	al, 3
	sbb	ah, ah
	rol	eax, 16
	shr	ax, 3
	shl	ah, 3
	mov	edx, 0E0E0E0E0h
	and	edx, eax
	shr	edx, 5
	or	eax, edx
	mov	[edi], eax
	add	edi, 4
	dec	ebx
	jne	@@2a
	call	_MemFree, [@@L0]
	clc
	leave
	ret

@@T	db 'cwd format  - version 1.00 -', 0

@@3:	sub	ebx, 19h
	jb	@@9
	lodsd
	cmp	eax, 'PDWC'
	jne	@@9
	lea	eax, [ebx+35h]
	call	_MemAlloc, eax
	jc	@@9
	push	eax
	xchg	edi, eax

	mov	eax, 0474E5089h
	stosd
	mov	eax, 00A1A0A0Dh
	stosd
	mov	eax, 00D000000h
	stosd
	mov	eax, 'RDHI'
	stosd
	push	15h
	pop	ecx
	rep	movsb
	mov	eax, 'TADI'
	stosd
	mov	ecx, ebx
	rep	movsb
	xchg	eax, ecx
	stosd
	mov	eax, 'DNEI'
	stosd
	mov	eax, 0826042AEh
	stosd
	pop	edi
	add	ebx, 35h
	push	'gnp'
	jmp	@@1b

@@PNG	db 89h,'PNG',0Dh,0Ah,1Ah,0Ah,0,0,0,0Dh,'IHDR'

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
	dec	[@@SC]
	js	@@9
	movsb
	jmp	@@1

@@1b:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
	mov	cl, dh
	shr	dh, 4
	and	ecx, 0Fh
	add	ecx, 2
	sub	[@@DC], ecx
	jb	@@9
	inc	ecx
	mov	eax, edi
	sub	eax, [@@DB]
	sub	edx, eax
	add	edx, 10h
	or	edx, -1000h
	add	eax, edx
	jns	@@2b
@@2a:	mov	byte ptr [edi], 0
	inc	edi
	dec	ecx
	je	@@1
	inc	eax
	jne	@@2a
@@2b:	lea	eax, [edi+edx]
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

@@SCE PROC

@@D = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	xor	ebx, ebx
	xor	edx, edx
	cmp	[@@C], ebx
	je	@@9
	lea	ecx, [edx+12h]
	mov	edi, [@@D]
	xor	esi, esi
@@1:	cmp	edx, 12h
	sbb	eax, eax
	and	edx, eax
	mov	eax, esi
	and	eax, ebx
	or	al, [@@T+edx]
	xor	[edi], al
	inc	edi
	test	edx, edx
	lea	edx, [edx+1]
	jne	@@2
	lea	eax, [esi+ebx]
	inc	esi
	xor	edx, edx
	div	ecx
	mov	bl, [@@T+edx]
	lea	eax, [edi+ebx]
	sub	eax, [@@D]
	xor	edx, edx
	div	ecx
@@2:	dec	[@@C]
	jne	@@1
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@T	db 'crowd script yeah '
ENDP

ENDP