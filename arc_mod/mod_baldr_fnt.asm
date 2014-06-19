
_mod_baldr_fnt PROC

@@stk = 0
@M0 @@L0, 10h
@M0 @@L1, 0Ch
@M0 @@M, 8
@M0 @@S
@M0 @@D
@M0 @@P

	enter	@@stk+60h, 0
	cmp	eax, 3
	jne	@@9a
	call	_MemAlloc, 2D09h*12h+0Ch
	jc	@@9a
	xchg	esi, eax
	mov	[@@M], esi
	mov	ebx, 2D09h
	call	@@Read, dword ptr [ebp+0Ch], 60h, esp
	cmp	eax, 5Ch
	jne	@@9b
	lea	ecx, [ebx+ebx+2]
	call	@@Read, dword ptr [ebp+10h], ecx, esi
	ror	eax, 1
	mov	[@@L0], eax
	dec	eax
	cmp	eax, ebx
	jae	@@9b
	lea	edi, [esi+ebx*2]
	mov	[@@M+4], edi

	mov	eax, 'TNF'
	stosd
	xor	eax, eax
	xor	ecx, ecx
	inc	eax
	stosd
	mov	eax, [@@L0]
	stosd
	shl	eax, 2
	xchg	ecx, eax
	rep	stosd

	call	_FileCreate, dword ptr [ebp+14h], FILE_OUTPUT
	jc	@@9b
	mov	[@@D], eax

	mov	ecx, [@@L0]
	shl	ecx, 4
	add	ecx, 0Ch
	mov	[@@P], ecx
	call	_FileWrite, [@@D], [@@M+4], ecx

	call	CreateCompatibleDC, 0
	mov	[@@L1], eax
	and	[@@L1+4], 0
	test	eax, eax
	je	@@1a
	call	CreateFontIndirectW, esp
	mov	[@@L1+4], eax
	test	eax, eax
	je	@@1b
	call	SelectObject, [@@L1], eax
	mov	[@@L1+8], eax
	call	SetBkMode, [@@L1], 1
	call	SetTextColor, [@@L1], 0FFFFFFh

	xor	ebx, ebx
@@2:	mov	edx, [@@M]
	movzx	eax, word ptr [edx+ebx*2]
	test	eax, eax
	je	@@2a
	lea	ecx, [ebx+ebx]
	mov	esi, [@@M+4]
	lea	esi, [esi+0Ch+ecx*8]
	call	@@GetGlyph, [@@D], [@@L1], eax, esi
	test	eax, eax
	je	@@2a
	mov	edx, [@@P]
	add	[@@P], eax
	mov	[esi+0Ch], edx
@@2a:	inc	ebx
	cmp	ebx, [@@L0]
	jb	@@2

	mov	esi, [@@M+4]
	add	esi, 0Ch+5Fh*10h

	xor	ebx, ebx
@@2b:	mov	edx, [@@M]
	movzx	eax, word ptr [edx+ebx*2]
	test	eax, eax
	jne	@@2c
	lea	ecx, [ebx+ebx]
	mov	edi, [@@M+4]
	lea	edi, [edi+0Ch+ecx*8]
	push	esi
	movsd
	movsd
	movsd
	movsd
	pop	esi
@@2c:	inc	ebx
	cmp	ebx, [@@L0]
	jb	@@2b

	call	SelectObject, [@@L1], [@@L1+8]
	call	DeleteObject, [@@L1+4]
@@1b:	call	DeleteDC, [@@L1]
@@1a:
	call	_FileSeek, [@@D], 0, 0
	mov	ecx, [@@L0]
	shl	ecx, 4
	add	ecx, 0Ch
	call	_FileWrite, [@@D], [@@M+4], ecx

@@9:	call	_FileClose, [@@D]
@@9b:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@Read PROC
	push	0
	call	_FileCreate, dword ptr [esp+8+4], FILE_INPUT
	jc	@@9
	push	eax
	call	_FileRead, eax, dword ptr [esp+0Ch+0Ch], dword ptr [esp+8+8]
	mov	[esp+4], eax
	call	_FileClose
@@9:	pop	eax
	ret	0Ch
ENDP

@@GetGlyph PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@C = dword ptr [ebp+1Ch]
@@L2 = dword ptr [ebp+20h]

