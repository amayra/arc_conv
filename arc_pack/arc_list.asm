
_arc_list PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M

	enter	@@stk, 0
	cmp	[@@PC], 0
	jne	@@9a
	mov	esi, [@@FL]
	mov	ecx, [esi-8]
	lodsd
	lea	ebx, [ecx+eax*2]
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax

@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	call	_sjis_slash, dword ptr [esi+4]
	mov	ecx, [esi+8]
	push	esi
	mov	esi, [esi+4]
	rep	movsb
	pop	esi
	mov	al, 0Dh
	stosb
	mov	al, 0Ah
	stosb
	jmp	@@1

@@7:	mov	esi, [@@M]
	sub	edi, esi
	call	_FileWrite, [@@D], esi, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_arc_tree PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M

	enter	@@stk, 0
	cmp	[@@PC], 0
	jne	@@9a
	mov	esi, [@@FL]
	mov	ecx, [esi-8]
	lodsd
	imul	ebx, eax, 24h+2
	lea	ebx, [ebx+ecx*2]
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax

	push	0
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@1a
	mov	ecx, [esi+8]
	lea	eax, [esi+0Ch]
	inc	ecx
	push	esi
	mov	esi, [esi+4]
	rep	movsw
	xchg	esi, eax
	mov	cl, 9
	rep	movsd
	pop	esi
	test	byte ptr [esi+0Ch], 10h
	je	@@1
	push	esi
	sub	esi, 4
	jmp	@@1

@@1a:	pop	esi
	test	esi, esi
	je	@@7
	xor	eax, eax
	stosw
	jmp	@@1

@@7:	mov	esi, [@@M]
	sub	edi, esi
	call	_FileWrite, [@@D], esi, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
