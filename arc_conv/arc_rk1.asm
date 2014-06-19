
; "Lolikko Kunoichi Boshi Soukan" *.?dt, bgm.ovd, script.dat

	dw 0
_arc_rk1 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+0Ch, 0
	call	_FileSeek, [@@S], -0Ch, 2
	jc	@@9a
	xchg	edi, eax
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	pop	eax
	pop	ebx
	pop	edx
	cmp	eax, '1KR'
	jne	@@9a
	lea	eax, [ebx-1]
	mov	[@@N], ebx
	shr	eax, 14h
	jne	@@9
	shl	ebx, 5
	sub	edi, ebx
	cmp	edx, edi
	jne	@@9
	call	_FileSeek, [@@S], edx, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 10h
	and	[@@D], 0
	mov	ebx, [esi+10h]
	mov	edi, [esi+14h]
	call	_FileSeek, [@@S], dword ptr [esi+1Ch], 0
	jc	@@1a
	lea	eax, [@@D]
	cmp	dword ptr [esi+18h], 1
	je	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 20h
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
