
; "Avaron" *.md
; avaron.exe

	dw _conv_mdfile-$-2
_arc_mdfile PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+1Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 1Ch
	jc	@@9a
	mov	edi, offset @@sign
	push	3
	pop	ecx
	repe	cmpsd
	jne	@@9a
	lodsd
	cmp	eax, 30h
	je	_mod_mdfile20
	cmp	eax, 32h
	jne	@@9a
	lodsd
	xchg	ecx, eax
	lodsd
	mov	ebx, [esi]
	imul	edx, ecx, 0Ch
	cmp	ebx, eax
	jb	@@9a
	dec	ecx
	sub	eax, 18h
	shr	ecx, 14h
	sub	eax, edx
	or	eax, ecx
	jne	@@9a
	lea	ecx, [ebx-1Ch]
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 1Ch, ecx, 0
	jc	@@9
	mov	edi, [@@M]
	mov	esi, esp
	push	7
	pop	ecx
	rep	movsd
	lea	esi, [edi-1Ch]
	mov	eax, [esi+14h]
	add	eax, [esi+eax-4]
	sub	eax, 4
	cmp	ebx, eax
	jb	@@9
	xchg	ebx, eax
	call	@@5
	test	eax, eax
	je	@@9
	mov	[@@N], eax
	call	_ArcCount, eax
	add	esi, 14h

@@1:	mov	eax, [esi]
	add	eax, [@@M]
	call	_ArcName, eax, -1
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

@@5 PROC
	push	ebx
	push	edi
	lea	edi, [esi+14h]
	xor	edx, edx
@@1:	mov	eax, [edi]
	cmp	eax, [esi+14h]
	jb	@@9
	mov	ecx, ebx
	sub	ecx, eax
	jbe	@@9
	push	edi
	lea	edi, [esi+eax]
	xor	eax, eax
	repne	scasb
	pop	edi
	jne	@@9
	inc	edx
	add	edi, 0Ch
	cmp	edx, [esi+10h]
	jb	@@1
@@9:	xchg	eax, edx
	pop	edi
	pop	ebx
	ret
ENDP

@@sign	db 'MDFILE Ver2.'
ENDP

; "Youjo Ranbu 2" *.md

_mod_mdfile20 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	lodsd
	mov	[@@N], eax
	imul	ecx, eax, 0Ch
	dec	eax
	shr	eax, 14h
	jne	@@9a
	lea	eax, [ecx+14h]
	sub	ecx, 8
	cmp	[esi], eax
	jne	@@9
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 8, ecx, 0
	jc	@@9
	mov	edi, [@@M]
	movsd
	movsd
	lea	esi, [edi-8]
	call	_ArcCount, [@@N]
	sub	esp, 200h

@@1:	mov	edi, [esi+4]
	mov	eax, [esi]
	sub	edi, eax
	jb	@@1b
	cmp	edi, 200h
	jae	@@1b
	call	_FileSeek, [@@S], eax, 0
	jc	@@1b
	mov	ebx, esp
	call	_FileRead, [@@S], ebx, edi
	jc	@@1b
	call	_ArcName, ebx, edi
@@1b:	and	[@@D], 0
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

_conv_mdfile PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 14h
	jbe	@@9
	push	0Fh
	pop	ecx
	call	@@1a
	db 'compress v1.0',0,0
@@1a:	pop	edi
	repe	cmpsb
	je	@@1
@@9:	stc
	leave
	ret

@@1:	call	_MemAlloc, dword ptr [esi+1]
	jb	@@9
	xchg	edi, eax
	lea	edx, [esi+5]
	sub	ebx, 14h
	mov	al, [esi]
	mov	ecx, ebx
	test	al, al
	je	@@1c
@@1b:	xor	[esi+5], al
	inc	esi
	dec	ecx
	jne	@@1b
@@1c:	call	_lzss_unpack, edi, dword ptr [edx-4], edx, ebx
	call	_ArcData, edi, eax
	call	_MemFree, edi
	clc
	leave
	ret
ENDP
