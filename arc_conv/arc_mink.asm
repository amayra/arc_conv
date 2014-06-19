
; "HEAVEN -Death Game-" *.det
; heaven.exe

	dw _conv_mink-$-2
_arc_mink PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 8

	enter	@@stk, 0
	and	[@@M], 0
	call	_unicode_ext, -1, offset inFileName
	cmp	eax, 'ted'
	jne	@@9a
	call	@@3
	mov	esi, [@@M]
	test	esi, esi
	je	@@9a
	add	[@@L0], esi
	call	_ArcCount, [@@N]

@@1:	mov	ecx, [@@L0+4]
	mov	edi, [esi]
	xor	eax, eax
	sub	ecx, edi
	jbe	@@1b
	add	edi, [@@L0]
	mov	edx, edi
	repne	scasb
	jne	@@1b
	call	_ArcName, edx, -1
@@1b:	and	[@@D], 0
	mov	ebx, [esi+8]
	mov	edi, [esi+10h]
	call	_FileSeek, [@@S], dword ptr [esi+4], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, edi, ebx, 0
	call	@@Unpack, [@@D], edi, edx, eax
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 14h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	call	_ArcInputExt, 'mta'
	jc	@@3a
	xchg	esi, eax
	call	_FileGetSize, esi
	xor	edx, edx
	lea	ecx, [edx+14h]
	mov	[@@L0], eax
	mov	ebx, eax
	div	ecx
	lea	ecx, [eax-1]
	sub	edx, 4
	shr	ecx, 14h
	or	edx, ecx
	jne	@@3b
	mov	[@@N], eax

	call	_ArcInputExt, 'emn'
	jc	@@3b
	xchg	edi, eax
	call	_FileGetSize, edi
	cmp	eax, [@@N]
	jb	@@3c
	mov	[@@L0+4], eax
	add	eax, ebx
	call	_MemAlloc, eax
	jc	@@3c
	mov	[@@M], eax
	call	_FileRead, esi, eax, ebx
	jc	@@3d
	add	ebx, [@@M]
	call	_FileRead, edi, ebx, [@@L0+4]
	jnc	@@3c
@@3d:	call	_MemFree, [@@M]
	and	[@@M], 0
@@3c:	call	_FileClose, edi
@@3b:	call	_FileClose, esi
@@3a:	ret

@@Unpack PROC	; 00416200

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
	dec	[@@SC]
	js	@@9
	lodsb
	cmp	al, -1
	jne	@@2
	dec	[@@SC]
	js	@@9
	lodsb
	cmp	al, -1
	jne	@@3
@@2:	dec	[@@DC]
	js	@@9
	stosb
	jmp	@@1

@@3:	movzx	edx, al
	xchg	ecx, eax
	shr	edx, 2
	and	ecx, 3
	not	edx
	add	ecx, 3
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	sub	[@@DC], ecx
	jb	@@9
	push	esi
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

_conv_mink PROC

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

@@1:	sub	ebx, 8
	jb	@@9
	mov	eax, [esi]
	sub	eax, 184346h
	test	eax, NOT 1082000h
	je	@@2
	sub	ebx, 8
	jb	@@9
	mov	eax, [esi]
	sub	eax, 186546h
	and	eax, NOT 80000h
	jne	@@9
	movzx	edi, word ptr [esi+4]
	movzx	edx, word ptr [esi+6]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 3, edi, edx
	lea	edi, [eax+12h]
	call	@@FE, edi, ebx, esi, [@@SC]
	clc
	leave
	ret

@@2:	mov	al, -0A0h
	add	al, [esi+8]	; starts with code 5 or 4
	cmp	al, 30h
	jae	@@9
	movzx	edi, word ptr [esi+4]
	movzx	edx, word ptr [esi+6]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 3, edi, edx
	lea	edi, [eax+12h]
	call	@@FC, edi, ebx, esi, [@@SC]
	clc
	leave
	ret

		; sai_gaku.exe 00421320
