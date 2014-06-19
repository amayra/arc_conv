
; "Thirua Panic" *.mrg
; device\codec\merge.dll

; "F&C", "Cocktail Soft", "Overture"

	dw _conv_overture-$-2
_arc_overture PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ebx
	pop	ecx
	sub	eax, 'GRM'
	sub	edx, 20001h
	or	eax, edx
	jne	@@9a
	mov	[@@N], ecx
	imul	eax, ecx, 57h
	dec	ecx
	add	eax, 57h
	sub	ebx, 10h
	shr	ecx, 14h
	jne	@@9a
	cmp	ebx, eax
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]

	call	_unicode_name, offset inFileName
	xchg	edx, eax
	push	0
	lea	eax, [ecx+ecx]
	and	eax, -4
	sub	esp, eax
	call	_unicode_to_ansi, 932, edx, ecx, esp
	call	@@Hash, esp
	mov	[@@L0], eax
	lea	esp, [ebp-@@stk]
	call	_overture_mrg_crypt, 0285EE76Fh, eax, esi, ebx
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	call	_ArcName, esi, 41h
	and	[@@D], 0
	mov	eax, [esi+4Fh]
	mov	ebx, [esi+4Fh+57h]
	mov	edi, [esi+41h]
	sub	ebx, eax
	jb	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	movzx	eax, word ptr [esi+45h]
	cmp	eax, 4
	jae	@@1a
	test	eax, eax
	jne	@@1c
	mov	byte ptr [esi+41h], 0
	call	@@Hash, esi
	call	_overture_mrg_crypt, [@@L0], eax, [@@D], ebx
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 57h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@1c:	test	al, 2
	je	@@1d
	mov	edx, [@@D]
	cmp	ebx, 108h
	jb	@@1a
	mov	ecx, [edx]
	xor	ecx, [edx+104h]
	push	ecx
	call	_MemAlloc, ecx
	pop	ecx
	jc	@@1a
	mov	edx, [@@D]
	mov	[@@D], eax
	push	edx
	add	edx, 4
	sub	ebx, 4
	call	_overture_arith_unpack, 0, eax, ecx, edx, ebx
	xchg	ebx, eax
	call	_MemFree
@@1d:	test	byte ptr [esi+45h], 1
	je	@@1e
	call	_MemAlloc, edi
	jc	@@1a
	mov	edx, [@@D]
	mov	[@@D], eax
	push	edx
	call	_overture_lzss_unpack, 0, eax, edi, edx, ebx
	xchg	ebx, eax
	call	_MemFree
@@1e:	jmp	@@1a

@@Hash PROC	; merge.dll 10007CB0
	push	esi
	mov	esi, [esp+8]
	lodsb
	sub	al, 61h
	cmp	al, 1Ah
	sbb	cl, cl
	and	cl, -20h
	add	al, cl
	add	al, 61h
	movsx	edx, al
	test	al, al
	je	@@9
@@1:	cmp	al, '.'
	je	@@2
	sub	al, 61h
	cmp	al, 1Ah
	sbb	cl, cl
	and	cl, -20h
	add	al, cl
	add	al, 61h
	movsx	eax, al
	imul	edx, 41h
	add	edx, eax
@@2:	lodsb
	test	al, al
	jne	@@1
@@9:	xchg	eax, edx
	pop	esi
	ret	4
ENDP

ENDP

_overture_mrg_crypt PROC	; merge.dll 10007C10
	; key1, key2, buf, len
	push	ebx
	enter	100h, 0
	mov	eax, [ebp+10h]
	mov	edx, [ebp+0Ch]	; 0x285EE76F
	; 10007DE0 10008C50
	xor	ebx, ebx
@@2:	mov	ecx, eax
	rol	ecx, 10h
	add	ecx, edx
	mov	edx, eax
	add	eax, ecx
	mov	byte ptr [esp+ebx], al
	inc	bl
	jne	@@2
	mov	ecx, [ebp+18h]
	mov	edx, [ebp+14h]
	test	ecx, ecx
	je	@@9
