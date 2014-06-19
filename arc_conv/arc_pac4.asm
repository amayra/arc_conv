
; "Bitter Smile", "Baldr Sky: Dive 2" *.pac
; bittersmile.exe
; 00532BF0 open_archive

	dw 0
_arc_pac4 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	pop	eax
	pop	ebx
	pop	edx
	sub	eax, 'CAP'
	lea	ecx, [ebx-1]
	shl	eax, 8
	shr	ecx, 14h
	or	eax, ecx
	jne	@@9a
	cmp	edx, 5
	jae	@@9a
	mov	[@@L0], edx
	mov	[@@N], ebx
	imul	ebx, 4Ch
	call	_FileSeek, [@@S], -4, 2
	jc	@@9a
	xchg	edi, eax
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	esi
	sub	edi, esi
	jb	@@9a
	test	esi, esi
	je	@@9a
	call	_FileSeek, [@@S], edi, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, ebx, esi, 0
	jc	@@9
	mov	edi, edx
	mov	ecx, esi
@@1c:	not	byte ptr [edi]
	inc	edi
	dec	ecx
	jne	@@1c
	call	_huff_unpack, [@@M], ebx, edx, esi
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	call	_ArcName, esi, 40h
	and	[@@D], 0
	mov	ebx, [esi+48h]
	mov	edi, [esi+44h]
	call	_FileSeek, [@@S], dword ptr [esi+40h], 0
	jc	@@1a
	mov	eax, [@@L0]
	test	eax, eax
	je	@@1d
	cmp	eax, 4
	jb	@@2a
	call	_ArcGetExt
	push	7
	pop	ecx
	mov	edi, offset @@T
	repne	scasd
	jne	@@2a
@@1d:	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 4Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	lea	eax, [@@D]
	call	_ArcMemRead, eax, edi, ebx, 0
	mov	ecx, [@@L0]
	call	[@@Unp+ecx*4-4], [@@D], edi, edx, eax
	jmp	@@1b

@@Unp	dd offset _lzss_unpack, offset _huff_unpack, offset _zlib_unpack, offset _zlib_unpack
@@T	db 'ogg',0,'wav',0,'png',0,'fnt',0,'mpg',0,'mpeg','avi',0
ENDP

_huff_unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	enter	400h, 0
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	xor	ebx, ebx
	mov	edx, esp
	xor	ecx, ecx
	cmp	[@@DC], ebx
	je	@@9
	call	@@4
	test	ah, ah
	jne	@@9
	xchg	edx, eax
@@1:	mov	eax, edx
@@1a:	call	@@3
	adc	eax, eax
	movzx	eax, word ptr [esp+eax*2]
	test	ah, ah
	je	@@1a
	stosb
	dec	[@@DC]
	jne	@@1
	xor	esi, esi
@@9:	xchg	eax, edi
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

@@4:	call	@@3
	jnc	@@4b
	push	ecx
	inc	cl
	je	@@9
	call	@@4
	push	eax
	call	@@4
	pop	edi
	shl	eax, 10h
	xchg	ax, di
	pop	edi
	mov	[edx+edi*4], eax
	xchg	eax, edi
	mov	edi, [@@DB]
	ret

@@4b:	mov	eax, 101h
@@4c:	call	@@3
	adc	al, al
	jnc	@@4c
	ret
ENDP
