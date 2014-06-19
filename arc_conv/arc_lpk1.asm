
; "SHUFFLE Essence" *.lpk
; SHFL_EP.EXE
; 004340EF->00488960 vm_set_key
; 004889A0 open_archive
; 00489400 seek
; 00489590 read
; 004980C0 unpack
; 00489180 name_unpack
; 00505F8C,00505F94 key1,key2
; 004C0750 elg24_unpack
; 004BEAB0 elg8_unpack

; 00000000 00000000 "SCRIPT"
; a3635fc4 a14a4686 "SYS"
; 4e34463c b4d8bd6d "CHR"
; f592b54b accd3a1c "PIC"
; c50d2fd6 c89de7a9 "BGM"
; e9cd4e1b 98ad9d63 "SE"
; 865a8d4e 742da395 "VOICE"
; cea56246 de46f9a6 "DATA"

; "Nekonade Distortion" *.lpk
; NEKONADE.EXE
; 0048E42B archivekey
; 00535540,00535548 key1,key2
; 0048F7D0 elg2_header
; 004EF250 elg24_unpack

; 00000000 00000000 "SCRIPT"
; 9D458B89 A648DA2B "SYS"
; 9DFE1FAA 782A896E "CHR"
; 6C34F79D D3875EAE "PIC"
; 4791D74E 5DE352C9 "BGM"
; C54F3A63 B37D7953 "SE"
; E1B4DF49 AFBD5FDA "VOICE"
; A7F63C5A 46B96D96 "DATA"

	dw _conv_lpk1-$-2
_arc_lpk1 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC
@M0 @@Name
@M0 @@L0
@M0 @@L1
@M0 @@L2
@M0 @@L3
@M0 @@L4
@M0 @@I

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	pop	eax
	cmp	eax, '1KPL'
	jne	@@9a
	push	8+7
	pop	ecx
@@3a:	mov	eax, [esi+8]
	xor	eax, [@@T+ecx*8-4]
	shr	eax, 12h
	je	@@3b
	dec	ecx
	jne	@@3a
	jmp	@@9a
@@3b:	mov	eax, [@@T+ecx*8-8]
	mov	edx, [@@T+ecx*8-4]
;	call	@@3
	mov	[@@L0], eax	; key1
	pop	eax
	mov	ebx, 0FFFFFFh
	xor	eax, edx
	mov	[@@L1], eax
	push	edx		; key2
	and	ebx, eax
	shr	eax, 19h	; bt eax, 18h
	jnc	@@2a
	shl	ebx, 0Bh
	sub	ebx, 8
@@2a:	shr	eax, 4		; and eax, NOT 1Fh
	jne	@@9a
	cmp	ebx, 5
	jb	@@9a
	lea	ecx, [ebx-4]
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 4, ecx, 0
	jc	@@9
	mov	edx, [esi+8]
	mov	esi, [@@M]
	mov	[@@SC], ebx
	mov	[esi], edx
	pop	eax		; key2
	mov	ecx, 31746285h
	shr	ebx, 2
@@2b:	rol	ecx, 4
	xor	[esi], eax
	ror	eax, cl
	add	esi, 4
	dec	ebx
	jne	@@2b
	mov	esi, [@@M]
	mov	eax, [esi]	; file count
	mov	[@@N], eax
	shr	eax, 14h
	jne	@@9b
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, [@@SC]

	movzx	ecx, byte ptr [esi+4]
	mov	[@@L3], ecx
	add	ecx, 5
	sub	[@@SC], ecx
	jb	@@9b
	add	esi, ecx

	sub	[@@SC], 5
	jb	@@9
	mov	ebx, [esi+1]
	sub	[@@SC], ebx
	jb	@@9
	add	esi, 5
	call	@@Unpack, 0, [@@N], esi
	test	eax, eax
	je	@@9b
	xchg	edi, eax
	call	_MemAlloc, edi
	jc	@@9b
	mov	[@@Name], eax
	call	@@Unpack, eax, [@@N], esi
	mov	ecx, [@@N]
	mov	edx, [@@Name]
	shl	ecx, 2
	sub	edi, ecx
	add	edx, ecx
	call	_ArcDbgData, edx, edi
	add	esi, ebx

	bt	[@@L1], 1Bh
	sbb	eax, eax
	and	eax, 4
	add	eax, 9
	mov	[@@L2], eax

	and	[@@I], 0
