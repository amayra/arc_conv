
; "Fairy Bloom Freesia" *.tgp
; "Ether Vapor" *.pac

	dw 0
_arc_tgp0 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ecx
	pop	ebx
	cmp	eax, '0PGT'
	je	@@2a
	xchg	ecx, ebx
	cmp	eax, 'CAPY'
	jne	@@9a
@@2a:	test	ecx, ecx
	jne	@@9a
	lea	ecx, [ebx-1]
	mov	[@@N], ebx
	shr	ecx, 14h
	jne	@@9a
	imul	ebx, 70h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	eax, [ebx+10h]
	cmp	byte ptr [esi], 0
	je	@@9
	cmp	[esi+60h], eax
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 60h
	and	[@@D], 0
	mov	eax, [esi+64h]
	mov	ebx, [esi+68h]
	or	eax, [esi+6Ch]
	jne	@@1a
	call	_FileSeek, [@@S], dword ptr [esi+60h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 70h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
