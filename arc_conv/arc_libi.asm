
; "Babydoll" *.arc
; Babydoll.exe
; 00404C7D lzss_unpack

	dw 0
_arc_libi PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	ebx
	lea	ecx, [ebx-1]
	shr	ecx, 14h
	jne	@@9a
	mov	[@@N], ebx
	shl	ebx, 5
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	eax, [ebx+4]
	cmp	[esi+1Ch], eax
	jne	@@9
	mov	edi, esi
	mov	ecx, [@@N]
@@2a:	push	5
	pop	edx
@@2b:	not	dword ptr [edi]
	add	edi, 4
	dec	edx
	jne	@@2b
	add	edi, 0Ch
	dec	ecx
	jne	@@2a
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	call	_ArcName, esi, 14h
	and	[@@D], 0
	mov	edi, [esi+14h]
	mov	ebx, [esi+18h]
	call	_FileSeek, [@@S], dword ptr [esi+1Ch], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, edi, ebx, 0
	call	_lzss_unpack, [@@D], edi, edx, eax
	xchg	ebx, eax
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
ENDP
