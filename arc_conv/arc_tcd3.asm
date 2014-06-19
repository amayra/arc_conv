
; "Nanapuri" *.tcd
; 7Pri.exe
; 00436AB0 open_archive
; 0043E610 ogg_decrypt

	dw _conv_tcd3-$-2
_arc_tcd3 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1
@M0 @@L2, 10h
@M0 @@I
@M0 @@L3

	enter	@@stk+0A8h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0A8h
	jc	@@9a
	cmp	dword ptr [esi], '3DCT'
	jne	@@9a
	; esi+4 file_count
	add	esi, 8
	and	[@@L1], 0
	mov	[@@L0], esi

	call	_ArcParamNum, -1
	db 'tcd3', 0
	mov	[@@L3], eax

	; size, offset, dir_cnt, dir_size, name_cnt, name_size
	push	5
	pop	ecx
	xor	ebx, ebx
@@2a:	cmp	dword ptr [esi], 0
	je	@@2b
	mov	eax, [esi+10h]
	add	ebx, eax
	dec	eax
	shr	eax, 0Fh	; 7530h
	jne	@@9a
	mov	eax, [esi+14h]
	mov	edx, [esi+0Ch]
	dec	eax
	dec	edx
	or	eax, edx
	mov	edx, [esi+8]
	shr	eax, 6
	dec	edx
	shr	edx, 8
	or	eax, edx
	jne	@@9a
@@2b:	add	esi, 20h
	dec	ecx
	jne	@@2a
	test	ebx, ebx
	je	@@9a
	call	_ArcCount, ebx
	and	[@@L1], 0

@@2c:	mov	edi, [@@L1]
	mov	esi, [@@L0]
	imul	eax, edi, 20h
	add	esi, eax
	cmp	dword ptr [esi], 0
	je	@@2d
	mov	ecx, [esi+10h]
	mov	edx, [esi+0Ch]
	mov	eax, [esi+14h]
	add	edx, 10h
	add	eax, 4
	imul	edx, [esi+8]
	imul	eax, ecx
	mov	[@@N], ecx
	lea	ebx, [edx+eax+4]
	call	_FileSeek, [@@S], dword ptr [esi+4], 0
	jc	@@1a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9

	mov	edx, [@@M]
	mov	ecx, [esi+8]
	imul	ecx, [esi+0Ch]
	mov	[@@L2], edx
	mov	al, [edx+ecx-1]
@@5a:	sub	[edx], al
	inc	edx
	dec	ecx
	jne	@@5a
	mov	[@@L2+4], edx
	xor	ebx, ebx
	mov	ecx, [esi+8]
@@5b:	mov	edi, [esi+14h]
	cmp	ebx, [edx+8]
	jne	@@2e
	imul	edi, ebx
	add	ebx, [edx]
	jc	@@2e
	cmp	edi, [edx+4]
	jne	@@2e
	add	edx, 10h
	dec	ecx
	jne	@@5b
	cmp	[esi+10h], ebx
	jne	@@2e
	mov	[@@L2+8], edx
	mov	ecx, [esi+10h]
	imul	ecx, [esi+14h]
	mov	al, [edx+ecx-1]
@@5c:	sub	[edx], al
	inc	edx
	dec	ecx
	jne	@@5c
	mov	[@@L2+0Ch], edx

	mov	eax, [esi+0Ch]
	add	eax, [esi+14h]
	inc	eax
	and	al, -4
	push	ecx
	sub	esp, eax
@@1:	mov	edx, [@@L2+4]
	mov	ebx, [esi+10h]
	mov	eax, [edx]
	sub	ebx, [@@N]
	add	eax, [edx+8]
	mov	ecx, [esi+0Ch]
	cmp	ebx, eax
	jb	@@1b
	add	[@@L2+4], 10h
	add	[@@L2], ecx
	jmp	@@1
@@1b:	mov	edx, [@@L2]
	mov	edi, esp
@@1c:	mov	al, [edx]
	inc	edx
	test	al, al
	je	@@1d
	stosb
	dec	ecx
	jne	@@1c
