
	dw 0
_arc_repipack PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0

	enter	@@stk+110h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	pop	edx
	pop	edi
	pop	ebx
	mov	ecx, edi
	or	edi, ebx
	sub	eax, 'ipeR'
	sub	edx, 'kcaP'
	shr	edi, 8
	or	eax, edx
	or	eax, edi
	jne	@@9a
	mov	edi, offset _repipack_table
@@2a:	movzx	eax, byte ptr [edi]
	cmp	eax, ecx
	je	@@2b
	lea	edi, [edi+10h]
	jb	@@2a
	jmp	@@9a

@@2b:	mov	[@@L0], ebx
	test	ebx, ebx
	je	@@2c
	mov	esi, esp
	call	_FileRead, [@@S], esi, ebx
	jc	@@9a
@@2c:	lea	eax, [@@N]
	call	_FileRead, [@@S], eax, 4
	jc	@@9a
	mov	eax, [@@N]
	movzx	ebx, word ptr [edi+2]
	imul	ebx, eax
	dec	eax
	shr	eax, 14h
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	push	ebx
	add	ebx, [@@L0]
	add	ebx, 14h
	call	_ArcParamNum, -1
	db 'repipack', 0
	cmp	eax, 7Fh
	jbe	@@2g
@@2e:	movzx	ecx, word ptr [edi+2]
	mov	edx, [edi+0Ch]
	call	@@4
	cmp	eax, ebx
	je	@@2f
	mov	al, [edi]
	add	edi, 10h
	cmp	al, [edi]
	je	@@2e
	jmp	@@9

@@2g:	xchg	ecx, eax
@@2h:	dec	ecx
	js	@@2f
	mov	al, [edi]
	add	edi, 10h
	cmp	al, [edi]
	je	@@2h
	jmp	@@9

@@2f:	mov	ebx, [@@N]
	call	_ArcCount, ebx
@@2d:	movzx	ecx, word ptr [edi+2]
	mov	edx, [edi+0Ch]
	call	@@3
	dec	ebx
	jne	@@2d
	pop	ebx

	mov	ecx, [@@L0]
	mov	esi, esp
	push	ecx
	push	esi
	mov	edx, [edi+8]
	call	@@3
	call	_ArcDbgData
	lea	esp, [ebp-@@stk]

	mov	esi, [@@M]
	call	_ArcDbgData, esi, ebx
	movzx	eax, byte ptr [edi]
	jmp	dword ptr [@@T+eax*4-4]

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@T	dd offset _mod_repipack2
	dd offset _mod_repipack2
	dd offset _mod_repipack2
	dd offset _mod_repipack4
	dd offset _mod_repipack5

@@4:	push	ebx
	push	esi
	sub	ecx, 0Ch
	mov	ebx, [edi+4]
	shr	ecx, 2
	cmp	byte ptr [edi], 2
	adc	ecx, 0
	cmp	byte ptr [edi+1], 0
	jne	@@4d
	jmp	@@4b
@@4a:	rol	eax, 10h
	xor	eax, ebx
	add	edx, eax
@@4b:	mov	eax, [esi]
	add	esi, 4
	xor	eax, edx
	dec	ecx
	jne	@@4a
	pop	esi
	pop	ebx
	ret

@@4c:	add	edx, eax
	add	edx, ebx
@@4d:	mov	eax, [esi]
	add	esi, 4
	xor	eax, edx
	dec	ecx
	jne	@@4c
	cmp	byte ptr [edi], 5
	jne	@@4e
	push	3
	pop	ecx
	push	eax
@@4f:	add	edx, eax
	add	edx, ebx
	mov	eax, [esi]
	add	esi, 4
	xor	eax, edx
	dec	ecx
	jne	@@4f
	test	eax, eax
	pop	eax
	je	@@4e
	xor	eax, eax
@@4e:	pop	esi
	pop	ebx
	ret

@@3:	push	ebx
	mov	ebx, [edi+4]
	shr	ecx, 2
	je	@@3b
	cmp	byte ptr [edi+1], 0
	jne	@@3c
@@3a:	mov	eax, [esi]
	xor	eax, edx
	mov	[esi], eax
	add	esi, 4
	rol	eax, 10h
	xor	eax, ebx
	add	edx, eax
	dec	ecx
	jne	@@3a
@@3b:	pop	ebx
	ret

@@3c:	mov	eax, [esi]
	xor	eax, edx
	mov	[esi], eax
	add	esi, 4
	add	edx, ebx
	add	edx, eax
	dec	ecx
	jne	@@3c
	pop	ebx
	ret
ENDP

_repipack_hex PROC
	mov	ecx, [esp+4]
