
	dw _conv_aoibx-$-2
_arc_aoibx PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	movzx	edx, dl
	sub	eax, 'BIOA'
	sub	edx, 'X'
	or	eax, edx
	jne	@@9a
	pop	eax
	pop	edx
	lea	ecx, [eax-1]
	mov	[@@N], eax
	shr	ecx, 14h
	or	ecx, edx
	jne	@@9a
	imul	ebx, eax, 18h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 10h
	and	[@@D], 0
	mov	ebx, [esi+14h]
	call	_FileSeek, [@@S], dword ptr [esi+10h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
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
ENDP

_conv_aoibx PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'txt'
	je	@@2
@@9:	stc
	leave
	ret

	; 9 - 0x5F
	; 10 - 0xB2
	; 11 - 0x5A

@@2:	cmp	ebx, 3
	jb	@@9
	mov	al, [esi]
	movzx	edx, word ptr [esi+1]
	xor	al, 'A'
	xor	dl, al
	xor	dh, al
	cmp	edx, 'IO'
	jne	@@9
	mov	edx, esi
	mov	ecx, ebx 
@@2a:	xor	[edx], al
	inc	edx
	dec	ecx
	jne	@@2a
	call	_ArcData, esi, ebx
	clc
	leave
	ret
ENDP

; "Yukioni-ya Onsen-ki"
; Onsen.exe
; 0040B7D0 box_open
; 0040A7E0 decrypt

	dw 0
_arc_aoimy PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+18h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 18h
	jc	@@9a
	mov	edi, offset _aoimy_sign
	push	4
	pop	ecx
	repe	cmpsd
	jne	@@9a
	lodsd
	bswap	eax
	lea	ecx, [eax-1]
	mov	[@@N], eax
	shr	ecx, 14h
	jne	@@9a
	cmp	dword ptr [esi], 0
	jne	@@9a
	imul	ebx, eax, 28h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	call	_ArcUnicode, 1

@@1:	call	_ArcName, esi, 10h
	and	[@@D], 0
	mov	edi, [esi+20h]
	mov	ebx, [esi+24h]
	bswap	edi
	bswap	ebx
	call	_FileSeek, [@@S], edi, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	call	_aoimy_crypt, edi, [@@D], ebx
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 28h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

; "Nangoku Dominion" *.vfs

	dw _conv_vfs-$-2
_arc_vfs PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	mov	ebx, [esi+8]
	movzx	eax, word ptr [esi]
	movzx	ecx, word ptr [esi+4]
	movzx	edx, word ptr [esi+6]
	test	ecx, ecx
	je	@@9a
	; [esi+0Ch] archive_size
	mov	[@@N], ecx
	imul	ecx, edx
	sub	eax, 'FV'
	sub	ecx, ebx
	or	eax, ecx
	jne	@@9a
	mov	eax, [esi]
	mov	ax, dx
	cmp	eax, 2000017h
	je	_mod_vfs200
	cmp	eax, 1010020h
	jne	@@9a
; _mod_vfs101
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	eax, [ebx+10h]
	cmp	dword ptr [esi+13h], eax
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 0Dh
	and	[@@D], 0
	mov	ebx, [esi+17h]
	mov	eax, [esi+1Bh]
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	call	_FileSeek, [@@S], dword ptr [esi+13h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 20h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

; "Bunny Black" *.vfs

_mod_vfs200 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1

	lea	esp, [ebp-@@stk]
	lea	ecx, [ebx+8]
	lea	eax, [@@M]
	and	[@@L0], 0
	call	_ArcMemRead, eax, 0, ecx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	dword ptr [esi+ebx+4], 0
	jne	@@9
	mov	ecx, [esi+ebx]
	mov	[@@L1], ecx
	shl	ecx, 1
	lea	eax, [@@L0]
	call	_ArcMemRead, eax, 0, ecx, 0
	jc	@@9
	call	_ArcCount, [@@N]
	call	_ArcUnicode, 1

	; d00 name_offset
	; w04 attributes
	; w06 dosdate
	; w08 dostime
	; d0A offset
	; d0E size
	; d12 size
	; b16 part_char

@@1:	mov	ecx, [@@L1]
	mov	eax, [esi]
	sub	ecx, eax
	jb	@@8
	shl	eax, 1
	add	eax, [@@L0]
	call	_ArcName, eax, ecx
	and	[@@D], 0
	mov	ebx, [esi+0Eh]
	mov	eax, [esi+12h]
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	call	_FileSeek, [@@S], dword ptr [esi+0Ah], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 17h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@L0]
	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_vfs PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'fga'
	je	@@2
	cmp	eax, 'hpi'
	jne	@@9
	cmp	ebx, 58h
	jae	@@1
@@9:	stc
	leave
	ret

; ipf33.dll 00401C98 iph33_Unpack

@@1:	mov	eax, [esi]
	mov	edx, [esi+4]
	sub	eax, 'FFIR'
	sub	edx, 38h
	or	eax, edx
	jne	@@9
	mov	edx, ' pmb'
	mov	eax, [esi+14h]
	lea	ecx, [ebx-38h]
	sub	eax, 30003h
	sub	edx, [esi+38h]
	sub	ecx, [esi+3Ch]
	movzx	edi, word ptr [esi+50h]
	or	eax, edx
	sub	edi, 10h
	or	eax, ecx
	add	esi, 58h
	or	eax, edi
	jne	@@9
	movzx	edi, word ptr [esi-18h]
	movzx	edx, word ptr [esi-16h]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 23h, edi, edx
	xchg	edi, eax
	add	edi, 12h
	mov	eax, [@@SC]
	sub	eax, 58h
	cmp	word ptr [esi-6], 0
	jne	@@1b
	lea	ecx, [ebx+ebx]
	cmp	ecx, eax
	jb	$+3
	xchg	ecx, eax
	push	edi
	rep	movsb
	pop	edi
	jmp	@@1c

@@1b:	call	@@IPH33, edi, ebx, esi, eax

@@1c:	movsx	esi, word ptr [esi-4]
@@1a:	movsx	eax, word ptr [edi+ebx*2-2]
	mov	cl, -1
	test	ah, ah
	jns	$+4
	mov	cl, 80h
	cmp	esi, -1
	je	@@1d
	cmp	eax, esi
	jne	$+4
	mov	cl, 0
@@1d:	ror	eax, 10
	shl	al, 3
	mov	ah, cl
	rol	eax, 16
	shr	ax, 3
	shl	ah, 3
	mov	edx, 0E0E0E0E0h
	and	edx, eax
	shr	edx, 5
	or	eax, edx
	mov	[edi+ebx*4-4], eax
	dec	ebx
	jne	@@1a
	clc
	leave
	ret

; PgsvTd.dll 1001C030

@@2:	mov	edi, ebx
	sub	ebx, 74h
	jb	@@9
	mov	eax, [esi]
	sub	edi, [esi+8]
	mov	ecx, [esi+0Ch]
	mov	edx, [esi+18h]
	sub	eax, 'FGA'
	sub	ecx, 74h
	sub	edx, 5Ch
	or	eax, ecx
	or	edx, edi
	or	eax, edx
	jne	@@9
	shr	ebx, 2
	mov	[@@SC], ebx
	mov	edi, [esi+1Ch]
	mov	edx, [esi+20h]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 23h, edi, edx
	xchg	edi, eax
	add	esi, 74h
	add	edi, 12h
	call	@@AGF, edi, ebx, esi, [@@SC]
	clc
	leave
	ret

@@AGF PROC

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
@@1:	xor	eax, eax
	cmp	[@@DC], eax
	je	@@7
	dec	[@@SC]
	js	@@9
	lodsd
	mov	ecx, eax
	cmp	al, 1
	jne	@@1a
	shr	ecx, 8
	sub	[@@DC], ecx
	jb	@@9
	sub	[@@SC], ecx
	jb	@@9
	rep	movsd
	jmp	@@1

@@1a:	cmp	al, 2
	jne	@@1b
	shr	ecx, 8
	sub	[@@DC], ecx
	jb	@@9
	dec	[@@SC]
	js	@@9
	lodsd
	rep	stosd
	jmp	@@1

@@1b:	cmp	al, 3
	jne	@@1d
	movzx	eax, ah
	shr	ecx, 10h
	sub	[@@SC], ecx
	jb	@@9
	lea	ebx, [esi+ecx*4]
	test	eax, eax
	je	@@1c
	imul	eax, ecx
	sub	[@@DC], eax
	jb	@@9
	sub	eax, ecx
	mov	edx, edi
	rep	movsd
	xchg	ecx, eax
	mov	esi, edx
	rep	movsd
@@1c:	mov	esi, ebx
	jmp	@@1

@@1d:	cmp	al, 4
	jne	@@1
	shr	eax, 8
	shr	ecx, 14h
	and	eax, 0FFFh
	neg	eax
	xchg	edx, eax
	sub	[@@DC], ecx
	jb	@@9
	shl	edx, 2
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsd
	xchg	esi, eax
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
ENDP

@@IPH33 PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@W = dword ptr [ebp-4]
@@H = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	mov	eax, [esi-18h]
	movzx	edx, ax
	shr	eax, 10h
	push	edx
	push	eax
@@1:	dec	[@@SC]
	js	@@9
	mov	ecx, [@@W]
	lodsb
	mov	[@@DC], ecx
	test	al, al
	jne	@@1a
	shl	ecx, 1
	sub	[@@SC], ecx
	jb	@@9
	rep	movsb
	jmp	@@1e

@@1a:	xor	eax, eax
@@2:	xchg	ebx, eax
	dec	[@@SC]
	js	@@9
	lodsb
	cmp	al, -1
	je	@@1b
	dec	[@@DC]
	js	@@9
	test	al, al
	jns	@@2b
	cmp	al, -2
	jne	@@2a
	sub	[@@SC], 3
	jb	@@9
	movzx	ecx, byte ptr [esi]
	inc	esi
	sub	[@@DC], ecx
	jb	@@9
	inc	ecx
	lodsw
	rep	stosw
	jmp	@@2

@@2a:	xor	edx, edx
	and	eax, 7Fh
	lea	ecx, [edx+5]
	div	ecx
	push	edx
	xor	edx, edx
	div	ecx
	push	edx
	xor	edx, edx
	div	ecx
	mov	eax, ebx
	mov	ecx, ebx
	and	eax, 1Fh
	shr	ecx, 5
	shr	ebx, 0Ah
	lea	eax, [eax+edx-2]
	pop	edx
	and	ecx, 1Fh
	and	ebx, 1Fh
	lea	ecx, [ecx+edx-2]
	pop	edx
	shl	ecx, 5
	lea	ebx, [ebx+edx-2]
	or	eax, ecx
	shl	ebx, 0Ah
	or	eax, ebx
	stosw
	jmp	@@2

@@2b:	dec	[@@SC]
	js	@@9
	mov	ah, al
	lodsb
	stosw
	jmp	@@2

@@1b:	mov	ecx, [@@DC]
	xor	eax, eax
	rep	stosw
@@1e:	mov	ebx, [@@W]
	dec	[@@SC]
	js	@@9
	lodsb
	test	al, al
	je	@@1c
	neg	ebx
@@4:	dec	[@@SC]
	js	@@9
	xor	ecx, ecx
	lodsb
	test	al, al
	jns	@@4a
	cmp	al, -1
	je	@@1d
	dec	[@@SC]
	js	@@9
	mov	cl, [esi]
	inc	esi
@@4a:	mov	dl, 20h
@@4b:	test	ebx, ebx
	je	@@4c
	inc	ebx
	test	al, dl
	je	@@4c
	or	byte ptr [edi+ebx*2-1], 80h
@@4c:	shr	dl, 1
	jne	@@4b
	dec	ecx
	jns	@@4a
	jmp	@@4

@@1c:	dec	[@@SC]
	js	@@9
	inc	esi
@@1d:	dec	[@@H]
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
ENDP

ENDP
