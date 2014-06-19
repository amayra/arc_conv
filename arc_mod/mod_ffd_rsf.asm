
; p = a < 0x8100 ? a : (a < 0xE000 ? a - 0x8000 : a - 0xC000)

_mod_ffd_rsf PROC

@@stk = 0
@M0 @@L0, 10h
@M0 @@L1, 0Ch
@M0 @@M, 0Ch
@M0 @@S
@M0 @@D
@M0 @@P
@M0 @@H
@M0 @@L2, 8
@M0 @@L3

	enter	@@stk+60h, 0
	cmp	eax, 4
	jne	@@9a
	call	_MemAlloc, 400h+3D00h*6+10h
	jc	@@9a
	xchg	esi, eax
	lea	edi, [@@L0]
	mov	[@@M], esi
	mov	ebx, 400h

	call	_FileCreate, dword ptr [ebp+0Ch], FILE_INPUT
	jc	@@9b
	mov	[@@S], eax
	call	_FileRead, [@@S], esi, ebx
	call	@@RSFCheck, edi, esi, eax
	test	eax, eax
	je	@@9c
	add	esi, ebx
	mov	ebx, 3D00h*2
	mov	[@@M+4], esi
	call	@@Read, dword ptr [ebp+10h], 60h, esp
	cmp	eax, 5Ch
	jne	@@9c
	lea	ecx, [ebx+4]
	call	@@Read, dword ptr [ebp+14h], ecx, esi
	cmp	eax, ebx
	jne	@@9c
	add	esi, ebx
	mov	[@@M+8], esi

	call	_FileCreate, dword ptr [ebp+18h], FILE_OUTPUT
	jc	@@9c
	mov	[@@D], eax
	call	_FileWrite, [@@D], [@@M], [@@L0]

	mov	eax, [esp]
	shr	eax, 1Fh
	mov	[@@L3], eax

	finit
	and	[@@P], 0
@@1:	mov	esi, [@@L0+0Ch]
	mov	edx, [@@P]
	mov	eax, [esi+4]
	mov	[esi+4], edx
	add	eax, [@@L0]
	call	@@CopyMetric, [@@D], [@@S], eax, [@@L0+4]
	add	eax, [@@P]
	mov	[@@P], eax
	mov	[@@L2], eax
	mov	ecx, [esi]
	mov	[@@H], ecx
	mov	eax, [@@L3]
	xor	ecx, eax
	sub	ecx, eax
	mov	[esp], ecx

	mov	edi, [@@M+8]
	mov	esi, edi
	mov	eax, 'RAHC'
	stosd
	mov	eax, 'LBAT'
	stosd
	xor	eax, eax
	mov	ecx, 3D00h
	rep	stosd
	mov	eax, 'TSAR'
	stosd
	mov	eax, 'ATAD'
	stosd
	sub	edi, esi
	call	_FileWrite, [@@D], esi, edi
	add	edi, [@@P]
	mov	[@@P], edi
	mov	[@@L2+4], edi

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
@@2:	mov	edx, [@@M+4]
	movzx	eax, word ptr [edx+ebx*2]
	test	eax, eax
	je	@@2a
	call	@@GetGlyph, [@@D], [@@L1], [@@H], eax
	test	eax, eax
	je	@@2a
	mov	edx, [@@P]
	add	[@@P], eax
	sub	edx, [@@L2+4]
	mov	[esi+8+ebx*4], edx
@@2a:	inc	ebx
	cmp	ebx, 3D00h
	jb	@@2

	mov	eax, [@@L2]
	add	eax, [@@L0]
	call	_FileSeek, [@@D], eax, 0
	call	_FileWrite, [@@D], esi, 3D00h*4+10h
	mov	eax, [@@P]
	add	eax, [@@L0]
	call	_FileSeek, [@@D], eax, 0

	call	SelectObject, [@@L1], [@@L1+8]
	call	DeleteObject, [@@L1+4]
@@1b:	call	DeleteDC, [@@L1]
@@1a:	add	[@@L0+0Ch], 8
	dec	[@@L0+8]
	jne	@@1
	call	_FileSeek, [@@D], 0, 0
	call	_FileWrite, [@@D], [@@M], [@@L0]

@@9:	call	_FileClose, [@@D]
@@9c:	call	_FileClose, [@@S]
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

