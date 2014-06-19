
; "airyFairy", "Akatsuki no Goei ~Principal-tachi no Kyuujitsu~" *.arc
; autorun.exe
; 00408DA0 name_hash

; NekoNeko Fan Disk 3
; 00454960 scenario_decrypt
; 00454A00 image_key

; Vanitas no Hitsuji
; 00454F80 image_key

	dw _conv_majiro-$-2
_arc_majiro PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk, 0
	lea	eax, [@@M]
	call	_majiro_arc_load, [@@S], eax
	test	eax, eax
	mov	[@@N], eax
	je	@@9a
	mov	esi, edx
	call	_ArcCount, eax
	call	@@Sort, esi, [@@N]

@@1:	mov	edx, [esi]
	test	edx, edx
	je	@@1b
	call	_ArcName, edx, -1
@@1b:	and	[@@D], 0
	mov	ebx, [esi+8]
	call	_FileSeek, [@@S], dword ptr [esi+4], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	mov	edi, [@@D]
	test	edi, edi
	je	@@1c
	call	_majiro_rct_check, edi, ebx
	cmp	al, 53h
	jne	@@1c
	lea	edx, [edi+edx+14h]
	call	_majiro_rct_decrypt, edx, ecx
	jc	@@1c
	mov	byte ptr [edi+5], 43h
@@1c:	call	_ArcConv, edi, ebx
	call	_MemFree, edi
@@8:	add	esi, 0Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@Sort PROC

@@S = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	xor	ecx, ecx
	jmp	@@4
@@1:	mov	eax, [ebx-8]
	mov	edx, [ebx+4]
	cmp	edx, eax
	jae	@@4
	mov	[ebx-8], edx
	mov	[ebx+4], eax
	mov	esi, [ebx-0Ch]
	mov	eax, [ebx-4]
	mov	edi, [ebx]
	mov	edx, [ebx+8]
	mov	[ebx-0Ch], edi
	mov	[ebx-4], edx
	mov	[ebx], esi
	mov	[ebx+8], eax
	sub	ebx, 0Ch
	cmp	ebx, [@@S]
	jne	@@1
@@4:	inc	ecx
	mov	eax, [@@S]
	lea	ebx, [ecx*2+ecx]
	lea	ebx, [eax+ebx*4]	
	cmp	ecx, [@@C]
	jb	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

ENDP

_conv_majiro PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, '8cr'
	je	@@1
	cmp	eax, 'tcr'
	je	@@2
	cmp	eax, 'ojm'
	je	@@3
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 314h
	jb	@@9
	mov	[@@SC], ebx
	mov	edx, 30305F38h
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, 9A925A98h
	sub	ebx, [esi+10h]
	or	eax, edx
	or	eax, ebx
	jne	@@9
	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 30h, edi, edx
	xchg	edi, eax
	add	esi, 14h
	movzx	eax, word ptr [edi+0Ch]
	add	edi, 12h
	mov	ecx, 300h/4
	rep	movsd
	call	@@RC8, edi, ebx, esi, [@@SC], eax
	clc
	leave
	ret

@@2:	call	_majiro_rct_check, esi, ebx
	test	eax, eax
	mov	[@@SC], ecx
	je	@@9
	push	edx
	cmp	al, 53h
	jne	@@2a
	lea	edx, [esi+edx+14h]
	call	_majiro_rct_decrypt, edx, ecx
	jc	@@9
	mov	byte ptr [esi+5], 43h
@@2a:
	mov	edi, [esi+8]
	mov	edx, [esi+0Ch]
	mov	ebx, edi
	imul	ebx, edx
	lea	ebx, [ebx*2+ebx]
	call	_ArcTgaAlloc, 22h, edi, edx
	lea	edi, [eax+12h]
	movzx	eax, word ptr [edi-12h+0Ch]
	add	esi, 14h
	pop	ecx
	push	eax	; @@RCT(5)
	test	ecx, ecx
	je	@@2b
	inc	esi
	dec	ecx
	inc	esi
	dec	ecx
	test	ch, ch
	jne	@@2b
	mov	[edi-12h], cl
	rep	movsb
@@2b:	add	esi, ecx
	call	@@RCT, edi, ebx, esi, [@@SC]
	clc
	leave
	ret

@@3:	call	_majiro_mjo_decrypt, esi, ebx
	sub	eax, 'X'
	neg	eax
	jc	@@3a
	call	_ArcData, esi, ebx
	clc
@@3a:	leave
	ret

