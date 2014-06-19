
_arc_vivid PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@P
@M0 @@M
@M0 @@DC

	enter	@@stk, 0
	mov	eax, [@@PC]
	test	eax, eax
	je	@@2a
	dec	eax
	jne	@@9a
	mov	eax, [@@PB]
	call	_ArcAddFile, [@@D], dword ptr [eax], 0
@@2a:	mov	[@@P], eax

	mov	esi, [@@FL]
	mov	ecx, [esi-8]
	imul	eax, [esi], 0Ah
	lea	ebx, [eax+ecx*2+0Ah]
if 0
	push	0Ah
	pop	ebx
	mov	esi, [@@FL]
	lodsd
@@2b:	mov	esi, [esi]
	test	esi, esi
	je	@@2c
	mov	ecx, [esi+8]
	lea	ebx, [ebx+ecx*2+0Ah]
	jmp	@@2b
@@2c:
endif
	lea	eax, [ebx+7Fh]
	shr	eax, 7
	add	eax, ebx
	mov	[@@DC], eax
	lea	eax, [eax+ebx+0Ch]
	call	_MemAlloc, eax
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax

	mov	esi, [@@FL]
	lodsd
@@1a:	mov	eax, [@@P]
	stosd
	mov	esi, [esi]
	test	esi, esi
	je	@@1b
	mov	eax, [esi+8]
	mov	ecx, 0FFh
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
	stosw
	xchg	ecx, eax
	xor	eax, eax
	stosd
	mov	eax, [esi+4]
	xchg	esi, eax
	rep	movsw
	xchg	esi, eax
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
	add	[@@P], eax
	jmp	@@1a

@@1b:	xor	eax, eax
	stosw
	stosd
	mov	ebx, edi
	mov	eax, [@@M]
	sub	ebx, eax
	lea	edx, [edi+4]
	mov	[edi], ebx
	call	@@Pack, edx, [@@DC], eax, ebx
	mov	ecx, [@@P]
	mov	[edi+4+eax], 'KCAP'
	mov	[edi+8+eax], ecx
	add	eax, 0Ch
	call	_FileWrite, [@@D], edi, eax
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@Pack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@M = dword ptr [ebp-4]
@@D = dword ptr [ebp-8]
@@L0 = dword ptr [ebp-0Ch]

@tblcnt = 800h

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	call	_MemAlloc, 10000h*4+@tblcnt*2
	jc	@@9a
	push	eax
	mov	esi, [@@SB]
	xchg	edi, eax
	mov	ecx, 10000h
	lea	eax, [esi-@tblcnt-1]
	cld
	rep	stosd
	push	edi
	push	0
	mov	edi, [@@DB]
	cmp	[@@SC], 0
	je	@@9
@@1:	inc	byte ptr [@@L0]
	jns	@@1b
	call	@@2
@@1b:	call	@@next
@@1a:	mov	ecx, [@@SC]
	cmp	ecx, 2
	jb	@@1
	mov	edx, [@@L0]
	xor	eax, eax
	dec	edx
	cmp	edx, 7Eh	; 0 or 0x7F
	adc	eax, 1
	call	@@match
	test	ecx, ecx
	je	@@1
	; ecx - address, eax - count
	not	ecx
	push	eax
	push	ecx
	call	@@2
	pop	ecx
	pop	ebx
	lea	eax, [ebx+1Eh]
	shl	eax, 0Bh-1
	add	eax, ecx
	xchg	al, ah
	stosw
@@3:	call	@@next
	dec	ebx
	jne	@@3
	jmp	@@1a

@@9:	call	@@2
	call	_MemFree, [@@M]
	mov	esi, [@@SC]
	add	esi, [@@L0]
	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@2:	mov	ecx, [@@L0]
	test	ecx, ecx
	je	@@2a
	lea	eax, [ecx-1]
	stosb
	sub	esi, ecx
	rep	movsb
	mov	[@@L0], ecx
@@2a:	ret

@@next:	dec	[@@SC]
	je	@@9
	mov	ecx, esi
	mov	edx, [@@M]
	movzx	eax, word ptr [esi]
	xchg	ecx, [edx+eax*4]
	sub	ecx, esi
	cmp	ecx, -@tblcnt+1
	sbb	eax, eax
	neg	ecx
	mov	edx, esi
	or	ecx, eax
	mov	eax, [@@D]
	and	edx, @tblcnt-1
	mov	[eax+edx*2], cx
	inc	esi
	ret

@@match PROC
	push	edi
	push	0	; D
	push	eax	; C = min-1
	push	20h
	pop	ebx
	cmp	ecx, ebx
	jae	$+4
	mov	ebx, ecx
	mov	ecx, [ebp-4]
	movzx	eax, word ptr [esi]
	mov	ecx, [ecx+eax*4]
	sub	ecx, esi
	jmp	@@3

@@4:	xor	edx, edx
	lea	edi, [esi+ecx]
	inc	edx
@@5:	inc	edx
	cmp	edx, ebx
	jae	@@6
	mov	al, [esi+edx]
	cmp	[edi+edx], al
	je	@@5
@@6:	pop	eax
	and	edx, -2
	cmp	eax, edx
	jae	@@2
	xchg	eax, edx
	pop	edx
	cmp	eax, ebx
	jae	@@9
	push	ecx
@@2:	push	eax
	and	edi, @tblcnt-1
	mov	edx, [ebp-8]
	movzx	edi, word ptr [edx+edi*2]
	sub	ecx, edi
@@3:	cmp	ecx, -@tblcnt
	jae	@@4
	pop	eax
	pop	ecx
@@9:	pop	edi
	ret
ENDP

ENDP	; @@Pack

ENDP