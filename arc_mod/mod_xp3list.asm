
_mod_xp3list PROC

@@stk = 0
@M0 @@M
@M0 @@L1, 14h
@M0 @@L2, 14h

	push	ebp
	mov	ebp, esp
	lea	ecx, [eax-1]
	shr	ecx, 1
	jne	@@9a
	call	_FileCreate, dword ptr [ebp+0Ch+eax*4-4], FILE_INPUT
	jc	@@9a
	xchg	esi, eax
	push	ecx
	call	_xp3_findsign, esi
	call	_xp3_arc_load, esi, eax, esp
	xchg	ebx, eax
	call	_FileClose, esi
	test	ebx, ebx
	je	@@9a
	mov	esi, [@@M]
	sub	esp, 0Ch
	push	ebx
	push	esi
	sub	esp, 0Ch
	push	ebx
	push	2
	pop	ebx
@@2a:	push	esi
	call	_xp3_next, esp
	pop	esi
	jc	@@2b
	mov	edx, [@@L2+8]
	movzx	ecx, word ptr [edx+14h]
	lea	ebx, [ebx+ecx*2+4]
@@2b:	test	esi, esi
	jne	@@2a
	call	_MemAlloc, ebx
	jc	@@9
	xchg	edi, eax
	push	edi
	mov	ax, 0FEFFh
	stosw
@@1a:	lea	edx, [@@L1]
	call	_xp3_next, edx
	jc	@@1b
	mov	esi, [@@L1+8]
	movzx	ecx, word ptr [esi+14h]
	add	esi, 16h
	rep	movsw
	mov	eax, 0A000Dh
	stosd
@@1b:	cmp	[@@L1], 0
	jne	@@1a
	mov	ebx, edi
	pop	edi
	sub	ebx, edi

	mov	edx, [ebp+0Ch]
	cmp	dword ptr [ebp+8], 2
	jae	@@1d
	call	_FileCreateExt, edx, FILE_OUTPUT, 'txt'
	jmp	@@1e
@@1d:	call	_FileCreate, edx, FILE_OUTPUT
@@1e:	jc	@@1c
	push	eax
	call	_FileWrite, eax, edi, ebx
	call	_FileClose
@@1c:	call	_MemFree, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
