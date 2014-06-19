
_mod_ai5 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 0Ch

	enter	@@stk-0Ch, 0
	push	edx
	push	ecx
	push	eax	; @@L0
	movzx	edi, ax
	add	edi, 0Ch
	sub	esp, edi
	mov	esi, esp
	call	_FileRead, [@@S], esi, edi
	jc	@@9a
	lodsd
	mov	ebx, eax
	dec	eax
	shr	eax, 14h
	jne	@@9a
	sub	edi, 4
	mov	[@@N], ebx
	imul	ebx, edi
	lea	eax, [ebx+4]
	xor	eax, [@@L0+8]
	cmp	eax, [esi+edi-4]
	jne	@@9a
	sub	ebx, edi
	lea	eax, [@@M]
	call	_ArcMemRead, eax, edi, ebx, 0
	jc	@@9
	mov	ecx, edi
	add	ebx, edi
	shr	ecx, 2
	mov	edi, [@@M]
	rep	movsd
	mov	esp, esi
	mov	esi, [@@M]

	mov	edx, [@@N]
	push	esi
@@2a:	mov	al, byte ptr [@@L0+2]
	movzx	ecx, word ptr [@@L0]
@@2b:	xor	byte ptr [esi], al
	inc	esi
	dec	ecx
	jne	@@2b
	mov	eax, [@@L0+4]
	mov	ecx, [@@L0+8]
	xor	[esi], eax
	xor	[esi+4], ecx
	add	esi, 8
	dec	edx
	jne	@@2a
	pop	esi

	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	movzx	edi, word ptr [@@L0]
	call	_ArcName, esi, edi
	lea	esi, [esi+edi+8]
	and	[@@D], 0
	mov	ebx, [esi-8]
	call	_FileSeek, [@@S], dword ptr [esi-4], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
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

; "Ai Shimai - Docchi ni Suru no!!" *.arc
; AI5WIN.exe
; 004119C0 arc_decode

	dw _conv_ai5-$-2
_arc_ai5 PROC
	mov	eax, 000980020h
	mov	ecx, 0757491F4h
	mov	edx, 045321E7Fh
	jmp	_mod_ai5
ENDP

	dw _conv_ai5-$-2
_arc_ai5_kakyu2 PROC
	mov	eax, 000030018h
	mov	ecx, 059713545h
	mov	edx, 037851832h
	jmp	_mod_ai5
ENDP

_conv_ai5 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'bil'
	je	@@4
	cmp	eax, 'sem'
	je	@@4
	cmp	eax, 'ccg'
	jne	@@9
	sub	ebx, 14h
	jb	@@9
	mov	eax, [esi]
	mov	ecx, [esi+0Ch]
	xor	edx, edx
	sub	eax, 'm42G'
	test	al, al		; 'G'
	je	@@2a
	mov	edx, [esi+10h]
	sub	al, 0Bh		; 'R'
@@2a:	rol	eax, 8
	shr	eax, 1
	je	@@1
@@9:	stc
	leave
	ret

@@4:	call	_lzss_unpack, 0, -1, esi, ebx
	test	eax, eax
	xchg	edi, eax
	je	@@9
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	call	_lzss_unpack, edi, eax, esi, ebx
	xchg	ebx, eax
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

@@1:	jc	@@1a		; 'n'
	sub	ebx, 0Ch	; 'm'
	jb	@@9
	cmp	ecx, edx
	jb	@@9
	cmp	ebx, ecx
	jb	@@9
	jmp	@@1b
@@1a:	test	ecx, ecx
	jne	@@9
@@1b:	sub	ebx, edx
	jb	@@9
@@1c:	mov	[@@SC], ebx
	movzx	edi, word ptr [esi+8]
	movzx	edx, word ptr [esi+0Ah]
	mov	ebx, edi
	imul	ebx, edx
	lea	ebx, [ebx*2+ebx]
	mov	cl, [esi+3]
	and	ecx, 1
	inc	ecx
	inc	ecx
	call	_ArcTgaAlloc, ecx, edi, edx
	xchg	edi, eax
	mov	eax, [esi+4]
	mov	[edi+8], eax
	add	edi, 12h
	cmp	byte ptr [esi], 47h
	je	@@2b
	call	_MemAlloc, 30002h
	jc	@@9
	push	eax
	call	@@Unpack, edi, ebx, esi, [@@SC], eax
	call	_MemFree
	clc
	leave
	ret

@@2b:	cmp	byte ptr [esi+3], 6Eh
	sbb	ecx, ecx
	and	ecx, 0Ch
	mov	edx, [@@SC]
	je	@@2c
	mov	edx, [esi+0Ch]
@@2c:	lea	ecx, [esi+14h+ecx]
	call	_lzss_unpack, edi, ebx, ecx, edx
	cmp	byte ptr [esi+3], 6Eh
	je	@@2d
	movzx	ecx, word ptr [esi+0Ah]
	movzx	eax, word ptr [esi+8]
	imul	ecx, eax
	mov	edx, ebx