@@stk = 0
@M0 @@M
@M0 @@L1, 0Ch
@M0 @@L3, 10h
@M0 @@N
@M0 @@L0, 8

	push	ebx
	push	esi
	push	edi
	enter	@@stk-0Ch, 0
	xor	eax, eax
	push	eax
	push	eax
	push	eax
	lea	edx, [@@C]
	call	GetTextExtentPoint32W, [@@S], edx, 1, esp
	test	eax, eax
	je	@@9a
	xor	eax, eax
	cmp	[@@L0], eax
	je	@@9a
	push	eax		; biClrImportant
	push	eax		; biClrUsed
	push	eax		; biYPelsPerMeter
	push	eax		; biXPelsPerMeter
	push	eax		; biSizeImage
	push	eax		; biCompression
	push	200001h		; biPlanes, biBitCount
	push	[@@L0+4]	; biHeight
	push	[@@L0]		; biWidth
	push	28h		; biSize
	lea	ecx, [@@L1+8]
	mov	edx, esp
	call	CreateDIBSection, [@@S], edx, 0, ecx, 0, 0
	test	eax, eax
	je	@@9a
	mov	[@@L1], eax
	call	SelectObject, [@@S], [@@L1]
	mov	[@@L1+4], eax
	call	PatBlt, [@@S], 0, 0, [@@L0], [@@L0+4], 0000042h

	lea	edx, [@@C]
	call	TextOutW, [@@S], 0, 0, edx, 1
	call	GdiFlush

	mov	ebx, [@@L0]
	mov	esi, [@@L1+8]
	lea	eax, [ebx+ebx]
	test	esi, esi
	je	@@9
	imul	eax, [@@L0+4]
	call	_MemAlloc, eax
	jc	@@9
	mov	[@@M], eax
	xchg	edi, eax

	xor	ecx, ecx
	mov	eax, [@@L0+4]
	mov	[@@L3], eax
	mov	[@@L3+4], ecx
	mov	[@@L3+8], ecx
	dec	eax
	js	@@1f
	imul	eax, ebx
	lea	esi, [esi+eax*4]
@@1a:	xor	ebx, ebx
	mov	[@@L3+0Ch], ebx
@@1b:	mov	al, [esi+1]
	add	esi, 4
	cmp	al, 0F8h
	jae	@@1d
	and	al, 0F0h
	jmp	@@1e
@@1d:	mov	al, 0FFh
@@1e:	cmp	al, 1
	cmc
	sbb	ah, ah
	xchg	al, ah
	stosw
	or	[@@L3+0Ch], eax
	inc	ebx
	cmp	ebx, [@@L0]
	jb	@@1b

	mov	ecx, [@@L3+8]
	mov	eax, [@@L3+0Ch]
	lea	edx, [ecx+1]
	test	al, al
	je	@@3b
	cmp	ecx, [@@L3]
	jae	@@3a
	mov	[@@L3], ecx
@@3a:	cmp	[@@L3+4], edx
	jae	@@3b
	mov	[@@L3+4], edx
@@3b:	neg	ebx
	mov	[@@L3+8], edx
	lea	esi, [esi+ebx*8]
	cmp	edx, [@@L0+4]
	jb	@@1a
@@1f:
	mov	eax, [@@L3]
	cmp	eax, [@@L3+4]
	sbb	edx, edx
	and	eax, edx
	sub	[@@L3+4], eax
	mov	[@@L3], eax

	mov	edi, [@@L2]
	mov	ecx, [@@L0]
	mov	ebx, [@@L3+4]
	mov	[edi], eax
	mov	[edi+4], ecx
	mov	[edi+8], ebx
	imul	ecx, ebx
	shl	ecx, 1
	mov	[@@N], ecx
	je	@@2b
	mov	eax, [@@L3]
	mov	edi, [@@M]
	imul	eax, [@@L0]
	lea	esi, [edi+eax*2]
@@2a:	mov	ecx, [@@L0]
	rep	movsw
	dec	ebx
	jne	@@2a
@@2b:
	mov	esi, [@@M]
	call	_FileWrite, [@@D], esi, [@@N]
	call	_MemFree, esi
@@9:	call	SelectObject, [@@S], [@@L1+4]
	call	DeleteObject, [@@L1]
@@9a:	mov	eax, [@@N]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

ENDP
