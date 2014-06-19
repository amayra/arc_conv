; "Togainu no Chi" *.pak

	dw 0
_arc_nitro2 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@SC
@M0 @@L0

	enter	@@stk+114h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 114h
	jc	@@9a
	mov	ecx, [esi+10h]
	lodsd
	sub	ecx, 64h	; 100-unpacked, 101-packed
	cmp	eax, 2
	jne	@@9a
	mov	[@@L0], ecx
	shr	ecx, 1
	jne	@@9a
	mov	ecx, [esi]	; file_cnt
	mov	edi, [esi+8]	; data_size
	mov	ebx, [esi+4]	; unp_size
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
	and	[@@D], 0
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
	jmp	@@1a
ENDP
