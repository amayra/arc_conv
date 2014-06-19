
; "Nanatsuiro Drops", "Pandora no Yume" *.dat
; nana.exe 00419FD0 0041A0D0

	dw _conv_gamedat-$-2
_arc_gamedat PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@L0

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ecx
	pop	ebx
	sub	eax, 'EMAG'
	sub	edx, ' TAD'
	sub	ecx, 'CAP'
	or	eax, edx
	lea	edx, [ebx-1]
	bswap	ecx
	shr	edx, 14h
	or	eax, edx
	jne	@@9a
	push	10h
	pop	edi
	cmp	ecx, 'K'
	je	@@2a
	cmp	ecx, '2'
	jne	@@9a
	shl	edi, 1
@@2a:	mov	[@@L0], edi
	mov	[@@N], ebx
	lea	ecx, [edi+8]
	imul	edi, ebx
	imul	ebx, ecx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	add	ebx, 10h
	add	edi, esi
	mov	[@@P], ebx
	cmp	byte ptr [esi], 0
	je	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, [@@L0]
	and	[@@D], 0
	mov	eax, [edi]
	mov	ebx, [edi+4]
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, [@@L0]
	add	edi, 8
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_gamedat PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'ape'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 10h
	jb	@@9
	mov	eax, [esi]
	sub	eax, 1015045h
	bswap	eax
	shr	eax, 1
	jne	@@9
	jnc	@@1a
	sub	ebx, 28h
	jb	@@9
@@1a:	movzx	ecx, byte ptr [esi+4]	; 0-8, 1-24, 2-32, 4-1
	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	cmp	ecx, 3
	jae	@@9
	test	ecx, ecx
	jne	@@1b
	mov	cl, 30h-21h
	sub	ebx, 300h
	jb	@@9
@@1b:	add	ecx, 21h
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	call	@@EPA, edi, esi, ebx
	clc
	leave
	ret

@@EPA PROC

@@DB = dword ptr [ebp+14h]
@@SB = dword ptr [ebp+18h]
@@SC = dword ptr [ebp+1Ch]

@@DC = dword ptr [ebp-4]
@@A = dword ptr [ebp-8]
@@T = dword ptr [ebp-44h]
@@C = dword ptr [ebp-48h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@SB]
	mov	edx, [esi+8]
	mov	eax, [esi+0Ch]
	movzx	ebx, byte ptr [esi+4]
	imul	eax, edx
	push	eax

	mov	edi, [@@DB]
	cmp	byte ptr [esi+3], 2
	lea	esi, [esi+10h]
	jne	@@2a
	push	28h
	pop	ecx
	mov	[edi-12h], cl
	rep	movsb
@@2a:
	test	ebx, ebx
	jne	@@2b
	dec	ebx
	mov	ecx, 300h
	rep	movsb
@@2b:	inc	ebx
	push	ebx
	mov	[@@DB], edi
	inc	ebx
	sub	esp, 3Ch
	call	_epa_dist, edx, ebx, esp

	xor	ebx, ebx
@@2:	mov	edi, [@@DB]
	push	[@@DC]
	add	edi, ebx
@@1:	xor	eax, eax
	cmp	[@@C], eax
	je	@@7
	dec	[@@SC]
	js	@@9
	lodsb
	mov	ecx, eax
	test	al, 0F0h
	jne	@@1b
	test	ecx, ecx
	je	@@1
	sub	[@@SC], ecx
	jb	@@9
	sub	[@@C], ecx
	jb	@@9
@@1a:	movsb
	add	edi, [@@A]
	dec	ecx
	jne	@@1a
	jmp	@@1

@@1b:	and	al, 7
	shr	ecx, 4
	jnc	@@1c
	mov	ah, al
	dec	[@@SC]
	js	@@9
	lodsb
@@1c:	xchg	ecx, eax
	sub	[@@C], ecx
	jb	@@9
	mov	eax, [@@T+eax*4-4]
	mov	edx, edi
	sub	edx, [@@DB]
	add	edx, eax
	jnc	@@9
	add	eax, edi
	xchg	esi, eax
@@1d:	movsb
	add	edi, [@@A]
	add	esi, [@@A]
	dec	ecx
	jne	@@1d
	xchg	esi, eax
	jmp	@@1

@@7:	inc	ebx
	pop	ecx
	cmp	ebx, [@@A]
	jbe	@@2
	xor	esi, esi
@@9:	xor	eax, eax
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

ENDP
