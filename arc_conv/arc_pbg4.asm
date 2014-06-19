
; "Touhou 7 - Perfect Cherry Blossom" *.dat

	dw 0
_arc_pbg4 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC
@M0 @@L1

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	ebx
	cmp	eax, '4GBP'
	jne	@@9a
	lea	eax, [ebx-1]
	mov	[@@N], ebx
	shr	eax, 14h
	jne	@@9a
	call	_FileSeek, [@@S], 0, 2
	jc	@@9a
	xchg	edi, eax
	mov	eax, [esi+8]
	mov	ebx, [esi+0Ch]
	sub	edi, eax
	jbe	@@9a
	mov	[@@L1], eax
	call	_FileSeek, [@@S], eax, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, ebx, edi, 0
	jc	@@9
	mov	esi, [@@M]
	call	_pbg_unpack, esi, ebx, edx, eax
	cmp	eax, ebx
	jne	@@9
	mov	[@@SC], ebx
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	mov	ecx, [@@SC]
	mov	edi, esi
	sub	ecx, 0Ch
	jbe	@@9
	xor	eax, eax
	repne	scasb
	jne	@@9
	push	ecx
	call	_ArcName, esi, -1
	pop	ecx
	lea	esi, [edi+0Ch]
	mov	[@@SC], ecx
	mov	edi, [@@L1]
	cmp	[@@N], 1
	je	@@1b
	test	ecx, ecx
	je	@@1b
	push	edi
	mov	edi, esi
	xor	eax, eax
	repne	scasb
	xchg	eax, edi
	pop	edi
	jne	@@1b
	cmp	ecx, 4
	jb	@@1b
	mov	edi, [eax]
@@1b:	mov	eax, [esi-0Ch]
	mov	ebx, [esi-8]
	and	[@@D], 0
	sub	edi, eax
	jbe	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, ebx, edi, 0
	call	_pbg_unpack, [@@D], ebx, edx, eax
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
