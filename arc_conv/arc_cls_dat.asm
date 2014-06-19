
; "Unlimited Mahjong Works" *.dat
; UMW.EXE

	dw _conv_cls_dat-$-2
_arc_cls_dat PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+40h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 40h
	jc	@@9a
	mov	edi, offset @@sign
	push	4
	pop	ecx
	repe	cmpsd
	jne	@@9a
	mov	ebx, [esi]
	mov	ecx, [esi+8]
	mov	edx, [esi+0Ch]
	mov	[@@N], ebx
	lea	eax, [ebx-1]
	shl	ebx, 6
	sub	edx, ecx
	shr	eax, 14h
	sub	edx, ebx
	sub	ecx, 40h
	or	eax, edx
	or	eax, ecx
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 28h
	and	[@@D], 0
	mov	ebx, [esi+30h]
	call	_FileSeek, [@@S], dword ptr [esi+2Ch], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 40h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@sign	db 'CLS_FILELINK',0,0,0,0
ENDP

_conv_cls_dat PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 30h
	jb	@@9
	mov	edi, offset @@sign
	push	4
	pop	ecx
	repe	cmpsd
	jne	@@9
	mov	eax, [esi+8]
	mov	ch, 2
	sub	eax, 30h
	jb	@@9
	lea	esi, [esi+20h+eax]
	add	eax, ecx
	sub	ebx, eax
	jb	@@9
	cmp	[esi], ecx
	jne	@@9
	movzx	eax, word ptr [esi+30h]
	dec	eax
	xchg	al, ah
	sub	al, 4
	cmp	eax, 2
	jae	@@9
	add	eax, 3
	push	eax	; @@L0
	mov	edi, [esi+1Ch]
	mov	edx, [esi+20h]
	lea	ecx, [eax+20h-1]
	call	_ArcTgaAlloc, ecx, edi, edx
	xchg	edi, eax
	xor	ebx, ebx
@@1:	mov	ecx, [@@SB]
	mov	eax, [@@SC]
	sub	eax, [ecx+18h]
	mov	edx, [esi+48h+ebx*4]
	mov	ecx, [esi+58h+ebx*4]
	sub	eax, edx
	jb	@@1a
	sub	eax, ecx
	jb	@@1a
	lea	eax, [ebx*2+ebx+2]	; RGB -> BGR
	and	eax, 3
	lea	eax, [edi+12h+eax]
	add	edx, esi
	call	@@Unpack, eax, dword ptr [esi+1Ch], edx, ecx, [@@L0], dword ptr [esi+20h]
@@1a:	inc	ebx
	cmp	ebx, [@@L0]
	jb	@@1
	clc
	leave
	ret

@@9:	stc
	leave
	ret

@@Unpack PROC	; 00405DA0

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@A = dword ptr [ebp+24h]
@@N = dword ptr [ebp+28h]

@@stk = 0
@M0 @@L2
@M0 @@L1
@M0 @@L0

	push	ebx
	push	esi
	push	edi
	enter	@@stk, 0
	dec	[@@A]
	mov	edx, [@@SC]
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	sub	edx, 2
	jb	@@9
	xor	eax, eax
	lodsw
	xchg	al, ah
	dec	eax
	jns	@@2b
	mov	ecx, [@@DC]
	imul	ecx, [@@N]
	sub	edx, ecx
	jb	@@9
@@2a:	movsb
	add	edi, [@@A]
	dec	ecx
	jnz	@@2a
	jmp	@@9

@@2b:	jne	@@9
	xor	ecx, ecx
@@2c:	sub	edx, 2
	jb	@@9
	xor	eax, eax
	lodsw
	xchg	al, ah
	inc	ecx
	sub	edx, eax
	jb	@@9
	jne	@@2c
	mov	[@@L2], ecx

@@2d:	mov	ecx, [@@DC]
	mov	edx, [@@SB]
	mov	[@@L1], ecx
	dec	[@@L2]
	js	@@1e
	add	edx, 2
	movzx	eax, word ptr [edx]
	xchg	al, ah
	mov	[@@SB], edx
	mov	[@@L0], eax
@@1:	xor	eax, eax
	dec	[@@L0]
	js	@@1e
	lodsb
	cmp	al, 81h
	xchg	ecx, eax
	jb	@@1c
	neg	cl
	inc	ecx
	sub	[@@L1], ecx
	jb	@@9
	dec	[@@L0]
	js	@@9
	lodsb
@@1b:	stosb
	add	edi, [@@A]
	dec	ecx
	jne	@@1b
	jmp	@@1

@@1c:	inc	ecx
	sub	[@@L1], ecx
	jb	@@9
	sub	[@@L0], ecx
	jb	@@9
@@1d:	movsb
	add	edi, [@@A]
	dec	ecx
	jne	@@1d
	jmp	@@1

@@1e:	mov	ecx, [@@L1]
	test	ecx, ecx
	je	@@1g
@@1f:	stosb
	add	edi, [@@A]
	dec	ecx
	jne	@@1f
@@1g:	dec	[@@N]
	jne	@@2d
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	18h
ENDP

@@sign	db 'CLS_TEXFILE',0,0,0,0,0
ENDP
