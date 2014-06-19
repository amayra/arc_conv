
_arc_sgs1 PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L2

	enter	@@stk, 0
	cmp	[@@PC], 0
	jne	@@9a
	mov	esi, [@@FL]
	mov	ebx, [esi]
	shl	ebx, 5
	lea	edi, [ebx+10h]
	mov	[@@P], edi
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax
	mov	eax, '.SGS'
	stosd
	mov	eax, ' TAD'
	stosd
	mov	eax, '00.1'
	stosd
	movsd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	call	_string_copy_ansi, edi, 13h, dword ptr [esi+4]
	add	edi, 13h
	xor	eax, eax
	stosb

	mov	eax, [esi+2Ch]
	mov	ecx, [@@P]
	stosd
	stosd
	xchg	eax, ecx
	stosd
	lea	ebx, [ecx*8+ecx+7]
	shr	ebx, 3
	lea	edx, [esi+30h]
	lea	eax, [@@L2]
	call	_ArcLoadFile, eax, edx, 0, ecx, ebx
	jc	@@3c
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	lea	eax, [edx+ecx]
	call	@@Pack, eax, ebx, edx, ecx
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	cmp	eax, ecx
	jae	@@3a
	add	edx, ecx
	xchg	eax, ecx
	inc	byte ptr [edi-0Dh]
@@3a:	mov	[edi-0Ch], ecx
	add	[@@P], ecx
	call	_FileWrite, [@@D], edx, ecx
@@3c:	call	_MemFree, [@@L2]
	jmp	@@1

@@7:	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	mov	edx, [@@M]
	sub	edi, edx
	call	_FileWrite, ebx, edx, edi
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
@@L1 = dword ptr [ebp-10h]
@@L2 = dword ptr [ebp-14h]

@tblcnt = 1000h

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
	push	1
	mov	edi, [@@DB]
	xor	ebx, ebx
	push	edi	; @@L1
	push	ebx
	cmp	[@@SC], ebx
	je	@@9
@@1:	inc	[@@L2]
	call	@@next
@@1a:	mov	ecx, [@@SC]
	cmp	ecx, 2
	jb	@@1
	call	@@match
	test	ecx, ecx
	je	@@1
	; ecx - address, eax - count
	push	eax
	push	ecx
	call	@@2
	mov	al, -1
	call	@@bit
	mov	[@@L0], edx
	pop	eax
	pop	ebx
	lea	ecx, [ebx-1]
	neg	eax
	shl	ecx, 0Ch
	add	eax, ecx
	stosw
@@3:	call	@@next
	dec	ebx
	jne	@@3
	jmp	@@1a

@@9d:	inc	esi
@@9:	call	@@2
	cmp	dl, 1
	je	@@9c
@@9b:	call	@@bit0
	jnc	@@9b
@@9c:	call	_MemFree, [@@M]
	mov	esi, [@@SC]
	add	esi, [@@L2]
	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@2:	mov	ebx, [@@L2]
	mov	edx, [@@L0]
	test	ebx, ebx
	je	@@2b
	sub	esi, ebx
@@2a:	call	@@bit0
	movsb
	dec	ebx
	jne	@@2a
	mov	[@@L2], ebx
@@2b:	ret

@@bit0:	mov	al, 0
@@bit:	cmp	dl, 1
	jne	@@bit1
	mov	[@@L1], edi
	inc	edi
@@bit1:	add	al, al
	adc	dl, dl
	jnc	@@bit2
	mov	eax, [@@L1]
	mov	[eax], dl
	mov	dl, 1
@@bit2:	ret

@@next:	dec	[@@SC]
	je	@@9d
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
	push	1	; C = min-1
	push	10h
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
@@3:	cmp	ecx, -0FFFh	; !!!
	jae	@@4
	pop	eax
	pop	ecx
@@9:	pop	edi
	ret
ENDP

ENDP	; @@Pack

ENDP
