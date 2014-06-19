
; "Touhou 7.5 - Immaterial and Missing Power" th075.dat, th075bgm.dat

	dw 0
_arc_th075 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC
@M0 @@L0

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 2
	jc	@@9a
	movzx	ebx, word ptr [esi]
	test	ebx, ebx
	je	@@9a
	mov	[@@N], ebx
	imul	ebx, 6Ch
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	ecx, ebx
	mov	al, 64h
	mov	dl, 64h
@@2a:	xor	[esi], al
	inc	esi
	add	eax, edx
	add	edx, 4Dh
	dec	ecx
	jne	@@2a
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	call	_ArcName, esi, 64h
	and	[@@D], 0
	mov	ebx, [esi+64h]
	call	_FileSeek, [@@S], dword ptr [esi+68h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 6Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
