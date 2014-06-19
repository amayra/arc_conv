
; "WizAnniversary", "Hoshizora no Memoria" *.bin
; WizAnniversary.exe

	dw _conv_crossnet-$-2
_arc_crossnet PROC

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
	pop	ecx
	pop	ebx
	lea	edx, [ecx*2+ecx]
	mov	eax, ebx
	mov	[@@N], ecx
	shr	eax, 8
	cmp	ebx, ecx
	jb	@@9a
	cmp	eax, ecx
	ja	@@9a
	dec	ecx
	lea	edx, [edx*4+ebx]
	shr	ecx, 14h
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, edx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	ecx, [@@N]
	lea	edx, [ecx*2+ecx]
	mov	[@@L1], ebx
	lea	edx, [esi+edx*4]
	mov	[@@L0], edx
	call	_ArcCount, ecx

@@1:	mov	ecx, [@@L1]
	mov	eax, [esi]
	sub	ecx, eax
	jbe	@@8
	add	eax, [@@L0]
	call	_ArcName, eax, ecx
	and	[@@D], 0
	mov	ebx, [esi+8]
	call	_FileSeek, [@@S], dword ptr [esi+4], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 0Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_crossnet PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 0Ch
	jb	@@9
	mov	eax, [esi]
	cmp	eax, '1czh'
	je	@@2
	cmp	eax, 'SggO'
	jne	@@1
	call	_ArcSetExt, 'ggo'
	jmp	@@9

@@1:	mov	edx, 'EVAW'
	sub	eax, 'FFIR'
	sub	edx, [esi+8]
	or	eax, edx
	jne	@@9
	call	_ArcSetExt, 'vaw'
@@9:	stc
	leave
	ret

@@2:	sub	ebx, 2Ch
	jb	@@9
	mov	eax, [esi+8]
	mov	edx, 'GSVN'
	sub	eax, 20h
	sub	edx, [esi+0Ch]
	or	eax, edx
	jne	@@9
	movzx	ecx, byte ptr [esi+12h]		; 0-24, 1-32, 2-32*x, 3-8, 4-8
	movzx	edi, word ptr [esi+14h]
	movzx	edx, word ptr [esi+16h]
	mov	eax, edi
	cmp	ecx, 2
	jae	@@9
	imul	eax, edx
	add	ecx, 3
	imul	eax, ecx
	cmp	eax, [esi+4]
	jne	@@9
	add	ecx, 20h-1
	call	_ArcTgaAlloc, ecx, edi, edx
	xchg	edi, eax
	add	esi, 2Ch
	lea	edx, [edi+12h]
	call	_zlib_unpack, edx, dword ptr [esi+4], esi, ebx
	clc
	leave
	ret
ENDP
