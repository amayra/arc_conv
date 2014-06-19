
; "Shirotsume Souwa ~Episode of the Clovers~ (DC)" *.mrg

; Dreamcast processor = SH4
; 8C010000 rom_start ("1ST_READ.BIN")
; 8C05BBD4 crc16
; 8C06ECD0 scr_crypt
; 8C09FAB8 a8_ext_tab

	dw _conv_mrg-$-2
_arc_mrg PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L1, 0Ch

	enter	@@stk, 0
	and	[@@M], 0
	call	_unicode_ext, -1, offset inFileName
	cmp	eax, 'grm'
	jne	@@2a
	call	@@3
@@2a:	mov	eax, [@@L1]
	mov	esi, [@@M]
	mov	[@@L1+8], eax
	test	esi, esi
	je	_mod_mrg_single
	call	_ArcCount, [@@N]

@@1:	mov	edx, [@@L1+8]
	mov	ecx, [@@L1+4]
	test	edx, edx
	je	@@1b
	lea	eax, [edx+ecx]
	sub	ecx, 4
	mov	[@@L1+8], eax
	call	_ArcName, edx, ecx
@@1b:	and	[@@D], 0
	movzx	ebx, word ptr [esi+4]
	test	ebx, ebx
	je	@@1c
	dec	ebx
	movzx	eax, word ptr [esi+6]
	shl	ebx, 0Bh
	and	eax, 7FFh
	add	ebx, eax
@@1c:	movzx	edx, word ptr [esi+2]
	movzx	eax, word ptr [esi]
	shl	edx, 4
	test	dx, dx
	jne	@@1a
	add	eax, edx
	shl	eax, 0Bh
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 8
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@L1]
	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	and	[@@L1], 0
	call	_ArcInputExt, 'deh'
	jc	@@3a
	xchg	esi, eax
	call	_FileGetSize, esi
	mov	ebx, eax
	ror	eax, 3
	dec	eax
	dec	eax
	mov	[@@N], eax
	dec	eax
	shr	eax, 14h
	jne	@@3b
	call	_MemAlloc, ebx
	jc	@@3b
	mov	[@@M], eax
	call	_FileRead, esi, eax, ebx
	lea	ecx, [@@M]
	jc	@@3c
	call	_FileClose, esi

	call	_ArcInputExt, 'man'
	jc	@@3a
	xchg	esi, eax
	call	_FileGetSize, esi
	test	eax, eax
	mov	ebx, eax
	jle	@@3b
	xor	edx, edx
	div	[@@N]
	test	edx, edx
	jne	@@3b
	mov	[@@L1+4], eax
	sub	eax, 10h
	and	eax, NOT 10h
	jne	@@3b
	call	_MemAlloc, ebx
	jc	@@3b
	mov	[@@L1], eax
	call	_FileRead, esi, eax, ebx
	jnc	@@3b
	lea	ecx, [@@L1]
@@3c:	push	dword ptr [ecx]
	and	dword ptr [ecx], 0
	call	_MemFree
@@3b:	call	_FileClose, esi
@@3a:	ret
ENDP

_mod_mrg_single PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L1, 0Ch

	call	_MemFree, [@@L1]

	lea	esp, [ebp-@@stk-4]
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	ebx
	lea	eax, [ebx-1]
	shr	eax, 0Ch	; 14h+3-0Bh
	jne	@@9a
	mov	ecx, ebx
	shl	ecx, 0Bh
	sub	ecx, 4
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 4, ecx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	[esi], ebx
	xor	ecx, ecx
	shl	ebx, 8
@@2a:	mov	eax, [esi+ecx*8]
	mov	edx, [esi+ecx*8+4]
	sub	eax, edx
	inc	edx
	shr	edx, 1
	or	eax, edx
	je	@@2b
	inc	ecx
	dec	ebx
	jne	@@2a
@@2b:	test	ecx, ecx
	je	@@9
	mov	[@@N], ecx
	call	_ArcCount, ecx