@@FE PROC	; 00422CE0 004235F0

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@W = dword ptr [ebp-4]
@@L0 = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	enter	0A4h+4, 0
	xor	eax, eax
	mov	edi, esp	; 0xA3
	stosb
	inc	eax
	stosb
	inc	eax
	stosb
	inc	eax

	; 0-2, 0x2B-0x52, (0x53,0x7B)-(0x7A,0xA2), 3-0x2A

@@2a:	lea	edx, [eax+28h]
	lea	ecx, [eax+50h]
	mov	[edi+eax-3], dl
	lea	edx, [eax+78h]
	mov	[edi+eax*2-6+28h], cl
	mov	[edi+eax*2-6+28h+1], dl
	mov	[edi+eax-3+28h*3], al
	inc	eax
	cmp	eax, 2Bh
	jb	@@2a

	mov	esi, [@@SB]
	mov	edi, [@@DB]
	xor	ebx, ebx
	movzx	eax, word ptr [esi+4]
	mov	[@@W], eax
	add	esi, 10h
@@1:	cmp	[@@DC], 0
	je	@@7
	call	@@4
	sub	eax, 4
	jae	@@1a
	movzx	ecx, byte ptr [esp]
	inc	eax
	jne	@@1b
	movzx	eax, byte ptr [esp+1]
	mov	[esp+1], cl
	mov	[esp], al
	xchg	eax, ecx
	jmp	@@1b
@@1a:	cmp	eax, 0A1h
	jae	@@9
	movzx	edx, word ptr [esp+eax]
	movzx	ecx, byte ptr [esp+eax+2]
	mov	[esp+eax], cl
	mov	[esp+eax+1], dx
@@1b:	test	ecx, ecx
	jne	@@1c
	xor	eax, eax
	lea	ecx, [eax+18h]
	call	@@5
	dec	[@@DC]
	or	eax, 0FF000000h
	stosd
	jmp	@@1

@@1c:	mov	[@@L0], ecx
	sub	ecx, 2Bh
	jae	@@2b
	call	@@4
	xchg	edx, eax
	call	@@4
	dec	edx
	dec	eax
	shr	edx, 1
	sbb	ecx, ecx
	dec	eax
	imul	edx, [@@W]
	xor	eax, ecx
	sub	eax, edx
	xchg	edx, eax
	shl	edx, 2
	mov	ecx, [@@L0]
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	sub	ecx, 3
	jae	@@1e
	xor	eax, eax
	inc	eax
	inc	ecx
	je	@@1d
	call	@@4
@@1d:	xchg	ecx, eax
	sub	[@@DC], ecx
	jb	@@9
	push	esi
	lea	esi, [edi+edx]
	rep	movsd
	pop	esi
	jmp	@@1

@@1e:	call	@@6
	call	@@3
	sbb	eax, eax
	neg	eax
	inc	eax
	sub	[@@DC], eax
	jb	@@9
	mov	[@@L0], eax
	push	ebx
	lea	ebx, [ecx+edx]
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, ebx
	jnc	@@9
@@1f:	mov	al, [edi+ecx]
	add	al, [edi+edx]
	sbb	ah, ah
	sub	al, [edi+ebx]
	adc	ah, 1
	shr	ah, 1
	stosb
	mov	al, [edi+ecx]
	add	al, [edi+edx]
	sub	al, [edi+ebx]
	stosb
	mov	al, [edi+ecx]
	add	al, [edi+edx]
	sub	al, [edi+ebx]
	sub	al, ah		; borrow fix: m = 0xFF00FF, (a & m + b & m - c & m) & m
	stosb
	mov	al, 0FFh
	stosb
	dec	[@@L0]
	jne	@@1f
	pop	ebx
	jmp	@@1

@@2b:	xor	edx, edx
	cmp	ecx, 28h
	jb	@@2c
	mov	edx, [@@W]
	neg	edx
	sub	ecx, 50h
	jae	@@2c
	add	ecx, 28h
	or	edx, -1
