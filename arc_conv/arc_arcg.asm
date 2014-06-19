
; "Kuro to Kin no Hirakanai Kagi" *.arc, *.bmx, *.vpk

	dw _conv_arcg-$-2
_arc_arcg PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M, 10h
@M0 @@D
@M0 @@P

	enter	@@stk+20h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 20h
	jc	@@9a
	pop	eax
	pop	edx
	sub	eax, 'GCRA'
	sub	edx, 10000h
	or	eax, edx
	jne	@@9a
	pop	edi
	pop	ebx
	call	_FileSeek, [@@S], edi, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	sub	edi, esi
	mov	[@@P], edi
	call	@@5
	lea	eax, [ecx-1]
	shr	eax, 14h
	jne	@@9
	call	_ArcCount, ecx

	sub	esp, 200h
	push	esi
@@2:	pop	esi
	mov	edi, esp
	movzx	ecx, byte ptr [esi]
	inc	esi
	dec	ecx
	js	@@9
	; ecx != 0
@@2a:	cmp	byte ptr [esi], 0
	je	@@2b
	movsb
	dec	ecx
	jne	@@2a
@@2b:	lea	esi, [esi+ecx+8]
	cmp	edi, esp
	je	@@2c
	mov	al, 2Fh
	stosb
@@2c:	push	esi
	mov	esi, [esi-8]
	sub	esi, [@@P]
@@1:	movzx	ecx, byte ptr [esi]
	inc	esi
	dec	ecx
	js	@@2
	lea	edx, [esp+4]
	push	edi
	rep	movsb
	xchg	eax, ecx
	stosb
	pop	edi
	call	_ArcName, edx, -1
	and	[@@D], 0
	lodsd
	xchg	edx, eax
	lodsd
	xchg	ebx, eax
	call	_FileSeek, [@@S], edx, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jnc	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5:	mov	edx, esi
	mov	edi, esi
	call	@@5b
	xor	ecx, ecx
@@5a:	movzx	eax, byte ptr [edi]
	lea	edi, [edi+eax+8]
	test	eax, eax
	je	@@5d
	mov	eax, [edi-8]
	sub	eax, [@@P]
	cmp	eax, edx
	jne	@@5c
	call	@@5b
	jmp	@@5a

@@5b:	sub	ebx, 4
	jb	@@5c
	movzx	eax, byte ptr [edx]
	add	edx, 4
	test	al, 3
	jne	@@5c
	test	eax, eax
	je	@@5d
	add	eax, 8-4
	inc	ecx
	add	edx, eax
	sub	ebx, eax
	jae	@@5b
@@5c:	pop	ecx
	xor	ecx, ecx
@@5d:	ret

ENDP

; "Kuro to Kin no Hirakanai Kagi" *.wsm

	dw _conv_arcg-$-2
_arc_wsm4 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+40h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 40h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ecx
	sub	eax, '4MSW'
	sub	ecx, 40h
	or	eax, ecx
	jne	@@9a
	pop	ebx
	pop	edi
	lea	ecx, [ebx-1]
	mov	[@@N], ebx
	shr	ecx, 14h
	jne	@@9a
	sub	edi, 40h
	imul	ebx, 1A8h
	cmp	edi, ebx
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	lea	edx, [esi+4]
	call	_ArcName, edx, 40h
	and	[@@D], 0
	lea	edx, [esi+0D4h]
	mov	ebx, [edx+4]
	call	_FileSeek, [@@S], dword ptr [edx], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 1A8h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_arcg PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-10h]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'fbm'
	je	@@3
	test	eax, eax
	jne	@@1
	cmp	ebx, 0Ch
	jb	@@9
	mov	eax, [esi]
	mov	edx, [esi+4]
	sub	eax, 'SggO'
	sub	dh, 2
	or	eax, edx
	mov	eax, 'ggo'
	je	@@7
	mov	edx, 'EVAW'
	mov	eax, [esi]
	sub	edx, [esi+8]
	sub	eax, 'FFIR'
	or	eax, edx
	jne	@@1
	mov	eax, 'vaw'
@@7:	call	_ArcSetExt, eax
@@9:	stc
	leave
	ret

@@1:	cmp	ebx, 36h
	jb	@@9
	cmp	word ptr [esi], 'CB'
	jne	@@9
	call	@@2
	clc
	leave
	ret

@@3:	sub	ebx, 20h
	jb	@@9
	cmp	dword ptr [esi], '0FBM'
	jne	@@9
	mov	eax, [esi+4]
	mov	ecx, [esi+8]
	test	eax, eax
	je	@@9
	lea	edx, [esi+20h]
	add	esi, ecx
	sub	ecx, 20h
	jb	@@9
	push	eax	; @@L0
	push	ecx
	push	edx
	call	_ArcSetExt, 0
	push	edx	; @@L1
