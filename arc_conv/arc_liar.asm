
; "Shikkoku no Sharnoth" *.xfl
; Shikkoku no Sharnoth.exe
; 0042F450 wcg_open
; 00432220 unpack(_00432380, 1, 4)
; 00432380 getlen
; 00432E90 select(_00432EF0, _00433200)
; 00432EF0 unpack(_00433510, 2, 2)
; 00433200 unpack(_004337F0, 2, 2)
; 00432EC0 select(_00433510, _004337F0)
; 00433070 unpack(_00433510, 2, 4)
; 00433380 unpack(_004337F0, 2, 4)
; 00433510 getlen
; 004337F0 getlen
; 00433B40 getbits

	dw _conv_liar-$-2
_arc_liar PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@SC

	enter	@@stk+18h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	mov	eax, [esi]
	cmp	eax, 1474Ch
	je	_mod_liar_lwg
	cmp	eax, 1424Ch
	jne	@@9a
	pop	eax
	pop	ebx
	pop	ecx
	mov	[@@N], ecx
	imul	eax, ecx, 28h
	dec	ecx
	lea	edx, [ebx+0Ch]
	shr	ecx, 14h
	jne	@@9a
	mov	[@@P], edx
	cmp	ebx, eax
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 20h
	and	[@@D], 0
	mov	eax, [esi+20h]
	mov	ebx, [esi+24h]
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
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
ENDP

; db 'LG',1,0
; dd height, width
; dd item_count
; dd ?
; dd dir_size
; ...
; dd data_size

_mod_liar_lwg PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@SC

	lea	edx, [esi+0Ch]
	call	_FileRead, [@@S], edx, 0Ch
	jc	@@9a
	mov	ecx, [esi+0Ch]
	mov	ebx, [esi+14h]
	mov	[@@N], ecx
	lea	eax, [ecx-1]
	shr	eax, 14h
	jne	@@9a
	mov	eax, ecx
	mov	edx, ebx
	shl	eax, 8
	sub	eax, ecx
	imul	ecx, 12h
	sub	edx, ecx
	cmp	edx, eax
	ja	@@9a
	lea	eax, [ebx+1Ch]
	mov	[@@SC], ebx
	mov	[@@P], eax
	add	ebx, 4
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 18h, ebx, 0
	jc	@@9
	mov	edi, [@@M]
	push	6
	pop	ecx
	rep	movsd
	add	ebx, 18h
	mov	esi, edi
	call	_ArcCount, [@@N]
	call	_ArcDbgData, [@@M], ebx

@@1:	sub	[@@SC], 12h
	jb	@@9
	movzx	edi, byte ptr [esi+11h]
	add	esi, 12h
	sub	[@@SC], edi
	jb	@@9
	call	_ArcName, esi, edi
	call	_ArcSetExt, 'gcw'

	and	[@@D], 0
	mov	eax, [esi-9]
	mov	ebx, [esi-5]
	add	esi, edi
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

; "Kusarihime - Euthanasia" grp?\*.lim
; Khime.exe 00420C21

; lm1 4C 4D 01 00 10 00 00 00	; 565_raw, "Cho~Ita"
; lim 4C 4D 32 00 10 00 08 00	; 565, "Kusarihime - Euthanasia"
; lim 4C 4D 32 03 10 00 08 00	; 565+8, "Kusarihime - Euthanasia"
; lim 4C 4D 53 F5 18 00 08 00	; 8+8+8+8, "CannonBall"
; wcg 57 47 71 02 20 00 ?? ??	; 88+88

_conv_liar PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 10h
	jb	@@9
	cmp	eax, 'gcw'
	je	@@1
	cmp	eax, 'mil'
	je	@@2
	cmp	eax, '1ml'
	je	@@3
@@9:	stc
	leave
	ret

@@1:	cmp	word ptr [esi], 'GW'
	jne	@@9
	cmp	word ptr [esi+4], 20h
	jne	@@9
	mov	al, [esi+2]
	and	eax, 0Fh
	dec	eax
	jne	@@9
	movzx	eax, word ptr [esi+2]
	and	eax, 1C0h
	cmp	eax, 40h
	jne	@@9
	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 23h, edi, edx
	lea	edi, [eax+12h]
	mov	edx, [@@SC]
	lea	ecx, [esi+10h]
	sub	edx, 10h
	lea	eax, [edi+2]
	call	_wcg_unpack, eax, ebx, ecx, edx, 1, 4
	jc	@@1a
	call	_wcg_unpack, edi, ebx, ecx, edx, 1, 4
@@1a:	not	byte ptr [edi+3]
	add	edi, 4
	dec	ebx
	jne	@@1a
	clc
	leave
	ret

@@2:	cmp	word ptr [esi], 'ML'
	jne	@@9
	mov	edx, 80018h
	mov	al, [esi+2]
	sub	edx, [esi+4]
	test	al, 10h
	je	@@9
	and	al, 0Fh
	cmp	al, 3
	je	@@4
	cmp	al, 2
	jne	@@9
	cmp	edx, 8
	jne	@@9
	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 23h, edi, edx
	lea	edi, [eax+12h]
	mov	edx, [@@SC]
	lea	ecx, [esi+10h]
	sub	edx, 10h
	call	_wcg_unpack, edi, ebx, ecx, edx, 1, 4
	jc	@@2a
	lea	eax, [edi+3]
	call	_wcg_unpack, eax, ebx, ecx, edx, 0, 4
