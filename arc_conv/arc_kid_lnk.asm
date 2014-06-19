
; "Ever 17" *.dat
; ever17PC_us.exe 0040D5F0
; 0040D1F0 decode
; 0040D8A0 lnd_unpack
; 00426DD0 vm

	dw _conv_kid_lnk-$-2
_arc_kid_lnk PROC

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
	pop	ebx
	pop	edx
	pop	ecx
	sub	eax, 'KNL'
	or	edx, ecx
	lea	ecx, [ebx-1]
	or	eax, edx
	shr	ecx, 14h
	or	eax, ecx
	jne	@@9a
	mov	[@@N], ebx
	shl	ebx, 5
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	add	ebx, 10h
	mov	[@@P], ebx

	call	_ArcParamNum, 0
	db 'lnk', 0
	jnc	@@2b
	call	_unicode_name, offset inFileName
	push	eax
	call	@@2a
	db 'saver.dat',0, 'sysvoice.dat',0, 'wallpaper.dat',0, 0
@@2a:	call	_filename_select
	sbb	eax, eax
	inc	eax
@@2b:	mov	[@@L0], eax

@@1:	lea	edx, [esi+8]
	call	_ArcName, edx, 18h
	mov	eax, [esi]
	mov	ebx, [esi+4]
	and	[@@D], 0
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	shr	ebx, 1
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	mov	eax, [esi+4]
	shr	eax, 1
	jnc	@@1c
	cmp	ebx, 10h
	jb	@@1c
	mov	edi, [@@D]
	mov	edx, 10064h
	mov	eax, [edi]
	sub	edx, [edi+4]
	sub	eax, 'dnl'
	or	eax, edx
	jne	@@1c
	call	_MemAlloc, dword ptr [edi+8]
	jc	@@1c
	lea	edx, [edi+10h]
	xchg	edi, eax
	call	_lnk_unpack, edi, dword ptr [edx-8], edx, ebx
	xchg	ebx, eax
	call	_MemFree, [@@D]
	mov	[@@D], edi
@@1c:	cmp	[@@L0], 0
	je	@@1b
	call	@@3
@@1b:	call	_ArcConv, [@@D], ebx
@@1a:	call	_MemFree, [@@D]
@@8:	add	esi, 20h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	call	_ArcGetExt
	xor	edx, edx
	cmp	eax, 'vaw'	; .wav 0
	je	@@3a
	mov	dh, 11h
	cmp	eax, 'gpj'	; .jpg 1100h
	je	@@3a
	mov	dh, 10h
	cmp	eax, 'rcs'	; .scr 1000h
	jne	@@3d
	cmp	ebx, 40h
	jb	@@3d
	mov	eax, [@@D]
	cmp	word ptr [eax], 'ZM'
	jne	@@3d
@@3a:	mov	ecx, ebx
	xor	edi, edi
	sub	ecx, edx
	jbe	@@3d
	mov	eax, 100h
	cmp	ecx, eax
	jb	$+3
	xchg	ecx, eax
	add	edx, [@@D]
	push	ebx
	xor	ebx, ebx
@@3b:	movzx	eax, byte ptr [esi+edi+8]
	inc	edi
	test	eax, eax
	je	@@3c
	add	ebx, eax
	cmp	edi, 18h
	jb	@@3b
@@3c:	sub	[edx], bl
	inc	edx
	imul	ebx, 6Dh
	add	ebx, -25h
	dec	ecx
	jne	@@3c
	pop	ebx
@@3d:	ret
ENDP

_conv_kid_lnk PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'spc'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	cmp	ebx, 14h
	jb	@@9
	cmp	dword ptr [esi], 'SPC'
	jne	@@9
	call	@@Decrypt
	cmp	byte ptr [esi+8], 'f'
	jne	@@9
	sub	ebx, 14h
	mov	al, [esi+0Ah]
	mov	edi, [esi+0Ch]
	test	al, 1
	jne	@@1d
	test	al, 2
	jne	@@9
	cmp	ebx, edi
	jb	$+4
	mov	ebx, edi
	push	0	; @@L0
	lea	edi, [esi+14h]
	jmp	@@1e

