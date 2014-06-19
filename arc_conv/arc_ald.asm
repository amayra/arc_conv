
; "Kaerunyo Panyorn", "Rance 5 - Ghost", "Sengoku_Rance" *.ald
; DLL\ALDLoader.dll

	dw _conv_ald-$-2
_arc_ald PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@SC
@M0 @@L0

	enter	@@stk+10h, 0
	call	_FileSeek, [@@S], -10h, 2
	jc	@@9a
	test	al, al
	jne	@@9a
	mov	[@@L0], eax
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	ecx
	sub	eax, 14C4Eh
	sub	ecx, 10h
	or	eax, ecx
	jne	@@9a
	movzx	eax, word ptr [esi+9]
	call	_ArcCount, eax
	call	_FileSeek, [@@S], 0, 0
	jc	@@9a
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	ebx
	pop	ecx
	mov	edi, ebx
	shl	ebx, 8
	lea	eax, [ebx-3]
	cmp	eax, 300000h
	jae	@@9a
	sub	ebx, 4
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 4, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	[esi], edi
	inc	ebx
	add	esi, 3
	mov	[@@SC], ebx

	add	esp, -80h
@@1:	sub	[@@SC], 3
	jb	@@9
	xor	eax, eax
	lodsb
	mov	edx, eax
	lodsw
	shl	eax, 8
	add	eax, edx
	je	@@9
	shl	eax, 8
	cmp	eax, [@@L0]
	jae	@@9
	call	_FileSeek, [@@S], eax, 0
	jc	@@8
	mov	edi, esp
	call	_FileRead, [@@S], edi, 10h
	jc	@@8
	mov	eax, [edi]
	test	al, 0Fh
	jne	@@8
	sub	eax, 20h
	cmp	eax, 60h
	ja	@@8
	lea	ebx, [eax+10h]
	add	edi, 10h
	and	[@@D], 0
	call	_FileRead, [@@S], edi, ebx
	jc	@@8
	call	_ArcName, edi, ebx
	mov	ebx, [edi-10h+4]
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
ENDP

; "Sengoku Rance" *GA.ald
; DLL\DecodeCG.dll 10002B70 10002C40

; 0x41, 0x48, 0x37B0, 0x1290
; 0x24B, 0x6B, 0x2E830, 0xF810

; db 'QNT',0
; dd 2, 44h, x, y, w, h, 0x18, 1, image_size, alpha_size
; dq time1, time2, time3

; cg00 CHAR
; cg01 BG
; cg10 MENU, UNIT
; cg30 AJP
; cg40 FX
; cg49 SMALL

; "Kaerunyo Panyorn" GAMEDATA\*G?.ALD
; "Rance 5 - Ghost" IST*.ALD
; GAMEDATA\SYSTEM35.EXE .004228EC

; FF FF, FF FF, FF 78 (cnt = 27Fh = 0FFh+0FFh+78h+9)

; "Daibanchou -Big Bang Age-" *GA.ald
; DLL\DecodeCG.dll 10001A00
; 10001D40 image_header: 0-pms("PM"), 1-bmp, 2-qnt("QNT"), 3-jpg, 4-?("ROU"), 5-ajp("AJP"), 6-png, 7-tga