@@2e:	mov	eax, [edi+edx-4]
	sub	edx, 3
	mov	al, 0FFh
	ror	eax, 8
	mov	[edi+ecx*4-4], eax
	dec	ecx
	jne	@@2e
	call	@@Unpack, edi, ebx, esi, [@@SC], 0
@@2d:	clc
	leave
	ret

@@Unpack PROC	; 00432A50

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]

@@L1 = dword ptr [ebp-4]
@@L2 = dword ptr [ebp-8]
@@L3 = dword ptr [ebp-0Ch]
@@L4 = dword ptr [ebp-10h]
@@C = dword ptr [ebp-14h]
@@A = dword ptr [ebp-18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	cmp	byte ptr [esi+3], 6Eh
	sbb	ecx, ecx
	add	esi, 0Ch
	xor	ebx, ebx
	lodsd
	xchg	edx, eax
	lodsd
	sub	edx, eax
	and	ecx, 0Ch
	jne	@@2f
	mov	edx, [@@SC]
@@2f:	add	esi, ecx
	push	eax	; @@L1
	add	eax, esi
	neg	ecx
	sbb	ecx, ecx
	push	eax	; @@L2
	push	edi	; @@L3
	push	edx	; @@L4
	push	ebx	; @@C
	push	ecx	; @@A
	mov	edx, [@@SC]
	cmp	[@@L0], 0
	je	@@7f
@@2:	mov	ecx, [@@DC]
	mov	eax, 0FFFFh
	cmp	ecx, eax
	jb	$+3
	xchg	ecx, eax
	sub	[@@DC], ecx
	call	@@3
	jnc	@@2a
	lea	eax, [ecx+2]
	mov	[@@C], eax
	push	ecx
	mov	edi, [@@L0]
	call	@@11
	pop	ecx
	mov	eax, [@@L0]
	mov	edi, [@@L3]
	movzx	edx, word ptr [eax]
	inc	eax
	inc	eax
	cmp	edx, ecx
	jae	@@9
	call	@@BWT, edi, eax, ecx, edx, [@@A]
	mov	[@@L3], eax
	jmp	@@2e

@@2a:	mov	[@@C], ecx
	mov	edi, [@@L3]
@@2b:	xor	eax, eax
	inc	eax
	call	@@3
	jnc	@@2c
	call	@@4
@@2c:	lea	ecx, [eax*2+eax]
	xchg	edx, eax
	sub	[@@C], ecx
	jb	@@9
	call	@@6
	stosb
	call	@@6
	stosb
	call	@@6
	stosb
	and	edx, [@@A]
	je	@@2g
	dec	edx
	mov	al, 0FFh
	stosb
@@2g:	sub	ecx, 3
	je	@@2d
	add	ecx, edx
	push	esi
	lea	esi, [edi-3]
	add	esi, [@@A]
	rep	movsb
	pop	esi
@@2d:	mov	[@@L3], edi
	cmp	[@@C], ecx
	jne	@@2b
@@2e:	cmp	[@@DC], 0
	jne	@@2

	mov	edx, [@@SC]
	mov	esi, [@@SB]
	add	edx, [esi+10h]
@@7f:	mov	esi, [@@SB]
	cmp	byte ptr [esi+3], 6Eh
	je	@@7
	movzx	edi, word ptr [esi+1Ah]
	movzx	ebx, word ptr [esi+18h]
	push	edi
	push	ebx
	imul	ebx, edi
	movzx	ecx, word ptr [esi+0Ah]
	movzx	eax, word ptr [esi+8]
	push	ecx
	push	eax
	imul	eax, ecx
	sub	edi, ecx
	cmp	ebx, eax
	jb	@@9
	mov	[@@C], eax
	movzx	ecx, word ptr [esi+6]
	movzx	eax, word ptr [esi+4]
	sub	edi, ecx
	push	edi
	push	eax
	push	0
	push	0

	mov	eax, [esi+0Ch]
	mov	ecx, [esi+1Ch]
	lea	esi, [esi+20h+eax]
	sub	edx, eax
	sub	edx, ecx
	jb	@@9
	lea	eax, [esi+ecx]
	mov	[@@L4], edx
	mov	[@@L2], eax
	mov	[@@L1], ecx
	mov	edi, [@@DB]
	xor	ebx, ebx
@@7a:	xor	eax, eax
	inc	eax
	call	@@3
	jnc	@@7b
	call	@@4
@@7b:	;sub	[@@C], eax
	;jb	@@9
	xchg	ecx, eax
	call	@@6
@@7c:	mov	edx, [@@A-20h]
	sub	edx, [@@A-18h]
	cmp	edx, [@@A-10h]
	jae	@@7d
	mov	edx, [@@A-20h+4]
	sub	edx, [@@A-18h+4]
	cmp	edx, [@@A-10h+4]
	jae	@@7d
	add	edi, 3
	stosb
	dec	[@@C]
	je	@@7
@@7d:	mov	edx, [@@A-20h]
	inc	edx
	cmp	edx, [@@A-8]
	jb	@@7e
	mov	edx, [@@A-20h+4]
	inc	edx
	cmp	edx, [@@A-8+4]
	jae	@@7
	mov	[@@A-20h+4], edx
	xor	edx, edx
@@7e:	mov	[@@A-20h], edx
	dec	ecx
	jne	@@7c
;	cmp	[@@C], ecx
;	jne	@@7a
	jmp	@@7a

@@7:	xor	esi, esi
@@9:	mov	eax, [@@L3]
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h

@@6:	dec	[@@L4]
	js	@@9
	mov	eax, [@@L2]
	inc	[@@L2]
	mov	al, [eax]
	ret

@@3:	shr	bl, 1
	jne	@@3a
	dec	[@@L1]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@3a:	ret

	; 00432500
@@11:	sub	esp, 20h
	xor	eax, eax
@@11a:	mov	[esp+eax], al
	mov	[esp+eax+10h], al
	inc	eax
	cmp	al, 10h
	jb	@@11a
	mov	bh, -1
@@11b:	mov	edx, esp
	call	@@3
	jnc	@@11e
	call	@@4
	add	edx, 10h
	sub	[@@C], eax
	jb	@@9
	push	eax
	call	@@3
	jnc	@@11c
	mov	bh, [edx]
	jmp	@@11d

@@11c:	call	@@10
@@11d:	pop	ecx
	mov	al, bh
	rep	stosb
	mov	edx, esp
	call	@@5
	jmp	@@11f

@@11e:	dec	[@@C]
	call	@@10
	mov	[edi], bh
	inc	edi
@@11f:	cmp	[@@C], 0
	jne	@@11b
	add	esp, 20h
	ret

@@10:	call	@@3
	jnc	@@10a
	call	@@4
	cmp	eax, 10h
	jae	@@9
	mov	bh, [edx+eax]
	jmp	@@5b

@@10a:	call	@@3
	jnc	@@10c
	call	@@4
	cmp	eax, 100h
	jae	@@9
	call	@@3
	jnc	@@10b
	neg	al
@@10b:	add	bh, al
	jmp	@@5

@@10c:	call	@@6
	mov	bh, al
@@5:	xor	eax, eax
@@5a:	cmp	[edx+eax], bh
	je	@@5b
	inc	eax
	cmp	eax, 0Fh
	jb	@@5a
@@5b:	test	eax, eax
	je	@@5d
@@5c:	dec	eax
	mov	cl, [edx+eax]
	mov	[edx+eax+1], cl
	jne	@@5c
	mov	[edx], bh
@@5d:	ret

	; 00432380
@@4:	xor	ecx, ecx
	xor	eax, eax
@@4a:	cmp	ecx, 20h
	jae	@@9
	inc	ecx
	call	@@3
	jnc	@@4a
	inc	eax
	dec	ecx
	je	@@4c
@@4b:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@4b
@@4c:	ret

@@BWT PROC	; 00432250

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@C = dword ptr [ebp+1Ch]
@@X = dword ptr [ebp+20h]
@@A = dword ptr [ebp+24h]

	push	ebx
	push	esi
	push	edi
	enter	200h, 0
	mov	edi, esp
	mov	ecx, 80h
	xor	eax, eax
	rep	stosd
	mov	esi, [@@S]
	mov	ecx, [@@C]
@@1:	lodsb
	inc	word ptr [esp+eax*2]
	dec	ecx
	jne	@@1
	xor	eax, eax
@@2:	movzx	edx, word ptr [esp+ecx*2]
	mov	[esp+ecx*2], ax
	add	eax, edx
	inc	cl
	jne	@@2
	mov	esi, [@@S]
	mov	ecx, [@@C]
	xor	eax, eax
	lea	ebx, [esi+10000h]
	xor	edi, edi
@@3:	lodsb
	movzx	edx, word ptr [esp+eax*2]
	inc	word ptr [esp+eax*2]
	mov	[ebx+edx*2], di
	inc	edi
	dec	ecx
	jne	@@3
	mov	esi, [@@S]
	mov	ecx, [@@C]
	xor	eax, eax
	mov	edi, [@@D]
	mov	edx, [@@X]
@@4:	movzx	edx, word ptr [ebx+edx*2]
	mov	al, [esi+edx]
	stosb
	movzx	edx, word ptr [ebx+edx*2]
	mov	al, [esi+edx]
	stosb
	movzx	edx, word ptr [ebx+edx*2]
	mov	al, [esi+edx]
	stosb
	mov	eax, [@@A]
	test	eax, eax
	je	@@4a
	stosb
@@4a:	sub	ecx, 3
	jne	@@4
	xchg	eax, edi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

ENDP

ENDP
