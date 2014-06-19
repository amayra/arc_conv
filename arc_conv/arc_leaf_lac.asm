
	dw 0
_arc_leaf_setup PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	eax
	pop	ebx
	cmp	eax, 'CAL'
	jne	@@9a
	lea	ecx, [ebx-1]
	mov	[@@N], ebx
	shr	ecx, 14h
	jne	@@9a

	imul	ebx, 78h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	eax, [ebx+8]
	cmp	[esi+58h], eax
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 4Ch
	and	[@@D], 0
	mov	ebx, [esi+4Ch]
	mov	eax, [esi+50h]
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	call	_FileSeek, [@@S], dword ptr [esi+58h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 78h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

	dw 0
_arc_leaf_lac PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	eax
	pop	ebx
	cmp	eax, 'CAL'
	jne	@@9a
	lea	ecx, [ebx-1]
	mov	[@@N], ebx
	shr	ecx, 14h
	jne	@@9a

	imul	ebx, 28h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	eax, [ebx+8]
	cmp	[esi+24h], eax
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	xor	ecx, ecx
@@2a:	mov	al, [esi+ecx]
	test	al, al
	je	@@2b
	not	al
	mov	[esi+ecx], al
	inc	ecx
	cmp	ecx, 20h
	jb	@@2a
@@2b:	call	_ArcName, esi, ecx
	and	[@@D], 0
	mov	ebx, [esi+20h]
	call	_FileSeek, [@@S], dword ptr [esi+24h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 28h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