@@2a:	not	byte ptr [edi+3]
	movzx	eax, word ptr [edi]
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
	mov	[edi], ax
	shr	eax, 10h
	mov	[edi+2], al
	add	edi, 4
	dec	ebx
	jne	@@2a
	clc
	leave
	ret

@@3:	cmp	dword ptr [esi], 14D4Ch
	jne	@@9
	cmp	word ptr [esi+4], 10h
	jne	@@9
	xchg	eax, ebx
	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	mov	ebx, edi
	imul	ebx, edx
	lea	ecx, [ebx+ebx]
	cmp	eax, ecx
	jb	@@9
	call	_ArcTgaAlloc, 22h, edi, edx
	lea	edi, [eax+12h]
	add	esi, 10h
@@3a:	movzx	eax, word ptr [esi]
	add	esi, 2
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
	mov	[edi], ax
	shr	eax, 10h
	mov	[edi+2], al
	add	edi, 3
	dec	ebx
	jne	@@3a
	clc
	leave
	ret

@@4:	test	edx, edx
	jne	@@9
	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 23h, edi, edx
	lea	edi, [eax+12h]
	mov	edx, [@@SC]
	lea	ecx, [esi+10h]
	sub	edx, 10h
	lea	eax, [edi+3]
	call	_wcg_unpack, eax, ebx, ecx, edx, 0, 4
	jc	@@1a
	lea	eax, [edi+2]
	call	_wcg_unpack, eax, ebx, ecx, edx, 0, 4
	jc	@@1a
	lea	eax, [edi+1]
	call	_wcg_unpack, eax, ebx, ecx, edx, 0, 4
	jc	@@1a
	call	_wcg_unpack, edi, ebx, ecx, edx, 0, 4
@@4a:	not	byte ptr [edi+3]
	add	edi, 4
	dec	ebx
	jne	@@4a
	clc
	leave
	ret
ENDP

_wcg_unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L3 = dword ptr [ebp+24h]
@@A = dword ptr [ebp+28h]

@@L5 = dword ptr [ebp-4]
@@L4 = dword ptr [ebp-8]
@@C = dword ptr [ebp-0Ch]
@@L1 = dword ptr [ebp-10h]
@@L0 = dword ptr [ebp-14h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	push	0
	push	0
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	sub	[@@SC], 0Ch
	jb	@@9
	mov	ecx, [@@L3]
	mov	eax, [@@DC]
	shl	eax, cl
	cmp	eax, [esi]
	jne	@@9
	movzx	eax, word ptr [esi+8]
	mov	ebx, [esi+4]
	mov	edx, eax
	shl	edx, cl
	sub	[@@SC], edx
	jb	@@9
	lea	esi, [esi+edx+0Ch]
	sub	[@@SC], ebx
	jb	@@9
	mov	edx, [@@SC]
	mov	[@@L4], edx
	lea	edx, [esi+ebx]
	mov	[@@L5], edx
	mov	[@@SC], ebx
	push	eax
	lea	edx, [ecx-1]
	dec	eax
	js	@@9
	test	ah, dh
	jne	@@9
	xor	edx, edx
	cmp	eax, 1001h
	sbb	eax, eax
	lea	edx, [edx+eax*8+0Eh]
	add	eax, 4
	push	edx
	push	eax
	xor	ebx, ebx
@@1:	xor	eax, eax
	mov	ecx, [@@L0]
	cmp	[@@DC], eax
	je	@@7
	lea	edx, [eax+1]
	call	@@5
	test	eax, eax
	jne	@@1a
	lea	ecx, [eax+4]
	call	@@5
	lea	edx, [eax+2]
	xor	eax, eax
	mov	ecx, [@@L0]
	call	@@5
@@1a:	call	@@4
	cmp	eax, [@@C]
	jae	@@9
	mov	ecx, [@@SB]
	sub	[@@DC], edx
	jb	@@9
	cmp	[@@L3], 0
	je	@@1c
	movzx	eax, word ptr [ecx+0Ch+eax*2]
@@1b:	mov	[edi], ax
	add	edi, [@@A]
	dec	edx
	jne	@@1b
	jmp	@@1

@@1c:	mov	al, [ecx+0Ch+eax]
@@1d:	mov	[edi], al
	add	edi, [@@A]
	dec	edx
	jne	@@1d
	jmp	@@1

@@7:
@@9:	mov	ecx, [@@L5]
	xchg	eax, edi
	mov	edx, [@@L4]
	sub	eax, [@@DB]
	cmp	ecx, 1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	18h

@@3:	shl	bl, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@3a:	ret

	; 00432380 03 06 08
	; 00433510 03 06 0C
	; 004337F0 04 0E 10

@@4:	xchg	ecx, eax
	xor	eax, eax
	dec	ecx
	js	@@9
	je	@@4b
	inc	eax
	cmp	ecx, [@@L1]
	jb	@@5
@@4a:	cmp	ecx, 10h
	jae	@@9
	inc	ecx
	call	@@3
	jc	@@4a
	dec	ecx
@@5:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@5
	ret
@@4b:	call	@@3
	adc	eax, eax
	ret
ENDP
