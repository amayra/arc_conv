
; "Sisters ~Natsu no Saigo no Hi~" *.isa
; sisters.exe

	dw 0
_arc_ism PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	pop	ecx
	sub	eax, ' MSI'
	sub	edx, 'HCRA'
	sub	ecx, 'DEVI'
	or	eax, edx
	or	eax, ecx
	jne	@@9a
	pop	eax
	movzx	ebx, ax
	shr	eax, 10h
	dec	eax
	lea	ecx, [ebx-1]
	mov	[@@N], ebx
	shr	ecx, 14h
	or	eax, ecx
	jne	@@9a
	shl	ebx, 6
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 34h
	and	[@@D], 0
if 0
	call	_ArcGetExt
	cmp	eax, 'gnp'
	je	@@8
endif
	mov	ebx, [esi+38h]
	call	_FileSeek, [@@S], dword ptr [esi+34h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
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