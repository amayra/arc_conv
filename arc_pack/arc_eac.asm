
_arc_eac PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P

	enter	@@stk, 0
	cmp	[@@PC], 0
	jne	@@9a
	mov	esi, [@@FL]
	mov	ebx, [esi]
	imul	ebx, 18h
	lea	edi, [ebx+4]
	mov	[@@P], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax
	movsd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	call	_string_copy_ansi, edi, 10h, dword ptr [esi+4]
	add	edi, 10h

	mov	ecx, [esi+2Ch]
	lea	edx, [esi+30h]
	lea	ebx, [ecx*8+ecx+7+4*8]
	shr	ebx, 3
	call	_ArcPackFile, [@@D], edx, ecx, ebx, 1, offset @@Pack, 0
	mov	ecx, [@@P]
	add	[@@P], eax
	stosd
	xchg	eax, ecx
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

@@Pack PROC
	mov	edx, [esp+4]
	mov	eax, [esp+10h]
	mov	ecx, [esp+8]
	mov	[edx], eax
	add	edx, 4
	sub	ecx, 4
	call	_lzss_pack, edx, ecx, dword ptr [esp+10h], eax
	add	eax, 4
	ret
ENDP

ENDP
