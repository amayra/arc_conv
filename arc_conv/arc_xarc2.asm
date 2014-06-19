
; "Seinarukana -The Spirit of Eternity Sword 2-" *.arc, *.xarc

	dw 0
_arc_xarc2 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1, 20h

	enter	@@stk+28h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 28h
	jc	@@9a
	mov	eax, [esi]
	mov	edx, [esi+4]
	cmp	eax, 'CRAX'
	je	@@2a
	sub	eax, 'OKIM'-'CRAX'
@@2a:	cmp	edx, 2
	jne	@@9a
	call	_xarc_crc16, esi, 0Ah
	jc	@@9a
	mov	ecx, [esi+10h]
	mov	eax, [esi+16h]
	mov	edx, [esi+24h]
	lea	edi, [ecx-1]
	sub	eax, 'MNFD'
	sub	edx, 'XIDN'
	shr	edi, 14h
	or	eax, edx
	or	eax, edi
	jne	@@9a
	mov	edx, ecx
	mov	ebx, [esi+1Ah]
	shl	edx, 4
	add	edx, 30h
	cmp	ebx, edx
	jb	@@9a
	mov	[@@N], ecx
	lea	ecx, [ecx*2+ecx+1]
	shl	ecx, 2
	add	ecx, ebx
	jc	@@9a
	sub	ecx, 28h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 28h, ecx, 0
	jc	@@9
	mov	edi, [@@M]
	push	28h/4
	pop	ecx
	push	edi
	rep	movsd
	pop	esi
	lea	eax, [esi+ebx+4]
	cmp	dword ptr [esi+ebx], 'RDAC'
	jne	@@9
	mov	[@@L0], eax
	mov	ecx, [@@N]
	shl	ecx, 3
	mov	eax, [esi+ecx+28h]
	mov	edx, [esi+ecx*2+2Ch]
	lea	ecx, [ecx+ecx+30h]
	sub	eax, 'XIDE'
	sub	edx, 'FITC'
	sub	ebx, ecx
	add	esi, ecx
	or	eax, edx
	jne	@@9
	mov	edx, [@@N]
	call	@@5
	test	eax, eax
	je	@@9
	mov	[@@N], eax
	call	_ArcCount, eax

@@1:	movzx	ebx, word ptr [esi+6]
	add	esi, 0Ah
	call	_ArcName, esi, ebx
	lea	esi, [esi+ebx+2]
	and	[@@D], 0
	mov	edx, [@@L0]
	lea	eax, [edx+0Ch]
	mov	[@@L0], eax
	cmp	dword ptr [edx+6], 0
	jne	@@1a
	call	_FileSeek, [@@S], dword ptr [edx+2], 0
	jc	@@1a
	lea	edi, [@@L1]
	call	_FileRead, [@@S], edi, 1Eh
	jc	@@1a
	cmp	dword ptr [edi], 'ATAD'
	jne	@@1a
	mov	ebx, [edi+18h]
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

_xarc_crc16 PROC
	mov	edx, [esp+4]
	mov	ecx, [esp+8]
	xor	eax, eax
	test	ecx, ecx
	je	@@9
	push	ebx
@@1:	xor	ah, [edx]
	inc	edx
	push	8
	pop	ebx
@@2:	shl	ax, 1
	jnc	@@3
	xor	eax, 1021h
@@3:	dec	ebx
	jne	@@2
	dec	ecx
	jne	@@1
	pop	ebx
@@9:	neg	eax
	ret	8
ENDP

@@5 PROC
	push	edx
	push	esi
@@1:	sub	ebx, 0Ch
	jb	@@9
	movzx	ecx, word ptr [esi+6]
	add	esi, 0Ah
	sub	ebx, ecx
	jb	@@9
	test	ecx, ecx
	je	@@3
@@2:	xor	byte ptr [esi], 56h
	inc	esi
	dec	ecx
	jne	@@2
@@3:	inc	esi
	inc	esi
	dec	edx
	jne	@@1
@@9:	pop	esi
	pop	eax
	sub	eax, edx
	ret
ENDP

ENDP
