
; "Sora wo Tobu, 7tsu Me no Mahou" *.gyu
; courier_7.exe
; 0041820A gyu_decode
; 0042EBA0 unpack3

; "Angel Ring"
; AngelRing.exe
; 0041B960 gyu_decode
; 0041B840 byte_swap
; resident.dll
; 1007FBF0 gyu_decode
; 10099480 ?dk@RetouchSystem@@MAEKHH@Z
; sc00.dll
; 100016C0 gyu_decode

; 0x2FFED837 res\g\ev\10\1002.gyu
; 0x49C26EE1 res\g\ev\10\1010.gyu
; 0xCEE98560 res\g\ev\10\1011.gyu
; 0x0A359900 res\g\ev\10\1012.gyu
; 0x0DFED0E2 res\g\ev\10\1013.gyu

; "retouch", "ExHIBIT"

; "Sora-iro no Organ"
; 1002E590 ?dk@RetouchSystem@@MAEKHHH@Z

	dw _conv_gyu-$-2
_arc_gyu:
	ret
_conv_gyu PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L2 = dword ptr [ebp-4]
@@L0 = dword ptr [ebp-8]
@@L1 = dword ptr [ebp-0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'ggo'
	je	@@4
	cmp	eax, 'uyg'
	jne	@@9
	mov	ecx, ebx
	sub	ebx, 24h
	jb	@@9
	mov	eax, [esi+0Ch]
	cmp	dword ptr [esi], 1A555947h
	jne	@@9
	mov	edi, [esi+18h]
	mov	ecx, [esi+20h]
	add	edi, [esi+1Ch]
	jc	@@9
	cmp	eax, 8
	je	@@1
	sub	eax, 18h
	or	eax, ecx
	jne	@@9
	cmp	ebx, edi
	je	@@2
@@9:	stc
	leave
	ret

@@4:	cmp	ebx, 8
	jb	@@9
	mov	eax, [esi]
	mov	edx, [esi+4]
	rol	eax, 2
	rol	edx, 0Fh
	xor	dh, 2
	xor	eax, edx
	cmp	eax, 'SggO'
	jne	@@9
	call	@@OggDecrypt, edx, esi, ebx
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@1:	mov	eax, ecx
	dec	ecx
	shl	eax, 2
	shr	ecx, 8
	jne	@@9
	sub	ebx, eax
	jb	@@9
	cmp	ebx, edi
	jne	@@9
@@2:	mov	edi, [esi+10h]
	mov	edx, [esi+14h]
	mov	ebx, edi
	mov	ecx, [esi+0Ch]
	mov	eax, [esi+1Ch]
	ror	ecx, 3
	imul	ebx, ecx
	lea	ecx, [ecx+18h+4-1]
	test	eax, eax
	je	$+4
	mov	cl, 3

	add	ebx, 3
	and	ebx, -4
	imul	ebx, edx
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	mov	eax, [esi+10h]
	mov	ecx, [esi+20h]
	imul	eax, [esi+14h]
	shl	eax, 2
	sub	eax, ebx
	cmp	dword ptr [esi+1Ch], 0
	jne	@@1f
	mov	eax, ecx
	shl	eax, 2
@@1f:	push	dword ptr [esi+4]	; @@L2
	push	eax			; @@L0

	mov	edx, [esi+8]
	mov	eax, [esi+18h]
	lea	esi, [esi+24h+ecx*4]
	push	eax
	push	esi

	push	eax
	push	esi
	add	esi, eax

	test	edx, edx
	jne	$+7
	call	@@ReadKey
	call	@@Decode, edx
	mov	eax, [@@L0]
	mov	[@@L0], esi
	lea	esi, [edi+eax]
	mov	al, byte ptr [@@L2+3]
	call	@@Unpack, esi, ebx
	mov	ebx, [@@SB]
	push	dword ptr [ebx+14h]	; @@L1
	push	edi
@@CheckPal PROC
	mov	ecx, [ebx+20h]
	cmp	dword ptr [ebx+0Ch], 8
	jne	@@9
	xor	edx, edx
@@1:	cmp	dword ptr [ebx+24h+edx*4], 0
	jne	@@9
	inc	edx
	cmp	edx, ecx
	jne	@@1
	xor	edx, edx
@@2:	imul	eax, edx, 10101h
	mov	[ebx+24h+edx*4], eax
	inc	edx
	cmp	edx, ecx
	jne	@@2
@@9:
ENDP
	cmp	dword ptr [ebx+1Ch], 0
	jne	@@1b
	mov	edx, [ebx+0Ch]
	cmp	edx, 8
	jne	@@5a
	mov	[edi-12h+5], cx
	push	esi
	lea	esi, [ebx+24h]
	rep	movsd
	pop	esi
@@5a:	ror	edx, 3
	imul	edx, [ebx+10h]
	mov	eax, edx
	neg	eax
	and	eax, 3
	je	@@5c
@@5b:	mov	ecx, edx
	rep	movsb
	add	esi, eax
	dec	[@@L1]
	jne	@@5b
@@5c:	clc
	leave
	ret

@@1b:	mov	ecx, [ebx+10h]
	cmp	dword ptr [ebx+0Ch], 8
	je	@@1d
	mov	al, 0FFh
@@1c:	movsb
	movsb
	movsb
	stosb
	dec	ecx
	jne	@@1c
	mov	eax, [ebx+10h]
	jmp	@@1e

@@1d:	movzx	eax, byte ptr [esi]
	inc	esi
	cmp	eax, [ebx+20h]
	sbb	edx, edx
	and	eax, edx
	mov	eax, [ebx+24h+eax*4]
	xor	eax, 0FF000000h
	stosd
	dec	ecx
	jne	@@1d
	mov	eax, [ebx+10h]
	neg	eax
@@1e:	and	eax, 3
	add	esi, eax
	dec	[@@L1]
	jne	@@1b
	pop	edi
	mov	eax, [ebx+1Ch]
	test	eax, eax
	je	@@5c

	mov	[@@SC], eax
	mov	esi, [ebx+10h]
	add	esi, 3
	and	esi, -4
	imul	esi, [ebx+14h]
	call	_MemAlloc, esi
	jc	@@2d
	xchg	esi, eax
	mov	dl, byte ptr [@@L2+3]
	call	@@Unpack, esi, eax, [@@L0], [@@SC]
	push	esi
	mov	edx, [ebx+14h]
@@2a:	mov	ecx, [ebx+10h]
@@2b:	movzx	eax, byte ptr [esi]
	inc	esi
	cmp	byte ptr [ebx+4], 1
	jne	@@2c
	imul	eax, 0FFh
	shr	eax, 4
@@2c:	add	edi, 3
	stosb
	dec	ecx
	jne	@@2b
	mov	eax, [ebx+10h]
	neg	eax
	and	eax, 3
	add	esi, eax
	dec	edx
	jne	@@2a
	call	_MemFree
@@2d:	clc
	leave
	ret

@@OggDecrypt PROC	; PrincessEvangileWEB.exe 101AEE20
	mov	edx, esp
	push	ebx
	push	esi
	push	edi
	mov	esi, [edx+4]
	mov	edi, [edx+8]
	mov	ebx, [edx+0Ch]
	mov	eax, 200h
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	xor	edx, edx
	shr	ebx, 2
	je	@@9
@@1:	mov	eax, [edi]
	mov	cl, [@@T+edx]
	inc	edx
	rol	eax, cl
	and	edx, 7
	xor	eax, esi
	stosd
	dec	ebx
	jne	@@1
@@9:	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@T	db 02h,0Fh,07h,0Bh,01h,0Fh,17h,03h
ENDP

@@Decode PROC

@@K = dword ptr [ebp+14h]
@@D = dword ptr [ebp+18h]
@@C = dword ptr [ebp+1Ch]

	push	ebx
	push	esi
	push	edi
	enter	270h*4, 0
	mov	eax, [@@K]
	cmp	eax, -1
	je	@@9
	call	_twister_init
	cmp	[@@C], 0
	je	@@9
	mov	esi, [@@D]
@@2:	call	_twister_next
	xor	edx, edx
	div	[@@C]
	mov	[@@K], edx
	call	_twister_next
	xor	edx, edx
	div	[@@C]
	mov	edi, [@@K]
	mov	al, [esi+edx]
	mov	cl, [esi+edi]
	mov	[esi+edi], al
	mov	[esi+edx], cl
	cmp	ebx, 0Ah*2
	jb	@@2
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

@@Unpack PROC		; "Harukaze dori ni, Tomarigi wo. 2nd Story" resident.dll 1016E020

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	cmp	al, 1
	je	_null_unpack
	cmp	al, 8
	jne	_lzss_unpack
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
	sub	[@@SC], 4
	jb	@@9
	lodsd		; size_be
@@1a:	dec	[@@DC]
	js	@@9
	dec	[@@SC]
	js	@@9
	movsb
@@1:	call	@@3
	jc	@@1a
	dec	[@@SC]
	js	@@9
	or	edx, -1
	call	@@3
	jc	@@1b
	xor	ecx, ecx
	call	@@3
	adc	ecx, ecx
	call	@@3
	adc	ecx, ecx
	mov	dl, [esi]
	inc	esi
	jmp	@@1c

@@1b:	dec	[@@SC]
	js	@@9
	mov	dh, [esi]
	inc	esi
	mov	dl, [esi]
	inc	esi
	mov	ecx, edx
	sar	edx, 3
	and	ecx, 7
	jne	@@1c
	dec	[@@SC]
	js	@@9
	mov	cl, [esi]
	inc	esi
	dec	ecx
	js	@@7
@@1c:	inc	ecx
	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@7:	mov	esi, [@@DC]
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

@@ReadKey PROC
	push	ebx
	push	esi
	call	_ArcLocal, offset _ArcLocalMem
	xchg	ebx, eax
	jnc	@@1a
	and	dword ptr [ebx], 0
	call	_ArcParamNum, 0
	db 'gyu_key', 0
	mov	[ebx+4], eax
	jnc	@@1a
	call	_ArcParam
	db 'gyu', 0
	jnc	@@4a
	call	@@4c
	db 'rld\def.rld', 0
@@4c:	pop	esi
	lea	edx, [esi+4]
	call	_LocalFileCreate, edx, FILE_INPUT
	jnc	@@4b
	call	_LocalFileCreate, esi, FILE_INPUT
	jmp	@@4b

@@4a:	call	_FileCreate, eax, FILE_INPUT
@@4b:	jc	@@1a
	xchg	esi, eax
	call	@@2
	call	_FileClose, esi
@@1a:	cmp	dword ptr [ebx], 0
	jne	@@1b
@@9:	mov	edx, [ebx+4]
	pop	esi
	pop	ebx
	ret

@@1b:	call	_unicode_name, offset outFileNameW
	xchg	esi, eax
	xor	eax, eax
	cdq
	lea	ecx, [eax+4]
@@1c:	lodsw
	sub	eax, 30h
	cmp	eax, 0Ah
	jae	@@9
	lea	edx, [edx*4+edx]
	lea	edx, [edx*2+eax]
	dec	ecx
	jne	@@1c
	lodsw
	sub	eax, 30h
	cmp	eax, 0Ah
	jb	@@9
	mov	esi, [ebx+8]
	cmp	edx, [ebx+0Ch]
	jae	@@9
	mov	edx, [esi+edx*4]
	pop	esi
	pop	ebx
	ret

@@2:	call	_FileGetSize, esi
	jc	@@2c
	push	eax
	call	_MemAlloc, eax
	pop	ecx
	jc	@@2c
	mov	[ebx], eax
	call	_FileRead, esi, eax, ecx
	jc	@@2a
	mov	edx, [ebx]
	cmp	eax, 2710h*4
	je	@@2b
	call	_exhibit_scan, edx, eax
	jc	@@2a
@@2b:	shr	eax, 2
	mov	[ebx+8], edx
	mov	[ebx+0Ch], eax
@@2c:	ret

@@2a:	call	_MemFree, dword ptr [ebx]
	and	dword ptr [ebx], 0
	ret
ENDP

ENDP
