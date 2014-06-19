
; "Biniku no Kaori -Netori Netorare Yari Yarare-" *.arc
; AI6WIN.exe
; 0040FD78 reg_test
; 00412980 arc_open
; 00459BF0 lzss_unpack
; 004695D0 rmt32_unpack
; 00472800 vm_loop

	dw _conv_ai6-$-2
_arc_ai6 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	lodsd
	mov	ebx, eax
	dec	eax
	shr	eax, 14h
	jne	@@9a
	mov	[@@N], ebx
	imul	ebx, 110h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	edx, [@@N]
	call	@@5
	call	_ArcDbgData, esi, ebx
	lea	eax, [ebx+4]
	bswap	eax
	cmp	[esi+10Ch], eax
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	mov	ebx, 104h
	call	_ArcName, esi, ebx
	lea	esi, [esi+ebx+0Ch]
	and	[@@D], 0
	mov	ebx, [esi-0Ch]
	mov	edi, [esi-8]
	mov	eax, [esi-4]
	bswap	ebx
	bswap	edi
	bswap	eax
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	cmp	ebx, edi
	jne	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	call	_ArcMemRead, eax, edi, ebx, 0
	call	_lzss_unpack, [@@D], edi, edx, eax
	jmp	@@1b

@@5 PROC
	push	ebx
	push	esi
@@1:	mov	ecx, 104h
	mov	edi, esi
	mov	ebx, ecx
	xor	eax, eax
	repne	scasb
	sub	edi, esi
	mov	eax, edi
	add	ebx, esi
	dec	edi
	je	@@3
@@2:	sub	[esi], al
	inc	esi
	dec	eax
	dec	edi
	jne	@@2
@@3:	lea	esi, [ebx+0Ch]
	dec	edx
	jne	@@1
	pop	esi
	pop	ebx
	ret
ENDP

ENDP

_conv_ai6 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'tmr'
	je	@@1
	cmp	eax, 'bka'
	je	@@2
	cmp	eax, 'dsv'
	je	@@3
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 14h
	jb	@@9
	cmp	dword ptr [esi], 20544D52h
	jne	@@9
	mov	[@@SC], ebx
	; [esi+4], [esi+8] - x, y (?)
	mov	edi, [esi+0Ch]
	mov	edx, [esi+10h]
	mov	ebx, edi
	imul	ebx, edx
	shl	ebx, 2
	call	_ArcTgaAlloc, 3, edi, edx
	lea	edi, [eax+12h]
	add	esi, 14h
	call	_lzss_unpack, edi, ebx, esi, [@@SC]
	push	4
	movzx	eax, word ptr [edi-12h+0Ch]
	movzx	edx, word ptr [edi-12h+0Eh]
	call	_ai6_add_top, edi, eax, edx
	clc
	leave
	ret

@@2:	sub	ebx, 20h
	jb	@@9
	cmp	dword ptr [esi], ' BKA'
	jne	@@9
	mov	[@@SC], ebx

	mov	edi, [esi+18h]
	mov	edx, [esi+1Ch]
	sub	edi, [esi+10h]
	sub	edx, [esi+14h]
	mov	ebx, edi
	imul	ebx, edx

	push	4
	mov	eax, [esi+8]
	pop	ecx
	shl	eax, 1
	je	@@2a
	dec	ecx
	cmp	eax, 400000FFh*2
	jne	@@9
@@2a:	imul	ebx, ecx
	push	ecx
	dec	ecx
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	mov	eax, [esi+14h]
	shl	eax, 10h
	mov	ax, [esi+10h]
	add	esi, 20h
	mov	[edi-12h+8], eax
	call	_lzss_unpack, edi, ebx, esi, [@@SC]
	movzx	eax, word ptr [edi-12h+0Ch]
	movzx	edx, word ptr [edi-12h+0Eh]
	call	_ai6_add_bottom, edi, eax, edx
	clc
	leave
	ret

@@3:	sub	ebx, 8
	jb	@@9
	lodsd
	cmp	eax, '1DSV'
	jne	@@9
	lodsd
	sub	ebx, eax
	jb	@@9
	add	esi, eax
	cmp	ebx, 4
	jb	@@9
	cmp	dword ptr [esi], 0BA010000h
	jne	@@9
	call	_ArcSetExt, 'gpm'
	call	_ArcData, esi, ebx
	clc
	leave
	ret
ENDP

_ai6_add_top PROC

@@D = dword ptr [ebp+14h]
@@W = dword ptr [ebp+18h]
@@H = dword ptr [ebp+1Ch]
@@A = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ebx, [@@A]
	mov	edi, [@@D]
	neg	ebx
	mov	ecx, [@@W]
	sub	edi, ebx
	dec	ecx
	je	@@2
	imul	ecx, ebx
@@1:	mov	al, [edi+ebx]
	add	[edi], al
	inc	edi
	inc	ecx
	jne	@@1
@@2:	mov	ecx, [@@H]
	imul	ebx, [@@W]
	dec	ecx
	je	@@9
	imul	ecx, ebx
@@3:	mov	al, [edi+ebx]
	add	[edi], al
	inc	edi
	inc	ecx
	jne	@@3
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

_ai6_add_bottom PROC

@@D = dword ptr [ebp+14h]
@@W = dword ptr [ebp+18h]
@@H = dword ptr [ebp+1Ch]
@@A = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ebx, [@@A]
	mov	edi, [@@D]
	neg	ebx
	mov	eax, [@@H]
	mov	ecx, [@@W]
	dec	eax
	imul	eax, ecx
	imul	eax, ebx
	sub	edi, eax

	sub	edi, ebx
	dec	ecx
	je	@@2
	imul	ecx, ebx
@@1:	mov	al, [edi+ebx]
	add	[edi], al
	inc	edi
	inc	ecx
	jne	@@1
@@2:	mov	ecx, [@@H]
	imul	ebx, [@@W]
	lea	esi, [ebx+ebx]
	neg	ebx
	dec	ecx
	je	@@9
@@4:	add	edi, esi
	mov	edx, ebx
@@5:	mov	al, [edi+ebx]
	add	[edi], al
	inc	edi
	dec	edx
	jne	@@5
	dec	ecx
	jne	@@4
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP
