
; "Wanko to Kurasou" *.mbl

; "MARBLEENGINE"

	dw _conv_mbl-$-2
_arc_mbl PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 8

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	mov	ebx, [esi]
	lea	ecx, [ebx-1]
	shr	ecx, 14h
	jne	@@9a

	call	_marble_check, offset inFileName
	mov	[@@L0+4], eax
	jnc	@@2b
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	lodsd
	lea	ecx, [eax-2]
	shr	ecx, 9
	jne	@@9a
@@2b:	lea	ecx, [eax+8]
	mov	[@@N], ebx
	mov	[@@L0], eax
	imul	ebx, ecx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	ecx, [@@L0]
	cmp	byte ptr [esi], 0
	je	@@9
	mov	edx, [@@L0+4]
	neg	edx
	sbb	edx, edx
	lea	eax, [ebx+8+edx*4]
	cmp	[esi+ecx], eax
	jb	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, [@@L0]
	and	[@@D], 0
	add	esi, [@@L0]
	mov	ebx, [esi+4]
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	@@3
	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 8
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	mov	edi, [@@D]
	cmp	[@@L0+4], 0
	jne	@@3c
	call	_ArcGetExt
	test	eax, eax
	jne	@@3a
	cmp	ebx, 4
	jb	@@3a
	mov	eax, [edi]
	mov	ecx, 'GGO'
	cmp	eax, 'SggO'
	je	@@3b
	mov	ecx, 'SRP'
	cmp	eax, 3034259h
	jne	@@3a
@@3b:	call	_ArcSetExt, ecx
@@3a:	ret

@@3c:	call	_marble_crypt, edi, ebx
	push	'S'
	pop	ecx
	jmp	@@3b
ENDP

_conv_mbl PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 's'
	je	@@2
	sub	ebx, 10h
	jb	@@9
	mov	eax, [esi]
	and	eax, NOT 0FF0000h
	sub	eax, 3004259h
	sub	ebx, [esi+4]
	or	eax, ebx
	je	@@1
@@9:	stc
	leave
	ret

@@2:	mov	ecx, ebx
	push	esi
	mov	edx, ebx
@@2a:	lodsb
	test	al, al
	jne	$+3
	inc	edx
	dec	ecx
	jne	@@2a
	pop	esi
	call	_MemAlloc, edx
	jc	@@9
	push	esi
	push	eax
	xchg	edi, eax
@@2b:	lodsb
	test	al, al
	jne	@@2c
	mov	al, 0Dh
	stosb
	mov	al, 0Ah
@@2c:	stosb
	dec	ebx
	jne	@@2b
	mov	ebx, edi
	pop	edi
	sub	ebx, edi
	call	_MemFree
	call	_ArcSetExt, 'txt'
	call	_ArcData, edi, ebx
	clc
	leave
	ret

	; .prs
@@1:	movzx	edi, word ptr [esi+0Ch]
	movzx	edx, word ptr [esi+0Eh]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 22h, edi, edx
	xchg	edi, eax
	lea	ecx, [esi+10h]
	add	edi, 12h
	lea	eax, [ebx*2+ebx]
	call	@@Unpack, edi, eax, ecx, dword ptr [esi+4]
	xor	eax, eax
	cmp	[esi+2], al
	jns	@@1b
	cdq
@@1a:	add	al, [edi]
	add	dl, [edi+1]
	add	ah, [edi+2]
	mov	[edi], al
	mov	[edi+1], dl
	mov	[edi+2], ah
	add	edi, 3
	dec	ebx
	jne	@@1a
@@1b:	clc
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
@@1a:	jc	@@1b
	dec	[@@DC]
	dec	[@@SC]
	js	@@9
	movsb
	jmp	@@1

@@1b:	dec	[@@SC]
	js	@@9
	xor	eax, eax
	lodsb
	mov	ecx, eax
	test	al, al
	js	@@1d
	and	al, 3
	shr	ecx, 2
	cmp	al, 3
	jne	@@1c
	add	ecx, 9
	sub	[@@DC], ecx
	jb	@@9
	sub	[@@SC], ecx
	jb	@@9
	rep	movsb
	jmp	@@1

@@1c:	mov	edx, ecx
	lea	ecx, [eax+2]
	jmp	@@1f

@@1d:	dec	[@@SC]
	js	@@9
	movzx	edx, byte ptr [esi]
	inc	esi
	mov	dh, cl
	and	dh, 3Fh
	test	ecx, 40h
	jne	@@1e
	mov	ecx, edx
	shr	edx, 4
	and	ecx, 0Fh
	add	ecx, 3
	jmp	@@1f

@@1e:	dec	[@@SC]
	js	@@9
	movsx	eax, byte ptr [esi]
	inc	esi
	xor	ecx, ecx
	inc	eax
	mov	ch, 10h
	je	@@1f
	inc	eax
	mov	ch, 4
	je	@@1f
	inc	eax
	mov	ch, 1
	je	@@1f
	movzx	ecx, al
@@1f:	not	edx
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
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
ENDP

ENDP