@@1:	and	[@@D], 0
	movzx	ebx, word ptr [esi+4]
	movzx	eax, word ptr [esi+6]
	shl	ebx, 0Bh
	and	eax, 7FFh
	add	ebx, eax
	movzx	eax, word ptr [esi]
	movzx	edx, word ptr [esi+2]
	shl	eax, 0Bh
	test	dh, 0F8h
	jne	@@1a
	add	eax, edx
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 8
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_mrg PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	call	_ArcLocal, 0
	xchg	edi, eax
	jnc	@@1a
	call	_ArcParamNum, 0
	db 'mrg', 0
	mov	[edi], eax
@@1a:	mov	eax, [edi]
	dec	eax
	je	@@1
	dec	eax
	je	@@2
@@9:	stc
	leave
	ret

@@1:	test	ebx, ebx
	je	@@1c
	mov	edi, esi
	mov	ecx, ebx
	push	6Ch
	pop	eax
@@1b:	xor	[edi], al
	inc	edi
	imul	eax, 4Dh
	add	eax, 35h
	dec	ecx
	jne	@@1b
@@1c:	call	_ArcSetExt, 'txt'
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@2:	sub	ebx, 0Dh
	jb	@@9
	mov	eax, [esi]
	movzx	edx, ah
	mov	ah, [esi+0Ch]
	cmp	eax, 40000010h
	jne	@@9
	cmp	edx, 43h
	je	@@2a
	dec	edx
	shr	edx, 1
	ror	edx, 3
	cmp	edx, 2
	jb	@@2b
	cmp	edx, 4
	jne	@@9
@@2a:	movzx	eax, byte ptr [esi+1]
	mov	ah, 0Fh
	cmp	al, 43h
	jne	@@2b
	and	ah, al
	shr	al, 4
	shl	eax, 8
	add	eax, '00$'
	call	_ArcSetExt, eax
	mov	byte ptr [edx], '_'
@@2b:
	cmp	word ptr [esi+6], 105h
	jne	@@9
	movzx	ebx, word ptr [esi+4]
	movzx	eax, word ptr [esi+8]
	movzx	edx, word ptr [esi+0Ah]
	xchg	al, ah
	xchg	dl, dh
	xchg	bl, bh
	lea	edi, [eax+3Fh]
	lea	ecx, [edx+3Fh]
	shr	edi, 6
	and	ecx, -40h
	imul	edi, ecx
	cmp	ebx, edi
	jne	@@9
	call	_ArcTgaAlloc, 23h, eax, edx
	xchg	edi, eax
	shl	ebx, 6+2
	add	edi, 12h
	call	_MemAlloc, ebx
	jc	@@9
	xchg	esi, eax
	shr	ebx, 2
	call	@@Unpack, esi, ebx, eax, [@@SC]
	movzx	edx, word ptr [edi-12h+0Eh]
	movzx	eax, word ptr [edi-12h+0Ch]
	call	@@Deblock, edi, esi, eax, edx
	call	_MemFree, esi
	clc
	leave
	ret

@@Deblock PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@W = dword ptr [ebp+1Ch]
@@H = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@S]
	push	[@@W]
@@1:	mov	edi, [@@D]
	mov	eax, [@@L0]
	push	40h
	pop	ebx
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	lea	eax, [edi+ebx*4]
	sub	[@@L0], ebx
	mov	[@@D], eax

	mov	eax, [@@W]
	sub	eax, ebx
	shl	eax, 2
	mov	[@@S], eax

	lea	eax, [ebx-40h]
	mov	edx, [@@H]
	neg	eax
@@2:	mov	ecx, ebx
	rep	movsd
	add	edi, [@@S]
	lea	esi, [esi+eax*4]
	dec	edx
	jne	@@2
	mov	eax, [@@H]
	neg	eax
	and	eax, 3Fh
	shl	eax, 6
	lea	esi, [esi+eax*4]
	cmp	[@@L0], edx
	jne	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]
@@L2 = dword ptr [ebp-0Ch]

	push	ebx
	push	esi
	push	edi
	enter	10Ch, 0
	xor	eax, eax
	mov	edi, esp
	lea	ecx, [eax+41h]
	rep	stosd
	xchg	ebx, eax

	mov	edi, [@@DB]
	mov	esi, [@@SB]
	sub	[@@SC], 0Dh
	jb	@@9
	mov	eax, [esi]
	add	esi, 0Dh
	mov	[@@L0], eax

	; 0 - 565, 1 - 1555, 4 - 4444

	cmp	ah, 43h
	jne	$+4
	mov	ah, 0
	shr	ah, 4
	cmp	ah, 1
	sbb	edx, edx
	shl	edx, 18h
	mov	[@@L1], edx

