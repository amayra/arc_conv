; "DraKoI", "Kaigen Seito" *.pak
; DraKoI\system.dll 10052EAC

	dw 0
_arc_nitro_pak PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@SC
@M0 @@L0, 8

	enter	@@stk+114h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 114h
	jc	@@9a
	lodsd
	mov	[@@L0+4], eax
	sub	eax, 3
	shr	eax, 1
	jne	@@9a
	sbb	eax, eax
	and	eax, 3F0h
	add	eax, 10h
	mov	[@@L0], eax
	; 10053090
	mov	eax, 100h
	push	esi
	push	eax
	add	esi, eax
	cmp	dword ptr [esi], 64h
	jne	@@9a
	call	_nitro_pak_checksum
	xchg	ebx, eax
	; 10052FF0
	mov	ecx, [esi+8]	; file_cnt
	mov	edi, [esi+0Ch]	; data_size
	xor	ecx, ebx
	xor	ebx, [esi+4]	; unp_size
	xor	edi, [esi]
	lea	esp, [ebp-@@stk]
	lea	eax, [ecx-1]
	mov	[@@N], ecx
	shr	eax, 14h
	jne	@@9a
	imul	ecx, 18h
	cmp	edi, 6
	jb	@@9a
	cmp	ebx, ecx
	jb	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, ebx, edi, 0
	jc	@@9
	mov	esi, [@@M]
	call	_zlib_unpack, esi, ebx, edx, eax
	jc	@@9
	call	_adler32@12, 1, esi, eax
	bswap	eax
	lea	ecx, [ebx+edi]
	cmp	eax, [esi+ecx-4]
	jne	@@9
	add	edi, 114h
	mov	[@@P], edi
	mov	[@@SC], ebx
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	sub	[@@SC], 18h
	jb	@@9
	lodsd
	sub	[@@SC], eax
	jb	@@9
	xchg	edi, eax
	call	_nitro_pak_checksum, edi, esi
	xchg	ebx, eax
	call	_ArcName, esi, edi
	lea	esi, [esi+edi+14h]
	mov	eax, esi
	sub	eax, [@@M]
	xor	eax, ebx
	and	[@@D], 0
	cmp	[esi-0Ch], eax
	jne	@@1a
	xor	[esi-14h], ebx
	xor	[esi-10h], ebx
	mov	[esi-0Ch], ebx
	xor	[esi-8], ebx
	xor	[esi-4], ebx
	cmp	dword ptr [esi-8], 2
	jae	@@1a
	mov	eax, [@@P]
	mov	ebx, [esi-10h]
	add	eax, [esi-14h]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	cmp	dword ptr [esi-8], 0
	jne	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	mov	ecx, [@@L0]
	cmp	ecx, ebx
	jb	$+4
	mov	ecx, ebx
@@2b:	mov	edx, [@@D]
	mov	eax, [esi-0Ch]
	test	ecx, ecx
	je	@@1a
@@1c:	xor	[edx], al
	inc	edx
	ror	eax, 8
	dec	ecx
	jne	@@1c
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jnc	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	call	_ArcMemRead, eax, ebx, dword ptr [esi-4], 0
	call	_zlib_unpack, [@@D], ebx, edx, eax
	xchg	ebx, eax
	cmp	[@@L0+4], 4
	jne	@@1a
	mov	ecx, ebx
	jmp	@@2b
ENDP
