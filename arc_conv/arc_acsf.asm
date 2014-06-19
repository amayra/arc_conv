
	dw 0
_arc_acsf PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+20h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 20h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ebx
	lea	ecx, [ebx-1]
	sub	eax, 'FSCA'
	and	edx, 7Fh
	shr	ecx, 14h
	or	eax, edx
	or	eax, ecx
	jne	@@9a
	mov	[@@N], ebx
	imul	ebx, 1Ch
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	lea	edx, [esi+4]
	call	_ArcName, edx, 10h
	mov	ebx, [esi+18h]
	and	[@@D], 0
	call	_FileSeek, [@@S], dword ptr [esi+14h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 1Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