@@1:	mov	al, [edx]
	shr	al, 4
	add	al, -10
	sbb	ah, ah
	add	al, 3Ah
	and	ah, 27h-20h
	add	al, ah
	stosb
	mov	al, [edx]
	inc	edx
	and	al, 0Fh
	add	al, -10
	sbb	ah, ah
	add	al, 3Ah
	and	ah, 27h-20h
	add	al, ah
	stosb
	dec	ecx
	jne	@@1
	ret	4
ENDP

_repipack_list PROC

@@B = dword ptr [ebp+4]

@@stk = 0
@M0 @@S
@M0 @@M
@M0 @@L0
@M0 @@L1

@@C0 = 200h
@@C1 = 1000h

	push	ebx
	push	esi
	push	edi
	push	0
	call	_ArcParam
	db 'list', 0
	jnc	@@4a
	push	FILE_INPUT
	call	@@4c
	db 'repipack.txt', 0
@@4c:	call	_LocalFileCreate
	jmp	@@4b

@@4a:	call	_FileCreate, eax, FILE_INPUT
@@4b:	jc	@@9a
	enter	@@stk+@@C0, 0
	mov	[@@S], eax
	call	_BlkCreate, 10000h
	jc	@@8
	mov	[@@M], eax
	mov	esi, @@C1*4+8
	call	_BlkAlloc, eax, esi
	jc	@@9
	xchg	edi, eax
	mov	eax, [@@M]
	mov	[@@B], edi
	stosd
	lea	eax, [esi-8]
	shr	eax, 2
	mov	ecx, eax
	dec	eax
	stosd
	xor	eax, eax
	rep	stosd

	mov	ebx, @@C0
	mov	[@@L1], esp
	mov	[@@L0], ebx
	sub	esp, ebx
@@1:	mov	edi, esp
	mov	esi, [@@L1]
@@1a:	call	@@3
	cmp	edi, esi
	je	$+3
	stosb
	cmp	al, 0Ah
	je	@@1b
	cmp	al, 0Dh
	je	@@1b
	test	al, al
	jne	@@1a
@@1b:	cmp	edi, esi
	je	@@1
	sub	edi, esp
	dec	edi
	je	@@1
	lea	eax, [edi+19h]
	call	_BlkAlloc, [@@M], eax
	jc	@@8
	xchg	esi, eax
	mov	eax, 67452301h
	mov	edx, 0EFCDAB89h
	mov	[esi], eax
	mov	[esi+4], edx
	not	eax
	not	edx
	mov	[esi+8], eax
	mov	[esi+0Ch], edx
	and	dword ptr [esi+10h], 0
	mov	edx, esp
	call	_repipack_md5, edx, edi, esi
;	mov	[esi+10h], edi

	mov	eax, [esi]
	mov	edx, [@@B]
	and	eax, [edx+4]
	lea	edx, [edx+8+eax*4]
	mov	eax, [edx]
	mov	[edx], esi
	mov	[esi+14h], eax

	mov	ecx, edi
	lea	edi, [esi+18h]
	mov	esi, esp
	rep	movsb
	xchg	eax, ecx
	stosb
	jmp	@@1

@@9:	call	_BlkDestroy, [@@M]
@@8:	call	_FileClose, [@@S]
	leave
@@9a:	pop	eax
	cmp	eax, 1
	pop	edi
	pop	esi
	pop	ebx
	ret

@@3a:	cmp	ebx, @@C0
	jne	@@3b
	call	_FileRead, [@@S], esi, ebx
	xor	ebx, ebx
	mov	[@@L0], eax
@@3:	cmp	ebx, [@@L0]
	jae	@@3a
	movzx	eax, byte ptr [esi+ebx]
	inc	ebx
	ret
@@3b:	ja	@@8
	or	ebx, -1
	mov	al, 0Ah
	ret
ENDP

_repipack_find PROC
	push	esi
	push	edi
	mov	eax, [esp+0Ch]
	mov	edx, [esp+10h]
	test	eax, eax
	je	@@9
	mov	ecx, [edx]
	and	ecx, [eax+4]
	lea	eax, [eax+8+ecx*4-14h]
@@1:	mov	eax, [eax+14h]
	test	eax, eax
	je	@@9
	push	4
	pop	ecx
	mov	esi, eax
	mov	edi, edx
	repe	cmpsd
	jne	@@1
@@9:	cmp	eax, 1
	pop	edi
	pop	esi
	ret	8
ENDP

_repipack_close PROC
	mov	eax, [esp+4]
	test	eax, eax
	je	@@9
	call	_BlkDestroy, dword ptr [eax]
@@9:	ret	4
ENDP
