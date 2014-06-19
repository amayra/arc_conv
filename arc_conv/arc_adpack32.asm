
; "Hinata Bokko" *.pak
; HinataBokko.exe
; 0042FF60 ed8_check
; 0042BDD0 ed8_open
; 0042BE70 ed8_unpack
; 00435370 edt_check
; 004354A0 edt_open
; 00435970 edt_unpack

	dw _conv_adpack32-$-2
_arc_adpack32 PROC

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
	pop	edx
	sub	eax, 'APDA'
	sub	ecx, '23KC'
	sub	edx, 10000h
	or	eax, ecx
	pop	ebx
	or	eax, edx
	jne	@@9a
	lea	eax, [ebx-1]
	mov	[@@N], eax
	dec	eax
	shr	eax, 14h
	jne	@@9
	shl	ebx, 5
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 1Ah
	mov	eax, [esi+1Ch]
	mov	ebx, [esi+3Ch]
	and	[@@D], 0
	sub	ebx, eax
	jb	@@9
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 20h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_adpack32 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, '8de'
	je	@@1
	cmp	eax, 'las'
	je	@@1
	cmp	eax, 'tde'
	je	@@2
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 1Ah
	jb	@@9
	mov	eax, 6942382Eh
	mov	edx, 8C5D8D74h
	movzx	ecx, word ptr [esi+8]
	sub	eax, [esi]
	sub	edx, [esi+4]
	sub	cl, 0CBh
	or	eax, edx
	or	eax, ecx
	jne	@@9
	mov	ecx, [esi+12h]
	lea	eax, [ecx*2+ecx]
	dec	ecx
	sub	ebx, eax
	jb	@@9
	shr	ecx, 8
	jne	@@9
	cmp	ebx, [esi+16h]
	jne	@@9
	movzx	edi, word ptr [esi+0Eh]
	movzx	edx, word ptr [esi+10h]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 30h, edi, edx
	xchg	edi, eax
	mov	ecx, [esi+12h]
	movzx	eax, word ptr [edi+0Ch]
	mov	[edi+5], cx
	add	edi, 12h
	lea	ecx, [ecx*2+ecx]
	mov	edx, [esi+16h]
	add	esi, 1Ah
	rep	movsb
	call	@@UnpackED8, edi, ebx, esi, edx, eax
	clc
	leave
	ret

@@2:	sub	ebx, 22h
	jb	@@9
	mov	eax, 5552542Eh
	mov	edx, 8C5D8D45h
	movzx	ecx, word ptr [esi+8]
	sub	eax, [esi]
	sub	edx, [esi+4]
	sub	cl, 0CBh
	or	eax, edx
	or	eax, ecx
	jne	@@9
	sub	ebx, [esi+1Ah]
	jb	@@9
	mov	ecx, [esi+1Eh]
	mov	eax, 0AAAAAAABh
	mul	ecx
	shr	edx, 1
	je	@@9
	lea	edx, [edx*2+edx]
	cmp	ecx, edx
	jne	@@9
	sub	ebx, ecx
	jb	@@9
	mov	eax, [esi+16h]
	test	eax, eax
	je	@@2a
	; 0x00 ".EDT_DIFF", 0
	; 0x0A color_mask
	; 0x0E name (size = 0x40)
	cmp	eax, 4Eh
	jne	@@9
@@2a:	cmp	ebx, eax
	jne	@@9
	movzx	edi, word ptr [esi+0Eh]
	movzx	edx, word ptr [esi+10h]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 22h, edi, edx
	xchg	edi, eax
	movzx	eax, word ptr [edi+0Ch]
	add	edi, 12h
	mov	edx, [esi+16h]
	lea	edx, [esi+edx+22h]
	call	@@UnpackEDT, edi, ebx, edx, dword ptr [esi+1Ah], eax, dword ptr [esi+1Eh]
	clc
	leave
	ret

@@UnpackED8 PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
@@1a:	dec	[@@DC]
	js	@@9
	push	8
	pop	ecx
	call	@@5
	stosb
@@1:	cmp	[@@DC], 0
	je	@@7
	call	@@3
	jc	@@1a
	or	edx, -1
	; 0042BF50
@@1b:	xor	eax, eax
	call	@@3
	jnc	@@1d
	call	@@3
	jnc	@@1c
	call	@@3
	adc	eax, eax
	inc	eax
@@1c:	call	@@3
	adc	eax, eax
	inc	eax
