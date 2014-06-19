
_mod_wip PROC

@@stk = 0
@M0 @@L0
@M0 @@L1

	push	ebp
	mov	ebp, esp
	sub	eax, 2
	jbe	@@9a
	mov	ebx, eax
	shr	eax, 9
	jne	@@9a
	call	_string_select, offset @@T, dword ptr [ebp+0Ch]
	jc	@@9a
	push	eax
	xor	edi, edi
	lea	esi, [ebp+14h]
	inc	edi
	dec	eax
	je	@@2a
	add	edi, 2
	dec	eax
	je	@@2a
	lodsd
	dec	ebx
	je	@@9a
@@2a:	call	_FileEnum, ebx, esi
	jc	@@9a
	push	eax
	xchg	esi, eax

	mov	ebx, [esi+4]
	mov	eax, 0FFFFh
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
	mov	[esi+4], ebx
	test	ebx, ebx
	je	@@1b
@@1:	mov	esi, [esi]
	mov	eax, [esi+4]
	test	eax, eax
	je	@@1a
	call	_BmReadFile, edi, eax
	mov	[esi+4], eax
@@1a:	dec	ebx
	jne	@@1
@@1b:	mov	esi, [@@L1]
	mov	ebx, [esi+4]
	lea	eax, [ebx*2+ebx+1]
	shl	eax, 3
	call	_MemAlloc, eax
	jc	@@9
	xchg	edi, eax
	mov	dword ptr [edi], 'FPIW'
	mov	[edi+4], ebx

	mov	ebx, [@@L0]
	push	dword ptr [ebp+10h]
	cmp	ebx, 2
	jb	@@2b
	call	@@WIP, esi, edi, ebx, 18h
	cmp	ebx, 2
	je	@@9
	push	dword ptr [ebp+14h]
@@2b:	call	@@WIP, esi, edi, ebx, 8
	call	_MemFree, edi

@@2c:	mov	esi, [esi]
	test	esi, esi
	je	@@9
	call	_MemFree, dword ptr [esi+4]
	jmp	@@2c

@@9:	mov	esi, [@@L1]
	call	_BlkDestroy, dword ptr [esi-4]
@@9a:	leave
	ret

@@T	db '8',0, '24',0, '24+8',0, 0

@@WIP PROC

@@B = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@L0 = dword ptr [ebp+1Ch]
@@L1 = dword ptr [ebp+20h]
@@D = dword ptr [ebp+24h]

@@N = dword ptr [ebp-4]
@@L2 = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edx, [@@B]
	mov	esi, [@@S]
	mov	eax, [@@L1]
	mov	ebx, [edx+4]
	mov	[esi+6], al
	push	ebx
	call	_FileCreate, [@@D], FILE_OUTPUT
	jc	@@9a
	mov	[@@D], eax
	lea	eax, [ebx*2+ebx+1]
	shl	eax, 3
	call	_FileWrite, [@@D], esi, eax

	lea	edi, [esi+8]
	test	ebx, ebx
	je	@@9
@@1:	mov	esi, [@@B]
	mov	esi, [esi]
	mov	[@@B], esi
	mov	esi, [esi+4]
	test	esi, esi
	jne	@@1g
	xor	eax, eax
	lea	ecx, [eax+6]
	rep	stosd
	jmp	@@1f

@@1g:	movsd	; 0
	movsd	; 4
	lodsd
	lodsd
	movsd	; 10h
	movsd	; 14h
	xor	eax, eax
	sub	esi, 18h
	stosd
	stosd

	mov	ecx, [esi]	
	mov	ebx, [@@L1]
	imul	ecx, [esi+4]
	shr	ebx, 3
	imul	ebx, ecx
	lea	eax, [ebx*8+ebx+18h]
	shr	eax, 3
	add	eax, ebx
	call	_MemAlloc, eax
	jc	@@1f
	push	edi	; @@L2
	xchg	edi, eax
	xor	ecx, ecx
	lea	eax, [ecx+3]
	cmp	[@@L1], 8
	jne	@@1c
	sub	esp, 400h
	mov	edx, [esi+18h]
@@1a:	imul	eax, ecx, 10101h
	cmp	[@@L0], 2
	jae	@@1b
	mov	eax, [edx+ecx*4]
	and	eax, 0FFFFFFh
@@1b:	mov	[esp+ecx*4], eax
	inc	cl
	jne	@@1a
	mov	ch, 4
	mov	edx, esp
	call	_FileWrite, [@@D], edx, ecx
	lea	esp, [@@L2]
	xor	eax, eax
	inc	eax
	cmp	[@@L0], 2
	jae	@@1c
	call	@@Copy8, edi, esi
	jmp	@@1d

@@1c:	call	@@Copy32, edi, esi, eax
@@1d:	lea	eax, [ebx*8+ebx+18h]
	lea	esi, [edi+ebx]
	shr	eax, 3
	call	_wip_pack, esi, eax, edi, ebx
	xchg	ebx, eax
	call	_FileWrite, [@@D], esi, ebx
	call	_MemFree, edi
	pop	edi
	mov	[edi-4], ebx
