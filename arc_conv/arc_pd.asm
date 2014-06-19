
; "Cross Channel" *.pd

	dw 0
_arc_pd_cc PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	enter	@@stk+48h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 48h
	jc	@@9a
	pop	ecx
	pop	eax
	sub	ecx, 'kcaP'
	jne	@@9a
	cmp	eax, 'sulP'
	je	@@2a
	sub	eax, 'ylnO'
	jne	@@9a
@@2a:	mov	[@@L0], eax
	pop	eax
	add	ecx, 0Dh
@@2b:	pop	edx
	or	eax, edx
	dec	ecx
	jne	@@2b
	pop	ebx
	pop	edx
	or	eax, edx
	lea	edx, [ebx-1]
	mov	[@@N], ebx
	shr	edx, 14h
	or	eax, edx
	jne	@@9a
	lea	ebx, [ebx*8+ebx]
	shl	ebx, 4
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	byte ptr [esi], 0
	je	@@9
	call	_ArcCount, [@@N]

@@1:	mov	ebx, 80h
	call	_ArcName, esi, ebx
	add	esi, ebx
	and	[@@D], 0
	mov	eax, [esi+4]
	mov	ebx, [esi+8]
	or	eax, [esi+0Ch]
	jne	@@1a
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	cmp	[@@L0], 0
	je	@@1a
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
@@8:	add	esi, 10h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

; "Carnival" *.pd

	dw 0
_arc_pd_sml PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 8

	enter	@@stk+34h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 34h
	jc	@@9a
	pop	ecx
	pop	eax
	movzx	edx, byte ptr [esi+2Bh]
	sub	ecx, 'kcaP'
	jne	@@9a
	cmp	eax, 'sulP'
	je	@@2a
	sub	eax, 'ylnO'
	jne	@@9a
@@2a:	mov	[@@L0], eax
	mov	[@@L0+4], edx
	pop	eax
	add	ecx, 7
@@2b:	pop	edx
	or	eax, edx
	dec	ecx
	jne	@@2b
	pop	edx
	pop	ebx
	shl	edx, 8
	pop	ecx
	or	eax, edx
	lea	edx, [ebx-1]
	mov	[@@N], ebx
	shr	edx, 14h
	or	eax, edx
	jne	@@9a
	call	_FileSeek, [@@S], ecx, 0
	jc	@@9a
	lea	ebx, [ebx*2+ebx]
	shl	ebx, 4
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	byte ptr [esi], 0
	je	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, 20h
	and	[@@D], 0
	movsx	ecx, byte ptr [esi+27h]
	mov	eax, [esi+28h]
	mov	ebx, [esi+2Ch]
	sub	eax, ecx
	sub	ebx, ecx
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	cmp	[@@L0], 0
	je	@@1c
	test	ebx, ebx
	je	@@1a
	mov	edx, [@@D]
	mov	eax, [@@L0+4]
	mov	ecx, ebx
@@1b:	xor	[edx], al
	inc	edx
	dec	ecx
	jne	@@1b
	jmp	@@1a

@@1d:	mov	byte ptr [edx+1Ah], 0
	jmp	@@1a

@@1c:	cmp	ebx, 1Bh
	jb	@@1a
	call	_ArcGetExt
	mov	edx, [@@D]
	cmp	eax, 'gnp'
	je	@@1d
	cmp	eax, 'ggo'
	jne	@@1a
	mov	eax, [@@L0+4]
	xor	[edx+1Ah], al
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 30h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
