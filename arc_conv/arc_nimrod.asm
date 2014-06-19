
; "Seikai no Senki" DATA\*.wac

	dw 0
_arc_nimrod PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+20h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 20h
	jc	@@9a
	mov	edi, offset @@sign
	push	4
	pop	ecx
	repe	cmpsd
	jne	@@9a
	lodsd
	xchg	edi, eax
	lodsd
	xchg	ebx, eax
	lodsd
	cmp	eax, 20h
	jne	@@9a
	lodsd
	lea	ecx, [eax-1]
	mov	[@@N], eax
	shr	ecx, 14h
	imul	eax, 110h
	sub	eax, ebx
	or	eax, ecx
	jne	@@9a
	call	_FileSeek, [@@S], edi, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	lodsd
	cmp	eax, 100h
	jne	@@9
	xchg	edi, eax
	call	_ArcName, esi, edi
	lea	esi, [esi+edi+0Ch]
	mov	eax, [esi-0Ch]
	mov	ebx, [esi-8]
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	and	[@@D], 0
	call	_FileSeek, [@@S], dword ptr [esi-4], 0
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

@@sign	db 'Nimrod1.00',0,0,0,0,0,0
ENDP
