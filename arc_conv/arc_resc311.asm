
; "Tokimeki Girl's Side 3rd Story (DS)"

	dw 0
_arc_resc311 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	ebx
	pop	edx
	pop	ecx
	lea	edi, [ebx-1]
	sub	eax, 'CSER'
	sub	edx, '11.3'
	shr	edi, 14h
	or	eax, ecx
	or	edx, edi
	or	eax, edx
	jne	@@9a
	mov	[@@N], ebx
	imul	ebx, 30h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	mov	eax, [esi+8]
	mov	edx, [esi+0Ch]
	bswap	eax
	bswap	edx
	push	eax
	push	edx
	mov	eax, [esi]
	mov	edx, [esi+4]
	bswap	eax
	bswap	edx
	push	eax
	push	edx
	mov	edx, esp
	call	_ArcName, edx, 10h
	add	esp, 10h
	mov	eax, [esi+14h]
	bswap	eax
	call	_ArcSetExt, eax
	and	[@@D], 0
	mov	ebx, [esi+18h]
	call	_FileSeek, [@@S], dword ptr [esi+1Ch], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 30h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
