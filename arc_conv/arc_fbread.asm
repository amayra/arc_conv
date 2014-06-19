
; "Drill Milky Punch", "Ragnarok Battle Offline" Data\*.pac
; dMp.exe 004121A0
; rbo.exe 004222B0

; French-Bread

	dw 0
_arc_fbread PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	edx
	pop	ebx
	mov	[@@L0], edx
	shr	edx, 1
	jne	@@9a
	mov	edi, offset @@T
@@2a:	mov	eax, [edi+4]
	xor	eax, ebx
	shr	eax, 14h
	je	@@2b
	add	edi, 0Ah
	cmp	byte ptr [edi], 0
	jne	@@2a
	jmp	@@9a

@@2b:	xor	ebx, [edi+4]
	mov	[@@L1], edi
	mov	[@@N], ebx
	lea	eax, [ebx-1]
	shr	eax, 14h
	jne	@@9a
	movzx	ecx, byte ptr [edi]
	movzx	eax, word ptr [edi+1]
	call	_fbread_header, ebx, ecx, eax, dword ptr [edi+4]
	test	eax, eax
	je	@@9
	mov	[@@M], eax
	xchg	esi, eax

@@1:	movzx	ebx, byte ptr [edi]
	call	_ArcName, esi, ebx
	and	[@@D], 0
	movzx	edx, byte ptr [edi+2]
	add	ebx, esi
	mov	eax, edx
	xor	eax, 1
	mov	eax, [ebx+eax*4]
	mov	ebx, [ebx+edx*4]
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	cmp	[@@L0], 0
	jne	@@1a
	movzx	ecx, byte ptr [edi]
	movzx	edx, byte ptr [edi+3]
	movzx	eax, word ptr [edi+8]
	cmp	eax, ebx
	jb	$+4
	mov	eax, ebx
	call	_fbread_crypt, esi, ecx, edx, [@@D], eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	movzx	ecx, byte ptr [edi]
	lea	esi, [esi+ecx+8]
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@T:	; "Drill Milky Punch"
	db 38h, -54h, 0, 0
	dd 0FA261EFBh
	dw 25E0h
	; "Ragnarok Battle Offline"
	db 3Ch, 3Dh, 1, 3
	dd 0E3DF59ACh
	dw 2173h

	db 0
ENDP

; "Melty Blood Act Cadenza" ??.p
; mbacPC.exe

	dw 0
_arc_mbac PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	enter	@@stk+18h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 18h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ecx
	; "PKFileInfo"
	sub	eax, 'iFKP'
	sub	edx, 'nIel'
	sub	ecx, 'of'
	or	eax, edx
	shl	ecx, 8
	or	eax, ecx
	jne	@@9a
	pop	ecx
	pop	ecx
	pop	eax
	cmp	ecx, 3
	jae	@@9a
	mov	ebx, 0E3DF59ACh
	mov	[@@L0], ecx
	xor	eax, ebx
	lea	ecx, [eax-1]
	shr	ecx, 14h
	jne	@@9a
	mov	[@@N], eax
	call	_fbread_header, eax, 40h, 14Eh, ebx
	test	eax, eax
	je	@@9
	mov	[@@M], eax
	xchg	esi, eax

