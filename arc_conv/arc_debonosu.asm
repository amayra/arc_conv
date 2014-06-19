
; "Toki o Kanaderu Waltz" *.pak

	dw 0
_arc_debonosu PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L1, 0Ch
@M0 @@P

	enter	@@stk+28h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 28h
	jc	@@9a
	pop	eax
	mov	edx, [esi+10h]
	movzx	ecx, word ptr [esi+4]
	sub	edx, 18h
	sub	ecx, 10h
	sub	eax, 'KAP'
	or	edx, ecx
	or	eax, edx
	jne	@@9a
	mov	ebx, [esi+20h]
	mov	edi, [esi+1Ch]
	test	ebx, ebx
	js	@@9a
	lea	ecx, [ebx+28h]
	mov	[@@P], ecx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, edi, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_zlib_raw_unpack, esi, edi, edx, eax
	jc	@@9
	xchg	ebx, eax
	call	_ArcDbgData, esi, ebx
	call	@@5
	lea	ecx, [eax-1]
	mov	[@@N], eax
	shr	ecx, 14h
	jne	@@9
	call	_ArcCount, eax
	mov	[@@L1+4], esp
	sub	esp, 200h
	mov	[@@L1], esp
	push	esp
	push	-1
@@1:	pop	ebx
	pop	edi
	test	ebx, ebx
	je	@@1
	dec	ebx
	push	edi
	push	ebx
	mov	ecx, [@@L1+4]
	lea	edx, [esi+34h]
	jmp	@@1e
@@1d:	cmp	edi, ecx
	je	$+3
	stosb
@@1e:	mov	al, [edx]
	inc	edx
	test	al, al
	jne	@@1d
	cmp	edi, ecx
	je	$+4
	mov	[edi], al
	test	byte ptr [esi+18h], 10h
	je	@@1b
	mov	al, 2Fh
	cmp	edi, ecx
	je	$+3
	stosb
	mov	eax, [@@L1]
	sub	eax, esp
	shr	eax, 7
	jne	@@9
	push	edi
	push	dword ptr [esi+8]
	mov	esi, edx
	jmp	@@1

@@1b:	mov	[@@L1+8], edx
	cmp	edi, [@@L1+4]
	je	@@1c
	call	_ArcName, [@@L1], -1
@@1c:	and	[@@D], 0
	mov	edi, [esi+8]
	mov	eax, [esi+0Ch]
	mov	ebx, [esi+10h]
	or	eax, [esi+14h]
	jne	@@1a
	mov	eax, [esi]
	mov	edx, [esi+4]
	add	eax, [@@P]
	adc	edx, 0
	jc	@@1a
	call	_FileSeek64, [@@S], eax, edx, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, edi, ebx, 0
	call	_zlib_raw_unpack, [@@D], edi, edx, eax
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	mov	esi, [@@L1+8]
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	mov	al, [edx]
	inc	edx
@@3a:	cmp	edi, [@@L1+4]
	je	@@3b
	stosb
	test	al, al
	jne	@@3
	dec	edi
@@3b:	ret

@@5 PROC
	push	ebx
	mov	edi, esi
	mov	ecx, ebx
	xor	edx, edx
@@1:	sub	ecx, 34h
	jb	@@9
	mov	ebx, [edi+18h]
	add	edi, 34h
	xor	eax, eax
	repne	scasb
	jne	@@9
	bt	ebx, 4
	sbb	edx, -1
	jmp	@@1
@@9:	xchg	eax, edx
	pop	ebx
	ret
ENDP

ENDP
