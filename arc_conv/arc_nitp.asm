
; "Nitro Amusement Disk" *.npp
; menu.exe
; 0044BB40 unpack

	dw 0
_arc_nitp PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	eax
	cmp	eax, 5074696Eh
	jne	@@9a
	pop	ebx
	mov	[@@N], ebx
	test	ebx, ebx
	je	@@9a
	imul	ebx, 90h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	lea	edi, [esi+10h]
	xor	eax, eax
	lea	ecx, [eax+3Fh]
	mov	edx, edi
	repne	scasb
	jne	@@8
	mov	byte ptr [edi-1], 2Fh
	push	esi
	lea	esi, [esi+50h]
	lea	ecx, [eax+10h]
	rep	movsd
	pop	esi
	stosb
	call	_ArcName, edx, -1
	and	[@@D], 0
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	mov	ebx, [esi+8]
	lea	eax, [@@D]
	cmp	word ptr [esi+0Ch], 1
	je	@@2a
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 90h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	call	_ArcMemRead, eax, ebx, dword ptr [esi+4], 0
	call	_lzss_unpack, [@@D], ebx, edx, eax
	jmp	@@1b
ENDP
