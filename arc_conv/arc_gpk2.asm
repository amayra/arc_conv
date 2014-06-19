
; "Kanosora" gfb\*, ogg\*

	dw _conv_gpk2-$-2
_arc_gpk2 PROC

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
	pop	eax
	pop	ebx
	cmp	eax, '2KPG'
	jne	@@9a
	call	_FileSeek, [@@S], 0, 2
	jc	@@9a
	xchg	edi, eax
	call	_FileSeek, [@@S], ebx, 0
	jc	@@9a
	sub	edi, ebx
	lea	edx, [@@N]
	call	_FileRead, [@@S], edx, 4
	jc	@@9a
	mov	eax, [@@N]
	sub	edi, 4
	imul	ebx, eax, 88h
	dec	eax
	sub	edi, ebx
	shr	eax, 14h
	or	eax, edi
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	mov	edi, 80h
	add	esi, 8
	call	_ArcName, esi, edi
	and	[@@D], 0
	mov	eax, [esi-8]
	mov	ebx, [esi-4]
	add	esi, edi
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

_conv_gpk2 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'bfg'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 40h
	jb	@@9
	mov	[@@SC], ebx
	mov	eax, [esi]
	sub	ebx, [esi+0Ch]
	mov	edx, [esi+14h]
	mov	ecx, [esi+18h]
	sub	eax, ' BFG'
	sub	edx, 40h
	sub	ecx, 28h
	or	eax, ebx
	or	edx, ecx
	or	eax, edx
	jne	@@9
	movzx	edi, word ptr [esi+1Ch]
	movzx	edx, word ptr [esi+20h]
	mov	ebx, edi
	imul	ebx, edx
	shl	ebx, 2
	cmp	[esi+10h], ebx
	jne	@@9
	call	_ArcTgaAlloc, 3, edi, edx
	xchg	edi, eax
	add	esi, 40h
	add	edi, 12h
	call	_lzss_unpack, edi, ebx, esi, [@@SC]
	clc
	leave
	ret
ENDP
