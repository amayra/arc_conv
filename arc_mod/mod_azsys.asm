
_mod_azsys PROC

@@stk = 0
@M0 @@S
@M0 @@C
@M0 @@M
@M0 @@K

	enter	@@stk+0Ch, 0
	sub	eax, 3
	xchg	ebx, eax
	shr	eax, 1
	jne	@@9a
	call	_string_select, offset @@strTab, dword ptr [ebp+0Ch]
	jc	@@9a
	and	[@@M], 0
	cmp	eax, 3
	je	@@3
	xchg	ebx, eax

	call	_string_num, dword ptr [ebp+10h]
	jc	@@9a
	mov	[@@K], eax
	call	_FileCreate, dword ptr [ebp+14h], FILE_INPUT
	jc	@@9a
	mov	[@@S], eax
	cmp	ebx, 2
	je	@@2
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9
	pop	eax
	cmp	eax, 1A425341h
	jne	@@9
	pop	edi
	pop	ebx
	cmp	edi, 6
	jb	@@9
	mov	eax, edi
	add	eax, ebx
	jc	@@9
	call	_MemAlloc, eax
	jc	@@9
	mov	[@@M], eax
	xchg	edi, eax
	lea	ecx, [eax-4]
	mov	[@@C], ecx
	lea	esi, [edi+ebx]
	call	@@ReadClose
	mov	eax, [@@K]
	xor	eax, ebx
	call	@@Crypt, 0, eax, esi, [@@C]
	test	eax, eax
	jne	@@9
	lea	edx, [esi+4]
	call	_zlib_unpack, edi, ebx, edx, [@@C]
	xchg	ebx, eax
	jmp	@@7

@@2:	call	_FileGetSize, [@@S]
	jc	@@9
	mov	[@@C], eax
	lea	ebx, [eax*8+eax+3Ah+7]
	shr	ebx, 3
	lea	ecx, [ebx+eax+10h]
	call	_MemAlloc, ecx
	jc	@@9
	mov	[@@M], eax
	xchg	esi, eax
	mov	eax, [@@C]
	call	@@ReadClose
	mov	ecx, [@@C]
	lea	edi, [esi+ecx]
	mov	eax, 1A425341h
	stosd
	xchg	eax, ecx
	stosd
	stosd
	stosd
	call	_zlib_pack, edi, ebx, esi, eax
	lea	ecx, [eax+4]
	lea	ebx, [eax+10h]
	mov	[edi-0Ch], ecx
	sub	edi, 10h
	mov	ecx, [@@K]
	lea	esi, [edi+0Ch]
	xor	ecx, [@@C]
	call	@@Crypt, 1, ecx, esi, eax
	jmp	@@7

@@3:	test	ebx, ebx
	jne	@@9a
	call	_FileCreate, dword ptr [ebp+10h], FILE_INPUT
	jc	@@9a
	mov	[@@S], eax
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9
	pop	eax
	cmp	eax, 1A425341h
	jne	@@9
	pop	edi
	pop	ebx
	cmp	edi, 8
	jb	@@9
	call	_MemAlloc, edi
	jc	@@9
	mov	[@@M], eax
	xchg	edi, eax
	lea	ecx, [eax-4]
	mov	[@@C], ecx
	mov	esi, edi
	call	@@ReadClose
	lea	edx, [edi+4]
	call	@@Brute, ebx, edx, [@@C]
	push	ecx
	push	ecx
	push	'x0'
	mov	edi, esp
	lea	edx, [edi+2]
	call	_hex32_upper, eax, edx
	push	0Ah
	pop	ebx
@@7:	mov	eax, [ebp+8]
	call	_FileCreate, dword ptr [ebp+0Ch+eax*4-4], FILE_OUTPUT
	jc	@@9
	mov	[@@S], eax
	call	_FileWrite, [@@S], edi, ebx
@@9:	call	_MemFree, [@@M]
	call	_FileClose, [@@S]
