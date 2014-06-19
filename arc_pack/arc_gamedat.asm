
_arc_gamedat PROC

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
	cmp	[@@PC], 1
	jne	@@9a
	mov	esi, [@@PB]
	mov	esi, [esi]
	movzx	eax, word ptr [esi]
	sub	eax, 31h
	cmp	eax, 2
	jae	@@9a
	cmp	word ptr [esi+2], 0
	jne	@@9a
	mov	[@@L0], eax

	mov	esi, [@@FL]
	call	_filelist_sort, esi, offset _fncmp_ansi_upper, 0

	mov	eax, [@@L0]
	inc	eax
	shl	eax, 4
	mov	[@@L1], eax
	lea	ebx, [eax+8]
	imul	eax, [esi]
	imul	ebx, [esi]
	add	eax, 10h
	lea	edi, [ebx+10h]
	mov	[@@L2], eax
	and	[@@P], 0
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	add	[@@L2], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax

	mov	eax, 'EMAG'
	stosd
	mov	eax, ' TAD'
	stosd
	mov	eax, 'CAP'
	stosd
	mov	al, 'K'
	cmp	[@@L0], 0
	je	$+4
	mov	al, '2'
	mov	[edi-1], al
	movsd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	call	_string_copy_ansi, edi, [@@L1], dword ptr [esi+4]
	add	edi, [@@L1]

	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
	mov	ecx, [@@L2]
	mov	edx, [@@P]
	mov	[ecx+4], eax
	mov	[ecx], edx
	add	ecx, 8
	add	[@@P], eax
	mov	[@@L2], ecx
	jmp	@@1

@@7:	mov	edi, [@@L2]
	mov	esi, [@@M]
	mov	ebx, [@@D]
	sub	edi, esi
	call	_FileSeek, ebx, 0, 0
	call	_FileWrite, ebx, esi, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
