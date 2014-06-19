
; "Gocchiru -Lovely Lady Maker-" *.fpk
; GChild.exe
; 0044AF80 file_decode
; 00445630 fbx_unpack

; Bitchn.exe 0xC34A7BB7

	dw _conv_fpk0100-$-2
_arc_fpk0100 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 8

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	pop	edi
	pop	ebx
	sub	eax, 'KPF'
	lea	ecx, [ebx-1]
	sub	edx, '0010'
	shr	ecx, 14h
	or	eax, edx
	or	eax, ecx
	jne	@@9a
	cmp	edi, 18h
	jb	@@9a
	call	_FileSeek, [@@S], edi, 0
	jc	@@9a
	mov	[@@N], ebx
	lea	ebx, [ebx*2+ebx]
	shl	ebx, 3
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

	call	_ArcParamNum, 0
	db 'fpk0100', 0
	sbb	edx, edx
	mov	[@@L0], eax
	mov	[@@L0+4], edx

@@1:	lea	edx, [esi+0Ch]
	call	_ArcName, edx, 0Ch
	and	[@@D], 0
	mov	ebx, [esi+8]
	call	_FileSeek, [@@S], dword ptr [esi+4], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	jc	@@1a
	cmp	dword ptr [esi], 0
	je	@@1a
	cmp	ebx, 8
	jb	@@1a
	test	bl, 3
	jne	@@1a
	btr	[@@L0+4], 0
	jnc	@@1b
	call	@@3
@@1b:	cmp	[@@L0+4], 0
	jne	@@1a
	call	@@Decode, [@@L0], [@@D], ebx
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 18h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	call	_ArcGetExt
	push	eax
	push	ebx
	push	[@@D]
	push	ecx
	push	ecx
	mov	edx, esi
	mov	edi, [@@N]
@@3d:	add	edx, 18h
	dec	edi
	je	@@3a
	cmp	dword ptr [edx], 0
	je	@@3d
	mov	eax, [edx+8]
	mov	edi, eax
	sub	eax, 8
	jb	@@3a
	test	al, 3
	jne	@@3a
	add	eax, [edx+4]
	jc	@@3a
	call	_FileSeek, [@@S], eax, 0
	jc	@@3a
	mov	edx, esp
	call	_FileRead, [@@S], edx, 8
	jnc	@@3b
@@3a:	xor	edi, edi
@@3b:	call	@@4, edi
	jc	@@3c
	mov	[@@L0], eax
	and	[@@L0+4], 0
@@3c:	ret

@@4 PROC

@@L1 = dword ptr [ebp+14h]
@@L0 = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	cmp	[@@L1], 0
	jne	@@1e
	mov	eax, [@@L0+8]
	push	5
	pop	ecx
	call	@@1d
	db 'fbx',0, 'fpk',0, 'png',0, 'ogg',0, 'wav',0
	db 'FBX',1, 'FPK',0, 89h,'PNG', 'OggS', 'RIFF'
@@1d:	pop	edi
	repne	scasd
	jne	@@9
	mov	eax, [edi+10h]
	mov	[@@L0+8], eax
@@1e:
	mov	eax, [@@L0+4]
	mov	edx, [@@L0]
	push	dword ptr [edx+eax-4]
	push	dword ptr [edx+eax-8]
	push	eax
	call	@@1a
	push	esi
	mov	ecx, [@@L1]
	lea	edx, [@@L1+8]
	sub	ecx, 4
	jb	@@1c
	lea	esi, [edx-4]
	call	@@3
	lea	edx, [eax+3+8]
	and	edx, -4
	cmp	edx, [@@L1]
	jmp	@@1b

@@1c:	mov	ecx, [@@L0+4]
	mov	edx, [@@L0]
	sub	ecx, 4
	mov	esi, edx
	add	edx, ecx
	call	@@3
	cmp	eax, [@@L0+8]
@@1b:	je	@@7
	pop	esi
	ret

@@1a:	call	_fpk0100_brute
@@9:	stc
@@7:	xchg	eax, ebx
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	18h

@@3:	push	ebx
	push	edi
	add	ecx, ebx
@@3a:	mov	eax, [edx]
	lea	edi, [ebx+ecx]
	sub	eax, ecx
	xor	eax, ebx
	sub	ecx, 3
	sub	ebx, eax
	shl	edi, 7
	shr	ebx, 7
	sub	edx, 4
	xor	ebx, edi
	cmp	edx, esi
	jae	@@3a
	pop	edi
	pop	ebx
	ret
ENDP

@@Decode PROC

