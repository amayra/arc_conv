
; "PurePure" cg.pak
; GameSys.exe 00428A00

	dw 0
_arc_klein PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@F

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	cmp	eax, 'KCAP'
	jne	@@9a
	pop	ebx
	pop	ecx
	pop	eax
	cmp	ecx, 2
	jae	@@9a
	lea	eax, [ebx-1]
	mov	[@@F], ecx
	mov	[@@N], ebx
	shr	eax, 14h
	jne	@@9a
	imul	ebx, 4Ch
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	eax, [ebx+10h]
	cmp	[esi+48h], eax
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 40h
	and	[@@D], 0
	call	_FileSeek, [@@S], dword ptr [esi+48h], 0
	jc	@@1a
	mov	edi, [esi+40h]
	mov	ebx, [esi+44h]
	lea	eax, [@@D]
	cmp	[@@F], 0
	jne	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 4Ch
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
