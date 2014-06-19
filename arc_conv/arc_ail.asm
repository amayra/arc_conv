
; "Chikan ~Shoujo wa Etsurakuiki no Densha ni Notte~" *.dat

	dw _conv_ail-$-2
_arc_ail PROC

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
	lea	ecx, [ebx-1]
	shr	ecx, 14h
	jne	@@9a
	mov	[@@N], ebx
	shl	ebx, 2
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	lodsd
	test	eax, eax
	je	@@8
	js	@@9
	xchg	edi, eax
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, edi, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
	cmp	ebx, edi
	jne	@@9
	jmp	@@8a

@@8:	call	_ArcSkip, 1
@@8a:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_ail PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 6+8
	jb	@@9
	cmp	word ptr [esi], 1
	je	@@3
	; 0008 0010
	mov	edx, 0A1A0A0Dh
	mov	eax, [esi+6]
	sub	edx, [esi+6+4]
	sub	eax, 474E5089h
	or	eax, edx
	je	@@1
	; 0000
	mov	eax, [esi+4]
	mov	edx, [esi+8]
	sub	eax, 'SggO'
	sub	dh, 2
	or	eax, edx
	je	@@2
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 6
	add	esi, 6
	call	_ArcSetExt, 'gnp'
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@2:	sub	ebx, 4
	add	esi, 4
	call	_ArcSetExt, 'ggo'
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@3:	mov	edi, [esi+2]
	sub	ebx, 6
	add	esi, 6
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	push	ebx
	push	esi
	push	eax
	push	edi
	mov	edx, esi
	mov	ecx, ebx
	call	@@UnpCrypt
	call	_lzss_unpack
	push	eax
	call	_ArcSetExt, 'nib'
	call	_ArcData, edi
	call	_MemFree, edi
	clc
	leave
	ret

@@UnpCrypt PROC
	xor	eax, eax
@@1:	dec	ecx
	js	@@9
	shr	eax, 1
	jne	@@1a
	dec	ecx
	js	@@9
	mov	al, [edx]
	xor	al, -1
	mov	[edx], al
	inc	edx
	stc
	rcr	al, 1
@@1a:	jnc	@@1b
	inc	edx
	jmp	@@1

@@1b:	inc	edx
	inc	edx
	dec	ecx
	jns	@@1
@@9:	ret
ENDP

ENDP
