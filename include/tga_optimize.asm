
	.data

_tga_flags	db 2,0,0,0

; 0 - no filter
; 1 - filter 0xFF
; 2 - filter 0x00
; 3 - no alpha

	.code

_tga_alpha_mode PROC
	jc	@@9
	cmp	eax, 4
	jae	@@9
	mov	[_tga_flags], al
@@9:	ret
ENDP

_tga_optimize PROC

@@SB = dword ptr [ebp+14h]
@@L0 = dword ptr [ebp-4]
@@SC = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@SB]
	movzx	eax, word ptr [esi+0Ch]
	movzx	ebx, word ptr [esi+0Eh]
	movzx	ecx, byte ptr [esi+10h]
	imul	ebx, eax
	mov	eax, ecx
	shr	ecx, 3
	movzx	edi, byte ptr [esi]
	imul	ecx, ebx
	add	edi, 12h
	add	ecx, edi
	push	edi
	push	ecx
	cmp	al, 8
	je	@@3
	cmp	al, 18h
	je	@@1a
	cmp	al, 20h
	jne	@@9
	xor	eax, eax
	mov	ecx, ebx
	mov	dl, [_tga_flags]
	call	@@4
	jne	@@2
	and	byte ptr [edx+11h], 0F0h
	mov	byte ptr [edx+10h], 18h
	sub	edi, [@@SB]
	mov	[@@SC], edi
@@1a:	mov	esi, [@@SB]
	add	esi, [@@L0]
	call	_tga24_pack, 0, 0, esi, ebx
	lea	ecx, [ebx*2+ebx]
	cmp	eax, ecx
	jae	@@9
	xchg	edi, eax
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	call	_tga24_pack, edi, eax, esi, ebx
	jmp	@@2a

@@9:	mov	edi, [@@SB]
	mov	ebx, [@@SC]
	mov	esi, offset @@sign	; size = 0x12
	add	edi, ebx
	add	ebx, 1Ah
	xor	eax, eax
	stosd
	stosd
	movsd
	movsd
	movsd
	movsd
	movsw
	xchg	eax, ebx
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4

@@3:	movzx	ecx, word ptr [esi+5]
	movzx	eax, byte ptr [esi+7]
	mov	edx, ecx
	shr	eax, 3
	imul	edx, eax
	add	edx, [@@L0]
	push	edx
	add	edx, ebx
	mov	[@@SC], edx
	cmp	al, 4
	jne	@@3a
	test	ecx, ecx
	je	@@3a
	mov	dl, 2
	call	@@4
	jne	@@3a
	mov	byte ptr [edx+7], 18h
	mov	ecx, ebx
	rep	movsb
	sub	edi, [@@SB]
	mov	[@@SC], edi
	movzx	ecx, word ptr [edx+5]
	sub	[esp], ecx
@@3a:	pop	esi
	add	esi, [@@SB]
	call	_tga8_pack, 0, 0, esi, ebx
	cmp	eax, ebx
	jae	@@9
	xchg	edi, eax
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	call	_tga8_pack, edi, eax, esi, ebx
	jmp	@@2a

@@2:	call	_tga32_pack, 0, 0, esi, ebx
	mov	ecx, ebx
	shl	ecx, 2
	cmp	eax, ecx
	jae	@@9
	xchg	edi, eax
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	call	_tga32_pack, edi, eax, esi, ebx
@@2a:	mov	edx, [@@SB]
	xchg	ecx, eax
	add	byte ptr [edx+2], 8
	push	edi
	xchg	esi, edi
	rep	movsb
	call	_MemFree
	sub	edi, [@@SB]
	mov	[@@SC], edi
	jmp	@@9

@@4 PROC
	xor	eax, eax
	cmp	dl, 2
	ja	@@2a
	je	@@2b
	dec	eax
	test	dl, dl
	je	@@2a
	mov	ah, 0
@@2b:	push	ecx
	mov	edi, [ebp-4]
	add	edi, esi
@@1:	mov	dl, [edi+3]
	or	al, dl
	inc	edx
	or	ah, dl
	add	edi, 4
	dec	ecx
	jne	@@1
	pop	ecx
@@2a:	mov	edx, esi
	add	esi, [ebp-4]
	test	al, al
	je	@@4b
	test	ah, ah
	jne	@@4d
@@4b:	mov	edi, esi
@@4c:	movsb
	movsb
	movsb
	inc	esi
	dec	ecx
	jne	@@4c
@@4d:	ret
ENDP

@@sign	db 'TRUEVISION-XFILE.', 0
ENDP

_tga8_pack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ecx, [@@SC]
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	test	ecx, ecx
	je	@@9
@@1:	xor	edx, edx
@@1a:	xor	ebx, ebx
	mov	al, [esi]
@@1b:	inc	esi
	inc	ebx
	dec	ecx
	je	@@1c
	cmp	[esi], al
	je	@@1b
