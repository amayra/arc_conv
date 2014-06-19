
; "Nagagutsu wo Haita Deco", "You Gaku" *.war
; deco.exe
; 00441870 open_archive

_warc_exescan PROC

@@D = dword ptr [ebp+14h]

@@stk = 0
@M0 @@L0, 8
@M0 @@SC
@M0 @@SB
@M0 @@L1

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, offset inFileName
	call	_unicode_name, esi
	xchg	edx, eax
@@1e:	movzx	eax, word ptr [edx]
	inc	edx
	inc	edx
	test	eax, eax
	je	@@9a
	cmp	eax, 5Fh	; '_'
	jne	@@1e
	sub	edx, esi
	lea	eax, [edx+6]
	mov	ecx, edx
	and	al, -4
	shr	ecx, 2
	push	0
	sub	esp, eax
	mov	edi, esp
	rep	movsd
	lea	edi, [esp+edx-2]
	mov	eax, '.' + 'e' * 10000h
	stosd
	mov	al, 'x'
	stosd
	mov	edx, esp
	xor	esi, esi
	call	_FileCreate, edx, FILE_INPUT
	jc	@@1b
	xchg	edi, eax
	call	_FileGetSize, edi
	test	eax, eax
	xchg	ebx, eax
	jle	@@1a
	call	_MemAlloc, ebx
	jc	@@1a
	xchg	esi, eax
	call	_FileRead, edi, esi, ebx
	xchg	ebx, eax
@@1a:	call	_FileClose, edi
@@1b:	lea	esp, [@@L0]
	test	esi, esi
	je	@@9a
	push	ebx
	push	esi
	call	_CheckPeHdr, esp
	test	eax, eax
	je	@@9
	call	_exe_timestamp, esi, ebx
	push	eax	; @@L1
	mov	ecx, [esi+3Ch]
	call	_RVAToFile, esi, dword ptr [esi+ecx+28h]	; Entry point
	jc	@@9
	sub	ebx, eax
	jb	@@9
	add	eax, esi
	cmp	ebx, 50h
	jb	@@9
	xchg	ebx, eax
	cmp	dword ptr [ebx], 52515390h
	jne	@@9
	mov	eax, [ebx+11h]
	lea	edi, [ebx+7]
	call	@@2
	cmp	byte ptr [ebx+1Ch], 0E8h
	jne	@@9
	; v2.39
	lea	edi, [ebx+22h]
	call	@@2
	mov	ecx, [ebx+27h]
	sub	edi, ecx
	call	_warc_scan, edi, ecx, [@@L1]
	jc	@@9
	xor	edi, edi
	mov	esi, edx
	xchg	edi, [@@D]
	call	_warc_init
@@9:	call	_MemFree, [@@SB]
@@9a:	neg	[@@D]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4

@@2:	push	eax
	mov	eax, [edi]
	mov	ecx, [esi+3Ch]
	sub	eax, [esi+ecx+34h]	; Image base
	call	_RVAToFile, esi, eax
	mov	ecx, [edi+5]
	xchg	edi, eax
	pop	eax
	jc	@@9
	mov	edx, [@@SC]
	sub	edx, edi
	jb	@@9
	add	edi, esi
	sub	edx, ecx
	jb	@@9
	test	ecx, ecx
	je	@@2b
@@2a:	lea	eax, [eax*4+eax+11h]	; 0x3711
	xor	[edi], al
	inc	edi
	dec	ecx
	jne	@@2a
@@2b:	ret
ENDP

	dw _conv_warc-$-2
_arc_warc PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1, 18h
@M0 @@L3

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@4b
	pop	eax
	movzx	edx, word ptr [esi+4]
	sub	eax, 'CRAW'
	sub	edx, 3120h
	or	eax, edx
	jne	@@4b
	mov	al, [esi+6]
	mov	dl, [esi+7]
	pop	ecx
	cmp	al, 2Eh
	jne	@@4a
	xchg	eax, edx
	mov	dl, 30h
