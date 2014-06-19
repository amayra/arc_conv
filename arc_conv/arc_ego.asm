
; "Men at Work 2", "Men at Work 3" game0?.dat

	dw 0
_arc_ego PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	ebx
	mov	eax, [esi+4]
	mov	edx, [esi+0Ch]
	cmp	eax, 12h
	jb	@@9a
	sub	edx, 4
	sub	edx, ebx
	jne	@@9a
	cmp	ebx, 12h
	jb	@@9a
	lea	ecx, [ebx-0Ch]
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0Ch, ecx, 0
	jc	@@9
	mov	esi, [@@M]
	pop	dword ptr [esi]
	pop	dword ptr [esi+4]
	pop	dword ptr [esi+8]
	call	@@5
	test	eax, eax
	je	@@9
	mov	[@@N], eax
	call	_ArcCount, eax

@@1:	lea	edx, [esi+10h]
	call	_ArcName, edx, -1
	and	[@@D], 0
	mov	ebx, [esi+0Ch]
	call	_FileSeek, [@@S], dword ptr [esi+8], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, [esi]
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5 PROC
	push	ebx
	push	edi
	mov	edi, esi
	xor	edx, edx
@@1:	mov	ecx, [edi]
	add	edi, 10h
	sub	ebx, ecx
	jb	@@9
	cmp	ecx, 12h
	jb	@@9
	sub	ecx, 10h
	xor	eax, eax
	repne	scasb
	jne	@@9
	test	ecx, ecx
	jne	@@9
	inc	edx
	jmp	@@1

@@9:	xchg	eax, edx
	pop	edi
	pop	ebx
	ret
ENDP

ENDP
