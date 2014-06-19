
_arc_ypf PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@P
@M0 @@M
@M0 @@DC
@M0 @@L1
@M0 @@L2
@M0 @@L3
@M0 @@L4

	enter	@@stk, 0
	mov	ebx, [@@PC]
	dec	ebx
	js	@@9a
	mov	esi, [@@PB]
	call	_string_num, dword ptr [esi]
	jc	@@9a
	mov	[@@L1], eax

	mov	edi, offset @@T
@@2a:	sub	edi, 5
	cmp	ax, word ptr [edi]
	jb	@@2a
	movzx	eax, byte ptr [edi+2]
	movzx	edx, word ptr [edi+3]
	mov	[@@L3], eax
	mov	[@@L4], edx

	test	ebx, ebx
	je	@@2b
	dec	ebx
	call	_string_num, dword ptr [esi+4]
	jc	@@9a
	mov	[@@L3], eax
	test	ebx, ebx
	je	@@2b
	dec	ebx
	jne	@@9a
	call	_string_num, dword ptr [esi+8]
	jc	@@9a
	mov	edx, eax
	shr	edx, 10h
	jne	@@9a
	mov	[@@L4], eax
@@2b:
	mov	esi, [@@FL]
	mov	ebx, [esi]
	add	esi, 4
	imul	ebx, 17h
	add	ebx, 20h
@@4a:	mov	esi, [esi]
	test	esi, esi
	je	@@4b
	add	ebx, [esi+8]
	jmp	@@4a
@@4b:	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax

	mov	esi, [@@FL]
	mov	eax, 'FPY'
	stosd
	mov	eax, [@@L1]
	stosd
	movsd
	xor	eax, eax
	stosd
	stosd
	stosd
	stosd
	stosd

@@4c:	mov	esi, [esi]
	test	esi, esi
	je	@@4d
	mov	eax, [esi+8]
	mov	ebx, 0FFh
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	call	_sjis_lower, dword ptr [esi+4]
	mov	eax, [esi+4]
	cmp	[@@L1], 100h
	jae	@@4f
	call	_adler32@12, 1, eax, ebx
	jmp	@@4g
@@4f:	call	_crc32@12, 0, eax, ebx
@@4g:	stosd
	mov	eax, ebx
	stosb
	xchg	ecx, eax
	mov	eax, [esi+4]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax

	cmp	ebx, 4
	jb	@@4e
	mov	eax, [edi-4]
	mov	cl, 9
	push	edi
	mov	edi, offset @@T
	repne	scasd
	pop	edi
	cmp	[@@L1], 100h
	jb	@@4e
	cmp	ecx, 6
	adc	ecx, -1
@@4e:	xchg	eax, ecx
	stosb
	xor	eax, eax
	stosb
	stosd
	stosd
	stosd
	stosd
	jmp	@@4c

@@4d:	xchg	eax, edi
	mov	edi, [@@M]
	sub	eax, edi
	mov	[@@P], eax
	call	_FileWrite, [@@D], edi, eax
	add	edi, 20h

	mov	esi, [@@FL]
	add	esi, 4
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@1a
	mov	eax, [@@L1]
	mov	edx, [@@L3]
	call	@@Enc
	mov	eax, [esi+2Ch]
	mov	ecx, [@@P]
	stosd
	stosd
	xchg	eax, ecx
	stosd
	xor	eax, eax
	inc	eax
	stosd	; adler32

	xor	edx, edx
	mov	ebx, [@@L4]
	lea	eax, [edx+4]
	test	ebx, ebx
	je	@@1f
	lea	eax, [ebx+ecx-1]
	div	ebx
	lea	eax, [eax*2+ebx+8]
@@1f:
	lea	ebx, [ecx*8+ecx+3Ah+7]
	shr	ebx, 3
	add	ebx, eax
	lea	edx, [esi+30h]
	lea	eax, [@@L2]
	call	_ArcLoadFile, eax, edx, 0, ecx, ebx
	jc	@@1c

	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	lea	eax, [edx+ecx]
	call	_zlib_pack, eax, ebx, edx, ecx
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	cmp	eax, ecx
	jae	@@1b
	add	edx, ecx
	xchg	eax, ecx
	inc	byte ptr [edi-11h]
@@1b:	mov	[edi-0Ch], ecx
	push	ecx
	push	edx
	call	_adler32@12, 1, edx, ecx
	mov	[edi-4], eax
	call	@@Rec, [@@L4]
	add	[@@P], eax
	call	_FileWrite, [@@D], edx, eax
@@1c:	call	_MemFree, [@@L2]
	jmp	@@1

@@1a:	mov	esi, [@@M]
	sub	edi, esi
	mov	eax, edi
	cmp	[@@L1], 100h
	jae	@@1d
	sub	eax, 20h
@@1d:	mov	[esi+0Ch], eax
	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	call	_FileWrite, ebx, esi, edi

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@Rec PROC

@@L0 = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@C = dword ptr [ebp+1Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@S]
	mov	ebx, [@@C]
	mov	eax, [@@L0]
	lea	edi, [esi+ebx]
	lea	ecx, [ebx+4]
	stosd
	test	eax, eax
	xchg	ecx, eax
	je	@@8
	lea	eax, [ebx+ecx-1]
	xor	edx, edx
	div	ecx
	stosd
	lea	eax, [edi+eax*2]
	push	eax
	push	edi
	xchg	edi, eax
	xor	eax, eax
	rep	stosb
	sub	edi, esi
	mov	[@@C], edi
	pop	edi
	test	ebx, ebx
	je	@@9
@@1:	mov	ecx, [@@L0]
	sub	ebx, ecx
	jae	$+6
	add	ecx, ebx
	xor	ebx, ebx
	mov	edx, [ebp-4]
	push	ecx
	push	esi
@@2:	lodsb
	xor	[edx], al
	inc	edx
	dec	ecx
	jne	@@2
	call	_adler32@12, 1
	stosw
	test	ebx, ebx
	jne	@@1
@@9:	mov	eax, [@@C]
@@8:	mov	edx, [@@S]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

@@Enc PROC
	movzx	ebx, byte ptr [edi+4]
	push	edx
	call	_ypf_crypt, eax, ebx
	xor	al, -1
	pop	edx
	mov	[edi+4], al
	add	edi, 5
	test	ebx, ebx
	je	@@2c
@@2b:	xor	[edi], dl
	inc	edi
	dec	ebx
	jne	@@2b
@@2c:	inc	edi
	inc	edi
	ret
ENDP
	db 000h,0,0FFh,0,4	; 0F7h
	db 022h,1,034h,0,4
	db 02Ch,1,028h,0,0
	db 096h,1,0FFh,0,4
@@T	db '.psd.ogg.wav.avi.gif.jpg.png.bmp.ybn'
ENDP
