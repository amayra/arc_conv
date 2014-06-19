
; "Choukui no Hana", "Stamp Out" data\*.?lk

	dw 0
_arc_glnk PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC

	enter	@@stk+14h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 12h
	jc	@@9a
	mov	eax, [esi]
	movzx	edx, word ptr [esi+4]
	mov	ebx, [esi+6]
	sub	eax, 'KNLG'
	sub	edx, 6Eh
	lea	ecx, [ebx-1]
	or	eax, edx
	shr	ecx, 14h
	or	eax, ecx
	jne	@@9a
	mov	[@@N], ebx
	imul	ecx, ebx, 0Dh
	mov	eax, [esi+0Ah]
	mov	ebx, [esi+0Eh]
	cmp	eax, 12h
	jb	@@9a
	cmp	ebx, ecx
	jb	@@9a
	call	_FileSeek, [@@S], eax, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	mov	[@@SC], ebx

@@1:	sub	[@@SC], 0Dh
	jb	@@9
	movzx	edi, byte ptr [esi]
	inc	esi
	sub	[@@SC], edi
	jb	@@9
	call	_ArcName, esi, edi
	add	esi, edi
	mov	ebx, [esi+4]
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 0Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