@@1:	mov	eax, [@@I]
	mov	edx, [@@Name]
	call	_ArcName, dword ptr [edx+eax*4], -1
	mov	ecx, [@@L2]
	sub	[@@SC], ecx
	jb	@@9
	and	[@@D], 0
	mov	ebx, [esi+5]
	xor	eax, eax
	cmp	ecx, 0Dh
	jb	@@1d
	mov	edx, [esi+9]
	test	edx, edx
	je	@@1d
	cmp	edx, ebx
	je	@@1d
	xchg	eax, edx
	xchg	eax, ebx
@@1d:	mov	[@@L4], eax

	mov	eax, [esi+1]
	bt	[@@L1], 18h
	jnc	@@1c
	shl	eax, 0Bh
@@1c:	test	eax, eax
	je	@@8
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	mov	ecx, [@@L4]
	mov	edi, [@@L3]
	mov	[@@L4], ebx
	sub	ebx, edi
	jae	$+4
	xor	ebx, ebx
	lea	eax, [@@D]
	test	ecx, ecx
	je	@@4a
	call	_ArcMemRead, eax, ebx, ecx, 0
	add	edi, [@@D]
	call	_lzss_unpack, edi, ebx, edx, eax
	jmp	@@4b

@@4a:	call	_ArcMemRead, eax, edi, ebx, 0
	mov	edi, edx
@@4b:	xchg	ebx, eax
	cmp	[@@D], 0
	je	@@1a
	test	ebx, ebx
	je	@@1e
	cmp	byte ptr [esi], 0
	je	@@2d
	mov	edx, ebx
@@2c:	mov	al, [edi]
	xor	al, 5Dh
	rol	al, 4
	mov	[edi], al
	inc	edi
	dec	edx
	jne	@@2c
	sub	edi, ebx
@@2d:	bt	[@@L1], 1Ah
	jnc	@@1e
	mov	edx, ebx
	push	40h
	pop	eax
	shr	edx, 2
	je	@@1e
	cmp	edx, eax
	jb	$+3
	xchg	edx, eax
	mov	ecx, 31746285h
	mov	eax, [@@L0]
@@2e:	ror	ecx, 4
	xor	[edi], eax
	rol	eax, cl
	add	edi, 4
	dec	edx
	jne	@@2e
@@1e:	mov	ecx, [@@L3]
	mov	eax, [@@L4]
	cmp	ecx, eax
	jb	$+3
	xchg	ecx, eax
	mov	edi, [@@D]
	add	ebx, ecx
	push	esi
	mov	esi, [@@M]
	add	esi, 5
	rep	movsb
	pop	esi
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	add	esi, [@@L2]
	inc	[@@I]
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@Name]
@@9b:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]
@@SC = dword ptr [ebp-0Ch]

	push	ebx
	push	esi
	push	edi
	enter	20Ch, 0
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	mov	ecx, [@@DC]
	xor	eax, eax
	test	edi, edi
	je	@@3a
	rep	stosd
@@3a:	lea	edi, [edi+ecx*4]
	mov	ecx, [esi-4]
	mov	al, [esi-5]
	mov	[@@SC], ecx
	mov	[@@L1], edi
	neg	eax
	sbb	eax, eax
	and	eax, 2
	inc	eax
	inc	eax
	mov	[@@L0], eax	; 2, 4
	mov	edi, esp
	or	ecx, -1
	call	@@1
	mov	eax, [@@L1]
	sub	eax, [@@DB]
@@8:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@9:	xor	eax, eax
	jmp	@@8

