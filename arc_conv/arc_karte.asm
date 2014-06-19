
; "Karte von Schnee" *.dat
; KARTE.EXE 0040E380

	dw _conv_karte-$-2
_arc_karte PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	mov	edi, 24B7935Bh
	pop	ebx
	add	ebx, edi
	lea	ecx, [ebx-4]
	ror	ecx, 2
	mov	[@@N], ecx
	dec	ecx
	shr	ecx, 14h
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 4, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	edx, [esi+4]
	mov	[esi], ebx
	mov	ecx, [@@N]
	lea	eax, [edi+edi]
@@2a:	add	[edx], eax
	add	edx, 4
	add	eax, edi
	dec	ecx
	jne	@@2a
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	and	[@@D], 0
	mov	eax, [esi]
	mov	ebx, [esi+4]
	sub	ebx, eax
	jb	@@9
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 4
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_karte PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	sub	ebx, 0Ch
	jb	@@9
	cmp	dword ptr [esi], 10001FFh
	je	@@1
	; 1FFh = extra_data
	; 0040E877 unplen + packdata, sub 0x37
@@9:	stc
	leave
	ret

@@1:	movzx	edi, word ptr [esi+4]
	movzx	edx, word ptr [esi+6]
	mov	ebx, edi
	imul	ebx, edx
	shl	ebx, 1
	cmp	[esi+8], ebx
	jne	@@9
	call	_ArcTgaAlloc, 2, edi, edx
	lea	edi, [eax+12h]
	mov	ecx, [@@SC]
	add	esi, 0Ch
	sub	ecx, 0Ch
	call	@@Unpack, edi, ebx, esi, ecx
	shr	ebx, 1
@@1a:	movzx	eax, word ptr [edi+ebx*2-2]
	ror	eax, 5
	shr	ax, 1
	sbb	edx, edx
	shl	ax, 3
	and	edx, 40404h
	shl	ah, 3
	rol	eax, 8
	add	eax, edx
	mov	edx, 0C0C0C0C0h
	and	edx, eax
	shr	edx, 6
	add	eax, edx
	lea	edx, [ebx*2+ebx]
	mov	[edi+edx-3], al
	shr	eax, 8
	mov	[edi+edx-2], ax
	dec	ebx
	jne	@@1a
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
@@1a:	jnc	@@1b
	dec	[@@SC]
	js	@@9
	dec	[@@DC]
	js	@@9
	movsb
	jmp	@@1

@@1b:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
	mov	ecx, edx
	shr	edx, 4
	je	@@9
	and	ecx, 0Fh
	neg	edx
	add	ecx, 3
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jns	@@2b
@@2a:	mov	byte ptr [edi], 0
	inc	edi
	dec	ecx
	je	@@1
	inc	eax
	jne	@@2a
@@2b:	push	esi
	lea	esi, [edi+edx]
	rep	movsb
	pop	esi
	jmp	@@1

@@7:	xor	esi, esi
@@9:	xchg	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

ENDP
