
_mod_ai6_rmt PROC
	push	ebp
	mov	ebp, esp
	cmp	eax, 2
	jne	@@9a
	call	_Bm32ReadFile, dword ptr [ebp+0Ch]
	test	eax, eax
	je	@@9a
	xchg	esi, eax

	call	@@2, esi
	test	eax, eax
	je	@@9b
	xchg	esi, eax
	call	_MemFree, eax

	call	_MemAlloc, dword ptr [esi+0Ch]
	test	eax, eax
	je	@@9b
	xchg	ebx, eax

	call	_FileCreate, dword ptr [ebp+10h], FILE_OUTPUT
	jc	@@9
	xchg	edi, eax

	mov	eax, [esi]
	mov	edx, [esi+4]
	mov	dword ptr [ebx], 20544D52h
	and	dword ptr [ebx+4], 0
	and	dword ptr [ebx+8], 0
	mov	[ebx+0Ch], eax
	mov	[ebx+10h], edx

	lea	ecx, [esi+10h]
	call	@@RMT, ecx, eax, edx

	lea	edx, [ebx+14h]
	lea	ecx, [esi+10h]
	call	_lzss_pack, edx, dword ptr [esi+0Ch], ecx, dword ptr [esi+8]
	add	eax, 14h
	call	_FileWrite, edi, ebx, eax
	call	_FileClose, edi
@@9:	call	_MemFree, ebx
@@9b:	call	_MemFree, esi
@@9a:	leave
	ret

@@RMT PROC

@@D = dword ptr [ebp+14h]
@@W = dword ptr [ebp+18h]
@@H = dword ptr [ebp+1Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	push	-4
	pop	ebx
	mov	edi, [@@D]
	mov	ecx, [@@H]
	imul	ebx, [@@W]
	mov	eax, ecx
	imul	eax, ebx
	sub	edi, eax
	call	@@2
	push	-4
	pop	ebx
	mov	ecx, [@@W]
	call	@@2
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@2:	dec	ecx
	je	@@2b
	imul	ecx, ebx
@@2a:	dec	edi
	mov	al, [edi+ebx]
	sub	[edi], al
	inc	ecx
	jne	@@2a
@@2b:	ret
ENDP

@@2 PROC

@@S = dword ptr [ebp+14h]

@@M = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@S]
	mov	eax, [esi]
	mov	ebx, [esi+4]
	imul	eax, ebx
	shl	eax, 2
	add	eax, 10h
	call	_MemAlloc, eax
	jc	@@9
	push	eax
	xchg	edi, eax

	mov	eax, [esi]
	stosd
	xchg	edx, eax
	mov	eax, ebx
	stosd
	imul	eax, edx
	shl	eax, 2
	stosd
	lea	eax, [eax*8+eax+7]
	shr	eax, 3
	stosd

	mov	eax, [esi+0Ch]
	mov	esi, [esi+8]
	lea	ecx, [ebx-1]
	imul	ecx, eax
	add	esi, ecx
	mov	ecx, edx
	neg	eax
	neg	ecx
	lea	eax, [eax+ecx*4]
	mov	[@@S], eax
@@1:	mov	ecx, edx
@@2:	movsd
	dec	ecx
	jne	@@2
	add	esi, [@@S]
	dec	ebx
	jne	@@1
	pop	eax
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP

ENDP