@@1d:	mov	al, 2Fh
	stosb
	mov	ecx, [esi+14h]
	push	esi
	mov	esi, ebx
	imul	esi, ecx
	add	esi, [@@L2+8]
	rep	movsb
	xchg	eax, ecx
	stosb
	pop	esi
	mov	edx, esp
	call	_ArcName, edx, -1
	and	[@@D], 0
	mov	edx, [@@L2+0Ch]
	mov	eax, [edx+ebx*4]
	mov	ebx, [edx+ebx*4+4]
	sub	ebx, eax
	jb	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax

	mov	eax, [@@L1]
	shl	eax, 10h
	add	eax, '00$'
	call	_ArcSetExt, eax

	mov	edi, [@@D]
	cmp	[@@L1], 3
	jb	@@4a
	cmp	ebx, 8
	jb	@@4a
	mov	eax, [edi]
	mov	edx, [edi+4]
	sub	eax, 'SggO'
	sub	dh, 2
	or	eax, edx
	jne	@@4a
	call	_ArcSetExt, 'ggo'
	call	@@OggChecksum, edi, ebx
@@4a:
	cmp	[@@L1], 2
	jne	@@1a
	cmp	ebx, 14h
	jb	@@1a
	call	_ArcSetExt, 'dps'
	cmp	dword ptr [edi], 'CDPS'
	je	@@1a
	mov	eax, [esi+10h]
	sub	eax, [@@N]
	call	@@SpdDecrypt, [@@L3], eax, edi
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1

@@2e:	mov	esp, [@@L0]
	call	_ArcSkip, [@@N]
	call	_MemFree, [@@M]
@@2d:	inc	dword ptr [@@L1]
	and	[@@M], 0
	cmp	[@@L1], 5
	jb	@@2c
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@OggChecksum PROC
	push	ebx
	push	esi
	push	edi
	enter	400h, 0

	xor	edx, edx
	mov	edi, esp
@@2:	mov	eax, edx
	push	8
	pop	ecx
@@2a:	shl	eax, 1
	jnc	@@2b
	xor	eax, 004C11DB7h
@@2b:	dec	ecx
	jne	@@2a
	stosd
	add	edx, 1000000h
	jne	@@2

	mov	ebx, [ebp+18h]
	mov	esi, [ebp+14h]
@@1:	cmp	ebx, 1Bh
	jb	@@9
	xor	ecx, ecx
	cmp	dword ptr [esi], 'SggO'
	jne	@@9
	movzx	edx, byte ptr [esi+1Ah]
	mov	[esi+16h], ecx
	lea	edi, [esi+1Bh]
	lea	ecx, [edx+1Bh]
	test	edx, edx
	je	@@1b
	cmp	ebx, ecx
	jb	@@9
@@1a:	movzx	eax, byte ptr [edi]
	inc	edi
	add	ecx, eax
	dec	edx
	jne	@@1a
@@1b:	sub	ebx, ecx
	jb	@@1
	lea	edi, [esi+16h]
	xor	eax, eax
@@3a:	mov	edx, eax
	shl	eax, 8
	shr	edx, 18h
	xor	dl, [esi]
	inc	esi
	xor	eax, [esp+edx*4]
	dec	ecx
	jne	@@3a
	mov	[edi], eax
	jmp	@@1

@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

@@SpdDecrypt PROC

@@L0 = dword ptr [ebp-14h]

	push	ebx
	push	esi
	push	edi
	enter	14h, 0
	mov	ebx, [ebp+14h]
	test	ebx, ebx
	jns	@@7
	xor	ebx, ebx
@@1:	mov	edi, esp
	mov	esi, [ebp+1Ch]
	push	5
	pop	ecx
	rep	movsd
	call	@@3, ebx, dword ptr [ebp+18h], esp
	call	_tcd3_spd_decrypt, esp
	mov	edx, [@@L0+8]
	mov	eax, [@@L0]
	or	edx, [@@L0+0Ch]
	sub	eax, 'CDPS'
	shr	edx, 10h
	or	eax, edx
	je	@@7
	inc	ebx
	cmp	ebx, 3
	jb	@@1
@@7:	cmp	ebx, 3
	mov	[ebp+14h], ebx
	leave
	pop	edi
	pop	esi
	pop	ebx
	jae	@@3b

@@3:	mov	ecx, [esp+4]
	mov	edx, [esp+0Ch]
	test	ecx, ecx
	jne	@@3a
	mov	al, [edx+10h]
	add	al, [edx+12h]
	sub	[edx], al
	sub	[edx+1], al
	sub	[edx+2], al
	sub	[edx+3], al
	jmp	@@3b