@@1d:	call	@@3
	adc	eax, eax
	; eax < 0xE
	cmp	eax, edx
	je	@@1a
	xchg	edx, eax
	call	@@4
	cmp	edx, 2
	sbb	eax, -1
	xchg	ecx, eax
	sub	[@@DC], ecx
	jb	@@9
	push	edx
	movsx	edx, [@@T+edx]
	mov	eax, edx
	sar	edx, 4
	and	eax, 0Fh
	imul	eax, [@@L0]
	sub	edx, eax
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
	pop	edx
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	cmp	[@@DC], 0
	jne	@@1b
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

@@3:	shr	ebx, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@3a:	ret

@@4:	xor	ecx, ecx
	xor	eax, eax
@@4a:	cmp	ecx, 20h
	jae	@@9
	inc	ecx
	call	@@3
	jc	@@4a
	inc	eax
	dec	ecx
	je	@@5a
@@5:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@5
@@5a:	ret

@@T	db 0F0h,001h,0E0h,0F1h,011h,002h
	db 0E1h,021h,0E2h,0F2h,012h,022h
	db 003h,0F3h
ENDP

@@UnpackEDT PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]
@@L1 = dword ptr [ebp+28h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	edx, [@@L0]
	add	esp, -80h
	lea	ebx, [edx*2+edx]
	imul	edx, -0Ch
	mov	edi, esp
@@2a:	lea	eax, [edx-9]
	push	7
	pop	ecx
@@2b:	stosd
	add	eax, 3
	dec	ecx
	jne	@@2b
	add	edx, ebx
	jne	@@2a
	lea	eax, [ecx-0Ch]
@@2c:	stosd
	add	eax, 3
	jne	@@2c

	mov	eax, [@@SC]
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
	add	[@@SB], eax
@@1a:	dec	[@@DC]
	js	@@9
	mov	eax, [@@SB]
	sub	[@@L1], 3
	jb	@@9
	xchg	eax, esi
	movsb
	movsb
	movsb
	mov	[@@SB], esi
	xchg	esi, eax
@@1:	cmp	[@@DC], 0
	je	@@7
	call	@@3
	jnc	@@1a
	call	@@3
	jc	@@1b
	; 004359D0
	xor	eax, eax
	lea	ecx, [eax+5]
	call	@@5
	mov	edx, [esp+eax*4]
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	call	@@4
	sub	[@@DC], eax
	jb	@@9
	lea	ecx, [eax+eax*2]
	xchg	eax, esi
	lea	esi, [edi+edx]
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@1b:	dec	[@@DC]
	push	3
	pop	edx
	lea	ecx, [edx-6]
	call	@@3
	jnc	@@1c
	; 00435B20
	xor	eax, eax
	lea	ecx, [eax+2]
	call	@@5
	mov	ecx, 11191718h		; 001h,0F1h,011h,002h
	shl	eax, 3
	xchg	ecx, eax
	shr	eax, cl
	movzx	eax, al
	mov	ecx, [esp+eax*4]
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, ecx
	jnc	@@9
	; 00435A40
@@1c:	mov	al, [edi+ecx]
	cmp	al, 2
	jae	$+4
	mov	al, 2
	cmp	al, 0FDh
	jb	$+4
	mov	al, 0FDh
	; 00435AF0
	call	@@3
	jnc	@@1e
	mov	ah, 1
	call	@@3
	adc	ah, 0
	call	@@3
	jc	@@1d
	neg	ah
@@1d:	add	al, ah
@@1e:	stosb
	dec	edx
	jne	@@1c
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
	ret	18h

@@3:	shr	ebx, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@3a:	ret

@@4:	xor	ecx, ecx
	xor	eax, eax
@@4a:	cmp	ecx, 20h
	jae	@@9
	inc	ecx
	call	@@3
	jc	@@4a
	inc	eax
	dec	ecx
	je	@@5a
@@5:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@5
@@5a:	ret

if 0
@@T	db 0D4h,0E4h,0F4h,004h,014h,024h,034h	; 00
	db 0D3h,0E3h,0F3h,003h,013h,023h,033h	; 07
	db 0D2h,0E2h,0F2h,002h,012h,022h,032h	; 0E
	db 0D1h,0E1h,0F1h,001h,011h,021h,031h	; 15
	db 0C0h,0D0h,0E0h,0F0h			; 1C

	imul	edx, eax, 25h	; div 7
	shr	edx, 8
	imul	ecx, edx, 7
	sub	eax, ecx
	cmp	edx, 4
	adc	eax, -4
	imul	edx, [@@W]
	sub	eax, edx
endif
ENDP

ENDP