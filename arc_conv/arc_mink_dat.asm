
; "Hell Guide", "Sacrifice - Shahai no Yukue" *.dat
; sacrifice.exe
; 00408C70 unpack

	dw _conv_mink_dat-$-2
_arc_mink_dat PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	ebx
	mov	[@@N], ebx
	lea	ecx, [ebx-1]
	shr	ecx, 14h
	jne	@@9a
	imul	ebx, 4Ch
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	eax, [ebx+4]
	cmp	byte ptr [esi], 0
	je	@@9
	cmp	[esi+48h], eax
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 44h
	and	[@@D], 0
	mov	ebx, [esi+44h]
	call	_FileSeek, [@@S], dword ptr [esi+48h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
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
ENDP

_conv_mink_dat PROC

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

@@1:	sub	ebx, 18h
	jb	@@9
	mov	eax, [esi]
	mov	ecx, [esi+0Ch]
	dec	eax
	jne	@@9
	cmp	[esi+10h], ebx
	jne	@@9
	ror	ecx, 3
	lea	eax, [ecx-1]
	cmp	eax, 4
	jae	@@9
	dec	eax
	je	@@9
	mov	edi, [esi+4]
	mov	edx, [esi+8]
	mov	ebx, edi
	imul	ebx, edx
	imul	ebx, ecx
	dec	ecx
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	add	esi, 18h
	call	_lzss_unpack, edi, ebx, esi, [@@SC]
	clc
	leave
	ret
ENDP