@@3a:	mov	eax, [esp+8]
	mov	ecx, [@@T+ecx*4-4]
	add	eax, 3
	imul	eax, ecx
	add	[edx], eax
	add	eax, ecx
	add	[edx+4], eax
	add	eax, ecx
	add	[edx+8], eax
	add	eax, ecx
	add	[edx+0Ch], eax
	add	eax, ecx
	add	[edx+10h], eax
@@3b:	ret	0Ch

@@T	dd -3AD5A73Eh
	dd 137E59A1h
ENDP

ENDP

_conv_tcd3 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'dps'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 14h
	jb	@@9
	cmp	dword ptr [esi], 'CDPS'
	jne	@@9
	mov	[@@SC], ebx
	call	_tcd3_spd_decrypt, esi

	mov	eax, [esi+4]
	and	al, 7Fh
	cmp	word ptr [esi+6], 18h
	jne	@@9
	test	al, al
	je	@@1d
	cmp	al, 2
	je	@@1d
	cmp	al, 3	; jpg
	je	@@1a
	cmp	al, 4	; jpg+alpha
	je	@@1a
	cmp	al, 1
	jne	@@9
	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	mov	ebx, edi
	imul	ebx, edx
	lea	ecx, [ebx*2+ebx]
	cmp	[esi+10h], ecx
	jne	@@9
	call	_ArcTgaAlloc, 22h, edi, edx
	lea	edi, [eax+12h]
	lea	edx, [esi+14h]
	mov	eax, offset @@Unpack1
	cmp	byte ptr [esi+5], 0
	jne	@@1e
	lea	ebx, [ebx*2+ebx]
	add	eax, @@Unpack2-@@Unpack1
@@1e:	call	eax, edi, ebx, edx, [@@SC]
	clc
	leave
	ret

@@1a:	add	esi, 14h
	push	4
	pop	edx
	cmp	al, 3
	je	@@1c
	xor	edx, edx
	sub	ebx, 0Ch
	jb	@@9
	mov	eax, [esi+4]
	sub	ebx, eax
	jb	@@9
	lea	esi, [esi+eax+0Ch]
@@1c:	cmp	ebx, 40h
	jb	@@9
	xor	ecx, ecx
@@1b:	add	dword ptr [esi+ecx*4], 0A8961EF1h
	inc	ecx
	cmp	ecx, 10h
	jb	@@1b
	sub	ebx, edx
	add	esi, edx
	call	_ArcSetExt, 'gpj'
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@1d:	mov	edi, [esi+10h]
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	lea	edx, [esi+14h]
	call	@@Unpack2, edi, eax, edx, ebx
	push	edi	; @@L0

	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 23h, edi, edx
	lea	edi, [eax+12h]
	mov	eax, [esi+4]
	call	@@Unpack3, edi, ebx, [@@L0], dword ptr [esi+10h]

	call	_MemFree
	clc
	leave
	ret

@@Unpack1 PROC	; 004367F0

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
	movzx	eax, word ptr [edi-12h+0Ch]
	neg	eax
	push	eax
	dec	[@@DC]
	js	@@9
	sub	[@@SC], 3
	jb	@@9
	movsb
	movsb
	movsb
@@1:	dec	[@@DC]
	js	@@7

	; 0x
	; 10x
	; 111
	; 1100x
	; 1101x

	or	edx, -1
	call	@@3
	jnc	@@1c
	mov	edx, [@@L0]
	call	@@3
	jnc	@@1c
	call	@@3
	jnc	@@1b
	mov	eax, 100h
@@1a:	call	@@3
	adc	eax, eax
	jnc	@@1a
	mov	[edi], eax
	add	edi, 3
	jmp	@@1

@@1b:	call	@@3
	sbb	eax, eax
	or	al, 1
	sub	edx, eax
@@1c:	lea	edx, [edx*2+edx]
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
	xchg	esi, eax
	movsb
	movsb
	movsb
	xchg	esi, eax
	call	@@3
	jnc	@@1
	call	@@2
	add	[edi-3], al
	add	[edi-2], al
	add	[edi-1], al
	call	@@2
	add	[edi-2], al
	call	@@2
	add	[edi-1], al
	jmp	@@1

