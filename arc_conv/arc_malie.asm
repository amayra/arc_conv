
; "Popotan Po!", "Shiokaze no Kieru Umi ni" *.lib

	dw _conv_malie-$-2
_arc_malie PROC

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
	pop	ebx
	pop	ecx
	sub	eax, 'BIL'
	rol	eax, 8
	movzx	edi, al
	cmp	eax, edi
	jne	@@9a
	mov	[@@N], ebx
	cmp	al, 'P'
	je	_mod_malie_p
	lea	ecx, [ebx-1]
	sub	edx, 10000h
	shr	ecx, 14h
	or	edx, ecx
	jne	@@9a
	cmp	al, 'U'
	je	_mod_malie_u
	test	al, al
	jne	@@9a
	imul	ebx, 30h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 24h
	and	[@@D], 0
	mov	ebx, [esi+24h]
	call	_FileSeek, [@@S], dword ptr [esi+28h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	cmp	ebx, 10h
	jb	@@1a
	mov	edi, [@@D]
	mov	edx, 10000h
	mov	eax, [edi]
	sub	edx, [edi+4]
	sub	eax, 'BIL'
	shl	eax, 8
	or	eax, edx
	jne	@@1a
	call	_ArcSetExt, 'bil'
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 30h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_mod_malie_u PROC

@@S = dword ptr [ebp+8]
@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	imul	ebx, 50h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	call	_ArcUnicode, 1

@@1:	call	_ArcName, esi, 22h
	and	[@@D], 0
	mov	ebx, [esi+44h]
	call	_FileSeek, [@@S], dword ptr [esi+48h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	cmp	ebx, 10h
	jb	@@1a
	mov	edi, [@@D]
	mov	edx, 10000h
	mov	eax, [edi]
	sub	edx, [edi+4]
	sub	eax, 'BIL'
	shl	eax, 8
	or	eax, edx
	jne	@@1a
	call	_ArcSetExt, 'bil'
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 50h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

; "Zettai Meikyuu Grimm Director's Cut"

_mod_malie_p PROC

@@S = dword ptr [ebp+8]
@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@L0, 0Ch
@M0 @@L1, 8

	lea	esp, [ebp-@@stk]
	lea	ecx, [edx-1]
	cmp	ebx, edx
	jae	@@9a
	shr	ecx, 14h
	jne	@@9a
	lea	eax, [edx-1]
	mov	[@@L0+4], edx
	mov	[@@L0+8], eax
	shl	edx, 5
	lea	ebx, [edx+ebx*4]
	mov	[@@L0], edx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	lea	eax, [ebx+10h+0FFFh]
	mov	esi, [@@M]
	and	eax, -1000h
	add	[@@L0], esi
	mov	[@@P], eax
	movzx	eax, word ptr [esi+16h]
	or	al, [esi]
	test	eax, eax
	jne	@@9
	call	_ArcCount, [@@N]
	mov	[@@L1+4], esp
	sub	esp, 200h
	mov	[@@L1], esp
	mov	edi, esp

	xor	ebx, ebx
	inc	ebx
@@1:	dec	ebx
	lea	edx, [esi+20h]
	push	ebx
	push	edi
	push	edx
	call	@@3
	jc	@@8
	cmp	word ptr [esi+16h], 0
	jne	@@1c
	dec	edi
	cmp	esi, [@@M]
	je	@@1b
	mov	al, 2Fh
	stosb
@@1b:	mov	edx, esi
	sub	edx, [@@M]
	shr	edx, 5
	add	edx, ebx
	mov	ecx, [esi+18h]
	mov	ebx, [esi+1Ch]
	cmp	ecx, edx
	jb	@@8
	cmp	ecx, [@@L0+4]
	jae	@@8
	sub	[@@L0+8], ebx
	jb	@@9
	mov	esi, [@@M]
	shl	ecx, 5
	add	esi, ecx
	jmp	@@1d

@@1c:	call	_ArcName, [@@L1], -1
	and	[@@D], 0
	mov	ecx, [esi+18h]
	mov	edx, [@@L0]
	cmp	ecx, [@@N]
	jae	@@1a
	mov	eax, [edx+ecx*4]
	mov	ebx, [esi+1Ch]
	shl	eax, 0Ah
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	pop	esi
	pop	edi
	pop	ebx
	call	_ArcBreak
	jc	@@9
@@1d:	test	ebx, ebx
	jne	@@1
	cmp	[@@L1], esp
	jne	@@8

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	xor	ecx, ecx
@@3a:	xor	eax, eax
	cmp	ecx, 16
	jae	@@3b
	mov	al, [esi+ecx]
	inc	ecx
@@3b:	cmp	edi, [@@L1+4]
	je	@@3c
	stosb
	test	al, al
	jne	@@3a
	ret
@@3c:	stc
	ret
ENDP

_conv_malie PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'fgm'
	jne	@@9
	cmp	ebx, 8
	jb	@@9
	mov	eax, 'ilaM'
	mov	edx, 'FGe'
	sub	eax, [esi]
	sub	edx, [esi+4]
	or	eax, edx
	je	@@1
@@9:	stc
	leave
	ret

@@1:	cmp	ebx, 10h
	jb	@@1a
	mov	eax, 'ilaM'
	mov	edx, 'FGe'
	sub	eax, [esi+ebx-8]
	sub	edx, [esi+ebx-4]
	or	eax, edx
	jne	@@1a
	sub	ebx, 8
@@1a:	
	mov	dword ptr [esi], 474E5089h
	mov	dword ptr [esi+4], 0A1A0A0Dh
	call	_ArcSetExt, 'gnp'
	call	_ArcData, esi, ebx
	clc
	leave
	ret
ENDP
