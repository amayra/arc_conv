
; "Himegari Dungeon Meister" SYS4INI.BIN

	dw _conv_eushully-$-2
_arc_eushully PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC
@M0 @@L0
@M0 @@L1
@M0 @@L2
@M0 @@L3
@M0 @@L4

	enter	@@stk+138h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	movzx	eax, word ptr [esi]
	movzx	edx, byte ptr [esi+3]
	sub	eax, '3S'
	sub	edx, 'C'
	xchg	al, ah
	shr	eax, 1
	or	eax, edx
	jne	@@9a
	mov	eax, [esi+4]
	sub	eax, 20303030h
	test	eax, NOT 0F0F0Fh
	jne	@@9a
	mov	al, [esi+2]
	mov	edi, 130h
	cmp	al, 'I'
	je	@@2d
	cmp	al, 'A'
	jne	@@9a
	sub	edi, 20h	; APPEND01.AAI 0x10C
@@2d:	add	esi, 8
	call	_FileRead, [@@S], esi, edi
	jc	@@9a
	add	esi, edi
	mov	ebx, [esi-0Ch]
	mov	edi, [esi-4]
	cmp	ebx, [esi-8]
	jne	@@9
	cmp	ebx, 104h
	jb	@@9
	mov	ecx, ebx
	cmp	edi, ebx
	jne	$+4
	xor	ecx, ecx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, ecx, edi, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	edi, ebx
	je	@@2a
	call	_lzss_unpack, esi, ebx, edx, edi
@@2a:	mov	[@@SC], ebx
	mov	edi, [esi]
	lea	ecx, [edi-1]
	shl	edi, 8
	shr	ecx, 7
	jne	@@9
	add	edi, 8
	cmp	ebx, edi
	jb	@@9
	mov	eax, [esi+edi-4]
	mov	[@@N], eax
	lea	ecx, [eax-1]
	imul	edx, eax, 50h
	shr	ecx, 14h
	jne	@@9
	add	edx, edi
	cmp	ebx, edx
	jb	@@9
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx
	add	esi, edi

	mov	ebx, offset inFileName
	lea	esp, [ebp-@@stk]
	call	_unicode_name, ebx
	sub	eax, ebx
	mov	ecx, eax
	sub	esp, 204h
	and	eax, -4
	sub	esp, eax
	mov	edi, esp
	push	esi
	mov	esi, ebx
	rep	movsb
	pop	esi
	mov	[@@L3], edi
	mov	[@@L4], esp

@@2b:	mov	ebx, [@@M]
	mov	eax, [@@L2]
	cmp	eax, [ebx]
	jae	@@9
	shl	eax, 8
	lea	ebx, [ebx+eax+4]

	mov	ecx, 100h
	xor	eax, eax
	mov	edi, ebx
	repne	scasb
	jne	@@2c
	sub	edi, ebx
	dec	edi
	call	_ansi_to_unicode, 932, ebx, edi, [@@L3]
	mov	edx, esp
	call	_FileCreate, edx, FILE_INPUT
	jc	@@2c
	mov	ecx, [@@N]
	mov	[@@L0], eax
	mov	[@@L1], ecx
	inc	edi
	sub	esp, 44h
	mov	eax, edi
	mov	ecx, edi
	and	eax, -4
	sub	esp, eax
	mov	edi, esp
	push	esi
	mov	esi, ebx
	mov	edx, edi
	rep	movsb
	pop	esi
	mov	byte ptr [edi-1], 5Ch
	push	esi
	call	@@1, edx, edi
	pop	esi
	call	_FileClose, [@@L0]
@@2c:	mov	esp, [@@L4]
	inc	[@@L2]
	call	_ArcBreak
	jnc	@@2b

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@1:	mov	eax, [@@L2]
	cmp	word ptr [esi], 40h
	je	@@8
	cmp	dword ptr [esi+48], -1
	je	@@8
	cmp	[esi+40h], eax
	jne	@@8
	push	40h
	pop	ecx
	mov	eax, [esp+4]
	mov	edi, [esp+8]
	push	esi
	rep	movsb
	pop	esi
	call	_ArcName, eax, 40h
	and	[@@D], 0
	mov	ebx, [esi+4Ch]
	call	_FileSeek, [@@L0], dword ptr [esi+48h], 0
	jc	@@1a
	call	_MemAlloc, ebx
	jc	@@1a
	mov	[@@D], eax
	call	_FileRead, [@@L0], eax, ebx
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 50h
	call	_ArcBreak
	jc	@@1b
	dec	[@@L1]
	jne	@@1
@@1b:	ret	8
ENDP

