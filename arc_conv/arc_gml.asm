
; "Watashi no Puni Puni" *.g
; punipuni.exe
; 00466E60 unpack

	dw _conv_gml-$-2
_arc_gml PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@SC

	enter	@@stk+14h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 14h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ecx
	pop	ebx
	pop	esi
	sub	eax, '_LMG'
	sub	edx, 'CRA'
	mov	[@@P], ecx
	sub	ecx, 14h
	jb	@@9a
	or	eax, edx
	sub	ecx, esi
	or	eax, ecx
	jne	@@9a
	mov	eax, ebx
	sub	eax, 104h
	jb	@@9a
	mov	[@@SC], eax
	lea	eax, [@@M]
	call	_ArcMemRead, eax, ebx, esi, 0
	jc	@@9
	mov	edi, edx
	mov	ecx, esi
@@1c:	not	byte ptr [edi]
	inc	edi
	dec	ecx
	jne	@@1c
	call	_gml_unpack, [@@M], ebx, edx, esi
	jc	@@9
	mov	esi, [@@M]
	add	esi, 100h
	lodsd
	mov	[@@N], eax
	lea	ecx, [eax-1]
	shr	ecx, 14h
	jne	@@9
	call	_ArcCount, eax
	call	_ArcDbgData, [@@M], ebx

@@1:	lodsd
	sub	[@@SC], eax
	jb	@@9
	xchg	ebx, eax
	call	_ArcName, esi, ebx
	lea	esi, [esi+ebx+0Ch]
	mov	eax, [esi-0Ch]
	add	eax, [@@P]
	jc	@@1a
	and	[@@D], 0
	mov	ebx, [esi-8]
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	test	ebx, ebx
	je	@@1a
	push	-4
	pop	edx
	mov	edi, [@@D]
	mov	ecx, ebx
@@1d:	mov	al, [esi+edx]
	stosb
	dec	ecx
	je	@@1a
	inc	edx
	jne	@@1d
	mov	edx, [@@M]
@@1b:	movzx	eax, byte ptr [edi]
	mov	al, [edx+eax]
	stosb
	dec	ecx
	jne	@@1b
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_gml_unpack PROC

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
	mov	cl, dh
	shr	dh, 4
	not	ecx
	and	ecx, 0Fh
	add	ecx, 3
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
	sub	edx, eax
	add	edx, 12h
	or	edx, -1000h
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

_conv_gml PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'xgp'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 20h
	jb	@@9
	cmp	dword ptr [esi], 'XGP'
	jne	@@9
	cmp	ebx, [esi+14h]
	jb	@@9
	cmp	ebx, 4
	jb	@@9
	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	mov	ebx, edi
	imul	ebx, edx
	shl	ebx, 2
	call	_ArcTgaAlloc, 23h, edi, edx
	xchg	edi, eax
	mov	edx, [esi+4]
	sub	esi, [esi+14h]
	add	esi, [@@SC]
	mov	[esi], edx
	add	edi, 12h
	call	_gml_unpack, edi, ebx, esi, [@@SC]
	clc
	leave
	ret
ENDP
