
; "Mamono Musume to no Seikatsu - Lamia no Baai" *.pak
; Lamia_girl.exe
; 00416FE0

	dw _conv_ipac-$-2
_arc_ipac PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 8

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	eax
	pop	ebx
	cmp	eax, 'CAPI'
	jne	@@9a
	movzx	ebx, bx
	mov	[@@N], ebx
	test	ebx, ebx
	je	@@9a
	imul	ebx, 2Ch
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 24h
	mov	ebx, [esi+28h]
	and	[@@D], 0
	call	_FileSeek, [@@S], dword ptr [esi+24h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	mov	edi, [@@D]
	cmp	ebx, 8
	jb	@@1a
	cmp	dword ptr [edi], '1LEI'
	jne	@@1a
	call	_MemAlloc, dword ptr [edi+4]
	jc	@@1a
	mov	[@@D], eax
	lea	edx, [edi+8]
	call	_lzss_unpack, eax, dword ptr [edi+4], edx, ebx
	xchg	ebx, eax
	call	_MemFree, edi
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 2Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_ipac PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'sei'
	jne	@@9
	sub	ebx, 420h
	jbe	@@9
	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	mov	ecx, edi
	imul	ecx, edx
	mov	eax, '2SEI'
	ror	ebx, 2
	sub	eax, [esi]
	sub	ecx, ebx
	or	eax, ecx
	mov	ecx, [esi+10h]
	sub	ecx, 18h
	or	eax, ecx
	je	@@1
@@9:	stc
	leave
	ret

@@1:	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 23h, edi, edx
	xchg	edi, eax
	add	esi, 420h
	lea	edx, [ebx*2+ebx]
	add	edi, 12h
	add	edx, esi
@@2:	movsb
	movsb
	movsb
	mov	al, [edx]
	inc	edx
	stosb
	dec	ebx
	jne	@@2
	clc
	leave
	ret
ENDP
