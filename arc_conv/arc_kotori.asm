
; "Ten no Hikari wa Koi no Hoshi" bgm0000.bin

	dw _conv_kotori-$-2
_arc_kotori PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@F
@M0 @@L0

	enter	@@stk+18h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 18h
	jc	@@9a
	mov	edi, offset @@sign
	push	5
	pop	ecx
	repe	cmpsd
	jne	@@9a
	sub	esi, 4
	call	_xarc_crc16, esi, 8
	jc	@@9a
	movzx	ecx, word ptr [esi+4]
	mov	[@@N], ecx
	test	ecx, ecx
	je	@@9a
	imul	ebx, ecx, 6
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

	call	_FileSeek, [@@S], 0, 2
	jc	@@9a
	mov	[@@L0], eax

@@1:	mov	ebx, [@@L0]
	cmp	[@@N], 1
	je	@@1b
	mov	ebx, [esi+6]
@@1b:	mov	eax, [esi]
	sub	ebx, eax
	jb	@@9
	and	[@@D], 0
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 6
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@sign	db 'KOTORI', 0,1Ah,1Ah,0, 0,0,0,0, 003h,067h, 18h,0A6h,0,1
ENDP

_conv_kotori PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 32h+8
	jb	@@9
	mov	edi, offset @@sign
	push	5
	pop	ecx
	repe	cmpsd
	jne	@@9
	sub	esi, 4
	call	_xarc_crc16, esi, 22h
	jnc	@@1
@@9:	stc
	leave
	ret

@@1:	lea	edi, [esi+22h]
	add	esi, 10h
	mov	eax, [edi]
	mov	edx, [edi+4]
	xor	eax, [esi]
	xor	edx, [esi+4]
	sub	ebx, 32h
	sub	eax, 'SggO'
	sub	dh, 2
	or	eax, edx
	jne	@@1
	mov	edx, ebx
	xor	ecx, ecx
@@1a:	mov	al, [edi]
	xor	al, [esi+ecx]
	inc	ecx
	stosb
	and	ecx, 0Fh
	dec	edx
	jne	@@1a
	add	esi, 12h
	call	_ArcSetExt, 'ggo'
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@sign	db 'KOTORi', 0,1Ah,1Ah,0, 0,0,0,0, 0A4h,09Bh, 18h,0A6h,0,1
ENDP