@@K = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@C = dword ptr [ebp+1Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	eax, [@@C]
	mov	esi, [@@K]
	cmp	eax, 8
	jb	@@7
	mov	edi, [@@S]
	lea	ecx, [eax-4]
	test	al, 3
	jne	@@7
	add	edi, ecx
	add	ecx, esi
@@1:	mov	eax, [edi]
	lea	edx, [esi+ecx]
	sub	eax, ecx
	xor	eax, esi
	sub	ecx, 3
	sub	esi, eax
	mov	[edi], eax
	shl	edx, 7
	shr	esi, 7
	sub	edi, 4
	xor	esi, edx
	cmp	edi, [@@S]
	jae	@@1
	; edi = src - 4
	mov	ecx, [@@C]
	mov	eax, [edi+ecx-4]
	lea	edx, [eax+3+8]
	and	edx, -4
	cmp	edx, ecx
	je	@@7
@@9:	xchg	eax, ecx
@@7:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

ENDP

_conv_fpk0100 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'xbf'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 10h
	jb	@@9
	cmp	dword ptr [esi], 001584246h
	jne	@@9
	mov	eax, [esi+8]
	mov	edi, [esi+0Ch]
	add	esi, 10h
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	call	@@Unpack, edi, eax, esi, ebx
	xchg	ebx, eax
	mov	eax, [esi-10h+3]
	shr	eax, 8
	call	_ArcSetExt, eax
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

@@Unpack PROC	; GChild.exe 00445630

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
	push	ecx
@@1:	and	[@@L0], 0
@@1c:	mov	eax, ebx
	shr	ebx, 2
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	bh, 1
	lodsb
	mov	bl, al
	shr	ebx, 2
@@1a:	and	eax, 3
	jne	@@1b
	dec	[@@SC]
	js	@@9
	dec	[@@DC]
	js	@@9
	movsb
	jmp	@@1

@@1b:	dec	eax
	je	@@2b
	dec	eax
	je	@@2d
	dec	[@@SC]
	js	@@9
	lodsb
	sub	al, 40h		; 0x00
	jb	@@2a
	cmp	al, 40h		; 0x40
	jb	@@2c
	test	al, al		; 0x80
	jns	@@1c
	; 0xC0
	xor	ebx, ebx
	and	eax, 3Fh
	cmp	[@@L0], ebx
	jne	@@7
	sub	[@@SC], eax
	jb	@@9
	add	esi, eax
	inc	[@@L0]
	jmp	@@1c

@@2a:	add	al, 41h
	shl	eax, 8
@@2b:	dec	[@@SC]
	js	@@9
	movzx	ecx, byte ptr [esi]
	inc	esi
	lea	ecx, [ecx+eax+2]
	sub	[@@SC], ecx
	jb	@@9
	sub	[@@DC], ecx
	jb	@@9
	rep	movsb
	jmp	@@1

@@2c:	shl	eax, 5
	add	eax, 20h
@@2d:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
	xchg	dl, dh
	mov	ecx, edx
	shr	edx, 5
	and	ecx, 1Fh
	not	edx
	lea	ecx, [ecx+eax+4]
	sub	[@@DC], ecx
	jb	@@9
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

_fpk0100_brute PROC

@@CB = dword ptr [ebp+14h]
@@L0 = dword ptr [ebp+18h]
@@L1 = dword ptr [ebp-0Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	eax, [@@L0]
	sub	eax, 4
	mov	[@@L0], eax
	sub	[@@L0+8], eax
	sub	eax, 3
	sub	[@@L0+4], eax

	mov	eax, [@@L0+4]
	mov	ecx, [@@L0]
	shr	eax, 19h
	shr	ecx, 12h
	push	eax
	push	ecx
	shr	ecx, 7
	push	ecx

	xor	esi, esi
@@2:	mov	edx, [@@L1+8]
	mov	ecx, esi
	sub	edx, esi
	shl	ecx, 19h
	lea	eax, [edx-1]
	xor	edx, [@@L1]
	xor	eax, [@@L1]
	sub	edx, [@@L1+4]
	sub	eax, [@@L1+4]

	lea	ebx, [edx-1]
	and	edx, 7Fh
	and	ebx, 7Fh
	shl	edx, 11h
	shl	ebx, 11h
	add	edx, ecx
	add	ebx, ecx
	push	edx
	push	ebx

	lea	ebx, [eax-1]
	and	eax, 7Fh
	and	ebx, 7Fh
	shl	eax, 11h
	shl	ebx, 11h
	add	eax, ecx
	add	ebx, ecx
	push	eax
	cmp	ebx, eax
	je	@@2a
	cmp	ebx, [@@L1-8]
	je	@@2a
	cmp	ebx, [@@L1-4]
	je	@@2a
	call	@@1
@@2a:	pop	ebx
	cmp	ebx, [@@L1-8]
	je	@@2b
	cmp	ebx, [@@L1-4]
	je	@@2b
	call	@@1
@@2b:	pop	ebx
	cmp	ebx, [@@L1-4]
	je	@@2c
	call	@@1
@@2c:	pop	ebx
	call	@@1
	inc	esi
	cmp	esi, 7Fh
	jbe	@@2
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@1:	mov	eax, [@@L0+8]
	mov	edx, [@@L0]
	sub	eax, ebx
	mov	ecx, ebx
	xor	eax, ebx
	lea	edx, [ebx*2+edx]
	sub	ecx, eax
	shl	edx, 7
	shr	ecx, 7
	mov	eax, [@@L0+4]
	xor	ecx, edx
	sub	eax, ebx
	xor	eax, ecx
	add	eax, 4+3
	and	eax, -4
	cmp	eax, [@@L0]
	je	@@1b
@@1a:	inc	ebx
	test	ebx, 1FFFFh
	jne	@@1
	add	ebx, 1000000h-20000h
	test	ebx, 1000000h
	jne	@@1
	ret

@@1b:	mov	eax, [@@CB]
	push	ebp
	mov	ebp, [ebp]
	call	eax
	pop	ebp
	jmp	@@1a
ENDP
