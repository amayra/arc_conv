
; "Miko Mai" *.arc

	dw 0
_arc_arcx PROC

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
	pop	edi
	pop	edx
	pop	ebx
	sub	eax, 'XCRA'
	sub	edx, 10h
	mov	[@@N], edi
	lea	ecx, [edi-1]
	or	eax, edx
	shl	edi, 7
	shr	ecx, 14h
	add	edi, 10h
	or	eax, ecx
	sub	edi, ebx
	or	eax, edi
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	byte ptr [esi], 0
	je	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 64h
	mov	ebx, [esi+68h]
	mov	edi, [esi+6Ch]
	and	[@@D], 0
	call	_FileSeek, [@@S], dword ptr [esi+64h], 0
	jc	@@1a
	lea	eax, [@@D]
	cmp	byte ptr [esi+77h], 0
	jne	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	sub	esi, -80h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	call	_ArcMemRead, eax, edi, ebx, 0
	call	_lzss_unpack, [@@D], edi, edx, eax
	jmp	@@1b
ENDP
