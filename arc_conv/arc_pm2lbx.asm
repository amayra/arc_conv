
; "Princess Maker 2" *.lbx

	dw _conv_pm2lbx-$-2
_arc_pm2lbx PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+8, 0
	call	_FileSeek, [@@S], -6, 2
	jc	@@9a
	xchg	edi, eax
	mov	esi, esp
	call	_FileRead, [@@S], esi, 6
	jc	@@9a
	movzx	ebx, word ptr [esi]
	test	ebx, ebx
	je	@@9a
	mov	[@@N], ebx
	imul	ebx, 14h
	sub	edi, ebx
	jb	@@9a
	cmp	[esi+2], edi
	jne	@@9a
	call	_FileSeek, [@@S], edi, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	push	0Ch
	pop	ecx
@@1b:	cmp	byte ptr [esi+ecx-1], 20h
	jne	@@1c
	dec	ecx
	jne	@@1b
@@1c:	call	_ArcName, esi, ecx

	mov	ebx, [esi+10h]
	and	[@@D], 0
	call	_FileSeek, [@@S], dword ptr [esi+0Ch], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
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

_conv_pm2lbx PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-10h]
@@L1 = dword ptr [ebp-18h]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'txt'
	je	@@5
	cmp	eax, '1tp'
	je	@@1
@@9:	stc
	leave
	ret

@@5:	sub	ebx, 2
	jbe	@@9
	lodsw
	cmp	ax, 401h
	jne	@@9
	xor	ecx, ecx
	push	04C79h
	push	06CB4A213h
	mov	edx, esi
	mov	edi, ebx
@@5a:	mov	al, [esp+ecx]
	sub	[edx], al
	inc	edx
	inc	ecx
	cmp	ecx, 6
	sbb	eax, eax
	and	ecx, eax
	dec	edi
	jne	@@5a
	call	@@Unpack, 0, -1, esi, ebx
	test	eax, eax
	je	@@9
	xchg	edi, eax
	test	edx, edx
	jne	@@9
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	call	@@Unpack, edi, eax, esi, ebx
	test	eax, eax
	xchg	ebx, eax
	je	@@5f
	cmp	byte ptr [edi+ebx-1], 1
	sbb	ebx, 0
	je	@@5f
	cmp	byte ptr [edi+ebx-1], 0Bh
	jne	@@5b
	dec	ebx
	je	@@5f
@@5b:
	mov	esi, edi
	mov	ecx, ebx
	mov	edx, ebx
@@5c:	lodsb
	cmp	al, 0Ch
	jne	$+3
	inc	edx
	dec	ecx
	jne	@@5c
	call	_MemAlloc, edx
	jc	@@5f
	push	edi
	push	eax
	xchg	edi, eax
	xchg	esi, eax
@@5d:	lodsb
	cmp	al, 0Ch
	jne	@@5e
	mov	al, 0Dh
	stosb
	mov	al, 0Ah
@@5e:	stosb
	dec	ebx
	jne	@@5d
	mov	ebx, edi
	pop	edi
	sub	ebx, edi
	call	_MemFree

@@5f:	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

@@1:	sub	esp, 10h
	mov	edi, esp
	call	@@Next
	jc	@@9
	sub	esp, 10h
	mov	edi, esp
	call	@@Next
	lea	esp, [@@L0]
	jnc	@@2
	call	@@3
	leave
	ret

@@2:	call	_ArcSetExt, 0
	push	0
	push	edx	; @@L1
@@2a:	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	lea	edi, [@@L0]
	call	@@Next
	jc	@@2c
	mov	[@@SB], esi
	mov	[@@SC], ebx

	push	[@@L1+4]
	inc	[@@L1+4]
	call	_ArcNameFmt, [@@L1]
	db '\%05i',0
	pop	ecx
	call	@@3
	jc	@@2b
	call	_ArcTgaSave
@@2b:	call	_ArcTgaFree
	jmp	@@2a

@@2c:	clc
	leave
	ret

@@3:	movzx	edi, word ptr [@@L0+0Ch]
	movzx	edx, word ptr [@@L0+0Eh]
	mov	ebx, edi
	imul	ebx, edx
	shl	edi, 3
	call	_ArcTgaAlloc, 40h+30h, edi, edx
	jc	@@3b
	xchg	edi, eax
	mov	eax, [@@L0+8]
	mov	[edi+8], eax
	mov	word ptr [edi+5], 20h
	add	edi, 12h
	mov	esi, offset @@T
	push	33h
	pop	ecx
	rep	movsb
	mov	cl, 2Dh
	lea	esi, [edi-3]
	rep	movsb
	lea	ecx, [ebx+ebx]
	xor	eax, eax
	push	edi
	rep	stosd
	pop	edi

	lea	eax, [ebx*4+ebx+1]
	shl	edx, 3
	and	al, -2
	call	_MemAlloc, eax
	jc	@@3b
	push	edi
	push	eax
	xchg	edi, eax
	mov	ecx, ebx
	shl	ecx, 2
	call	@@4, [@@L0], ecx
	inc	ebx
	and	ebx, -2
	call	@@4, [@@L0+4], ebx
	pop	esi
	pop	edi

	xor	ebx, ebx
	inc	ebx
	push	esi
