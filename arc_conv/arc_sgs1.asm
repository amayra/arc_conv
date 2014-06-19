
; "Viper-V8", "Viper-V10", "Viper-V16" SGS.DAT
; SGS.EXE
; 00415259 sgs_unpack
; 00415328 anm_unpack

	dw 0
_arc_sgs1 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	pop	edi
	pop	ebx
	sub	eax, '.SGS'
	sub	edx, ' TAD'
	sub	edi, '00.1'
	or	eax, edx
	lea	ecx, [ebx-1]
	or	eax, edi
	shr	ecx, 14h
	or	eax, ecx
	jne	@@9a
	mov	[@@N], ebx
	shl	ebx, 5
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 13h
	and	[@@D], 0
	mov	ebx, [esi+14h]
	mov	edi, [esi+18h]
	call	_FileSeek, [@@S], dword ptr [esi+1Ch], 0
	jc	@@1a
	lea	eax, [@@D]
	cmp	byte ptr [esi+13h], 0
	jne	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 20h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	call	_ArcMemRead, eax, edi, ebx, 0
	call	@@Unpack, [@@D], edi, edx, eax
	jmp	@@1b

@@Unpack PROC

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
@@1:	cmp	[@@DC], 0
	je	@@7
	shl	bl, 1
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@1a:	jc	@@1b
	dec	[@@SC]
	js	@@9
	dec	[@@DC]
	movsb
	jmp	@@1

@@1b:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
	mov	ecx, edx
	and	dh, 0Fh
	shr	ecx, 0Ch
	neg	edx
	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	push	esi
	lea	esi, [edi+edx]
	rep	movsb
	pop	esi
	jmp	@@1

@@7:	xor	esi, esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

ENDP
