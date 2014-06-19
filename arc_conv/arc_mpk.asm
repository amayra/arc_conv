
; "Evolimit" *.mpk

	dw _conv_mpk-$-2
_arc_mpk PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	edi
	pop	ebx
	mov	[@@N], ebx
	lea	ecx, [ebx-1]
	shr	ecx, 14h
	jne	@@9a
	imul	ebx, -28h
	call	_FileSeek, [@@S], ebx, 2
	cmp	eax, edi
	jne	@@9a
	neg	ebx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	eax, 58585858h
	mov	ecx, ebx
	mov	edx, esi
	shr	ecx, 2
@@2a:	xor	[edx], eax
	add	edx, 4
	dec	ecx
	jne	@@2a
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	mov	al, [esi]
	mov	edx, esi
	sub	al, 5Ch
	cmp	al, 1
	sbb	ecx, ecx
	sub	edx, ecx
	add	ecx, 28h
	call	_ArcName, edx, ecx
	and	[@@D], 0
	mov	ebx, [esi+24h]
	call	_FileSeek, [@@S], dword ptr [esi+20h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 28h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_mpk PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'rgm'
	jne	@@9
	sub	ebx, 0Ah
	jb	@@9
	movzx	eax, word ptr [esi]
	dec	eax
	jne	@@2
	cmp	ebx, [esi+6]
	jne	@@9
	mov	edi, [esi+2]
	add	esi, 0Ah
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	call	@@Unpack, edi, eax, esi, ebx
	xchg	ebx, eax
	call	_ArcSetExt, 'pmb'
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

@@9:	stc
	leave
	ret

@@2:	js	@@9
	push	eax	; @@L0
	dec	eax
	shl	eax, 2
	lea	ecx, [eax+0Ah]
	cmp	ebx, eax
	jb	@@9
	cmp	ecx, [esi+2]
	jne	@@9
	call	_ArcSetExt, 0
	push	edx	; @@L1
	xor	ebx, ebx
@@2a:	call	_ArcNameFmt, [@@L1], ebx
	db '\%05i.bmp',0
	pop	ecx
	mov	esi, [@@SB]
	mov	edx, [esi+2+ebx*4]
	push	ebx
	mov	ebx, [@@SC]
	add	esi, edx
	sub	ebx, edx
	jb	@@2c
	sub	ebx, 8
	jb	@@2c
	mov	edi, [esi]
	mov	eax, [esi+4]
	cmp	ebx, eax
	jb	@@2b
	xchg	ebx, eax
	add	esi, 8
	call	_MemAlloc, edi
	jc	@@2b
	xchg	edi, eax
	call	@@Unpack, edi, eax, esi, ebx
	xchg	ebx, eax
	call	_ArcData, edi, ebx
	call	_MemFree, edi
@@2b:	pop	ebx
	inc	ebx
	cmp	ebx, [@@L0]
	jbe	@@2a
@@2c:	clc
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
@@1:	xor	eax, eax
	cmp	[@@DC], eax
	je	@@7
	dec	[@@SC]
	js	@@9
	lodsb
	cmp	al, 20h
	jae	@@1a
	inc	eax
	sub	[@@SC], eax
	jb	@@9
	sub	[@@DC], eax
	jb	@@9
	xchg	ecx, eax
	rep	movsb
	jmp	@@1

@@1a:	lea	ecx, [eax+40h]
	and	al, 1Fh
	shr	ecx, 5
	mov	ah, al
	cmp	ecx, 9
	jne	@@1b
	dec	[@@SC]
	js	@@9
	movzx	ecx, byte ptr [esi]
	inc	esi
	add	ecx, 9
@@1b:	dec	[@@SC]
	js	@@9
	lodsb
	xchg	edx, eax
	sub	[@@DC], ecx
	jb	@@9
	not	edx
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
