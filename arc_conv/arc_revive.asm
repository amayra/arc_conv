
; "Revive... Sosei" *.afs, *prs
; revive.exe 

; char00?.afs, event?.afs, flex.afs - packed
; scen?.afs, staff?.afs, title2.afs - not packed

	dw _conv_revive-$-2
_arc_revive PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	eax
	pop	ebx
	lea	ecx, [ebx-1]
	shr	ecx, 14h
	sub	eax, 'SFA'
	or	eax, ecx
	jne	@@9a
	mov	[@@N], ebx
	shl	ebx, 3
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	and	[@@D], 0
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

_conv_revive PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	call	@@Unpack, 0, -1, esi, ebx
	test	eax, eax
	je	@@9
	mov	[@@SC], eax
	call	_MemAlloc, eax
	jc	@@9
	xchg	esi, eax
	call	@@Unpack, esi, [@@SC], eax, ebx
	call	_ArcData, esi, [@@SC]
	call	_MemFree, esi
	clc
	leave
	ret

@@9:	stc
	leave
	ret

@@Unpack PROC	; 00413600

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
@@1:	cmp	[@@DC], 0
	je	@@7
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
	dec	[@@DC]
	lodsb
	cmp	[@@DB], 0
	je	@@2a
	mov	[edi], al
@@2a:	inc	edi
	jmp	@@1

@@1b:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
	mov	ecx, edx
	shr	dl, 4
	and	ecx, 0Fh
	xchg	dl, dh
	inc	ecx
	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
	or	edx, -1000h
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	cmp	[@@DB], 0
	je	@@2b
	push	esi
	lea	esi, [edi+edx]
	rep	movsb
	pop	esi
	jmp	@@1

@@2b:	add	edi, ecx
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
ENDP

ENDP

	dw _conv_gbix-$-2
_arc_gbix:
	ret
_conv_gbix PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	sub	ebx, 20h
	jb	@@9
	mov	eax, [esi]
	dec	eax
	cmp	eax, 10h
	jae	@@1a
	inc	eax
	inc	eax
	shl	eax, 2
	sub	ebx, eax
	jb	@@9
	add	esi, eax
@@1a:	mov	edx, 'TRVP'
	mov	eax, [esi]
	sub	edx, [esi+10h]
	sub	eax, 'XIBG'
	or	eax, edx
	je	@@1
@@9:	stc
	leave
	ret

@@1:	xchg	eax, ebx
	shr	eax, 1
	movzx	edi, word ptr [esi+1Ch]
	movzx	edx, word ptr [esi+1Eh]
	mov	ebx, edi
	imul	ebx, edx
	sub	eax, ebx
	jb	@@9
	mov	eax, [esi+18h]
	cmp	al, 3
	jae	@@9
	push	edx
	mov	edx, offset @@T
	movzx	ecx, al
	movsx	ecx, word ptr [edx+ecx*2]
	add	ecx, edx
	pop	edx
	push	ecx
	cmp	ah, 1
	je	@@1c
	; 9
	call	_ArcTgaAlloc, 23h, edi, edx
	xchg	edi, eax
	add	esi, 20h
	add	edi, 12h
@@1b:	call	[@@L0]
	dec	ebx
	jne	@@1b
	clc
	leave
	ret

@@1c:	lea	eax, [edi-1]
	mov	ecx, edi
	and	eax, edi
	sub	ecx, edx
	or	eax, ecx
	jne	@@9
	mov	ebx, edi
	call	_ArcTgaAlloc, 23h, edi, edx
	xchg	edi, eax
	add	esi, 20h
	add	edi, 12h
	call	@@2, edi, esi, ebx, [@@L0]
	clc
	leave
	ret

@@T	dw @@3a-@@T
	dw @@3b-@@T
	dw @@3c-@@T

	; 1555
@@3a:	movzx	eax, word ptr [esi]
	add	esi, 2
	ror	eax, 10
	shl	al, 3
	sbb	ah, ah
	rol	eax, 16
	shr	ax, 3
	shl	ah, 3
	mov	edx, 0E0E0E0E0h
	and	edx, eax
	shr	edx, 5
	or	eax, edx
	mov	[edi], eax
	add	edi, 4
	ret

	; 565
@@3b:	movzx	eax, word ptr [esi]
	add	esi, 2
	ror	eax, 5
	shr	ax, 1
	sbb	edx, edx
	shl	ax, 3
	and	edx, 40404h
	shl	ah, 3
	rol	eax, 8
	add	eax, edx
	mov	edx, 0C0C0C0C0h
	and	edx, eax
	shr	edx, 6
	add	eax, edx
	mov	[edi], eax
	add	edi, 4
	ret

	; 4444
@@3c:	movzx	eax, word ptr [esi]
	add	esi, 2
	ror	eax, 8
	shl	ax, 4
	shr	al, 4
	rol	eax, 10h
	shr	ax, 4
	shr	al, 4
	imul	eax, 11h
	mov	[edi], eax
	add	edi, 4
	ret

@@2 PROC	; Twiddle

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@W = dword ptr [ebp+1Ch]
@@L0 = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@S]
	mov	edi, [@@D]
	mov	ecx, [@@W]
	jmp	@@1

@@2:	call	[@@L0]
	cmp	esp, ebp
	je	@@9
	pop	ecx
	pop	edi
@@1:	shr	ecx, 1
	je	@@2
	mov	eax, ecx
	imul	eax, [@@W]
	lea	eax, [edi+eax*4]
	lea	ebx, [edi+ecx*4]
	lea	edx, [eax+ecx*4]
	push	edx
	push	ecx
	push	ebx
	push	ecx
	push	eax
	push	ecx
	jmp	@@1

@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

ENDP

if 0
	shr	eax, 1
	rcr	ecx, 1	; Y
	shr	eax, 1
	rcr	edx, 1	; X

	mov	ecx, 55555555h
	mov	eax, edx
	shr	edx, 1
	and	eax, ecx
	and	edx, ecx
	mov	ecx, 66666666h
	lea	eax, [eax*2+eax]
	lea	edx, [edx*2+edx]
	and	eax, ecx
	and	edx, ecx
	mov	ecx, 78787878h
	lea	eax, [eax*4+eax]
	lea	edx, [edx*4+edx]
	and	eax, ecx
	and	edx, ecx
	; ...
endif
