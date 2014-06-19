
; "Barbaroi" HD\*.arc

	dw 0
_arc_xarc1 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@F
@M0 @@L1, 20h

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	cmp	dword ptr [esi], 'CRAX'
	jne	@@9a
	mov	ecx, [esi+4]
	mov	ebx, ecx
	dec	ecx
	mov	[@@N], ebx
	shl	ebx, 2
	shr	ecx, 14h
	jne	@@9a
	add	ebx, 2
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 8, ebx, 0
	jc	@@9
	mov	edi, [@@M]
	lea	ecx, [ebx+8]
	mov	edx, edi
	movsd
	movsd
	mov	esi, edi
	call	_xarc_crc16, edx, ecx
	jc	@@9a
	call	_ArcCount, [@@N]

@@1:	and	[@@D], 0
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	lea	edi, [@@L1]
	call	_FileRead, [@@S], edi, 20h
	jc	@@1a
	cmp	dword ptr [edi], 'ATAD'
	jne	@@1a
	mov	eax, [edi+18h]
	mov	ebx, [edi+1Ch]
	dec	eax
	cmp	eax, 200h
	jae	@@1a
	add	eax, 3
	add	ebx, eax
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	mov	edx, [edi+18h]
	xor	ebx, ebx
	lea	ecx, [edx+2]
	sub	eax, ecx
	jb	@@1a
	xchg	ebx, eax

	mov	edi, [@@D]
	push	edx
	push	edi
@@1c:	rol	byte ptr [edi], 4
	inc	edi
	dec	edx
	jne	@@1c
	call	_ArcName
	inc	edi
	inc	edi

	call	_ArcConv, edi, ebx
@@1a:	call	_MemFree, [@@D]
@@8:	add	esi, 4
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
