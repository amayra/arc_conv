
_arc_hypack PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L0
@M0 @@L2
@M0 @@L1

	enter	@@stk, 0
	mov	ebx, [@@PC]
	shr	ebx, 1
	jne	@@9a
	mov	esi, [@@PB]
	push	1
	pop	eax
	jnc	@@2c
	lodsd
	call	_string_num, eax
	jc	@@9a
	cmp	eax, 2
	jae	@@9a
@@2c:	mov	[@@L1], eax

	mov	esi, [@@FL]
	lodsd
	imul	ebx, eax, 30h
	add	ebx, 10000h
	and	[@@P], 0
	push	eax
	push	0
	push	3006B63h
	push	61507948h
	mov	edx, esp
	call	_FileWrite, [@@D], edx, 10h
	call	_MemAlloc, ebx
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax

	sub	esp, 200h
	xor	ecx, ecx
@@2a:	mov	eax, ecx
	push	8
	pop	edx
@@2b:	shr	eax, 1
	jnc	$+7
	xor	eax, 8408h
	dec	edx
	jne	@@2b
	mov	[esp+ecx*2], ax
	inc	ecx
	test	ch, ch
	je	@@2a
	mov	[@@L0], esp

@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	mov	ecx, [esi+4]
	mov	edx, [esi+8]
	add	ecx, edx
	call	@@4
	mov	[edi+14h], ebx
	call	_string_copy_ansi, edi, 15h, dword ptr [esi+4]
	add	edi, 18h

	mov	eax, [@@P]
	stosd
	xor	ecx, ecx
	mov	eax, [esi+2Ch]
	stosd
	xchg	ecx, eax
	stosd
	mov	eax, 0FFFF0100h
	stosd

	lea	ebx, [ecx*8+ecx+1Fh]
	shr	ebx, 3
	add	ebx, 0Fh
	cmp	[@@L1], 0
	jne	$+4
	xor	ebx, ebx
	lea	edx, [esi+30h]
	lea	eax, [@@L2]
	call	_ArcLoadFile, eax, edx, 0, ecx, ebx
	jc	@@3c
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	test	ebx, ebx
	je	@@3a
	lea	eax, [edx+ecx]
	call	@@Mariel_Pack, eax, ebx, edx, ecx
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	cmp	eax, ecx
	jae	@@3a
	add	edx, ecx
	xchg	eax, ecx
	inc	byte ptr [edi-4]
@@3a:	mov	[edi-8], ecx
	mov	ebx, ecx

	or	eax, -1
	push	edx
	call	@@5, edx, ebx
	pop	edx
	mov	[edi-2], ax

	mov	ecx, ebx
	xor	eax, eax
	neg	ecx
	and	ecx, 0Fh
	push	edi
	lea	edi, [edx+ebx]
	add	ebx, ecx
	rep	stosb
	pop	edi
	add	[@@P], ebx
	call	_FileWrite, [@@D], edx, ebx
@@3c:	call	_MemFree, [@@L2]

	xchg	esi, eax
	lea	esi, [eax+0Ch+14h]	; LastWriteTime
	movsd
	movsd
	xchg	esi, eax
	jmp	@@1

@@7:	mov	ebx, [@@D]
	mov	edx, [@@M]
	sub	edi, edx
	call	_FileWrite, ebx, edx, edi
	call	_FileSeek, ebx, 8, 0
	lea	edx, [@@P]
	call	_FileWrite, ebx, edx, 4

	call	_FileSeek, ebx, 0, 0
	or	eax, -1
	mov	edi, [@@M]
	mov	esi, 10000h
@@7a:	push	eax
	call	_FileRead, ebx, edi, esi
	xchg	ecx, eax
	pop	eax
	push	ecx
	call	@@5, edi, ecx
	pop	ecx
	cmp	ecx, esi
	je	@@7a
	mov	[edi], eax
	call	_FileWrite, ebx, edi, 2

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@4 PROC
	xor	ebx, ebx
@@1:	dec	ecx
	dec	edx
	js	@@9
	mov	al, [ecx]
	cmp	al, 2Fh
	je	@@9
	cmp	al, 5Ch
	je	@@9
	cmp	al, 2Eh
	je	@@2
	rol	ebx, 8
	test	bl, bl
	mov	bl, al
	je	@@1
@@9:	xor	ebx, ebx
	ret

@@2:	rol	ebx, 8
	test	bl, bl
	jne	@@9
	mov	byte ptr [ecx], 0
	ret
ENDP

@@5 PROC
	push	esi
	mov	ecx, [esp+0Ch]
	mov	esi, [esp+8]
	test	ecx, ecx
	je	@@4
@@3:	movzx	edx, al
	movzx	eax, ah
	xor	dl, [esi]
	inc	esi
	xor	ax, [esp+14h+edx*2]	; esi, ret, src, cnt, xxx
	dec	ecx
	jne	@@3
@@4:	pop	esi
	ret	8
ENDP

@@Mariel_Pack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@M = dword ptr [ebp-4]
@@D = dword ptr [ebp-8]
@@L0 = dword ptr [ebp-0Ch]
@@L1 = dword ptr [ebp-10h]
@@L2 = dword ptr [ebp-14h]

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
	pop	edx
	pop	ebx
	neg	edx
	lea	ecx, [ebx-1]
	cmp	ebx, 0Fh
	jb	@@3a
	xor	ecx, ecx
	cmp	bh, 1
	sbb	ecx, -0Fh
@@3a:	lea	eax, [edx-1]
	cmp	edx, 0Bh
	jb	@@3b
	mov	al, dh
	add	al, 0Ah
@@3b:	shl	ecx, 4
	add	eax, ecx
	stosb
	cmp	al, 0E0h
	jb	@@3c
	mov	[edi], bl
	inc	edi
	test	bh, bh
	je	@@3c
	mov	[edi], bh
	inc	edi
@@3c:	cmp	edx, 0Bh
	jb	@@3
	xchg	eax, edx
	stosb
@@3:	call	@@next
	dec	ebx
	jne	@@3
	jmp	@@1a

@@9d:	inc	esi
@@9:	call	@@2
	cmp	edx, 1
	je	@@9c
@@9b:	call	@@bit0
	cmp	edx, 1
	jne	@@9b
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
@@bit:	cmp	edx, 1
	jne	@@bit1
	mov	[@@L1], edi
	add	edi, 4
@@bit1:	add	al, al
	adc	edx, edx
	jnc	@@bit2
	mov	eax, [@@L1]
	mov	[eax], edx
	xor	edx, edx
	inc	edx
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
	mov	ebx, 0FFFFh
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
@@3:	cmp	ecx, -5FFh	; !!!
	jae	@@4
	pop	eax
	pop	ecx
@@9:	pop	edi
	ret
ENDP

ENDP	; @@Pack

ENDP