@@1:	mov	al, [esp+ebx]
	inc	bl
	xor	[edx], al
	inc	edx
	dec	ecx
	jne	@@1
@@9:	leave
	pop	ebx
	ret	10h
ENDP

_overture_arith_unpack PROC	; merge.dll 10001130

@@K = dword ptr [ebp+14h]
@@DB = dword ptr [ebp+18h]
@@DC = dword ptr [ebp+1Ch]
@@SB = dword ptr [ebp+20h]
@@SC = dword ptr [ebp+24h]

@@M = dword ptr [ebp-4]
@@L0 = dword ptr [ebp-8]
@@L1 = dword ptr [ebp-0Ch]
@@L2 = dword ptr [ebp-10h]

	push	ebx
	push	esi
	push	edi
	enter	410h, 0

	mov	esi, [@@SB]
	mov	edi, [@@DB]
	sub	[@@SC], 104h
	jb	@@9a
	call	_MemAlloc, 0FF00h
	jb	@@9a
	mov	[@@M], eax
	push	edi
	xchg	edi, eax
	xor	eax, eax
	xor	edx, edx
	mov	ebx, [@@K]
@@2a:	movzx	ecx, byte ptr [esi]
	inc	esi
	cmp	[@@K], 0
	je	@@2c
	rol	cl, 1
	xor	cl, bl
	sub	bl, al
@@2c:	mov	[esp+eax*4+4], dx
	mov	[esp+eax*4+6], cx
	add	edx, ecx
	rep	stosb
	inc	al
	jne	@@2a
	pop	edi

	mov	cl, 7
	mov	ebx, edx
	dec	edx
	js	@@9
	shr	edx, cl
@@2b:	inc	ecx
	shr	edx, 1
	jne	@@2b
	inc	edx
	shl	edx, cl
	dec	edx
	mov	[@@L2], edx

	mov	eax, 10000h
	xor	edx, edx
	div	ebx
	mov	[@@L0], ebx
	mov	[@@L1], eax

	lodsd
	bswap	eax
	xor	ebx, ebx
	or	ecx, -1
@@1:	dec	[@@DC]
	js	@@7
	shr	ecx, 8
	imul	ecx, [@@L1]
	shr	ecx, 8
	push	eax
	sub	eax, ebx
	xor	edx, edx
	div	ecx
	mov	edx, [@@M]
	cmp	eax, [@@L0]
	jae	@@9
	movzx	eax, byte ptr [edx+eax]
	stosb
	movzx	edx, word ptr [esp+eax*4+4]
	movzx	eax, word ptr [esp+eax*4+6]
	imul	edx, ecx
	imul	ecx, eax
	pop	eax
	add	ebx, edx
	jmp	@@1b

@@1a:	shl	ebx, 8
	shl	eax, 8
	shl	ecx, 8
	dec	[@@SC]
	js	@@9
	lodsb
@@1b:	lea	edx, [ecx+ebx]
	xor	edx, ebx
	test	edx, 0FF000000h
	je	@@1a
@@1c:	cmp	ecx, [@@L2]
	ja	@@1
	mov	ecx, ebx
	not	ecx
	and	ecx, [@@L2]
	shl	ebx, 8
	shl	eax, 8
	shl	ecx, 8
	dec	[@@SC]
	js	@@9
	lodsb
	jmp	@@1c

@@7:	xor	esi, esi
@@9:	call	_MemFree, [@@M]
@@9a:	xchg	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

_overture_lzss_unpack PROC

