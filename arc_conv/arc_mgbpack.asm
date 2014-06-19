
; Kengeki.exe

	dw 0
_arc_mgbpack PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P
@M0 @@SC

	enter	@@stk+40h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 40h
	jc	@@9a
	call	@@3, esi, 40h
	pop	eax
	pop	edx
	pop	ecx
	pop	edi
	sub	eax, 'pbgm'
	sub	edx, 'kca'
	dec	ecx
	sub	edi, 40h
	or	eax, edx
	or	ecx, edi
	or	eax, ecx
	jne	@@9a
	pop	ebx
	lea	ecx, [ebx-1]
	mov	[@@N], ebx
	shr	ecx, 14h
	jne	@@9a
	imul	eax, ebx, 15h
	pop	ebx
	mov	ecx, ebx
	cmp	ebx, eax
	jb	@@9a
	add	ecx, 40h
	jc	@@9
	mov	[@@P], ecx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	[@@SC], ebx
	call	@@3, esi, ebx
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

@@1:	sub	[@@SC], 15h
	jb	@@9
	lodsd
	sub	[@@SC], eax
	jb	@@9
	xchg	edi, eax
	call	_ArcName, esi, edi
	lea	esi, [esi+edi+11h]
	and	[@@D], 0
	mov	eax, [esi-10h]
	mov	edx, [esi-0Ch]
	mov	ebx, [esi-8]
	or	edx, [esi-4]
	jne	@@1a
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	mov	ecx, [esp+8]
	mov	edx, [esp+4]
	test	ecx, ecx
	je	@@3b
@@3a:	xor	byte ptr [edx], 0A4h
	inc	edx
	dec	ecx
	jne	@@3a
@@3b:	ret	8
ENDP