
; "Touhou 12.3" th123?.dat
; th123.exe
; 0041B1C0 archive_load
; 00409330 decode_table
; 00409370 decode_byte
; 0040CD88 file_decode_init
; 0041B8B2 file_decode

; "Twilight Frontier", "Tasofro"

	dw _conv_tasofro-$-2
_arc_tasofro PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC
@M0 @@L0

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ah
	jc	@@9a
	movzx	ebx, word ptr [esi]
	mov	edi, [esi+2]
	test	ebx, ebx
	je	@@9a
	imul	eax, ebx, -0Ah
	imul	edx, ebx, 0FEh
	add	eax, edi
	cmp	eax, edx
	ja	@@9a
	mov	[@@N], ebx
	lea	eax, [edi+6]
	add	esi, 6
	sub	esp, 270h*4
	call	_th123_crypt_init, eax
	call	_th123_crypt, esi, 4, 0

	call	_ArcParamNum, 0
	db 'tasofro', 0
	jnc	@@2a
	lea	eax, [edi+6]
	xor	eax, [esi]
@@2a:
	; 0x471E48C5 - th105?.dat, th123?.dat
	; 0x3B204EC5 - 6kinoko_?.dat, gs0?.dat

	mov	edx, eax
	shr	edx, 10h
	sub	dh, dl
	sub	dl, ah
	sub	ah, al
	sub	dh, dl
	sub	dl, ah
	cmp	al, 0C5h
	jne	@@9a
	cmp	dl, dh
	jne	@@9a
	shl	edx, 10h
	xchg	dx, ax
	mov	[@@L0], edx

	mov	[@@SC], edi
	sub	edi, 4
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 4, edi, 0
	jc	@@9
	lodsd
	mov	esi, [@@M]
	lea	edx, [esi+4]
	mov	[esi], eax
	call	_th123_crypt, edx, edi, 4
	lea	esp, [ebp-@@stk]
	mov	ecx, [@@SC]
	mov	ebx, [@@L0]
	mov	eax, ebx
	shr	ebx, 10h
	movzx	edx, ah
@@2b:	xor	[esi], al
	inc	esi
	add	eax, edx
	add	edx, ebx
	dec	ecx
	jne	@@2b
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, [@@SC]

@@1:	sub	[@@SC], 9
	jb	@@9
	movzx	ecx, byte ptr [esi+8]
	test	ecx, ecx
	je	@@9
	sub	[@@SC], ecx
	jb	@@9
	lea	edx, [esi+9]
	call	_ArcName, edx, ecx
	and	[@@D], 0
	mov	ebx, [esi+4]
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	test	ebx, ebx
	je	@@1a
	mov	ecx, ebx
	mov	eax, [esi]
	mov	edx, [@@D]
	shr	eax, 1
	or	al, 23h
@@1b:	xor	[edx], al
	inc	edx
	dec	ecx
	jne	@@1b
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	movzx	eax, byte ptr [esi+8]
	lea	esi, [esi+9+eax]
	call	_ArcBreak
	jnc	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_tasofro PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, '3vc'
	je	@@2
	cmp	eax, '2vc'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 11h
	jb	@@9
	movzx	ecx, byte ptr [esi]
	ror	ecx, 3
	lea	eax, [ecx-3]
	shr	eax, 1
	or	eax, [esi+0Dh]
	jne	@@9
	mov	edi, [esi+1]
	mov	eax, [esi+9]
	lea	edx, [edi+3]
	and	edx, -4
	cmp	eax, edi
	je	@@1a
	cmp	eax, edx
	jne	@@9
@@1a:	mov	edx, [esi+5]
	imul	eax, edx
	shl	eax, 2
	cmp	ebx, eax
	jb	@@9
	add	ecx, 20h-1
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]

	mov	edx, [esi+1]
	mov	eax, [esi+9]
	mov	ebx, [esi+5]
	sub	eax, edx
	cmp	byte ptr [esi], 18h
	lea	esi, [esi+11h]
	je	@@1c
@@1b:	mov	ecx, edx
	rep	movsd
	lea	esi, [esi+eax*4]
	dec	ebx
	jne	@@1b
	clc
	leave
	ret

@@1c:	mov	ecx, edx
@@1d:	movsb
	movsb
	movsb
	inc	esi
	dec	ecx
	jne	@@1d
	lea	esi, [esi+eax*4]
	dec	ebx
	jne	@@1c
	clc
	leave
	ret

@@2:	sub	ebx, 16h
	jb	@@9
	cmp	word ptr [esi], 1
	jne	@@9
	lea	eax, [ebx+2Ch]
	call	_MemAlloc, eax
	jc	@@9
	xchg	edi, eax
	push	edi
	mov	eax, 'FFIR'
	stosd
	lea	eax, [ebx+24h]
	stosd
	mov	eax, 'EVAW'
	stosd
	mov	eax, ' tmf'
	stosd
	push	10h
	pop	eax
	stosd
	movsd
	movsd
	movsd
	movsd
	add	esi, 6
	mov	eax, 'atad'
	stosd
	mov	eax, ebx
	stosd
	mov	ecx, ebx
	rep	movsb
	pop	edi
	add	ebx, 2Ch
	call	_ArcSetExt, 'vaw'
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret
ENDP
