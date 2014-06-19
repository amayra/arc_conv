
; "Adult Video King" cg.bin, voice.bin
; AVKING.exe
; 004352A0 decode

	dw _conv_avking-$-2
_arc_avking PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M, 8
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1, 8

	enter	@@stk, 0
	call	_unicode_ext, -1, offset inFileName
	cmp	eax, 'nib'
	jne	@@9a
	call	@@3
	test	ebx, ebx
	je	@@9
	call	@@4
	shr	ebx, 6
	mov	[@@L1+4], ebx
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	@@5
	and	[@@D], 0
	mov	ebx, [esi+4]
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, [@@L0]
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M+4]
	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	xor	ebx, ebx
	mov	[@@M], ebx
	mov	[@@M+4], ebx
	call	_ArcInputExt, 'kap'
	jc	@@3a
	xchg	esi, eax
	call	_FileGetSize, esi
	sub	eax, 8
	jb	@@3b
	xchg	edi, eax
	push	ecx
	push	ecx
	mov	edx, esp
	call	_FileRead, esi, edx, 8
	pop	eax
	pop	ecx
	jc	@@3b
	sub	eax, 'deh'
	lea	edx, [ecx-1]
	mov	[@@N], ecx
	shr	edx, 14h
	or	eax, edx
	jne	@@3b
	mov	eax, edi
	xor	edx, edx
	div	ecx
	test	edx, edx
	jne	@@3b
	mov	[@@L0], eax
	sub	eax, 8
	and	eax, NOT 10h
	jne	@@3b
	push	0
@@3c:	call	_MemAlloc, edi
	pop	ecx
	jc	@@3b
	mov	[@@M+ecx*4], eax
	call	_FileRead, esi, eax, edi
	jc	@@3b
	xchg	ebx, eax
@@3b:	call	_FileClose, esi
@@3a:	ret

@@4:	xor	ebx, ebx
	call	_ArcParam
	db 'avking_path', 0	; "data/cg/", "data/sound/voice/"
	jc	@@3a
	mov	[@@L1], eax
	call	_ArcParam
	db 'avking_map', 0
	jc	@@3a
	call	_FileCreate, eax, FILE_INPUT
	jc	@@3a
	xchg	esi, eax
	call	_FileGetSize, esi
	test	eax, eax
	je	@@3b
	test	al, 3Fh
	jne	@@3b
	xchg	edi, eax
	push	1
	jmp	@@3c

@@5b:	mov	edi, [@@M+4]
	add	[@@M+4], 40h
	dec	[@@L1+4]
	mov	edx, [@@L1]
	push	3Eh
	pop	ecx
@@5a:	movzx	ebx, word ptr [edx]
	add	edx, 2
	test	ebx, ebx
	je	@@5c
	movzx	eax, byte ptr [edi]
	inc	edi
	cmp	eax, ebx
	jne	@@5
	dec	ecx
	jne	@@5a
@@5:	cmp	[@@L1+4], 0
	jne	@@5b	
	ret

@@5c:	call	_ArcName, edi, ecx
	ret
ENDP

_conv_avking PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 8
	jb	@@9
	mov	eax, [esi]
	mov	edx, [esi+4]
	sub	eax, 'SggO'
	sub	dh, 2
	or	eax, edx
	jne	@@1
	call	_ArcSetExt, 'ggo'
@@9:	stc
	leave
	ret

@@1:	cmp	dword ptr [esi], 'xcs'
	jne	@@1a
	lea	edx, [esi+8]
	lea	ecx, [ebx-8]
	call	@@SCX, edx, ecx
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@1a:	sub	esp, 14h
	cmp	dword ptr [esi], 'zih'
	je	@@1b
	cmp	dword ptr [esi], 'pih'
	jne	@@1c
	sub	ebx, 18h
	jb	@@1c
	mov	eax, [esi+10h]
	add	esi, 18h
	test	eax, eax
	je	@@1b
	sub	eax, 18h
	jb	@@1c
	push	ebx
	push	esi
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	call	@@2
	pop	esi
	pop	ebx
	mov	eax, [esi+10h-18h]
	sub	eax, 18h
	add	esi, eax
	sub	ebx, eax
	jb	@@1c
	call	_ArcSetExt, 'mna'
	mov	byte ptr [edx], '_'
@@1b:	call	@@2
@@1c:	clc
	leave
	ret

@@2:	lea	ecx, [esi+4]
	cmp	dword ptr [esi], 'zih'
	jne	@@2e
	push	18h
	pop	edx
	cmp	dword ptr [ecx], 64h
	jne	@@2a
	add	ecx, 4
	add	edx, 34h
@@2a:	sub	ebx, edx
	jb	@@2e
	add	esi, edx

	mov	eax, 0136A9326h
	xor	eax, [ecx+10h]
	cmp	eax, ebx
	jb	$+3
	xchg	eax, ebx
	push	eax
	mov	eax, 019739D6Ah
	mov	edx, 0375A8436h
	xor	eax, [ecx+0Ch]
	xor	edx, [ecx+8]
	push	eax
	push	edx
	cmp	edx, 2
	jae	@@2f
	mov	edi, 0AA5A5A5Ah
	mov	edx, 0AC9326AFh
	xor	edi, [ecx]
	xor	edx, [ecx+4]
	mov	ebx, edi
	imul	ebx, edx
	shl	ebx, 2
	cmp	ebx, eax
	jne	@@2f
	call	_ArcTgaAlloc, 40h+23h, edi, edx
	jc	@@2f
	lea	edi, [eax+12h]
	cmp	dword ptr [esp], 0
	jne	@@2g
	call	_null_unpack, edi, ebx, esi, dword ptr [esp+8]
	jmp	@@2h

@@2g:	call	_MemAlloc, ebx
	jc	@@2h
	xchg	esi, eax
	call	_lzss_unpack, esi, ebx, eax, dword ptr [esp+8]
	shr	ebx, 2
	mov	ecx, ebx
	lea	edx, [ebx*2+ebx]
	push	esi
@@2i:	mov	al, [esi]
	stosb
	mov	al, [esi+ebx]
	stosb
	mov	al, [esi+ebx*2]
	stosb
	mov	al, [esi+edx]
	stosb
	inc	esi
	dec	ecx
	jne	@@2i
	call	_MemFree

@@2h:	call	_ArcTgaSave
	call	_ArcTgaFree
@@2f:	add	esp, 0Ch
@@2e:	ret

@@SCX PROC
	push	ebx
	push	esi
	push	edi
	mov	esi, [esp+14h]
	mov	edi, [esp+10h]
	test	esi, esi
	je	@@9
	xor	ebx, ebx
	xor	ecx, ecx
@@1:	mov	al, byte ptr [@@T+ecx]
	add	al, bl
	xor	[edi+ebx], al
	inc	ecx
	inc	ebx
	cmp	ecx, 0Bh
	sbb	eax, eax
	and	ecx, eax
	dec	esi
	jne	@@1
@@9:	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@T	dd 087F2B3A9h, 06713AFDCh, 000EC91D5h
ENDP

ENDP
