
_arc_dir PROC

@@R = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1
@M0 @@L2
@M0 @@S

	enter	@@stk, 0
	call	_BlkCreate, 4000h
	jc	@@9a
	mov	[@@M], eax
	xor	eax, eax
	lea	esi, [@@L1]
	mov	[@@N], eax
	mov	[@@L2], esi
	mov	[edx], eax
	mov	ebx, offset inFileName
	call	_FindFile, offset @@3, ebx
	call	_ArcSetCP, 0
	call	_ArcUnicode, 1
	cmp	[@@N], 0
	je	@@1c
	call	_ArcCount, [@@N]
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@9
	and	[@@D], 0
	mov	eax, [esi+2Ch]
	mov	ebx, eax
	shr	eax, 1Dh
	or	eax, [esi+28h]
	jne	@@8
	call	_ArcName, dword ptr [esi+4], -1
	lea	edx, [esi+30h]
	call	_FileCreate, edx, FILE_INPUT+8
	jc	@@8
	mov	[@@S], eax
@@1b:	lea	eax, [ebx+200h]
	call	_MemAlloc, eax
	jc	@@1a
	mov	[@@D], eax
	call	_FileRead, [@@S], eax, ebx
	xchg	ebx, eax
@@1a:	call	_FileClose, [@@S]
	test	ebx, ebx
	je	@@8
	cmp	[@@D], 0
	je	@@8
	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jnc	@@1
@@9:	call	_BlkDestroy, [@@M]
@@9a:	leave
	ret

@@1c:	call	_FileCreate, ebx, FILE_INPUT+8
	jc	@@9
	mov	[@@S], eax
	and	[@@D], 0

	mov	ecx, ebx
@@1d:	mov	edx, ecx
@@1e:	movzx	eax, word ptr [ecx]
	inc	ecx
	inc	ecx
	cmp	eax, '\'
	je	@@1d
	cmp	eax, '/'
	je	@@1d
	test	eax, eax
	jne	@@1e
	call	_ArcName, edx, -1

	xor	ebx, ebx
	call	_ArcCount, 1
	call	_FileGetSize, [@@S]
	jc	@@1a
	mov	ebx, eax
	shr	eax, 1Dh
	jne	@@1a
	jmp	@@1b

@@3:	mov	edx, [esp+4]
	mov	eax, [@@R]
	test	edx, edx
	je	@@3a
	test	byte ptr [edx], 10h
	jne	@@3b
	mov	esi, [esp+8]
	mov	ebx, [esp+14h]
	sub	ebx, esi
	lea	eax, [ebx+24h+0Ch]
	shr	ebx, 1
	call	_BlkAlloc, [@@M], eax
	jc	@@3a
	mov	edx, [@@L2]
	mov	[@@L2], eax
	mov	[edx], eax
	inc	[@@N]
	xchg	edi, eax
	mov	edx, [esp+0Ch]
	xor	eax, eax
	sub	edx, esi
	lea	ecx, [eax+9]
	shr	edx, 1
	stosd
	lea	eax, [edi+2Ch+edx*2]
	stosd
	lea	eax, [ebx-1]
	sub	eax, edx
	stosd
	mov	eax, [esp+4]
	xchg	esi, eax
	rep	movsd
	xchg	esi, eax
	mov	ecx, ebx
	rep	movsw
@@3a:	xor	eax, eax
	inc	eax
@@3b:	ret
ENDP

	dw _conv_copy-$-2
_arc_copy:
	ret
_conv_copy PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	call	_ArcData, esi, ebx
	clc
	leave
	ret
ENDP