_conv_eushully PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'fga'
	jne	@@9
	cmp	ebx, 4
	jb	@@4a
	cmp	dword ptr [esi], 0BA010000h
	jne	@@4a
	call	_ArcSetExt, 'gpm'
	jmp	@@9
@@4a:
	sub	[@@SC], 18h+0Ch
	jb	@@9
	mov	edx, [esi+4]
	mov	eax, [esi]
	dec	edx
	test	eax, eax
	je	@@1f
	sub	eax, 'FGCA'
	dec	edx
@@1f:	or	eax, edx
	or	eax, [esi+8]
	lea	esi, [esi+0Ch]
	jne	@@9
	mov	eax, [esi]
	cmp	eax, 438h
	jne	@@9
	sub	esp, eax
	mov	edi, esp
	call	@@3
	jc	@@9
	cmp	dword ptr [edi+10h], 28h
	je	@@1
@@9:	stc
	leave
	ret

@@1:	movzx	eax, word ptr [edi+1Eh]
	mov	ecx, [edi+14h]
	mov	edx, [edi+18h]
	lea	ebx, [ecx+3]
	cmp	eax, 8
	je	@@1a
	cmp	eax, 18h
	jne	@@9
	lea	ebx, [ecx*2+ebx]
@@1a:	and	ebx, -4
	imul	ebx, edx
	cmp	dword ptr [esi], ebx
	jne	@@9
	call	_ArcTgaAlloc, 3, ecx, edx
	xchg	edi, eax
	movzx	eax, word ptr [edi+0Ch]
	movzx	edx, word ptr [edi+0Eh]
	imul	eax, edx
	shl	eax, 2
	sub	eax, ebx
	add	edi, 12h
	push	edi
	add	edi, eax
	push	edi
	call	@@3
	mov	[@@SB], esi
	pop	esi
	pop	edi
	jc	@@9

	push	ebp
	push	edi
	lea	ebp, [esp+8]
	mov	ebx, [ebp+18h]
@@1b:	mov	ecx, [ebp+14h]
	cmp	byte ptr [ebp+1Eh], 8
	je	@@1d
	mov	al, 0FFh
@@1c:	movsb
	movsb
	movsb
	stosb
	dec	ecx
	jne	@@1c
	mov	eax, [ebp+14h]
	jmp	@@1e
@@1d:	movzx	eax, byte ptr [esi]
	inc	esi
	mov	eax, [ebp+38h+eax*4]
	xor	eax, 0FF000000h
	stosd
	dec	ecx
	jne	@@1d
	mov	eax, [ebp+14h]
	neg	eax
@@1e:	and	eax, 3
	add	esi, eax
	dec	ebx
	jne	@@1b
	pop	edi
	pop	ebp
	mov	esi, [@@SB]
	sub	[@@SC], 24h
	jb	@@2d
	mov	edx, [esi+4]
	mov	eax, [esi]
	dec	edx
	sub	eax, 'FICA'
	dec	edx
	or	eax, edx
	or	eax, [esi+8]
	jne	@@2d
	movzx	ecx, word ptr [edi-12h+0Ch]
	movzx	edx, word ptr [edi-12h+0Eh]
	mov	eax, ecx
	imul	eax, edx
	sub	ecx, [esi+10h]
	sub	edx, [esi+14h]
	or	ecx, edx
	jne	@@2d
	cmp	[esi+0Ch], eax
	jne	@@2d
	add	esi, 18h
	cmp	[esi], eax
	jne	@@2d
	call	_MemAlloc, eax
	jc	@@2d
	push	edi
	xchg	edi, eax
	call	@@3
	mov	esi, edi
	pop	edi
	push	esi
	jc	@@2c
	movzx	edx, word ptr [edi-12h+0Ch]
	movzx	ebx, word ptr [edi-12h+0Eh]
	lea	eax, [ebx-1]
	imul	eax, edx
	lea	edi, [edi+eax*4]
@@2a:	mov	ecx, edx
@@2b:	add	edi, 3
	movsb
	dec	ecx
	jne	@@2b
	mov	eax, edx
	shl	eax, 3
	sub	edi, eax
	dec	ebx
	jne	@@2a
@@2c:	call	_MemFree
@@2d:	clc
	leave
	ret

@@3:	mov	ecx, [esi]
	mov	eax, [esi+4]
	mov	ebx, [esi+8]
	sub	eax, ecx
	add	esi, 0Ch
	neg	eax
	jc	@@3a
	sub	[@@SC], ebx
	jb	@@3a
	cmp	ecx, ebx
	je	@@3b
	call	_lzss_unpack, edi, ecx, esi, ebx
	add	esi, ebx
@@3a:	ret

@@3b:	push	edi
	rep	movsb
	pop	edi
	clc
	ret
ENDP
