
; "Angel's Lesson" *.pak
; AL.exe
; 00428340 arc_count_decode
; 00428300 data_decode

	dw _conv_cherry-$-2
_arc_cherry PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@L0

	enter	@@stk+1Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 1Ch
	jc	@@9a
	mov	edi, offset @@sign
	push	4
	pop	ecx
	repe	cmpsd
	jne	@@9a
	lodsd
	cmp	eax, 2
	jae	@@9a
	mov	[@@L0], eax
	lodsd
	xor	eax, 0BC138744h
	lea	ecx, [eax-1]
	shr	ecx, 14h
	jne	@@9a
	mov	[@@N], eax
	imul	ebx, eax, 18h
	lodsd
	xor	eax, 064E0BA23h
	mov	[@@P], eax
	cmp	[@@L0], 0
	jne	@@2a
	lea	ecx, [ebx+1Ch]
	cmp	eax, ecx
	jne	@@9a
	mov	[@@P], ecx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	jmp	@@2b

@@2a:	sub	eax, 1Ch
	jb	@@9a
	xchg	edi, eax
	lea	eax, [@@M]
	call	_ArcMemRead, eax, ebx, edi, 0
	jc	@@9
	mov	esi, [@@M]
	add	esi, ebx
	call	_cherry_decode, esi, edi
	call	_lzss_unpack, [@@M], ebx, esi, edi
	jc	@@9
@@2b:	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	call	_ArcName, esi, 10h
	and	[@@D], 0
	mov	eax, [esi+10h]
	mov	ebx, [esi+14h]
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
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

@@sign	db 'CHERRY PACK 2.0', 0
ENDP

_cherry_decode PROC
	mov	ecx, [esp+8]
	mov	edx, [esp+4]
	shr	ecx, 1
	je	@@9
@@1:	movzx	eax, word ptr [edx]
	xchg	al, ah
	xor	eax, 33CCh
	mov	[edx], ax
	inc	edx
	inc	edx
	dec	ecx
	jne	@@1
@@9:	ret	8
ENDP

_conv_cherry PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-8]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	sub	ebx, 18h
	jb	@@9
	mov	eax, [esi+8]
	mov	edi, 0A53CC35Ah
	mov	edx, 035421005h
	xor	edi, [esi]
	xor	edx, [esi+4]
	mov	ecx, edi
	sub	eax, 8
	or	ecx, edx
	and	eax, NOT 10h
	shr	ecx, 10h
	or	eax, ecx
	je	@@1
@@9:	stc
	leave
	ret

@@1:	mov	[@@SC], ebx
	mov	ebx, edi
	imul	ebx, edx
	mov	eax, 400h
	; ecx = 0
	mov	cl, 18h
	cmp	dword ptr [esi+8], 8
	je	@@1a
	mov	cl, 2
	xor	eax, eax
	lea	ebx, [ebx*2+ebx]
@@1a:	add	ebx, eax
	mov	eax, [esi+10h]
	xor	eax, 0CF42355Dh
	cmp	ebx, eax
	jne	@@9
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	add	esi, 18h
	call	_cherry_decode, esi, [@@SC]
	call	_lzss_unpack, edi, ebx, esi, [@@SC]
	clc
	leave
	ret
ENDP