@@1:	mov	eax, esi
	inc	ecx
	sub	eax, [@@SB]
	cmp	ecx, 200h
	jae	@@9
	sub	eax, [@@SC]
	jae	@@9
	movzx	eax, byte ptr [esi]
	inc	esi
	test	eax, eax
	je	@@1a
@@2:	push	eax
	mov	eax, esi
	sub	eax, [@@SB]
	sub	eax, [@@SC]
	jae	@@9
	add	eax, [@@L0]
	jc	@@9
	lodsb
	mov	[edi+ecx], al
	movzx	edx, word ptr [esi]
	cmp	[@@L0], 2
	je	@@2a
	mov	edx, [esi]
	add	esi, 2
@@2a:	add	esi, 2
	push	esi
	test	al, al
	jne	@@2b
	cmp	edx, [@@DC]
	jae	@@9
	mov	esi, edi
	mov	eax, [@@DB]
	push	edi
	mov	edi, [@@L1]
	push	ecx
	inc	ecx
	test	eax, eax
	je	@@2d
	mov	[eax+edx*4], edi
	rep	movsb
@@2d:	add	edi, ecx
	pop	ecx
	mov	[@@L1], edi
	pop	edi
	jmp	@@2c

@@2b:	add	esi, edx
	call	@@1
@@2c:	pop	esi
	pop	eax
	dec	eax
	jne	@@2
@@1a:	dec	ecx
	ret
ENDP

if 0
@@3:	push	ebx
	push	edi
	mov	ecx, offset inFileName
@@3a:	mov	edi, ecx
@@3b:	movzx	eax, word ptr [ecx]
	inc	ecx
	inc	ecx
	cmp	eax, '\'
	je	@@3a
	test	eax, eax
	jne	@@3b
	xor	ebx, ebx
	xor	ecx, ecx
@@3c:	movzx	eax, word ptr [edi]
	inc	edi
	inc	edi
	cmp	eax, '.'
	je	@@3d
	test	eax, eax
	je	@@3d
	sub	eax, 61h
	cmp	eax, 1Ah
	sbb	edx, edx
	add	eax, 61h
	and	edx, -20h
	add	eax, edx
	xor	ebx, eax
	add	ecx, 7
	rol	ebx, 7
	jmp	@@3c

@@3d:	mov	edx, 9A639DE5h
	mov	eax, 0DCD635D2h		; rol32(0xA5B9AC6B,7)
	rol	edx, cl
	add	ecx, 7
	xor	edx, ebx
	xor	eax, ebx
	ror	eax, cl
	pop	edi
	pop	ebx
	ret
endif

	; "SHUFFLE Essence"
@@T	dd 0A8E7FAF1h,0A742F274h	; SCRIPT
	dd 0C9669AE9h,0178F6375h	; SYS
	dd 004758B11h,00019D81Eh	; CHR
	dd 099D7F066h,01A6C17EFh	; PIC
	dd 08D701AFBh,07C7F4D5Ah	; BGM
	dd 0FF77D8FDh,07FC0197Bh	; SE
	dd 0FFD3F4FBh,05E01AC8Dh	; VOICE
	dd 01C3900ECh,0CFD5E0FCh	; DATA

	; "Nekonade Distortion"
;	dd 0A8E7FAF1h,0A742F274h	; SCRIPT
	dd 0F7404EA4h,0108DFFD8h	; SYS
	dd 0D7BFD287h,0CCEBEC1Dh	; CHR
	dd 00071B2B0h,06526735Dh	; PIC
	dd 00FECE263h,0E901F83Ah	; BGM
	dd 0D3F5AC85h,05410FD4Bh	; SE
	dd 0983DA6FCh,0859150C2h	; VOICE
	dd 0756A5EF0h,0572A74CCh	; DATA
ENDP

_conv_lpk1 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'gle'
	jne	@@9
	sub	ebx, 8
	jae	@@1
@@9:	stc
	leave
	ret

