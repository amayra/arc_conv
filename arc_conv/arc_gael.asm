
; "Galaxy Angel Eternal Lovers" Dat\gadat0??.pak
; BaseLib.dll
; 6300D0F0 crc32

	dw _conv_gael-$-2
_arc_gael PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@I
@M0 @@L0, 14h
@M0 @@L2
@M0 @@L3

	enter	@@stk+8, 0

	call	_unicode_ext, -1, offset inFileName
	cmp	eax, 'kap'
	jne	@@9a

	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	eax
	pop	ebx
	sub	eax, ' FPI'
	lea	ecx, [ebx-1]
	shr	ecx, 14h
	or	eax, ecx
	jne	@@9a
	mov	[@@N], ebx
	and	[@@I], 0
	or	[@@L2], -1
	or	[@@L3], -1

	imul	ebx, 0Ch
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	@@Sort, esi, [@@N]
	call	_ArcCount, [@@N]

@@1:	lea	edi, [@@L0]
	call	_StrDec32, 7, [@@I], edi
	add	edi, eax
	mov	al, '_'
	stosb
	mov	eax, [esi]
	push	8
	pop	ecx
@@1c:	rol	eax, 4
	push	eax
	and	al, 0Fh
	add	al, -10
	sbb	ah, ah
	add	al, 3Ah
	and	ah, 27h-20h
	add	al, ah
	stosb
	dec	ecx
	pop	eax
	jne	@@1c
	xchg	eax, ecx
	stosb
	lea	edi, [@@L0]
	call	_ArcName, edi, -1
	and	[@@D], 0

	mov	eax, [esi+4]
	mov	ebx, [esi+8]
	shr	eax, 1Ch
	cmp	eax, [@@L2]
	je	@@1b
	mov	[@@L2], eax
	imul	edx, eax, 0CCCDh
	shr	edx, 13h
	lea	ecx, [edx*4+edx]
	shl	ecx, 1
	sub	eax, ecx
	mov	ah, al
	mov	al, dl
	shl	eax, 8
	add	eax, '00p'
	push	eax
	call	_FileClose, [@@L3]
	call	_ArcInputExt
	mov	[@@L3], eax
@@1b:
	mov	eax, [esi+4]
	and	eax, 0FFFFFFFh
	call	_FileSeek, [@@L3], eax, 0
	jc	@@1a
	call	_MemAlloc, ebx
	jc	@@1a
	mov	[@@D], eax
	call	_FileRead, [@@L3], eax, ebx
	xchg	ebx, eax
	cmp	ebx, 0Ah
	jb	@@1a
	mov	edx, [@@D]
	cmp	word ptr [edx], '0Z'
	jne	@@1a
	mov	eax, [edx+2]
	bswap	eax
	call	_MemAlloc, eax
	jc	@@1a
	xchg	edi, eax
	mov	edx, [@@D]
	mov	eax, [edx+2]
	bswap	eax
	lea	ecx, [ebx-0Ah]
	add	edx, 0Ah
	call	_zlib_raw_unpack, edi, eax, edx, ecx
	xchg	ebx, eax
	call	_MemFree, [@@D]
	mov	[@@D], edi
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	inc	[@@I]
	add	esi, 0Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_FileClose, [@@L3]
	call	_MemFree, [@@M]
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

_conv_gael PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 8
	jb	@@9
	mov	eax, [esi]
	mov	edx, [esi+4]
	cmp	eax, 'Ba8T'
	je	@@1c
	cmp	eax, ' 23T'
	je	@@1d	
	mov	ecx, 'MBT'
	sub	ecx, eax
	shl	ecx, 8
	je	@@1
	sub	eax, 'SggO'
	sub	dh, 2
	or	eax, edx
	jne	@@2a
	push	'ggo'
@@9a:	call	_ArcSetExt
@@9:	stc
	leave
	ret

@@2a:	cmp	ebx, 36h
	jb	@@9
	movzx	eax, word ptr [esi]
	mov	edx, [esi+0Eh]
	sub	eax, 'MB'
	sub	edx, 28h
	or	eax, edx
	jne	@@9
	push	'pmb'
	jmp	@@9a

@@1:	rol	eax, 8
	push	28h
	pop	ecx
	cmp	al, 20h
	je	@@1a
	cmp	al, 'B'
	jne	@@9
	add	ecx, 4
