; "Tenkuu no Symphonia", "Tenkuu no Symphonia 2" *.mrg

	dw 0
_arc_mrg0 PROC

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
	pop	ecx
	pop	edi
	cmp	eax, '0grm'
	jne	@@9a
	mov	[@@N], ecx
	imul	ebx, ecx, 4Ch
	dec	ecx
	lea	edx, [ebx+10h]
	shr	ecx, 14h
	jne	@@9a
	cmp	edi, edx
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 40h
	and	[@@D], 0
	mov	edi, [esi+40h]
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, edi, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 4Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