@@2c:	call	@@6
	mov	eax, [edi+ecx]
	shl	edx, 2
	je	@@2d
	add	ecx, edx
	push	ebx
	mov	ebx, edi
	sub	ebx, [@@DB]
	add	ebx, edx
	jnc	@@9
	sub	ebx, edx
	add	ebx, ecx
	jnc	@@9
	pop	ebx
	add	eax, [edi+edx]
	sub	eax, [edi+ecx]
@@2d:	mov	[@@L0], eax
	call	@@4
	shr	eax, 1
	sbb	edx, edx
	dec	eax
	xor	edx, eax
	shl	edx, 10h
	add	[@@L0], edx
	call	@@4
	shr	eax, 1
	sbb	edx, edx
	dec	eax
	xor	edx, eax
	shl	edx, 8
	add	[@@L0], edx
	call	@@4
	shr	eax, 1
	sbb	edx, edx
	dec	eax
	xor	edx, eax
	mov	eax, [@@L0]
	add	eax, edx
	dec	[@@DC]
	or	eax, 0FF000000h
	stosd
	jmp	@@1

@@7:	mov	edx, [@@SB]
	cmp	word ptr [edx+2], 20h
	jne	@@7c
	mov	eax, edi
	mov	edi, [@@DB]
	sub	eax, edi
	shr	eax, 2
	mov	[@@DC], eax
@@7a:	xor	eax, eax
	lea	ecx, [eax+8]
	call	@@5
	xchg	edx, eax
	call	@@4	; 00422130
	dec	eax
	sub	[@@DC], eax
	jb	@@9
@@7b:	mov	[edi+3], dl
	add	edi, 4
	dec	eax
	jne	@@7b
	cmp	[@@DC], eax
	jne	@@7a
@@7c:	xor	esi, esi
@@9:	xor	eax, eax
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@6:	movsx	ecx, byte ptr [@@T+ecx]
	mov	eax, ecx
	sar	ecx, 4
	and	eax, 0Fh
	imul	eax, [@@W]
	sub	ecx, eax
	mov	eax, edi
	shl	ecx, 2
	sub	eax, [@@DB]
	add	eax, ecx
	jnc	@@9
	ret

@@3:	shl	bl, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@3a:	ret

@@4:	xor	ecx, ecx
@@4a:	inc	ecx
	call	@@3
	jc	@@4a
	xor	eax, eax
	inc	eax
@@5:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@5
	ret

@@T:	; 00463E98 00463DF8
db 0F0h,001h,011h,0F1h,0E0h,0E1h,0E2h,0F2h
db 002h,012h,022h,021h,0D0h,0D1h,0D2h,0D3h
db 0E3h,0F3h,003h,013h,023h,033h,032h,031h
db 0C0h,0C1h,0C2h,0C3h,0C4h,0D4h,0E4h,0F4h
db 004h,014h,024h,034h,044h,043h,042h,041h

if 0
; 00463E98
db  0,-1,-1,-1, 0,-1,-2,-2
db -2,-2,-2,-1, 0,-1,-2,-3
db -3,-3,-3,-3,-3,-3,-2,-1
db  0,-1,-2,-3,-4,-4,-4,-4
db -4,-4,-4,-4,-4,-3,-2,-1
; 00463DF8
db -1, 0, 1,-1,-2,-2,-2,-1
db  0, 1, 2, 2,-3,-3,-3,-3
db -2,-1, 0, 1, 2, 3, 3, 3
db -4,-4,-4,-4,-4,-3,-2,-1
db  0, 1, 2, 3, 4, 4, 4, 4
endif
ENDP

; "Love Call" pic\*.bmp
; lovecall.exe .00425230

; 00469DF8
; 40 c=2 n=40 a=9
; C0 c=3 n=20 a=8,7,6,5
; F0 c=4 n=10 a=4,3,2
; 00 c=5 n=08 a=1,0

@@FC PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-0Ch]
@@L1 = dword ptr [ebp-8]
@@L2 = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
	lodsd
	push	eax
	shl	eax, 8
	sbb	eax, eax
	and	eax, 808080h
	push	eax
	lodsd
	push	eax

