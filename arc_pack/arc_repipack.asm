
_arc_repipack PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@F
@M0 @@L0, 0Ch
@M0 @@L2

	enter	@@stk, 0
	push	5
	pop	eax
	mov	ecx, [@@PC]
	mov	esi, [@@PB]
	dec	ecx
	je	@@2d
	dec	ecx
	jne	@@2i
	mov	edi, [esi]
	add	esi, 4
	movzx	eax, word ptr [edi]
	sub	al, 31h
	cmp	eax, 5
	jae	@@2i
	inc	eax
	cmp	al, 2
	adc	ah, ah
	movzx	ecx, word ptr [edi+2]
	test	ecx, ecx
	je	@@2d
	cmp	al, 2
	jne	@@2i
	or	ecx, 20h
	movzx	edx, word ptr [edi+4]
	sub	ecx, 'a'
	or	ecx, edx
	jne	@@2i
	mov	ah, 1
@@2d:	xor	ebx, ebx
	mov	esi, [esi]
	mov	[@@F], eax
	call	_string_num, esi
	jc	@@2c
	cmp	eax, 7Fh
	ja	@@2c
	mov	edi, offset _repipack_table
	mov	ecx, [@@F]
@@2f:	cmp	[edi], cl
	lea	edi, [edi+10h]
	jne	@@2f
@@2g:	dec	eax
	js	@@2h
	cmp	[edi], cl
	lea	edi, [edi+10h]
	je	@@2g
@@2i:	jmp	@@9a

@@2h:	lea	esi, [edi-0Ch]
	lea	edi, [@@L0]
	movsd
	movsd
	movsd
	jmp	@@2e

@@2c:	call	_repipack_int32
	jc	@@2i
	mov	[@@L0+ebx*4], eax
	inc	ebx
	lodsw
	cmp	ebx, 3
	sbb	edx, edx
	and	edx, '-'
	cmp	ax, dx
	jne	@@2i
	test	edx, edx
	jne	@@2c
@@2e:
	mov	eax, [@@FL]
	mov	ebx, [eax]
	imul	eax, ebx, 30h
	shl	ebx, 5
	add	ebx, 14h
	cmp	byte ptr [@@F], 4
	jae	$+4
	add	ebx, eax

	mov	esi, [@@PB]
	call	_unicode_name, dword ptr [esi-4]	; outFileName
	xchg	esi, eax
	push	0
	lea	eax, [ecx+ecx]
	and	eax, -4
	sub	esp, eax
	call	_unicode_to_ansi, 932, esi, ecx, esp
	add	ebx, eax
	mov	[@@P], ebx
	xchg	ebx, eax
	call	_MemAlloc, eax
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	mov	eax, 'ipeR'
	stosd
	mov	eax, 'kcaP'
	stosd
	movzx	eax, byte ptr [@@F]
	stosd
	xchg	eax, ebx
	stosd
	xchg	eax, ecx
	mov	esi, esp
	push	ecx
	push	edi
	rep	movsb
	movzx	eax, byte ptr [@@F+1]
	call	_repipack_encode, eax, [@@L0], [@@L0+4]
	mov	eax, [@@FL]
	mov	eax, [eax]
	stosd
	lea	esp, [ebp-@@stk]
	call	_FileWrite, [@@D], [@@M], [@@P]

	mov	esi, [@@FL]
	mov	eax, [@@F]
	add	esi, 4
	cmp	al, 4
	jb	_mod_repipack2
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	mov	ebx, [esi+2Ch]	; FileSizeLow
	mov	[edi+18h], ebx
	call	_repipack_dec_name, dword ptr [esi+4], edi
	jc	@@1b
	test	eax, eax
	jne	@@1a
	mov	[edi+18h], edx
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
	mov	[edi+14h], eax
	jmp	@@1e

@@1a:	cmp	byte ptr [@@F], 5
	je	@@1b
	mov	[edi+10h], edx
	cmp	eax, 2Eh
	je	@@1c
@@1b:	mov	eax, 67452301h
	mov	edx, 0EFCDAB89h
	mov	[edi], eax
	mov	[edi+4], edx
	not	eax
	not	edx
	mov	[edi+8], eax
	mov	[edi+0Ch], edx
	and	dword ptr [edi+10h], 0
	call	_sjis_lower, dword ptr [esi+4]
	call	_repipack_md5, dword ptr [esi+4], dword ptr [esi+8], edi

@@1c:	and	dword ptr [edi+14h], 0
	call	_repipack_ext_test
	lea	eax, [@@L2]
	call	_ArcLoadFile, eax, edx, 0, ecx, ebx
	jc	@@1h
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	test	ebx, ebx
	je	@@1d
	lea	eax, [edx+ecx]
	call	_lzss_pack, eax, ebx, edx, ecx
	mov	ecx, [esi+2Ch]
	mov	edx, [@@L2]
	cmp	eax, ecx
	jae	@@1d
	add	edx, ecx
	xchg	eax, ecx
@@1d:	mov	[edi+14h], ecx
	push	ecx
	push	edx
	test	ecx, ecx
	je	@@1g
	push	ecx
	push	edx
	cmp	byte ptr [@@F], 5
	je	@@1f
	call	@@4
	jmp	@@1g
@@1f:	call	@@5
@@1g:	call	_FileWrite, [@@D]
@@1h:	call	_MemFree, [@@L2]

@@1e:	mov	ecx, [@@P]
	mov	eax, [edi+14h]
	mov	[edi+10h], ecx
	and	dword ptr [edi+1Ch], 0
	add	[@@P], eax 

	call	_repipack_encode, 0, [@@L0], [@@L0+8], edi, 20h
	add	edi, 20h
	jmp	@@1

@@7:	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	mov	edx, [@@M]
	sub	edi, edx
	call	_FileWrite, ebx, edx, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

_repipack_int32 PROC
	xor	eax, eax
	lea	edx, [eax+1]
@@1:	lodsw
	sub	al, 30h
	cmp	eax, 0Ah
	jb	@@2
	or	al, 20h
	sub	al, 31h
	cmp	eax, 6
	jae	@@3
	add	al, 0Ah
@@2:	shl	edx, 4
	lea	edx, [edx+eax]
	jnc	@@1
	xchg	eax, edx
@@3:	cmc
	ret
ENDP

@@4 PROC

@@SB = dword ptr [ebp+14h]
@@SC = dword ptr [ebp+18h]

@@L0 = dword ptr [ebp-10h]

	push	ebx
	push	esi
	push	edi
	enter	4Ch, 0

	xor	eax, eax
	mov	esi, edi
	mov	edi, esp
	lea	ecx, [eax+3Ch/4]
	rep	stosd
	movsd
	movsd
	movsd
	movsd
	lodsd
	shl	eax, 3
	push	8020h
	mov	[@@L0-8], eax

	xor	esi, esi
	mov	edi, [@@SB]
	mov	ebx, [@@SC]
@@1:	cmp	esi, 40h
	jae	@@9
	inc	esi
	lea	edx, [@@L0]
	add	[@@L0-8], 8
	call	_md5_transform@8, edx, esp
	xor	ecx, ecx
@@3:	cmp	ecx, 10h
	je	@@1
	mov	al, byte ptr [@@L0+ecx]
	inc	ecx
	xor	[edi], al
	inc	edi
	dec	ebx
	jne	@@3
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

@@5 PROC

@@SB = dword ptr [ebp+14h]
@@SC = dword ptr [ebp+18h]

@@L0 = dword ptr [ebp-14h]
@@C = dword ptr [ebp-18h]
@@N = dword ptr [ebp-1Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	push	0
	mov	edx, 10325476h
	mov	eax, 98BADCFEh
	push	edx
	push	eax
	not	edx
	not	eax
	push	edx
	push	eax

	mov	ebx, [esi+4]
	mov	ecx, [esi+8]
	lea	edi, [ebx+ecx]
	mov	ecx, edi
	sub	ecx, ebx
	push	ecx
	push	ebx
	shr	ecx, 1
	je	@@2b
@@2a:	dec	edi
	mov	al, [ebx]
	mov	ah, [edi]
	mov	[edi], al
	mov	[ebx], ah
	inc	ebx
	dec	ecx
	jne	@@2a
@@2b:
	xor	esi, esi
	mov	edi, [@@SB]
	mov	ebx, [@@SC]
@@1:	cmp	esi, 40h
	jae	@@9
	mov	ecx, [@@C]
	mov	eax, esi
	xor	edx, edx
	inc	esi
	div	ecx
	lea	eax, [@@L0]
	sub	ecx, edx
	add	edx, [@@N]
	call	_repipack_md5, edx, ecx, eax
	xor	ecx, ecx
@@3:	cmp	ecx, 10h
	je	@@1
	mov	al, byte ptr [@@L0+ecx]
	inc	ecx
	xor	[edi], al
	inc	edi
	dec	ebx
	jne	@@3
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

ENDP

_mod_repipack2 PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@F
@M0 @@L0, 0Ch

	sub	al, 2
	shr	al, 7
	mov	byte ptr [@@F], al
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	call	_string_copy_ansi, edi, 44h, dword ptr [esi+4]
	add	edi, 44h
	xor	eax, eax
	stosd
	stosd
	stosd

	call	_repipack_ext_test
	movzx	eax, byte ptr [@@F]
	test	eax, eax
	je	@@1b
	mov	eax, offset @@3
@@1b:	call	_ArcPackFile, [@@D], edx, ecx, ebx, 0, offset _lzss_pack, eax
	movzx	ebx, byte ptr [@@F]
	mov	[edi-8+ebx*4], eax
	mov	ecx, [@@P]
	add	[@@P], eax
	mov	edx, [esi+2Ch]
	mov	[edi-10h+ebx*4], ecx
	mov	[edi-0Ch+ebx*4], edx
	lea	edx, [edi-50h]
	movzx	ecx, byte ptr [@@F+1]
	call	_repipack_encode, ecx, [@@L0], [@@L0+8], edx, 50h
	jmp	@@1

@@7:	mov	ebx, [@@D]
	call	_FileSeek, ebx, 0, 0
	mov	edx, [@@M]
	sub	edi, edx
	call	_FileWrite, ebx, edx, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	call	_repipack_encode, 1, [@@L0], [@@L0+8], esi, ebx
	ret
ENDP

_repipack_ext_test PROC
	mov	ecx, [esi+2Ch]
	mov	edx, [esi+8]
	lea	ebx, [ecx*8+ecx+7]
	mov	eax, [esi+4]
	shr	ebx, 3
	sub	edx, 4
	jb	@@2
	mov	eax, [eax+edx]
	or	eax, 20202000h
	cmp	eax, 'vgo.'
	je	@@1
	cmp	eax, 'fsr.'
	je	@@1
	cmp	eax, 'vaw.'
	je	@@1
	cmp	eax, 'ggo.'
	jne	@@2
@@1:	xor	ebx, ebx
@@2:	lea	edx, [esi+30h]
	ret
ENDP

_repipack_encode PROC
	push	ebx
	push	esi
	push	edi
	mov	ecx, [esp+20h]
	mov	esi, [esp+1Ch]
	shr	ecx, 2
	je	@@3b
	mov	edx, [esp+18h]
	mov	ebx, [esp+14h]
	cmp	dword ptr [esp+10h], 0
	jne	@@3c
@@3a:	mov	eax, [esi]
	mov	edi, eax
	xor	eax, edx
	rol	edi, 10h
	mov	[esi], eax
	add	esi, 4
	xor	edi, ebx
	add	edx, edi
	dec	ecx
	jne	@@3a
@@3b:	pop	edi
	pop	esi
	pop	ebx
	ret	14h

@@3c:	mov	eax, [esi]
	mov	edi, eax
	xor	eax, edx
	mov	[esi], eax
	add	esi, 4
	add	edx, ebx
	add	edx, edi
	dec	ecx
	jne	@@3c
	jmp	@@3b
ENDP

_repipack_dec_name PROC
	push	ebx
	push	esi
	push	edi
	xor	ebx, ebx
	mov	esi, [esp+10h]
	mov	edi, [esp+14h]
@@1:	call	@@3
	jc	@@9
	bswap	eax
	stosd
	inc	ebx
	cmp	ebx, 4
	jb	@@1
	xor	eax, eax
	lodsb
	cmp	eax, '-'
	jne	@@9
	cdq
	jmp	@@2d

@@2a:	cmp	edx, 1999999Ah
	lea	edx, [edx*4+edx]
	lea	edx, [edx*2+eax]
	jae	@@9
	cmp	edx, eax
	jb	@@9
@@2d:	lodsb
	sub	eax, 30h
@@2b:	cmp	eax, 0Ah
	jb	@@2a
	lea	eax, [eax+30h]
	jmp	$+3
@@9:	stc
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@3:	xor	eax, eax
	lea	edx, [eax+1]
@@3a:	lodsb
	sub	eax, 30h
	cmp	eax, 0Ah
	jb	@@3b
	or	eax, 20h
	sub	eax, 31h
	cmp	eax, 6
	jae	@@3c
	add	eax, 0Ah
@@3b:	shl	edx, 4
	lea	edx, [edx+eax]
	jnc	@@3a
	xchg	eax, edx
@@3c:	cmc
	ret
ENDP
