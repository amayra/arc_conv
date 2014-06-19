
; "Kimiaru" *.nsa
; kimiaru.exe
; 00444960 unpack
; 00444D00 bitmap_unpack

; "[Materia] Eclipse" nscript.dat
; xor 0x84

	dw _conv_nsa-$-2
_arc_nsa PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@SC
@M0 @@L0

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 6
	jc	@@9a
	movzx	eax, word ptr [esi]
	mov	ebx, [esi+2]
	xchg	al, ah
	bswap	ebx
	test	eax, eax
	je	@@9a
	mov	[@@N], eax
	mov	[@@P], ebx
	sub	ebx, 6
	jb	@@9a
	mov	[@@SC], ebx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	mov	edi, esi
	xor	eax, eax
	mov	ecx, [@@SC]
	sub	ecx, 0Dh
	jbe	@@9
	repne	scasb
	jne	@@9
	mov	[@@SC], ecx
	call	_ArcName, esi, -1
	and	[@@D], 0
	lea	esi, [edi+0Dh]
	mov	eax, [esi-0Ch]
	mov	ebx, [esi-8]
	bswap	eax
	bswap	ebx
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	mov	edi, [esi-4]
	bswap	edi
	xor	ecx, ecx
	cmp	byte ptr [esi-0Dh], 2
	jne	$+4
	mov	ecx, edi
	call	_ArcMemRead, eax, ecx, ebx, 0
	xchg	ebx, eax
	cmp	byte ptr [esi-0Dh], 2
	jne	@@1a
	call	@@Unpack, [@@D], edi, edx, ebx
	xchg	ebx, eax
@@1a:	call	@@4, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@4:	cmp	byte ptr [esi-0Dh], 1
	je	_ArcConv
	jmp	_ArcData

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
@@1:	xor	eax, eax
	cmp	[@@DC], eax
	je	@@7
	call	@@3
	sbb	edx, edx
	inc	eax
@@1a:	call	@@3
	adc	al, al
	jnc	@@1a
	inc	edx
	jne	@@1b
	dec	[@@DC]
	js	@@9
	stosb
	jmp	@@1

@@1b:	lea	edx, [eax+11h]
	mov	al, 10h
@@1c:	call	@@3
	adc	al, al
	jnc	@@1c
	lea	ecx, [eax+2]
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
	sub	edx, eax
	or	edx, -100h
	add	eax, edx
	jns	@@2b
@@2a:	mov	byte ptr [edi], 20h
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
ENDP

ENDP

_conv_nsa PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'pmb'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 4
	jb	@@9
	mov	edi, [esi]
	bswap	edi
	movzx	edx, di
	shr	edi, 10h
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 22h, edi, edx
	lea	edi, [eax+12h]
	call	@@Unpack, edi, ebx, esi, [@@SC]
	clc
	leave
	ret

@@Unpack PROC	; 00444D00

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@W = dword ptr [ebp-4]
@@C = dword ptr [ebp-8]
@@I = dword ptr [ebp-0Ch]
@@A = dword ptr [ebp-10h]
@@X = dword ptr [ebp-14h]
@@L0 = dword ptr [ebp-18h]
@@L1 = dword ptr [ebp-1Ch]
@@L2 = dword ptr [ebp-20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@SB]
	sub	[@@SC], 4
	lodsd
	bswap	eax
	shr	eax, 10h
	push	eax
	xor	ebx, ebx
	xor	edx, edx
@@2:	mov	eax, [@@DC]
	mov	edi, [@@DB]
	mov	ecx, [@@W]
	dec	eax
	dec	ecx
	add	edi, edx
	push	eax	; @@C
	push	edx	; @@I
	push	2	; @@A
	push	ecx	; @@X
	push	8
	pop	ecx
	call	@@5
	stosb
	inc	edi
	inc	edi
	push	eax	; @@L0
@@1:	push	4
	pop	edx
	push	3
	pop	ecx
	call	@@5
	test	eax, eax
	je	@@1a
	add	eax, 2
	cmp	eax, 9
	jne	@@1a
	xor	eax, eax
	call	@@3
	adc	eax, 1
@@1a:	push	eax	; @@L1
	push	edx	; @@L2
	xchg	ecx, eax
	mov	eax, [@@L0]
	test	ecx, ecx
	je	@@1b
	xchg	edx, eax
	call	@@5
	cmp	[@@L1], 8
	je	@@1b
	shr	eax, 1
	sbb	ecx, ecx
	xor	eax, ecx
	sub	edx, eax
	xchg	eax, edx
@@1b:	mov	[@@L0], eax
	cmp	[@@C], 0
	je	@@1c
	mov	edx, [@@A]
	dec	[@@C]
	stosb
	add	edi, edx
	dec	[@@X]
	jne	@@1c
	mov	eax, [@@W]
	mov	[@@X], eax
	lea	eax, [eax*2+eax]
	xor	edx, -2		; 2, -4
	add	edi, eax
	lea	edi, [edi+edx+1]
	mov	[@@A], edx
@@1c:	pop	edx
	pop	eax
	dec	edx
	jne	@@1a
	cmp	[@@C], 0
	jne	@@1
	pop	eax
	pop	edx
	pop	eax
	pop	edx
	pop	eax
	inc	edx
	cmp	edx, 3
	jb	@@2
	xor	esi, esi
@@9:	xor	eax, eax
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

@@5:	xor	eax, eax
@@5a:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@5a
	ret
ENDP

ENDP
