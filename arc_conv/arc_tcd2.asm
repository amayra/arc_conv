
; "ReNN ~Another Story of Works Doll~" *.tcd
; ReNN.exe

	dw 0
_arc_tcd2 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1
@M0 @@L2, 18h
@M0 @@I
@M0 @@L4, 0Ch

	enter	@@stk+88h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 88h
	jc	@@9a
	cmp	dword ptr [esi], '2DCT'
	jne	@@9a
	; esi+4 file_count
	add	esi, 8
	and	[@@L1], 0
	mov	[@@L0], esi

	; size, offset, dir_cnt, dir_size, name_cnt, name_size
	push	4
	pop	ecx
	xor	ebx, ebx
@@2a:	cmp	dword ptr [esi], 0
	je	@@2b
	mov	eax, [esi+4]	; file_cnt
	mov	edx, [esi+8]	; dir_cnt
	add	ebx, eax
	dec	eax
	dec	edx
	shr	eax, 0Fh	; 2000h
	shr	edx, 8		; 100h
	or	eax, edx
	jne	@@2f
	mov	eax, [esi+4]
	mov	edx, [esi+8]
	shl	eax, 9
	shl	edx, 9
	cmp	eax, [esi+14h]	; filenames_size
	jb	@@2f
	cmp	edx, [esi+10h]	; dirnames_size
	jae	@@2b
@@2f:	jmp	@@9a

@@2b:	add	esi, 20h
	dec	ecx
	jne	@@2a
	test	ebx, ebx
	je	@@9a
	call	_ArcCount, ebx
	and	[@@L1], 0
	push	ecx
	mov	[@@L4+4], esp
	sub	esp, 200h

@@2c:	mov	edi, [@@L1]
	mov	esi, [@@L0]
	imul	eax, edi, 20h
	add	esi, eax
	cmp	dword ptr [esi], 0
	je	@@2d
	mov	ebx, [esi+8]
	mov	ecx, [esi+4]
	shl	ebx, 4
	add	ebx, [esi+10h]
	mov	[@@N], ecx
	add	ebx, [esi+14h]
	lea	ebx, [ebx+ecx*4+4]
	call	_FileSeek, [@@S], dword ptr [esi+0Ch], 0
	jc	@@1a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9

	mov	edx, [@@M]
	mov	ecx, [esi+10h]
	mov	[@@L2], edx
	mov	[@@L2+10h], ecx
	mov	al, [edx+ecx-1]
@@5a:	sub	[edx], al
	inc	edx
	dec	ecx
	jne	@@5a
	mov	[@@L2+4], edx
	xor	ebx, ebx
	mov	ecx, [esi+8]
@@5b:	cmp	ebx, [edx+8]
	jne	@@2e
	add	ebx, [edx]
	jc	@@2e
	add	edx, 10h
	dec	ecx
	jne	@@5b
	cmp	ebx, [esi+4]
	jne	@@2e
	mov	ecx, [esi+14h]
	mov	[@@L2+8], edx
	mov	[@@L2+14h], ecx
	mov	al, [edx+ecx-1]
@@5c:	sub	[edx], al
	inc	edx
	dec	ecx
	jne	@@5c
	mov	[@@L2+0Ch], edx

@@1:	mov	edx, [@@L2+4]
	mov	ebx, [esi+4]
	sub	ebx, [@@N]
	sub	ebx, [edx+8]
	jne	@@2g
	mov	edi, [@@L2]
	mov	ecx, [@@L2+10h]
	xor	eax, eax
	repne	scasb
	jne	@@2e
	mov	eax, [@@L2]
	mov	[@@L2], edi
	sub	edi, eax
	mov	[@@L2+10h], ecx
	lea	ecx, [edi-1]
	cmp	edi, 200h
	jae	@@2e
	mov	edi, esp
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	mov	al, 2Fh
	stosb
	mov	eax, [edx+4]
	mov	[@@L4], edi
	mov	[@@L4+8], eax
@@2g:	cmp	ebx, [edx]
	jb	@@1b
	add	[@@L2+4], 10h
	jmp	@@1

@@1b:	mov	edx, [@@L4+8]
	mov	ecx, [@@L2+14h]
	mov	edi, [@@L4]
	push	esi
	sub	ecx, edx
	jbe	@@1d
	mov	esi, [@@L2+8]
@@1c:	mov	al, [esi+edx]
	inc	edx
	test	al, al
	je	@@1d
	cmp	edi, [@@L4+4]
	je	$+3
	stosb
	dec	ecx
	jne	@@1c
@@1d:	pop	esi
	mov	[@@L4+8], edx
	xor	eax, eax
	stosb
	mov	edx, esp
	call	_ArcName, edx, -1
	and	[@@D], 0
	mov	edx, [@@L2+0Ch]
	mov	eax, [edx+ebx*4]
	mov	ebx, [edx+ebx*4+4]
	sub	ebx, eax
	jb	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax

	mov	eax, [@@L1]
	shl	eax, 10h
	add	eax, '00$'
	call	_ArcSetExt, eax

	mov	edi, [@@D]
	cmp	[@@L1], 2
	jne	@@1a
	cmp	ebx, 14h
	jb	@@1a
	call	_ArcSetExt, 'dps'
	cmp	dword ptr [edi], '8DPS'
	je	@@1a
	mov	al, [edi+10h]
	add	al, [edi+12h]
	sub	[edi], al
	sub	[edi+1], al
	sub	[edi+2], al
	sub	[edi+3], al
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1

@@2e:	call	_ArcSkip, [@@N]
	call	_MemFree, [@@M]
@@2d:	inc	dword ptr [@@L1]
	and	[@@M], 0
	cmp	[@@L1], 4
	jb	@@2c
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
