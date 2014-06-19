
_majiro_arc_load PROC

@@S = dword ptr [ebp+14h]
@@D = dword ptr [ebp+18h]
@@L0 = dword ptr [ebp-0Ch]
@@M = dword ptr [ebp-10h]

	push	ebx
	push	esi
	push	edi
	enter	1Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 1Ch
	jc	@@9a
	mov	edi, offset @@sign
	push	0Ah
	pop	ecx
	repe	cmpsb
	jne	@@9a
	mov	cl, 5
	lodsb
	repe	cmpsb
	jne	@@9a
	sub	al, 31h
	cmp	al, 3
	jae	@@9a
	movzx	edi, al
	mov	eax, [@@L0]
	mov	edx, [@@L0+4]
	mov	ebx, [@@L0+8]
	lea	ecx, [eax-1]
	cmp	ebx, edx
	jb	@@9a
	shr	ecx, 14h
	jne	@@9a
	cmp	edi, 1
	adc	eax, 0
	lea	ecx, [edi+2]
	shl	eax, 2
	imul	eax, ecx
	add	eax, 1Ch
	cmp	eax, edx
	jne	@@9a
	sub	ebx, 1Ch
	imul	ecx, [@@L0], 0Ch
	add	ecx, 3
	add	ecx, ebx
	jc	@@9a
	call	_MemAlloc, ecx
	jb	@@9a
	mov	[@@M], eax
	xchg	esi, eax
	call	_FileRead, [@@S], esi, ebx
	jc	@@9
	mov	ecx, ebx
	mov	eax, [@@L0+4]
	lea	edx, [ebx+3]
	sub	eax, 1Ch
	and	edx, -4
	sub	ecx, eax
	add	eax, esi
	add	esi, edx
	mov	ebx, [@@L0]
	call	@@5
	mov	eax, [@@L0]
	jmp	@@8

@@9:	call	_MemFree, [@@M]
@@9a:	xor	eax, eax
@@8:	mov	edx, [@@D]
	mov	ecx, [@@M]
	mov	[edx], ecx
	mov	edx, esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@5:	push	ebx
	push	esi
	push	edi
	xchg	edi, eax
@@5a:	xor	eax, eax
	test	ecx, ecx
	je	@@5b
	mov	edx, edi
	repne	scasb
	je	@@5c
@@5b:	xor	edx, edx
@@5c:	mov	[esi], edx
	add	esi, 0Ch
	dec	ebx
	jne	@@5a
	pop	edi
	pop	esi
	pop	ebx
	xchg	eax, edi
	mov	edi, esi
	push	esi
	mov	esi, [@@M]
	test	eax, eax
	jne	@@4b
@@4a:	lodsd
	lodsd
	mov	ecx, [esi+4]
	sub	ecx, eax
	jae	$+4
	xor	ecx, ecx
	scasd
	stosd
	xchg	eax, ecx
	stosd
	dec	ebx
	jne	@@4a
	pop	esi
	ret

@@4b:	lea	esi, [esi+eax*4]
	scasd
	movsd
	movsd
	dec	ebx
	jne	@@4b
	pop	esi
	ret

@@sign	db 'MajiroArcV.000',0
ENDP

_majiro_mjo_decrypt PROC

@@S = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ebx, [@@C]
	mov	esi, [@@S]
	sub	ebx, 20h
	jb	@@9
	mov	edi, offset @@sign
	push	9
	pop	ecx
	repe	cmpsb
	jne	@@9
	lodsb
	mov	cl, 6
	repe	cmpsb
	jne	@@9
	cmp	al, 'V'
	je	@@7
	cmp	al, 'X'
	jne	@@9
	mov	ecx, [esi+8]
	shl	ecx, 3
	sub	ebx, ecx
	jb	@@9
	lea	esi, [esi+0Ch+ecx]
	lodsd
	sub	ebx, eax
	jb	@@9
	test	eax, eax
	je	@@7
	xchg	ebx, eax

	sub	esp, 400h
	xor	ecx, ecx
	mov	edi, esp
@@1:	mov	eax, ecx
	push	8
	pop	edx
@@2:	shr	eax, 1
	jnc	$+7
	xor	eax, 0EDB88320h
	dec	edx
	jne	@@2
	stosd
	inc	cl
	jne	@@1

	xor	ecx, ecx
@@3:	mov	al, [esp+ecx]
	inc	ecx
	xor	[esi], al
	inc	esi
	and	ecx, 3FFh
	dec	ebx
	jne	@@3

@@7:	mov	esi, [@@S]
	movzx	eax, byte ptr [esi+9]
	mov	byte ptr [esi+9], 'V'
	jmp	@@8

@@9:	xor	eax, eax
@@8:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@sign	db 'MajiroObj1.000', 0
ENDP
