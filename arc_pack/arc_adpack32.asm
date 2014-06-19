
_arc_adpack32 PROC

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
	shl	ebx, 5
	add	ebx, 30h
	mov	[@@P], ebx
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, ebx
	mov	eax, 'APDA'
	stosd
	mov	eax, '23KC'
	stosd
	mov	eax, 10000h
	stosd
	lodsd
	inc	eax
	stosd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	call	_string_copy_ansi, edi, 19h, dword ptr [esi+4]
	push	esi
	mov	esi, edi
	add	edi, 19h
	xor	eax, eax
	stosb
	call	@@3
	pop	esi
	stosw
	mov	eax, [@@P]
	stosd
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
	add	[@@P], eax
	jmp	@@1

@@7:	xor	eax, eax
	lea	ecx, [eax+7]
	rep	stosd
	mov	eax, [@@P]
	stosd
	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	mov	edx, [@@M]
	sub	edi, edx
	call	_FileWrite, ebx, edx, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

	; HinataBokko.exe 00407170
@@3:	xor	edx, edx
	mov	cl, 1
@@3a:	lodsb
	sub	al, 61h
	cmp	al, 1Ah
	sbb	ah, ah
	and	ah, -20h
	add	al, ah
	add	al, 61h
	je	@@3d
	xor	dh, al
@@3b:	shl	dx, 1
	jnc	@@3c
	xor	dx, 1021h
@@3c:	rol	cl, 1
	jnc	@@3b
	jmp	@@3a
@@3d:	xchg	eax, edx
	ret
ENDP
