
; "Extravaganza" *.gpk

	dw _conv_cycsoft-$-2
_arc_cycsoft PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 8
@M0 @@L1
@M0 @@L2

	enter	@@stk, 0
	call	_unicode_ext, -1, offset inFileName
	cmp	eax, 'kpv'
	je	_mod_cycsoft_vpk
	cmp	eax, 'kpg'
	jne	@@9a
	call	@@3
	test	esi, esi
	je	@@9a
	mov	[@@M], esi
	lodsd
	lea	ecx, [eax-1]
	mov	[@@N], eax
	lea	edx, [esi+eax*4]
	shl	eax, 3
	shr	ecx, 14h
	jne	@@9
	sub	ebx, eax
	jb	@@9
	add	eax, esi
	mov	[@@L1], edx
	mov	[@@L0], eax
	mov	[@@L0+4], ebx
	call	_ArcCount, [@@N]

	call	_FileGetSize, [@@S]
	mov	[@@L2], eax

	xor	esi, esi
@@1:	mov	edx, [@@M]
	mov	ecx, [@@L0+4]
	mov	edi, [edx+esi*4+4]
	xor	eax, eax
	sub	ecx, edi
	jbe	@@8
	add	edi, [@@L0]
	mov	edx, edi
	repne	scasb
	jne	@@8
	call	_ArcName, edx, -1
	and	[@@D], 0
	mov	ebx, [@@L2]
	mov	edx, [@@L1]
	cmp	[@@N], 1
	je	@@1b
	mov	ebx, [edx+esi*4+4]
@@1b:	mov	eax, [edx+esi*4]
	sub	ebx, eax
	jb	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	inc	esi
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	call	_ArcInputExt, 'btg'
	jc	@@3b
	xchg	edi, eax
	call	_FileGetSize, edi
	xchg	ebx, eax
	cmp	ebx, 4
	jb	@@3a
	call	_MemAlloc, ebx
	jc	@@3a
	xchg	esi, eax
	call	_FileRead, edi, esi, ebx
	jnc	@@3c
	call	_MemFree, esi
@@3a:	call	_FileClose, edi
@@3b:	xor	esi, esi
@@3c:	ret
ENDP

_mod_cycsoft_vpk PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	call	@@3
	test	esi, esi
	je	@@9a
	mov	[@@M], esi
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 8
	and	[@@D], 0
	mov	ebx, [esi+8+0Ch]
	mov	eax, [esi+8]
	sub	ebx, eax
	jb	@@1a
	call	_FileSeek, [@@S], eax, 0
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

@@3:	call	_ArcInputExt, 'btv'
	jc	@@3b
	xchg	edi, eax
	call	_FileGetSize, edi
	mov	ebx, eax
	xor	edx, edx
	lea	ecx, [edx+0Ch]
	div	ecx
	test	edx, edx
	jne	@@3b
	dec	eax
	lea	ecx, [eax-1]
	mov	[@@N], eax
	shr	ecx, 14h
	jne	@@3b
	call	_MemAlloc, ebx
	jc	@@3a
	xchg	esi, eax
	call	_FileRead, edi, esi, ebx
	jnc	@@3c
	call	_MemFree, esi
@@3a:	call	_FileClose, edi
@@3b:	xor	esi, esi
@@3c:	ret
ENDP

_conv_cycsoft PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'kpg'
	je	@@9
	cmp	eax, 'kpv'
	je	@@9
	sub	ebx, 40h
	jb	@@9
	mov	edx, 'EPYT'
	mov	eax, [esi+30h]
	sub	edx, [esi+34h]
	sub	eax, 'KCAP'
	or	eax, edx
	je	@@1
@@9:	stc
	leave
	ret

@@1:	; PACKTYPE=0 bmp
	; PACKTYPE=3A bmp+bmp
	; PACKTYPE=5 jpg
	; PACKTYPE=8A png+png
	; vaw PACKTYPE=0 wav
	; wgq PACKTYPE=6 ogg

	cmp	byte ptr [esi+3Ah], 'A'
	jne	@@1a
	mov	eax, [esi+20h]
	mov	ecx, ebx
	test	eax, eax
	je	@@1a
	sub	ecx, eax
	jb	@@1a
	xchg	ebx, eax
	jmp	$+4
@@1a:	xor	ecx, ecx
	push	ecx
	add	esi, 40h
	call	@@2
	add	esi, ebx
	pop	ebx
	test	ebx, ebx
	je	@@1b
	call	_ArcSetExt, 'ksm'
	mov	byte ptr [edx], '_'
	call	@@2
@@1b:	clc
	leave
	ret

@@2:	cmp	ebx, 0Ch
	jb	@@2b
	mov	ecx, 'ggo'
	mov	eax, [esi]
	mov	edx, [esi+4]
	sub	eax, 'SggO'
	sub	dh, 2
	or	eax, edx
	je	@@2a
	mov	ecx, 'vaw'
	mov	edx, 'EVAW'
	mov	eax, [esi]
	sub	edx, [esi+8]
	sub	eax, 'FFIR'
	or	eax, edx
	je	@@2a
	mov	ecx, 'gpj'
	cmp	word ptr [esi], 0D8FFh
	je	@@2a
	mov	ecx, 'pmb'
	cmp	word ptr [esi], 'MB'
	je	@@2a
	mov	ecx, 'gnp'
	mov	edx, 0A1A0A0Dh
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, 474E5089h
	or	eax, edx
	je	@@2a
@@2b:	xor	ecx, ecx
@@2a:	call	_ArcSetExt, ecx
	call	_ArcData, esi, ebx
	ret
ENDP