@@1:	lodsd
	sub	eax, 'GLE'
	xor	edx, edx
	rol	eax, 8
	cmp	al, 2
	jne	@@1c
	sub	ebx, 5
	jb	@@9
	lodsb
	mov	ecx, [esi]
	mov	edx, [esi+4]
	add	esi, 8
	push	ecx
@@1d:	dec	ebx
	js	@@9
	movzx	ecx, byte ptr [esi]
	inc	esi
	test	ecx, ecx
	je	@@1b
	sub	ebx, 4
	jb	@@9
	mov	ecx, [esi]
	add	esi, ecx
	sub	ecx, 4
	jb	@@9
	sub	ebx, ecx
	jb	@@9
	jmp	@@1d

@@1c:	cmp	al, 1
	jne	@@1a
	sub	ebx, 5
	jb	@@9
	lodsb
	mov	edx, [esi]
	add	esi, 4
@@1a:	mov	ecx, [esi]
	add	esi, 4
	push	ecx
@@1b:	ror	eax, 3
	dec	eax
	cmp	eax, 4
	jae	@@9
	mov	[@@SC], ebx
	lea	ecx, [eax+38h]
	push	eax	; @@L1
	dec	eax		; 16
	je	@@9
	push	edx
	movzx	edi, word ptr [@@L0]
	movzx	edx, word ptr [@@L0+2]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	pop	dword ptr [edi+8]
	call	@@Unpack, edi, ebx, esi, [@@SC], [@@L1]
	clc
	leave
	ret

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L1 = dword ptr [ebp+24h]

@@L0 = dword ptr [ebp-4]
@@W = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	mov	ecx, [@@L1]
	sub	ecx, 2		; 24, 32 -> 0, 1
	jae	@@4a
	xor	ecx, ecx
	call	@@5, edi, 400h, esi, [@@SC]
	lea	edi, [edi+eax]
	jc	@@9
	add	esi, [@@SC]
	xor	ecx, ecx
	sub	esi, edx
	call	@@5, edi, [@@DC], esi, edx
	sbb	esi, esi
	add	edi, eax
	jmp	@@9

@@4a:	movzx	eax, word ptr [edi-12h+0Ch]
	push	ecx
	push	eax
@@1:	xor	eax, eax
	xor	ecx, ecx
	dec	[@@SC]
	js	@@9
	lodsb
	mov	edx, eax
	test	al, al
	js	@@1c
	and	eax, 1Fh
	shr	edx, 6
	jnc	@@1a
	shl	eax, 8
	lodsb
	add	eax, 20h
@@1a:	shr	edx, 1
	mov	edx, [@@L0]
	jc	@@1b
	inc	eax
	lea	ecx, [eax*2+eax]
	sub	[@@DC], eax
	jb	@@9
	sub	[@@SC], ecx
	jb	@@9
@@1h:	movsb
	movsb
	movsb
	add	edi, edx
	dec	eax
	jne	@@1h
	jmp	@@1

@@1b:	sub	[@@SC], 3
	jb	@@9
	dec	[@@DC]
	js	@@9
	movsb
	movsb
	movsb
	add	edi, edx
	xchg	eax, ecx
	jmp	@@3

@@1c:	test	al, 40h
	jne	@@2a
	and	eax, 0Fh
	and	edx, 30h
	jne	@@1d
	xchg	ecx, eax
	dec	[@@SC]
	js	@@9
	lodsb
	jmp	@@1g

@@1d:	cmp	edx, 20h
	ja	@@1f
	jb	@@1e
	shl	eax, 8
	dec	[@@SC]
	js	@@9
	lodsb
	add	eax, 10h
@@1e:	shl	eax, 8
	dec	[@@SC]
	js	@@9
	lodsb
	mov	cl, [esi]
	inc	esi
	jmp	@@1g

@@1f:	mov	edx, eax
	and	eax, 7
	and	edx, 8
	je	@@1g
	shl	eax, 8
	dec	[@@SC]
	js	@@9
	lodsb
	add	eax, 8
