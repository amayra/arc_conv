
; "Innai Kansen" GGD

	dw _conv_ikura-$-2
_arc_ikura PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 2
	jc	@@9a
	pop	eax
	movzx	ebx, ax
	cmp	ebx, 20h
	jb	@@9a
	lea	ecx, [ebx-10h]
	test	al, 0Fh
	jne	@@9a
	shr	ecx, 4
	mov	[@@N], ecx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	byte ptr [esi], 0
	je	@@9
	mov	eax, [esi+ebx-10h]
	or	eax, [esi+ebx-0Ch]
	or	eax, [esi+ebx-8]
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 0Ch
	and	[@@D], 0
	mov	eax, [esi+0Ch]
	mov	ebx, [esi+1Ch]
	sub	ebx, eax
	jb	@@9
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 10h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

; "DO"
; "Crysweeper" VRS
; CRYSWP95.EXE .004171E4 .004178A4
; "Rinkan" MRS
; "Paradise Heights" MRS
; "Paradise Heights 2" MRS

; "CD" -> "True Love" MRS

_conv_ikura PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'dgg'
	je	@@1
	cmp	eax, 'srv'
	je	@@2
	cmp	eax, 'srm'
	je	@@2
	cmp	eax, 'gmx'
	je	@@3
@@9:	stc
	leave
	ret

@@1:	mov	ecx, 42Ch
	sub	ebx, ecx
	jb	@@9
	mov	edx, 80001h
	mov	eax, [esi]
	sub	edx, [esi+0Ch]
	sub	eax, 28h
	or	eax, edx
	jne	@@9
	mov	[@@SC], ebx
	mov	edi, [esi+4]
	mov	edx, [esi+8]
	add	edi, 3
	and	edi, -4
	neg	edx
	mov	ebx, edi
	imul	ebx, edx
	mov	eax, [esi+ecx-4]
	cmp	eax, [esi+14h]
	jne	@@9
	cmp	eax, ebx
	jb	@@9
	call	_ArcTgaAlloc, 38h, edi, edx
	xchg	edi, eax
	add	esi, 28h
	add	edi, 12h
	mov	ecx, 100h
	rep	movsd
	lodsd
	call	_lzss_unpack, edi, ebx, esi, [@@SC]
	clc
	leave
	ret

@@2:	sub	ebx, 30Ch
	jb	@@9
	mov	eax, [esi]
	cmp	eax, 'DC'
	je	@@2a
	cmp	eax, 'OD'
	jne	@@9
@@2a:	mov	[@@SC], ebx
	movzx	edi, word ptr [esi+4]
	movzx	edx, word ptr [esi+6]
	mov	ebx, edi
	imul	ebx, edx
	call	_ArcTgaAlloc, 30h, edi, edx
	xchg	edi, eax
	add	esi, 0Ch
	add	edi, 12h
	xor	ecx, ecx
@@2b:	movsb
	lodsw
	xchg	al, ah
	stosw
	inc	cl
	jne	@@2b
	call	@@Unpack, edi, ebx, esi, [@@SC]
	clc
	leave
	ret

@@3:	mov	ecx, 30Ch
	sub	ebx, ecx
	jb	@@9
	mov	eax, [esi]
	cmp	ax, 0FAF3h	; 0
	je	@@3b
	cmp	ax, 0B2ABh	; 0x5858
	jne	@@9
@@3b:	mov	edi, esi
	xor	edx, edx
@@3c:	mov	al, [edi]
	sub	al, dl
	add	dl, 7
	xor	al, 0F3h
	stosb
	dec	ecx
	jne	@@3c
	jmp	@@2a

@@Unpack PROC

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
	lodsb
	mov	ecx, eax
	xor	edx, edx
	test	al, al
	js	@@1d
	and	ecx, 3Fh
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	cl, [esi]
	inc	esi
	add	ecx, 40h
@@1a:	test	al, 40h
	jne	@@1c
	sub	[@@DC], ecx
	jb	@@9
	sub	[@@SC], ecx
	jb	@@9
	rep	movsb
	jmp	@@1

@@1d:	and	al, 0Fh
	shr	ecx, 4
	dec	[@@SC]
	js	@@9
	mov	dh, al
	mov	dl, [esi]
	inc	esi
	sub	ecx, 8
	jne	@@1e
	dec	[@@SC]
	js	@@9
	mov	cl, [esi]
	inc	esi
	add	ecx, 8
@@1e:	inc	ecx
@@1c:	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
	not	edx
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
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

ENDP