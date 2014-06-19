
; "H-Cup Namaiki Kateikyoushi -Chichi Fetish Paizuri Hen-" *.gsp
; H-cup.exe

	dw _conv_gsp-$-2
_arc_gsp PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	ebx
	mov	[@@N], ebx
	lea	ecx, [ebx-1]
	shl	ebx, 6
	shr	ecx, 14h
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

	add	esi, 8
@@1:	call	_ArcName, esi, 38h
	and	[@@D], 0
	mov	ebx, [esi-4]
	call	_FileSeek, [@@S], dword ptr [esi-8], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 40h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_gsp PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'zmb'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 8
	jb	@@9
	cmp	dword ptr [esi], '3CLZ'
	jne	@@9
	mov	edi, [esi+4]
	add	esi, 8
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	call	_zlib_unpack, edi, eax, esi, ebx
	xchg	ebx, eax
	call	_ArcSetExt, 'pmb'
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret
ENDP
