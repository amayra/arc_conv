
_mod_lwg PROC

@@M = dword ptr [ebp-4]
@@D = dword ptr [ebp-8]
@@L0 = dword ptr [ebp-0Ch]
@@L1 = dword ptr [ebp-10h]
@@L2 = dword ptr [ebp-14h]

	push	ebp
	mov	ebp, esp
	lea	ebx, [eax-2]
	cmp	ebx, 2
	jae	@@9a
	call	@@2, dword ptr [ebp+0Ch]
	test	eax, eax
	je	@@9a
	xchg	esi, eax
	push	esi
	call	_FileCreate, dword ptr [ebp+0Ch+ebx*8], FILE_OUTPUT
	jc	@@9
	push	eax
	mov	ecx, [esi+14h]
	add	ecx, 1Ch
	push	0
	lea	edx, [esi+ecx]
	push	ecx
	push	edx
	call	_FileWrite, [@@D], esi, ecx

	call	_unicode_name, dword ptr [ebp+10h]
	call	_stack_sjis, eax
	call	_ansi_ext, eax, esp
	mov	byte ptr [edx], 0
	mov	[@@L1], ecx

	mov	ebx, [esi+0Ch]
	add	esi, 18h
@@1:	mov	edi, esp
	movzx	ecx, byte ptr [esi+11h]
	cmp	ecx, [@@L1]
	jne	@@1a
	push	esi
	add	esi, 12h
	rep	cmpsb
	pop	esi
@@1a:	jne	@@1b
	call	@@3, [@@D], dword ptr [ebp+10h]
	mov	[esi+0Dh], eax
	jmp	@@1c

@@1b:	mov	edx, [esi+9]
	mov	ecx, [esi+0Dh]
	add	edx, [@@L2]
	call	_FileWrite, [@@D], edx, ecx
@@1c:	mov	ecx, [@@L0]
	add	[@@L0], eax
	mov	[esi+9], ecx

	movzx	ecx, byte ptr [esi+11h]
	lea	esi, [esi+12h+ecx]
	dec	ebx
	jne	@@1
	mov	ecx, [@@L0]
	mov	[esi], ecx
	call	_FileSeek, [@@D], 0, 0
	mov	esi, [@@M]
	mov	ecx, [esi+14h]
	add	ecx, 1Ch
	call	_FileWrite, [@@D], esi, ecx
	call	_FileClose, [@@D]
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3 PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	enter	0FFCh, 0
	push	ecx
	mov	esi, esp
	xor	ebx, ebx
	mov	edi, 1000h
	call	_FileCreate, [@@S], FILE_INPUT
	jc	@@9
	mov	[@@S], eax
@@1:	call	_FileRead, [@@S], esi, edi
	test	eax, eax
	je	@@2
	call	_FileWrite, [@@D], esi, eax
	add	ebx, eax
	cmp	eax, edi
	je	@@1
@@2:	call	_FileClose, [@@S]
@@9:	xchg	eax, ebx
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

@@2 PROC

@@S = dword ptr [ebp+14h]

@@L0 = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	xor	edi, edi
	call	_FileCreate, [@@S], FILE_INPUT
	jc	@@9a
	mov	[@@S], eax
	call	_FileGetSize, [@@S]
	cmp	eax, 1Ch
	jl	@@9b
	xchg	ebx, eax
	call	_MemAlloc, ebx
	jc	@@9b
	xchg	edi, eax
	call	_FileRead, [@@S], edi, ebx
	jc	@@9
	mov	eax, [edi+14h]
	sub	ebx, 1Ch
	sub	ebx, eax
	jb	@@9
	push	ebx	; @@L0
	xchg	ebx, eax
	cmp	dword ptr [edi], 1474Ch
	jne	@@9
	mov	ecx, [edi+0Ch]
	lea	edx, [edi+18h]
	test	ecx, ecx
	je	@@9
@@1:	sub	ebx, 12h
	jb	@@9
	mov	eax, [edx+9]
	add	eax, [edx+0Dh]
	jc	@@9
	cmp	[@@L0], eax
	jb	@@9
	movzx	eax, byte ptr [edx+11h]
	sub	ebx, eax
	jb	@@9
	lea	edx, [edx+12h+eax]
	dec	ecx
	jne	@@1
	jmp	@@9b

@@9:	call	_MemFree, edi
	xor	edi, edi
@@9b:	call	_FileClose, [@@S]
@@9a:	xchg	eax, edi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP

ENDP
