
; "Valkyrie Complex" Pack\*.pak

	dw _conv_vc_pak-$-2
_arc_vc_pak PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC
@M0 @@L0

	enter	@@stk+20h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 20h
	jc	@@9a
	mov	edi, offset @@sign
	push	6
	pop	ecx
	repe	cmpsd
	jne	@@9a
	mov	eax, 58585858h
	mov	ecx, [esi]
	mov	ebx, [esi+4]
	xor	ecx, eax
	xor	ebx, eax
	mov	[@@N], ecx
	imul	eax, ecx, 10h
	dec	ecx
	shr	ecx, 14h
	jne	@@9a
	mov	[@@L0], eax
	cmp	ebx, eax
	jb	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	ecx, ebx
	mov	edx, esi
@@2a:	xor	byte ptr [edx], 58h
	inc	edx
	dec	ecx
	jne	@@2a
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx
	sub	ebx, [@@L0]
	add	[@@L0], esi
	mov	[@@SC], ebx

@@1:	mov	ecx, [esi+4]
	mov	edi, [@@L0]
	cmp	ecx, 200h
	jae	@@9
	inc	ecx
	mov	edx, edi
	sub	[@@SC], ecx
	jb	@@9
	xor	eax, eax
	repne	scasb
	jne	@@9
	test	ecx, ecx
	jne	@@9
	mov	[@@L0], edi
	call	_ArcName, edx, -1
	and	[@@D], 0
	mov	ebx, [esi+0Ch]
	call	_FileSeek, [@@S], dword ptr [esi+8], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	test	ebx, ebx
	je	@@1a
	mov	edx, [@@D]
	mov	ecx, ebx
@@1b:	xor	byte ptr [edx], 24h
	inc	edx
	dec	ecx
	jne	@@1b
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 10h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@sign	db 082h,075h,082h,062h,090h,0BBh,095h,069h,094h,0C5h,0Eh dup(0)
ENDP

_conv_vc_pak PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'sc'
	je	@@4
	cmp	eax, 'spc'
	jne	@@9
	mov	ecx, ebx
	cmp	ebx, 8
	jb	@@9
	mov	eax, [esi]
	mov	ecx, eax
	xor	eax, 0A415FCFh
	shr	ecx, 1Ch
	and	eax, 0FFFFFFFh
	push	eax	; @@L0
	cmp	ecx, 2
	je	@@2
	cmp	ecx, 3
	je	@@1
@@9:	stc
	leave
	ret

@@4:	test	ebx, ebx
	je	@@9
@@4a:	dec	byte ptr [esi]
	inc	esi
	dec	ebx
	jne	@@4a
	jmp	@@9

@@1:	call	_MemAlloc, eax
	jc	@@9
	push	eax	; @@L1
	call	@@3
	mov	ebx, [@@SC]
	lodsd
	sub	ebx, 4
	call	@@Unpack3, [@@L1], [@@L0], esi, ebx
	pop	edi
	pop	ebx
	call	_ArcSetExt, 'pmb'
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

@@2:	call	_MemAlloc, eax
	jc	@@9
	push	eax	; @@L1
	call	@@3
	mov	ebx, [@@SC]
	lodsd
	sub	ebx, 4
	call	@@Unpack2, [@@L1], [@@L0], esi, ebx
	pop	edi
	pop	ebx
	call	_ArcSetExt, 'agt'
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

	; 0041A5E0 cps_decode
@@3:	cmp	ebx, 308h
	jb	@@3a
	mov	al, [esi+ebx-1]
	xor	[esi+4], al
	mov	edx, 0FFh
	sub	ebx, 8
	add	esi, 8
	mov	edi, ebx
	shr	edi, 9
	sub	ebx, edx
	lea	ecx, [edx+edi]
	mov	al, [esi+ecx]
	mov	ah, [esi+ebx]
	mov	[esi+ebx], al
	mov	[esi+ecx], ah
	sub	ebx, edx
	lea	ecx, [edx+edi*2]
	mov	al, [esi+ecx]
	mov	ah, [esi+ebx]
	mov	[esi+ebx], al
	mov	[esi+ecx], ah
	sub	esi, 8
@@3a:	ret

@@Unpack2 PROC

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
	sub	[@@SC], 22h
	jb	@@9
	mov	ecx, [@@DC]
	mov	al, [esi+20h]
	add	esi, 22h
	shr	ecx, 1
	mov	[@@DC], ecx
	jnc	@@1
	mov	[edi+ecx*2], al

@@1:	cmp	[@@DC], 0
	je	@@7
	call	@@3
	jnc	@@1c
	mov	eax, 10000h
@@1a:	call	@@3
	adc	eax, eax
	jnc	@@1a
@@1b:	stosw
	dec	[@@DC]
	jmp	@@1

@@1c:	xor	eax, eax
@@1d:	call	@@3
	jc	@@1e
	inc	eax
	cmp	eax, 0Fh
	jb	@@1d
@@1e:	mov	edx, [@@SB]
	movzx	eax, word ptr [edx+eax*2]
	jmp	@@1b

@@7:	xor	esi, esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@3:	shr	ebx, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@3a:	ret

ENDP

@@Unpack3 PROC

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

	mov	eax, 80h
	mov	ecx, [@@SC]
	cmp	ecx, eax
	jb	$+3
	xchg	ecx, eax
	sub	[@@SC], ecx
	sub	[@@DC], ecx
	jb	@@9
	rep	movsb

@@1:	cmp	[@@DC], 0
	je	@@7
	call	@@3
	jc	@@1a
	mov	cl, 8
	call	@@5
	stosb
	dec	[@@DC]
	jmp	@@1

@@1a:	mov	cl, 7
	call	@@5
	xchg	edx, eax
	mov	cl, 4
	call	@@5
	lea	ecx, [eax+2]
	not	edx
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
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

@@5:	xor	eax, eax
@@5a:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@5a
	ret

@@3:	shr	ebx, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@3a:	ret

ENDP

ENDP