@@RC8 PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@W = dword ptr [ebp+24h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	eax, eax
	jmp	@@1c

@@1:	xor	eax, eax
	cmp	[@@DC], 0
	je	@@7
	dec	[@@SC]
	js	@@9
	lodsb
	test	al, al
	jns	@@1b
	mov	edx, eax
	and	eax, 7
	shr	edx, 3
	cmp	eax, 7
	jne	@@1a
	sub	[@@SC], 2
	jb	@@9
	lodsw
	add	eax, 7
@@1a:	and	edx, 0Fh
	lea	ecx, [eax+3]
	sub	[@@DC], ecx
	jb	@@9
	movsx	edx, byte ptr [@@T+edx]
	mov	eax, edx
	sar	edx, 4
	and	eax, 0Fh
	imul	eax, [@@W]
	sub	edx, eax
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	push	esi
	lea	esi, [edi+edx]
	rep	movsb
	pop	esi
	jmp	@@1

@@1b:	cmp	eax, 7Fh
	jne	@@1c
	sub	[@@SC], 2
	jb	@@9
	lodsw
	add	eax, 7Fh
@@1c:	lea	ecx, [eax+1]
	sub	[@@SC], ecx
	jb	@@9
	sub	[@@DC], ecx
	jb	@@9
	rep	movsb
	jmp	@@1

@@7:	xor	esi, esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h

@@T	db 0F0h,0E0h,0D0h,0C0h
	db 031h,021h,011h,001h,0F1h,0E1h,0D1h
	db 022h,012h,002h,0F2h,0E2h
ENDP

@@RCT PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@W = dword ptr [ebp+24h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	eax, eax
	jmp	@@1c

@@1:	xor	eax, eax
	cmp	[@@DC], 0
	je	@@7
	dec	[@@SC]
	js	@@9
	lodsb
	test	al, al
	jns	@@1b
	mov	edx, eax
	and	eax, 3
	shr	edx, 2
	cmp	eax, 3
	jne	@@1a
	sub	[@@SC], 2
	jb	@@9
	lodsw
	add	eax, 3
@@1a:	and	edx, 1Fh
	lea	ecx, [eax+eax*2+3]
	sub	[@@DC], ecx
	jb	@@9
	movsx	edx, byte ptr [@@T+edx]
	mov	eax, edx
	sar	edx, 4
	and	eax, 0Fh
	imul	eax, [@@W]
	sub	edx, eax
	lea	edx, [edx*2+edx]
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	push	esi
	lea	esi, [edi+edx]
	rep	movsb
	pop	esi
	jmp	@@1

@@1b:	cmp	eax, 7Fh
	jne	@@1c
	sub	[@@SC], 2
	jb	@@9
	lodsw
	add	eax, 7Fh
@@1c:	lea	ecx, [eax+eax*2+3]
	sub	[@@SC], ecx
	jb	@@9
	sub	[@@DC], ecx
	jb	@@9
	rep	movsb
	jmp	@@1

@@7:	xor	esi, esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h

@@T	db 0F0h,0E0h,0D0h,0C0h,0B0h,0A0h
	db 031h,021h,011h,001h,0F1h,0E1h,0D1h
	db 032h,022h,012h,002h,0F2h,0E2h,0D2h
	db 033h,023h,013h,003h,0F3h,0E3h,0D3h
	db 024h,014h,004h,0F4h,0E4h
ENDP

ENDP

_majiro_rct_decrypt PROC
	push	ebx
	push	esi
	push	edi
	mov	ebx, esp
	call	_ArcLocal, offset _ArcLocalMem
	xchg	esi, eax
	jnc	@@4b
	xor	edi, edi
	mov	[esi], edi
	call	_ArcParamNum, edi
	db 'majiro_key', 0
	jnc	@@4a
	inc	edi
	call	_ArcParam
	db 'majiro_str', 0
	jc	@@4c
	call	_stack_sjis_esc, eax
	mov	eax, esp
	jmp	@@4a

@@4c:	dec	edi
	call	_majiro_arcscan
	jc	@@4b
@@4a:	push	eax
	call	_MemAlloc, 400h
	pop	edx
	mov	[esi], eax
	jc	@@4b
	call	@@Init, eax, edx, edi
@@4b:
	mov	esi, [esi]
	mov	esp, ebx
	cmp	esi, 1
	jb	@@9
	mov	ebx, [esp+14h]
	mov	edx, [esp+10h]
	test	ebx, ebx
	je	@@9
	xor	ecx, ecx
@@1:	mov	al, [esi+ecx]
	inc	ecx
	xor	[edx], al
	inc	edx
	and	ecx, 3FFh
	dec	ebx
	jne	@@1
	clc
@@9:	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@Init PROC
	push	ebx
	push	esi
	push	edi
	enter	400h, 0
	xor	ecx, ecx
	mov	edi, esp
@@1:	mov	eax, ecx
	push	8
	pop	edx
@@2:	shr	eax, 1
	jnc	$+7
	xor	eax, 0EDB88320h
	dec	edx
	jne	@@2
	stosd
	inc	cl
	jne	@@1

	mov	esi, [ebp+18h]
	cmp	dword ptr [ebp+1Ch], 0
	je	@@3c
	or	eax, -1
	jmp	@@3b
@@3a:	mov	dh, 0
	xor	dl, al
	shr	eax, 8
	xor	eax, [esp+edx*4]
@@3b:	movzx	edx, byte ptr [esi]
	inc	esi
	test	edx, edx
	jne	@@3a
	not	eax
	xchg	esi, eax
@@3c:
	mov	edi, [ebp+14h]
	xor	edx, edx
@@4:	lea	eax, [esi+edx]
	movzx	eax, al
	mov	eax, [esp+eax*4]
	xor	eax, esi
	stosd
	inc	dl
	jne	@@4

	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

ENDP

_majiro_rct_check PROC
	push	esi
	mov	ecx, [esp+0Ch]
	mov	esi, [esp+8]
	sub	ecx, 14h
	jb	@@9
	cmp	dword ptr [esi], 9A925A98h
	jne	@@9
	movzx	eax, word ptr [esi+6]
	xchg	al, ah
	sub	eax, 3030h
	xor	edx, edx
	shr	eax, 1
	jne	@@9
	jnc	@@1
	sub	ecx, 2
	jb	@@9
	movzx	edx, word ptr [esi+14h]
	sub	ecx, edx
	jb	@@9
	inc	edx
	inc	edx
@@1:	cmp	[esi+10h], ecx
	jne	@@9
	movzx	eax, byte ptr [esi+5]
	cmp	byte ptr [esi+4], 54h
	jne	@@9
	cmp	al, 43h
	je	@@8
	cmp	al, 53h		; encrypted
	je	@@8
@@9:	xor	eax, eax
@@8:	pop	esi
	ret	8
ENDP

_majiro_arcscan PROC

@@L0 = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	push	-1
	push	ecx
	mov	esi, offset inFileName
	call	_unicode_name, esi
	sub	eax, esi
	lea	ecx, [eax+2]
	and	ecx, -4
	push	eax
	sub	esp, ecx
	shr	ecx, 2
	mov	edi, esp
	rep	movsd
	mov	[esp+eax], cx
	push	esp
	call	@@3b

@@3:	mov	edx, [esp+4]
	test	edx, edx
	je	@@3a
	test	byte ptr [edx], 10h
	jne	@@3a
	mov	edx, [esp+10h]
	mov	ecx, [esp+14h]
	sub	ecx, edx
	shr	ecx, 1
	dec	ecx
	call	_unicode_ext, ecx, edx
	cmp	eax, 'cra'
	jne	@@3a
	call	@@4, dword ptr [esp+8]
	jc	@@3a
	and	dword ptr [@@L0+4], 0
	mov	[@@L0], eax
	or	eax, -1
	ret
@@3a:	xor	eax, eax
	ret

@@3b:	call	_FindFile
	lea	esp, [@@L0]
	pop	eax
	pop	ecx
	neg	ecx
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret

@@4 PROC

@@S = dword ptr [ebp+14h]

@@M = dword ptr [ebp-4]
@@N = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	enter	8, 0
	xor	esi, esi
	call	_FileCreate, @@S, FILE_INPUT
	jc	@@9a
	mov	[@@S], eax
	lea	eax, [@@M]
	call	_majiro_arc_load, [@@S], eax
	mov	[@@N], eax
	test	eax, eax
	je	@@9
	mov	esi, edx

@@2:	mov	edx, [esi]
	call	@@2d
	db 'start.mjo',0
@@2d:	pop	edi
@@2e:	mov	al, [edx]
	inc	edx
	sub	al, 41h
	cmp	al, 1Ah
	sbb	ah, ah
	and	ah, 20h
	add	al, ah
	add	al, 41h
	scasb
	jne	@@2c
	test	al, al
	jne	@@2e
	mov	eax, [esi+4]
	mov	ebx, [esi+8]
	call	_FileSeek, [@@S], eax, 0
	jc	@@2c
	call	_MemAlloc, ebx
	jc	@@2c
	push	esi
	xchg	esi, eax
	call	_FileRead, [@@S], esi, ebx
	xchg	ebx, eax
	call	_majiro_mjo_decrypt, esi, ebx
	test	eax, eax
	je	@@2b
	push	esi
	call	@@3
	pop	esi
@@2b:	call	_MemFree, esi
	pop	esi
@@2c:	add	esi, 0Ch
	dec	[@@N]
	jne	@@2
	xor	esi, esi
@@9:	call	_MemFree, [@@M]
	call	_FileClose, [@@S]
@@9a:	xchg	eax, ebx
	cmp	esi, 1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4

@@4:	movzx	ecx, word ptr [esi+2]
	lea	edx, [esi+4]
	dec	ecx
	call	_crc32@12, 0, edx, ecx
	xchg	ebx, eax
	pop	esi
	pop	esi
	call	_MemFree, esi
	jmp	@@9

@@3:	mov	eax, [esi+18h]
	shl	eax, 3
	add	eax, 20h
	sub	ebx, eax
	add	esi, eax
@@3b:	cmp	ebx, 4
	jb	@@3d
	cmp	word ptr [esi], 801h
	jne	@@3c
	movzx	ecx, word ptr [esi+2]
	lea	edx, [ecx+0Ch]
	test	ecx, ecx
	je	@@3c
	cmp	ebx, edx
	jb	@@3c
	cmp	dword ptr [esi+ecx+6], 07A7B6ED4h
	jne	@@3c
	cmp	word ptr [esi+ecx+4], 835h
	jne	@@3c
	lea	edi, [esi+4]
	xor	eax, eax
	repne	scasb
	jne	@@3c
	test	ecx, ecx
	je	@@4
@@3c:	inc	esi
	dec	ebx
	jne	@@3b
@@3d:	ret	
ENDP

ENDP
