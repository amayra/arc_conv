
; "Princess Maker Refine", "Princess Maker 2 Refine" *.dat

	dw _conv_pmref-$-2
_arc_pmref PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	ebx
	pop	eax
	lea	ecx, [ebx-1]
	shr	ecx, 14h
	or	ecx, eax
	jne	@@9a
	mov	[@@N], ebx
	dec	ebx
	shl	ebx, 2
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 4, ebx, 4
	jc	@@9
	mov	esi, [@@M]
	call	_FileGetSize, [@@S]
	jc	@@9
	and	dword ptr [esi], 0
	mov	[esi+ebx+4], eax
	call	_ArcCount, [@@N]
@@1:	lodsd
	mov	edi, [esi]
	sub	edi, eax
	jb	@@9
	js	@@9
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, edi, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
	cmp	ebx, edi
	jne	@@9
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_pmref PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 10h
	jb	@@9
	mov	edx, 0A1A0A0Dh
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, 474E5089h
	or	eax, edx
	jne	@@1
	call	_ArcPngName, esi, ebx
	call	_ArcSetExt, 'gnp'
@@9:	stc
	leave
	ret

@@1:	mov	edx, 'ekaF'
	mov	ecx, ' eiL'
	mov	eax, [esi]
	sub	edx, [esi+8]
	sub	ecx, [esi+0Ch]
	sub	eax, 'FFIR'
	or	edx, ecx
	or	eax, edx
	jne	@@9
	mov	dword ptr [esi+8], 'EVAW'
	mov	dword ptr [esi+0Ch], ' tmf'
	call	_ArcSetExt, 'vaw'
	call	_ArcData, esi, ebx
	clc
	leave
	ret
ENDP
