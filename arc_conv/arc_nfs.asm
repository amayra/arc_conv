
; "Trouble Trap Laboratory" *.nfs
; tora.exe
; 004108B0 open_archive

	dw _conv_nfs-$-2
_arc_nfs PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	ebx
	mov	[@@N], ebx
	lea	ecx, [ebx-1]
	shl	ebx, 5
	shr	ecx, 14h
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	eax, [@@N]
	mov	edx, esi
	mov	ecx, ebx
@@2a:	xor	[edx], al
	inc	edx
	dec	ecx
	jne	@@2a
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx
	lea	edx, [ebx+4]
	mov	[@@P], edx

@@1:	call	_ArcName, esi, 18h
	and	[@@D], 0
	mov	eax, [esi+18h]
	mov	ebx, [esi+1Ch]
	add	eax, [@@P]
	jc	@@1a
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

_conv_nfs PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'pgn'
	je	@@1
	cmp	eax, 'bcs'
	je	@@2
@@9:	stc
	leave
	ret

@@2:	mov	ecx, ebx
	mov	edx, esi
	test	ecx, ecx
	je	@@2b
@@2a:	not	byte ptr [edx]
	inc	edx
	dec	ecx
	jne	@@2a
@@2b:	call	_ArcSetExt, 'txt'
	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@1:	mov	eax, 104h
	sub	ebx, eax
	jb	@@9
	cmp	dword ptr [esi], ' PGN'
	jne	@@9
	push	ebx
	mov	edi, [esi+16h]
	mov	edx, [esi+1Ah]
	movzx	ecx, word ptr [esi+1Eh]
	add	esi, eax
	mov	ebx, edi
	imul	ebx, edx
	imul	ebx, ecx
	dec	ecx
	cmp	ecx, 4
	jae	@@9
	dec	ecx
	je	@@9
	add	ecx, 21h
	cmp	[esi-4], ebx
	jne	@@9
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	call	_zlib_unpack, edi, ebx, esi
	clc
	leave
	ret
ENDP
