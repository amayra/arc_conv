
; "Hanafuda Market" *.bin
; hanamar.exe
; 00425040 open_archive
; 00421B10 read_file

	dw _conv_hanafuda-$-2
_arc_hanamar PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	ebx
	pop	ecx
	lea	edx, [ecx-1]
	sub	eax, 'LIFR'
	shr	edx, 14h
	or	eax, edx
	jne	@@9a
	mov	[@@N], ecx
	pop	[@@L0]
	shl	ecx, 6
	cmp	ebx, ecx
	jne	@@9a

	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	[@@L0], 4D2h	; 'gorp' - nocrypt
	jne	@@2a
	call	_hanamar_crypt, 0, esi, ebx
@@2a:	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	call	_ArcName, esi, 34h
	and	[@@D], 0
	mov	ebx, [esi+38h]
	call	_FileSeek, [@@S], dword ptr [esi+34h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	mov	eax, [esi+3Ch]
	test	ebx, ebx
	je	@@1a
	mov	edx, ebx
	dec	eax
	je	@@1b
	dec	eax
	je	@@1d
	dec	eax
	dec	eax
	jne	@@1a
	mov	eax, 400h
	cmp	edx, eax
	jb	$+3
	xchg	edx, eax
	jmp	@@1b

@@1d:	mov	eax, 51EB851Fh
	mul	edx
	shr	edx, 5
	inc	edx
@@1b:	mov	ecx, [@@D]
@@1c:	xor	byte ptr [ecx], 7Fh
	inc	ecx
	dec	edx
	jne	@@1c
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 40h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_hanamar_crypt PROC
	mov	ecx, [esp+0Ch]
	mov	edx, [esp+8]
	mov	eax, [esp+4]
	test	ecx, ecx
	je	@@9
	push	ebx
@@1:	imul	eax, 343FDh
	add	eax, 269EC3h
	mov	ebx, eax
	shr	ebx, 10h
	xor	[edx], bl
	inc	edx
	dec	ecx
	jne	@@1
@@9:	pop	ebx
	ret	0Ch
ENDP

; "Shinobi Hanafuda 2 Hyakka Soumei" SOUMEI.BIN
; SOUMEI.EXE
; 00410C90 smg_read

	dw _conv_hanafuda-$-2
_arc_hanafuda PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 8

	enter	@@stk+14h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 14h
	jc	@@9a
	movzx	eax, byte ptr [esi+1]
	ror	eax, 6
	cmp	eax, 3
	jae	@@9a

	mov	eax, [esi]
	mov	[@@L0], eax
	lea	edx, [esi+8]
	call	_hanamar_crypt, 0, edx, 0Ch
	mov	[@@L0+4], eax

	call	_MemAlloc, 14h*200h
	jc	@@9a
	mov	[@@M], eax
	xchg	esi, eax

	xor	ebx, ebx
	mov	edi, esi
@@4:	call	_FileRead, [@@S], edi, 14h
	jc	@@9
	cmp	byte ptr [edi], 0
	je	@@4a
	inc	ebx
	add	edi, eax
	cmp	ebx, 200h
	jb	@@4
	jmp	@@9

@@4a:	test	ebx, ebx
	je	@@9
	mov	[@@N], ebx
	sub	edi, esi

	movzx	eax, byte ptr [@@L0+1]
	mov	edx, esi
	test	al, al
	je	@@2c
	jns	@@2b
	mov	ecx, edi
@@2a:	xor	byte ptr [edx], 7Fh
	inc	edx
	dec	ecx
	jne	@@2a
	jmp	@@2c
@@2b:	call	_hanamar_crypt, [@@L0+4], edx, edi
@@2c:
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, edi

@@1:	push	8
	pop	ecx
@@1b:	cmp	byte ptr [esi+ecx-1], 20h
	jne	@@1c
	dec	ecx
	jne	@@1b
@@1c:	call	_ArcName, esi, ecx
	mov	eax, [esi+8]
	cmp	al, 2Eh
	jne	@@1d
	shr	eax, 8
	call	_ArcSetExt, eax
@@1d:	and	[@@D], 0
	mov	ebx, [esi+10h]
	call	_FileSeek, [@@S], dword ptr [esi+0Ch], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
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
ENDP

_conv_hanafuda PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 36h
	jb	@@9
	cmp	word ptr [esi], 'MB'
	jne	@@1
	cmp	dword ptr [esi+0Eh], 28h
	jne	@@1
	call	_ArcSetExt, 'pmb'
@@9:	stc
	leave
	ret

@@1:	mov	eax, 380h
	cmp	ebx, eax
	jb	@@9
	sub	eax, [esi+0Ch]
	sub	ebx, [esi+20h]
	or	eax, ebx
	jne	@@9
	movzx	edi, word ptr [esi+44h]
	movzx	edx, word ptr [esi+46h]
	lea	eax, [edi-1]
	shr	eax, 7+3
	jne	@@9
	call	_ArcTgaAlloc, 34h, edi, edx
	lea	edi, [eax+12h]
	push	edi
	push	esi
	sub	esi, -80h
	mov	ah, 0
@@1a:	movsb
	movsb
	lodsb
	xchg	al, [edi-2]
	stosb
	dec	ah
	jne	@@1a
	pop	esi
	call	@@SMG, edi, esi
	call	_tga_align4
	clc
	leave
	ret

@@SMG PROC	; 00410F60

@@DB = dword ptr [ebp+14h]
@@SB = dword ptr [ebp+18h]

@@stk = 0
@M0 @@W
@M0 @@H
@M0 @@L3, 8
@M0 @@L2, 8
@M0 @@L1, 8
@M0 @@L0

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@SB]
	mov	edi, [@@DB]
	movzx	eax, word ptr [esi+44h]
	movzx	edx, word ptr [esi+46h]
	push	eax
	push	edx
	push	3
	pop	ebx
	mov	ecx, [esi+20h]
