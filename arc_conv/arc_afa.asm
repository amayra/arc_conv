
; "Daiteikoku" *.afa
; DLL\AFALoader.dll

; db 'AFAH'
; dd 1Ch
; db 'AlicArch'
; dd 1, 1, data_offset

; db 'INFO'
; dd blk_size, unp_size, filecount

; dir:
; dd name_size
; dd name_size_align4
; db 'name'
; dd file_index, time_low, time_high, data_offset, file_size

	dw _conv_afa-$-2
_arc_afa PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 10h
@M0 @@P, 8
@M0 @@SC

	enter	@@stk+1Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 1Ch
	jc	@@9a
	pop	eax
	pop	ecx
	pop	edx
	pop	ebx
	sub	eax, 'HAFA'
	sub	ecx, 1Ch
	sub	edx, 'cilA'
	sub	ebx, 'hcrA'
	or	eax, ecx
	or	edx, ebx
	or	eax, edx
	jne	@@9a
	push	1Ch
	and	[@@M], 0
	and	[@@P], 0
	pop	[@@P+4]
	call	@@3

	mov	esi, [@@M]
@@1:	sub	[@@SC], 1Ch
	jb	@@9
	mov	edi, [esi+4]
	mov	ecx, [esi]
	sub	[@@SC], edi
	jb	@@9
	cmp	edi, ecx
	jb	@@9
	add	esi, 8
	call	_ArcName, esi, ecx
	and	[@@D], 0
	lea	esi, [esi+edi+14h]
	mov	eax, [esi-8]
	mov	ebx, [esi-4]
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	lea	edi, [@@L0]
	call	_FileRead, [@@S], edi, 8
	jc	@@9
	mov	ecx, [edi+4]
	mov	eax, [edi]
	cmp	ecx, 8
	jb	@@9
	mov	edx, [@@P+4]
	add	[@@P+4], ecx
	jc	@@9
	cmp	eax, 'OFNI'
	je	@@3c
	cmp	eax, 'ATAD'
	jne	@@3a
	xchg	[@@P], edx
	test	edx, edx
	jne	@@9
@@3a:	call	_FileSeek, [@@S], [@@P+4], 0
	jc	@@9
@@3b:	cmp	[@@M], 0
	je	@@3
	cmp	[@@P], 0
	je	@@3
	ret

@@3c:	cmp	[@@M], 0
	jne	@@9
	lea	edx, [edi+8]
	call	_FileRead, [@@S], edx, 8
	jc	@@9
	mov	edx, [edi+4]
	mov	ebx, [edi+8]
	mov	ecx, [edi+0Ch]
	sub	edx, 10h
	jb	@@9
	mov	[@@N], ecx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, ebx, edx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_zlib_unpack, esi, ebx, edx, eax
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx
	mov	[@@SC], ebx
	jmp	@@3b
ENDP

_conv_afa PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]
@@M = dword ptr [ebp-0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'xca'
	je	@@1
	cmp	eax, 'ffa'
	je	@@2
	jmp	_conv_ald_sys
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 10h
	jb	@@9
	mov	eax, [esi]
	mov	ecx, [esi+8]
	sub	eax, 'XCA'
	sub	ecx, ebx
	or	eax, [esi+4]
	or	eax, ecx
	jne	@@9
	mov	edi, [esi+0Ch]
	add	esi, 10h
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	call	_zlib_unpack, edi, eax, esi, ebx
	xchg	ebx, eax
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

@@2:	cmp	ebx, 10h
	jb	@@9
	mov	eax, [esi]
	mov	ecx, [esi+8]
	mov	edx, 4D2h
	sub	eax, 'FFA'
	sub	ecx, ebx
	sub	edx, [esi+0Ch]
	or	eax, ecx
	or	eax, edx
	jne	@@9
	sub	ebx, 10h
	add	esi, 10h
	call	@@AFF, esi, ebx
	call	_ArcSetExt, 'fws'
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@AFF PROC
	push	ebx
	mov	ebx, [esp+0Ch]
	mov	edx, [esp+8]
	test	ebx, ebx
	je	@@9
	push	40h
	pop	eax
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	xor	ecx, ecx
@@1:	mov	al, byte ptr [@@T+ecx]
	inc	ecx
	xor	[edx], al
	inc	edx
	and	ecx, 0Fh
	dec	ebx
	jne	@@1
@@9:	pop	ebx
	ret	8

@@T	dd 0B78FBBC8h, 04A9943EDh, 0B05B7EA2h, 088F81868h
ENDP

ENDP

	dw 0
_arc_alice_slk PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 0Ch

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ebx
	pop	edi
	sub	eax, 'KLS'
	dec	edx
	lea	ecx, [edi-1]
	dec	edx
	shr	ecx, 14h
	or	eax, edx
	or	eax, ecx
	jne	@@9a
	mov	[@@N], edi
	lea	eax, [edi*4+edi+1]
	shl	eax, 2
	cmp	ebx, eax
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	lea	edi, [@@L0]
	call	_hex32_upper, dword ptr [esi+10h], edi
	call	_ArcName, edi, 8
	and	[@@D], 0
	mov	ebx, [esi+8]
	mov	eax, [esi+0Ch]
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	call	_FileSeek, [@@S], dword ptr [esi+4], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 14h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

	dw _conv_alice_red-$-2
_arc_alice_red PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ebx
	pop	edi
	sub	eax, 'RAA'
	lea	ecx, [ebx-1]
	or	eax, edx
	shr	ecx, 14h
	or	eax, ecx
	jne	@@9a
	mov	ecx, edi
	mov	[@@N], ebx
	sub	ecx, 10h
	jb	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 4, ecx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	[esi], edi
	call	_ArcCount, [@@N]
	sub	edi, 0Ch
	mov	[@@SC], edi

@@1:	mov	ecx, [@@SC]
	xor	eax, eax
	add	esi, 0Ch
	sub	ecx, 0Ch
	jb	@@9
	mov	edi, esi
	repne	scasb
	jne	@@9
	mov	[@@SC], ecx
	call	_ArcName, esi, -1
	and	[@@D], 0
	mov	ebx, [esi-8]
	mov	edx, [esi-0Ch]
	mov	eax, [esi-4]
	mov	esi, edi
	xchg	edi, eax
	call	_FileSeek, [@@S], edx, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	test	edi, edi
	jne	@@1a
	lea	edx, [@@D]
	call	@@ZLB, edx, ebx
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@ZLB PROC
	push	ebx
	push	esi
	push	edi
	mov	edx, [esp+10h]
	mov	ebx, [esp+14h]
	mov	esi, [edx]
	cmp	ebx, 10h
	jb	@@9
	lea	ecx, [ebx-10h]
	mov	eax, [esi]
	sub	ecx, [esi+0Ch]
	sub	eax, 'BLZ'
	or	eax, [esi+4]
	or	eax, ecx
	jne	@@9
	mov	edi, [esi+8]
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	mov	edx, [esp+10h]
	mov	[edx], edi
	lea	ecx, [ebx-10h]
	lea	edx, [esi+10h]
	call	_zlib_unpack, edi, eax, edx, ebx
	xchg	ebx, eax
	call	_MemFree, esi
@@9:	xchg	eax, ebx
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

ENDP

_conv_alice_red PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 8
	jb	@@9
	cmp	dword ptr [esi], 'TNQ'
	jne	@@9
	mov	eax, 'tnq'
	jmp	_conv_ald_sys
@@9:	stc
	leave
	ret
ENDP


