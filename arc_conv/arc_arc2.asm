
; "Amy's Fantasys" AMY.A2, "Kotobuki" KOTOBUKI.ADT, "Gloria" GLORIA.DAT
; ARC2LOAD.DLL .10002ECC

	dw 0
_arc_arc2 PROC

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
	pop	ebx
	pop	edx
	lea	ecx, [ebx-1]
	sub	eax, '2cra'
	mov	edi, edx
	sub	edx, 10000h
	shr	ecx, 14h
	or	eax, edx
	or	eax, ecx
	jne	@@9a
	mov	[@@N], ebx
	shl	ebx, 5
	call	_FileSeek, [@@S], edi, 0
	jc	@@1a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

@@1:	lea	edx, [esi+1]
	call	_ArcName, edx, 0Fh
	mov	edx, offset @@T
	mov	al, [esi]
@@3a:	mov	ecx, [edx+1]
	cmp	[edx], al
	lea	edx, [edx+5]
	je	@@3b
	test	ecx, ecx
	jne	@@3a
	mov	al, [esi]
	shr	al, 4
	add	al, -10
	sbb	ah, ah
	add	al, 3Ah
	and	ah, 27h-20h
	add	al, ah
	mov	cl, al
	mov	al, [esi]
	and	al, 0Fh
	add	al, -10
	sbb	ah, ah
	add	al, 3Ah
	and	ah, 27h-20h
	add	al, ah
	mov	ch, al
	shl	ecx, 8
	mov	cl, '$'
@@3b:	call	_ArcSetExt, ecx
@@3c:
	mov	ebx, [esi+14h]
	and	[@@D], 0
	call	_FileSeek, [@@S], dword ptr [esi+10h], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 3
	xchg	ebx, eax
	lea	edi, [ebx+3]
	shr	edi, 2
	je	@@1a
	mov	eax, [esi+18h]
	mov	ecx, [esi+1Ch]
@@1b:	add	eax, ecx
	sub	[edx], eax
	xchg	eax, ecx
	add	edx, 4
	dec	edi
	jne	@@1b
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 20h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@T	db 'b', 'bmp',0
	db 'w', 'wav',0
	db 'm', 'mds',0
	db 'x', 'syx',0
	db 's', 'sco',0
	db 0, 0,0,0,0
ENDP