@@9a:	leave
	ret

@@ReadClose:
	call	_FileRead, [@@S], esi, eax
	jc	@@9
	call	_FileClose, [@@S]
	or	[@@S], -1
	ret

@@Crypt PROC

@@L0 = dword ptr [ebp+14h]
@@K = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	ebx, [@@K]
	mov	esi, [@@SB]
	mov	edi, [@@SC]
	mov	ecx, ebx
	shl	ebx, 0Ch
	or	ebx, ecx
	shl	ebx, 0Bh
	xor	ebx, ecx

	cmp	[@@L0], 0
	je	@@1
	lea	edx, [esi+4]
	call	_crc32@12, 0, edx, edi
	mov	[esi], eax
	neg	ebx
@@1:
	mov	ecx, edi
	mov	edx, esi
	shr	ecx, 2
@@2:	sub	[edx], ebx
	add	edx, 4
	dec	ecx
	jns	@@2

	cmp	[@@L0], 0
	jne	@@3
	lea	edx, [esi+4]
	call	_crc32@12, 0, edx, edi
	sub	eax, [esi]
@@3:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

@@Brute PROC

@@DC = dword ptr [ebp+14h]
@@SB = dword ptr [ebp+18h]
@@SC = dword ptr [ebp+1Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	enter	408h, 0

	xor	ecx, ecx
@@3:	mov	eax, ecx
	push	8
	pop	edx
@@3a:	ror	eax, 1
	jc	$+7
	xor	eax, 06DB88320h
	dec	edx
	jne	@@3a
	mov	[esp+ecx*4], eax
	inc	cl
	jne	@@3

	mov	esi, [@@SB]
	mov	eax, [esi]
	sub	eax, 0DA78h
	mov	[@@L1], 0F0000000h
	mov	[@@L0], eax

@@2:	mov	ebx, [@@L1]
	bswap	ebx
	shl	bl, 4
	xor	ebx, [@@L0]

	mov	eax, [esi]
	sub	eax, ebx
	xchg	al, ah
	movzx	eax, ax
	imul	edx, eax, 8422h	; div16(0x1F)
	shr	edx, 14h
	imul	edx, 1Fh
	cmp	eax, edx
	jne	@@2c
	test	ah, ah
	js	@@2c

	mov	ecx, [@@SC]
	xor	eax, eax
	shr	ecx, 2
@@1a:	mov	edx, [esi]
	sub	edx, ebx
	xor	eax, edx
	add	esi, 4
	movzx	edx, al
	shr	eax, 8
	xor	eax, [esp+edx*4]
	movzx	edx, al
	shr	eax, 8
	xor	eax, [esp+edx*4]
	movzx	edx, al
	shr	eax, 8
	xor	eax, [esp+edx*4]
	movzx	edx, al
	shr	eax, 8
	xor	eax, [esp+edx*4]
	dec	ecx
	jne	@@1a
	mov	ecx, [@@SC]
	and	ecx, 3
	je	@@1c
@@1b:	movzx	edx, byte ptr [esi]
	inc	esi
	xor	dl, al
	shr	eax, 8
	xor	eax, [esp+edx*4]
	dec	ecx
	jne	@@1b
@@1c:
	mov	esi, [@@SB]
	add	eax, ebx
	cmp	eax, [esi-4]
	je	@@2b
@@2a:	inc	[@@L1]
	jne	@@2
	xor	eax, eax
	jmp	@@9

@@2c:	or	word ptr [@@L1], -1
	jmp	@@2a

@@2b:	mov	eax, ebx
	mov	ecx, eax
	shl	eax, 0Bh
	xor	eax, ecx
	mov	edx, eax
	shl	eax, 0Ch
	or	eax, edx
	shl	eax, 0Bh
	xor	eax, ecx
	xor	eax, [@@DC]
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

@@strTab db 'dec',0, 'enc',0, 'key',0, 0
ENDP