@@3a:	mov	edx, [@@L1+4]
	sub	[@@L1+8], 2
	jb	@@3b
	movzx	ecx, byte ptr [edx]
	inc	edx
	add	[@@L1+4], ecx
	sub	ecx, 2
	jbe	@@3b
	cmp	ecx, 7Fh
	ja	@@3b
	cmp	byte ptr [edx+ecx], 0
	jne	@@3b
	inc	edx
	call	_ArcNameFmt, [@@L1], edx
	db '\%s',0
	pop	ecx
	call	@@2
	test	ebx, ebx
	je	@@3b
	add	esi, [esi+2]
	dec	[@@L0]
	jne	@@3a
@@3b:	clc
	leave
	ret

@@2:	mov	ecx, [esi+2]
	cmp	ecx, ebx
	jb	$+4
	mov	ecx, ebx
	sub	ebx, ecx
	cmp	ecx, 36h
	jb	@@2e
	mov	eax, [esi+0Ah]
	cmp	dword ptr [esi+0Eh], 28h
	jb	@@2e
	lea	edx, [eax+8]
	sub	eax, 36h
	cmp	eax, 400h
	ja	@@2e
	sub	ecx, edx
	jb	@@2e
	add	edx, esi
	cmp	dword ptr [edx-8], '40XT'
	jne	@@2e
	movzx	eax, word ptr [esi+1Ch]
	ror	eax, 3
	push	eax
	push	ecx
	push	edx
	movzx	edi, word ptr [edx-4]
	movzx	ecx, word ptr [edx-2]
	mov	eax, [esi+0Ah]
	imul	edi, ecx
	add	eax, edi
	call	_MemAlloc, eax
	xchg	edi, eax
	jc	@@2d
	mov	edx, edi
	mov	ecx, [esi+0Ah]
	push	esi
	rep	movsb
	pop	esi
	push	eax
	push	edi
	mov	edi, edx
	call	@@Unpack
	add	eax, [esi+0Ah]
	mov	word ptr [edi], 'MB'
	mov	[edi+2], eax
	and	dword ptr [edi+1Eh], 0
	push	eax
	call	_ArcSetExt, 'pmb'
	call	_ArcData, edi
	call	_MemFree, edi
@@2e:	ret

@@2d:	add	esp, 0Ch
	ret

@@Unpack PROC	; blackgold.exe 0043511C 0043E478

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@A = dword ptr [ebp+24h]

@@W = dword ptr [ebp-4]
@@H = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	push	2
	movzx	edx, word ptr [esi-4]
	movzx	eax, word ptr [esi-2]
	pop	ecx
	push	edx		; @@W
	push	eax		; @@H
	jmp	@@2a

@@1:	cmp	[@@DC], 0
	je	@@7
	dec	[@@SC]
	js	@@9
	xor	eax, eax
	lodsb
	cmp	al, 0E0h	; E0 FF
	jb	@@1a
	add	al, 21h
	xchg	ecx, eax
@@2a:	sub	[@@SC], ecx
	jb	@@9
	sub	[@@DC], ecx
	jb	@@9
	rep	movsb
	jmp	@@1

@@7:	xor	esi, esi
@@9:	mov	ebx, [@@A]
	mov	edx, [@@W]
	lea	eax, [ebx-3]
	shr	eax, 1
	jne	@@9a
	sub	edx, ebx
	jb	@@9a
	push	esi
	call	@@5
	pop	esi
@@9a:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h

@@1a:	cmp	al, 0C0h	; C0 DF
	jb	@@1c
	sub	[@@SC], 2
	jb	@@9
	and	al, 1Fh
	movzx	edx, byte ptr [esi]	; always 0
	inc	esi
	shl	edx, 5
	movzx	ecx, byte ptr [esi]
	inc	esi
	add	edx, eax
@@1b:	sub	[@@DC], ecx
	jb	@@9
	not	edx
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@1c:	cmp	al, 40h		; 00 3F
	jae	@@1e
	mov	edx, eax
	and	al, 7
	shr	edx, 3
	cmp	al, 7
@@1d:	lea	ecx, [eax+2]
	jne	@@1b
	dec	[@@SC]
	js	@@9
	lodsb
	xchg	ecx, eax
	jmp	@@1b

@@1e:	mov	edx, [@@W]
	test	al, al		; 40 7F
	jns	$+4
	shl	edx, 1		; 80 BF
	mov	ecx, eax
	and	al, 3
	shr	ecx, 2
	add	edx, 7
	and	ecx, 0Fh
	sub	edx, ecx
	cmp	al, 3
	jmp	@@1d

@@5:	mov	esi, [@@DB]
	neg	ebx
	cmp	[@@H], 0
	je	@@5c
@@5a:	mov	ecx, edx
	sub	esi, ebx
@@5b:	mov	al, [esi+ebx]
	add	[esi], al
	inc	esi
	dec	ecx
	jne	@@5b
	dec	[@@H]
	jne	@@5a
@@5c:	ret
ENDP

ENDP
