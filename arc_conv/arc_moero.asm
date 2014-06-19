
; "Moero Downhill Night Type R" bg.pkd

	dw 0
_arc_moero PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+90h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 90h
	jc	@@9a
	lodsd
	cmp	eax, 'KCAP'
	jne	@@9a
	mov	ecx, 88h
	lodsd
	mov	ebx, eax
	dec	eax
	shr	eax, 14h
	jne	@@9a
	mov	[@@N], ebx
	imul	ebx, ecx
	mov	edx, 0C5C5C5C5h
	lea	eax, [ebx+8]
	xor	eax, edx
	sub	edx, [ebp-@@stk-0Ch]
	sub	eax, [ebp-@@stk-4]
	or	eax, edx
	jne	@@9a
	sub	ebx, ecx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, ecx, ebx, 0
	jc	@@9
	mov	edi, [@@M]
	mov	edx, edi
	push	88h/4
	pop	ecx
	shr	ebx, 2
	add	ebx, ecx
	rep	movsd
	mov	esp, esi
	mov	esi, edx
@@2a:	xor	dword ptr [edx], 0C5C5C5C5h
	add	edx, 4
	dec	ebx
	jne	@@2a
	call	_ArcCount, [@@N]

@@1:	mov	ebx, 80h
	call	_ArcName, esi, ebx
	add	esi, ebx
	and	[@@D], 0
	mov	ebx, [esi]
	call	_FileSeek, [@@S], dword ptr [esi+4], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	mov	edx, [@@D]
	test	ebx, ebx
	je	@@1a
	mov	ecx, ebx
@@1b:	xor	byte ptr [edx], 0C5h
	inc	edx
	dec	ecx
	jne	@@1b
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 8
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
