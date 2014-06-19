
; "Dungeon Siege 3" *.oaf

	dw 0
_arc_ds3_oaf PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 0Ch


	enter	@@stk+18h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 18h
	jc	@@9a
	pop	eax
	pop	edx
	sub	eax, '!FAO'
	sub	edx, 40002h
	or	eax, edx
	jne	@@9a
	mov	eax, [esi+14h]
	imul	ebx, eax, 14h
	mov	[@@N], eax
	dec	eax
	shr	eax, 14h
	jne	@@9a
	call	_FileGetSize, [@@S]
	jc	@@9a
	sub	eax, [esi+0Ch]
	jb	@@9a
	xchg	edi, eax
	and	[@@L0], 0
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	call	_FileSeek, [@@S], dword ptr [esi+0Ch], 0
	jc	@@9a
	lea	eax, [@@L0]
	call	_ArcMemRead, eax, 0, edi, 0
	jc	@@9
	mov	[@@L0+4], edi
	call	_ArcCount, [@@N]
	call	_ArcSetCP, 65001		; CP_UTF8
	mov	eax, [@@L0]
	mov	esi, [@@M]
	mov	[@@L0+8], eax

@@1:	mov	ecx, [@@L0+4]
	mov	edi, [@@L0+8]
	mov	edx, edi
	xor	eax, eax
	test	ecx, ecx
	je	@@1d
	repne	scasb
@@1d:	mov	[@@L0+4], ecx
	mov	[@@L0+8], edi
	sub	edi, edx
	je	@@1e
	call	_ArcName, edx, edi
@@1e:
	and	[@@D], 0
	mov	ebx, [esi+0Ch]
	call	_FileSeek, [@@S], dword ptr [esi+4], 0
	jc	@@1a
	lea	eax, [@@D]
	test	byte ptr [esi+0Bh], 10h
	jne	@@1c
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 14h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
	call	_MemFree, [@@L0]
@@9a:	leave
	ret

@@1c:	call	_ArcMemRead, eax, ebx, dword ptr [esi+10h], 0
	call	_zlib_unpack, [@@D], ebx, edx, eax
	jmp	@@1b
ENDP