@@1d:	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	push	edi	; @@L0
	lea	edx, [esi+14h]
	call	_lnk_unpack, edi, eax, edx, ebx
	xchg	ebx, eax
@@1e:
	cmp	ebx, 14h
	jb	@@1a
	cmp	dword ptr [edi], 'TRP'
	jne	@@1a

	; 00180066 00240024
	; 00180065 00140014
	; 00080066 04240024
	; 00080065 04140014

	movzx	ecx, word ptr [edi+4]
	movzx	edx, word ptr [edi+0Ah]
	mov	eax, [edi+8]
	cmp	ebx, edx
	jb	@@1a
	sub	ecx, 65h
	shr	ecx, 1
	jne	@@1a
	movzx	eax, word ptr [edi+8]
	sbb	ecx, ecx
	and	ecx, 10h
	add	ecx, 14h
	cmp	ecx, eax
	jne	@@1a
	sub	edx, ecx
	movzx	eax, word ptr [edi+6]
	ror	eax, 3
	dec	eax
	ror	eax, 1
	shr	eax, 1
	jne	@@9
	jc	@@1b
	sub	dh, 4
@@1b:	test	edx, edx
	je	@@2
@@1a:	call	_ArcData, edi, ebx
@@1c:	call	_MemFree, [@@L0]
	clc
	leave
	ret

@@2:	mov	esi, edi
	movzx	edx, word ptr [edi+0Ah]
	movzx	ecx, word ptr [edi+6]
	sub	ebx, edx
	ror	ecx, 3
	movzx	edi, word ptr [esi+0Ch]
	movzx	edx, word ptr [esi+0Eh]
	cmp	byte ptr [esi+8], 24h
	jb	@@2c
	mov	eax, [esi+1Ch]
	or	eax, [esi+20h]
	je	@@2c
	mov	edi, [esi+1Ch]
	mov	edx, [esi+20h]
@@2c:	mov	eax, edi
	imul	eax, ecx
	add	eax, 3
	and	al, -4
	imul	eax, edx
	push	eax	; @@L1
	sub	ebx, eax
	jb	@@2a
	cmp	byte ptr [esi+10h], 0
	je	@@2f
	mov	eax, edi
	imul	eax, edx
	sub	ebx, eax
	jb	@@2a
	mov	cl, 4
@@2f:	add	ecx, 44h+18h-1
	call	_ArcTgaAlloc, ecx, edi, edx
	jnc	@@2b
@@2a:	call	_MemFree, [@@L0]
	stc
	leave
	ret

@@2b:	lea	edi, [eax+12h]
	cmp	byte ptr [esi+8], 24h
	jb	@@2d
	mov	eax, [esi+18h-2]
	mov	ax, [esi+14h]
	mov	[edi-12h+8], eax
@@2d:	movzx	eax, word ptr [esi+6]
	mov	cl, [esi+10h]
	movzx	edx, word ptr [esi+8]
	add	esi, edx
	test	cl, cl
	jne	@@2g
	push	edi
	cmp	al, 8
	jne	@@2e
	mov	ecx, 100h
	rep	movsd
@@2e:	mov	ecx, [@@L1]
	rep	movsb
	call	_tga_align4
	jmp	@@1c

@@2g:	call	@@Mask, edi, esi, [@@L1], eax
	jmp	@@1c

@@Mask PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@L0 = dword ptr [ebp+1Ch]
@@L1 = dword ptr [ebp+20h]

@@stk = 0
@M0 @@W
@M0 @@H
@M0 @@A

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	edi, [@@D]
	mov	esi, [@@S]
	movzx	eax, word ptr [edi-12h+0Ch]
	movzx	edx, word ptr [edi-12h+0Eh]
	push	eax
	push	edx
	imul	edx, eax
	mov	ecx, [@@L1]
	add	edx, [@@L0]
	ror	ecx, 3
	imul	eax, ecx
	neg	eax
	and	eax, 3
	push	eax
	dec	ecx
	je	@@2
	add	edx, esi
