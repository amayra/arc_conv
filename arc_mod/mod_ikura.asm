
_mod_ikura PROC

@@stk = 0
@M0 @@L2
@M0 @@L1
@M0 @@M
@M0 @@W
@M0 @@L0

	push	0
	pop	ebx
	push	ebp
	mov	ebp, esp
	cmp	eax, 4
	jne	@@9a

	push	dword ptr [ebp+0Ch]
	call	@@2a
	db 'mrs',0, 'xmg', 0
@@2a:	call	_string_select
	jc	@@9
	push	eax	; @@L2

	call	_string_num, dword ptr [ebp+10h]
	jc	@@9b
	push	eax	; @@L1
	call	_BmReadFile, 1, dword ptr [ebp+14h]
	jc	@@9b
	push	eax	; @@M
	xchg	esi, eax

	mov	ebx, [esi]
	push	ebx	; @@W
	lea	eax, [ebx+3Fh]
	shr	eax, 6
	add	eax, ebx
	imul	ebx, [esi+4]
	imul	eax, [esi+4]
	push	eax	; @@L0
	lea	edi, [eax+30Ch]
	lea	eax, [edi+ebx]
	call	_MemAlloc, eax
	jc	@@9b
	xchg	esi, eax
	add	edi, esi

	push	esi
	push	edi
	mov	edi, esi
	mov	esi, [@@M]
	mov	eax, [@@L1]
	stosd
	mov	eax, [esi+4]
	shl	eax, 10h
	mov	ax, [esi]
	stosd
	xor	eax, eax
	stosd

	mov	esi, [esi+18h]
	mov	ecx, 100h
@@1a:	movsb
	lodsw
	xchg	al, ah
	stosw
	inc	esi
	dec	ecx
	jne	@@1a
	pop	edi
	pop	esi

	call	@@3, edi, [@@M]
	call	_MemFree, [@@M]
	mov	[@@M], esi

	mov	eax, 30Ch
	xchg	edi, eax
	lea	edx, [esi+edi]
	call	_ikura_pack, edx, [@@L0], eax, ebx, [@@W]
	lea	ebx, [eax+edi]

	cmp	[@@L2], 1
	je	@@1c
	mov	edx, esi
	xor	ecx, ecx
@@1b:	mov	al, [edx]
	xor	al, 0F3h
	add	al, cl
	add	cl, 7
	mov	[edx], al
	inc	edx
	dec	edi
	jne	@@1b
@@1c:
	call	_FileCreate, dword ptr [ebp+18h], FILE_OUTPUT
	jc	@@9
	xchg	edi, eax
	call	_FileWrite, edi, esi, ebx
@@9:	call	_FileClose, edi
@@9b:	call	_MemFree, esi
@@9a:	leave
	ret

@@3 PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@S]
	mov	edi, [@@D]
	mov	edx, [esi]
	mov	ebx, [esi+4]
	mov	eax, edx
	neg	eax
	add	eax, [esi+0Ch]
	mov	esi, [esi+8]
@@2:	mov	ecx, edx
	rep	movsb
	add	esi, eax
	dec	ebx
	jne	@@2
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

ENDP

_ikura_pack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@W = dword ptr [ebp+24h]

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
	push	ecx
	push	[@@W]
	mov	edi, [@@DB]
	cmp	[@@SC], ecx
	je	@@9
@@1:	inc	[@@L0]
	call	@@next
@@1a:	mov	ecx, [@@L1]
	cmp	ecx, 3
	jb	@@1
	call	@@match
	test	ecx, ecx
	je	@@1
	; ecx - address, eax - count
	not	ecx
	xchg	ebx, eax
	push	ecx
	call	@@2
	pop	edx
	call	@@3
@@1b:	call	@@next
	dec	ebx
	jne	@@1b
	jmp	@@1a

@@9b:	inc	esi
	call	@@2
@@9:	call	_MemFree, [@@M]
	mov	esi, [@@SC]
	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@next:	dec	[@@L1]
	jne	@@5a
	mov	eax, [@@W]
	mov	[@@L1], eax
@@5a:	dec	[@@SC]
	je	@@9b
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

@@4:	cmp	edx, 40h
	jb	@@4a
	stosb
	mov	eax, 13Fh
	sub	edx, eax
	jae	$+6
	add	eax, edx
	xor	edx, edx
	sub	eax, 40h
	stosb
	lea	ecx, [eax+40h]
	ret

@@4a:	add	eax, edx
	stosb
	xchg	ecx, eax
	xor	edx, edx
	ret

@@2:	mov	edx, [@@L0]
	test	edx, edx
	je	@@2b
	sub	esi, edx
@@2a:	xor	eax, eax
	call	@@4
	rep	movsb
	test	edx, edx
	jne	@@2a
	mov	[@@L0], edx
@@2b:	ret

@@3:	test	edx, edx
	je	@@3a
	cmp	ebx, 0Ah
	jae	@@3b
	lea	eax, [ebx-2+8]
	shl	eax, 4
	add	al, dh
	stosb
	xchg	eax, edx
	stosb
	ret

@@3a:	lea	edx, [ebx-1]
	mov	al, 40h
	call	@@4
	ret

@@3b:	mov	eax, 109h
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax

	mov	al, 80h
	add	al, dh
	stosb
	xchg	eax, edx
	stosb
	lea	eax, [ebx-0Ah]
	stosb
	ret

@@match PROC
	push	edi
	push	0	; D
	push	2	; C = min-1
	push	140h
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
@@3:	cmp	ecx, -@tblcnt
	jae	@@4
	pop	eax
	pop	ecx
@@9:	cmp	ecx, -1
	jne	@@9a
	cmp	eax, 3
	jae	@@9a
	xor	ecx, ecx
@@9a:	pop	edi
	ret
ENDP

ENDP