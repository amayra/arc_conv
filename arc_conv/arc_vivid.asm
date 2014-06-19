
; "Silver Chaos" pack\*.com
; module\FileSystem.mod
; 10001000 unpack
; 10001120 file_read
; 100013A0 open_archive
; module\GObj_BGData.mod
; 10001000 bgd_unpack
; module\GObj_CHRData.mod
; 10001300 chr_unpack

	dw _conv_vivid-$-2
_arc_vivid PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC
@M0 @@E
@M0 @@L0

	enter	@@stk+8+4, 0
	call	_FileSeek, [@@S], -8, 2
	jc	@@9a
	xchg	edi, eax
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	eax
	pop	ebx
	xor	eax, 'KCAP'
	sub	edi, ebx
	jb	@@9a
	sub	edi, 4
	jbe	@@9a
	xor	esi, esi
	test	eax, eax
	je	@@2b
	mov	esi, offset @@T
	mov	ecx, [esi-4]
@@2c:	cmp	eax, [esi]
	je	@@2b
	add	esi, 10h
	dec	ecx
	jne	@@2c
	jmp	@@9a

@@2b:	call	_FileSeek, [@@S], ebx, 0
	jc	@@9a
	mov	edx, esp
	call	_FileRead, [@@S], edx, 4
	jc	@@9a
	pop	ebx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, ebx, edi, 0
	jc	@@9
	call	@@3
	mov	esi, [@@M]
	call	@@Unpack, esi, ebx, edx, edi
	jc	@@9
	call	@@5
	test	eax, eax
	je	@@9
	mov	[@@N], eax
	call	_ArcCount, eax
	call	_ArcDbgData, esi, ebx
	call	_ArcUnicode, 1

@@1:	lodsd
	xchg	edi, eax
	movzx	ebx, byte ptr [esi]
	movzx	eax, byte ptr [esi+1]
	mov	[@@L0], eax
	add	esi, 6
	call	_ArcName, esi, ebx
	lea	esi, [esi+ebx*2]
	mov	ebx, [esi]
	and	[@@D], 0
	sub	ebx, edi
	jb	@@8
	call	_FileSeek, [@@S], edi, 0
	jc	@@1a
	cmp	[@@L0], 1
	je	@@2a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	sub	ebx, 4
	jb	@@1a
	lea	eax, [@@L0]
	call	_FileRead, [@@S], eax, 4
	jc	@@1a
	mov	edi, [@@L0]
	lea	eax, [@@D]
	call	_ArcMemRead, eax, edi, ebx, 0
	call	@@Unpack, [@@D], edi, edx, eax
	jmp	@@1b

@@3 PROC
	push	edx
	push	edi
	test	esi, esi
	je	@@9
	xor	ecx, ecx
@@1:	mov	al, [esi+ecx]
	inc	ecx
	xor	[edx], al
	inc	edx
	and	ecx, 0Fh
	dec	edi
	jne	@@1
@@9:	pop	edi
	pop	edx
	ret
ENDP

	; MainSystem.exe 0041D920
	dd 3
@@T	dd 011CD93CCh,09BEF19F3h,0D98EC3B6h,053FA4506h	; "Silver Chaos FanBox"
	dd 05C3E250Fh,090774B2Ah,0468E8A05h,043113DEBh	; "Imouto de Ikou!"
	dd 0ACC74A40h,04E9C71C6h,054CC81A8h,072C2B5F8h	; "Hanamachi Monogatari"

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
@@1:	cmp	[@@DC], 0
	je	@@7
	xor	eax, eax
	dec	[@@SC]
	js	@@9
	lodsb
	test	al, al
	js	@@1a
	inc	eax
	sub	[@@DC], eax
	jb	@@9
	sub	[@@SC], eax
	jb	@@9
	xchg	ecx, eax
	rep	movsb
	jmp	@@1

@@1a:	dec	[@@SC]
	js	@@9
	mov	edx, 7FFh
	shl	eax, 8
	lodsb
	and	edx, eax
	shr	eax, 0Bh
	not	edx
	lea	ecx, [eax+eax-1Eh]
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
@@9:	mov	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

@@5 PROC	; esi, ebx
	push	ebx
	push	esi
	xor	ecx, ecx
	sub	ebx, 4
	jb	@@9
@@1:	lodsd
	xor	eax, eax
	sub	ebx, 0Ah
	jb	@@9
	lodsb
	shl	eax, 1
	je	@@9
	sub	ebx, eax
	jb	@@9
	lea	esi, [esi+5+eax]
	inc	ecx
	jmp	@@1
@@9:	xchg	eax, ecx
	pop	esi
	pop	ebx
	ret
ENDP

ENDP

