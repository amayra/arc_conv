
_mod_ssdc43 PROC
	push	ebp
	mov	ebp, esp
	cmp	eax, 3
	jne	@@9a
	call	_Bm32ReadFile, dword ptr [ebp+0Ch]
	test	eax, eax
	je	@@9a
	xchg	edi, eax
	call	_Bm32ReadFile, dword ptr [ebp+10h]
	test	eax, eax
	je	@@9b
	xchg	esi, eax

	mov	eax, [esi]
	mov	edx, [esi+4]
	sub	eax, [edi]
	sub	edx, [edi+4]
	or	eax, edx
	jne	@@9
	call	@@4, esi, edi
	call	_BmWriteTga, esi, dword ptr [ebp+14h]
@@9:	call	_MemFree, esi
@@9b:	call	_MemFree, edi
@@9a:	leave
	ret

@@4 PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@S]
	mov	edi, [@@D]
	mov	ebx, [esi]
	push	dword ptr [esi+4]
	shl	ebx, 2
	mov	ecx, ebx
	mov	eax, [edi+0Ch]
	neg	ecx
	lea	eax, [eax+ecx]
	add	ecx, [esi+0Ch]
	mov	[@@D], eax
	mov	[@@S], ecx
	mov	esi, [esi+8]
	mov	edi, [edi+8]
@@2:	mov	ecx, ebx
@@3:	lodsb
	mov	edx, ecx
	and	edx, 3
	dec	edx
	je	@@4
	movzx	edx, byte ptr [edi]
	and	al, -10h
	shr	edx, 4
	or	al, [@@T+edx]
@@4:	stosb
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
	ret	8

@@T	db 00,01,02,03,04,05,06,07
	db 09,10,11,12,13,14,15,15
ENDP

ENDP