@@1a:	sub	ebx, ecx
	jb	@@9
	mov	eax, [esi+1Ch]
	lea	ecx, [eax-1]
	imul	eax, 14h
	shr	ecx, 7
	jne	@@9
	mov	ecx, [esi+20h]
	sub	ebx, eax
	jb	@@9
	shr	ecx, 3
	lea	edx, [ecx-2]
	shr	edx, 1
	jne	@@9
@@1b:	mov	edi, [esi+14h]
	mov	edx, [esi+18h]
	call	_ArcTgaAlloc, 23h, edi, edx
	xchg	edi, eax
	add	edi, 12h
	call	@@Unpack, edi, 0, esi, [@@SC]
	clc
	leave
	ret

@@1c:	sub	ebx, 4
	jb	@@9
@@1d:	sub	ebx, 20h
	jb	@@9
	mov	eax, [esi+1Ch]
	lea	ecx, [eax-1]
	imul	eax, 14h
	shr	ecx, 7
	jne	@@9
	sub	ebx, eax
	jb	@@9
	jmp	@@1b

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@W = dword ptr [ebp-4]
@@H = dword ptr [ebp-8]
@@X = dword ptr [ebp-0Ch]
@@Y = dword ptr [ebp-10h]
@@I = dword ptr [ebp-14h]
@@N = dword ptr [ebp-18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
	push	20h
	pop	ecx
	cmp	byte ptr [esi+1], 'B'
	jne	@@1a
	mov	ecx, [esi+20h]
@@1a:	movzx	eax, word ptr [edi-12h+0Ch]
	movzx	edx, word ptr [edi-12h+0Eh]
	shr	ecx, 3
	push	eax	; @@W
	push	edx	; @@H
	push	ecx
	push	ecx
	push	0
	push	ecx
@@1:	mov	ebx, [@@I]
	mov	esi, [@@SB]
	mov	ecx, [@@SC]
	cmp	ebx, [esi+1Ch]
	jae	@@7
	mov	al, [esi+1]
	inc	[@@I]
	cmp	al, 33h
	je	@@1b
	inc	ebx
	cmp	al, 38h
	je	@@1b
	cmp	byte ptr [esi+3], 21h
	sbb	ebx, -2
@@1b:	mov	eax, [esi+20h+ebx*4]
	sub	ecx, eax
	jb	@@9
	sub	ecx, 10h
	jb	@@9
	add	esi, eax
	push	ecx
	mov	edi, [esi+4]
	mov	ecx, [esi]
	mov	ebx, edi
	imul	edi, [@@W]
	mov	edx, [esi+0Ch]
	mov	eax, [esi+8]
	add	edi, ecx
	add	ecx, eax
	add	ebx, edx
	cmp	[@@W], ecx
	jb	@@9
	cmp	[@@H], ebx
	jb	@@9
	pop	ecx
	mov	ebx, [@@N]
	mov	[@@Y], edx
	mov	[@@X], eax
	imul	eax, ebx
	cmp	ebx, 3
	jne	@@1c
	add	eax, 3
	and	eax, -4
@@1c:	imul	eax, edx
	mov	edx, [@@DB]
	test	eax, eax
	je	@@9
	lea	edi, [edx+edi*4]
	sub	ecx, eax
	jb	@@9
	add	esi, 10h

@@2a:	mov	ecx, [@@X]
	push	edi
	mov	edx, [@@N]
	xor	eax, eax
	cmp	edx, 3
	ja	@@2d
	je	@@2c
@@2b:	movzx	eax, word ptr [esi]
	add	esi, 2
	ror	eax, 5
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
	mov	[edi], eax
	add	edi, 4
	dec	ecx
	jne	@@2b
	jmp	@@2e

@@2c:	movsb
	movsb
	movsb
	stosb
	dec	ecx
	jne	@@2c
	mov	eax, [@@X]
	neg	eax
	and	eax, 3
	add	esi, eax
	jmp	@@2e

@@2d:	rep	movsd
@@2e:	pop	edi
	mov	eax, [@@W]
	lea	edi, [edi+eax*4]
	dec	[@@Y]
	jne	@@2a
	jmp	@@1

@@7:	xor	esi, esi
@@9:	xor	eax, eax
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

ENDP
