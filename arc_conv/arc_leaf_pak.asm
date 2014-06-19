
; "Tears to Tiara" (*.pak)
; TtT.exe
; 00458F60 VM

	dw 0
_arc_leaf_pak1 PROC

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
	cmp	eax, 'PACK'
	jne	@@9a
	lea	ecx, [ebx-1]
	mov	[@@N], ebx
	shr	ecx, 14h
	jne	@@9a
	imul	ebx, 24h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	eax, [ebx+8]
	cmp	[esi+1Ch], eax
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	cmp	dword ptr [esi], 2	; 0 - unpacked, 1 - lzss, 0xCCCCCCCC - dir(?)
	jb	@@1c
	call	_ArcSkip, 1
	jmp	@@8
@@1c:	lea	edx, [esi+4]
	call	_ArcName, edx, 18h
	and	[@@D], 0
	mov	ebx, [esi+20h]
	call	_FileSeek, [@@S], dword ptr [esi+1Ch], 0
	jc	@@1a
	cmp	dword ptr [esi], 0
	jne	@@1d
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 24h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@1d:	cmp	ebx, 8
	jb	@@1a
	push	ecx
	push	ecx
	mov	edx, esp
	call	_FileRead, [@@S], edx, 8
	pop	eax
	pop	edi
	jc	@@1a
	cmp	eax, ebx
	jne	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, edi, ebx, 0
	call	_lzss_unpack, [@@D], edi, edx, eax
	jmp	@@1b
ENDP

; "Hoshi no Ouji-kun" (*.pak)

	dw 0
_arc_leaf_pak2 PROC

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
	pop	ecx
	pop	ebx
	cmp	eax, 'PACK'
	jne	@@9a
	lea	ecx, [ebx-1]
	mov	[@@N], ebx
	shr	ecx, 14h
	jne	@@9a
	imul	ebx, 2Ch
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	eax, [ebx+10h]
	cmp	[esi+24h], eax
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	cmp	dword ptr [esi], 2	; 0 - unpacked, 1 - lzss, 0xCCCCCCCC - dir(?)
	jb	@@1c
	call	_ArcSkip, 1
	jmp	@@8
@@1c:	lea	edx, [esi+4]
	call	_ArcName, edx, 18h
	and	[@@D], 0
	mov	ebx, [esi+28h]
	call	_FileSeek, [@@S], dword ptr [esi+24h], 0
	jc	@@1a
	cmp	dword ptr [esi], 0
	jne	@@1d
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 2Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@1d:	cmp	ebx, 8
	jb	@@1a
	push	ecx
	push	ecx
	mov	edx, esp
	call	_FileRead, [@@S], edx, 8
	pop	eax
	pop	edi
	jc	@@1a
	cmp	eax, ebx
	jne	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, edi, ebx, 0
	call	_lzss_unpack, [@@D], edi, edx, eax
	jmp	@@1b
ENDP