_conv_ald PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]
@@M = dword ptr [ebp-0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'psv'
	je	_conv_vsp_sys
_conv_ald_sys:
	cmp	eax, 'smp'
	je	@@2
	cmp	eax, 'pja'
	je	@@4
	cmp	eax, 'tnq'
	jne	@@9
	sub	ebx, 44h
	jb	@@9
	mov	eax, [esi]
	mov	edx, [esi+4]
	mov	ecx, [esi+8]
	mov	edi, [esi+1Ch]
	sub	eax, 'TNQ'
	sub	edx, 2
	sub	ecx, 44h
	or	eax, edx
	sub	edi, 18h
	or	eax, ecx
	or	eax, edi
	je	@@1
@@9:	stc
	leave
	ret

@@2:	cmp	ebx, 30h
	jb	@@9
	movzx	ecx, word ptr [esi+4]
	movzx	edx, word ptr [esi+2]
	movzx	eax, word ptr [esi]
	cmp	ebx, ecx
	jb	@@9
	dec	edx
	sub	eax, 'MP'
	shr	edx, 1
	sbb	edi, edi
	sub	ecx, 30h
	and	edi, 10h
	sub	ecx, edi
	or	eax, edx
	or	eax, ecx
	jne	@@9
	movzx	ecx, word ptr [esi+4]
	movzx	edx, word ptr [esi+6]
	lea	eax, [ecx+300h]
	cmp	edx, 8
	jne	@@3
	sub	ebx, eax
	jb	@@9
	sub	eax, [esi+20h]
	sub	ecx, [esi+24h]
	or	eax, ecx
	jne	@@9
	mov	edi, [esi+18h]
	mov	edx, [esi+1Ch]
	call	_ArcTgaAlloc, 30h, edi, edx
	lea	edi, [eax+12h]
	add	esi, [esi+24h]
	mov	edx, [edi-12h+0Ch]
	xor	ecx, ecx
@@2a:	lodsb
	inc	edi
	movsb
	stosb
	lodsb
	mov	[edi-3], al
	inc	cl
	jne	@@2a
	call	@@PMS1, edi, edx, esi, ebx, 0
	clc
	leave
	ret

@@3:	and	dh, NOT 8
	sub	edx, 10h
	sub	ecx, [esi+20h]
	or	edx, ecx
	jne	@@9
	mov	edi, [esi+18h]
	mov	edx, [esi+1Ch]
	call	_ArcTgaAlloc, 23h, edi, edx
	lea	edi, [eax+12h]

	mov	ecx, [esi+20h]
	mov	eax, ebx
	lea	edx, [esi+ecx]
	sub	eax, ecx
	call	@@PMS2, edi, dword ptr [edi-12h+0Ch], edx, eax
	mov	eax, [esi+24h]
;	cmp	byte ptr [esi+7], 8
;	jne	@@3a
	test	eax, eax
	je	@@3a
	sub	ebx, eax
	jb	@@3a
	add	esi, eax
	call	@@PMS1, edi, dword ptr [edi-12h+0Ch], esi, ebx, 3
@@3a:	clc
	leave
	ret

@@1:	mov	ecx, [esi+28h]
	sub	ebx, [esi+24h]
	jb	@@9
	sub	ebx, ecx
	jne	@@9
	mov	edi, [esi+14h]
	mov	edx, [esi+18h]
	lea	eax, [edi+1]
	lea	ebx, [edx+1]
	and	eax, -2
	and	ebx, -2
	imul	ebx, eax
	imul	eax, edx
	cmp	ecx, 1
	sbb	ecx, ecx
	add	ecx, 4
	lea	ebx, [ebx*2+ebx]
	push	ecx	; @@L0
	push	eax	; @@L1
	add	ecx, 20h-1
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]

	mov	eax, [@@L0]
	sub	eax, 3
	imul	eax, [@@L1]
	add	eax, ebx
	call	_MemAlloc, eax
	jc	@@9
	push	eax
	lea	ecx, [esi+44h]
	call	_zlib_unpack, eax, ebx, ecx, dword ptr [esi+24h]
	cmp	[@@L0], 3
	je	@@1a
	mov	eax, [@@M]
	lea	ecx, [esi+44h]
	add	eax, ebx
	add	ecx, [esi+24h]
	call	_zlib_unpack, eax, [@@L1], ecx, dword ptr [esi+28h]
@@1a:	pop	esi
	call	@@QNT, edi, esi, [@@L0], dword ptr [edi-12h+0Ch]
	call	_MemFree, esi
	clc
	leave
	ret

@@4:	cmp	ebx, 38h
	jb	@@9
	mov	eax, [esi]
	mov	ecx, [esi+8]
	sub	eax, 'PJA'
	sub	ecx, 38h
	or	eax, ecx
	jne	@@9
	mov	edi, [esi+14h]
	mov	ebx, [esi+18h]
	call	@@4a
	cmp	dword ptr [esi+20h], 0
	jne	@@4b
	call	_ArcSetExt, 'gpj'
	call	_ArcData, edi, ebx
	clc
	leave
	ret

@@4b:	call	_ArcSetExt, 'gpj'
	call	_ArcData, edi, ebx
	call	_ArcSetExt, 'smp'
	mov	edi, [esi+1Ch]
	mov	ebx, [esi+20h]
	call	@@4a
	call	_ArcData, edi, ebx
	clc
	leave
	ret

@@4a:	mov	eax, [@@SC]
	sub	eax, edi
	jae	$+4
	xor	eax, eax
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	add	edi, esi
	call	@@AJPCrypt, edi, ebx
	ret

