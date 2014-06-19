
; "ChugokuH" *.dat

	dw _conv_yanepk-$-2
_arc_yanepk PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	pop	eax
	pop	edx
	pop	ebx
	sub	eax, 'enay'
	sub	edx, 'xDkp'
	lea	ecx, [ebx-1]
	or	eax, edx
	shr	ecx, 14h
	or	eax, ecx
	jne	@@9a
	mov	[@@N], ebx
	imul	ebx, 10Ch
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	byte ptr [esi], 0
	je	@@9
	call	_ArcCount, [@@N]

@@1:	mov	ebx, 100h
	call	_ArcName, esi, ebx
	add	esi, ebx
	mov	edi, [esi+4]
	mov	ebx, [esi+8]
	and	[@@D], 0
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	lea	eax, [@@D]
	cmp	ebx, edi
	jne	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 0Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	call	_ArcMemRead, eax, edi, ebx, 0
	call	_lzss_unpack, [@@D], edi, edx, eax
	jmp	@@1b
ENDP

_conv_yanepk PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'agy'
	jne	@@9
	sub	ebx, 18h
	jb	@@9
	mov	edi, [esi+4]
	mov	edx, [esi+8]
	mov	eax, [esi+0Ch]
	sub	ebx, [esi+14h]
	dec	eax
	mov	ecx, [esi+10h]
	or	eax, ebx
	mov	ebx, edi
	imul	ebx, edx
	shl	ebx, 2
	sub	ecx, ebx
	or	eax, ecx
	je	@@1
@@9:	stc
	leave
	ret

@@1:	call	_ArcTgaAlloc, 23h, edi, edx
	xchg	edi, eax
	lea	ecx, [esi+18h]
	add	edi, 12h
	call	_lzss_unpack, edi, ebx, ecx, dword ptr [esi+14h]
	clc
	leave
	ret
ENDP