@@1:	cmp	[@@DC], 0
	je	@@7
	dec	[@@SC]
	js	@@9
	mov	eax, [@@L2]
	lodsb
	test	ah, ah
	jns	@@3a
	ror	ax, 4
	ror	ah, 4
@@3a:	mov	[@@L2], eax
	movzx	ecx, al
	shr	ecx, 2
	inc	ecx
	and	eax, 3
	jne	@@1a
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, [@@L1]
	cmp	edi, [@@DB]
	je	@@1g
	mov	eax, [edi-4]
@@1g:	rep	stosd
	jmp	@@1

@@1a:	dec	eax
	jne	@@1b
	mov	eax, [@@L0]
	push	-200h
	pop	edx
	and	ah, 0Fh
	cmp	ah, 2
	je	$+4
	sar	edx, 1
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jc	@@1f
	push	ebx
	xchg	ebx, eax
	mov	eax, [@@L1]
@@1e:	stosd
	dec	ecx
	je	@@1h
	add	ebx, 4
	jnc	@@1e
@@1h:	pop	ebx
	test	ecx, ecx
	je	@@1
@@1f:	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsd
	xchg	esi, eax
	jmp	@@1

@@1b:	dec	eax
	jne	@@1c
	dec	[@@DC]
	js	@@9
	mov	eax, [esp+ecx*4-4]
	stosd
	jmp	@@1

@@1c:	lea	eax, [ecx+ecx]
	sub	[@@DC], ecx
	jb	@@9
	cmp	byte ptr [@@L0+1], 43h
	je	@@3b
	sub	[@@SC], eax
	jb	@@9
@@1d:	movzx	eax, word ptr [esi]
	xchg	al, ah
	add	esi, 2

	mov	edx, [@@L0]
	test	dh, 0F0h
	jne	@@2a
	; 565
	ror	eax, 5
	shr	ax, 1
	sbb	edx, edx
	shl	ax, 3
	and	edx, 40404h
	shl	ah, 3
	rol	eax, 8
	add	eax, edx
	mov	edx, 0C0C0C0C0h
	and	edx, eax
	shr	edx, 6
	add	eax, edx
	or	eax, [@@L1]
	jmp	@@2b

@@2a:	test	dh, 40h
	jne	@@2c
	; 1555
	ror	eax, 10
	shl	al, 3
	sbb	ah, ah
	rol	eax, 16
	shr	ax, 3
	shl	ah, 3
	mov	edx, 0E0E0E0E0h
	and	edx, eax
	shr	edx, 5
	or	eax, edx
	jmp	@@2b

@@2c:	; 4444
	ror	eax, 8
	shl	ax, 4
	shr	al, 4
	rol	eax, 10h
	shr	ax, 4
	shr	al, 4
	imul	eax, 11h
@@2b:
	mov	[esp+ebx*4], eax
	mov	[edi], eax
	inc	ebx
	add	edi, 4
	and	ebx, 3Fh
	dec	ecx
	jne	@@1d
	jmp	@@1

@@3b:	sub	[@@SC], ecx
	jb	@@9
@@3c:	mov	eax, [@@L2]
	xor	edx, edx
	lodsb
	add	ah, 10h
	jc	@@3d
	dec	[@@SC]
	js	@@9
	mov	ah, al
	mov	dh, 0F0h
	lodsb
	or	dh, al
	shr	eax, 4
@@3d:	mov	[@@L2], edx
	shl	ah, 4
	ror	eax, 4
	shl	ax, 4
	rol	eax, 4
	imul	eax, 11h
	or	eax, [@@L1]
	mov	[esp+ebx*4], eax
	mov	[edi], eax
	inc	ebx
	add	edi, 4
	and	ebx, 3Fh
	dec	ecx
	jne	@@3c
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

ENDP