@@1g:	inc	eax
	jmp	@@3

@@2a:	cmp	al, 0FFh
	je	@@7
	and	eax, 0Fh
	and	edx, 30h
	je	@@2e
	inc	eax
	shr	edx, 2
@@2b:	imul	eax, [@@W]
	dec	eax
	; (1, 2, 3)*4 -> 0, -1, 1
	sub	edx, 8
	jb	@@3
	shr	edx, 1
	dec	edx
	sub	eax, edx
@@3:	mov	edx, [@@L0]
	inc	ecx
	not	eax
	add	edx, 3
	sub	[@@DC], ecx
	jb	@@9
	imul	eax, edx
	imul	ecx, edx
	mov	edx, edi
	sub	edx, [@@DB]
	add	edx, eax
	jnc	@@9
	add	eax, edi
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@7:	mov	[@@SB], esi
	mov	ecx, [@@L0]
	mov	esi, [@@DC]
	test	ecx, ecx
	je	@@9
	test	esi, esi
	jne	@@9
	inc	ecx
	inc	ecx
	mov	eax, edi
	sub	eax, [@@DB]
	shr	eax, 2
	call	@@5, [@@DB], eax, [@@SB], [@@SC]
	sbb	esi, esi
@@9:	mov	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h

@@2e:	lea	edx, [eax+4]
	and	eax, 3
	shl	eax, 8
	dec	[@@SC]
	js	@@9
	lodsb
	add	eax, 10h
	and	edx, 0Ch
	jne	@@2b
	add	eax, 7F9h
	jmp	@@3

@@5 PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	push	ecx
	mov	edi, [@@DB]
	mov	esi, [@@SB]
@@1:	xor	eax, eax
	xor	ecx, ecx
	dec	[@@SC]
	js	@@9
	lodsb
	mov	edx, eax
	test	al, al
	js	@@1d
	and	eax, 1Fh
	shr	edx, 6
	jnc	@@1a
	shl	eax, 8
	dec	[@@SC]
	js	@@9
	lodsb
	add	eax, 20h
@@1a:	shr	edx, 1
	mov	edx, [@@L0]
	jc	@@1c
	inc	eax
	sub	[@@SC], eax
	jb	@@9
	sub	[@@DC], eax
	jb	@@9
@@1b:	add	edi, edx
	movsb
	dec	eax
	jne	@@1b
	jmp	@@1

@@1c:	dec	[@@SC]
	js	@@9
	dec	[@@DC]
	js	@@9
	add	edi, edx
	movsb
	xchg	ecx, eax
	jmp	@@2c

@@1d:	test	al, 40h
	jne	@@2a
	dec	[@@SC]
	js	@@9
	and	eax, 0Fh
	and	edx, 30h
	jne	@@1e
	xchg	ecx, eax
	lodsb
	jmp	@@2b

@@1e:	shl	eax, 8
	lodsb
	inc	eax
	cmp	edx, 20h
	ja	@@1f
	je	@@1g
	dec	[@@SC]
	js	@@9
	movzx	ecx, byte ptr [esi]
	inc	esi
@@1f:	inc	ecx
@@1g:	inc	ecx
	jmp	@@2b

@@2a:	cmp	al, -1
	je	@@7
	and	eax, 1Fh
	and	edx, 20h
	je	@@3
@@2b:	inc	eax
@@2c:	inc	ecx
@@3:	mov	edx, [@@L0]
	inc	ecx
	inc	edx
	not	eax
	sub	[@@DC], ecx
	jb	@@9
	imul	eax, edx
	mov	edx, edi
	sub	edx, [@@DB]
	add	edx, eax
	jnc	@@9
	add	eax, edi
	mov	edx, [@@L0]
	xchg	esi, eax
@@3a:	add	esi, edx
	add	edi, edx
	movsb
	dec	ecx
	jne	@@3a
	xchg	esi, eax
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
ENDP

ENDP	; @@Unpack

ENDP