@@1:	call	_ArcName, esi, 40h
	and	[@@D], 0
	mov	ebx, [esi+44h]
	call	_FileSeek, [@@S], dword ptr [esi+40h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	test	ebx, ebx
	je	@@1a
	mov	edx, [@@L0]
	mov	ecx, ebx
	dec	edx
	je	@@1a
	mov	eax, 7B9h
	mov	edi, [@@D]
	cmp	ecx, eax
	jb	$+3
	xchg	ecx, eax
	dec	edx
	jne	@@1c
@@1b:	xor	byte ptr [edi], 0CAh
	inc	edi
	dec	ecx
	jne	@@1b
	jmp	@@1a

@@1c:	call	_fbread_crypt, esi, 40h, 3, edi, ecx
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 48h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_fbread_header PROC

@@N = dword ptr [ebp+14h]
@@L0 = dword ptr [ebp+18h]
@@L1 = dword ptr [ebp+1Ch]
@@L2 = dword ptr [ebp+20h]
@@M = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	push	ecx
	mov	ebx, [@@L0]
	add	ebx, 8
	imul	ebx, [@@N]
	mov	eax, esp
	push	ebp
	mov	ebp, [ebp]
	call	_ArcMemRead, eax, 0, ebx, 0
	pop	ebp
	jc	@@9
	mov	esi, [@@M]
	xor	edx, edx
@@1:	xor	ecx, ecx
@@2:	mov	eax, edx
	imul	eax, ecx
	lea	eax, [eax*2+eax]
	add	eax, [@@L1]
	xor	[esi+ecx], al
	inc	ecx
	cmp	ecx, [@@L0]
	jb	@@2
	add	esi, ecx
	movzx	ecx, byte ptr [@@L1+1]
	mov	eax, [@@L2]
	xor	dword ptr [esi+ecx*4], eax
	inc	edx
	add	esi, 8
	cmp	edx, [@@N]
	jb	@@1
	mov	esi, [@@M]
	mov	ebp, [ebp]
	call	_ArcCount, edx
	call	_ArcDbgData, esi, ebx
@@9:	pop	eax
	pop	ebp
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

_fbread_crypt PROC
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [ebp+14h]
	xor	edx, edx
@@1:	cmp	byte ptr [esi+edx], 0
	je	@@1a
	inc	edx
	cmp	edx, [ebp+18h]
	jb	@@1
@@1a:	test	edx, edx
	je	@@9

	xor	ebx, ebx
	mov	edi, [ebp+20h]
	mov	ecx, [ebp+24h]
	mov	ebp, [ebp+1Ch]
	test	ecx, ecx
	je	@@9
@@2:	movzx	eax, byte ptr [esi+ebx]
	add	eax, ebp
	xor	[edi], al	
	inc	edi
	inc	ebx
	inc	ebp
	cmp	ebx, edx
	sbb	eax, eax
	and	ebx, eax
	dec	ecx
	jne	@@2
@@9:	pop	ebp
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

; "American Sexy Channel 3" data\3ch.dat

; 3CH.EXE
; 0044AE40 file_decrypt

	dw _conv_asc3-$-2
_arc_asc3 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	mov	edi, 0FA261EFBh
	pop	eax
	xor	eax, edi
	lea	ecx, [eax-1]
	mov	[@@N], eax
	shr	ecx, 14h
	jne	@@9a
	lea	ebx, [eax*4+eax]
	shl	ebx, 3
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	eax, [ebx+4]
	cmp	[esi+24h], eax
	jne	@@9
	call	@@5
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	call	_ArcName, esi, 20h
	and	[@@D], 0
	mov	ebx, [esi+20h]
	call	_FileSeek, [@@S], dword ptr [esi+24h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	mov	eax, 2C00h
	cmp	eax, ebx
	jb	$+4
	mov	eax, ebx
	call	_fbread_crypt, esi, 20h, 0, [@@D], eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 28h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5:	push	ebx
	push	esi
	mov	ebx, [@@N]
@@5a:	mov	al, -54h
	push	20h
	pop	ecx
@@5b:	xor	[esi], al
	inc	esi
	add	al, 5
	dec	ecx
	jne	@@5b
	xor	[esi], edi
	add	esi, 8
	dec	ebx
	jne	@@5a
	pop	esi
	pop	ebx
	ret
ENDP

_conv_asc3 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'gmi'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 1Ch
	jb	@@9
	mov	ecx, [esi+4]
	shr	ecx, 1
	jne	@@9
	cmc
	sbb	ecx, ecx
	and	ecx, 20h
	push	ecx
	mov	ecx, [esi+10h]
	mov	edi, [esi+14h]
	mov	edx, [esi+18h]
	add	esi, 1Ch
	mov	eax, edi
	imul	eax, edx
	cmp	ecx, 8
	je	@@1b
	cmp	ecx, 18h
	jne	@@9
	lea	eax, [eax*2+eax]
	cmp	ebx, eax
	jne	@@9
	pop	ecx
	add	ecx, 22h
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
@@1a:	mov	ecx, ebx
	rep	movsb
	clc
	leave
	ret

@@1b:	push	eax
	mov	ecx, [esi-1Ch+0Ch]
	lea	eax, [ecx-1]
	shl	ecx, 2
	shr	eax, 8
	pop	eax
	jne	@@9
	sub	ebx, ecx
	jb	@@9
	cmp	ebx, eax
	jne	@@9
	pop	ecx
	add	ecx, 38h
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	mov	ecx, [esi-1Ch+0Ch]
	mov	[edi-12h+5], cx
	rep	movsd
	jmp	@@1a
ENDP
