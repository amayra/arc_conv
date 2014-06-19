
_arc_warc PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@P
@M0 @@M
@M0 @@DC
@M0 @@L0
@M0 @@L1, 18h
@M0 @@L3

	enter	@@stk, 0
	mov	ecx, [@@PC]
	lea	edi, [@@L1]
	shr	ecx, 1
	jne	@@2c
	jnc	@@2a
	mov	esi, [@@PB]
	call	_warc_readkey, dword ptr [esi], edi
	jnc	@@2b
@@2c:	jmp	@@9a

@@2a:	xor	esi, esi
	mov	eax, 47*32
	call	_warc_init
@@2b:	movzx	ebx, word ptr [@@L1+2]
	mov	esi, [@@FL]
	lodsd
	imul	ebx, eax

	lea	eax, [ebx*8+ebx+3Ah+7]
	shr	eax, 3
	mov	[@@L0], eax
	mov	ecx, 400h
	cmp	eax, ecx
	jae	$+3
	xchg	eax, ecx
	lea	eax, [ebx+eax+8+3]
	call	_MemAlloc, eax
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax

	push	0Ch
	pop	ecx
	mov	[@@P], ecx
	push	0
	push	'7.1 '
	push	'CRAW'
	mov	edx, esp
	call	_FileWrite, [@@D], edx, ecx
	add	esp, 0Ch

@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@1a
	movzx	ebx, word ptr [@@L1+2]
	sub	ebx, 18h
	call	_string_copy_ansi, edi, ebx, dword ptr [esi+4]
	add	edi, ebx

	mov	eax, [@@P]
	stosd
	xor	eax, eax
	stosd
	mov	eax, [esi+2Ch]
	stosd
	xchg	ecx, eax

	lea	ebx, [ecx*8+ecx+3Ah+7]
	shr	ebx, 3
	add	ebx, 8
	lea	edx, [esi+30h]
	lea	eax, [@@L3]
	call	_ArcLoadFile, eax, edx, 0, ecx, ebx
	jc	@@1b
	sub	ebx, 8
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L3]
	lea	eax, [edx+ecx+8]
	call	_zlib_pack, eax, ebx, edx, ecx
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L3]
	add	eax, 8
	add	edx, ecx
	mov	[edi-8], eax
	add	[@@P], eax
	mov	dword ptr [edx], 0014B5059h
	mov	[edx+4], ecx
	push	eax
	push	edx
	lea	ecx, [eax-8]
	add	edx, 8
	mov	eax, NOT 4B4D4B4Dh
	call	@@3
	call	_FileWrite, [@@D]
@@1b:	call	_MemFree, [@@L3]

	xchg	esi, eax
	lea	esi, [eax+0Ch+14h]	; LastWriteTime
	movsd
	movsd
	xchg	esi, eax
	push	3
	pop	eax
	stosd
	jmp	@@1

@@1a:	mov	ebx, edi
	mov	edx, [@@M]
	sub	ebx, edx
	lea	eax, [edi+8]
	call	_zlib_pack, eax, [@@L0], edx, ebx
	lea	ecx, [eax+3]
	lea	esi, [eax+8]
	shr	ecx, 2

	mov	eax, [@@P]
	xor	eax, 095E49790h
	xor	eax, ebx
	and	ebx, 0FF000000h
	mov	[edi+4], eax
	xor	eax, ebx
	xor	eax, 0014B5059h
	mov	[edi], eax

	mov	eax, [@@P]
	lea	edx, [edi+8]
	xor	eax, 55555555h
@@1c:	xor	[edx], eax
	add	edx, 4
	dec	ecx
	jne	@@1c
	lea	edx, [@@L1]
	movzx	eax, word ptr [@@L1+2]
	shl	eax, 0Eh
	call	_warc_crypt, 1, 0, edx, edi, eax

	mov	ebx, [@@D]
	call	_FileWrite, ebx, edi, esi
	call	_FileSeek, ebx, 8, 0
	lea	edx, [@@P]
	xor	dword ptr [edx], 0F182AD82h
	call	_FileWrite, ebx, edx, 4

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3 PROC
	sub	ecx, 4
	jb	@@2
@@1:	xor	[edx], eax
	add	edx, 4
	sub	ecx, 4
	jae	@@1
@@2:	and	ecx, 3
	je	@@4
@@3:	xor	[edx], al
	inc	edx
	dec	ecx
	jne	@@3
@@4:	ret
ENDP

ENDP