@@K = dword ptr [ebp+14h]
@@DB = dword ptr [ebp+18h]
@@DC = dword ptr [ebp+1Ch]
@@SB = dword ptr [ebp+20h]
@@SC = dword ptr [ebp+24h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	mov	ebx, [@@K]
	shl	ebx, 8
@@1:	dec	[@@DC]
	js	@@7
	shr	bl, 1
	jne	@@1a
	call	@@3
	mov	bl, al
	stc
	rcr	bl, 1
@@1a:	jnc	@@1b
	call	@@3
	cmp	[@@DB], 0
	je	@@1c
	stosb
	jmp	@@1

@@2c:	add	edi, ecx
@@1c:	inc	edi
	jmp	@@1

@@1b:	call	@@3
	movzx	edx, al
	call	@@3
	mov	dh, al
	mov	ecx, edx
	and	dh, 0Fh
	shr	ecx, 0Ch
	add	ecx, 2
	sub	[@@DC], ecx
	jb	@@9
	cmp	[@@DB], 0
	je	@@2c
	inc	ecx
	mov	eax, edi
	sub	eax, [@@DB]
	sub	edx, eax
	add	edx, 12h
	or	edx, -1000h
	add	eax, edx
	jns	@@2b
@@2a:	mov	byte ptr [edi], 0
	inc	edi
	dec	ecx
	je	@@1
	inc	eax
	jne	@@2a
@@2b:	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
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
	ret	14h

@@3:	mov	ah, byte ptr [@@SC]
	dec	[@@SC]
	js	@@9
	lodsb
	cmp	[@@K], 0
	je	@@3a
	rol	al, 1
	xor	al, bh
	add	bh, ah
@@3a:	ret
ENDP

if 0
_overture_mcx_decrypt PROC	; mcx.dll 10008A30
	push	edi
	mov	ecx, [esp+10h]
	mov	edi, [esp+0Ch]
	test	ecx, ecx
	je	@@9
	mov	edx, [esp+8]
	test	edx, edx
	je	@@9
@@1:	mov	al, [edi]
	rol	al, 1
	xor	al, dl
	stosb
	add	dl, cl
	dec	ecx
	jne	@@1
@@9:	pop	edi
	ret	0Ch
ENDP

_overture_mcx_encrypt PROC
	push	edi
	mov	ecx, [esp+10h]
	mov	edi, [esp+0Ch]
	test	ecx, ecx
	je	@@9
	mov	edx, [esp+8]
	test	edx, edx
	je	@@9
@@1:	mov	al, [edi]
	xor	al, dl
	ror	al, 1
	stosb
	add	dl, cl
	dec	ecx
	jne	@@1
@@9:	pop	edi
	ret	0Ch
ENDP

_overture_lzss_crypt PROC
	xor	eax, eax
@@1:	dec	ecx
	js	@@9
	shr	eax, 1
	jne	@@1a
	dec	ecx
	js	@@9
	mov	al, [edx]
	inc	edx
	stc
	rcr	al, 1
@@1a:	jnc	@@1b
	inc	edx
	jmp	@@1

@@1b:	inc	edx
	rol	byte ptr [edx], 4
	inc	edx
	dec	ecx
	jns	@@1
@@9:	ret
ENDP
endif

_conv_overture PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'gcm'
	je	@@1
	cmp	eax, 'dca'
	je	@@2
	cmp	eax, 'acm'
	je	@@3
@@9:	stc
	leave
	ret

@@2:	sub	ebx, 1Ch
	jb	@@9
	mov	edx, '00.1'
	mov	eax, [esi]
	sub	edx, [esi+4]
	mov	ecx, [esi+8]
	sub	eax, ' DCA'
	sub	ecx, 1Ch
	or	eax, edx
	or	eax, ecx
	jne	@@9
	push	ebx
	mov	edi, [esi+14h]
	mov	edx, [esi+18h]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 20h, edi, edx
	lea	edi, [eax+12h]
	mov	ecx, [esi+10h]
	add	ecx, 7
	shr	ecx, 3
	push	ecx
	call	_MemAlloc, ecx
	pop	ecx
	jc	@@9
	lea	edx, [esi+1Ch]
	xchg	esi, eax
	call	_overture_lzss_unpack, 0, esi, ecx, edx
	call	@@ACD, edi, ebx, esi, eax
	call	_MemFree, esi
	call	_ArcGetExt
	mov	byte ptr [edx], '_'
	clc
	leave
	ret

@@1:	cmp	ebx, 41h
	jb	@@9
	mov	eax, [esi]
	mov	edx, [esi+10h]
	sub	eax, ' GCM'
	sub	edx, 40h
	or	eax, edx
	jne	@@9
	mov	eax, [esi+4]
	mov	ecx, [esi+24h]
	cmp	eax, '00.1'
	je	@@1b
	cmp	ecx, 18h
	jne	@@9
	cmp	eax, '10.1'
	je	@@1a
	cmp	eax, '00.2'
	jne	@@9
@@1a:	call	@@Key, esi, ebx
	js	@@9
	push	eax	; @@L0
	mov	edi, [esi+1Ch]
	mov	edx, [esi+20h]
	call	_ArcTgaAlloc, 22h+4, edi, edx
	lea	edi, [eax+12h]
	mov	ecx, [esi+18h-2]
	mov	cx, [esi+14h]
	mov	[edi-12h+8], ecx
	call	@@MCG, edi, [@@L0], esi, ebx
	clc
	leave
	ret

	; "univ"
@@1b:	cmp	ecx, 8
	jne	@@9
	sub	ebx, 440h
	jb	@@9
	mov	[@@SC], ebx
	mov	edi, [esi+1Ch]
	mov	edx, [esi+20h]
	lea	ebx, [edi+3]
	and	ebx, -4
	imul	ebx, edx
	call	_ArcTgaAlloc, 38h+4, edi, edx
	lea	edi, [eax+12h]
	add	esi, 40h
	mov	ecx, 100h
	push	edi
	rep	movsd
	call	_overture_lzss_unpack, 0, edi, ebx, esi, [@@SC]
	call	_tga_align4
	clc
	leave
	ret

@@3:	sub	ebx, 30h
	jb	@@9
	mov	edx, 10000h
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, ' ACM'
	or	eax, edx
	jne	@@9
	mov	edi, [esi+20h]
	mov	eax, [esi+10h]
	mov	edx, [esi+14h]
	sub	eax, 30h
	lea	ecx, [edi-1]
	sub	edx, 18h
	shr	ecx, 10h
	or	eax, edx
	shl	edi, 2
	or	eax, ecx
	jne	@@9
	sub	ebx, edi
	jb	@@9
	call	@@Key, esi, [@@SC]
	js	@@9
	push	eax	; @@L0
	call	_ArcSetExt, 0
	push	edx	; @@L1
	xor	ebx, ebx
@@3a:	mov	ecx, [@@SC]
	mov	edi, [esi+30h+ebx*4]
	sub	ecx, edi
	jb	@@3b
	add	esi, edi
	sub	ecx, 20h
	jb	@@3b
	sub	ecx, [esi+14h]
	jb	@@3b
	cmp	dword ptr [esi], 1
	jne	@@3b

	call	_ArcNameFmt, [@@L1], ebx
	db '\%05i',0
	pop	ecx

	mov	edi, [esi+0Ch]
	mov	edx, [esi+10h]
	lea	eax, [edi*2+edi+3]
	and	al, -4
	imul	eax, edx
	push	eax
	call	_ArcTgaAlloc, 40h+22h+4, edi, edx
	pop	edx
	jc	@@3b
	lea	edi, [eax+12h]
	mov	ecx, [esi+8-2]
	mov	cx, [esi+4]
	mov	[edi-12h+8], ecx
	add	esi, 20h
	call	_overture_lzss_unpack, [@@L0], edi, edx, esi, dword ptr [esi-20h+14h]
	call	_tga_align4, edi
	call	_ArcTgaSave
	call	_ArcTgaFree
@@3b:	mov	esi, [@@SB]
	inc	ebx
	cmp	ebx, [esi+20h]
	jb	@@3a
	clc
	leave
	ret

@@ACD PROC	; mcx.dll 1000A960

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
	xor	eax, eax
	call	@@3
	jnc	@@1b
	dec	eax
	call	@@3
	jc	@@1b
	add	eax, 3
@@1a:	call	@@3
	adc	al, al
	jnc	@@1a
	je	@@1b
	inc	eax
	imul	eax, 28CCCCDh	; (0xFF << 24) / 0x64
	shr	eax, 18h
@@1b:	stosb
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

@@3:	shl	bl, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@3a:	ret
ENDP

@@Key PROC
	push	esi
	call	_ArcLocal, 0
	xchg	esi, eax
	jnc	@@1
	call	_ArcParamNum, -1
	db 'overture', 0
	jnc	@@1
	mov	[esi], eax
@@1:	mov	eax, [esi]
	cmp	eax, -4
	jb	@@2
	call	@@Brute, dword ptr [esp+0Ch], dword ptr [esp+0Ch]
	test	eax, eax
	jns	@@3
	mov	eax, [esi]
	dec	eax
@@3:	mov	[esi], eax
@@2:	test	eax, eax
	pop	esi
	ret	8

; 0x6F-"Thirua Panic (Trial)"
; 0x43-"Pia Carrot he Youkoso!! G.P. (Trial)"
; 0x5C-"Canvas 4 ~Achrome Etude~ (Trial)"

@@Brute PROC

@@SB = dword ptr [ebp+14h]
@@SC = dword ptr [ebp+18h]

@@K = dword ptr [ebp-4]
@@M = dword ptr [ebp-8]
@@N = dword ptr [ebp-0Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	push	-1	; @@K

	mov	esi, [@@SB]
	cmp	byte ptr [esi+2], 'G'
	jne	@@3
	mov	eax, [esi+1Ch]
	mov	edx, [esi+20h]
	mov	ecx, eax
	or	ecx, edx
	mov	edi, eax
	imul	edi, edx
	shr	ecx, 0Fh
	jne	@@9
	test	edi, edi
	je	@@9
	cmp	byte ptr [esi+4], '2'
	jne	@@2
	call	_MemAlloc, edi
	jc	@@9
	push	eax	; @@M
	and	[@@K], 0
@@1:	mov	esi, [@@SB]
	mov	ebx, [@@SC]
	add	esi, 40h
	sub	ebx, 41h
	push	3	; @@N
@@1a:	call	_overture_arith_unpack, [@@K], [@@M], edi, esi, ebx
	jc	@@1b
	add	esi, ebx
	mov	ebx, edx
	sub	esi, edx
	dec	[@@N]
	jne	@@1a
	test	edx, edx
	je	@@7
@@1b:	pop	ecx
	inc	[@@K]
	cmp	[@@K], 100h
	jbe	@@1
	or	[@@K], -1
@@7:	call	_MemFree, [@@M]
@@9:	mov	eax, [@@K]
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@2:	lea	edi, [eax*2+eax+3]
	and	edi, -4
	imul	edi, edx
	mov	esi, [@@SB]
	mov	ebx, [@@SC]
	add	esi, 40h
	sub	ebx, 41h
	and	[@@K], 0
@@2a:	call	_overture_lzss_unpack, [@@K], 0, edi, esi, ebx
	jc	@@2b
	test	edx, edx
	mov	eax, [@@K]
	je	@@9a
@@2b:	inc	[@@K]
	cmp	[@@K], 100h
	jbe	@@2a
	or	eax, -1
	jmp	@@9a

@@3:	xor	ebx, ebx
@@3a:	push	ebx
	mov	ecx, [@@SC]
	mov	edi, [esi+30h+ebx*4]
	sub	ecx, edi
	jb	@@3b
	add	edi, esi
	sub	ecx, 20h
	jb	@@3b
	sub	ecx, [edi+14h]
	jb	@@3b
	cmp	dword ptr [edi], 1
	jne	@@3b

	mov	eax, [edi+0Ch]
	mov	edx, [edi+10h]
	mov	ecx, eax
	or	ecx, edx
	lea	eax, [eax*2+eax+3]
	and	al, -4
	imul	eax, edx
	shr	ecx, 0Fh
	jne	@@3b
	test	eax, eax
	je	@@3b
	xchg	ebx, eax
	add	edi, 20h
	cmp	[@@K], -1
	jne	@@3e
	and	[@@K], 0
@@3c:	call	_overture_lzss_unpack, [@@K], 0, ebx, edi, dword ptr [edi-20h+14h]
	jc	@@3d
	test	edx, edx
	je	@@3b
@@3d:	inc	[@@K]
	cmp	[@@K], 100h
	jbe	@@3c
@@3f:	or	eax, -1
	jmp	@@9a

@@3e:	call	_overture_lzss_unpack, [@@K], 0, ebx, edi, dword ptr [edi-20h+14h]
	jc	@@3f
	test	edx, edx
	jne	@@3f
@@3b:	pop	ebx
	inc	ebx
	cmp	ebx, [esi+20h]
	jb	@@3a
	jmp	@@9
ENDP

ENDP

@@MCG PROC

@@D = dword ptr [ebp+14h]
@@K = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-4]
@@M = dword ptr [ebp-8]
@@L1 = dword ptr [ebp-0Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@SB]
	mov	eax, [esi+1Ch]
	mov	edx, [esi+20h]
	cmp	byte ptr [esi+4], '2'
	je	@@2
	lea	eax, [eax*2+eax+3]
	and	al, -4
	imul	eax, edx
	mov	ebx, [@@SC]
	add	esi, 40h
	sub	ebx, 41h
	call	_overture_lzss_unpack, [@@K], [@@D], eax, esi, ebx
	call	_tga_align4, [@@D]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@2:	imul	eax, edx
	push	eax
	lea	eax, [eax*2+eax]
	call	_MemAlloc, eax
	jc	@@9
	push	eax	; @@M
	push	3
	xchg	edi, eax

	mov	ebx, [@@SC]
	add	esi, 40h
	sub	ebx, 40h
@@2a:	call	_overture_arith_unpack, [@@K], edi, [@@L0], esi, ebx
	jc	@@2b
	add	esi, ebx
	mov	ebx, edx
	sub	esi, edx
	add	edi, eax
	dec	[@@L1]
	jne	@@2a
@@2b:
	mov	esi, [@@M]
	mov	edi, [@@D]
	mov	ebx, [@@L0]
	push	esi
	mov	ecx, ebx
@@2c:	mov	al, [esi+ebx]
	stosb
	mov	al, [esi]
	stosb
	mov	al, [esi+ebx*2]
	stosb
	inc	esi
	dec	ecx
	jne	@@2c
	call	_MemFree

	; mcx.dll 10007EA0
	mov	esi, [@@SB]
	mov	edi, [@@D]
	mov	ebx, [esi+1Ch]
	mov	edx, [esi+20h]
	dec	ebx
	je	@@1e
	lea	ebx, [ebx*2+ebx]
	dec	edx
	je	@@1e
	mov	[@@L1], edx
@@1a:	mov	[@@L0], ebx
@@1b:	movzx	edx, byte ptr [edi+ebx+3]
	movzx	eax, byte ptr [edi+3]
	movzx	ecx, byte ptr [edi]
	sub	eax, ecx
	sub	edx, ecx
	lea	ecx, [eax+edx]
	jns	$+4
	neg	edx
	test	eax, eax
	jns	$+4
	neg	eax
	test	ecx, ecx
	jns	$+4
	neg	ecx

	cmp	edx, eax
	jb	@@1c
	cmp	ecx, eax
	mov	al, [edi+ebx+3]
	jae	@@1d
@@1c:	cmp	ecx, edx
	mov	al, [edi+3]
	jae	@@1d
	mov	al, [edi]
@@1d:	add	al, 80h
	add	[edi+ebx+6], al
	inc	edi
	dec	[@@L0]
	jne	@@1b
	add	edi, 3
	dec	[@@L1]
	jne	@@1a
@@1e:
	mov	esi, [@@SB]
	mov	edi, [@@D]
	mov	ebx, [esi+1Ch]
	imul	ebx, [esi+20h]
@@1f:	mov	al, 80h
	mov	dl, 80h
	add	al, [edi]
	add	dl, [edi+2]
	movsx	eax, al
	movsx	edx, dl
	mov	cl, [edi+1]
	lea	esi, [eax+edx]
	sar	esi, 2
	sub	ecx, esi
	add	eax, ecx
	add	edx, ecx
	mov	[edi], al
	mov	[edi+1], cl
	mov	[edi+2], dl
	add	edi, 3
	dec	ebx
	jne	@@1f

@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

ENDP
