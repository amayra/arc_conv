
; "Amatsukami no Miko" data.pak
; MikoStg.exe

	dw 0
_arc_mikostg PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@D
@M0 @@N

	enter	@@stk+108h+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 44h
	jc	@@9a
	mov	ebx, [esi+40h]
	pop	eax
	pop	edx
	lea	ecx, [ebx-1]
	sub	eax, 'okiM'
	sub	edx, ' GTS'
	shr	ecx, 14h
	or	eax, edx
	or	eax, ecx
	jne	@@9a
	mov	[@@N], ebx
	call	_ArcCount, ebx

@@1:	mov	edi, esp
	mov	ebx, 108h
	call	_FileRead, [@@S], edi, ebx
	jc	@@9
	sub	ebx, 4
	call	_ArcName, edi, ebx
	mov	ebx, [edi+ebx]
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	; ...
@@9a:	leave
	ret
ENDP
