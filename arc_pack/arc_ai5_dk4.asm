
_arc_ai5_dk4 PROC
	mov	eax, 000290100h
	mov	ecx, 01663E1E9h
	mov	edx, 01BB6625Ch
	jmp	_mod_ai5
ENDP

_mod_ai5 PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L0, 0Ch

	enter	@@stk, 0
	mov	[@@L0], eax
	mov	[@@L0+4], ecx
	mov	[@@L0+8], edx
	movzx	ebx, ax
	cmp	[@@PC], 0
	jne	@@9a
	add	ebx, 8
	mov	esi, [@@FL]
	imul	ebx, [esi]
	add	ebx, 4
	mov	[@@P], ebx
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, ebx
	movsd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	movzx	ebx, word ptr [@@L0]
	call	_string_copy_ansi, edi, ebx, dword ptr [esi+4]
	mov	al, byte ptr [@@L0+2]
@@1d:	xor	[edi], al
	inc	edi
	dec	ebx
	jne	@@1d

	call	_ansi_ext, dword ptr [esi+8], dword ptr [esi+4]
	lea	edx, [esi+30h]
	cmp	eax, 'bil'
	je	@@1g
	cmp	eax, 'sem'
	je	@@1g
	call	_ArcAddFile, [@@D], edx, 0
	jmp	@@1h

@@1g:	mov	ecx, [esi+2Ch]
	lea	ebx, [ecx*8+ecx+7]
	shr	ebx, 3
	call	_ArcPackFile, [@@D], edx, ecx, ebx, 0, offset _lzss_pack, 0
@@1h:	mov	edx, [@@P]
	add	[@@P], eax
	xor	eax, [@@L0+4]
	xor	edx, [@@L0+8]
	stosd
	xchg	eax, edx
	stosd
	jmp	@@1

@@7:	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	mov	edx, [@@M]
	sub	edi, edx
	call	_FileWrite, ebx, edx, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