@@1a:	mov	ecx, [@@W]
	sub	edx, ecx
@@1b:	movsb
	movsb
	movsb
	mov	al, [edx]
	inc	edx
	stosb
	dec	ecx
	jne	@@1b
	sub	edx, [@@W]
	add	esi, [@@A]
	dec	[@@H]
	jne	@@1a
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@2:	mov	ebx, esi
	add	esi, 400h
	add	edx, esi
@@2a:	mov	ecx, [@@W]
	sub	edx, ecx
@@2b:	xor	eax, eax
	lodsb
	mov	eax, [ebx+eax*4]
	stosd
	dec	edi
	mov	al, [edx]
	inc	edx
	stosb
	dec	ecx
	jne	@@2b
	sub	edx, [@@W]
	add	esi, [@@A]
	dec	[@@H]
	jne	@@2a
	jmp	@@9
ENDP

@@Decrypt PROC	; aiaoPC_us.exe 00413C90
	push	ebx
	push	esi
	push	edi
	mov	eax, [esi+4]
	cmp	ebx, eax
	xchg	ebx, eax
	jb	@@9
	cmp	ebx, 14h
	jb	@@9
	sub	ebx, 4
	mov	eax, 7534682h
	mov	edi, [esi+ebx]
	sub	edi, eax
	jbe	@@9
	cmp	ebx, edi
	jb	@@9
	mov	ecx, [esi+edi]
	mov	[esi+ebx], eax
	lea	ecx, [ecx+edi+3786425h]
	push	10h
	pop	edx
	jmp	@@2
@@1:	cmp	edx, edi
	je	@@2
	lea	eax, [ecx+ebx+4]
	sub	[esi+edx], eax
@@2:	imul	ecx, 41C64E6Dh
	add	edx, 4
	add	ecx, 9B06h
	cmp	edx, ebx
	jb	@@1
@@9:	pop	edi
	pop	esi
	pop	ebx
	ret
ENDP

ENDP

_lnk_unpack PROC	; ever17PC_us.exe 0040D8A0

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
@@1:	xor	eax, eax
	cmp	[@@DC], 0
	je	@@7
	dec	[@@SC]
	js	@@9
	lodsb
	add	al, 40h
	js	@@1c
	; 0xC0
	mov	ecx, eax
	mov	edx, eax
	and	ecx, 1Fh
	test	al, 20h
	je	@@1a
	dec	[@@SC]
	js	@@9
	lodsb
	shl	eax, 5
	add	ecx, eax
@@1a:	inc	ecx
	and	edx, 40h
	jne	@@1b
	inc	ecx
	; 0xC0
	sub	[@@DC], ecx
	jb	@@9
	dec	[@@SC]
	js	@@9
	lodsb
	rep	stosb
	jmp	@@1

@@1b:	; 0x00
	sub	[@@DC], ecx
	jb	@@9
	sub	[@@SC], ecx
	jb	@@9
	rep	movsb
	jmp	@@1

@@1c:	add	al, 40h
	jnc	@@1e
	; 0x80
	mov	ecx, eax
	and	al, 3
	shr	ecx, 2
	mov	ah, al
	dec	[@@SC]
	js	@@9
	lodsb
	xchg	edx, eax
	add	ecx, 2
	not	edx
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
@@1d:	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@1e:	; 0x40
	and	al, 3Fh
	lea	ecx, [eax+2]
	dec	[@@SC]
	js	@@9
	lodsb
	inc	eax
	imul	eax, ecx
	sub	[@@SC], ecx
	jb	@@9
	sub	[@@DC], eax
	jb	@@9
	sub	eax, ecx
	mov	edx, edi
	rep	movsb
	xchg	ecx, eax
	xchg	eax, edx
	jmp	@@1d

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
