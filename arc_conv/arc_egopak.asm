
; "Aozora Majika" game0?.dat
; magiccer.exe 004ED366

	dw 0
_arc_egopak PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1
@M0 @@I
@M0 @@L2
@M0 @@L3
@M0 @@L4

	enter	@@stk+14h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 14h
	jc	@@9a
	pop	eax
	pop	ebx
	pop	edx
	pop	ecx
	pop	edi
	sub	eax, '0KAP'
	inc	edi
	or	eax, edi
	jne	@@9a
	lea	eax, [edx-1]
	lea	edi, [ecx-1]
	shr	eax, 10h
	shr	edi, 14h
	or	eax, edi
	jne	@@9a
	mov	[@@L0], edx
	mov	[@@N], ecx
	add	edx, ecx
	shl	ecx, 3
	lea	edi, [ecx+edx*8+10h]
	lea	ecx, [ebx-14h]
	sub	ebx, edi
	jb	@@9
	cmp	ebx, edx
	jb	@@9
	inc	edx
	shl	edx, 2
	lea	eax, [@@M]
	call	_ArcMemRead, eax, edx, ecx, 0
	jc	@@9
	sub	edx, 4
	mov	esi, [@@M]
	mov	ecx, [@@N]
	add	ecx, [@@L0]
	lea	edi, [edx+edi-10h]
	mov	[@@L2], edx
	dec	ecx
	call	@@5
	sub	eax, [@@L0]
	jbe	@@9
	mov	[@@N], eax
	call	_ArcCount, eax

	and	[@@I], 0
	and	[@@L3], 0
	mov	[@@L1], esp
@@2:	sub	esp, 200h

	mov	eax, [@@L3]
	mov	ecx, [@@L2]
	lea	edx, [ecx+eax*8]
	mov	ebx, [edx+4]
	cmp	ebx, [@@I]
	jbe	@@2e
	mov	[@@L4], ebx
	mov	edi, esp
	push	0
@@2a:	test	eax, eax
	je	@@2c
	mov	edx, edi
	sub	edx, esp
	shr	edx, 7
	jne	@@2e
	mov	edx, [ecx+eax*8]
	push	eax
	cmp	edx, eax
	jae	@@2e
	xchg	eax, edx
	jmp	@@2a

@@2b:	mov	edx, [esi+eax*4]
	call	@@3
	jnc	@@2e
	mov	byte ptr [edi-1], '/'
@@2c:	pop	eax
	test	eax, eax
	jne	@@2b

@@1:	push	edi
	mov	edx, [@@I]
	add	edx, [@@L0]
	mov	edx, [esi+edx*4]
	call	@@3
	pop	edi
	jnc	@@8
	mov	edx, esp
	call	_ArcName, edx, -1
	mov	eax, [@@I]
	shl	eax, 1
	add	eax, [@@L0]
	mov	ecx, [@@L2]
	lea	edx, [ecx+eax*8]
	mov	ebx, [edx+4]
	and	[@@D], 0
	call	_FileSeek, [@@S], dword ptr [edx], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	mov	eax, [@@I]
	inc	eax
	mov	[@@I], eax
	cmp	eax, [@@N]
	jae	@@9
	cmp	eax, [@@L4]
	jb	@@1
@@2e:	lea	esp, [ebp-@@stk]
	mov	eax, [@@L3]
	inc	eax
	mov	[@@L3], eax
	cmp	eax, [@@L0]
	jb	@@2

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	movzx	ecx, byte ptr [edx-1]
@@3a:	mov	al, [edx]
	inc	edx
	cmp	edi, [@@L1]
	je	@@3c
	stosb
	dec	ecx
	jne	@@3a
	xchg	eax, ecx
	cmp	edi, [@@L1]
	je	@@3c
	stosb
@@3c:	ret

@@5 PROC
	xor	edx, edx
	inc	edx
@@1:	dec	ebx
	js	@@9
	movzx	eax, byte ptr [edi]
	inc	edi
	test	eax, eax
	je	@@9
	sub	ebx, eax
	jb	@@9
	mov	[esi+edx*4], edi
	add	edi, eax
	inc	edx
	dec	ecx
	jne	@@1
@@9:	xchg	eax, edx
	ret
ENDP

ENDP
