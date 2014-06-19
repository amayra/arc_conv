
; "Dungeon Crusaderz ~Tales of Demon Eater~" *.arc
; CRUSADER.exe
; 004750F0 unpack

	dw _conv_wfl1-$-2
_arc_wfl1 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	enter	@@stk+4+208h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	eax
	cmp	eax, '1LFW'
	jne	@@9a
	mov	[@@N], 100000h
	call	@@3

@@1:	mov	edi, esp
	call	_FileRead, [@@S], edi, 4
	jc	@@9
	mov	ebx, [edi]
	lea	eax, [ebx-1]
	lea	ecx, [ebx+6]
	shr	eax, 8
	jne	@@9
	call	_FileRead, [@@S], edi, ecx
	jc	@@9
	mov	ecx, ebx
@@1b:	not	byte ptr [edi]
	inc	edi
	dec	ecx
	jne	@@1b
	mov	edi, esp
	call	_ArcName, edi, ebx
	and	[@@D], 0

	add	ebx, edi
	movzx	edi, word ptr [ebx]
	mov	ebx, [ebx+2]
	lea	edx, [@@L0]
	cmp	edi, 3
	jae	@@9
	and	dword ptr [edx], 0
	dec	edi
	jne	@@1c
	call	_FileRead, [@@S], edx, 4
	jc	@@9
@@1c:	lea	eax, [@@D]
	call	_ArcMemRead, eax, [@@L0], ebx, 0
	jnc	@@1d
	push	1
	pop	[@@N]
@@1d:	test	edi, edi
	jne	@@1a
	call	@@Unpack, [@@D], [@@L0], edx, eax
@@1a:	xchg	ebx, eax
	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	; ...
@@9a:	leave
	ret

@@3:	xor	edi, edi
	call	_ArcInputExt, 'ira'
	jc	@@3a
	xchg	esi, eax
	call	_FileGetSize, esi
	jc	@@3b
	xchg	ebx, eax
	call	_MemAlloc, ebx
	jc	@@3b
	xchg	edi, eax
	call	_FileRead, esi, edi, ebx
	xchg	ebx, eax
@@3b:	call	_FileClose, esi
	test	edi, edi
	je	@@3a
	mov	edx, edi
	xor	eax, eax
	jmp	@@5
@@5a:	mov	ecx, [edx]
	sub	ebx, ecx
	jb	@@5b
	lea	edx, [edx+ecx+4+6]
	cmp	word ptr [edx-6], 3
	jae	@@5b
	inc	eax
@@5:	sub	ebx, 4+6
	jae	@@5a
@@5b:	call	_ArcCount, eax
	call	_MemFree, edi
@@3a:	ret

@@Unpack PROC	; 004750F0

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
	xor	ecx, ecx
@@1:	call	@@3
	jnc	@@1a
	dec	[@@DC]
	js	@@9
	mov	cl, 8
	call	@@4
	stosb
	jmp	@@1

@@1a:	mov	cl, 0Ch
	call	@@4
	test	eax, eax
	xchg	edx, eax
	je	@@7
	mov	cl, 4
	call	@@4
	lea	ecx, [eax+2]
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
	sub	edx, eax
	dec	edx
	or	edx, -1000h
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@7:	mov	esi, [@@DC]
@@9:	xchg	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@3:	shl	bl, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@3a:	ret

@@4:	xor	eax, eax
@@4a:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@4a
	ret
ENDP

ENDP

_conv_wfl1 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 8
	jb	@@9
	mov	ecx, 'ggo'
	mov	eax, [esi]
	mov	edx, [esi+4]
	sub	eax, 'SggO'
	sub	dh, 2
	or	eax, edx
	jne	@@2
@@8:	call	_ArcSetExt, ecx
@@9:	stc
	leave
	ret

@@2:	cmp	ebx, 36h
	jb	@@9
	cmp	word ptr [esi], 'MB'
	jne	@@9
	cmp	dword ptr [esi+0Eh], 28h
	jne	@@9
	mov	ecx, 'pmb'
	jmp	@@8
ENDP
