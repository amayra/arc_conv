	
; "Touhou 12.5 - Double Spoiler" th125.dat
; th125.exe
; 0044A340

;	dw _conv_th125-$-2
	dw 0
_arc_th125 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC
@M0 @@L0
@M0 @@L1
@M0 @@L2

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	call	_pbg_decode, esi, 10h, 10371Bh
	pop	eax
	cmp	eax, '1AHT'
	jne	@@9a
	add	esi, 4
	sub	dword ptr [esi], 0075BCD15h
	sub	dword ptr [esi+4], 03ADE68B1h
	sub	dword ptr [esi+8], 008180754h
	mov	ebx, [esi+8]
	lea	eax, [ebx-1]
	mov	[@@N], ebx
	shr	eax, 14h
	jne	@@9a
	call	_FileSeek, [@@S], 0, 2
	jc	@@9a
	mov	edi, [esi+4]
	mov	ebx, [esi]
	sub	eax, edi
	jbe	@@9a
	mov	[@@L1], eax
	call	_FileSeek, [@@S], eax, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, ebx, edi, 0
	jc	@@9
	mov	esi, [@@M]
	push	eax
	push	edx
	call	_pbg_decode, edx, edi, 809B3Eh
	call	_pbg_unpack, esi, ebx
	cmp	eax, ebx
	jne	@@9
	mov	[@@SC], ebx
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

	call	_ArcParamNum, 2
	db 'th125', 0
	dec	eax
	cmp	eax, 2
	jae	@@9
	imul	eax, 30h
	add	eax, offset @@T
	mov	[@@L2], eax

@@1:	mov	ecx, [@@SC]
	mov	edi, esi
	sub	ecx, 0Ch
	jbe	@@9
	xor	eax, eax
	mov	edx, edi
	repne	scasb
	jne	@@9
	sub	edx, edi
	and	edx, 3
	sub	ecx, edx
	jb	@@9
	add	edi, edx
	mov	edx, esi
	xor	ebx, ebx
@@1d:	mov	al, [edx]
	inc	edx
	add	ebx, eax
	test	eax, eax
	jne	@@1d
	and	ebx, 7
	mov	[@@L0], ebx
	push	ecx
	call	_ArcName, esi, -1
	pop	ecx
	lea	esi, [edi+0Ch]
	mov	[@@SC], ecx
	mov	edi, [@@L1]
	cmp	[@@N], 1
	je	@@1c
	test	ecx, ecx
	je	@@1c
	push	edi
	mov	edi, esi
	mov	edx, edi
	repne	scasb
	xchg	eax, edi
	pop	edi
	jne	@@1c
	sub	edx, eax
	and	edx, 3
	add	edx, 4
	cmp	ecx, edx
	jb	@@1c
	mov	edi, [eax+edx-4]
@@1c:	mov	eax, [esi-0Ch]
	mov	ebx, [esi-8]
	and	[@@D], 0
	sub	edi, eax
	jbe	@@1a
	test	ebx, ebx
	je	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	xor	ecx, ecx
	cmp	ebx, edi
	je	$+4
	mov	ecx, ebx
	lea	eax, [@@D]
	call	_ArcMemRead, eax, ecx, edi, 0
	push	eax
	push	edx
	mov	ecx, [@@L0]
	mov	eax, [@@L2]
	lea	ecx, [ecx*2+ecx]
	lea	ecx, [eax+ecx*2]
	movzx	eax, word ptr [ecx+4]
	cmp	eax, edi
	jb	$+4
	mov	eax, edi
	call	_pbg_decode, edx, eax, dword ptr [ecx]
	pop	edx
	pop	eax
	cmp	edi, ebx
	je	@@1b
	call	_pbg_unpack, [@@D], ebx, edx, eax
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@T	dw 0371Bh, 0040h,2800h	; th10, th11
	dw 0E951h, 0040h,3000h
	dw 051C1h, 0080h,3200h
	dw 01903h, 0400h,7800h
	dw 0CDABh, 0200h,2800h
	dw 03412h, 0080h,3200h
	dw 09735h, 0080h,2800h
	dw 03799h, 0400h,2000h

	dw 0731Bh, 0040h,3800h	; th12, th125, th128
	dw 09E51h, 0040h,4000h
	dw 015C1h, 0400h,2C00h
	dw 09103h, 0080h,6400h
	dw 0DCABh, 0080h,6E00h
	dw 04312h, 0200h,3C00h
	dw 07935h, 0400h,3C00h
	dw 07D99h, 0080h,2800h
ENDP

if 0
_conv_th125 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'mna'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	call	_ArcSetExt, 0
	push	edx	; @@L0
	push	0	; @@L1
@@1a:	cmp	[@@SC], 20h
	jb	@@1c
	cmp	dword ptr [esi], 7
	jne	@@1c
	mov	ecx, [esi+1Ch]
	mov	edi, [esi+10h]
	cmp	ecx, 10h
	jb	@@1c
	sub	[@@SC], ecx
	jb	@@1c
	lea	edx, [esi+edi]
	add	esi, ecx
	sub	ecx, edi
	jbe	@@1c
	xor	eax, eax
	mov	edi, edx
	repne	scasb
	jne	@@1c
	call	_ArcNameFmt, [@@L0], [@@L1]
	db '\%05i',0
	pop	ecx
	inc	[@@L1]

	sub	[@@SC], 10h
	cmp	dword ptr [esi], 'XTHT'
	jne	@@1c
	mov	ecx, [esi+0Ch]
	sub	[@@SC], ecx
	jb	@@1c
	movzx	edi, word ptr [esi+8]
	movzx	edx, word ptr [esi+0Ah]
	mov	ebx, edi
	imul	ebx, edx

	; 1 - 8888
	; 3 - 0565
	; 4 - 8000(?)
	; 5 - 4444

	mov	ecx, ebx
	movzx	eax, word ptr [esi+6]
	dec	eax
	jne	@@2a
	shl	ecx, 2
	jmp	@@2b
@@2a:	dec	eax
	dec	eax
	and	eax, NOT 2
	jne	@@1d
	shl	ecx, 1
@@2b:	cmp	[esi+0Ch], ecx
	jne	@@1c

	call	_ArcTgaAlloc, 23h, edi, edx
	xchg	edi, eax
	movzx	eax, word ptr [esi+6]
	add	esi, 10h
	add	edi, 12h
	dec	eax
	jne	@@2c
	mov	ecx, ebx
	rep	movsd
	jmp	@@2f

@@2c:	dec	eax
	dec	eax
	jne	@@2e
@@2d:	movzx	eax, word ptr [esi]
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
	mov	[edi], eax
	add	edi, 4
	dec	ebx
	jne	@@2d
	jmp	@@2f

@@2e:	movzx	eax, word ptr [esi]
	add	esi, 2
	ror	eax, 8
	shl	ax, 4
	shr	al, 4
	rol	eax, 10h
	shr	ax, 4
	shr	al, 4
	imul	eax, 11h
	mov	[edi], eax
	add	edi, 4
	dec	ebx
	jne	@@2e
@@2f:
	call	_ArcTgaSave
	call	_ArcTgaFree
	jmp	@@1a

@@1d:	add	esi, [esi+0Ch]
	jmp	@@1a	

@@1c:	clc
	leave
	ret
ENDP
endif
