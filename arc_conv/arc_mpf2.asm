
; "Unival! Paranormal Girls Strike!!" arc.dat
; unival.exe
; 004D2F80

	dw 0
_arc_mpf2 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@L0
@M0 @@L1
@M0 @@L2, 8

	enter	@@stk+20h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 20h
	jc	@@9a
	pop	eax
	pop	ecx
	cmp	eax, '2FPM'
	jne	@@9a
	pop	edi
	pop	ebx
	pop	[@@P]
	or	[@@L1], -1
	lea	eax, [@@M]
	call	_ArcMemRead, eax, ebx, edi, 0
	jc	@@9
	mov	esi, [@@M]
	call	_zlib_unpack, esi, ebx, edx, eax
	cmp	eax, ebx
	jne	@@9
	call	@@5
	lea	ecx, [eax-1]
	shr	ecx, 14h
	jne	@@9
	mov	[@@N], eax
	call	_ArcCount, eax
	call	_ArcDbgData, esi, ebx
	call	_ArcUnicode, 1

	call	_FileGetSize, [@@S]
	jc	@@9
	mov	[@@L0], eax
	call	_ArcInputExt, '10a'
	mov	[@@L1], eax
	mov	esi, [@@M]

@@1:	cmp	dword ptr [esi+4], 0	; 0 - file, 1 - link
	jne	@@8
	mov	eax, [esi]
	mov	edx, 210h
	sub	eax, edx
	add	edx, esi
	shr	eax, 1
	call	_ArcName, edx, eax
	and	[@@D], 0
	mov	ebx, [esi+8]
	mov	edx, [esi+0Ch]
	mov	edi, [@@L0]
	add	ebx, [@@P]
	adc	edx, 0
	jc	@@1a
	cmp	ebx, edi
	jae	@@1b
	mov	[@@L2], ebx
	call	_FileSeek, [@@S], ebx, 0
	jc	@@1a
	mov	ecx, [esi+14h]
	xor	eax, eax

	add	ebx, ecx
	jc	@@1a
	sub	ebx, edi
	jbe	@@1c
	call	_FileSeek, [@@L1], 0, 0
	jc	@@1a
	mov	ecx, [esi+14h]
	xchg	eax, ebx
	sub	ecx, eax
	jmp	@@1c

@@1b:	sub	ebx, edi
	call	_FileSeek, [@@L1], ebx, 0
	jc	@@1a
	xor	ecx, ecx
	mov	eax, [esi+14h]
@@1c:	mov	[@@L2], ecx
	mov	[@@L2+4], eax

	mov	edi, [esi+18h]
	mov	eax, [esi+14h]
	cmp	dword ptr [esi+10h], 0
	jne	$+4
	xor	edi, edi
	add	eax, edi
	jc	@@1a
	call	_MemAlloc, eax
	jc	@@1a
	mov	[@@D], eax
	add	edi, eax

	mov	ebx, [@@L2]
	test	ebx, ebx
	je	@@1d
	call	_FileRead, [@@S], edi, ebx
	xchg	ebx, eax
	jc	@@1e
@@1d:	mov	eax, [@@L2+4]
	test	eax, eax
	je	@@1e
	lea	edx, [edi+ebx]
	call	_FileRead, [@@L1], edx, eax
	add	ebx, eax
@@1e:	cmp	dword ptr [esi+10h], 0
	je	@@1a
	call	_zlib_unpack, [@@D], dword ptr [esi+18h], edi, ebx
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, [esi]
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_FileClose, [@@L1]
	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5 PROC
	push	ebx
	push	esi
	xor	ecx, ecx
@@1:	mov	eax, [esi]
	sub	ebx, eax
	jb	@@9
	add	esi, eax
	sub	eax, 210h
	jb	@@9
	shr	eax, 1
	jc	@@9
	inc	ecx
	jmp	@@1
@@9:	xchg	eax, ecx
	pop	esi
	pop	ebx
	ret
ENDP

ENDP
