
; "Beloved Kingdom" *.tpf
; KINGDOM.EXE

	dw 0
_arc_tpf PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ecx
	sub	eax, ' FPT'
	sub	edx, 'ELIF'
	or	eax, ecx
	or	eax, edx
	jne	@@9a
	pop	ebx
	lea	ecx, [ebx-1]
	mov	[@@N], ecx
	dec	ecx
	shr	ecx, 14h
	jne	@@9a
	imul	ebx, 30h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	byte ptr [esi], 0
	je	@@9
	add	ebx, 10h
	cmp	[esi+24h], ebx
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 20h
	and	[@@D], 0
	mov	ebx, [esi+54h]
	mov	edi, [esi+2Ch]
	sub	ebx, [esi+24h]
	jb	@@1a
	call	_FileSeek, [@@S], dword ptr [esi+24h], 0
	jc	@@1a
	lea	eax, [@@D]
	movzx	ecx, byte ptr [esi+23h]
	dec	ecx
	shr	ecx, 1
	je	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 30h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	call	_ArcMemRead, eax, edi, ebx, 0
	call	@@3, [@@D], edi, edx, eax
	jmp	@@1b

@@3:	cmp	byte ptr [esi+23h], 1
	je	_lzss_unpack

@@Unpack PROC	; 00441710

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	enter	408h, 0
	mov	edi, esp
	xor	eax, eax
	mov	ecx, 102h
	rep	stosd
	; huff + lzss
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	xor	ebx, ebx
	mov	edx, esp
	call	@@4
	test	ah, ah
	jne	@@9
	mov	[@@L0], eax
@@1:	cmp	[@@DC], 0
	je	@@7
	mov	eax, [@@L1]
	shr	eax, 1
	jne	@@1a
	call	@@5
	stc
	rcr	al, 1
@@1a:	mov	[@@L1], eax
	jnc	@@1b
	dec	[@@DC]
	js	@@9
	call	@@5
	stosb
	jmp	@@1

@@1b:	call	@@5
	xchg	edx, eax
	call	@@5
	mov	dh, al
	mov	cl, dh
	shr	dh, 4
	and	ecx, 0Fh
	add	ecx, 3
	sub	[@@DC], ecx
	jae	@@1c
	add	ecx, [@@DC]
	and	[@@DC], 0
@@1c:	mov	eax, edi
	sub	eax, [@@DB]
	sub	edx, eax
	add	edx, 12h
	or	edx, -1000h
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
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@5:	mov	eax, [@@L0]
@@5a:	call	@@3
	adc	eax, eax
	movzx	eax, word ptr [esp+eax*2+4]
	test	ah, ah
	je	@@5a
	mov	ah, 0
	ret

	; 00441B00
@@3:	shl	bl, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@3a:	ret

	; 004354D0
@@4:	call	@@3
	jnc	@@4b
	push	ecx
	inc	cl
	je	@@9
	call	@@4
	pop	edi
	mov	[edx+edi*4], ax
	push	edi
	mov	edi, [@@DB]
	call	@@4
	pop	edi
	mov	[edx+edi*4+2], ax
	xchg	eax, edi
	mov	edi, [@@DB]
	ret

@@4b:	mov	eax, 101h
@@4c:	call	@@3
	adc	al, al
	jnc	@@4c
	ret
ENDP

ENDP
