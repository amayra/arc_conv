
; "Shukufuku no Campanella" *.int
; cs2.exe
; 00584130 blowfish_set_key

	dw _conv_kif-$-2
_arc_kif PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1, 8

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	eax
	cmp	eax, 'FIK'
	jne	@@9a
	pop	ecx
	imul	ebx, ecx, 48h
	mov	[@@N], ecx
	dec	ecx
	shr	ecx, 14h
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	and	[@@L0], 0
	mov	esi, [@@M]
	mov	edi, offset @@sign
	push	3
	pop	ecx
	push	esi
	rep	cmpsd
	pop	esi
	jne	@@2a
	dec	[@@N]
	je	@@9
	call	@@ReadKey
	sbb	edx, edx
	mov	[@@L1], eax
	mov	[@@L1+4], edx

	; 0x4260E643 "CAMPANELLA" "Shukufuku no Campanella"
	; 0xA5A166AA "FW_MAKAI-TENSHI_DJIBRIL4" "Makai Tenshi Djibril -Episode 4-"

	call	@@3, dword ptr [esi+44h]
	lea	edx, [@@L0]
	sub	esp, 0FFCh
	push	ecx
	sub	esp, 48h
	mov	ebx, esp
	mov	[edx], eax
	call	_blowfish_set_key@12, ebx, edx, 4
	xor	ebx, ebx
	mov	edi, [@@N]
@@2:	add	esi, 48h
	inc	ebx
	mov	eax, [esi+40h]
	mov	edx, [esi+44h]
	add	eax, ebx
	mov	ecx, esp
	call	_blowfish_decrypt
	mov	[esi+40h], eax
	mov	[esi+44h], edx
	cmp	dword ptr [@@L1+4], 0
	jne	@@2b
	mov	eax, [@@L1]
	add	eax, ebx
	call	@@3, eax
	mov	edx, eax
	shr	eax, 10h
	add	dl, dh
	add	al, ah
	add	al, dl
	movzx	eax, al
	call	@@4
@@2b:	dec	edi
	jne	@@2
	mov	[@@L0], esp
	mov	esi, [@@M]
	add	esi, 48h
@@2a:	mov	ecx, [@@N]
	imul	ebx, ecx, 48h
	call	_ArcCount, ecx
	call	_ArcDbgData, esi, ebx

@@1:	and	[@@D], 0
	mov	ebx, [esi+44h]
	call	_FileSeek64, [@@S], dword ptr [esi+40h], 0, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	mov	ecx, [@@L0]
	test	ecx, ecx
	je	@@1a
	mov	edi, [@@D]
	call	@@Decode
	cmp	[@@L1+4], 0
	je	@@1a
	mov	edi, [@@D]
	call	@@5
	jc	@@1a
	call	@@4
@@1a:	call	_ArcName, esi, 40h
	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 48h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@Decode PROC
	push	ebx
	shr	ebx, 3
	je	@@2
@@1:	mov	eax, [edi]
	mov	edx, [edi+4]
	call	_blowfish_decrypt
	mov	[edi], eax
	mov	[edi+4], edx
	add	edi, 8
	dec	ebx
	jne	@@1
@@2:	pop	ebx
	ret
ENDP

@@3 PROC
	push	ebx
	push	esi
	push	edi
	enter	270h*4, 0
	mov	eax, [ebp+14h]
	call	_twister_init
	call	_twister_next
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP

@@5 PROC
	cmp	ebx, 4
	jb	@@9
	xor	ecx, ecx
@@1:	mov	al, [edi+ecx]
	or	al, 20h
	sub	al, 61h
	cmp	al, 1Ah
	jb	@@2
	inc	ecx
	cmp	ecx, 4
	jb	@@1
@@9:	stc
	ret

@@2:	add	al, 1Ah
	movzx	edi, al

	xor	edx, edx
@@2a:	mov	ecx, edx
@@2b:	mov	al, [esi+edx]
	inc	edx
	cmp	al, '.'
	je	@@2a
	test	al, al
	jne	@@2b
	movzx	eax, byte ptr [esi+ecx]
	test	ecx, ecx
	je	@@9
	mov	edx, eax
	or	al, 20h
	sub	al, 61h
	cmp	al, 1Ah
	jae	@@9
	and	edx, 20h
	je	$+4
	add	al, 1Ah
	not	al
	add	al, 34h
	add	ecx, edi
	mov	ah, 34h
	sub	eax, ecx
	clc
	ret
ENDP

@@4 PROC	; 004BDD50
	push	40h
	pop	ecx
	push	ebx
	push	esi
	cdq
	lea	ebx, [edx+34h]
	div	ebx
	mov	ebx, edx
@@1:	lodsb
	test	al, al
	je	@@9
	mov	edx, eax
	or	al, 20h
	sub	al, 61h
	cmp	al, 1Ah
	jae	@@2
	and	edx, 20h
	je	$+4
	add	al, 1Ah
	not	al
	add	al, 34h
	sub	al, bl
	jae	$+4
	add	al, 34h
	cmp	al, 1Ah
	jb	$+4
	add	al, 6
	add	al, 41h
	mov	[esi-1], al
