
_mod_cv2 PROC

@@L0 = dword ptr [ebp-4]

	push	ebp
	mov	ebp, esp
	cmp	eax, 2
	jne	@@9a
	call	_Bm32ReadFile, dword ptr [ebp+0Ch]
	test	eax, eax
	je	@@9a
	xchg	esi, eax

	call	@@Img32, esi
	test	eax, eax
	je	@@9b
	push	edx	; @@L0
	xchg	esi, eax
	call	_MemFree, eax

	call	_FileCreate, dword ptr [ebp+10h], FILE_OUTPUT
	jc	@@9b
	xchg	edi, eax

	mov	eax, [@@L0]
	shl	eax, 18h
	push	0
	push	dword ptr [esi+8]
	push	dword ptr [esi+4]
	push	dword ptr [esi]
	push	eax
	lea	edx, [esp+3]
	call	_FileWrite, edi, edx, 11h

	mov	ecx, [esi+8]
	lea	edx, [esi+0Ch]
	imul	ecx, [esi+4]
	shl	ecx, 2
	call	_FileWrite, edi, edx, ecx
	call	_FileClose, edi
@@9b:	call	_MemFree, esi
@@9a:	leave
	ret

@@Img32 PROC

@@S = dword ptr [ebp+14h]

@@A = dword ptr [ebp-4]
@@H = dword ptr [ebp-8]
@@M = dword ptr [ebp-0Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@S]
	mov	eax, [esi]
	mov	ebx, [esi+4]
	mov	edx, eax
	neg	edx
	and	edx, 3
	push	edx
	add	eax, edx
	imul	eax, ebx
	shl	eax, 2
	add	eax, 0Ch
	call	_MemAlloc, eax
	jc	@@9
	push	ebx
	push	eax
	xchg	edi, eax

	mov	eax, [esi]
	stosd
	xchg	edx, eax
	mov	eax, ebx
	stosd
	mov	eax, [@@A]
	add	eax, edx
	stosd

	mov	ecx, edx
	mov	eax, [esi+0Ch]
	neg	ecx
	mov	esi, [esi+8]
	lea	eax, [eax+ecx*4]
	mov	[@@S], eax
	or	ebx, -1
@@1:	mov	ecx, edx
@@2:	lodsd
	stosd
	and	ebx, eax
	dec	ecx
	jne	@@2
	mov	ecx, [@@A]
	xor	eax, eax
	rep	stosd	
	add	esi, [@@S]
	dec	[@@H]
	jne	@@1
	pop	eax
@@9:	sar	ebx, 18h
	add	ebx, 1
	sbb	edx, edx
	add	edx, 4
	shl	edx, 3
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP

ENDP
