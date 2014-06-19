
_arc_pac4 PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@P
@M0 @@M
@M0 @@DC
@M0 @@L0
@M0 @@L2

	enter	@@stk, 0
	mov	ecx, [@@PC]
	push	4
	pop	eax
	test	ecx, ecx
	je	@@2b
	dec	ecx
	jne	@@9a
	mov	esi, [@@PB]
	call	_string_num, dword ptr [esi]
	jc	@@9a
	cmp	eax, 5
	jae	@@9a
@@2b:	mov	[@@L2], eax

	mov	esi, [@@FL]
	imul	ebx, dword ptr [esi], 4Ch
	lea	eax, [ebx+140h]
	mov	[@@L0], eax
	add	eax, ebx
	call	_MemAlloc, eax
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax

	push	0Ch
	pop	ecx
	mov	[@@P], ecx
	lodsd
	push	[@@L2]
	push	eax
	push	'CAP'
	mov	edx, esp
	call	_FileWrite, [@@D], edx, ecx
	add	esp, 0Ch

@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@1a
	call	_string_copy_ansi, edi, 40h, dword ptr [esi+4]

	mov	edx, edi
	mov	ebx, [@@L2]
	add	edi, 40h
	dec	ebx
	js	@@1d
	cmp	ebx, 3
	jne	@@1c
	call	_ansi_ext, eax, edx
	push	7
	pop	ecx
	push	edi
	mov	edi, offset @@T
	repne	scasd
	pop	edi
	je	@@1d
@@1c:
	mov	eax, [@@P]
	stosd
	mov	eax, [esi+2Ch]
	stosd
	xchg	ecx, eax
	call	@@Select
	lea	edx, [esi+30h]
	call	_ArcPackFile, [@@D], edx, ecx, ebx, 1, eax, 0
	add	[@@P], eax
	stosd
	jmp	@@1

@@1d:	mov	eax, [@@P]
	stosd
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
	add	[@@P], eax
	stosd
	stosd
	jmp	@@1

@@1a:	mov	ebx, edi
	mov	edx, [@@M]
	sub	ebx, edx
	call	_huff_pack, edi, [@@L0], edx, ebx
	xchg	esi, eax

	mov	edx, edi
	mov	ecx, esi
@@2a:	not	byte ptr [edx]
	inc	edx
	dec	ecx
	jne	@@2a

	mov	ebx, [@@D]
	call	_FileWrite, ebx, edi, esi
	push	esi
	mov	edx, esp
	call	_FileWrite, ebx, edx, 4

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

	; 0 - none, 1 - lzss, 2 - huff, 3 - zlib, 4 - select(none,zlib)

@@Select PROC
	dec	ebx
	js	@@1
	je	@@2
	lea	ebx, [ecx*8+ecx+3Ah+7]
	mov	eax, offset _zlib_pack
	shr	ebx, 3
	ret

@@1:	lea	ebx, [ecx*8+ecx+7]
	mov	eax, offset _lzss_pack
	shr	ebx, 3
	ret

@@2:	lea	ebx, [ecx+140h]
	mov	eax, offset _huff_pack
	ret
ENDP

@@T	db 'ogg',0,'wav',0,'png',0,'fnt',0,'mpg',0,'mpeg','avi',0
ENDP

_huff_pack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	enter	0C08h, 0
	mov	edi, esp
	mov	ecx, 100h
	xor	eax, eax
	mov	esi, [@@SB]
	mov	ebx, [@@SC]
	rep	stosd
	test	ebx, ebx
	je	@@1a
@@1:	lodsb
	inc	dword ptr [esp+eax*4]
	dec	ebx
	jne	@@1
@@1a:	mov	eax, esp
	call	@@2
	mov	[@@L0], eax
	xor	edx, edx
	mov	esi, esp
	inc	edx
	mov	edi, [@@DB]
	xor	ecx, ecx
	call	@@4

	cmp	[@@SC], 0
	je	@@9
	mov	esi, [@@SB]
@@5:	movzx	eax, byte ptr [esi]
	inc	esi
	mov	ecx, [esp+eax*8]
	mov	eax, [esp+eax*8+4]
@@5a:	add	eax, eax
	call	@@3
	dec	ecx
	jne	@@5a
	dec	[@@SC]
	jne	@@5

@@9:	cmp	edx, 1
	je	@@9c
@@9b:	add	dl, dl
	jnc	@@9b
	mov	[edi], dl
	inc	edi
@@9c:	xchg	eax, edi
	mov	esi, [@@SC]
	sub	eax, [@@DB]
	neg	esi
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@3:	adc	dl, dl
	jnc	@@3a
	mov	[edi], dl
	inc	edi
	mov	dl, 1
@@3a:	ret

@@4:	test	ah, ah
	jne	@@4a
	cmp	ecx, 20h
	jae	@@9
	stc
	call	@@3
	inc	ecx
	shl	ebx, 1
	mov	ah, 2
	push	eax
	movzx	eax, word ptr [esi+eax*4]
	call	@@4
	pop	eax
	inc	ebx
	movzx	eax, word ptr [esi+eax*4+2]
	call	@@4
	shr	ebx, 1
	dec	ecx
	ret

@@4a:	mov	ah, 0
	ror	ebx, cl
	mov	[esi+eax*8], ecx
	mov	[esi+eax*8+4], ebx
	rol	ebx, cl
	clc
	call	@@3
	stc
	adc	al, al
@@4b:	call	@@3
	add	al, al
	jne	@@4b
	ret

@@2 PROC
	push	ebx
	push	esi
	push	edi
	push	ebp
	xchg	esi, eax
	mov	edi, esi
	xor	eax, eax
	xor	ecx, ecx
@@1:	add	ecx, [esi+eax*4]
	inc	al
	jne	@@1
	push	ecx
	lea	ebp, [esp-10h]
@@2:	mov	ah, 1
@@3:	xor	ebx, ebx
	xor	ecx, ecx
	or	edi, -1
@@4:	mov	edx, [esi+ecx*4]
	test	edx, edx
	je	@@5
	cmp	edx, edi
	jae	@@5
	mov	ebx, ecx
	mov	edi, edx
@@5:	inc	ecx
	cmp	ecx, eax
	jb	@@4
	push	ebx
	push	dword ptr [esi+ebx*4]
	and	dword ptr [esi+ebx*4], 0
	cmp	esp, ebp
	jne	@@3
	pop	edx
	pop	ebx
	pop	ecx
	add	edx, ecx
	pop	ecx
	mov	[esi+eax*4], edx
	mov	ah, 2
	xor	ch, 1
	xor	bh, 1
	mov	[esi+eax*4], cx
	mov	[esi+eax*4+2], bx
	inc	eax
	cmp	edx, [esp]
	jne	@@2
	dec	eax
	mov	ah, 0
	pop	ecx
	pop	ebp
	pop	edi
	pop	esi
	pop	ebx
	ret
ENDP

ENDP
