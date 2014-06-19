
; "Figu@Carnival", "Figu@Prister" *.bin

; figucan.exe
; 00438BC0 open_archive
; 004388C0 open_packed

; FiguatPrister.exe
; 0043FE50 open_archive
; 0043F6D0 open_packed

; "Escu:de"

	dw _conv_escude-$-2
_arc_escude PROC

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
	pop	eax
	pop	edx
	pop	edi
	cmp	eax, '-CSE'
	jne	@@9
	sub	edx, '1CRA'
	mov	esi, esp
	bswap	edx
	lea	ecx, [edx+1]
	mov	ebx, edx
	shr	edx, 1
	jne	@@9a
	call	_escude_crypt, edi, ecx, esp
	xchg	edi, eax
	pop	ecx
	lea	eax, [ecx-1]
	mov	[@@N], ecx
	shr	eax, 14h
	jne	@@9a
	test	ebx, ebx
	je	_mod_escude_arc1
	pop	ebx
	imul	ecx, 0Ch
	mov	[@@L0+4], ebx
	add	ebx, ecx
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	ecx, [@@N]
	mov	esi, [@@M]
	lea	ecx, [ecx*2+ecx]
	lea	edx, [esi+ecx*4]
	mov	[@@L0], edx
	call	_escude_crypt, edi, ecx, esi
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	mov	ecx, [@@L0+4]
	mov	eax, [esi]
	sub	ecx, eax
	jbe	@@8
	add	eax, [@@L0]
	call	_ArcName, eax, ecx
	and	[@@D], 0
	mov	ebx, [esi+8]
	call	_FileSeek, [@@S], dword ptr [esi+4], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 0Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_mod_escude_arc1 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	imul	ebx, ecx, 88h
	lea	ecx, [ebx-4]
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 4, ecx, 0
	jc	@@9
	mov	ecx, ebx
	mov	esi, [@@M]
	pop	dword ptr [esi]
	shr	ecx, 2
	call	_escude_crypt, edi, ecx, esi
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	mov	edi, 80h
	call	_ArcName, esi, edi
	add	esi, edi
	and	[@@D], 0
	mov	ebx, [esi+4]
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 8
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

	dw _conv_escude-$-2
_arc_escude_acpx PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	pop	eax
	pop	edx
	pop	ecx
	sub	eax, 'XPCA'
	sub	edx, '10KP'
	or	eax, edx
	jne	@@9
	lea	eax, [ecx-1]
	mov	[@@N], ecx
	shr	eax, 14h
	jne	@@9a
	imul	ebx, ecx, 28h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 20h
	and	[@@D], 0
	mov	ebx, [esi+24h]
	call	_FileSeek, [@@S], dword ptr [esi+20h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 28h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_escude PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 8
	jb	@@9
	cmp	dword ptr [esi], 'pca'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	mov	edi, [esi+4]
	bswap	edi
	add	esi, 8
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	call	@@Unpack, edi, eax, esi, ebx
	xchg	ebx, eax
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

@@Unpack PROC	; lzw

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@M = dword ptr [ebp-4]
@@L0 = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	xor	ebx, ebx
	call	_MemAlloc, 8C00h*4	; 88CFh-1
	jc	@@9a
	push	eax
@@2:	push	800000h		; 32-9
	mov	edx, 102h
@@1:	mov	eax, [@@L0]
@@2a:	shl	bl, 1
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@1a:	adc	eax, eax
	jnc	@@2a
	cmp	ah, 1
	jne	@@1b
	cmp	al, 2
	ja	@@1b
	pop	ecx
	je	@@2
	test	al, al
	je	@@7
	shr	ecx, 1
	test	ch, ch
	jne	@@9
	push	ecx
	jmp	@@1

@@1b:	inc	edx
	mov	ecx, [@@M]
	cmp	edx, 8C00h	; max = 0x7FFF
	jae	@@9
	mov	[ecx+edx*4], edi
	test	ah, ah
	jne	@@1c
	dec	[@@DC]
	js	@@9
	stosb
	jmp	@@1

@@1c:	cmp	eax, edx
	jae	@@9
	lea	ecx, [ecx+eax*4]
	mov	eax, [ecx]
	mov	ecx, [ecx+4]
	sub	ecx, eax
	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@7:	mov	esi, [@@DC]
@@9:	call	_MemFree, [@@M]
@@9a:	xchg	eax, edi
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
