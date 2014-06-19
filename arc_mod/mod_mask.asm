
_mod_mskn PROC
	push	-1
	jmp	@@4
_mod_mask:
	push	0
@@4:	pop	ebx
	push	ebp
	mov	ebp, esp
	dec	eax
	dec	eax
	shr	eax, 1
	jne	@@9a
	call	_Bm32ReadFile, dword ptr [ebp+0Ch]
	jc	@@9a
	xchg	edi, eax
	call	_BmReadFile, 2, dword ptr [ebp+10h]
	jc	@@9b
	xchg	esi, eax

	mov	eax, [esi]
	mov	edx, [esi+4]
	sub	eax, [edi]
	sub	edx, [edi+4]
	or	eax, edx
	jne	@@9
	call	@@Mask, edi, esi, ebx
	mov	eax, [ebp+8]
	call	_BmWriteTga, edi, dword ptr [ebp+0Ch+eax*8-10h]
@@9:	call	_MemFree, esi
@@9b:	call	_MemFree, edi
@@9a:	leave
	ret

@@Mask PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@X = dword ptr [ebp+1Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@S]
	mov	edi, [@@D]
	mov	edx, [esi]
	push	dword ptr [esi+4]
	mov	ecx, edx
	mov	eax, [edi+0Ch]
	neg	ecx
	lea	eax, [eax+ecx*4]
	add	ecx, [esi+0Ch]
	mov	[@@D], eax
	mov	[@@S], ecx

	mov	esi, [esi+8]
	mov	edi, [edi+8]
	mov	ebx, [@@X]
@@2:	mov	ecx, edx
@@3:	movzx	eax, byte ptr [esi]
	add	edi, 4
	xor	eax, ebx
	inc	esi
	mov	[edi-1], al
	dec	ecx
	jne	@@3
	add	esi, [@@S]
	add	edi, [@@D]
	dec	dword ptr [ebp-4]
	jne	@@2
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

ENDP
