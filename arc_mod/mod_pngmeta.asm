
_mod_pngmeta PROC
	push	ebp
	mov	ebp, esp
	sub	eax, 2
	shr	eax, 1
	jne	@@9b
	mov	ecx, [ebp+0Ch]
	call	@@PNGMeta
	push	edx
	push	eax

	call	_FileCreate, dword ptr [ebp+10h], FILE_INPUT
	jc	@@9a
	xchg	esi, eax
	xor	edi, edi
	call	_FileGetSize, esi
	jc	@@4
	cmp	eax, 21h
	jl	@@4
	xchg	ebx, eax
	call	_MemAlloc, ebx
	xchg	edi, eax
	jc	@@4
	call	_FileRead, esi, edi, ebx
	xchg	ebx, eax
@@4:	call	_FileClose, esi
	test	edi, edi
	je	@@9a
	mov	edx, 0A1A0A0Dh
	mov	eax, [edi]
	sub	edx, [edi+4]
	sub	eax, 474E5089h
	or	eax, edx
	jne	@@9

	mov	eax, [ebp+8]
	call	_FileCreate, dword ptr [ebp+8+eax*4], FILE_OUTPUT
	jc	@@9
	xchg	esi, eax
	call	_FileWrite, esi, edi, 21h
	call	_FileWrite, esi, dword ptr [ebp-8], dword ptr [ebp-4]
	sub	ebx, 21h
	add	edi, 21h
	jmp	@@1
@@2:	mov	eax, [edi]
	bswap	eax
	sub	ebx, eax
	lea	edi, [edi+eax+0Ch]
	jb	@@3
@@1:	sub	ebx, 0Ch
	jb	@@3
	cmp	dword ptr [edi+4], 'TADI'
	jne	@@2
	add	ebx, 0Ch
	call	_FileWrite, esi, edi, ebx
@@3:	call	_FileClose, esi
@@9:	call	_MemFree, edi
@@9a:	call	_MemFree, dword ptr [ebp-8]
@@9b:	leave
	ret

@@PNGMeta PROC
	push	ebx
	push	esi
	push	edi
	enter	24h, 0
	mov	edi, esp
	push	0
	push	0
	call	_FileCreate, ecx, FILE_INPUT
	jc	@@9a
	push	21h
	pop	ebx
	xchg	esi, eax
	call	_FileRead, esi, edi, ebx
	jc	@@9
	mov	edx, 0A1A0A0Dh
	mov	eax, [edi]
	sub	edx, [edi+4]
	sub	eax, 474E5089h
	or	eax, edx
	je	@@1
@@9:	call	_FileClose, esi
@@9a:	pop	eax
	pop	edx
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret

@@2:	mov	eax, [edi]
	bswap	eax
	add	eax, 0Ch
	jc	@@9
	add	ebx, eax
	jc	@@9
	call	_FileSeek, esi, ebx, 0
	jc	@@9
@@1:	call	_FileRead, esi, edi, 0Ch
	jc	@@9
	cmp	dword ptr [edi+4], 'TADI'
	jne	@@2
	sub	ebx, 21h
	jbe	@@9
	call	_FileSeek, esi, 21h, 0
	jc	@@9
	call	_MemAlloc, ebx
	mov	[ebp-2Ch], eax
	jc	@@9
	call	_FileRead, esi, eax, ebx
	mov	[ebp-28h], ebx
	jmp	@@9
ENDP

ENDP
