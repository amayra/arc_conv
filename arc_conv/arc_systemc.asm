
; "Muriyari!? Otome DAYS" *.fpk
; otomedays.exe
; "SystemC"
; 00452FF0 open_archive

	dw _conv_systemc-$-2
_arc_systemc PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 0Ch

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	mov	ecx, 0FFFFFFh
	lodsd
	and	ecx, eax
	shr	eax, 18h
	mov	[@@N], ecx
	mov	[@@L0+8], eax
	cmp	al, 80h
	jne	@@9a
	imul	ebx, ecx, 24h
	dec	ecx
	shr	ecx, 14h
	jne	@@9a
	call	_FileSeek, [@@S], -8, 2
	jc	@@9a
	lea	esi, [@@L0]
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	call	_FileSeek, [@@S], [@@L0+4], 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	eax, [@@L0]
	mov	ecx, ebx
	mov	edx, esi
	shr	ecx, 2
@@2a:	xor	[edx], eax
	add	edx, 4
	dec	ecx
	jne	@@2a
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	lea	edx, [esi+8]
	call	_ArcName, edx, 18h
	and	[@@D], 0
	mov	ebx, [esi+4]
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	cmp	ebx, 8
	jb	@@1b
	mov	edi, [@@D]
	cmp	dword ptr [edi], '2CLZ'
	jne	@@1b
	call	_MemAlloc, dword ptr [edi+4]
	jc	@@1b
	mov	[@@D], eax
	sub	ebx, 8
	lea	edx, [edi+8]
	call	@@Unpack, eax, dword ptr [edi+4], edx, ebx
	xchg	ebx, eax
	call	_MemFree, edi

@@1b:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 24h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

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
@@1:	dec	[@@DC]
	js	@@7
	shl	bl, 1
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@1a:	jc	@@1b
	dec	[@@SC]
	js	@@9
	movsb
	jmp	@@1

@@1b:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
	mov	cl, dh
	shr	dh, 4
	and	ecx, 0Fh
	neg	edx
	add	ecx, 2
	or	edx, -1000h
	sub	[@@DC], ecx
	jae	@@1c
	add	ecx, [@@DC]
@@1c:	inc	ecx
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@7:	mov	esi, [@@DC]
	inc	esi
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

_conv_systemc PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'gk'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 0Ch
	jb	@@9
	cmp	dword ptr [esi], 'KGCG'
	jne	@@9
	movzx	eax, word ptr [esi+6]
	shl	eax, 2
	sub	ebx, eax
	jb	@@9
	movzx	edi, word ptr [esi+4]
	movzx	edx, word ptr [esi+6]
	call	_ArcTgaAlloc, 23h, edi, edx
	lea	edi, [eax+12h]
	call	@@KGUnpack, edi, 0, esi, ebx
	clc
	leave
	ret

@@KGUnpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@H = dword ptr [ebp-4]
@@W = dword ptr [ebp-8]
@@X = dword ptr [ebp-0Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	movzx	edx, word ptr [esi+6]
	movzx	eax, word ptr [esi+4]
	push	edx
	lea	esi, [esi+0Ch+edx*4]
	push	eax
	push	esi
@@1:	mov	eax, [@@SB]
	mov	ebx, [@@SC]
	mov	esi, [eax+0Ch]
	add	eax, 4
	mov	edx, [@@W]
	sub	ebx, esi
	mov	[@@SB], eax
	jb	@@7
	add	esi, [@@X]

@@2:	sub	ebx, 2
	jb	@@7
	lodsb
	movzx	ecx, byte ptr [esi]
	inc	esi
	dec	cl
	inc	ecx
	test	al, al
	jne	@@2a
	sub	edx, ecx
	jae	$+6
	add	ecx, edx
	xor	edx, edx
	xor	eax, eax
	rep	stosd
	jmp	@@5

@@2a:	mov	[@@DC], eax
@@2b:	sub	ebx, 3
	jb	@@7
	mov	eax, [esi-1]
	add	esi, 3
	mov	al, byte ptr [@@DC]
	bswap	eax
	stosd
	dec	edx
	je	@@7
	dec	ecx
	jne	@@2b
@@5:	test	edx, edx
	jne	@@2

@@7:	mov	ecx, edx
	xor	eax, eax
	rep	stosd
	dec	[@@H]
	jne	@@1
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

ENDP
