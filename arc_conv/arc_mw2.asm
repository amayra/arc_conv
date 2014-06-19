
; "Gokko" *.ARC
; MGS.EXE 00406CB0

	dw _conv_mw2-$-2
_arc_mw2 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P

	enter	@@stk+30h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 30h
	jc	@@9a
	pop	eax
	pop	edx
	mov	ebx, [esi+24h]
	sub	eax, 'CRA'
	sub	edx, 30h
	lea	ecx, [ebx-1]
	or	eax, edx
	shr	ecx, 14h
	or	eax, ecx
	jne	@@9a
	mov	eax, [esi+1Ch]
	mov	ecx, [esi+20h]
	mov	edx, [esi+0Ch]
	mov	[@@P], ecx
	add	ecx, [esi+14h]
	add	edx, 30h
	sub	ecx, [esi+8]
	sub	edx, eax
	or	edx, ecx
	jne	@@9a
	mov	[@@N], ebx
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	imul	ebx, 1Ch
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	byte ptr [esi], 0
	je	@@9
	cmp	dword ptr [esi+10h], 0
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 10h
	and	[@@D], 0
	mov	eax, [esi+10h]
	mov	ebx, [esi+14h]
	add	eax, [@@P]
	jc	@@9
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 1Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_mw2 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, '2wm'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	mov	ecx, 420h
	sub	ebx, ecx
	jb	@@9
	mov	edx, 400h
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, '2WM'
	or	eax, edx
	jne	@@9
	cmp	[esi+14h], ebx
	jne	@@9
	mov	[@@SC], ebx
	movzx	edi, word ptr [esi+12h]
	movzx	edx, word ptr [esi+10h]
	sub	di, [esi+0Eh]
	jb	@@9
	sub	dx, [esi+0Ch]
	jb	@@9
	inc	edi
	inc	edx
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 18h, edi, edx
	xchg	edi, eax
	mov	eax, [esi+0Ch]
	rol	eax, 10h
	mov	[edi+8], eax
	add	esi, 20h
	add	edi, 12h
	mov	ecx, 100h
	rep	movsd
	movzx	ecx, word ptr [edi+0Ch]
	call	@@Unpack, edi, ebx, esi, [@@SC], ecx
	clc
	leave
	ret

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]

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
	lodsb
	mov	ecx, eax
	cmp	al, 40h
	jb	@@1a
	sub	al, 0C0h
	jae	@@1b
	and	ecx, 3
	shr	eax, 2
	inc	ecx
	inc	ecx
	jmp	@@3b

@@1b:	dec	[@@SC]
	js	@@9
	mov	cl, [esi]
	inc	esi
	cmp	al, 20h
	jb	@@3a
	cmp	al, 30h
	jae	@@1d
	inc	ecx
	shl	ecx, 8
	dec	[@@SC]
	js	@@9
	mov	cl, [esi]
	inc	esi
@@3a:	add	ecx, 6
@@3b:	and	al, 1Fh
	sub	[@@DC], ecx
	jb	@@9
	movsx	edx, byte ptr [@@T+eax]
	mov	eax, edx
	sar	edx, 4
	and	eax, 0Fh
	imul	eax, [@@L0]
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

@@1d:	shl	al, 4
	or	ecx, eax
@@1a:	test	ecx, ecx
	je	@@1
	sub	[@@DC], ecx
	jb	@@9
	sub	[@@SC], ecx
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

@@T:
db 0F0h,0E0h,0D0h,0C0h,021h,011h,001h,0F1h
db 0E1h,0D1h,012h,002h,0F2h,0E2h,013h,003h
db 031h,032h,022h,033h,023h,0F3h,0E3h,0D3h
db 0C3h,0B3h,0D2h,0C2h,0B2h,0C1h,0B1h,0B0h
ENDP

ENDP