@@CopyMetric PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@P = dword ptr [ebp+1Ch]
@@L0 = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	enter	60h, 0
	mov	esi, esp
	call	_FileSeek, [@@S], [@@P], 0
	jc	@@9
	push	0Ch*4+10h		; 2*2 + 4*2 (short Asc, short Dsc, float Asc/H, float Dsc/H)
	pop	ebx
	test	byte ptr [@@L0], 2
	jne	@@1c
	mov	bl, 14h*4+10h	; 2*4 + 4*3
@@1c:	call	_FileRead, [@@S], esi, ebx
	jc	@@9
	sub	ebx, 8
	mov	edx, 'CRTM'
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, 'TXET'
	or	eax, edx
	jne	@@9
	mov	edx, 'LBAT'
	mov	eax, [esi+ebx]
	sub	edx, [esi+ebx+4]
	sub	eax, 'RAHC'
	or	eax, edx
	jne	@@9
	call	_FileWrite, [@@D], esi, ebx
	jc	@@9
	xchg	eax, ebx
	jmp	@@8
@@9:	xor	eax, eax
@@8:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

@@RSFCheck PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@C = dword ptr [ebp+1Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	ebx, [@@C]
	mov	esi, [@@S]
	mov	edi, [@@D]
	sub	ebx, 1Ah+0Ch
	jb	@@9
	mov	edx, 'TNOF'
	mov	eax, [esi]
	sub	edx, [esi+4]
	mov	ecx, [esi+8]
	sub	eax, 'TSAR'
	sub	ecx, 101
	or	eax, edx
	or	eax, ecx
	jne	@@9
	mov	edx, 'OFNI'
	mov	eax, [esi+0Ch]
	sub	edx, [esi+10h]
	sub	eax, 'TNOF'
	or	eax, edx
	jne	@@9
	movzx	eax, word ptr [esi+14h]
	mov	[edi+4], eax
	add	esi, 1Ah
	cmp	ah, 4
	jne	@@9
	push	4
	pop	ecx
@@1a:	movzx	eax, word ptr [esi]
	inc	eax
	inc	eax
	sub	ebx, eax
	jb	@@9
	add	esi, eax
	dec	ecx
	jne	@@1a
	mov	edx, 'LBAT'
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, 'EZIS'
	or	eax, edx
	jne	@@9
	mov	ecx, [esi+8]
	add	esi, 0Ch
	test	ecx, ecx
	je	@@9
	mov	[edi+8], ecx
	mov	[edi+0Ch], esi
	shl	ecx, 3
	sub	ebx, ecx
	jb	@@9
@@1b:	mov	eax, [esi]
	dec	eax
	shr	eax, 0Ah
	jne	@@9
	add	esi, 8
	sub	ecx, 8
	jne	@@1b
	sub	esi, [@@S]
	xchg	eax, esi
	jmp	@@8
@@9:	xor	eax, eax
@@8:	mov	[edi], eax
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

@@GetGlyph PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@H = dword ptr [ebp+1Ch]
@@C = dword ptr [ebp+20h]

@@stk = 0
@M0 @@M
@M0 @@L1, 0Ch
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
	inc	ebx
	test	esi, esi
	je	@@9
	shr	ebx, 1
	imul	ebx, [@@H]
	add	ebx, 6
	call	_MemAlloc, ebx
	jc	@@9
	mov	[@@M], eax
	mov	[@@N], ebx
	xchg	edi, eax

	mov	ebx, [@@L0]
	fild	dword ptr [@@L0]
	fidiv	dword ptr [@@H]
	fstp	dword ptr [edi+2]
	mov	[edi], bx
	add	edi, 6

	mov	eax, [@@L0+4]
	mov	ecx, [@@H]
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
	mov	[@@L0+4], eax
	sub	[@@H], eax
	dec	eax
	js	@@1f
	imul	eax, ebx
	lea	esi, [esi+eax*4]
@@1a:	xor	ebx, ebx
@@1b:	mov	al, [esi+1]
	add	esi, 4
	test	bl, 1
	jne	@@1d
	and	al, 0F0h
	stosb
	jmp	@@1e
@@1d:	shr	al, 4
	or	[edi-1], al
@@1e:	inc	ebx
	cmp	ebx, [@@L0]
	jb	@@1b
	neg	ebx
	lea	esi, [esi+ebx*8]
	dec	[@@L0+4]
	jne	@@1a
@@1f:	mov	ecx, [@@L0]
	inc	ecx
	shr	ecx, 1
	imul	ecx, [@@H]
	xor	eax, eax
	rep	stosb

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
