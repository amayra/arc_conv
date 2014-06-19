
; "Kichiku Megane (trial)" Seen.txt
; RealLive.exe
; 0040D990 read_file
; 0047CA6E seen_table
; 004035D2 seen_decrypt
; 00403CA0 unpack

	dw _conv_rlseen-$-2
_arc_rlseen PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk, 0
	mov	ebx, 2710h*8
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	shr	ebx, 3
	xor	eax, eax
	mov	[@@N], ebx
@@2a:	cmp	dword ptr [esi+4], 1
	lea	esi, [esi+8]
	sbb	eax, -1
	dec	ebx
	jne	@@2a
	test	eax, eax
	je	@@9
	call	_ArcCount, eax

	xor	esi, esi
@@1:	mov	edi, [@@M]
	mov	ebx, [edi+esi*8+4]
	mov	edi, [edi+esi*8]
	test	ebx, ebx
	je	@@8
	push	'txt.'
	push	ecx
	call	_StrDec32, 4, esi, esp
	push	'neeS'
	mov	edx, esp
	mov	byte ptr [edx+8], '.'
	call	_ArcName, edx, 0Ch
	add	esp, 0Ch
	and	[@@D], 0
	call	_FileSeek, [@@S], edi, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	inc	esi
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_rlseen PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	mov	eax, 1D0h
	cmp	ebx, eax
	jb	@@9
	mov	edi, [esi+20h]
	cmp	edi, eax
	jb	@@9
	sub	ebx, edi
	jb	@@9
	cmp	ebx, [esi+28h]
	je	@@1
@@9:	stc
	leave
	ret

@@1:	mov	eax, [esi+24h]
	push	eax	; @@L0
	add	eax, edi
	jc	@@9
	cmp	ebx, 8
	jb	@@9
	call	_MemAlloc, eax
	jc	@@9
	lea	ecx, [ebx-8]
	push	eax
	push	ecx	; @@Unpack
	push	ebx	; @@Decrypt
	mov	ebx, edi
	xchg	edi, eax
	xchg	ecx, eax
	rep	movsb
	call	_rlseen_xor, esi
	add	esi, 8
	call	_reallive_unpack, edi, [@@L0], esi
	add	ebx, eax
	pop	edi
	and	dword ptr [edi+28h], 0
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret
ENDP

_reallive_unpack PROC

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
	xor	ebx, ebx
@@1:	dec	[@@DC]
	js	@@7
	shr	ebx, 1
	jne	@@1a
	dec	[@@SC]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	rcr	bl, 1
@@1a:	jnc	@@1b
	dec	[@@SC]
	js	@@9
	movsb
	jmp	@@1

@@1b:	sub	[@@SC], 2
	jb	@@9
	movzx	edx, word ptr [esi]
	inc	esi
	inc	esi
	mov	ecx, edx
	shr	edx, 4
	and	ecx, 0Fh
	neg	edx
	inc	ecx
	sub	[@@DC], ecx
	jb	@@9
	inc	ecx
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
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP
