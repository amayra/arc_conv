
; "Green Green" *.pcg, *.dat

	dw _conv_grgr-$-2
_arc_grgr PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	enter	@@stk+8, 0
	call	_unicode_ext, -1, offset inFileName
	push	30h
	pop	ecx
	cmp	eax, 'gcp'
	je	@@2a
	add	ecx, 18h
	cmp	eax, 'tad'
	jne	@@9a
@@2a:	mov	[@@L0], ecx

	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	ebx
	pop	eax
	lea	ecx, [ebx-1]
	mov	[@@N], ebx
	shr	ecx, 14h
	jne	@@9a
	imul	ebx, [@@L0]
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	mov	edi, [@@L0]
	cmp	edi, 30h
	jne	@@1b
	sub	edi, 8
@@1b:	sub	edi, 8
	call	_ArcName, esi, edi
	and	[@@D], 0
	mov	ebx, [esi+edi]
	call	_FileSeek, [@@S], dword ptr [esi+edi+4], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, [@@L0]
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_grgr PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	sub	ebx, 18h
	jb	@@9
	mov	eax, [esi]
	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	add	esi, 18h
	mov	ecx, edi
	imul	ecx, edx
	cmp	eax, 'PMCN'
	je	@@1
	cmp	eax, 'BCR'
	je	@@2
@@9:	stc
	leave
	ret

@@1:	lea	eax, [ecx*2+ecx]
	sub	ebx, eax
	jb	@@9
	xchg	ebx, eax
	call	_ArcTgaAlloc, 22h, edi, edx
	lea	edi, [eax+12h]
	mov	ecx, ebx
	rep	movsb
	clc
	leave
	ret

@@2:	push	ecx
	call	_ArcTgaAlloc, 22h, edi, edx
	lea	edi, [eax+12h]
	pop	ecx
	call	@@Unpack, edi, ecx, esi, ebx
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
	sub	[@@SC], 4
	jb	@@9
	movzx	ecx, byte ptr [esi+3]
	add	esi, 4
	test	ecx, ecx
	je	@@1
	sub	[@@DC], ecx
	jb	@@9
	sub	esi, 4
	movsb
	movsb
	movsb
	inc	esi
	dec	ecx
	je	@@1
	lea	ecx, [ecx*2+ecx]
	lea	eax, [edi-3]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
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