@@4a:	sub	al, 30h
	cmp	al, 0Ah
	jae	@@4b
	imul	ecx, eax, 0Ah
	lea	eax, [edx-30h]
	cmp	al, 0Ah
	jae	@@4b
	add	eax, ecx
	cmp	al, 70
	jne	@@9a

	lea	edi, [@@L1]
	call	_ArcParam
	db 'warc', 0
	jc	@@4f
	call	_warc_readkey, eax, edi
	jnc	@@4e
@@4b:	jmp	@@9a

@@4f:	call	_warc_exescan, edi
	jnc	@@4e
	xor	esi, esi
	mov	eax, 38*32
	call	_warc_init
@@4e:
	pop	edi
	xor	edi, 0F182AD82h
	mov	[@@L0], edi
	call	_FileSeek, [@@S], 0, 2
	jc	@@9a
	sub	eax, edi
	jb	@@9a
	cmp	eax, 8+3
	jb	@@9a
	movzx	ebx, word ptr [@@L1+2]
	shl	ebx, 0Eh
	cmp	eax, ebx
	jb	$+4
	mov	eax, ebx
	xchg	edi, eax
	call	_FileSeek, [@@S], eax, 0
	jc	@@9a
	mov	ecx, 400h
	sub	ecx, edi
	jae	$+4
	xor	ecx, ecx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, edi, ecx
	jc	@@9
	mov	esi, [@@M]
	lea	edx, [@@L1]
	call	_warc_crypt, 0, 0, edx, esi, ebx
	lea	ecx, [edi+3]
	mov	eax, 55555555h
	mov	edx, esi
	xor	eax, [@@L0]
	shr	ecx, 2
@@4c:	xor	[edx], eax
	add	edx, 4
	dec	ecx
	jne	@@4c

	sub	edi, 8
	lea	edx, [esi+8]
	call	_zlib_unpack, 0, -1, edx, edi
	jc	@@9
	cmp	ebx, eax
	jb	$+3
	xchg	eax, ebx
	call	_MemAlloc, ebx
	jc	@@9
	mov	[@@M], eax
	lea	edx, [esi+8]
	call	_zlib_unpack, eax, ebx, edx, edi
	xchg	edi, eax
	call	_MemFree, esi
	cmp	edi, ebx
	jne	@@9
	mov	esi, [@@M]
	movzx	ecx, word ptr [@@L1+2]
	mov	eax, ebx
	xor	edx, edx
	div	ecx
	test	eax, eax
	je	@@9
	test	edx, edx
	jne	@@9
	mov	[@@N], eax
	call	_ArcCount, eax
	call	_ArcDbgData, esi, ebx

	call	_LoadTable, 1
	mov	[@@L3], eax

@@1:	movzx	ebx, word ptr [@@L1+2]
	sub	ebx, 18h
	cmp	esi, [@@M]
	je	@@1b
	lea	ecx, [ebx-1]
	lea	edi, [esi+1]
	push	esi
	sub	esi, ecx
	sub	esi, 18h
	mov	dl, [esi-1]
	rep	cmpsb
	pop	esi
	jne	@@1b
	mov	al, [esi]
	cmp	dl, al
	je	@@1c
	test	al, al
	jns	@@1b
	call	_sjis_test
	jc	@@1c
@@1b:	call	_ArcName, esi, ebx
	add	esi, ebx
	and	[@@D], 0
	mov	ebx, [esi+4]
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	mov	edi, [@@D]
	cmp	ebx, 8
	jb	@@1a
	call	@@30
	jnc	@@2c
	call	@@31
	cmp	byte ptr [esi+17h], 0
	jns	@@2a
	mov	eax, [@@L3]
	test	eax, eax
	je	@@1a
	lea	ecx, [ebx-8]
	lea	edx, [edi+8]
	push	ecx
	push	edx
	lea	edx, [@@L1]
	add	eax, 4000h
	call	_warc_crypt, 0, eax, edx
@@2a:	test	byte ptr [esi+17h], 20h
	je	@@2b
	lea	edx, [edi+8]
	lea	ecx, [ebx-8]
	call	@@32, [@@L3], edx, ecx
@@2b:	call	@@30
	jnc	@@2c
	call	@@31
	jmp	@@1a

@@2c:	test	byte ptr [esi+17h], 40h
	je	@@2d
	call	@@32, [@@L3], edi, ebx
@@2d:	cmp	byte ptr [@@L1], WARC_V249
	jb	@@1a
	call	@@Dec249, [@@D], ebx
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 18h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@1c:	add	esi, ebx
	call	_ArcSkip, 1
	jmp	@@8

@@31:	mov	eax, [edi+4]
	xor	eax, 082AD82h
	and	eax, 0FFFFFFh
	xor	[edi], eax
	ret

@@30:	mov	eax, [edi]
	and	eax, 0FFFFFFh
	cmp	eax, 'ZLY'	; 1
	je	@@30b
	cmp	eax, '1HY'	; 2
	je	@@30a
	cmp	eax, 'KPY'	; 3
	jne	@@30c
@@30a:	call	_MemAlloc, dword ptr [edi+4]
	jc	@@30c
	lea	edx, [edi+8]
	lea	ecx, [ebx-8]
	mov	[@@D], eax
	call	@@Unpack, [@@D], dword ptr [edi+4], edx, ecx
	xchg	ebx, eax
	call	_MemFree, edi
	mov	edi, [@@D]
@@30b:	clc
	ret

@@30c:	stc
	ret

@@32:	cmp	byte ptr [@@L1], WARC_V241	; v2.41 new decode.bin
	sbb	eax, eax
	inc	eax
	shl	eax, 0Dh
@@32a PROC
	mov	edx, esp
	push	ebx
	push	esi
	push	edi
	mov	edi, [edx+4]
	mov	esi, [edx+8]
	test	edi, edi
	je	@@9
	add	edi, eax
	cmp	dword ptr [edx+0Ch], 400h
	jb	@@9
	mov	ecx, 100h
	or	ebx, -1
@@1:	lodsb
	shl	eax, 18h
	xor	ebx, eax
	push	8
	pop	edx
@@2:	shl	ebx, 1
	sbb	eax, eax
	and	eax, 004C11DB7h
	xor	ebx, eax
	dec	edx
	jne	@@2
	dec	ecx
	jne	@@1
	mov	cl, 40h
@@3:	mov	eax, [esi]
	and	eax, 1FFCh
	mov	eax, [edi+eax]
	xor	eax, ebx
	xor	[esi+100h], eax
	add	esi, 4
	dec	ecx
	jne	@@3
@@9:	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

@@Unpack PROC
	mov	al, [edi+3]
	neg	al
	sbb	eax, eax
	and	eax, 4B4Dh
	cmp	byte ptr [edi+1], 4Ch	; HLP -> 48 4C 50
	jb	@@YH1
;	je	@@YLZ

@@YPK PROC	; yougaku.exe 00451BE0
	mov	ecx, eax
	shl	ecx, 10h
	or	eax, ecx
	je	@@4
	mov	edx, [esp+0Ch]
	mov	ecx, [esp+10h]
	not	eax
	sub	ecx, 4
	jb	@@2
@@1:	xor	[edx], eax
	add	edx, 4
	sub	ecx, 4
	jae	@@1
@@2:	and	ecx, 3
	je	@@4
@@3:	xor	[edx], al
	inc	edx
	dec	ecx
	jne	@@3
@@4:	jmp	_zlib_unpack
ENDP

		; huff_shl32
@@YH1 PROC	; yougaku.exe 00451AE0

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	enter	400h, 0
	test	eax, eax
	je	@@2b
	mov	edx, [@@SB]
	mov	ecx, [@@SC]
	xor	eax, 06393528Eh
	shr	ecx, 2
	je	@@2b
@@2a:	xor	[edx], eax
	add	edx, 4
	dec	ecx
	jne	@@2a
@@2b:
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	xor	ebx, ebx
	mov	edx, esp
	xor	ecx, ecx
	cmp	[@@DC], ebx
	je	@@9
	call	@@4
	test	ah, ah
	jne	@@9
	xchg	edx, eax
@@1:	mov	eax, edx
@@1a:	call	@@3
	adc	eax, eax
	movzx	eax, word ptr [esp+eax*2]
	test	ah, ah
	je	@@1a
	stosb
	dec	[@@DC]
	jne	@@1
	xor	esi, esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@3:	shl	ebx, 1
	jne	@@3a
	sub	[@@SC], 4
	jb	@@9
	mov	ebx, [esi]
	add	esi, 4
	stc
	adc	ebx, ebx
@@3a:	ret

@@4:	call	@@3
	jnc	@@4b
	push	ecx
	inc	cl
	je	@@9
	call	@@4
	pop	edi
	mov	[edx+edi*4], ax
	push	edi
	mov	edi, [@@DB]
	call	@@4
	pop	edi
	mov	[edx+edi*4+2], ax
	xchg	eax, edi
	mov	edi, [@@DB]
	ret

@@4b:	mov	eax, 101h
@@4c:	call	@@3
	adc	al, al
	jnc	@@4c
	ret

ENDP	; @@YH1

ENDP	; @@Unpack

@@Dec249 PROC
	push	ebx
	mov	ebx, [esp+0Ch]
	mov	edx, [esp+8]
	cmp	ebx, 400h
	jb	@@9
	and	ebx, 7Eh
	xor	eax, eax
	inc	ebx
	push	edx
@@1:	xor	al, [edx]
	inc	edx
	push	8
	pop	ecx
@@2:	ror	ax, 1
	jc	@@3
	xor	ax, 408h
@@3:	dec	ecx
	jne	@@2
	dec	ebx
	jne	@@1
	pop	edx
	xor	[edx+104h], ax
@@9:	pop	ebx
	ret	8
ENDP

ENDP

_conv_warc PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'vgo'
	je	@@4
	cmp	eax, '52s'
	jne	@@9
	sub	ebx, 8
	jb	@@9
	mov	eax, [esi]
	mov	ecx, [esi+4]
	sub	eax, '52S'
	lea	edx, [ecx-1]
	shr	edx, 10h
	or	eax, edx
	jne	@@9
	mov	eax, ecx
	shl	ecx, 2
	sub	ebx, ecx
	jb	@@9
	xchg	edi, eax
	xor	ebx, ebx
@@1a:	call	@@S25A, [@@SB], [@@SC], ebx
	inc	ebx
	cmp	ebx, edi
	jb	@@1a
	xor	ebx, ebx
	dec	edi
	jne	@@2
	call	@@3
	leave
	ret

@@9:	stc
	leave
	ret

@@2:	push	edi	; @@L0
	call	_ArcSetExt, 0
	push	edx	; @@L1
@@2a:	call	_ArcNameFmt, [@@L1], ebx
	db '\%05i',0
	pop	ecx
	push	ebx
	call	@@3
	jc	@@2b
	call	_ArcTgaSave
	call	_ArcTgaFree
@@2b:	pop	ebx
	inc	ebx
	cmp	ebx, [@@L0]
	jbe	@@2a
@@2c:	clc
	leave
	ret

