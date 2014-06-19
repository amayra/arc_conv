
; "Touhou 6 - The Embodiment of Scarlet Devil" *.dat

; 0043C790 open_archive
; 0043C510 00 bits(1)
; 0043C570 04 bits(n)
; 0043C610 0C seek

	dw 0
_arc_pbg3 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1
@M0 @@L2

@@C0 = 200h

	enter	@@stk+@@C0+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Dh
	jc	@@9a
	lea	ecx, [eax-4]
	pop	eax
	cmp	eax, '3GBP'
	jne	@@9a
	and	[@@M], 0
	mov	[@@L1], ecx
	and	[@@L0], 0
	mov	[@@L2], esp
	call	@@4
	mov	ebx, eax
	dec	eax
	shr	eax, 14h
	jne	@@9a
	call	@@4
	push	eax
	and	[@@L0], 0
	mov	[@@L1], @@C0*10001h
	call	_FileSeek, [@@S], eax, 0
	jc	@@9a
	mov	[@@N], ebx
	imul	eax, ebx, 114h
	add	eax, 14h
	call	_MemAlloc, eax
	jc	@@9a
	mov	[@@M], eax
	xchg	edi, eax
@@2a:	call	@@4	; 04
	stosd
	call	@@4	; 00
	stosd
	call	@@4	; 10 packed checksum
	stosd
	call	@@4	; 0C offset
	stosd
	call	@@4	; 8 size
	stosd
	mov	edx, 100h
@@2b:	push	8
	pop	ecx
	call	@@5
	stosb
	dec	edx
	je	@@9a
	test	al, al
	jne	@@2b
	add	edi, edx
	dec	ebx
	jne	@@2a
	pop	dword ptr [edi+0Ch]
	lea	esp, [ebp-@@stk]
	mov	esi, [@@M]
	imul	ebx, [@@N], 114h
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	lea	edx, [esi+14h]
	call	_ArcName, edx, -1
	mov	edi, [esi+114h+0Ch]
	mov	eax, [esi+0Ch]
	mov	ebx, [esi+10h]
	and	[@@D], 0
	sub	edi, eax
	jbe	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, ebx, edi, 0
	call	_pbg_unpack, [@@D], ebx, edx, eax
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 114h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@4:	xor	ecx, ecx
	call	@@3
	adc	ecx, ecx
	call	@@3
	adc	ecx, ecx
	inc	ecx
	shl	ecx, 3
	xor	eax, eax
@@5:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@5
	ret

@@3b:	cmp	ecx, @@C0
	jne	@@9
	call	_FileRead, [@@S], edx, ecx
	mov	[@@L1], eax
	pop	edx
	pop	ecx
	pop	eax
@@3:	shl	byte ptr [@@L0], 1
	jne	@@3a
	push	eax
	push	ecx
	push	edx
	movzx	eax, word ptr [@@L1+2]
	movzx	ecx, word ptr [@@L1]
	mov	edx, [@@L2]
	cmp	eax, ecx
	jae	@@3b
	inc	word ptr [@@L1+2]
	movzx	eax, byte ptr [edx+eax]
	stc
	adc	al, al
	mov	[@@L0], eax
	pop	edx
	pop	ecx
	pop	eax
@@3a:	ret

_pbg_unpack PROC	; 0043CB40

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

	xor	ecx, ecx
	xor	ebx, ebx
@@1:	call	@@3
	jnc	@@1a
	add	ecx, 8
	call	@@5
	dec	[@@DC]
	js	@@9
	stosb
	jmp	@@1

@@1a:	add	ecx, 0Dh
	call	@@5
	test	eax, eax
	je	@@7
	xchg	edx, eax
	add	ecx, 4
	call	@@5
	lea	ecx, [eax+3]
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
	sub	edx, eax
	dec	edx
	or	edx, -2000h
	add	eax, edx
	jns	@@2b
@@2a:	mov	byte ptr [edi], 0
	inc	edi
	dec	ecx
	je	@@1
	inc	eax
	jne	@@2a
@@2b:	push	esi
	lea	esi, [edi+edx]
	rep	movsb
	pop	esi
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

@@3:	shl	bl, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@3a:	ret

@@5:	xor	eax, eax
@@5a:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@5a
	ret
ENDP

ENDP