@@1c:	cmp	ebx, 3
	jae	@@1d
	add	edx, ebx
	test	ecx, ecx
	jne	@@1a
	xor	ebx, ebx
@@1d:	cmp	[@@DB], 0
	je	@@4
	test	edx, edx
	je	@@3
	sub	esi, edx
	push	ecx
	sub	esi, ebx
@@2:	mov	eax, 80h
	sub	edx, eax
	jae	$+6
	add	eax, edx
	xor	edx, edx
	mov	ecx, eax
	dec	eax
	stosb
	rep	movsb
	test	edx, edx
	jne	@@2
	pop	ecx
	test	ebx, ebx
	je	@@9
	add	esi, ebx
@@3:	mov	eax, 80h
	sub	ebx, eax
	jae	$+6
	add	eax, ebx
	xor	ebx, ebx
	add	al, 7Fh
	dec	esi
	stosb
	movsb
	test	ebx, ebx
	jne	@@3
@@7:	test	ecx, ecx
	jne	@@1
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@4:	lea	eax, [edx+7Fh]
	lea	ebx, [ebx+7Fh]
	shr	eax, 7
	shr	ebx, 7
	add	eax, edx
	lea	edi, [edi+ebx*2]
	add	edi, eax
	jmp	@@7
ENDP

_tga24_pack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ecx, [@@SC]
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	test	ecx, ecx
	je	@@9
@@1:	push	edi
	xor	edx, edx
@@1a:	xor	ebx, ebx
	movzx	edi, word ptr [esi]
	movzx	eax, byte ptr [esi+2]
@@1b:	add	esi, 3
	inc	ebx
	dec	ecx
	je	@@1c
	cmp	[esi], di
	jne	@@1c
	cmp	[esi+2], al
	je	@@1b
@@1c:	cmp	ebx, 2
	jae	@@1d
	inc	edx
	test	ecx, ecx
	jne	@@1a
	dec	ebx
@@1d:	pop	edi
	cmp	[@@DB], 0
	je	@@4
	test	edx, edx
	je	@@3
	lea	eax, [edx+ebx]
	lea	eax, [eax*2+eax]
	push	ecx
	sub	esi, eax
@@2:	mov	eax, 80h
	sub	edx, eax
	jae	$+6
	add	eax, edx
	xor	edx, edx
	lea	ecx, [eax*2+eax]
	dec	eax
	stosb
	rep	movsb
	test	edx, edx
	jne	@@2
	pop	ecx
	test	ebx, ebx
	je	@@9
	lea	eax, [ebx*2+ebx]
	add	esi, eax
@@3:	mov	eax, 80h
	sub	ebx, eax
	jae	$+6
	add	eax, ebx
	xor	ebx, ebx
	add	al, 7Fh
	sub	esi, 3
	stosb
	movsb
	movsb
	movsb
	test	ebx, ebx
	jne	@@3
@@7:	test	ecx, ecx
	jne	@@1
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@4:	lea	eax, [edx+7Fh]
	lea	ebx, [ebx+7Fh]
	shr	eax, 7
	shr	ebx, 7
	lea	edx, [edx*2+edx]
	add	edi, eax
	lea	edx, [edx+ebx*4]
	add	edi, edx
	jmp	@@7
ENDP

_tga32_pack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ecx, [@@SC]
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	test	ecx, ecx
	je	@@9
@@1:	xor	edx, edx
@@1a:	xor	ebx, ebx
	mov	eax, [esi]
@@1b:	add	esi, 4
	inc	ebx
	dec	ecx
	je	@@1c
	cmp	[esi], eax
	je	@@1b
@@1c:	cmp	ebx, 2
	jae	@@1d
	inc	edx
	test	ecx, ecx
	jne	@@1a
	dec	ebx
@@1d:	cmp	[@@DB], 0
	je	@@4
	test	edx, edx
	je	@@3
	lea	eax, [edx+ebx]
	shl	eax, 2
	push	ecx
	sub	esi, eax
@@2:	mov	eax, 80h
	sub	edx, eax
	jae	$+6
	add	eax, edx
	xor	edx, edx
	mov	ecx, eax
	dec	eax
	stosb
	rep	movsd
	test	edx, edx
	jne	@@2
	pop	ecx
	test	ebx, ebx
	je	@@9
	lea	esi, [esi+ebx*4]
@@3:	mov	eax, 80h
	sub	ebx, eax
	jae	$+6
	add	eax, ebx
	xor	ebx, ebx
	add	al, 7Fh
	sub	esi, 4
	stosb
	movsd
	test	ebx, ebx
	jne	@@3
@@7:	test	ecx, ecx
	jne	@@1
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@4:	lea	eax, [edx+7Fh]
	lea	ebx, [ebx+7Fh]
	shr	eax, 7
	shr	ebx, 7
	lea	edi, [edi+edx*4]
	lea	ebx, [ebx*4+ebx]
	add	edi, eax
	add	edi, ebx
	jmp	@@7
ENDP
