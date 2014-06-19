
; "Musumaker" *.dat

	dw 0
_arc_taskforce PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	pop	eax
	pop	edx
	pop	ebx
	sub	eax, 'fkst'
	sub	edx, 'ecro'
	lea	ecx, [ebx-1]
	shr	ecx, 14h
	or	eax, edx
	or	eax, ecx
	jne	@@9a
	mov	[@@N], ebx
	imul	ebx, 10Ch
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	eax, [ebx+0Ch]
	cmp	byte ptr [esi], 0
	je	@@9
	cmp	[esi+100h], eax
	jne	@@9
	call	_ArcCount, [@@N]

@@1:	mov	edi, 100h
	call	_ArcName, esi, edi
	lea	esi, [esi+edi+0Ch]
	and	[@@D], 0
	mov	edi, [esi-8]
	mov	ebx, [esi-4]
	call	_FileSeek, [@@S], dword ptr [esi-0Ch], 0
	jc	@@1a
	mov	ecx, edi
	cmp	edi, ebx
	jne	$+4
	xor	ecx, ecx
	lea	eax, [@@D]
	call	_ArcMemRead, eax, ecx, ebx, 0
	cmp	ebx, edi
	je	@@1b
	call	_lzss_unpack, [@@D], edi, edx, eax
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
