
_mod_nsa_alpha PROC
	push	ebp
	mov	ebp, esp
	dec	eax
	shr	eax, 1
	jne	@@9a
	call	_Bm32ReadFile, dword ptr [ebp+0Ch]
	jc	@@9a
	xchg	esi, eax

	shr	dword ptr [esi], 1
	jc	@@9
	call	@@4, esi
	mov	eax, [ebp+8]
	call	_BmWriteTga, esi, dword ptr [ebp+0Ch+eax*4-4]
@@9:	call	_MemFree, esi
@@9a:	leave
	ret

@@4 PROC

@@D = dword ptr [ebp+14h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	edi, [@@D]
	mov	ebx, [edi]
	push	dword ptr [edi+4]
	mov	ecx, ebx
	mov	eax, [edi+0Ch]
	neg	ecx
	lea	eax, [eax+ecx*4]
	mov	[@@D], eax

	mov	edi, [edi+8]
@@1:	mov	esi, ebx
@@2:	movzx	eax, byte ptr [edi+ebx*4]
	movzx	edx, byte ptr [edi+ebx*4+1]
	movzx	ecx, byte ptr [edi+ebx*4+2]
	imul	eax, 132h
	imul	edx, 259h
	imul	ecx, 75h
	add	eax, edx
	add	eax, ecx
	shr	eax, 0Ah
	not	eax
	add	edi, 3
	stosb
	dec	esi
	jne	@@2
	add	edi, [@@D]
	dec	dword ptr [ebp-4]
	jne	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP

ENDP