@@2a:	mov	eax, [esi+0Ch+ebx*4-4]
	sub	ecx, eax
	jb	@@9
	push	ecx
	mov	ecx, eax
	add	eax, esi
	push	eax
	dec	ebx
	jne	@@2a
	push	ebx	; @@L0

	add	esp, -80h
	xor	eax, eax
	mov	edi, esp
	lea	ecx, [eax+20h]
	rep	stosd
	mov	edi, [@@DB]

@@1:	mov	ebx, [@@W]
	add	ebx, 7
	shr	ebx, 3
	xor	ecx, ecx
	mov	esi, esp
@@1a:	shl	cl, 1
	jne	@@1c
	dec	[@@L2+4]
	js	@@9
	mov	edx, [@@L2]
	mov	cl, [edx]
	inc	edx
	mov	[@@L2], edx
	stc
	adc	cl, cl
@@1c:	jnc	@@1b
	dec	[@@L3+4]
	js	@@9
	mov	edx, [@@L3]
	mov	al, [edx]
	inc	edx
	mov	[@@L3], edx
	xor	[esi], al
@@1b:	inc	esi
	dec	ebx
	jne	@@1a

	mov	ebx, [@@W]
	mov	esi, esp
	add	ebx, 3
	shr	ebx, 2
@@4:	movzx	eax, byte ptr [esi]
	shr	eax, 4
	call	@@5
	stosd
	dec	ebx
	je	@@4a
	lodsb
	and	eax, 0Fh
	call	@@5
	stosd
	dec	ebx
	jne	@@4
@@4a:
	dec	[@@H]
	jne	@@1
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@5:	test	eax, eax
	jne	@@5a
	sub	[@@L1+4], 4
	jb	@@9
	mov	edx, [@@L1]
	mov	eax, [edx]
	add	edx, 4
	xor	eax, [@@L0]
	mov	[@@L1], edx
	mov	[@@L0], eax
	ret

@@5a:	mov	ecx, [@@W]
	add	eax, [@@SB]
	add	ecx, 3
	shr	ecx, 2
	movsx	edx, byte ptr [eax+70h]
	movsx	eax, byte ptr [eax+60h]
	imul	edx, ecx
	add	edx, eax
	neg	edx
	shl	edx, 2
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	mov	eax, [edi+edx]
	ret
ENDP

ENDP
