
; "Separate Blue" *.pak
; ADV.exe
; 00401B14 open_archive
; 00402130 decrypt
; 00402070 rle_unpack

	dw 0
_arc_vav PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+20h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 20h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ecx
	pop	edi
	sub	eax, 'vav'
	sub	dl, 0C8h
	sub	edi, 20h
	shr	edx, 1
	or	eax, edi
	or	eax, edx
	jne	@@9a
	mov	[@@N], ecx
	imul	ebx, ecx, 38h
	dec	ecx
	shr	ecx, 14h
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 20h
	and	[@@D], 0
	mov	ebx, [esi+20h]
	call	_FileSeek, [@@S], dword ptr [esi+28h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax

	cmp	byte ptr [esi+2Ch], 0		; huffman
	jns	@@1c
	mov	edi, [esi+24h]
	imul	edi, 41h
	add	edi, 3Fh
	shr	edi, 6
	call	_MemAlloc, edi
	jc	@@1a
	mov	edx, [@@D]
	mov	[@@D], eax
	push	edx
	call	@@Unpack, eax, edi, edx, ebx
	xchg	ebx, eax
	call	_MemFree
@@1c:
	test	byte ptr [esi+2Ch], 10h		; rle
	je	@@1b
	mov	edi, [esi+24h]
	call	_MemAlloc, edi
	jc	@@1a
	mov	edx, [@@D]
	mov	[@@D], eax
	push	edx
	call	@@RLE, eax, edi, edx, ebx
	xchg	ebx, eax
	call	_MemFree
@@1b:
	mov	dl, [esi+2Ch]
	mov	edi, [@@D]
	and	edx, 0Fh
	call	@@Decrypt
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 38h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@Decrypt PROC
	push	ebx
	sub	ebx, edx
	jbe	@@9
	test	edx, edx
	jne	@@2
@@1:	xor	byte ptr [edi], 55h
	inc	edi
	dec	ebx
	jne	@@1
	jmp	@@9

@@2:	mov	al, [edi]
	xor	[edi+edx], al
	inc	edi
	dec	ebx
	jne	@@2
@@9:	pop	ebx
	ret
ENDP

@@RLE PROC

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
@@1:	cmp	[@@DC], 0
	jle	@@7
	dec	[@@SC]
	js	@@9
	lodsb
	mov	ecx, eax
	and	ecx, 7Fh
	sub	[@@DC], ecx
	jae	@@1a
	add	ecx, [@@DC]
@@1a:	test	al, al
	js	@@1b
	sub	[@@SC], ecx
	jb	@@9
	rep	movsb
	jmp	@@1

@@1b:	dec	[@@SC]
	js	@@9
	lodsb
	rep	stosb
	jmp	@@1

@@7:	mov	esi, [@@DC]
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

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	enter	0FFCh, 0
	push	ecx
	push	ecx
	push	ecx
	; 0x201 * 8 = 1008h

	mov	ecx, 100h
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	sub	[@@SC], ecx
	jb	@@9
	call	@@4
	jb	@@7
	xchg	edx, eax

	xor	ebx, ebx
@@1:	mov	eax, edx
@@1a:	shl	eax, 1
	call	@@3
	adc	eax, eax
	movzx	eax, word ptr [esp+eax*2]
	cmp	eax, 100h
	ja	@@1a
	je	@@7
	dec	[@@DC]
	js	@@9
	stosb
	jmp	@@1

@@7:	mov	esi, [@@DC]
@@9:	xchg	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@3:	shl	bl, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@3a:	ret

@@4 PROC
	push	edi
	push	ebp
	mov	ebp, esp

	lea	edi, [ebp+0Ch]
	xor	eax, eax
@@3:	lodsb
	xor	al, 55h
	stosd
	stosd
	dec	ecx
	jne	@@3
	mov	al, 1
	stosd
	stosd
	push	esi
	mov	edi, 101h
	jmp	@@2

@@1:	add	esi, ecx
	mov	[ebp+0Ch+edi*8], edx
	mov	[ebp+10h+edi*8], esi
	movzx	ebx, dx
	shr	edx, 10h
	and	dword ptr [ebp+10h+ebx*8], 0
	and	dword ptr [ebp+10h+edx*8], 0
	inc	edi
@@2:	or	esi, -1
	xor	ebx, ebx
	mov	ecx, esi
@@4:	mov	eax, [ebp+10h+ebx*8]
	test	eax, eax
	je	@@5
	cmp	eax, esi
	jae	@@5
	shl	edx, 10h
	mov	esi, ecx
	xchg	ecx, eax
	add	edx, ebx
@@5:	inc	ebx
	cmp	ebx, edi
	jb	@@4
	test	esi, esi
	jg	@@1
	xchg	eax, edi
	dec	eax
	pop	esi
	leave
	pop	edi
	cmp	eax, 101h
	ret
ENDP

ENDP

ENDP
