
; "Manbiki, Dame. Zettai!!" *.pak

	dw _conv_eagls-$-2
_arc_eagls PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	enter	@@stk, 0
	call	_unicode_ext, -1, offset inFileName
	cmp	eax, 'kap'
	jne	@@9a
	call	@@3
	test	ebx, ebx
	je	@@9
	mov	esi, [@@M]
	lea	edi, [ebx-4]
	mov	eax, [esi+edi]
@@2a:	imul	eax, 343FDh
	add	eax, 269EC3h
	lea	edx, [eax+eax]
	shr	edx, 11h
	imul	ecx, edx, 1642Dh	; div 0x2E
	shr	ecx, 11h+5
	imul	ecx, 2Eh
	sub	edx, ecx
	mov	cl, [@@T+edx]
	xor	[esi], cl
	inc	esi
	dec	edi
	jne	@@2a
	mov	esi, [@@M]
	mov	edx, esi
	xor	ecx, ecx
@@2b:	cmp	byte ptr [edx], 0
	je	@@2c
	inc	ecx
	add	edx, [@@L0]
	cmp	ecx, 2710h
	jb	@@2b
@@2c:	test	ecx, ecx
	je	@@9
	mov	[@@N], ecx
	call	_ArcCount, ecx
	call	_ArcDbgData, esi, ebx

@@1:	cmp	[@@L0], 28h
	je	@@1b
	call	_ArcName, esi, 14h
	and	[@@D], 0
	mov	eax, [esi+14h]
	mov	ebx, [esi+18h]
	xor	edx, edx
	jmp	@@1c

@@1b:	call	_ArcName, esi, 18h
	and	[@@D], 0
	mov	eax, [esi+18h]
	mov	edx, [esi+1Ch]
	mov	ebx, [esi+20h]
	cmp	dword ptr [esi+24h], 0
	jne	@@1a
@@1c:	sub	eax, 174Bh
	sbb	edx, 0
	jb	@@1a
	call	_FileSeek64, [@@S], eax, edx, 0
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
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	xor	ebx, ebx
	mov	[@@M], ebx
	call	_ArcInputExt, 'xdi'
	jc	@@3a
	xchg	esi, eax
	call	_FileGetSize, esi
	mov	edi, eax
	xor	edx, edx
	mov	ecx, 2710h
	div	ecx
	cmp	edx, 4
	jne	@@3b
	cmp	eax, 28h
	je	@@3c
	cmp	eax, 1Ch
	jne	@@3b
@@3c:	mov	[@@L0], eax
	call	_MemAlloc, edi
	jc	@@3b
	mov	[@@M], eax
	call	_FileRead, esi, eax, edi
	jc	@@3b
	xchg	ebx, eax
@@3b:	call	_FileClose, esi
@@3a:	ret

@@T	db '1qaz2wsx3edc4rfv5tgb6yhn7ujm8ik,9ol.0p;/-@:^[]'
ENDP

_conv_eagls PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'rg'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	dec	ebx
	jle	@@9
	call	@@Decode, esi, ebx
	call	_lzss_unpack, 0, -1, esi, ebx
	test	eax, eax
	xchg	edi, eax
	je	@@9
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	call	_lzss_unpack, edi, eax, esi, ebx
	xchg	ebx, eax
	call	_ArcSetExt, 'pmb'
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

@@Decode PROC
	push	ebx
	push	esi
	push	edi
	mov	ebx, [esp+14h]
	mov	esi, [esp+10h]
	movzx	ecx, byte ptr [esi+ebx]
	xor	ecx, 75BD924h
	mov	eax, 174Bh
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax

@@1:	mov	eax, 5E4789C9h
	imul	ecx
	imul	ecx, 0BC8Fh
	sar	edx, 0Eh
	mov	eax, edx
	shr	eax, 1Fh
	add	eax, edx
	imul	eax, 7FFFFFFFh
	sub	ecx, eax
	test	ecx, ecx
	jg	@@1a
	add	ecx, 7FFFFFFFh
@@1a:	mov	eax, ecx
	shr	eax, 1Fh
	add	eax, ecx
	shr	eax, 17h
	mov	edx, eax
	imul	eax, 0AAABh
	shr	eax, 13h
	lea	eax, [eax*2+eax]
	shl	eax, 2
	sub	edx, eax
	mov	al, [@@T+edx]
	xor	[esi], al
	inc	esi
	dec	ebx
	jne	@@1
@@9:	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@T	db 'EAGLS_SYSTEM'
ENDP

ENDP

