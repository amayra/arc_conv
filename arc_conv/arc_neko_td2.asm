
; "Tiny Dungeon 2", "Tiny Dungeon 3" *.dat
; TD3trial.exe

; 'NEKOPACK', 'OKENOA_SYSTEM'

	dw _conv_neko_td2-$-2
_arc_neko_td2 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L1, 0Ch
@M0 @@SC
@M0 @@L0, 14h

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	sub	eax, 'OKEN'
	sub	edx, 'KCAP'
	or	eax, edx
	jne	@@9a
	pop	eax
	mov	[@@L1], eax
	cmp	eax, 24315C66h
	je	@@2a
	call	_ArcParam
	db 'fmt', 0
	jc	@@9a
@@2a:
	call	@@4
	mov	esi, [@@D]
	mov	[@@M], esi
	jc	@@9
	call	_ArcDbgData, esi, ebx
	shr	ebx, 3
	mov	[@@SC], ebx
	lea	eax, [ebx-1]
	shr	eax, 14h
	jne	@@9
	call	_ArcCount, ebx

@@2:	dec	[@@SC]
	js	@@9
	call	_ArcSkip, 1
	lodsd
	lea	edx, [@@L0]
	call	_hex32_upper, eax, edx
	mov	byte ptr [@@L0+8], '/'
	lodsd
	test	eax, eax
	je	@@2
	mov	[@@N], eax
@@1:	dec	[@@SC]
	js	@@9
	lea	edx, [@@L0+9]
	call	_hex32_upper, dword ptr [esi], edx
	lea	edx, [@@L0]
	call	_ArcName, edx, -1
	call	@@4
	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
	cmp	ebx, [@@L1+8]
	jne	@@9
	cmp	ebx, [esi+4]
	jne	@@9
@@8:	add	esi, 8
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
	jmp	@@2

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@4:	lea	edx, [@@L1+4]
	and	[@@D], 0
	call	_FileRead, [@@S], edx, 8
	jc	@@4a
	mov	ebx, [@@L1+8]
	call	@@Check, [@@L1], ebx
	sub	eax, [@@L1+4]
	neg	eax
	jc	@@4a
	mov	ecx, ebx
	neg	ecx
	and	ecx, 7
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, ecx
	xchg	ebx, eax
	call	@@Decrypt, [@@L1+4], [@@D], ebx
	cmp	ebx, [@@L1+8]
@@4a:	ret

@@Check PROC	; 004ABFCC
	mov	eax, [esp+4]
	mov	edx, [esp+8]
	xor	eax, edx
	add	eax, 05D588B65h
	xor	eax, edx
	add	eax, 0CA62C1D6h
	mov	ecx, eax
	xor	eax, edx
	add	eax, 08F1BBCDCh
	shr	ecx, 1Bh
	xor	eax, edx
	add	eax, 06C078965h
	rol	eax, cl
	ret	8
ENDP

@@Decrypt PROC	; 004AC05C, 004AC090
	push	ebp
	mov	ebp, esp
	mov	eax, [ebp+8]
	mov	edx, eax
	add	eax, 05D588B65h
	xor	eax, edx
	add	edx, 0CA62C1D6h
	xor	edx, eax
	add	eax, 08F1BBCDCh
	xor	eax, edx
	add	edx, 06C078965h
	xor	edx, eax
	push	edx
	push	eax
	mov	ecx, [ebp+10h]
	mov	edx, [ebp+0Ch]
	add	ecx, 7
	shr	ecx, 3
	je	@@9
	movq	mm1, [ebp-8]
@@1:	movq	mm0, [edx]
	pxor	mm0, mm1
	paddw	mm1, mm0
	movq	[edx], mm0
	add	edx, 8
	dec	ecx
	jne	@@1
@@9:	emms
	leave
	ret	0Ch
ENDP

ENDP

_conv_neko_td2 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	test	eax, eax
	jne	@@9
	cmp	ebx, 8
	jb	@@9
	mov	ecx, 'ggo'
	mov	eax, [esi]
	mov	edx, [esi+4]
	sub	eax, 'SggO'
	sub	dh, 2
	or	eax, edx
	je	@@8
	mov	edx, 0A1A0A0Dh
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, 474E5089h
	or	eax, edx
	jne	@@9
	call	_ArcPngName, esi, ebx
	mov	ecx, 'gnp'
@@8:	call	_ArcSetExt, ecx
@@9:	stc
	leave
	ret
ENDP