@@2:	inc	ebx
	cmp	ebx, 34h
	sbb	eax, eax
	and	ebx, eax
	dec	ecx
	jne	@@1
@@9:	pop	esi
	pop	ebx
	ret
ENDP

@@ReadKey PROC
	push	ebx
	mov	ebx, esp
	call	_ArcParamNum, 0
	db 'kif_key', 0
	jnc	@@1c
	call	_ArcParam
	db 'kif_str', 0
	jc	@@1d
	call	_stack_sjis_esc, eax
	mov	edx, esp
	or	eax, -1
@@1:	mov	cl, [edx]
	inc	edx
	shl	ecx, 18h
	je	@@1c
	push	8
	xor	eax, ecx
	pop	ecx
@@1a:	shl	eax, 1
	jnc	@@1b
	xor	eax, 004C11DB7h
@@1b:	dec	ecx
	jne	@@1a
	not	eax
	jmp	@@1

@@1c:	clc
@@1d:	mov	esp, ebx
	pop	ebx
	ret
ENDP

@@sign	db '__key__.dat', 0
ENDP

_conv_kif PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-8]
@@L1 = dword ptr [ebp-0Ch]
@@L2 = dword ptr [ebp-10h]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, '3gh'
	je	@@1
@@9:	stc
	leave
	ret

	; 004B1070 hg3_read
@@1:	sub	ebx, 4Ch
	jb	@@9
	mov	eax, [esi]
	mov	edx, [esi+4]
	sub	eax, '3-GH'
	sub	edx, 0Ch
	or	eax, edx
	jne	@@9
	mov	edx, 'idts'
	mov	ecx, 'ofn'
	sub	edx, [esi+14h]
	sub	ecx, [esi+18h]
	mov	eax, [esi+1Ch]
	or	edx, ecx
	sub	eax, 38h
	or	eax, edx
	jne	@@9
	cmp	dword ptr [esi+2Ch], 20h
	jne	@@9
	push	dword ptr [esi+28h]
	push	dword ptr [esi+24h]

	mov	edx, [esi+34h]
	mov	eax, [esi+30h]
	sub	edx, [esi+48h]
	sub	eax, [esi+44h]
	shl	edx, 10h
	xchg	dx, ax
	push	edx
	add	esi, 4Ch

	sub	ebx, 10h
	jb	@@9
	mov	edx, '000'
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, '0gmi'
	or	eax, edx
	jne	@@9
	mov	ecx, [esi+0Ch]
	sub	ebx, ecx
	jb	@@9
	sub	ecx, 18h
	jb	@@9
	mov	eax, [@@L0+4]
	cmp	[esi+14h], eax
	jne	@@9
	mov	eax, [esi+18h]
	mov	edi, [esi+1Ch]
	add	eax, [esi+20h]
	jb	@@9
	add	edi, [esi+24h]
	jc	@@9
	cmp	ecx, eax
	jb	@@9

	mov	ecx, [@@L0]
	mov	edx, [@@L0+4]
	mov	ebx, ecx
	imul	ebx, edx
	shl	ebx, 2
	call	_ArcTgaAlloc, 3, ecx, edx
	pop	edx
	push	eax	; @@L1
	mov	[eax+8], edx

	call	_MemAlloc, edi
	jc	@@9
	push	eax	; @@L2
	xchg	edi, eax

	lea	edx, [esi+28h]
	add	edx, [esi+18h]
	call	_zlib_unpack, edi, dword ptr [esi+24h], edx, dword ptr [esi+20h]
	lea	edx, [esi+28h]
	add	edi, [esi+24h]
	call	_zlib_unpack, edi, dword ptr [esi+1Ch], edx, dword ptr [esi+18h]

	mov	edi, [@@L1]
	add	edi, 12h
	call	@@Unpack, edi, ebx, [@@L2], dword ptr [esi+24h], dword ptr [esi+1Ch]

	call	_MemFree

	clc
	leave
	ret

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]

