_mod_is256 PROC
	push	ebp
	mov	ebp, esp
	push	2
	pop	ebx
	dec	eax
	jne	@@9a
	call	_Bm32ReadFile, dword ptr [ebp+0Ch]
	test	eax, eax
	je	@@9a
	xchg	esi, eax
	call	@@2, esi
	xchg	ebx, eax
@@9:	call	_MemFree, esi
@@9a:	leave
	call    ExitProcess, ebx

@@2 PROC

@@S = dword ptr [ebp+14h]

	push	ebx
	push	esi
	push	edi
	enter	404h, 0
	mov	esi, [@@S]
	mov	ebx, [esi]
	mov	edx, [esi+4]
	mov	eax, [esi+0Ch]
	mov	ecx, ebx
	mov	[ebp-4], edx
	neg	ecx
	lea	eax, [eax+ecx*4]
	mov	esi, [esi+8]
	mov	[@@S], eax
	xor	ecx, ecx
	mov	edx, ebx
	lodsd
	jmp	@@4
@@2:	mov	edx, ebx
@@3:	lodsd
	mov	edi, esp
	push	ecx
	repne	scasd
	pop	ecx
	je	@@5
	test	ch, ch
	jne	@@9
@@4:	mov	[esp+ecx*4], eax
	inc	ecx
@@5:	dec	edx
	jne	@@3
	add	esi, [@@S]
	dec	dword ptr [ebp-4]
	jne	@@2
	dec	ecx
@@9:	movzx	eax, ch
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP

ENDP