_conv_vivid PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'rhc'
	je	@@3
	cmp	eax, 'pla'
	je	@@4b
	cmp	eax, 'pamc'
	je	@@4b
	cmp	eax, 'bxet'
	je	@@4a
	sub	ebx, 10h
	jb	@@9
	cmp	eax, 'dgc'
	je	@@2
	cmp	eax, 'dgb'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	mov	edi, [esi+4]
	mov	edx, [esi+8]
	mov	ebx, edi
	imul	ebx, edx
	shr	ebx, 1
	call	_ArcTgaAlloc, 2, edi, edx
	lea	edi, [eax+12h]
	mov	ecx, [@@SB]
	lea	edx, [esi+10h]
	sub	ecx, 10h
	call	@@BGD, edi, ebx, edx, ecx
	mov	esi, [esi+0Ch]
	jmp	@@5

@@2:	mov	edi, [esi+4]
	mov	edx, [esi+8]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 2, edi, edx
	lea	edi, [eax+12h]
	mov	ecx, [@@SB]
	lea	edx, [esi+10h]
	sub	ecx, 10h
	call	@@CGD, edi, ebx, edx, ecx
	mov	esi, [esi+0Ch]
	jmp	@@5

@@4a:	sub	ebx, 8
	jb	@@9b
	mov	edi, [esi]
	mov	edx, [esi+4]
	add	esi, 8
	mov	eax, edi
	imul	eax, edx
	shl	eax, 2
	cmp	ebx, eax
	jne	@@9b
	call	_ArcTgaAlloc, 23h, edi, edx
	lea	edi, [eax+12h]
	mov	ecx, ebx
	shr	ecx, 2
	rep	movsd
@@4c:	call	_ArcGetExt
	mov	byte ptr [edx], '_'
	clc
	leave
	ret

@@4b:	sub	ebx, 8
	jb	@@9b
	mov	edi, [esi]
	mov	edx, [esi+4]
	add	esi, 8
	mov	eax, edi
	imul	eax, edx
	cmp	ebx, eax
	jne	@@9b
	call	_ArcTgaAlloc, 20h, edi, edx
	lea	edi, [eax+12h]
	mov	ecx, ebx
	rep	movsb
	jmp	@@4c

@@9b:	stc
	leave
	ret

@@3:	cmp	ebx, 24h
	jb	@@9b
	mov	edx, [esi]
	mov	eax, [esi+18h]
	sub	edx, ebx
	or	eax, [esi+1Ch]
	or	eax, edx
	jne	@@9b

	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	call	_ArcTgaAlloc, 3, edi, edx
	lea	edi, [eax+12h]
	mov	eax, [esi+12h]
	mov	ax, [esi+10h]
	mov	[edi-12h+8], eax
	mov	ecx, [@@SB]
	lea	edx, [esi+20h]
	sub	ecx, 20h
	call	@@CHR1, edi, dword ptr [edi-12h+0Ch], edx, ecx

	mov	esi, [esi+4]
@@5:	mov	ebx, [@@SC]
	test	esi, esi
	je	@@5a
	sub	ebx, esi
	jb	@@5a
	add	esi, [@@SB]
	sub	ebx, 4
	jb	@@5a
	mov	eax, [esi]
	cmp	ebx, eax
	jb	$+4
	xchg	ebx, eax
	sub	ebx, 14h
	jb	@@5a
	mov	edi, [esi+8]
	movzx	edx, word ptr [esi+10h]
	movzx	ecx, word ptr [esi+12h]
	shl	edx, 2
	imul	ecx, edi
	imul	edx, ecx
	sub	ebx, edx
	mov	ecx, edi
	shr	ecx, 0Ch
	or	ebx, ecx
	jne	@@5a
	push	edi	; @@L0
	call	_ArcSetExt, 0
	push	edx	; @@L1

	xor	ebx, ebx
@@5b:	call	_ArcTgaSave
	call	_ArcTgaFree
@@5e:	cmp	ebx, [@@L0]
	jb	@@5c
@@5a:	clc
	leave
	ret

@@5c:	call	_ArcNameFmt, [@@L1], ebx
	db '\%05i',0
	pop	ecx

	movzx	edi, word ptr [esi+10h]
	movzx	edx, word ptr [esi+12h]
	call	_ArcTgaAlloc, 40h+3, edi, edx
	jc	@@5e
	lea	edi, [eax+12h]
	mov	eax, [esi+0Ch]
	mov	[edi-12h+8], eax

	movzx	eax, word ptr [esi+10h]
	movzx	edx, word ptr [esi+12h]
	imul	eax, edx
	imul	eax, ebx
	lea	edx, [esi+14h+eax*4]
	call	@@CHR2, edi, edx
	inc	ebx
	jmp	@@5b

@@CHR2 PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]

@@L0 = word ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@D]
	mov	esi, [@@S]
	push	dword ptr [edi-12h+0Ch]
