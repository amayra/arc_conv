
; "Alice Parade" *.pac

	dw _conv_softpal_ap-$-2
_arc_softpal_ap PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	ebx
	lea	ecx, [ebx-1]
	shr	ecx, 14h
	jne	@@9a
	mov	edi, 3FEh
	mov	[@@N], ebx
	call	_FileSeek, [@@S], edi, 0
	jc	@@9a
	xchg	edi, eax
	imul	ebx, 18h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	add	edi, ebx
	mov	esi, [@@M]
	cmp	[esi+14h], edi
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 10h
	and	[@@D], 0
	mov	ebx, [esi+10h]
	call	_FileSeek, [@@S], dword ptr [esi+14h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 18h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_softpal_ap PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
;	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
;	cmp	eax, 'dgp'
;	jne	@@9
	sub	ebx, 24h
	jb	@@9
	lea	ecx, [ebx+0Ch]
	mov	eax, [esi+18h]
	sub	ecx, [esi+20h]
	sub	eax, 'C_00'
	or	eax, ecx
	je	@@1
@@9:	stc
	leave
	ret

@@1:	mov	edi, [esi+1Ch]
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	add	esi, 24h
	call	@@Unpack, edi, eax, esi, ebx
	xchg	ebx, eax
	call	_ArcSetExt, 'agt'
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

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
	shr	ebx, 1
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@1a:	jc	@@1b
	dec	[@@SC]
	js	@@9
	movzx	ecx, byte ptr [esi]
	inc	esi
	sub	[@@SC], ecx
	jb	@@9
	sub	[@@DC], ecx
	jb	@@9
	rep	movsb
	jmp	@@1

@@1b:	mov	eax, edi
	mov	edx, 0BB8h
	sub	eax, [@@DB]
	sub	[@@SC], 3
	jb	@@9
	cmp	eax, edx
	jb	$+3
	xchg	eax, edx
	movzx	edx, word ptr [esi]
	movzx	ecx, byte ptr [esi+2]
	add	esi, 3
	sub	[@@DC], ecx
	jb	@@9
	sub	edx, eax
	jae	@@9
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