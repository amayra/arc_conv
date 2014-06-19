
; "Monster Park ~Bakemono ni Miirareshi Hime~" setup.cg, *.cgf, *.iaf, *.sud
; MOP_DL.EXE
; 00417A40 iaf_unpack

	dw _conv_route2-$-2
_arc_route2 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	enter	@@stk+24h, 0

	call	_FileGetSize, [@@S]
	jc	@@9a
	mov	[@@L0], eax

	mov	esi, esp
	call	_ArcParamNum, 0
	db 'route2', 0
	cmp	eax, 3
	sbb	edx, edx
	and	eax, edx
	dec	eax
	je	_mod_route2_mask
	dec	eax
	je	@@4	; sud

	call	_FileRead, [@@S], esi, 18h
	jc	@@9a
	lodsd
	lea	ecx, [eax-1]
	mov	[@@N], eax
	shr	ecx, 14h
	jne	@@9a
	mov	edx, [esi+10h]
	imul	ebx, eax, 14h
	sub	edx, 4
	cmp	edx, ebx
	jne	@@9a
	lea	ecx, [ebx-14h]
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 14h, ecx, 0
	jc	@@9
	mov	edi, [@@M]
	push	5
	pop	ecx
	rep	movsd
	lea	esi, [edi-14h]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 10h
	and	[@@D], 0
	mov	ebx, [@@L0]
	cmp	[@@N], 1
	je	@@1b
	mov	ebx, [esi+10h+14h]
@@1b:	mov	eax, [esi+10h]
	sub	ebx, eax
	jb	@@9
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 14h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@4:	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	lodsd
	sub	eax, 8
	jb	@@9a
	xchg	ebx, eax
	mov	eax, [esi]
	mov	edx, [esi+4]
	sub	eax, 'SggO'
	sub	dh, 2
	or	eax, edx
	jne	@@9a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 8, ebx, 0
	mov	edi, [@@D]
	lea	ebx, [eax+8]
	test	edi, edi
	je	@@9a
	movsd
	movsd
	call	_ArcSetExt, 'ggo'
	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
	jmp	@@4
ENDP

_mod_route2_mask PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	call	_FileRead, [@@S], esi, 24h
	jc	@@9a
	lodsd
	lea	ecx, [eax-1]
	mov	[@@N], eax
	shr	ecx, 14h
	jne	@@9a
	mov	edx, 7FFFFFFFh
	and	edx, [esi+1Ch]
	imul	ebx, eax, 20h
	sub	edx, 4
	cmp	edx, ebx
	jne	@@9a
	lea	ecx, [ebx-20h]
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 20h, ecx, 0
	jc	@@9
	mov	edi, [@@M]
	push	8
	pop	ecx
	rep	movsd
	lea	esi, [edi-20h]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 1Ch
	mov	dl, [esi+1Fh]
	mov	eax, '0$'
	shr	dl, 7
	add	ah, dl
	call	_ArcSetExt, eax
	and	[@@D], 0
	mov	ebx, [@@L0]
	mov	eax, 7FFFFFFFh
	cmp	[@@N], 1
	je	@@1b
	mov	ebx, [esi+1Ch+20h]
	and	ebx, eax
@@1b:	and	eax, [esi+1Ch]
	sub	ebx, eax
	jb	@@9
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 20h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_route2 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, '1$'
	je	@@2a
	cmp	eax, '0$'
	je	@@2b
	cmp	eax, 'fai'
	je	@@1
@@9:	stc
	leave
	ret

@@2a:	sub	ebx, 10h
	jb	@@9
	add	esi, 10h
@@2b:	sub	ebx, 8
	jb	@@9
	lodsd
	xchg	ecx, eax
	lodsd
	jmp	@@2c

@@1:	sub	ebx, 5+14h
	jb	@@9
	lodsb
	lodsd
	xchg	ecx, eax
	mov	eax, [esi+ebx+10h]
@@2c:	cmp	ebx, ecx
	jne	@@9
	mov	edi, 3FFFFFFFh
	and	edi, eax
	shr	eax, 1Eh
	cmp	eax, 3
	jae	@@9
	push	eax
	call	_MemAlloc, edi
	pop	edx
	jc	@@9
	xchg	edi, eax
	dec	edx
	je	@@1b
	push	ebx
	push	esi
	push	eax	
	push	edi
	jns	@@1a
	call	_lzss_unpack
	jmp	@@1c

@@1a:	call	@@Unpack
	jmp	@@1c

@@1b:	cmp	eax, ebx
	jb	$+3
	xchg	eax, ebx
	mov	ecx, eax
	rep	movsb
@@1c:	push	eax
	call	_ArcSetExt, 'pmb'
	call	_ArcData, edi
	call	_MemFree, edi
	clc
	leave
	ret

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
@@1:	sub	[@@SC], 2
	jb	@@9
	lodsw
	test	al, al
	jne	@@1a
	movzx	ecx, ah
	sub	[@@SC], ecx
	jb	@@9
	sub	[@@DC], ecx
	jb	@@9
	rep	movsb
	jmp	@@1

@@1a:	movzx	ecx, al
	mov	al, ah
	sub	[@@DC], ecx
	jb	@@9
	rep	stosb
	jmp	@@1

@@7:	mov	esi, [@@DC]
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