@@4:	cmp	ebx, 34h
	jb	@@9
	mov	edx, 'SggO'
	mov	ecx, 200h
	mov	eax, [esi]
	sub	edx, [esi+2Ch]
	sub	ecx, [esi+30h]
	sub	eax, 'VGO'
	or	edx, ecx
	or	eax, edx
	jne	@@9
	sub	ebx, 2Ch
	add	esi, 2Ch
	call	_ArcSetExt, 'ggo'
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@3:	mov	esi, [@@SB]
	mov	ecx, [@@SC]
	mov	eax, [esi+ebx*4+8]
	test	eax, eax
	je	@@3a
	sub	ecx, eax
	jb	@@3a
	add	esi, eax
	sub	ecx, 14h
	jb	@@3a
	mov	edi, [esi]
	mov	edx, [esi+4]
	mov	eax, edx
	shl	eax, 2
	sub	ecx, eax
	jb	@@3a
	call	_ArcTgaAlloc, 40h+23h, edi, edx
	jc	@@3a
	lea	edi, [eax+12h]
	mov	ecx, [esi+0Ch-2]
	mov	cx, [esi+8]
	mov	[edi-12h+8], ecx
	call	@@S25, edi, ebx, [@@SB], [@@SC]
	clc
	ret

@@3a:	stc
	ret

@@S25 PROC

@@DB = dword ptr [ebp+14h]
@@L0 = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@W = dword ptr [ebp-4]
@@H = dword ptr [ebp-8]
@@L1 = dword ptr [ebp-0Ch]
@@DC = dword ptr [ebp-10h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	eax, [@@L0]
	mov	esi, [@@SB]
	add	esi, [esi+eax*4+8]
	mov	edx, [esi+4]
	push	dword ptr [esi]
	push	edx
	add	esi, 14h
	push	esi
	push	ecx	; @@DC
@@1:	mov	edi, [@@DB]
	dec	[@@H]
	js	@@7
	mov	eax, [@@W]
	mov	esi, [@@L1]
	lea	edx, [edi+eax*4]
	mov	[@@DC], eax
	mov	[@@DB], edx
	lodsd
	mov	ecx, [@@SC]
	mov	[@@L1], esi
	sub	ecx, eax
	jb	@@1
	add	eax, [@@SB]
	sub	ecx, 2
	jb	@@1
	movzx	ebx, word ptr [eax]
	lea	esi, [eax+2]
	sub	ecx, ebx
	jae	$+4
	add	ebx, ecx
@@2:	cmp	[@@DC], 0
	je	@@1
	mov	edx, esi
	sub	edx, [@@SB]
	and	edx, 1
	add	edx, 2
	sub	ebx, edx
	jb	@@1
	add	esi, edx	
	mov	ecx, 7FFh
	movzx	eax, word ptr [esi-2]
	mov	edx, eax
	and	ecx, eax
	shr	edx, 0Bh
	shr	eax, 0Dh
	and	edx, 3
	sub	ebx, edx
	jb	@@9a
	add	esi, edx
	test	ecx, ecx
	jne	@@4c
	sub	ebx, 4
	jb	@@9a
	mov	ecx, [esi]
	add	esi, 4
@@4c:
	sub	[@@DC], ecx
	jb	@@9a
	dec	eax
	dec	eax
	jne	@@2b
	lea	edx, [ecx*2+ecx]
	test	ecx, ecx
	je	@@2
	sub	ebx, edx
	jb	@@9a
	mov	al, 0FFh
@@2a:	movsb
	movsb
	movsb
	stosb
	dec	ecx
	jne	@@2a
	jmp	@@2

@@9a:	jmp	@@1

@@2b:	dec	eax
	jne	@@2d
	sub	ebx, 3
	jb	@@9a
	add	esi, 3
	test	ecx, ecx
	je	@@2
	sub	esi, 3
	mov	al, 0FFh
	movsb
	movsb
	movsb
	stosb
@@2c:	dec	ecx
	je	@@2
	push	esi
	lea	esi, [edi-4]
	rep	movsd
	pop	esi
	jmp	@@2

@@2d:	dec	eax
	jne	@@2f
	mov	edx, ecx
	test	ecx, ecx
	je	@@2
	shl	edx, 2
	sub	ebx, edx
	jb	@@9a
@@2e:	lodsd
	ror	eax, 8
	stosd
	dec	ecx
	jne	@@2e
	jmp	@@2

@@2f:	dec	eax
	jne	@@2g
	sub	ebx, 4
	jb	@@9a
	lodsd
	test	ecx, ecx
	je	@@2
	ror	eax, 8
	stosd
	jmp	@@2c

@@2g:	xor	eax, eax
	rep	stosd
	jmp	@@2

@@7:	xor	esi, esi
@@9:	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

@@S25A PROC	; yougaku.exe 00403430

@@SB = dword ptr [ebp+14h]
@@SC = dword ptr [ebp+18h]
@@L0 = dword ptr [ebp+1Ch]

@@W = dword ptr [ebp-4]
@@H = dword ptr [ebp-8]
@@L1 = dword ptr [ebp-0Ch]
@@DC = dword ptr [ebp-10h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	eax, [@@L0]
	mov	esi, [@@SB]
	mov	ecx, [@@SC]
	mov	eax, [esi+eax*4+8]
	test	eax, eax
	je	@@9
	sub	ecx, eax
	jb	@@9
	add	esi, eax
	sub	ecx, 14h
	jb	@@9
	cmp	dword ptr [esi+10h], 0
	jns	@@9
	mov	edx, [esi+4]
	push	dword ptr [esi]
	push	edx
	add	esi, 14h
	sub	edx, 2
	push	esi
	sub	ecx, edx
	jb	@@9
	push	ecx	; @@DC
@@1:	dec	[@@H]
	js	@@7
	mov	eax, [@@W]
	mov	esi, [@@L1]
	mov	[@@DC], eax
	lodsd
	mov	ecx, [@@SC]
	mov	[@@L1], esi
	sub	ecx, eax
	jb	@@1
	add	eax, [@@SB]
	sub	ecx, 2
	jb	@@1
	movzx	ebx, word ptr [eax]
	lea	esi, [eax+2]
	sub	ecx, ebx
	jae	$+4
	add	ebx, ecx
@@2:	cmp	[@@DC], 0
	je	@@1
	mov	edx, esi
	sub	edx, [@@SB]
	and	edx, 1
	add	edx, 2
	sub	ebx, edx
	jb	@@1
	add	esi, edx	
	mov	ecx, 7FFh
	movzx	eax, word ptr [esi-2]
	mov	edx, eax
	and	ecx, eax
	shr	edx, 0Bh
	shr	eax, 0Dh
	and	edx, 3
	sub	ebx, edx
	jb	@@9a
	add	esi, edx
	test	ecx, ecx
	jne	@@4c
	sub	ebx, 4
	jb	@@9a
	mov	ecx, [esi]
	add	esi, 4
@@4c:
	sub	[@@DC], ecx
	jb	@@9a
	dec	eax
	dec	eax
	jne	@@2b
	lea	edx, [ecx*2+ecx]
	test	ecx, ecx
	je	@@2
	sub	ebx, edx
	jb	@@9a
	add	esi, 3
	dec	ecx
	je	@@2
	lea	ecx, [ecx*2+ecx]
@@2a:	mov	al, [esi-3]
	add	[esi], al
	inc	esi
	dec	ecx
	jne	@@2a
	jmp	@@2

@@9a:	jmp	@@1

@@2b:	dec	eax
	jne	@@2d
	sub	ebx, 3
	jb	@@9a
	add	esi, 3
	jmp	@@2

@@2d:	dec	eax
	jne	@@2f
	mov	edx, ecx
	test	ecx, ecx
	je	@@2
	shl	edx, 2
	sub	ebx, edx
	jb	@@9a
	add	esi, 4
	dec	ecx
	je	@@2
	shl	ecx, 2
@@2e:	mov	al, [esi-4]
	add	[esi], al
	inc	esi
	dec	ecx
	jne	@@2e
	jmp	@@2

@@2f:	dec	eax
	jne	@@2
	sub	ebx, 4
	jb	@@9a
	add	esi, 4
	jmp	@@2

@@7:	xor	esi, esi
@@9:	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

ENDP