@@7:	xor	esi, esi
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

	; 1xx
	; 01
	; 001xx
	; 0001xxx
	; 0000xxxx

@@2:	xor	ecx, ecx
	xor	eax, eax
	inc	ecx
	call	@@3
	jc	@@2a
	call	@@3
	jc	@@2c
	inc	eax
	call	@@3
	jc	@@2a
	inc	ecx
	call	@@3
	jc	@@2a
	inc	ecx
@@2a:	call	@@3
	cmc
	sbb	edx, edx
	xor	eax, edx
@@2b:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@2b
	not	eax
	sub	eax, edx
@@2c:	ret
ENDP

@@Unpack2 PROC	; 00436980

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
	xor	ebx, ebx
@@1:	cmp	[@@DC], 0
	je	@@7
	shr	ebx, 1
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@1a:	jnc	@@1b
	dec	[@@SC]
	js	@@9
	dec	[@@DC]
	js	@@9
	movsb
	jmp	@@1

@@1b:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
	mov	ecx, edx
	shr	edx, 4
	and	ecx, 0Fh
	add	ecx, 3
	sub	[@@DC], ecx
	jb	@@9
	neg	edx
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	push	esi
	lea	esi, [edi+edx]
	rep	movsb
	pop	esi
	jmp	@@1

@@7:	xor	esi, esi
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

@@Unpack3 PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	xchg	ebx, eax
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	sub	[@@SC], 8
	jb	@@9
	lodsd
	xchg	ecx, eax
	lodsd
	sub	ecx, 8
	jb	@@9
	sub	[@@SC], ecx
	jb	@@9
	push	ecx
	add	ecx, esi
	push	ecx
	test	bl, bl
	je	@@2
@@1:	xor	eax, eax
	cmp	[@@DC], eax
	je	@@7
	sub	[@@L0], 2
	jb	@@9
	lodsw
	mov	ecx, eax
	shr	eax, 0Eh
	and	ch, 3Fh
	test	ecx, ecx
	je	@@1
	sub	[@@DC], ecx
	jb	@@9
	dec	eax
	js	@@1a
	lea	edx, [ecx*2+ecx]
	sub	[@@SC], edx
	jb	@@9
	mov	edx, esi
	dec	eax
	js	@@1b
	sub	[@@L0], ecx
	jb	@@9
	mov	esi, [@@L1]
@@1d:	movsb
	movsb
	movsb
	mov	al, [edx]
	inc	edx
	stosb
	dec	ecx
	jne	@@1d
@@1e:	mov	[@@L1], esi
	mov	esi, edx
	jmp	@@1

@@1a:	xor	eax, eax
	rep	stosd
	jmp	@@1

@@1b:	mov	esi, [@@L1]
@@1c:	movsb
	movsb
	movsb
	stosb
	dec	ecx
	jne	@@1c
	jmp	@@1e

@@7:	xor	esi, esi
@@9:	xchg	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@2:	xor	eax, eax
	cmp	[@@DC], eax
	je	@@7
	sub	[@@L0], 4
	jb	@@9
	lodsd
	sub	[@@DC], eax
	jb	@@9
	test	eax, eax
	je	@@2b
	xchg	ecx, eax
	lea	edx, [ecx*2+ecx]
	sub	[@@SC], edx
	jb	@@9
	push	esi
	mov	esi, [@@L1]
	mov	al, 0FFh
@@2a:	movsb
	movsb
	movsb
	stosb
	dec	ecx
	jne	@@2a
	mov	[@@L1], esi
	pop	esi
@@2b:	sub	[@@L0], 4
	jb	@@9
	lodsd
	sub	[@@DC], eax
	jb	@@9
	xchg	ecx, eax
	xor	eax, eax
	rep	stosd
	jmp	@@2
ENDP

ENDP

_tcd3_spd_decrypt PROC
	push	esi
	mov	esi, [esp+8]
	mov	eax, [esi+10h]
	mov	ecx, 4DFh
	mov	edx, eax
	and	ecx, eax
	shl	edx, 4
	shl	ecx, 2
	shr	eax, 2
	movzx	edx, dx
	and	eax, 0F731h
	sub	[esi+4], edx
	sub	[esi+8], ecx
	sub	[esi+0Ch], eax
	pop	esi
	ret	4
ENDP
