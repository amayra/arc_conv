
; "Maho Tama Series - Sukumizu Hen" *.dat
; ags.exe

; "Animation Game System"

	dw 0
_arc_erogos PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@F

	enter	@@stk+20h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 1Eh
	jc	@@9a
	pop	eax
	cmp	eax, 'kcap'
	jne	@@9a
	movzx	ebx, word ptr [esi+4]
	mov	[@@N], ebx
	dec	ebx
	js	@@9a
	imul	ebx, 18h
	add	esi, 6
	lea	eax, [ebx+1Eh]
	cmp	[esi+10h], eax
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 18h, ebx, 0
	jc	@@9
	mov	edi, [@@M]
	push	6
	pop	ecx
	rep	movsd
	lea	esi, [edi-18h]
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 10h
	and	[@@D], 0
	mov	ebx, [esi+14h]
	call	_FileSeek, [@@S], dword ptr [esi+10h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 18h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