@@3a:	call	@@Decode, [@@L0+0Ch]
	shl	ebx, 1
	cmp	ebx, 20h
	jb	@@3a
	call	_MemFree
	clc
@@3b:	ret

@@4:	pop	eax
	pop	edx
	pop	ecx
	push	eax
	test	edx, edx
	je	@@4a
	movzx	eax, word ptr [edx+0Ah]
	add	edx, 0Ch
	push	eax
	push	edx
	push	ecx
	push	edi
	add	edi, ecx
	call	@@Unpack
	ret
@@4a:	xor	eax, eax
	rep	stosb
	ret

@@Next PROC
	and	dword ptr [edi], 0
	and	dword ptr [edi+4], 0
	call	@@2
	jc	@@9
	test	eax, eax
	mov	eax, [esi+2]
	mov	edx, [esi+6]
	mov	[edi+8], eax
	mov	[edi+0Ch], edx
	je	@@1a
	mov	[edi+4], esi
	sub	ebx, ecx
	add	esi, ecx
	call	@@2
	jc	@@1b
	test	eax, eax
	jne	@@1b
	mov	eax, [edi+8]
	mov	edx, [edi+0Ch]
	sub	eax, [esi+2]
	sub	edx, [esi+6]
	or	eax, edx
	jne	@@1b
@@1a:	mov	[edi], esi
	sub	ebx, ecx
	add	esi, ecx
@@1b:	clc
@@9:	ret

@@2:	cmp	ebx, 0Ch
	jb	@@2a
	movzx	eax, word ptr [esi]
	movzx	ecx, word ptr [esi+0Ah]
	sub	eax, 2
	add	ecx, 0Ch
	cmp	eax, 2
	jae	@@2a
	mov	edx, ecx
	cmp	ebx, ecx
	jb	@@2a
	shr	edx, 1
	ret
@@2a:	stc
	ret
ENDP

@@Decode PROC

@@L0 = dword ptr [ebp+0Ch]

@@W = dword ptr [ebp-4]
@@A = dword ptr [ebp-8]

	push	edi
	push	ebp
	mov	ebp, esp
	movzx	eax, word ptr [@@L0]
	push	eax
	dec	eax
	shl	eax, 3
	push	eax
@@1a:	movzx	ecx, word ptr [@@L0+2]
	push	edi
@@1b:	lodsb
	stc
	adc	al, al
@@1c:	sbb	edx, edx
	and	edx, ebx
	or	[edi], dl
	inc	edi
	add	al, al
	jne	@@1c
	add	edi, [@@A]
	dec	ecx
	jne	@@1b
	pop	edi
	add	edi, 8
	dec	[@@W]
	jne	@@1a
	leave
	pop	edi
	ret	4
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
@@1:	xor	eax, eax
	sub	[@@SC], 2
	jb	@@9
	lodsw
	mov	ecx, eax
	shl	cx, 1
	je	@@7
	sub	[@@DC], ecx
	jb	@@9
	test	ah, ah
	js	@@1a
	sub	[@@SC], ecx
	jb	@@9
	cmp	[@@DB], 0
	je	@@1b
	rep	movsb
	jmp	@@1

@@1a:	test	ecx, ecx
	je	@@9
	sub	[@@SC], 2
	jb	@@9
	lodsw
	xchg	edx, eax
	neg	edx
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	cmp	[@@DB], 0
	je	@@1c
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@1b:	add	esi, ecx
@@1c:	add	edi, ecx
	jmp	@@1

@@7:	sbb	esi, esi
	or	esi, [@@DC]
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

@@T	db 000h,000h,000h	; 0
	db 0DFh,0EFh,0FFh	; 1
	db 0BAh,0CFh,0FFh	; 2
	db 086h,09Ah,0EFh	; 3
	db 051h,051h,0AAh	; 4
	db 024h,024h,086h	; 5
	db 000h,000h,051h	; 6
	db 065h,065h,065h	; 7
	db 0CBh,0CBh,0CBh	; 8
	db 0DFh,034h,000h	; 9
	db 000h,000h,0FFh	; A
	db 0AEh,09Ah,0FFh	; B
	db 000h,0CBh,000h	; C
	db 0EFh,0CFh,045h	; D
	db 000h,0EFh,0FFh	; E
	db 0FFh,0FFh,0FFh	; F

	db 0FFh,000h,0FFh	; *
ENDP
