
; "Shin Mikagura Shoujo Tanteidan" *.dat
; mika.exe

	dw _conv_mp_mika-$-2
_arc_mp_mika PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+20h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 20h
	jc	@@9a
	lodsd
	xchg	ecx, eax
	lodsd
	cmp	cx, 'PM'
	jne	@@9a
	shr	ecx, 10h
	je	@@9a
	mov	[@@N], ecx
	dec	ecx
	imul	ebx, ecx, 18h
	lea	eax, [ebx+20h]
	cmp	[esi+14h], eax
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 18h, ebx, 0
	jc	@@9
	mov	edi, [@@M]
	push	edi
	push	18h/4
	pop	ecx
	rep	movsd
	pop	esi
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 10h
	and	[@@D], 0
	mov	ebx, [esi+10h]
	call	_FileSeek, [@@S], dword ptr [esi+14h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
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
ENDP

_conv_mp_mika PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'bce'
	je	@@3
	cmp	eax, 'nce'
	jne	@@9
@@3:	mov	edx, ebx
	sub	ebx, 21h
	jb	@@9
	cmp	edx, [esi+4]
	jne	@@9
	mov	ecx, [esi+14h]
	cmp	word ptr [esi], 'MM'
	jne	@@9
	sub	ecx, 9
	jb	@@9
	sub	ebx, ecx
	jae	@@1
@@9:	stc
	leave
	ret

@@1:	movzx	ecx, word ptr [esi+0Eh]
	movzx	edi, word ptr [esi+0Ah]
	movzx	edx, word ptr [esi+0Ch]
	mov	ebx, edi
	imul	ebx, edx
	cmp	ecx, 4
	jne	@@2
	shl	ebx, 2
	cmp	[esi+1Dh], ebx
	jne	@@9
	call	_ArcTgaAlloc, 3, edi, edx
	xchg	edi, eax
	add	edi, 12h
	call	_MemAlloc, ebx
	jc	@@9
	push	eax
	mov	ecx, [esi+14h]
	cmp	byte ptr [esi+18h], 0
	lea	esi, [esi+21h]
	je	@@1c
	sub	ecx, 9
	xchg	esi, eax
	call	_lzss_unpack, esi, ebx, eax, ecx
@@1c:	shr	ebx, 2
	push	edi
	mov	ecx, ebx
@@1a:	add	edi, 3
	movsb
	dec	ecx
	jne	@@1a
	pop	edi
@@1b:	movsb
	movsb
	movsb
	inc	edi
	dec	ebx
	jne	@@1b
	call	_MemFree
	clc
	leave
	ret

@@2:	mov	eax, [esi+1Dh]
	lea	ebx, [ebx*2+ebx]
	sub	eax, ebx
	shr	eax, 1
	jne	@@9
	call	_ArcTgaAlloc, 2, edi, edx
	xchg	edi, eax
	add	edi, 12h
	mov	ecx, [esi+14h]
	cmp	byte ptr [esi+18h], 0
	lea	esi, [esi+21h]
	je	@@2a
	sub	ecx, 9
	call	_lzss_unpack, edi, ebx, esi, ecx
	clc
	leave
	ret

@@2a:	cmp	ecx, ebx
	jb	$+4
	mov	ecx, ebx
	rep	movsb
	clc
	leave
	ret
ENDP