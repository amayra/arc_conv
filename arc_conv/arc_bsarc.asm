
; "Manin Densha 2", "Ura Kyoushi ~Haitoku no Inetsu Jugyou~" *.bsa
; demo.exe
; 004B31B0 bsg_unpack

	dw _conv_bsarc-$-2
_arc_bsarc PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L1, 0Ch

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	sub	eax, 'rASB'
	sub	edx, 'c'
	or	eax, edx
	jne	@@9a
	pop	edi
	pop	ebx
	movzx	ecx, di
	shr	edi, 10h
	je	@@9a
	mov	[@@N], edi
	dec	ecx
	sub	ecx, 2
	je	_mod_bsarc3
	jae	@@9a
	call	_FileSeek, [@@S], ebx, 0
	jc	@@9a
	imul	ebx, edi, 28h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	eax, [esi+20h]
	and	eax, NOT 10h
	jne	@@9
	call	@@5
	call	_ArcCount, ebx

	mov	[@@L1+4], esp
	sub	esp, 200h
	mov	[@@L1], esp
	mov	[@@L1+8], esp

@@1:	xor	eax, eax
	lea	ecx, [eax+20h]
	mov	edi, edx
	repne	scasb
	jne	@@1b
	mov	edx, esi
	mov	al, [esi]
	mov	edi, [@@L1+8]
	cmp	al, 3Ch
	jne	@@1c
	cmp	esp, [@@L1]
	je	@@8
	pop	[@@L1+8]
	jmp	@@8

@@1c:	cmp	al, 3Eh
	jne	@@1d
	mov	eax, [@@L1]
	sub	eax, esp
	shr	eax, 6
	jne	@@9
	inc	edx
	push	edi
	call	@@3
	mov	al, 2Fh
	cmp	edi, [@@L1+4]
	je	$+3
	stosb
	mov	[@@L1+8], edi
	jmp	@@8

@@1d:	call	@@3
	cmp	edi, [@@L1+4]
	je	@@1b
	call	_ArcName, [@@L1], -1
@@1b:	and	[@@D], 0
	mov	eax, [esi+20h]
	mov	ebx, [esi+24h]
	test	eax, eax
	je	@@8
	call	_FileSeek, [@@S], eax, 0
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

@@3:	mov	al, [edx]
	inc	edx
	cmp	edi, [@@L1+4]
	je	@@3a
	stosb
	test	al, al
	jne	@@3
	dec	edi
@@3a:	ret

@@5:	push	esi
	xor	ebx, ebx
@@5a:	mov	al, [esi]
	cmp	al, 3Ch	; <
	je	@@5b
	cmp	al, 3Eh	; >
	je	@@5b
	inc	ebx
@@5b:	add	esi, 28h
	dec	edi
	jne	@@5a
	pop	esi
	ret
ENDP

_mod_bsarc3 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L1, 0Ch
@M0 @@L0, 8

	lea	esp, [ebp-@@stk]
	call	_FileGetSize, [@@S]
	jc	@@9a
	imul	ecx, edi, 0Ch
	mov	[@@L0], ecx
	sub	eax, ebx
	jb	@@9a
	cmp	eax, ecx
	jb	@@9a
	xchg	ebx, eax
	call	_FileSeek, [@@S], eax, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	edx, [@@L0]
	mov	esi, [@@M]
	sub	ebx, edx
	add	edx, esi
	mov	[@@L0+4], ebx
	mov	[@@L0], edx

	mov	eax, [esi+4]
	and	eax, NOT 10h
	or	eax, [esi]
	jne	@@9
	mov	edx, [@@L0]
	mov	ecx, [@@L0+4]
	call	@@5
	call	_ArcCount, ebx

	mov	[@@L1+4], esp
	sub	esp, 200h
	mov	[@@L1], esp
	mov	[@@L1+8], esp

@@1:	mov	ecx, [@@L0+4]
	mov	edx, [esi]
	sub	ecx, edx
	jbe	@@1b
	add	edx, [@@L0]
	xor	eax, eax
	mov	edi, edx
	repne	scasb
	jne	@@1b
	mov	al, [edx]
	mov	edi, [@@L1+8]
	cmp	al, 3Ch
	jne	@@1c
	cmp	esp, [@@L1]
	je	@@8
	pop	[@@L1+8]
	jmp	@@8

@@1c:	cmp	al, 3Eh
	jne	@@1d
	mov	eax, [@@L1]
	sub	eax, esp
	shr	eax, 6
	jne	@@9
	inc	edx
	push	edi
	call	@@3
	mov	al, 2Fh
	cmp	edi, [@@L1+4]
	je	$+3
	stosb
	mov	[@@L1+8], edi
	jmp	@@8

@@1d:	call	@@3
	cmp	edi, [@@L1+4]
	je	@@1b
	call	_ArcName, [@@L1], -1
@@1b:	and	[@@D], 0
	mov	eax, [esi+4]
	mov	ebx, [esi+8]
	test	eax, eax
	je	@@8
	call	_FileSeek, [@@S], eax, 0
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

@@3:	mov	al, [edx]
	inc	edx
	cmp	edi, [@@L1+4]
	je	@@3a
	stosb
	test	al, al
	jne	@@3
	dec	edi
@@3a:	ret

@@5:	push	esi
	xor	ebx, ebx
@@5a:	mov	eax, [esi]
	cmp	ecx, eax
	jbe	@@1b
	mov	al, [edx+eax]
	cmp	al, 3Ch	; <
	je	@@5b
	cmp	al, 3Eh	; >
	je	@@5b
	inc	ebx
@@5b:	add	esi, 0Ch
	dec	edi
	jne	@@5a
	pop	esi
	ret
ENDP

_conv_bsarc PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'gsb'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	cmp	ebx, 40h
	jb	@@9
	push	4
	pop	ecx
	call	@@1a
	db 'BSS-Composition',0
@@1a:	pop	edi
	rep	cmpsd
	je	@@2
@@1b:	call	@@3
	jc	@@9
	call	@@4
	leave
	ret

@@2:	movzx	edi, byte ptr [esi+1]
	add	[@@SB], 20h
	sub	[@@SC], 20h
	dec	edi
	je	@@1b
	js	@@9
	push	edi	; @@L0
	call	_ArcSetExt, 0
	push	edx	; @@L1
	xor	ebx, ebx
@@2a:	call	_ArcNameFmt, [@@L1], ebx
	db '\%05i',0
	pop	ecx
	push	ebx
	call	@@3
	jc	@@2c
	call	@@4
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

@@3:	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 40h
	jb	@@3b
	push	4
	pop	ecx
	call	@@3a
	db 'BSS-Graphics',0,0,0,0
@@3a:	pop	edi
	rep	cmpsd
	jne	@@3b
	sub	esi, 10h
	mov	eax, [esi+32h]
	mov	ecx, [esi+36h]
	cmp	eax, 40h
	jb	@@3b
	sub	ebx, eax
	jb	@@4a
	add	eax, esi
	sub	ebx, ecx
	jb	@@4a
	add	eax, ecx
	mov	[@@SC], ebx
	mov	[@@SB], eax
	; 2,1 -> 8
	; 1,1 -> 24
	; 0,1 -> 32
	movzx	ecx, word ptr [esi+30h]
	dec	ch
	jne	@@3b
	cmp	ecx, 3
	jae	@@3b
	neg	ecx
	add	ecx, 3
	cmp	ecx, 2
	sbb	ecx, 0
	clc
	ret

@@3b:	stc
	ret

@@4:	movzx	edi, word ptr [esi+16h]
	movzx	edx, word ptr [esi+18h]
	mov	ebx, edi
	imul	ebx, edx
	push	ecx
	add	ecx, 40h
	call	_ArcTgaAlloc, ecx, edi, edx
	pop	ecx
	jc	@@4a
	lea	edi, [eax+12h]
	mov	eax, [esi+20h]
	mov	[edi-12h+8], eax
	mov	edx, [esi+32h]
	add	edx, esi
	call	@@Unpack, edi, ebx, edx, dword ptr [esi+36h], ecx
	clc
@@4a:	ret

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]

@@L1 = dword ptr [ebp-4]
@@L2 = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ebx, [@@L0]
	push	0
@@2:	mov	ecx, [@@SC]
	mov	esi, [@@SB]
	sub	ecx, 4
	jb	@@9
	lodsd
	mov	edi, [@@DB]
	sub	ecx, eax
	jae	$+6
	add	eax, ecx
	xor	ecx, ecx
	mov	edx, eax
	add	eax, esi
	mov	[@@SC], ecx
	mov	[@@SB], eax
	add	edi, [@@L1]
	push	[@@DC]

@@1:	dec	edx
	js	@@7
	lodsb
	movzx	ecx, al
	test	al, al
	jns	@@1b
	not	cl
	inc	ecx
	inc	ecx
	dec	edx
	js	@@7
	lodsb
	sub	[@@L2], ecx
	jb	@@7
@@1a:	stosb
	add	edi, ebx
	dec	ecx
	jne	@@1a
	jmp	@@1

@@1b:	inc	ecx
	sub	[@@L2], ecx
	jb	@@7
	sub	edx, ecx
	jb	@@7
@@1c:	movsb
	add	edi, ebx
	dec	ecx
	jne	@@1c
	jmp	@@1

@@7:	inc	[@@L1]
	pop	ecx
	cmp	[@@L1], ebx
	jbe	@@2
	xor	esi, esi
@@9:	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

ENDP

