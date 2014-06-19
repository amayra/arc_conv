
; "Lover Able" *.ykc
; Loverable.exe
; 00439160 yks_load

	dw _conv_ykc-$-2
_arc_ykc PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 8

	enter	@@stk+18h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 18h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ecx
	sub	eax, '0CKY'
	sub	edx, '10'
	sub	ecx, 18h
	or	eax, edx
	or	eax, ecx
	jne	@@9a
	mov	edi, [esi+10h]
	mov	eax, [esi+14h]
	xor	edx, edx
	lea	ecx, [edx+14h]
	div	ecx
	lea	ecx, [eax-1]
	mov	[@@N], eax
	shr	ecx, 14h
	or	edx, ecx
	jne	@@9a
	call	_FileSeek, [@@S], edi, 0
	jc	@@1a
	lea	edx, [@@L0]
	call	_FileRead, [@@S], edx, 4
	jc	@@9a
	mov	eax, [@@L0]
	mov	ebx, [esi+14h]
	sub	edi, eax
	jb	@@9a
	add	ebx, edi
	jc	@@9a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	[@@L0+4], edi
	add	esi, edi
	call	_ArcCount, [@@N]

@@1:	mov	edx, [esi]
	mov	ecx, [@@L0+4]
	sub	edx, [@@L0]
	jb	@@1b
	sub	ecx, edx
	jb	@@1b
	mov	eax, [esi+4]
	add	edx, [@@M]
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
	call	_ArcName, edx, eax
@@1b:	and	[@@D], 0
	mov	ebx, [esi+0Ch]
	call	_FileSeek, [@@S], dword ptr [esi+8], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 14h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_ykc PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'gky'
	je	@@1
	cmp	eax, 'sky'
	je	@@2
@@9:	stc
	leave
	ret

@@2:	cmp	ebx, 30h
	jb	@@9
	mov	edx, 13130h
	mov	eax, [esi]
	sub	edx, [esi+4]
	mov	ecx, [esi+8]
	sub	eax, '0SKY'
	sub	ecx, 30h
	or	eax, edx
	or	eax, ecx
	jne	@@9
	mov	edx, [esi+20h]
	mov	ecx, ebx
	sub	ecx, edx
	jb	@@9
	cmp	ecx, [esi+24h]
	jne	@@9
	test	ecx, ecx
	je	@@2b
@@2a:	xor	byte ptr [esi+edx], 0AAh
	inc	edx
	dec	ecx
	jne	@@2a
@@2b:	mov	byte ptr [esi+6], cl
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@1:	cmp	ebx, 48h
	jb	@@9
	mov	edx, '00'
	mov	eax, [esi]
	sub	edx, [esi+4]
	mov	ecx, [esi+8]
	sub	eax, '0GKY'
	sub	ecx, 40h
	or	eax, edx
	or	eax, ecx
	jne	@@9
	sub	ebx, 40h
	add	esi, 40h
	mov	edx, 0A1A0A0Dh
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, 504E4789h
	or	eax, edx
	jne	@@9
	mov	dword ptr [esi], 474E5089h
	call	_ArcSetExt, 'gnp'
	call	_ArcData, esi, ebx
	clc
	leave
	ret
ENDP
