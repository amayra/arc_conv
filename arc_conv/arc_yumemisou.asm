
; ANEKAN.exe
; 00422910 graphic_unpack

	dw _conv_yumemisou-$-2
_arc_yumemisou PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1

	enter	@@stk, 0
	call	_unicode_ext, -1, offset inFileName
	cmp	eax, 'tad'
	jne	@@9a
	call	@@3
	test	ebx, ebx
	je	@@9
	mov	esi, [@@M]
	call	@@5
	lea	ecx, [eax-1]
	mov	[@@N], eax
	shr	ecx, 14h
	jne	@@9
	call	_ArcCount, eax
	call	_ArcDbgData, esi, ebx

	call	_unicode_name, offset inFileName
	xor	edx, edx
	xchg	ebx, eax
	lea	ecx, [edx+3]
@@2a:	movzx	eax, word ptr [ebx]
	inc	ebx
	inc	ebx
	or	al, 20h
	lea	edi, [eax-61h]
	cmp	edi, 1Ah
	jae	@@2b
	mov	dl, al
	ror	edx, 8
	dec	ecx
	jne	@@2a
@@2b:	inc	ecx
	shl	ecx, 3
	ror	edx, cl
	mov	[@@L1], edx

	call	_FileGetSize, [@@S]
	jc	@@9
	mov	[@@L0], eax

@@1:	movzx	edi, byte ptr [esi]
	inc	esi
	call	_ArcName, esi, edi
	call	_ArcSetExt, [@@L1]
	lea	esi, [esi+edi+4]
	and	[@@D], 0
	mov	ebx, [@@L0]
	cmp	[@@N], 1
	je	@@1b
	movzx	edi, byte ptr [esi]
	mov	ebx, [esi+edi+1]
@@1b:	mov	eax, [esi-4]
	sub	ebx, eax
	jbe	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	xor	ebx, ebx
	mov	[@@M], ebx
	call	_ArcInputExt, 'deh'
	jc	@@3a
	xchg	esi, eax
	call	_FileGetSize, esi
	jc	@@3b
	xchg	edi, eax
	call	_MemAlloc, edi
	jc	@@3b
	mov	[@@M], eax
	call	_FileRead, esi, eax, edi
	jc	@@3b
	xchg	ebx, eax
@@3b:	call	_FileClose, esi
@@3a:	ret

@@5:	push	ebx
	push	esi
	xor	eax, eax
@@5a:	sub	ebx, 5
	jb	@@5c
	movzx	ecx, byte ptr [esi]
	add	esi, 5
	sub	ebx, ecx
	jb	@@5c
	inc	eax
	test	ecx, ecx
	je	@@5a
@@5b:	not	byte ptr [esi-4]
	inc	esi
	dec	ecx
	jne	@@5b
	jmp	@@5a
@@5c:	pop	esi
	pop	ebx
	ret
ENDP

_conv_yumemisou PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'arg'
	je	@@1
	cmp	ebx, 0Dh+8
	jb	@@9
	lea	ecx, [ebx-0Dh]
	mov	eax, [esi+0Dh]
	mov	edx, [esi+0Dh+4]
	sub	eax, 'SggO'
	sub	dh, 2
	sub	ecx, [esi+9]
	or	eax, edx
	or	eax, ecx
	je	@@2
@@9:	stc
	leave
	ret

@@2:	sub	ebx, 0Dh
	add	esi, 0Dh
	call	_ArcSetExt, 'ggo'
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@1:	sub	ebx, 10Ah
	jb	@@9
	movzx	ecx, byte ptr [esi]
	cmp	byte ptr [esi+1], 3
	jne	@@9
	cmp	ecx, 2
	jae	@@9
	movzx	edi, word ptr [esi+2]
	movzx	edx, word ptr [esi+4]
	add	ecx, 22h
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	call	@@Unpack, edi, esi, ebx
	clc
	leave
	ret

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@SB = dword ptr [ebp+18h]
@@SC = dword ptr [ebp+1Ch]

@@stk = 0
@M0 @@AC
@M0 @@WH
@M0 @@DC
@M0 @@M
@M0 @@X
@M0 @@N

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@SB]
	movzx	eax, word ptr [esi+2]
	movzx	edx, word ptr [esi+4]
	imul	eax, edx

	add	esi, 10Ah
	mov	ebx, [esi-4]
	mov	ecx, [@@SC]
	sub	ecx, ebx
	jae	$+6
	add	ebx, ecx
	xor	ecx, ecx
	push	ecx	; @@AC
	mov	[@@SC], ebx

	push	eax
	lea	eax, [eax*2+eax]
	mov	ebx, 40000h
	push	eax
	add	eax, ebx
	call	_MemAlloc, eax
	jc	@@9a
	push	eax	; @@M
	add	eax, ebx
	xor	ebx, ebx
	push	eax
	push	ebx	; @@N
	xchg	edi, eax

