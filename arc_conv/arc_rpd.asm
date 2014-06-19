
; "Black Wolves Saga" *.rpd

	dw 0
_arc_rpd PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC

	enter	@@stk+4, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	ebx
	cmp	ebx, 4+10h
	jb	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]

	mov	edx, esi
	mov	ecx, ebx
@@2a:	not	byte ptr [edx]
	inc	edx
	dec	ecx
	jne	@@2a

	mov	eax, [esi]
	lea	ecx, [eax-1]
	shr	ecx, 14h
	jne	@@9a
	mov	[@@N], eax
	call	_ArcCount, eax
	call	_ArcDbgData, esi, ebx
	sub	ebx, 4
	add	esi, 4
	mov	[@@SC], ebx

@@1:	sub	[@@SC], 10h
	jb	@@9
	lodsd
	sub	[@@SC], eax
	jb	@@9
	push	eax
	push	esi
	add	esi, eax
	call	_ArcName
	and	[@@D], 0

	mov	ebx, [esi]
	call	_FileSeek, [@@S], dword ptr [esi+4], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	test	ebx, ebx
	je	@@1a
	mov	edx, [@@D]
	mov	ecx, ebx
@@1b:	not	byte ptr [edx]
	inc	edx
	dec	ecx
	jne	@@1b
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:
	add	esi, 0Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
