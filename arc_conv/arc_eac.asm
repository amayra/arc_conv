
; "Words Worth XP" *.eac

	dw _conv_eac-$-2
_arc_eac PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	eax
	lea	ecx, [eax-1]
	shr	ecx, 14h
	jne	@@9a
	mov	[@@N], eax
	imul	ebx, eax, 18h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	eax, [ebx+4]	
	cmp	[esi+14h], eax
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 10h
	mov	ebx, [esi+10h]
	and	[@@D], 0
	call	_FileSeek, [@@S], dword ptr [esi+14h], 0
	jc	@@1a
	sub	ebx, 4
	jb	@@1a
	push	ecx
	mov	edx, esp
	call	_FileRead, [@@S], edx, 4
	pop	eax
	jc	@@1a
	xchg	edi, eax
	lea	eax, [@@D]
	call	_ArcMemRead, eax, edi, ebx, 0
	call	_lzss_unpack, [@@D], edi, edx, eax
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 18h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_eac PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'fge'
	je	@@1
	cmp	eax, 'rxt'
	je	@@2
@@9:	stc
	leave
	ret

@@2:	sub	ebx, 4
	jb	@@9
	xchg	eax, ebx
	movzx	edi, word ptr [esi]
	movzx	edx, word ptr [esi+2]
	mov	ebx, edi
	imul	ebx, edx
	add	ebx, 400h
	cmp	eax, ebx
	jne	@@9
	call	_ArcTgaAlloc, 38h, edi, edx
	xchg	edi, eax
	add	esi, 4
	add	edi, 12h
	mov	ecx, ebx
	rep	movsb
	clc
	leave
	ret

@@1:	sub	ebx, 0Ch
	jb	@@9
	cmp	dword ptr [esi], '1fge'
	jne	@@9
	xchg	eax, ebx
	ror	eax, 1
	movzx	edi, word ptr [esi+4]
	movzx	edx, word ptr [esi+6]
	mov	ebx, edi
	imul	ebx, edx
	cmp	eax, ebx
	jne	@@9
	call	_ArcTgaAlloc, 23h, edi, edx
	xchg	edi, eax
	add	esi, 0Ch
	add	edi, 12h
@@1a:	; 1555
	movzx	eax, word ptr [esi]
	add	esi, 2
	test	eax, eax
	je	@@1b
	ror	eax, 10
	shl	al, 3
	cmc
	sbb	ah, ah
	rol	eax, 16
	shr	ax, 3
	shl	ah, 3
	mov	edx, 0E0E0E0E0h
	and	edx, eax
	shr	edx, 5
	or	eax, edx
@@1b:	mov	[edi], eax
	add	edi, 4
	dec	ebx
	jne	@@1a
	clc
	leave
	ret
ENDP