@@L1 = dword ptr [ebp-4]
@@L2 = dword ptr [ebp-8]
@@L3 = dword ptr [ebp-10h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
	mov	eax, [@@SC]
	add	eax, esi
	push	eax	; @@L1
	call	@@3
	sbb	edx, edx
	call	@@4
	mov	ecx, [@@DC]
	sub	[@@DC], eax
	jb	@@9
	shr	ecx, 2
	push	eax	; @@L2
	push	ecx
	push	ecx
	push	edi
	test	edx, edx
	jne	@@1a
@@1:	cmp	[@@L2], 0
	je	@@7
	call	@@4
	xchg	ecx, eax
	sub	[@@L2], ecx
	jb	@@9
	xor	eax, eax
@@1b:	call	@@2
	dec	ecx
	jne	@@1b

@@1a:	cmp	[@@L2], 0
	je	@@7
	call	@@4
	xchg	ecx, eax
	sub	[@@L2], ecx
	jb	@@9
	sub	[@@L0], ecx
	jb	@@9
	push	esi
	mov	esi, [@@L1]
@@1c:	lodsb
	call	@@2
	dec	ecx
	jne	@@1c
	mov	[@@L1], esi
	pop	esi
	jmp	@@1

@@7:	mov	ecx, [@@DC]
	xor	esi, esi
	test	ecx, ecx
	je	@@7b
	xor	eax, eax
@@7a:	call	@@2
	dec	ecx
	jne	@@7a
@@7b:	pop	edi
	movzx	edx, word ptr [edi-12h+0Eh]
	movzx	eax, word ptr [edi-12h+0Ch]
	call	@@6, edi, eax, edx
@@9:	xor	eax, eax
	mov	edx, [@@SC]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h

@@2:	stosb
	add	edi, 3
	dec	[@@L3]
	jne	@@2a
	mov	edi, [@@DB]
	mov	edx, [@@L3+4]
	inc	edi
	mov	[@@L3], edx
	mov	[@@DB], edi
@@2a:	ret

@@3:	shr	ebx, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@3a:	ret

	; 004B0860
@@4:	xor	ecx, ecx
	xor	eax, eax
@@4a:	cmp	ecx, 20h
	jae	@@9
	inc	ecx
	call	@@3
	jnc	@@4a
	inc	eax
	dec	ecx
	je	@@5a
@@5:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@5
@@5a:	ret

@@6 PROC

@@D = dword ptr [ebp+14h]
@@W = dword ptr [ebp+18h]
@@H = dword ptr [ebp+1Ch]

	push	ebx
	push	esi
	push	edi
	enter	400h, 0
	mov	edi, esp
	xor	ecx, ecx
@@4a:	or	eax, -1
	mov	edx, ecx
@@4b:	shrd	eax, edx, 2
	shr	eax, 6
	shr	edx, 2
	test	al, al
	js	@@4b
	stosd
	inc	cl
	jne	@@4a

	mov	ecx, [@@W]
	mov	esi, [@@D]
	imul	ecx, [@@H]
	xor	eax, eax
@@1:	lodsb
	mov	edx, [esp+eax*4]
	shl	edx, 2
	lodsb
	add	edx, [esp+eax*4]
	shl	edx, 2
	lodsb
	add	edx, [esp+eax*4]
	shl	edx, 2
	lodsb
	add	edx, [esp+eax*4]
	mov	[esi-4], edx
	dec	ecx
	jne	@@1

	push	4
	mov	edi, [@@D]
	pop	ecx
@@2a:	mov	al, [edi]
	shr	al, 1
	sbb	dl, dl
	xor	al, dl
	stosb
	dec	ecx
	jne	@@2a

	mov	ecx, [@@W]
	dec	ecx
	je	@@2c
	shl	ecx, 2
@@2b:	mov	al, [edi]
	shr	al, 1
	sbb	dl, dl
	xor	al, dl
	add	al, [edi-4]
	stosb
	dec	ecx
	jne	@@2b
@@2c:
	mov	ebx, [@@W]
	mov	ecx, [@@H]
	shl	ebx, 2
	dec	ecx
	je	@@2e
	imul	ecx, ebx
	neg	ebx
@@2d:	mov	al, [edi]
	shr	al, 1
	sbb	dl, dl
	xor	al, dl
	add	al, [edi+ebx]
	stosb
	dec	ecx
	jne	@@2d
@@2e:
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP	; @@6

ENDP	; @@Unpack

ENDP

; "Grisaia no Kajitsu" export\*.zt

	dw 0
_arc_kif_zt PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@L1, 8
@M0 @@L0, 114h

	enter	@@stk, 0
	mov	[@@N], 100000h
	and	[@@P], 0
	mov	esi, esp

@@1:	call	_FileRead, [@@S], esi, 11Ch
	jc	@@9
	mov	eax, [esi+0Ch]
	cmp	eax, 2
	jae	@@9
	xor	eax, 1
	cmp	dword ptr [esi+eax*4], 0
	jne	@@9
	dec	eax
	jne	@@8
	lea	edx, [esi+10h]
	call	_ArcName, edx, 104h
	and	[@@D], 0
	mov	ebx, [@@L1]
	mov	edi, [@@L1+4]
	cmp	ebx, edi
	jne	$+4
	xor	edi, edi
	lea	eax, [@@D]
	call	_ArcMemRead, eax, edi, ebx, 0
	xchg	ebx, eax
	test	edi, edi
	je	@@1a
	call	_zlib_unpack, [@@D], edi, edx, ebx
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], edi
	call	_MemFree, [@@D]
@@8:
	mov	eax, [esi]
	add	eax, [esi+4]
	je	@@9
	add	[@@P], eax
	jc	@@9
	call	_FileSeek, [@@S], [@@P], 0
	jc	@@9
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	; ...
@@9a:	leave
	ret
ENDP
