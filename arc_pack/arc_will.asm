
_arc_will PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L0
@M0 @@L1
@M0 @@L2

	enter	@@stk, 0
	mov	ecx, [@@PC]
	push	8
	pop	eax
	test	ecx, ecx
	je	@@2g
	dec	ecx
	jne	@@9a
	mov	esi, [@@PB]
	call	_string_num, dword ptr [esi]
	jc	@@9a
	mov	ecx, eax
	shr	ecx, 9
	jne	@@9a
@@2g:	add	eax, 9
	mov	[@@L2], eax

	mov	esi, [@@FL]
	lodsd
	xor	ebx, ebx
@@2a:	mov	esi, [esi]
	test	esi, esi
	je	@@2b
	call	@@FindExt
	je	@@2c
	test	bl, bl
	js	@@2a
	inc	ebx
	push	0
	push	0
	push	eax
	mov	edx, esp
@@2c:	inc	dword ptr [edx+4]
	jmp	@@2a
@@2b:	mov	[@@L0], ebx

	mov	esi, esp
	call	@@SortExt, esi, ebx
	lea	edi, [ebx*2+ebx+1]
	shl	edi, 2
	test	ebx, ebx
	je	@@2e
	mov	ecx, ebx
@@2d:	mov	eax, [@@L2]
	mov	[esi+8], edi
	imul	eax, [esi+4]
	add	esi, 0Ch
	add	edi, eax
	dec	ecx
	jne	@@2d
@@2e:	mov	[@@P], edi
	mov	[@@L1], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax

	xchg	eax, ebx
	stosd
	test	eax, eax
	je	@@9
	mov	esi, esp
	xchg	ebx, eax
@@2f:	lodsd
	push	0
	push	eax
	call	_sjis_upper, esp
	pop	eax
	pop	edx
	stosd
	movsd
	movsd
	dec	ebx
	jne	@@2f

	mov	esi, [@@FL]
	lodsd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@1a
	mov	ebx, [@@L0]
	call	@@FindExt
	jne	@@1
	mov	byte ptr [ecx], 0
	mov	edi, [edx+8]
	mov	ebx, [@@L2]
	add	edi, [@@M]
	add	[edx+8], ebx
	sub	ebx, 8
	call	_sjis_upper, dword ptr [esi+4]
	call	_string_copy_ansi, edi, ebx, dword ptr [esi+4]
	add	edi, ebx
	lea	eax, [esi+30h]
	stosd
	stosd
	jmp	@@1
@@1a:
	mov	esi, [@@M]
	lodsd
	xchg	ebx, eax
	test	ebx, ebx
	je	@@4b
@@4:	push	ebx
	mov	edi, [esi+8]
	mov	ebx, [esi+4]
	add	edi, [@@M]
	call	_will_sort, edi, ebx, [@@L2], 8
@@4a:	add	edi, [@@L2]
	call	_ArcAddFile, [@@D], dword ptr [edi-8], 0
	mov	ecx, [@@P]
	add	[@@P], eax
	mov	[edi-8], eax
	mov	[edi-4], ecx
	dec	ebx
	jne	@@4a
	pop	ebx
	add	esi, 0Ch
	dec	ebx
	jne	@@4
@@4b:
	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	call	_FileWrite, ebx, [@@M], [@@L1]
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@SortExt PROC

@@S = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@S]
	xor	ecx, ecx
	jmp	@@4
@@1:	mov	eax, [ebx-0Ch]
	mov	edx, [ebx]
	bswap	eax
	bswap	edx
	cmp	edx, eax
	jae	@@4
	bswap	eax
	bswap	edx
	mov	[ebx], eax
	mov	[ebx-0Ch], edx
	mov	eax, [ebx-8]
	mov	edx, [ebx+4]
	mov	[ebx+4], eax
	mov	[ebx-8], edx
	sub	ebx, 0Ch
	cmp	ebx, esi
	jne	@@1
@@4:	inc	ecx
	lea	ebx, [ecx*2+ecx]
	lea	ebx, [esi+ebx*4]	
	cmp	ecx, [@@C]
	jb	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

@@FindExt PROC
	call	_ansi_ext, dword ptr [esi+8], dword ptr [esi+4]
	push	edx
	mov	ecx, ebx
	test	ebx, ebx
	je	@@9
	lea	edx, [esp+8]
@@1:	cmp	eax, [edx]
	je	@@7
	add	edx, 0Ch
	dec	ecx
	jne	@@1
@@9:	dec	ecx
@@7:	pop	ecx
	ret
ENDP

ENDP

_will_sort PROC

@@S = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]
@@A = dword ptr [ebp+1Ch]
@@X = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edx, [@@A]
	xor	ebx, ebx
	jmp	@@4

@@1:	mov	ecx, edx
	mov	edi, esi
	sub	ecx, [@@X]
	sub	esi, edx
	repe	cmpsb
	je	@@4
	dec	esi
	add	ecx, 1+3
	mov	al, [esi]
	cmp	[esi+edx], al
	jae	@@4
@@2:	mov	eax, [esi]
	mov	edi, [esi+edx]
	mov	[esi+edx], eax
	mov	[esi], edi
	add	esi, 4
	sub	ecx, 4
	jae	@@2
	lea	esi, [esi+ecx-3]
	add	esi, [@@X]
if 0
	and	ecx, 3
	je	@@5
@@3:	mov	al, [esi]
	mov	ah, [esi+edx]
	mov	[esi+edx], ah
	mov	[esi], al
	inc	esi
	dec	ecx
	jne	@@3
@@5:	sub	esi, 4
	add	esi, [@@X]
endif
	sub	esi, edx
	cmp	esi, [@@S]
	jne	@@1
@@4:	inc	ebx
	mov	esi, edx
	imul	esi, ebx
	add	esi, [@@S]
	cmp	ebx, [@@C]
	jb	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP
