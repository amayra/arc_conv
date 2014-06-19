
; "Peace@Pieces" GR.059, PIC.059
; "Peace@Pieces FanDisk" GR.067, PIC.067
; 0040EA10 lz_unpack

	dw _conv_vafsh-$-2
_arc_vafsh PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+14h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 14h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ebx
	pop	ebx
	pop	ebx
	movzx	edx, dl
	lea	ecx, [ebx-18h]
	sub	eax, 'SFAV'
	sub	edx, 'H'
	shr	ecx, 14h+2
	or	eax, edx
	sub	ebx, 10h
	or	eax, ecx
	jne	@@9a
	call	_FileSeek, [@@S], 0, 2
	jc	@@9a
	xchg	edi, eax
	call	_FileSeek, [@@S], 10h, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	@@5
	dec	eax
	mov	[@@N], eax
	jle	@@9
	call	_ArcCount, eax

@@1:	and	[@@D], 0
	mov	eax, [esi]
	mov	ebx, [esi+4]
	sub	ebx, eax
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

@@5 PROC	; esi, ebx
	push	ebx
	push	esi
	mov	edx, ebx
	xor	ecx, ecx
@@1:	sub	ebx, 4
	jb	@@9
	lodsd
	cmp	eax, edx
	jb	@@9
	cmp	eax, edi
	ja	@@9
	lea	ecx, [ecx+1]
	jb	@@1
@@9:	xchg	eax, ecx
	pop	esi
	pop	ebx
	ret
ENDP

ENDP

_conv_vafsh PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	sub	ebx, 8
	jb	@@2
	movzx	eax, word ptr [esi]
	dec	eax
	cmp	eax, 4
	jae	@@9
	dec	eax
	jne	@@1
@@9:	stc
	leave
	ret

@@2:	lea	ecx, [ebx+8]
	test	ecx, ecx
	je	@@2a
	mov	edi, esi
	xor	eax, eax
	repe	scasb
	jne	@@9
@@2a:	clc
	leave
	ret

@@1:	movzx	edi, word ptr [esi+2]
	movzx	edx, word ptr [esi+4]
	add	edi, 7
	add	edx, 7
	shr	edi, 3
	shr	edx, 3
	movzx	eax, byte ptr [esi+6]
	movzx	ecx, byte ptr [esi+7]
	sub	eax, edi
	sub	ecx, edx
	or	eax, ecx
	jne	@@9
	mov	eax, edi
	imul	eax, edx
	sub	ebx, eax
	jb	@@9
	movzx	ecx, word ptr [esi]
	shl	edi, 3
	shl	edx, 3
	dec	ecx
	call	_ArcTgaAlloc, ecx, edi, edx
	xchg	edi, eax
	add	edi, 12h
	call	@@Unpack, edi, 0, esi, ebx
	mov	eax, [esi+2]
	mov	[edi-12h+0Ch], eax
	test	al, 7
	je	@@1b
	movzx	ecx, word ptr [esi]
	movzx	ebx, ax
	shr	eax, 10h
	lea	edx, [ebx+7]
	and	edx, -8
	sub	edx, ebx
	imul	ebx, ecx
	imul	edx, ecx
	mov	esi, edi
@@3b:	mov	ecx, ebx
	rep	movsb
	add	esi, edx
	dec	eax
	jne	@@3b
@@1b:	clc
	leave
	ret

@@Unpack PROC	; 0040DB40(1), 0040C9D0(3), 0040CF90(4)

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@C = dword ptr [ebp-4Ch]
@@H = dword ptr [ebp-50h]
@@W = dword ptr [ebp-54h]
@@Y = dword ptr [ebp-58h]
@@X = dword ptr [ebp-5Ch]

	push	ebx
	push	esi
	push	edi
	enter	48h, 0
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	movzx	ecx, word ptr [esi]
	movzx	eax, word ptr [esi+6]
	movzx	edx, al
	shr	eax, 8
	push	ecx
	push	eax
	push	edx
	imul	eax, edx
	lea	esi, [esi+eax+8]
	xor	ebx, ebx
@@2a:	push	ebx	; @@Y
	xor	ebx, ebx
@@2b:	push	ebx	; @@X
	mov	ecx, [@@H]
	sub	ecx, [@@Y]
	dec	ecx
	imul	ecx, [@@W]
	add	ecx, [@@X]
	mov	edx, [@@SB]
	mov	al, [edx+ecx+8]
	mov	ecx, [@@C]
	mov	[ebp-48h], eax
	cmp	ecx, 4
	jae	@@2c
	test	al, al
	jns	@@2c
	shr	eax, 1
	mov	edx, [@@W]
	mov	edi, [@@Y]
	sbb	eax, eax
	shl	edi, 3
	shl	ecx, 3
	imul	edi, edx
	add	edi, [@@X]
	dec	edx
	imul	edx, ecx
	imul	edi, ecx
	mov	ebx, ecx
	add	edi, [@@DB]
	push	esi
	push	8
	pop	esi
@@3b:	mov	ecx, ebx
	rep	stosb
	add	edi, edx
	dec	esi
	jne	@@3b
	pop	esi
	jmp	@@8

@@2c:	lea	edi, [ebp-44h]
	sub	[@@SC], ecx
	jb	@@9
	rep	movsb
	xor	ebx, ebx
@@1:	mov	eax, [ebp-48h]
	and	eax, 3
	lea	ecx, [eax+1]
	shl	ecx, 4
	sub	[@@SC], ecx
	jb	@@9
	lea	edi, [ebp-40h]
	mov	cl, 10h
	dec	eax
	jns	@@1b
@@1a:	movzx	edx, byte ptr [esi]
	inc	esi
rept 4
	mov	eax, edx
	shl	edx, 2
	sar	al, 6
	stosb
endm
	dec	ecx
	jne	@@1a
	jmp	@@1g

@@1b:	jne	@@1d
	shl	ecx, 1
@@1c:	movzx	edx, byte ptr [esi]
	inc	esi
rept 2
	mov	eax, edx
	shl	edx, 4
	sar	al, 4
	stosb
endm
	dec	ecx
	jne	@@1c
	jmp	@@1g

@@1d:	dec	eax
	jne	@@1f
@@1e:
rept 3
	lodsb
	shl	eax, 2
	sar	al, 2
	stosb
endm
	shr	eax, 6
	sar	al, 2
	stosb
	dec	ecx
	jne	@@1e
	jmp	@@1g

@@1f:	rep	movsd
@@1g:	or	eax, -1
	push	esi
	mov	esi, offset @@T
@@1h:	lodsw
	movsx	edx, al
	sar	eax, 8
	mov	cl, [edi+edx]
	add	[edi+eax], cl
	cmp	eax, edx
	jne	@@1h
	shr	dword ptr [ebp-44h], 8
	shr	dword ptr [ebp-48h], 2

	mov	ecx, [@@W]
	mov	edi, [@@Y]
	shl	ecx, 3
	imul	edi, ecx
	mov	edx, [@@C]
	add	edi, [@@X]
	sub	ecx, 8
	shl	edi, 3
	imul	ecx, edx
	imul	edi, edx
	mov	eax, ebx	; 0123 -> 1230
	cmp	edx, 4
	adc	eax, -1
	and	eax, 3
	dec	edx
	add	edi, eax
	lea	esi, [ebp-40h]
	add	edi, [@@DB]
	push	3Fh
	pop	eax
@@3a:	movsb
	add	edi, edx
	test	al, 7
	jne	$+4
	add	edi, ecx
	dec	eax
	jns	@@3a
	pop	esi

	inc	ebx
	cmp	ebx, [@@C]
	jb	@@1
@@8:	pop	ebx
	inc	ebx
	cmp	ebx, [@@W]
	jb	@@2b
	pop	ebx
	inc	ebx
	cmp	ebx, [@@H]
	jb	@@2a
	xor	esi, esi
@@9:	mov	eax, [@@DC]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@T:	db -44h,-25h
	db -25h,-26h
	db -26h,-27h
	db -27h,-28h
	db -25h,-2Dh
	db -25h,-2Eh
	db -2Eh,-2Fh
	db -2Fh,-30h
	db -2Dh,-35h
	db -2Eh,-36h
	db -2Eh,-37h
	db -37h,-38h
	db -35h,-3Dh
	db -36h,-3Eh
	db -37h,-3Fh
	db -37h,-40h

	db -44h,-24h
	db -24h,-23h
	db -23h,-22h
	db -22h,-21h
	db -24h,-2Ch
	db -24h,-2Bh
	db -2Bh,-2Ah
	db -2Ah,-29h
	db -2Ch,-34h
	db -2Bh,-33h
	db -2Bh,-32h
	db -32h,-31h
	db -34h,-3Ch
	db -33h,-3Bh
	db -32h,-3Ah
	db -32h,-39h

	db -44h,-1Dh
	db -1Dh,-1Eh
	db -1Eh,-1Fh
	db -1Fh,-20h
	db -1Dh,-15h
	db -1Dh,-16h
	db -16h,-17h
	db -17h,-18h
	db -15h,-0Dh
	db -16h,-0Eh
	db -16h,-0Fh
	db -0Fh,-10h
	db -0Dh,-05h
	db -0Eh,-06h
	db -0Fh,-07h
	db -0Fh,-08h

	db -44h,-1Ch
	db -1Ch,-1Bh
	db -1Bh,-1Ah
	db -1Ah,-19h
	db -1Ch,-14h
	db -1Ch,-13h
	db -13h,-12h
	db -12h,-11h
	db -14h,-0Ch
	db -13h,-0Bh
	db -13h,-0Ah
	db -0Ah,-09h
	db -0Ch,-04h
	db -0Bh,-03h
	db -0Ah,-02h
	db -0Ah,-01h

	db -44h,-44h
ENDP

ENDP