
; "Yumemi Hakusho" *.pak
; yume_haku.exe

	dw _conv_hdoc-$-2
_arc_hdoc PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	pop	eax
	pop	ebx
	cmp	eax, 'KCAP'
	jne	@@9a
	lea	ecx, [ebx-1]
	mov	[@@N], ebx
	shr	ecx, 14h
	jne	@@9a
	imul	ebx, 4Ch
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	cmp	byte ptr [esi+8], 1
	mov	esi, [@@M]
	jne	@@2b
	mov	edx, esi
	mov	ecx, ebx
@@2a:	rol	byte ptr [edx], 4
	inc	edx
	dec	ecx
	jne	@@2a
@@2b:	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx
	call	_ArcUnicode, 1

@@1:	call	_ArcName, esi, 20h
	and	[@@D], 0
	mov	ebx, [esi+40h]
	mov	edi, [esi+44h]
	call	_FileSeek, [@@S], dword ptr [esi+48h], 0
	jc	@@1a
	lea	eax, [@@D]
	test	edi, edi
	jne	@@1c
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 4Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@1c:	call	_ArcMemRead, eax, ebx, edi, 0
	call	_lzss_unpack, [@@D], ebx, edx, eax
	jmp	@@1b
ENDP

_conv_hdoc PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, '2po'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 20h
	jb	@@9
	cmp	dword ptr [esi], '2FPO'
	jne	@@9
	mov	ecx, [esi+0Ch]
	ror	ecx, 3
	mov	eax, ecx
	dec	ecx
	je	@@1a
	dec	ecx
	cmp	ecx, 2
	jae	@@9
	mov	[@@SC], ebx
	mov	edi, [esi+4]
	mov	edx, [esi+8]
	mov	ebx, edi
	imul	ebx, edx
	add	ecx, 21h
	imul	ebx, eax
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	add	esi, 20h
	call	_lzss_unpack, edi, ebx, esi, [@@SC]
	clc
	leave
	ret

@@1a:	sub	ebx, 400h
	jb	@@9
	mov	[@@SC], ebx
	mov	edi, [esi+4]
	mov	edx, [esi+8]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 38h, edi, edx
	lea	edi, [eax+12h]
	add	esi, 20h
	mov	ecx, 100h
	rep	movsd
	call	_lzss_unpack, edi, ebx, esi, [@@SC]
	clc
	leave
	ret
ENDP
