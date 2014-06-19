
_mod_tga PROC
	push	ebp
	mov	ebp, esp
	lea	esi, [ebp+0Ch]
	xor	ebx, ebx
	sub	eax, 2
	je	@@1a
	dec	eax
	jne	@@9
	lodsd
	push	eax
	call	@@1b
	db '8',0, 'gs',0, '32',0, 'mskn',0, 'mask',0, 0
@@1b:	call	_string_select
	jc	@@9
	xchg	ebx, eax
@@1a:	lodsd
	push	eax
	cmp	ebx, 4
	jae	@@1c
	call	_BmReadFile, ebx
	jc	@@9
	xchg	ebx, eax
@@7:	lodsd
	call	_BmWriteTga, ebx, eax
	call	_MemFree, ebx
@@9:	leave
	ret

@@1c:	call	_Bm32ReadFile
	jc	@@9
	lea	ecx, [ebx-5]	; mask = 0, mskn = -1
	xchg	ebx, eax
	call	@@Mask, ebx, ecx

	sub	esp, 400h
	mov	edi, esp
	mov	eax, 0FF000000h
	mov	[ebx+18h], edi
@@1d:	stosd
	add	eax, 10101h
	jnc	@@1d
	jmp	@@7

@@Mask PROC

@@D = dword ptr [ebp+14h]
@@X = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@D]
	mov	edx, [esi]
	push	dword ptr [esi+4]
	mov	ecx, edx
	mov	eax, [esi+0Ch]
	neg	ecx
	lea	eax, [eax+ecx*4]
	mov	[@@D], eax

	mov	ebx, [@@X]
	mov	esi, [esi+8]
@@2:	mov	ecx, edx
	mov	edi, esi
@@3:	lodsd
	xor	eax, ebx
	shr	eax, 18h
	stosb
	dec	ecx
	jne	@@3
	add	esi, [@@D]
	dec	dword ptr [ebp-4]
	jne	@@2
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

ENDP