@@1:	xor	eax, eax
	lea	edx, [eax+9-1]
	call	@@3
	adc	eax, eax
	call	@@3
	adc	eax, eax
	dec	eax
	js	@@1a
	call	@@3
	adc	eax, eax
	sub	edx, 4
	sub	eax, 4
	jb	@@1a
	call	@@3
	adc	eax, eax
	sub	edx, 3
	sub	eax, 3
	jb	@@1a
	call	@@3
	adc	eax, eax
@@1a:	sub	edx, eax
	cmp	edx, 3
	ja	@@1c
	call	@@5
	xor	ecx, ecx
	cmp	edx, 3
	jb	@@1b
	call	@@4
	dec	ecx
	js	@@9
	sub	[@@DC], ecx
	jbe	@@9
@@1b:	or	eax, 0FF000000h
	inc	ecx
	rep	stosd
	dec	[@@DC]
	je	@@7
	jmp	@@1

@@1c:	sub	edx, 6
	jb	@@1e
	call	@@5
@@1d:	call	@@6
	add	al, cl
	call	@@6
	add	ah, cl
	call	@@6
	shl	ecx, 10h
	add	eax, ecx
	shl	eax, 8
	jmp	@@1g

@@1e:	mov	eax, [@@L1]
	inc	edx
	je	@@1d
	mov	cl, 8
@@1f:	adc	bh, bh
	dec	ecx
	add	bl, bl
	jne	@@1f
	sub	[@@SC], 3
	jb	@@9
	mov	bl, [esi]
	shl	ebx, 10h
	mov	bh, [esi+1]
	mov	bl, [esi+2]
	add	esi, 3
	shl	ebx, 1
	inc	ebx
	shl	ebx, cl
	mov	eax, ebx
@@1g:	xor	ecx, ecx
	shr	eax, 8
	jmp	@@1b

@@7:	cmp	byte ptr [@@L2+2], 20h
	jne	@@7d
	movzx	ecx, word ptr [@@L0+2]
	movzx	edx, word ptr [@@L0]
	mov	edi, [@@DB]
	imul	edx, ecx
	mov	[@@DC], edx
@@7c:	mov	cl, 8
@@7e:	adc	bh, bh
	dec	ecx
	add	bl, bl
	jne	@@7e
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	shl	ebx, 1
	inc	ebx
	shl	ebx, cl
	call	@@4
	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
@@7f:	mov	[edi+3], bh
	add	edi, 4
	dec	ecx
	jne	@@7f
	cmp	[@@DC], 0
	jne	@@7c
@@7d:
	xor	esi, esi
	cmp	byte ptr [@@L2+3], 0
	je	@@9
	; 00426005
	movzx	ecx, word ptr [@@L0+2]
	movzx	ebx, word ptr [@@L0]
	dec	ecx
	je	@@9
	mov	edi, [@@DB]
	imul	ecx, ebx
	lea	edi, [edi+ebx*4]
	neg	ebx
@@7a:	mov	al, [edi+ebx*4]
	add	al, 80h
	add	[edi], al
	inc	edi
	mov	al, [edi+ebx*4]
	add	al, 80h
	add	[edi], al
	inc	edi
	mov	al, [edi+ebx*4]
	add	al, 80h
	add	[edi], al
	inc	edi
	inc	edi
	dec	ecx
	jne	@@7a

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

@@4:	xor	edx, edx
@@4a:	inc	edx
	cmp	edx, 1Eh
	jae	@@9
	call	@@3
	jc	@@4a
	xor	ecx, ecx
	inc	ecx
@@4b:	call	@@3
	adc	ecx, ecx
	dec	edx
	jne	@@4b
	dec	ecx
	dec	ecx
	ret

@@5:	xor	eax, eax
	cmp	edx, 3
	je	@@5a
	movzx	eax, word ptr [@@L0]
	neg	eax
	add	eax, edx
@@5a:	lea	eax, [edi+eax*4-4]
	cmp	eax, [@@DB]
	js	@@9
	mov	eax, [eax]
	ret

@@6:	call	@@4
	cmp	ecx, 200h
	jae	@@9
	shr	ecx, 1
	jnc	$+4
	not	ecx
	ret
ENDP

ENDP

