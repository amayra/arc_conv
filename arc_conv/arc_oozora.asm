
; "Kono Oozora ni, Tsubasa wo Hirogete" *.arc

	dw 0
_arc_oozora PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@SC

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	eax
	pop	ebx
	mov	[@@N], eax
	lea	ecx, [eax-1]
	imul	eax, 0Ah
	shr	ecx, 14h
	jne	@@9a
	cmp	ebx, eax
	jb	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	lea	edx, [ebx+8]
	mov	[@@P], edx
	call	_ArcUnicode, 1
	shr	ebx, 1
	mov	[@@SC], ebx

@@1:	mov	ecx, [@@SC]
	add	esi, 8
	sub	ecx, 4
	jb	@@9
	xor	eax, eax
	mov	edi, esi
	repne	scasw
	jne	@@9
	mov	[@@SC], ecx
	call	_ArcName, esi, -1
	and	[@@D], 0
	mov	eax, [esi-4]
	mov	ebx, [esi-8]
	add	eax, [@@P]
	mov	esi, edi
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