@@AJPCrypt PROC
	push	ebp
	mov	ebp, esp
	push	03416CBB5h
	push	0924CEC83h
	push	0CD41564Ah
	push	087AE915Dh
	xor	ecx, ecx
	mov	edx, [ebp+8]
@@1:	mov	al, [esp+ecx]
	cmp	ecx, [ebp+0Ch]
	jae	@@9
	xor	[edx+ecx], al
	inc	ecx
	cmp	ecx, 10h
	jb	@@1
@@9:	leave
	ret	8
ENDP

@@QNT PROC

@@DB = dword ptr [ebp+14h]
@@SB = dword ptr [ebp+18h]
@@L0 = dword ptr [ebp+1Ch]
@@L1 = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	edx, edx
@@2a:	push	edi
	add	edi, edx
	movzx	ebx, word ptr [@@L1+2]
	shr	ebx, 1
	je	@@2j
@@2b:	movzx	ecx, word ptr [@@L1]
	push	edx
	push	ebx
	mov	ebx, [@@L0]
	mov	edx, ecx
	imul	edx, ebx
@@2c:	lodsw
	mov	[edi], al
	mov	[edi+edx], ah
	add	edi, ebx
	dec	ecx
	jne	@@2c
	add	edi, edx
	pop	ebx
	pop	edx
	mov	ecx, [@@L1]
	and	ecx, 1
	lea	esi, [esi+ecx*2]
	dec	ebx
	jne	@@2b
@@2j:	mov	ebx, [@@L0]
	test	byte ptr [@@L1+2], 1
	je	@@2h
	movzx	ecx, word ptr [@@L1]
@@2g:	lodsw
	mov	[edi], al
	add	edi, ebx
	dec	ecx
	jne	@@2g
	mov	ecx, [@@L1]
	and	ecx, 1
	lea	esi, [esi+ecx*2]
@@2h:	inc	edx
	pop	edi
	cmp	edx, 3
	jb	@@2a
	cmp	ebx, edx
	je	@@3c
	push	edi
	add	edi, edx
	movzx	ebx, word ptr [@@L1+2]
@@3a:	movzx	ecx, word ptr [@@L1]
@@3b:	movsb
	add	edi, 3
	dec	ecx
	jne	@@3b
	mov	ecx, [@@L1]
	and	ecx, 1
	add	esi, ecx
	dec	ebx
	jne	@@3a
	pop	edi
	inc	edx
@@3c:
	movzx	ebx, word ptr [@@L1]
	add	edi, edx
	imul	ebx, edx
	neg	edx
	mov	ecx, ebx
	neg	ebx
	add	ecx, edx
	je	@@2k
@@2d:	mov	al, [edi+edx]
	sub	al, [edi]
	stosb
	dec	ecx
	jne	@@2d
@@2k:	dec	word ptr [@@L1+2]
	je	@@2i
@@2e:	mov	al, [edi+ebx]
	sub	al, [edi]
	stosb
	dec	ecx
	cmp	ecx, edx
	jne	@@2e
	sub	ecx, ebx
@@2f:	mov	al, [edi+edx]
	add	al, [edi+ebx]
	rcr	al, 1
	sub	al, [edi]
	stosb
	dec	ecx
	jne	@@2f
	dec	word ptr [@@L1+2]
	jne	@@2e
@@2i:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

@@PMS2 PROC

@@DB = dword ptr [ebp+14h]
@@L0 = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
@@2:	movzx	ebx, word ptr [@@L0]
@@1:	test	ebx, ebx
	je	@@7
	dec	[@@SC]
	js	@@9
	movsx	eax, byte ptr [esi]
	inc	esi
	lea	ecx, [eax+6]
	cmp	al, 0F8h
	jb	@@1a
	shr	ecx, 1
	je	@@2a	; FB, FA
	dec	[@@SC]
	js	@@9
	movzx	ecx, byte ptr [esi]
	inc	esi
	inc	eax
	inc	eax
	jns	@@1b	; FF, FE
	inc	eax
	je	@@1d	; FD
	inc	eax
	je	@@1e	; FC
	add	eax, 3
	je	@@2b	; F9
	inc	eax
	jne	@@9	; F8
	xchg	eax, ecx
@@1a:	dec	[@@SC]
	js	@@9
	movzx	eax, word ptr [esi-1]
	inc	esi
	call	@@3a
	stosd
	dec	ebx
	jmp	@@1

@@2a:	cmc
	sbb	eax, eax
	movzx	edx, word ptr [@@L0]
	lea	edx, [edx+eax*2+1]
	jmp	@@1c

@@2b:	lea	eax, [ecx+2]
	inc	ecx
	sub	ebx, ecx
	jb	@@9
	sub	[@@SC], eax
	jb	@@9
	push	ebx
	movzx	ebx, byte ptr [esi]
	inc	esi
	; 0xE0 << 6 + 0x18 << 4 + 0x07
	ror	ebx, 5
	shl	bx, 2
	rol	ebx, 2
	shl	bx, 4
	rol	ebx, 3
@@2c:	movzx	eax, byte ptr [esi]
	inc	esi
	ror	eax, 6
	shl	ax, 2
	rol	eax, 4
	shl	ax, 3
	rol	eax, 2
	lea	eax, [eax+ebx*4]
	call	@@3a
	stosd
	dec	ecx
	jne	@@2c
	pop	ebx
	jmp	@@1

@@1b:	movzx	edx, word ptr [@@L0]
	jne	$+4
	shl	edx, 1
	inc	ecx
@@1c:	inc	ecx
	neg	edx
	sub	ebx, ecx
	jb	@@9
	shl	edx, 2
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
@@1f:	xchg	esi, eax
	rep	movsd
	xchg	esi, eax
	jmp	@@1

@@1d:	sub	[@@SC], 2
	jb	@@9
	add	ecx, 3
	sub	ebx, ecx
	jb	@@9
	call	@@3
	rep	stosd
	jmp	@@1

@@1e:	sub	[@@SC], 4
	jb	@@9
	lea	ecx, [ecx+ecx+4]
	sub	ebx, ecx
	jb	@@9
	call	@@3
	stosd
	dec	ecx
	call	@@3
	stosd
	dec	ecx
	lea	eax, [edi-8]
	jmp	@@1f

@@7:	dec	word ptr [@@L0+2]
	jne	@@2
	xor	esi, esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@3:	movzx	eax, word ptr [esi]
	add	esi, 2
@@3a:	ror	eax, 5
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
	or	eax, 0FF000000h
	ret
ENDP

@@PMS1 PROC

@@DB = dword ptr [ebp+14h]
@@L0 = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@A = dword ptr [ebp+24h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
@@2:	movzx	ebx, word ptr [@@L0]
@@1:	test	ebx, ebx
	je	@@7
	dec	[@@SC]
	js	@@9
	movsx	eax, byte ptr [esi]
	inc	esi
	cmp	al, 0F8h
	jb	@@1a
	dec	[@@SC]
	js	@@9
	movzx	ecx, byte ptr [esi]
	inc	esi
	inc	eax
	inc	eax
	jns	@@1b	; FF, FE
	inc	eax
	je	@@1d	; FD
	inc	eax
	je	@@1e	; FC
	add	al, 4	; F8
	jne	@@9
	xchg	eax, ecx
@@1a:	add	edi, [@@A]
	stosb
	dec	ebx
	jmp	@@1

@@1b:	movzx	edx, word ptr [@@L0]
	jne	@@1c
	shl	edx, 1
@@1c:	add	ecx, 3
	neg	edx
	sub	ebx, ecx
	jb	@@9
	mov	eax, [@@A]
	inc	eax
	imul	edx, eax
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	edx, [edi+edx]
@@2a:	add	edx, [@@A]
	add	edi, [@@A]
	mov	al, [edx]
	inc	edx
	stosb
	dec	ecx
	jne	@@2a
	jmp	@@1

@@1d:	dec	[@@SC]
	js	@@9
	add	ecx, 4
	sub	ebx, ecx
	jb	@@9
	mov	edx, edi
	add	edi, [@@A]
	movsb
	dec	ecx
	jmp	@@2a

@@1e:	sub	[@@SC], 2
	jb	@@9
	lea	ecx, [ecx+ecx+6]
	sub	ebx, ecx
	jb	@@9
	mov	edx, edi
	add	edi, [@@A]
	movsb
	dec	ecx
	add	edi, [@@A]
	movsb
	dec	ecx
	jmp	@@2a

@@7:	dec	word ptr [@@L0+2]
	jne	@@2
	xor	esi, esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

ENDP
