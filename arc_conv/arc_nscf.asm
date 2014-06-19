
; "XXXXX -Five X-" *.nsc
; NekoW95.exe
; 004047C0 gcmp24
; 004045C0 gcmp8

; "NekotaroGameSystem"
; aig - "GCmpSH0"
; lzs lzt scc - packed

	dw _conv_nscf-$-2
_arc_nscf PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	lodsd
	cmp	eax, 'FCSN'
	jne	@@9a
	lea	ecx, [ebx-1]
	shr	ecx, 14h
	jne	@@9a
	mov	eax, [esi]
	lea	ebx, [eax-8]
	ror	eax, 2
	dec	eax
	dec	eax
	lea	ecx, [eax-1]
	shr	ecx, 14h
	jne	@@9a
	mov	[@@N], eax
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 4, ebx, 0
	jc	@@9
	mov	edi, [@@M]
	movsd
	lea	esi, [edi-4]
	call	_ArcCount, [@@N]

	call	_FileGetSize, [@@S]
	jc	@@9
	cmp	[esi+ebx], eax
	jne	@@9

@@1:	lodsd
	mov	edi, [esi]
	sub	edi, eax
	jb	@@9
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, edi, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
	cmp	ebx, edi
	jne	@@9
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_nscf PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 0Ch
	jb	@@9
	mov	edx, 'EVAW'
	mov	eax, [esi]
	sub	edx, [esi+8]
	sub	eax, 'FFIR'
	or	eax, edx
	jne	@@1
	call	_ArcSetExt, 'vaw'
@@9:	stc
	leave
	ret

@@1:	cmp	ebx, 10h
	jb	@@9
	mov	edx, '0HS'
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, 'pmCG'
	or	eax, edx
	jne	@@9
	cmp	dword ptr [esi+0Ch], 18h
	jne	@@9
	movzx	edi, word ptr [esi+8]
	movzx	edx, word ptr [esi+0Ah]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 2, edi, edx
	lea	edi, [eax+12h]
	mov	ecx, [@@SC]
	lea	edx, [esi+10h]
	sub	ecx, 10h
	call	@@GCmp24, edi, ebx, edx, ecx
	clc
	leave
	ret

@@GCmp24 PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	enter	180h, 0
	mov	edi, esp
	xor	eax, eax
	lea	ecx, [eax+60h]
	rep	stosd

	mov	esi, [@@SB]
	mov	edi, [@@DB]
@@1:	xor	eax, eax
	cmp	[@@DC], eax
	je	@@7
	dec	[@@SC]
	js	@@9
	lodsb
	test	al, al
	jns	@@1c
	mov	ebx, eax
	shr	eax, 5
	and	ebx, 1Fh
	and	al, 3
	jne	@@1a
	dec	[@@SC]
	js	@@9
	lodsb
	add	al, 80h
	adc	ebx, ebx
	and	al, 7Fh
	xchg	ebx, eax
@@1a:	test	eax, eax
	jne	@@1b
	sub	[@@SC], 4
	jb	@@9
	lodsd
@@1b:	lea	edx, [ebx*2+ebx+3]
	neg	edx
	add	edx, ebp
	jmp	@@1f

@@1c:	cmp	eax, 1
	jne	@@1d
	dec	[@@SC]
	js	@@9
	lodsb
	test	eax, eax
	je	@@9
	lea	ecx, [eax*2+eax]
	sub	[@@DC], eax
	jb	@@9
	sub	[@@SC], ecx
	jb	@@9
	mov	ebx, ecx
	rep	movsb
	lea	ecx, [eax-80h]
	neg	ecx
	jns	@@2b
	xor	ecx, ecx
	mov	ebx, 180h
	jmp	@@2b

@@1d:	test	eax, eax
	jne	@@1e
	sub	[@@SC], 4
	jb	@@9
	lodsd
@@1e:	sub	[@@SC], 3
	jb	@@9
	mov	edx, esi
	add	esi, 3
	push	7Fh
	pop	ebx
@@1f:	test	eax, eax
	je	@@9
	sub	[@@DC], eax
	jb	@@9
	push	esi
	mov	esi, edx
	movsb
	movsb
	movsb
	dec	eax
	je	@@2a
	lea	esi, [edi-3]
	lea	ecx, [eax*2+eax]
	rep	movsb
@@2a:	pop	esi
	test	ebx, ebx
	je	@@1
	mov	ecx, ebx
	push	3
	pop	ebx
@@2b:	lea	ecx, [ecx*2+ecx]
	push	esi
	mov	esi, ebp
	sub	esi, ecx
	mov	eax, esi
	sub	eax, ebx
	xchg	edi, eax
	rep	movsb
	mov	esi, eax
	mov	ecx, ebx
	sub	esi, ebx
	rep	movsb
	xchg	edi, eax
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
