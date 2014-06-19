
; "Messiah" *.pak
; MESSIAH_Trial03\MESSIAH.exe 004399C0
; MESSIAH_Trial01\MESSIAH.exe 00438CD0

; MESSIAH.exe
; 0043AF80 script_decode

; "Kimi to Boku to Eden no Ringo (Trial)" *.pak
; EDEN.exe
; 0046FCE0 png_key_init

	dw _conv_datapack5-$-2
_arc_datapack5 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@L0,8

	enter	@@stk+48h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 48h
	jc	@@9a
	pop	eax
	pop	ecx
	movzx	edx, word ptr [esi+8]
	movzx	ebx, word ptr [esi+32h]
	sub	eax, 'ataD'
	sub	ecx, 'kcaP'
	sub	edx, 35h
	sub	ebx, 5
	or	eax, ecx
	or	edx, ebx
	or	eax, edx
	jne	@@9a
	mov	ebx, [esi+3Ch]
	mov	eax, [esi+40h]
	lea	ecx, [ebx-1]
	mov	[@@P], eax
	shr	ecx, 14h
	jne	@@9a
	mov	[@@N], ebx
	imul	ebx, 68h
	call	_FileSeek, [@@S], dword ptr [esi+44h], 0
	jc	@@9a

	lea	edx, [esi+10h]
	call	_ansi_select, offset @@T, edx
	mov	ecx, [esi+38h]
	mov	[@@L0], eax
	mov	[@@L0+4], ecx

	mov	edi, [esi+34h]
	lea	eax, [@@M]
	test	edi, edi
	jne	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	jmp	@@2b

@@2a:	call	_ArcMemRead, eax, ebx, edi, 0
	jc	@@9
	mov	ecx, [@@L0+4]
	test	ecx, ecx
	je	@@2c
	cmp	[@@L0], 0
	je	@@2d
	shr	ecx, 1
	jnc	@@2c
	or	ecx, -1
@@2d:
	call	_datapack5_crypt, ecx, edx, edi
@@2c:	mov	esi, [@@M]
	lea	edx, [esi+ebx]
	call	_lzss_unpack, esi, ebx, edx, edi
	jc	@@9
	call	_ArcDbgData, esi, ebx
@@2b:	call	_ArcCount, [@@N]

@@1:	mov	ebx, [esi+44h]
	cmp	byte ptr [esi], 0
	jne	@@1b
	mov	byte ptr [esi], '$'
	test	ebx, ebx
	jne	@@1b
	call	_ArcSkip, 1
	jmp	@@8

@@1b:	call	_ArcName, esi, 40h
	mov	eax, [esi+40h]
	and	[@@D], 0
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	cmp	[@@L0], 0
	je	@@1a
	test	byte ptr [@@L0+4], 2
	je	@@1a
	call	@@4
	mov	ecx, ebx
	mov	edx, [@@D]
	shr	ecx, 2
	je	@@1a
	mov	edi, [edx]
	xor	edi, 474E5089h

@@1c:	xor	[edx], eax
	add	edx, 4
	dec	ecx
	jne	@@1c
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 68h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@4 PROC
	xor	eax, eax
	xor	ecx, ecx
@@1:	movsx	edx, byte ptr [esi+ecx]
	inc	ecx
	test	edx, edx
	je	@@9
	imul	eax, 25h
	or	edx, 20h
	add	eax, edx
	cmp	ecx, 40h
	jb	@@1
@@9:	ret
ENDP

@@T	db 'EDEN',0, 'EDENTR',0, 0
ENDP

_datapack5_crypt PROC
	push	ebx
	push	edi
	mov	edi, [esp+10h]
	mov	ebx, [esp+14h]
	xor	ecx, ecx
	test	ebx, ebx
	je	@@9
	mov	edx, [esp+0Ch]
@@1:	mov	eax, ecx
	and	eax, edx
	xor	[edi+ecx], al
	inc	ecx
	dec	ebx
	jne	@@1
@@9:	pop	edi
	pop	ebx
	ret	0Ch
ENDP

_conv_datapack5 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 8
	jb	@@9
	mov	ecx, 'ggo'
	mov	eax, [esi]
	mov	edx, [esi+4]
	sub	eax, 'SggO'
	sub	dh, 2
	or	eax, edx
	je	@@8
	mov	ecx, 'gnp'
	mov	edx, 0A1A0A0Dh
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, 474E5089h
	or	eax, edx
	jne	@@1
@@8:	call	_ArcSetExt, ecx
@@9:	stc
	leave
	ret

@@1:	cmp	ebx, 74h
	jb	@@9
	cmp	dword ptr [esi], 40000h
	jne	@@2
	cmp	dword ptr [esi+0Ch], 74h
	jne	@@9
	mov	ecx, [esi+1Ch]
	mov	edi, [esi+14h]
	mov	edx, [esi+18h]
	mov	ebx, edi
	imul	ebx, edx
	ror	ecx, 3
	imul	ebx, ecx
	dec	ecx
	cmp	ecx, 4
	jae	@@9
	dec	ecx
	je	@@9
	jns	@@1a
	add	ebx, 400h
@@1a:	add	ecx, 38h+1
	cmp	ebx, [esi+8]
	jne	@@9
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	mov	ecx, [@@SC]
	lea	edx, [esi+74h]
	sub	ecx, 74h
	call	_lzss_unpack, edi, ebx, edx, ecx
	clc
	leave
	ret

@@2:	mov	edi, 1C8h
	sub	ebx, edi
	jb	@@9
	mov	edx, 'x.'
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, '5wcS'
	or	eax, edx
	jne	@@9
	mov	ecx, [esi+1Ch]
	cmp	dword ptr [esi+14h], -1
	je	@@2a
	mov	ecx, [esi+18h]
@@2a:	cmp	ebx, ecx
	jb	@@9
	add	esi, edi
	call	_datapack5_crypt, -1, esi, ecx

	mov	esi, [@@SB]
	cmp	dword ptr [esi+14h], -1
	jne	@@9
	mov	ecx, [esi+18h]
	add	ecx, edi
	call	_MemAlloc, ecx
	jc	@@9
	push	eax
	xchg	edi, eax
	xchg	ecx, eax
	mov	edx, esi
	shr	ecx, 2
	rep	movsd
	call	_lzss_unpack, edi, dword ptr [edx+18h], esi, dword ptr [edx+1Ch]
	add	edi, eax
	pop	esi
	sub	edi, esi
	call	_ArcData, esi, edi
	call	_MemFree, esi
	clc
	leave
	ret
ENDP
