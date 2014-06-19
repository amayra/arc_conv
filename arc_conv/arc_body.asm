
; "Shitai o Arau" *.arc
; BODY.exe
; 0043ED20 lzss_unpack

	dw _conv_body-$-2
_arc_body PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	ecx
	imul	ebx, ecx, 28h
	mov	[@@N], ecx
	dec	ecx
	shr	ecx, 14h
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	eax, [ebx+4]
	cmp	byte ptr [esi], 0
	je	@@9
	cmp	[esi+20h], eax
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 20h
	and	[@@D], 0
	mov	ebx, [esi+24h]
	call	_FileSeek, [@@S], dword ptr [esi+20h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 28h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_body PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, '42g'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 8
	jb	@@9
	movzx	edi, word ptr [esi+4]
	movzx	edx, word ptr [esi+6]
	mov	ebx, edi
	imul	ebx, edx
	lea	ebx, [ebx*2+ebx]
	call	_ArcTgaAlloc, 2, edi, edx
	lea	edi, [eax+12h]
	mov	ecx, [@@SC]
	add	esi, 8
	sub	ecx, 8
	call	_lzss_unpack, edi, ebx, esi, ecx
	clc
	leave
	ret
ENDP