@@1:	movzx	ecx, [@@L0]
@@2:	movsb
	movsb
	movsb
	movzx	eax, byte ptr [esi]
	inc	esi
	imul	eax, 0FFh
	shr	eax, 7
	stosb
	dec	ecx
	jne	@@2
	dec	[@@L0+2]
	jne	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP	; @@CHR2

@@BGD PROC

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
	mov	eax, 10001h
	xor	ebx, ebx
	push	eax
	push	eax
@@1:	sub	[@@SC], 3
	jb	@@9
	mov	bl, 2
	mov	al, [esi]	; 0
	and	al, 0Fh
	call	@@2
	lodsb			; 0
	shr	al, 4
	call	@@2
	lodsb			; 1
	and	al, 0Fh
	call	@@2
	mov	bl, 2
	mov	al, [esi]	; 2
	and	al, 0Fh
	call	@@2
	lodsb			; 2
	shr	al, 4
	call	@@2
	mov	al, [esi-2]	; 1
	shr	al, 4
	call	@@2
	dec	[@@DC]
	jne	@@1
@@9:	mov	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	[@@DC]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@2:	add	al, -8
	sbb	edx, edx
	and	eax, 7
	movzx	ecx, byte ptr [esp+ebx*2]
	lea	ecx, [ecx*8+eax]
	mov	al, [@@T+ecx]
	xor	eax, edx
	sub	eax, edx
	mov	cl, [@@T+ecx+18h]
	add	al, [esp+ebx*2+1]
	mov	[esp+ebx*2], cl
	mov	[esp+ebx*2+1], al
	stosb
	inc	ebx
	ret

@@T	db 001h,002h,004h,008h,010h,026h,050h,0AAh
	db 002h,004h,006h,00Ch,018h,030h,060h,0C0h
	db 005h,00Ah,014h,01Eh,032h,050h,082h,0D2h
	db 0,0,0,1,1,1,1,1
	db 0,0,1,1,2,2,1,1
	db 1,1,2,2,2,2,1,1
ENDP	; @@BGD

@@CHR1 PROC

@@DB = dword ptr [ebp+14h]
@@W = word ptr [ebp+18h]
@@H = word ptr [ebp+1Ah]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@DC = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
@@2:	movzx	eax, word ptr [@@W]
	push	eax
@@1:	xor	eax, eax
	dec	[@@SC]
	js	@@9
	lodsb
	cmp	eax, 7Fh
	jae	@@1a
	dec	[@@DC]
	js	@@9
	sub	[@@SC], 3
	jb	@@9
	inc	eax
	shl	eax, 1
	movsb
	movsb
	movsb
	stosb
	jmp	@@1

@@1a:	lea	ecx, [eax-7Fh]
	cmp	ecx, 20h	; 0x9F
	jae	@@1c
	sub	[@@SC], 3
	jb	@@9
	mov	ah, -1
	mov	al, [esi+2]
	shl	eax, 10h
	lodsw
	inc	esi
	jmp	@@1d

@@1c:	sub	ecx, 20h	; 0x9E
	cmp	ecx, 60h	; 0xFF EOL
	jae	@@1e
	xor	eax, eax
@@1d:	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
	rep	stosd
	jmp	@@1

@@1e:	pop	ecx
	xor	eax, eax
	rep	stosd
	dec	[@@H]
	jne	@@2
@@9:	mov	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	[@@H]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP	; @@CHR1

@@CGD PROC

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
	xor	edx, edx
@@1:	xor	eax, eax
	dec	[@@SC]
	js	@@9
	lodsb
	test	al, al
	js	@@1a
	dec	[@@SC]
	js	@@9
	mov	ah, al
	lodsb
	dec	[@@DC]
	js	@@9
	xor	eax, 4210h
	mov	ecx, eax
	and	al, 1Fh
	shr	ecx, 5
	shr	ah, 2
	and	ecx, 1Fh
	sub	al, 10h
	sub	cl, 10h
	sub	ah, 10h
	add	bl, al
	add	bh, cl
	add	dl, ah
	mov	[edi], bx
	mov	[edi+2], dl
	add	edi, 3
	jmp	@@1

@@1a:	cmp	al, -1
	je	@@7
	mov	ecx, eax
	and	ecx, 3Fh
	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
	cmp	al, 0C0h
	jb	@@1b
	lea	ecx, [ecx*2+ecx]
	sub	[@@SC], ecx
	jb	@@9
	rep	movsb
	mov	bx, [edi-3]
	mov	dl, [edi-1]
	jmp	@@1

@@1b:	mov	[edi], bx
	mov	[edi+2], dl
	add	edi, 3
	dec	ecx
	jne	@@1b
	jmp	@@1

@@7:	mov	esi, [@@DC]
@@9:	xchg	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP	; @@CGD

ENDP	; @@Convert

ENDP
