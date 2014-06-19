
; "Hime Musha" *.arc
; HimeMusya.exe

	dw _conv_mai-$-2
_arc_mai PROC

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
	pop	ecx
	pop	ebx
	pop	edx	; 100h, 200h
	cmp	eax, 0A49414Dh
	jne	@@9a
	movzx	edx, dx
	xchg	dl, dh
	dec	edx
	shr	edx, 1
	lea	ecx, [ebx-1]
	mov	[@@N], ebx
	shr	ecx, 14h
	or	ecx, edx
	jne	@@9a
	lea	ebx, [ebx*2+ebx]
	shl	ebx, 3
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 10h
	and	[@@D], 0
	mov	ebx, [esi+14h]
	call	_FileSeek, [@@S], dword ptr [esi+10h], 0
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

_conv_mai PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 20h
	jb	@@9
	movzx	eax, word ptr [esi]
	cmp	[esi+2], ebx
	jne	@@1a
	cmp	eax, 'MC'	; cmp
	je	@@1
	cmp	eax, 'MA'	; ami
	je	@@2
@@1a:	mov	ecx, ' tmf'
	mov	edx, 'EVAW'
	mov	eax, [esi]
	sub	edx, [esi+8]
	sub	ecx, [esi+0Ch]
	sub	eax, 'FFIR'
	or	edx, ecx
	or	eax, edx
	jne	@@9
	call	_ArcSetExt, 'vaw'
@@9:	stc
	leave
	ret

@@1:	cmp	byte ptr [esi+0Ch], 18h
	jne	@@9
	sub	ebx, 20h
	mov	eax, [esi+10h]
	sub	ebx, [esi+14h]
	sub	eax, 20h
	or	eax, ebx
	jne	@@9
	movzx	edi, word ptr [esi+6]
	movzx	edx, word ptr [esi+8]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 2, edi, edx
	lea	edi, [eax+12h]
	lea	edx, [esi+20h]
	call	@@CM, edi, ebx, edx, dword ptr [esi+14h], 0
	clc
	leave
	ret

@@2:	sub	ebx, 30h
	jb	@@9
	cmp	byte ptr [esi+14h], 18h
	jne	@@9
	mov	eax, [esi+6]
	mov	ecx, [esi+1Ah]
	sub	eax, [esi+0Ah]
	sub	ecx, 30h
	or	eax, ecx
	jne	@@9
	mov	ecx, [esi+1Eh]
	sub	ebx, ecx
	jb	@@9
	add	ecx, 30h
	sub	ebx, [esi+26h]
	sub	ecx, [esi+22h]
	or	ebx, ecx
	jne	@@9
	movzx	edi, word ptr [esi+6]
	movzx	edx, word ptr [esi+8]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 3, edi, edx
	lea	edi, [eax+12h]
	lea	edx, [esi+30h]
	call	@@CM, edi, ebx, edx, dword ptr [esi+1Eh], 1
	mov	edx, [esi+22h]
	add	edx, esi
	call	@@AM, edi, ebx, edx, dword ptr [esi+26h], dword ptr [edi-12h+0Ch]
	clc
	leave
	ret

@@CM PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@A = dword ptr [ebp+24h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
@@1:	cmp	[@@DC], 0
	je	@@7
	dec	[@@SC]
	js	@@9
	lodsb
	mov	ecx, eax
	and	ecx, 7Fh
	mov	edx, [@@A]
	sub	[@@DC], ecx
	jb	@@9
	test	al, al
	js	@@1b
	lea	eax, [ecx*2+ecx]
	test	ecx, ecx
	je	@@1
	sub	[@@SC], eax
	jb	@@9
@@1a:	movsb
	movsb
	movsb
	add	edi, edx
	dec	ecx
	jne	@@1a
	jmp	@@1

@@1b:	sub	[@@SC], 3
	jb	@@9
	add	esi, 3
	dec	ecx
	js	@@1
	sub	esi, 3
	mov	eax, edi
	movsb
	movsb
	movsb
	add	edi, edx
	add	edx, 3
	imul	ecx, edx
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
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
	ret	14h
ENDP

@@AM PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]

@@L1 = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]

	movzx	eax, word ptr [@@L0]
	movzx	ecx, word ptr [@@L0+2]
	mov	ebx, eax
	shl	eax, 2
	dec	ecx
	imul	ecx, eax
	shl	eax, 1
	add	edi, ecx
	push	eax

@@1:	cmp	[@@DC], 0
	je	@@7
	dec	[@@SC]
	js	@@9
	lodsb
	mov	ecx, eax
	and	ecx, 7Fh
	sub	[@@DC], ecx
	jb	@@9
	test	al, al
	js	@@1b
	test	ecx, ecx
	je	@@1
	sub	[@@SC], ecx
	jb	@@9
@@1a:	lodsb
	call	@@2
	dec	ecx
	jne	@@1a
	jmp	@@1

@@1b:	dec	[@@SC]
	js	@@9
	lodsb
	test	ecx, ecx
	je	@@1
@@1c:	call	@@2
	dec	ecx
	jne	@@1c
	jmp	@@1

@@7:	xor	esi, esi
@@9:	mov	edx, [@@SC]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h

@@2:	add	edi, 3
	stosb
	dec	ebx
	jne	@@2a
	sub	edi, [@@L1]
	movzx	ebx, word ptr [@@L0]
@@2a:	ret

ENDP

ENDP

