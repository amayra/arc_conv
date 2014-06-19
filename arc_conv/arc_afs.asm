
; "Quartett! The Stage of Love (PS2)" *.acx, *.afs

	dw _conv_afs-$-2
_arc_afs PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1, 10h

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	eax
	pop	ebx
	mov	[@@L0], eax
	cmp	eax, 'SFA'
	je	@@2a
	bswap	ebx
	test	eax, eax
	jne	@@9a
@@2a:	mov	[@@N], ebx
	lea	eax, [ebx-1]
	shr	eax, 14h
	jne	@@9a
	shl	ebx, 3
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	[@@L0], 0
	jne	@@2c
@@2b:	lodsd
	bswap	eax
	sub	ebx, 4
	mov	[esi-4], eax
	jne	@@2b
@@2c:
	call	_ArcCount, [@@N]
	call	@@3
	mov	esi, [@@M]
@@1:	call	@@4
	and	[@@D], 0
	mov	ebx, [esi+4]
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 8
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@L1]
	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@4:	push	esi
	mov	esi, [@@L1+8]
	mov	edx, [@@L1+4]
	test	esi, esi
	je	@@4d
	mov	ecx, [@@L1+0Ch]
	test	ecx, ecx
	jne	@@4e
@@4a:	cmp	esi, edx
	je	@@4c
	lodsb
	cmp	al, 0Ah
	je	@@4b
	cmp	al, 0Dh
	jne	@@4a
@@4b:	dec	ecx
	xor	al, 7
	cmp	esi, edx
	je	@@4c
	cmp	al, [esi]
	jne	@@4c
	inc	esi
	dec	ecx
@@4c:	mov	edx, [@@L1+8]
	mov	[@@L1+8], esi
	sub	esi, edx
	add	ecx, esi
	je	@@4d
@@4f:	call	_ArcName, edx, ecx
@@4d:	pop	esi
	ret

@@4e:	sub	edx, esi
	cmp	edx, ecx
	jb	@@4d
	mov	edx, esi
	add	[@@L1+8], ecx
	sub	ecx, 4
	jmp	@@4f

@@3:	and	[@@L1], 0
	and	[@@L1+0Ch], 0
	call	_ArcInputExt, 'sla'
	jc	@@3d
	xchg	esi, eax
	call	_FileGetSize, esi
	test	eax, eax
	xchg	ebx, eax
	jle	@@3b
@@3c:	call	_MemAlloc, ebx
	jc	@@3b
	mov	[@@L1], eax
	call	_FileRead, esi, eax, ebx
	xchg	ebx, eax
@@3b:	call	_FileClose, esi
@@3a:	mov	esi, [@@L1]
	add	ebx, esi
	mov	[@@L1+4], ebx
	mov	[@@L1+8], esi
	ret

@@3d:	call	_ArcInputExt, 'man'
	jc	@@3c
	xchg	esi, eax
	call	_FileGetSize, esi
	test	eax, eax
	mov	ebx, eax
	jle	@@3b
	xor	edx, edx
	div	[@@N]
	test	edx, edx
	jne	@@3b
	mov	[@@L1+0Ch], eax
	sub	eax, 10h
	and	eax, NOT 10h
	jne	@@3b
	jmp	@@3c
ENDP

_conv_afs PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@M = dword ptr [ebp-4]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 4
	jb	@@9
	cmp	word ptr [esi], 80h
	jne	@@9
	movzx	ecx, word ptr [esi+2]
	xchg	cl, ch
	cmp	ecx, 4+6
	jb	@@9
	add	ecx, 4
	sub	ebx, ecx
	jb	@@9
	mov	edx, 'IRC)'
	movzx	eax, word ptr [esi+ecx-6]
	sub	edx, [esi+ecx-4]
	sub	eax, 'c('
	or	eax, edx
	je	@@1
@@9:	stc
	leave
	ret

@@1a:	call	_ArcSetExt, ecx
	jmp	@@9

@@1:	movzx	eax, byte ptr [esi+4]
	lea	edx, [eax-10h]
	mov	ecx, 'xha'
	shr	edx, 1
	je	@@1a
	mov	ch, 'd'
	sub	eax, 3
	shr	eax, 1
	jne	@@9
	call	_ArcSetExt, ecx
	movzx	ecx, word ptr [esi+2]
	xchg	cl, ch
	cmp	ecx, 10h+6
	jb	@@9
	mov	eax, [esi+4]
	bswap	eax
	sub	eax, 003120401h
	movzx	ecx, al		; 0-mono, 1-stereo
	shr	eax, 1
	jne	@@9
	mov	[@@SC], ebx
	xor	edx, edx
	mov	eax, ebx
	lea	edi, [edx+12h]
	div	edi
	mov	edx, [esi+0Ch]
	shr	eax, cl
	bswap	edx
	shl	eax, 5
	cmp	eax, edx
	jb	$+3
	xchg	eax, edx
	mov	ebx, eax
	add	eax, 1Fh
	inc	ecx
	and	eax, -20h
	shl	eax, cl
	add	eax, 2Ch
	call	_MemAlloc, eax
	jc	@@9
	push	eax	; @@M
	xchg	edi, eax

	movzx	ecx, byte ptr [esi+7]
	mov	edx, ebx
	shl	edx, cl
	mov	eax, 'FFIR'
	stosd
	lea	eax, [edx+24h]
	stosd
	mov	eax, 'EVAW'
	stosd
	mov	eax, ' tmf'
	stosd
	push	10h
	pop	eax
	stosd
	mov	eax, ecx
	shl	eax, 10h
	inc	eax
	stosd
	mov	eax, [esi+8]
	bswap	eax
	stosd			; nSamplesPerSec
	shl	eax, cl
	stosd			; nAvgBytesPerSec
	lea	eax, [ecx+ecx+100000h]
	stosd
	mov	eax, 'atad'
	stosd
	xchg	eax, edx
	stosd

	dec	ecx
	push	ecx
	finit
	mov	edx, [esi+8]
	movzx	eax, word ptr [esi+10h]
	bswap	edx
	xchg	al, ah
	call	@@ADXCoef, eax, edx
	push	edx
	push	eax

	movzx	ecx, word ptr [esi+2]
	add	ebx, 1Fh
	xchg	cl, ch
	shr	ebx, 5
	lea	esi, [esi+ecx+4]
	call	@@ADXConv, edi, esi, ebx

	mov	edi, [@@M]
	mov	ebx, [edi+4]
	add	ebx, 8
	call	_ArcSetExt, 'vaw'
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