@@1:	mov	eax, [@@N]
	mov	edx, [@@M]
	cmp	eax, 10000h
	jae	@@1e
	mov	[edx+eax*4], edi
	inc	[@@N]
@@1e:	dec	[@@DC]
	js	@@9
	call	@@3
	jnc	@@1b
	mov	edx, [@@N]
	xor	ecx, ecx
	xor	eax, eax
	dec	edx
	inc	ecx
@@1a:	call	@@3
	jnc	$+4
	or	eax, ecx
	shl	ecx, 1
	shr	edx, 1
	jne	@@1a
	inc	eax
	cmp	eax, [@@N]
	jae	@@9
	mov	edx, [@@M]
	mov	ecx, [edx+eax*4]
	mov	eax, [edx+eax*4-4]
	sub	ecx, eax
	sub	[@@DC], ecx
	jb	@@9
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
@@1b:
	xor	ecx, ecx
	inc	ecx
@@1c:	cmp	ecx, 8
	jae	@@9
	inc	ecx
	call	@@3
	jc	@@1c
	mov	edx, [@@SB]
	xor	eax, eax
@@1d:	call	@@3
	adc	eax, eax
	dec	ecx
	jne	@@1d
	mov	al, [edx+eax+6]
	stosb
	jmp	@@1

@@9:	mov	edx, [@@SB]
	movzx	eax, word ptr [edx+2]
	movzx	edx, word ptr [edx+4]
	call	_yumemisou_add, [@@X], eax, edx, 3

	mov	edx, [@@SB]
	mov	ebx, [@@WH]
	movzx	edx, byte ptr [edx]
	mov	edi, [@@DB]
	mov	ecx, ebx
	mov	esi, [@@X]
@@7a:	mov	al, [esi+ebx]
	mov	ah, [esi+ebx*2]
	movsb
	stosw
	add	edi, edx
	dec	ecx
	jne	@@7a
	test	edx, edx
	je	@@9b
	mov	esi, [@@SB]
	add	esi, 10Ah
	add	esi, [esi-4]
	sub	[@@AC], 8
	jb	@@9b
	lodsd
	lodsd
	mov	edi, [@@DB]
	mov	ebx, [@@WH]
@@7b:	sub	[@@AC], 2
	jb	@@9b
	lodsw
	movzx	ecx, ah
	movzx	eax, al
	imul	eax, 28CCCCDh	; (0xFF << 24) / 0x64
	shr	eax, 18h
	test	ecx, ecx
	je	@@7b
	sub	ebx, ecx
	jb	@@9b
@@7c:	add	edi, 3
	stosb
	dec	ecx
	jne	@@7c
	test	ebx, ebx
	jne	@@7b

@@9b:	call	_MemFree, [@@M]
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@3:	shr	ebx, 1
	jne	@@3a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@3a:	ret
ENDP

ENDP

_yumemisou_add PROC

@@D = dword ptr [ebp+14h]
@@W = dword ptr [ebp+18h]
@@H = dword ptr [ebp+1Ch]
@@A = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ebx, [@@W]
	mov	edi, [@@D]
	neg	ebx
@@1:	mov	ecx, ebx
	inc	edi
	inc	ecx
	je	@@1b
@@1a:	mov	al, [edi-1]
	add	[edi], al
	inc	edi
	inc	ecx
	jne	@@1a
@@1b:	mov	esi, [@@H]
	dec	esi
	je	@@2c
@@2:	mov	al, [edi+ebx]
	add	[edi], al
	push	esi
	mov	esi, ebx
	inc	edi
	inc	esi
	je	@@2b
@@2a:	movzx	ecx, byte ptr [edi+ebx]
	movzx	edx, byte ptr [edi+ebx-1]
	movzx	eax, byte ptr [edi-1]
	sub	ecx, edx
	sub	eax, edx
	lea	edx, [eax+ecx]
	jns	$+4
	neg	eax
	test	ecx, ecx
	jns	$+4
	neg	ecx
	test	edx, edx
	jns	$+4
	neg	edx
	cmp	edx, ecx
	jae	@@3a
	cmp	edx, eax
	mov	dl, [edi+ebx-1]
	jb	@@3b
@@3a:	cmp	eax, ecx
	mov	dl, [edi+ebx]
	jb	@@3b
	mov	dl, [edi-1]
@@3b:	add	[edi], dl
	inc	edi
	inc	esi
	jne	@@2a
@@2b:	pop	esi
	dec	esi
	jne	@@2
@@2c:	dec	[@@A]
	jne	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP
