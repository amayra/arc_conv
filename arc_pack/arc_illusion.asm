
_arc_illusion PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L0
@M0 @@L2

	enter	@@stk, 0
	cmp	[@@PC], 1
	jne	@@9a
	mov	ebx, [@@PB]
	call	_pp_select, dword ptr [ebx]
	jc	@@9a
	dec	eax
	je	_mod_illusion_sb3
	mov	[@@L0], eax

	mov	esi, [@@FL]
	mov	ebx, [esi]
	imul	ebx, 10Ch
	add	ebx, 9
	mov	[@@P], ebx
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, ebx

	mov	edx, 0DE022C34h
	cmp	[@@L0], 4	; 0x03 ^ 0x34
	sbb	eax, eax
	lea	eax, [eax+eax+37h]
	stosb
	lodsd
	xor	eax, edx
	stosd
	mov	ecx, [@@P]
	xor	edx, ecx
	mov	[edi+ecx-9], edx

@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	mov	ebx, 104h
	call	_string_copy_ansi, edi, ebx, dword ptr [esi+4]
	add	edi, ebx

	mov	eax, [esi+2Ch]
	mov	ecx, [@@P]
	stosd
	xchg	eax, ecx
	stosd

	lea	edx, [esi+30h]
	lea	eax, [@@L2]
	call	_ArcLoadFile, eax, edx, 0, ecx, 0
	jc	@@1b
	mov	edx, [@@L2]
	mov	ecx, [esi+2Ch]
	call	_pp_crypt, [@@L0], edx, ecx
	mov	edx, [@@L2]
	mov	ecx, [esi+2Ch]
	add	[@@P], ecx
	call	_FileWrite, [@@D], edx, ecx
@@1b:	call	_MemFree, [@@L2]
	jmp	@@1

@@7:	add	edi, 4
	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	mov	esi, [@@M]
	mov	eax, [@@P]
	sub	edi, esi
	lea	edx, [esi+5]
	lea	ecx, [edi-9]
	call	_pp_crypt, 0, edx, ecx
	call	_FileWrite, ebx, esi, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_mod_illusion_sb3 PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L0
@M0 @@L2

	lea	esp, [ebp-@@stk]

	mov	esi, [@@FL]
	mov	ebx, [esi]
	imul	ebx, 24h
	add	ebx, 8
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, ebx
	lodsd
	mov	ebx, eax
	stosd
	stosd
	shl	ebx, 5
	and	[@@P], 0
	add	ebx, edi

@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	call	_string_copy_ansi, edi, 20h, dword ptr [esi+4]
	push	ebx
	push	20h
	pop	ebx
	call	@@5
	pop	ebx
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, offset @@5
	mov	[ebx], eax
	add	ebx, 4
	add	[@@P], eax
	jmp	@@1

@@7:	mov	edi, ebx
	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	mov	esi, [@@M]
	mov	eax, [@@P]
	sub	edi, esi
	mov	[esi+4], eax
	call	_FileWrite, ebx, esi, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5:	neg	byte ptr [edi]
	inc	edi
	dec	ebx
	jne	@@5
	ret
ENDP