@@ADXCoef PROC
	fild	dword ptr [esp+4]
	fidiv	dword ptr [esp+8]
	fldpi
	fadd	st(0), st(0)
	fmulp	st(1), st(0)
	fcos
	; st(0) = z
	fld1
	fadd	st(0), st(0)
	fsqrt
	fsubr	st(1), st(0)
	fld1
	fsubp	st(1), st(0)
	; st(0) = sqrt(2) - 1, st(1) = sqrt(2) - z
	fld	st(1)
	fadd	st(0), st(1)	; a + b
	fld	st(2)
	fsub	st(0), st(2)	; a - b
	fmulp	st(1), st(0)
	fsqrt
	fsubp	st(2), st(0)
	fdivp	st(1), st(0)	; c
	fld	st(0)
	fmul	st(0), st(0)
	db 0B8h		; mov eax, i32
	dd -4096.0
	call	@@2
	xchg	edx, eax
	db 0B8h		; mov eax, i32
	dd 8192.0
	call	@@2
	ret	8

@@2:	push	eax
	mov	ecx, esp
	fmul	dword ptr [ecx]
	fstcw	[ecx]
	mov	eax, [ecx]
	; floor
	and	ah, 0F3h
	or	ah, 4
	push	eax
	fldcw	[ecx-4]
	fistp	dword ptr [ecx-4]
	fldcw	[ecx]
	pop	eax
	pop	ecx
	ret
ENDP

@@ADXConv PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@C = dword ptr [ebp+1Ch]
@@L0 = dword ptr [ebp+20h]
@@L1 = dword ptr [ebp+24h]
@@L2 = dword ptr [ebp+28h]

	push	ebx
	push	esi
	push	edi
	enter	40h, 0
	xor	eax, eax
	push	eax
	push	eax
	sub	esp, 40h
	push	eax
	push	eax
	mov	edi, [@@D]
	mov	esi, [@@S]
	cmp	[@@C], 0
	je	@@9
@@1a:	mov	ebx, esp
	call	@@2
	cmp	[@@L2], 0
	jne	@@1c
	xor	ecx, ecx
@@1b:	movzx	eax, word ptr [ebx+8+ecx*2]
	stosw
	inc	ecx
	cmp	ecx, 20h
	jb	@@1b
	jmp	@@1e

@@1c:	add	ebx, 48h
	call	@@2
	xor	ecx, ecx
@@1d:	movzx	eax, word ptr [ebx+8+ecx*2]
	shl	eax, 10h
	mov	ax, [ebx-40h+ecx*2]
	stosd
	inc	ecx
	cmp	ecx, 20h
	jb	@@1d
@@1e:	dec	[@@C]
	jne	@@1a
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	18h

@@2:	movzx	ecx, word ptr [esi]
	inc	esi
	inc	esi
	xchg	cl, ch
	inc	ecx
	push	edi
	xor	edi, edi
	mov	eax, [ebx]
@@2a:	mov	edx, [ebx+4]
	imul	eax, [@@L0]
	imul	edx, [@@L1]
	add	eax, edx
	jns	@@2b
	add	eax, 0FFFh
@@2b:	movsx	edx, byte ptr [esi]
	sar	edx, 4
	sar	eax, 0Ch
	imul	edx, ecx
	add	eax, edx
	cmp	eax, 7FFFh
	jl	$+7
	mov	eax, 7FFFh
	cmp	eax, -8000h
	jge	$+7
	mov	eax, -8000h
	mov	[ebx+4], eax
	mov	[ebx+edi*4+8], ax
	mov	edx, [ebx]
	imul	eax, [@@L0]
	imul	edx, [@@L1]
	add	eax, edx
	jns	@@2c
	add	eax, 0FFFh
@@2c:	mov	dl, [esi]
	inc	esi
	shl	dl, 4
	movsx	edx, dl
	sar	edx, 4
	sar	eax, 0Ch
	imul	edx, ecx
	add	eax, edx
	cmp	eax, 7FFFh
	jl	$+7
	mov	eax, 7FFFh
	cmp	eax, -8000h
	jge	$+7
	mov	eax, -8000h
	mov	[ebx], eax
	mov	[ebx+edi*4+0Ah], ax
	inc	edi
	cmp	edi, 10h
	jb	@@2a
	pop	edi
	ret
ENDP

ENDP
