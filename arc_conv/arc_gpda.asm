
; "Ore no Imouto ga Konnna ni Kawaii Wake ga Nai Portable (PSP)" *.dat

	dw _conv_gpda-$-2
_arc_gpda PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 8

	enter	@@stk+20h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 20h
	jc	@@9a
	pop	eax
	pop	ecx	; archive_size
	pop	edx
	pop	ebx
	sub	eax, 'ADPG'
	lea	ecx, [ebx-1]
	or	eax, edx
	shr	ecx, 14h
	or	eax, ecx
	jne	@@9a
	mov	[@@N], ebx
	shl	ebx, 4
	add	ebx, 10h
	mov	eax, [esi+1Ch]
	sub	eax, ebx
	or	eax, [esi+14h]
	jne	@@9a
	mov	ecx, [esi+10h]
	cmp	ecx, ebx
	jb	@@9a
	mov	[@@L0], ebx
	mov	[@@L0+4], ecx
	sub	ecx, 20h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 20h, ecx, 0
	jc	@@9
	mov	edi, [@@M]
	push	8
	pop	ecx
	rep	movsd
	lea	esi, [edi-20h+10h]
	call	_ArcCount, [@@N]

@@1:	mov	edx, [esi+0Ch]
	call	@@3
	test	ecx, ecx
	je	@@1b
	call	_ArcName, edx, ecx
@@1b:	and	[@@D], 0
	mov	ebx, [esi+8]
	cmp	dword ptr [esi+4], 0
	jne	@@1a
	call	_FileSeek, [@@S], dword ptr [esi],  0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 10h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	mov	ecx, [@@L0+4]
	cmp	edx, [@@L0]
	jb	@@3a
	sub	ecx, edx
	jb	@@3a
	add	edx, [@@M]
	sub	ecx, 4
	jb	@@3a
	mov	eax, [edx]
	add	edx, 4
	cmp	ecx, eax
	jb	@@3a
	xchg	ecx, eax
	test	ecx, ecx
	je	@@3a
	cmp	byte ptr [edx+ecx-1], 20h
	jne	$+3
	dec	ecx
	ret

@@3a:	xor	ecx, ecx
	ret
ENDP

_conv_gpda PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	call	_gzip_header, esi, ebx
	jnc	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, eax
	add	esi, eax
	call	_zlib_raw_unpack, 0, -1, esi, ebx
	jc	@@9
	mov	edi, eax
	cmp	eax, 1
	adc	eax, 0
	call	_MemAlloc, eax
	jc	@@9
	xchg	edi, eax
	call	_zlib_raw_unpack, edi, eax, esi, ebx
	xchg	ebx, eax
	call	_ArcGetExt, 'zg'
	jne	@@1a
	call	_ArcSetExt, 0
@@1a:	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret
ENDP

_gzip_header PROC
	push	esi
	mov	ecx, [esp+0Ch]
	mov	esi, [esp+8]
	sub	ecx, 0Ah
	jb	@@9
	mov	eax, [esi]
	sub	eax, 88B1Fh
	shl	eax, 8
	jne	@@9
	mov	al, [esi+3]
	add	esi, 0Ah
	test	al, 0E0h
	jne	@@9
	test	al, 4	; extra
	je	@@1a
	sub	ecx, 2
	jb	@@9
	movzx	edx, word ptr [esi]
	sub	ecx, edx
	jb	@@9
	lea	esi, [esi+edx+2]
@@1a:	test	al, 8	; name
	call	@@2
	test	al, 10h	; comment
	call	@@2
	test	al, 2	; header_crc
	je	@@1b
	sub	ecx, 2
	jb	@@9
	inc	esi
	inc	esi
@@1b:	sub	esi, [esp+8]
	xchg	eax, esi
	jmp	@@8
@@2c:	pop	ecx
@@9:	xor	eax, eax
@@8:	pop	esi
	cmp	eax, 1
	ret	8

@@2:	je	@@2b
@@2a:	inc	esi
	dec	ecx
	js	@@2c
	cmp	byte ptr [esi-1], 0
	jne	@@2a
@@2b:	ret
ENDP
