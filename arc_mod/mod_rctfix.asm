
_mod_rctfix PROC
	push	ebp
	mov	ebp, esp
	dec	eax
	dec	eax
	shr	eax, 1
	jne	@@9a
	mov	esi, [ebp+0Ch]
	call	_TgaCommentSize, esi
	test	eax, eax
	je	@@9a
	call	_string_num, dword ptr [ebp+10h]
	jc	@@9a
	xchg	ebx, eax
	call	_Bm32ReadFile, esi
	jc	@@9a
	xchg	esi, eax

	mov	ecx, [esi+1Ch]
	lea	edi, [esi+20h]
	test	ecx, ecx
	je	@@9b
	xor	eax, eax
	repne	scasb
	jne	@@9b
	test	ecx, ecx
	jne	@@9b
	mov	ecx, [esi+1Ch]
	lea	edi, [esi+20h]
	lea	eax, [ecx+ecx+4+4*2]
	and	eax, -4
	sub	esp, eax
	call	_ansi_to_unicode, 932, edi, ecx, esp
	call	_unicode_ext, eax, esp
	mov	dword ptr [edx], '.' + 't' * 10000h
	mov	dword ptr [edx+4], 'g' + 'a' * 10000h
	and	dword ptr [edx+8], 0
	call	_Bm32ReadFile, esp
	mov	esp, ebp
	jc	@@9b
	xchg	edi, eax

	mov	eax, [esi]
	mov	edx, [esi+4]
	sub	eax, [edi]
	sub	edx, [edi+4]
	or	eax, edx
	jne	@@9
	call	@@ColorMask, esi, edi, ebx
	mov	eax, [ebp+8]
	call	_BmWriteTga, esi, dword ptr [ebp+0Ch+eax*8-10h]
@@9:	call	_MemFree, edi
@@9b:	call	_MemFree, esi
@@9a:	leave
	ret

@@ColorMask PROC

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
	shl	ecx, 2
	add	eax, ecx
	add	ecx, [esi+0Ch]
	mov	[@@D], eax
	mov	[@@S], ecx

	mov	ebx, [@@X]
	mov	esi, [esi+8]
	mov	edi, [edi+8]
	shl	ebx, 8
@@2:	mov	ecx, edx
@@3:	mov	eax, [edi]
	shl	eax, 8
	cmp	eax, ebx
	jne	@@4
	movsb
	movsb
	movsb
	inc	esi
	inc	edi
	jmp	@@5
@@4:	add	esi, 4
	add	edi, 4
@@5:	dec	ecx
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
