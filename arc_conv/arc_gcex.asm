
; "Princess Maker 4" data, gd, script
; PrincessMaker4.exe
; 004C4E70 unpack
; 0046A6B0 string_decode
; 0047B0DC vm_table

	dw _conv_gcex-$-2
_arc_gcex PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC
@M0 @@L0

	enter	@@stk+30h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ebx
	pop	ecx
	sub	eax, 'XECG'
	or	edx, ecx
	or	eax, edx
	jne	@@9a
	call	_FileSeek, [@@S], ebx, 0
	jc	@@9a
	mov	esi, esp
	call	_FileRead, [@@S], esi, 20h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ebx
	pop	ecx
	and	edx, NOT 10h
	sub	eax, '3ECG'
	or	edx, ecx
	or	eax, edx
	jne	@@9a
	pop	ecx
	pop	ecx
	pop	edi
	pop	ecx
	sub	ebx, 20h
	jbe	@@9a
	lea	ecx, [edi-1]
	imul	eax, edi, 22h
	shr	ecx, 14h
	jne	@@9a
	cmp	ebx, eax
	jb	@@9a
	mov	[@@N], edi
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, edi
	shl	edi, 5
	sub	ebx, edi
	add	edi, esi
	mov	[@@SC], ebx
	mov	[@@L0], edi
	call	_FileSeek, [@@S], 10h, 0
	jc	@@9a

@@1:	mov	ecx, [@@SC]
	mov	edx, [@@L0]
	sub	ecx, 2
	jb	@@9
	movzx	ebx, word ptr [edx]
	inc	edx
	inc	edx
	sub	ecx, ebx
	jb	@@9
	lea	eax, [edx+ebx]
	mov	[@@SC], ecx
	mov	[@@L0], eax
	cmp	dword ptr [esi+4], 10h		; 0x10 - directory, 0x20 - file
	je	@@8
	call	_ArcName, edx, ebx
	and	[@@D], 0
	mov	ebx, [esi+10h]
	mov	eax, [esi+14h]
	mov	ecx, [esi+18h]
	or	eax, [esi+1Ch]
	jne	@@9
	lea	eax, [@@D]
	cmp	ebx, ecx
	jne	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
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

@@2a:	call	_ArcMemRead, eax, ebx, ecx, 40000h
	call	@@Unpack, [@@D], ebx, edx, eax
	jmp	@@1b

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L2 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]
@@L0 = dword ptr [ebp-0Ch]
@@M = dword ptr [ebp-10h]

	push	ebx
	push	esi
	push	edi
	enter	0Ch, 0
	mov	edi, [@@DB]
	mov	edx, [@@SC]
	mov	esi, [@@SB]
	add	edx, esi
	push	edx		; @@M
@@8a:	cmp	[@@DC], 0
	je	@@7
	sub	[@@SC], 8
	jb	@@9
	mov	eax, [esi]
	mov	ecx, [esi+4]
	sub	[@@DC], ecx
	jb	@@9
	cmp	eax, '0ECG'
	jne	@@8b
	add	esi, 8
	sub	[@@SC], ecx
	jb	@@9
	rep	movsb
	jmp	@@8a

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

@@8b:	cmp	eax, '1ECG'
	jne	@@9
	sub	[@@SC], 10h
	jb	@@9
	mov	eax, [esi+0Ch]
	add	edx, esi
	sub	[@@SC], eax
	jb	@@9
	; TODO: check [esi+14h]
	add	esi, 18h
	mov	[@@L2], ecx
	mov	[@@L1], eax
	mov	[@@L0], esi
	add	esi, eax
	push	edi
	mov	edi, [@@M]
	mov	ecx, 10000h
	xor	eax, eax
	cdq			; edx = 0
	rep	stosd
	pop	edi
	xchg	ebx, eax
@@1:	cmp	[@@L2], 0
	je	@@8a
	call	@@4
	xchg	ecx, eax
	test	ecx, ecx
	je	@@1b
	push	esi
	push	ebx
	mov	ebx, [@@M]
	mov	esi, [@@L0]
	sub	[@@L1], ecx
	jb	@@9
	call	@@2
	mov	[@@L0], esi
	pop	ebx
	pop	esi
@@1b:	cmp	[@@L2], 0
	je	@@8a
	call	@@4
	xchg	ecx, eax
	inc	ecx
	push	esi
	push	ebx
	mov	ebx, [@@M]
	mov	eax, [ebx+edx*4]
	test	eax, eax
	je	@@9
	xchg	esi, eax
	call	@@2
	pop	ebx
	pop	esi
	jmp	@@1

@@2:	sub	[@@L2], ecx
	jb	@@9
@@2a:	lodsb
	mov	[ebx+edx*4], edi
	mov	dh, dl
	stosb
	mov	dl, al
	dec	ecx
	jne	@@2a
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
	xor	eax, eax
@@4a:	inc	ecx
	cmp	ecx, 21h
	jae	@@4b
	call	@@3
	jnc	@@4a
@@4b:	dec	ecx
	je	@@5a
	inc	eax
	dec	ecx
	je	@@5a
@@5:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@5
@@5a:	ret
ENDP

ENDP

_conv_gcex PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'bgra'
	jne	@@9
	sub	ebx, 10h
	jb	@@9
	mov	edx, 8080808h
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, 'ARGB'
	or	eax, edx
	jne	@@9
	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	mov	eax, edi
	imul	eax, edx
	ror	ebx, 2
	cmp	ebx, eax
	jne	@@9
	call	_ArcTgaAlloc, 23h, edi, edx
	xchg	edi, eax
	add	esi, 10h
	mov	ecx, ebx
	add	edi, 12h
	rep	movsd
	clc
	leave
	ret

@@9:	stc
	leave
	ret
ENDP