@@1f:	dec	[@@N]
	jne	@@1
@@9:	mov	esi, [@@S]
	sub	edi, esi
	call	_FileSeek, [@@D], 0, 0
	call	_FileWrite, [@@D], esi, edi
	call	_FileClose, [@@D]
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h

@@Copy32 PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@L0 = dword ptr [ebp+1Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@S]
	mov	edi, [@@D]
	mov	edx, [esi]
	mov	ebx, [esi+4]
	mov	ecx, edx
	neg	ecx
	mov	eax, [esi+0Ch]
	mov	esi, [esi+8]
	lea	eax, [eax+ecx*4]
	cmp	[@@L0], 3
	je	@@1
	add	esi, 3
@@1:	push	ebx
	push	esi
@@2:	mov	ecx, edx
@@3:	movsb
	add	esi, 3
	dec	ecx
	jne	@@3
	add	esi, eax
	dec	ebx
	jne	@@2
	pop	esi
	pop	ebx
	inc	esi
	dec	[@@L0]
	jne	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

@@Copy8 PROC
	push	ebx
	push	esi
	push	edi
	mov	esi, [esp+14h]
	mov	edi, [esp+10h]
	mov	edx, [esi]
	mov	ebx, [esi+4]
	mov	eax, [esi+0Ch]
	sub	eax, edx
	mov	esi, [esi+8]
@@1:	mov	ecx, edx
	rep	movsb
	add	esi, eax
	dec	ebx
	jne	@@1
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

ENDP	; @@WIP

ENDP

_wip_pack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@M = dword ptr [ebp-4]
@@D = dword ptr [ebp-8]
@@L0 = dword ptr [ebp-0Ch]
@@L1 = dword ptr [ebp-10h]

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
	rep	stosd
	push	edi
	push	-80h
	mov	edi, [@@DB]
	xor	ebx, ebx
	push	edi	; @@L1
@@1:	cmp	[@@SC], 0
	je	@@9
	stc
	call	@@3
	mov	al, [esi]
	stosb
	call	@@next
@@1a:	call	@@match
@@1b:	cmp	eax, 2
	jb	@@1
	lea	esp, [@@L1]
	push	ecx
	push	eax
	xchg	ebx, eax
	call	@@next
	xor	eax, eax
	cmp	ebx, 11h
	jae	@@2a
	call	@@match
	mov	ebx, [@@L1-8]
@@2a:	push	ecx
	push	eax
	dec	ebx
@@2b:	call	@@next
	dec	ebx
	jne	@@2b
	mov	ebx, [@@L1-10h]
	cmp	[@@L1-8], 3
	jae	@@2f
	cmp	ebx, 3
	jae	@@2g
@@2f:	call	@@match
	push	ecx
	push	eax
	cmp	[@@L1-10h], 4
	jae	@@2d
@@2c:	mov	ebx, [@@L1-8]
	mov	ecx, [@@L1-4]
	; ecx - address, eax - count
	call	@@3a
	sub	ecx, [@@SB]
	shl	ecx, 1
	lea	eax, [ecx*8+ebx-2+10h]
	xchg	al, ah
	stosw
	pop	eax
	pop	ecx
	jmp	@@1b

@@9:	call	@@3a
	cmp	byte ptr [@@L0], 80h
	jne	@@9
	xor	eax, eax
	stosw
	call	_MemFree, [@@M]
	mov	esi, [@@SC]
	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@2d:	mov	edx, [@@L1-8]
	mov	ebx, [@@L1-10h]
	add	edx, eax
	dec	edx
	cmp	ebx, edx
	jb	@@2c
@@2g:	stc
	call	@@3
	mov	eax, esi
	sub	eax, [@@L1-8]
	mov	al, [eax]
	stosb
	mov	ecx, [@@L1-0Ch]
	call	@@3a
	sub	ecx, [@@SB]
	shl	ecx, 1
	lea	eax, [ecx*8+ebx-2+10h]
	xchg	al, ah
	stosw
	inc	ebx
	sub	ebx, [@@L1-8]
@@2e:	call	@@next
	dec	ebx
	jne	@@2e
	jmp	@@1a

@@3a:	clc
@@3:	mov	eax, [@@L0]
	rcr	al, 1
	jc	@@3c
	test	al, 3Fh
	jne	@@3b
	mov	[@@L1], edi
	inc	edi
@@3b:	mov	[@@L0], eax
	ret
@@3c:	mov	edx, [@@L1]
	mov	[edx], al
	mov	al, 80h
	jmp	@@3b

@@next:	dec	[@@SC]
	je	@@3d
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
@@3d:	inc	esi
	ret

@@match PROC
	mov	ecx, [ebp+20h]	; @@SC
	push	edi
	push	0	; D
	push	1	; C = min-1
	push	11h
	pop	ebx
	cmp	ecx, 2
	jb	@@8
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
	lea	eax, [edi+1]
	sub	eax, [ebp+1Ch]	; @@SB
	shl	eax, 14h
	je	@@6
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
@@8:	pop	eax
	pop	ecx
@@9:	add	ecx, esi
	pop	edi
	ret
ENDP

ENDP

