
; 00 width
; 04 height
; 08 image_data
; 0C line_width
; 10 x
; 14 y
; 18 pal_data
; 1C comment_size
; 20 comment

_TgaCommentSize PROC

@@S = dword ptr [ebp+0Ch]

	pop	edx
	pop	eax
	push	edx
	push	ebx
	enter	14h, 0
	call	_FileCreate, eax, FILE_INPUT
	jc	@@9
	mov	edx, esp
	push	eax
	call	_FileRead, eax, edx, 12h
	sbb	ebx, ebx
	call	_FileClose
	inc	ebx
	je	@@9a
	pop	eax
	movzx	ebx, al
	movzx	ecx, ah		; 0,1
	shr	eax, 10h	; (1,2,3) + 8
	dec	ecx
	and	al, NOT 8
	dec	ecx
	dec	eax
	movzx	eax, al
	sub	eax, 3
	and	eax, ecx
	js	@@9a
@@9:	xor	ebx, ebx
@@9a:	xchg	eax, ebx
	leave
	pop	ebx
	ret
ENDP

_Bm32ReadFile:
	pop	eax
	push	3
	push	eax

_BmReadFile PROC

@@F = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]

@@SE = dword ptr [ebp-4]
@@SB = dword ptr [ebp-8]
@@L0 = dword ptr [ebp-0Ch]
@@L1 = dword ptr [ebp-10h]
@@L2 = dword ptr [ebp-14h]
@@L3 = dword ptr [ebp-18h]
@@M = dword ptr [ebp-1Ch]

	push	ebx
	push	esi
	push	edi
	enter	18h, 0
	push	0
	call	_FileCreate, [@@S], FILE_INPUT
	jc	@@9a
	mov	[@@S], eax
	mov	esi, esp
	sub	esp, 400h
	mov	[@@SE], esi
	mov	[@@SB], esp
	call	@@3
	dec	esi
	mov	ecx, [@@SE]
	add	eax, 12h
	sub	ecx, esi
	cmp	word ptr [esi], 'MB'
	je	@@21
	cmp	ecx, eax
	jb	@@9
	mov	eax, [esi]
	mov	[@@L0], eax
	shr	eax, 8
	and	ah, NOT 8

	movzx	ecx, byte ptr [esi+10h]
	cmp	ecx, 8
	mov	cl, 1
	je	$+4
	mov	cl, 4
	mov	[@@L1], ecx
	je	@@2b
	movzx	edx, word ptr [esi+10h]
	sub	edx, 18h
	mov	cl, dl
	mov	byte ptr [@@L0], dl
	not	cl
	and	dh, cl
	and	dl, cl
	sub	ah, 2
	or	eax, [esi+4]
	jmp	@@2d

@@2b:	movzx	eax, ax
	movzx	ebx, byte ptr [esi+7]
	movzx	ecx, word ptr [esi+3]
	movzx	edx, word ptr [esi+5]
	sub	ah, 3
	je	@@2c
	sub	ebx, 18h
	add	edx, ecx
	mov	byte ptr [@@L0], bl
	and	ebx, NOT 8
	rol	al, 1
	dec	edx
	add	ah, al
	mov	cl, ch
	and	al, NOT 2
	shr	edx, 8
@@2c:	or	eax, ecx
	or	eax, edx
	movzx	edx, word ptr [esi+10h]
	or	eax, ebx
	sub	edx, 8
@@2d:	and	dh, NOT 20h
	or	eax, edx
	jne	@@9
	movzx	eax, word ptr [esi+0Ch]
	movzx	ebx, word ptr [esi+0Eh]
	call	@@22
	xor	edx, edx
	test	byte ptr [esi+11h], 20h
	jne	@@2e
	lea	edx, [ebx-1]
	imul	edx, ecx
	neg	ecx
@@2e:	add	edx, [@@L2]
	add	edx, edi
	imul	ebx, eax
	mov	[edi+8], edx
	mov	[edi+0Ch], ecx
	movsx	eax, word ptr [esi+8]
	movsx	edx, word ptr [esi+0Ah]
	mov	[edi+10h], eax
	mov	[edi+14h], edx
	movzx	ecx, byte ptr [esi]
	movzx	eax, word ptr [esi+3]
	movzx	edx, word ptr [esi+5]
	mov	[edi+1Ch], ecx
	push	edi
	add	edi, 20h
	add	esi, 12h
	rep	movsb
	pop	edi
	xchg	ecx, eax
	add	edi, 120h
	cmp	[@@L1], 4
	je	@@4d
	test	edx, edx
	je	@@4b
	push	edx
	add	dl, cl
	xor	eax, eax
	rep	stosd
	pop	ecx
@@4a:	call	@@5
	dec	ecx
	jne	@@4a
	sub	cl, dl
	xor	eax, eax
	rep	stosd
	jmp	@@4d

@@4b:	call	@@26
@@4d:
	mov	al, byte ptr [@@L0+2]
	mov	ecx, ebx
	test	al, 8
	je	@@1c
@@1:	test	ebx, ebx
	je	@@9b
	call	@@3
	mov	ecx, eax
	and	ecx, 7Fh
	inc	ecx
	sub	ebx, ecx
	jae	$+6
	add	ecx, ebx
@@1c:	xor	ebx, ebx
	cmp	[@@L1], 4
	jne	@@1d
	test	al, al
	js	@@1b
@@1a:	call	@@5
	dec	ecx
	jne	@@1a
	jmp	@@1

@@1b:	call	@@5
	dec	ecx
	mov	eax, [edi-4]
	rep	stosd
	jmp	@@1

@@1d:	test	al, al
	js	@@1f
@@1e:	call	@@3
	stosb
	dec	ecx
	jne	@@1e
	jmp	@@1

@@1f:	call	@@3
	rep	stosb
	jmp	@@1

@@9:	call	_MemFree, [@@M]
	and	[@@M], 0
@@9b:	call	_FileClose, [@@S]
	mov	esi, [@@M]
	mov	ecx, [@@F]
	test	esi, esi
	je	@@9a
	mov	edx, [esi+18h]
	dec	ecx
	js	@@9a
	test	edx, edx
	jne	@@7a
	dec	ecx
	js	@@7d
	jne	@@9a
	call	@@24
	jmp	@@7c

@@7d:	call	@@27
	jmp	@@7c

@@7a:	dec	ecx
	js	@@9a
	jne	@@7b
	call	_Bm8Grayscale, esi
	jmp	@@9a

@@7b:	call	@@25
@@7c:	call	_MemFree, esi

@@9a:	mov	eax, [@@M]
	cmp	eax, 1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@3a:	xchg	eax, esi
	mov	esi, [@@SB]
	sub	eax, esi
	cmp	eax, 400h
	jne	@@9
	push	ecx
	call	_FileRead, [@@S], esi, eax
	pop	ecx
	test	eax, eax
	je	@@9
	add	eax, esi
	mov	[@@SE], eax
@@3:	cmp	esi, [@@SE]
	je	@@3a
	movzx	eax, byte ptr [esi]
	inc	esi
	ret

@@5:	call	@@3
	stosb
	call	@@3
	stosb
	call	@@3
	stosb
	mov	al, 0FFh
	cmp	byte ptr [@@L0], 0
	je	@@5a
	call	@@3
@@5a:	stosb
	ret

@@22:	mov	ecx, [@@L1]
	push	120h
	pop	edx
	cmp	ecx, 1
	jne	$+4
	mov	dh, 4+1
	mov	edi, eax
	imul	eax, ebx
	mov	[@@L2], edx
	test	eax, eax
	je	@@9
	imul	ecx, eax
	shr	eax, 1Ch
	jne	@@9
	add	ecx, edx
	call	_MemAlloc, ecx
	jc	@@9
	mov	[@@M], eax
	xchg	edi, eax
	mov	ecx, [@@L1]
	mov	[edi], eax
	xor	edx, edx
	cmp	ecx, 1
	jne	@@22a
	lea	edx, [edi+120h]
@@22a:	imul	ecx, eax
	mov	[edi+4], ebx
	mov	[edi+18h], edx
	and	dword ptr [edi+1Ch], 0
	ret

@@21:	cmp	ecx, 36h
	jb	@@9
	movzx	eax, word ptr [esi+1Ah]
	mov	edx, [esi+0Ah]
	mov	ecx, [esi+0Eh]
	dec	eax
	sub	ecx, 28h
	or	eax, [esi+1Eh]
	sub	edx, 36h
	or	eax, ecx
	jne	@@9
	mov	eax, [esi+1Ch]
	ror	eax, 3
	mov	[@@L0], eax
	mov	ecx, eax
	dec	eax
	je	$+4
	mov	cl, 4
	mov	[@@L1], ecx
	je	@@21a
	dec	eax
	dec	eax
	shr	eax, 1
	jmp	@@21b
@@21a:	sub	dh, 4
@@21b:	or	eax, edx
	jne	@@9
	mov	eax, [esi+12h]
	mov	ebx, [esi+16h]
	call	@@22
	lea	edx, [ebx-1]
	imul	edx, ecx
	neg	ecx
	add	edx, [@@L2]
	add	edx, edi
	mov	[@@L2], eax
	xor	eax, eax
	mov	[edi+8], edx
	mov	[edi+0Ch], ecx
	mov	[edi+10h], eax
	mov	[edi+14h], eax
	add	edi, 120h
	add	esi, 36h
	cmp	[@@L1], 4
	je	@@21d
	xor	ecx, ecx
@@21c:	call	@@5
	mov	byte ptr [edi-1], 0FFh
	inc	cl
	jne	@@21c
@@21d:	mov	eax, [@@L0]
	sub	eax, 3
	jb	@@21i
	mov	[@@L0], eax
	dec	eax
	and	eax, 3
	mov	[@@L3], eax
@@21e:	mov	ecx, [@@L2]
@@21f:	call	@@5
	dec	ecx
	jne	@@21f
	mov	ecx, [@@L2]
	and	ecx, [@@L3]
	je	@@21h
@@21g:	call	@@3
	dec	ecx
	jne	@@21g
@@21h:	dec	ebx
	jne	@@21e
	jmp	@@9b

@@21i:	mov	ecx, [@@L2]
@@21j:	call	@@3
	stosb
	dec	ecx
	jne	@@21j
	mov	ecx, [@@L2]
	neg	ecx
	and	ecx, 3
	je	@@21l
@@21k:	call	@@3
	dec	ecx
	jne	@@21k
@@21l:	dec	ebx
	jne	@@21i
	jmp	@@9b

@@26:	mov	eax, 0FF000000h
@@26a:	stosd
	add	eax, 10101h
	jnc	@@26a
	ret

@@23:	xor	byte ptr [@@L1], 5
	mov	eax, [esi]
	mov	ebx, [esi+4]
	call	@@22
	xor	edx, edx
	cmp	dword ptr [esi+0Ch], 0
	jns	@@23a
	lea	edx, [ebx-1]
	imul	edx, ecx
	neg	ecx
@@23a:	add	edx, [@@L2]
	add	edx, edi
	imul	ebx, eax
	mov	[edi+8], edx
	mov	[edi+0Ch], ecx
	mov	eax, [esi+10h]
	mov	edx, [esi+14h]
	mov	[edi+10h], eax
	mov	[edi+14h], edx
	add	edi, 1Ch
	mov	edx, [esi+18h]
	add	esi, 1Ch
	push	41h
	pop	ecx
	rep	movsd
	ret

@@24:	push	esi
	call	@@23
	call	@@26
@@24a:	movzx	eax, byte ptr [esi]
	movzx	edx, byte ptr [esi+1]
	movzx	ecx, byte ptr [esi+2]
	imul	eax, 132h
	imul	edx, 259h
	imul	ecx, 75h
	add	eax, edx
	add	esi, 4
	add	eax, ecx
	shr	eax, 0Ah
	stosb
	dec	ebx
	jne	@@24a
	pop	esi
	ret

@@25:	push	esi
	call	@@23
	add	esi, 400h
@@25a:	movzx	eax, byte ptr [esi]
	inc	esi
	mov	eax, [edx+eax*4]
	stosd
	dec	ebx
	jne	@@25a
	pop	esi
	ret

@@27:	push	esi
	call	@@23
	xor	eax, eax
	push	ebx
	push	eax
	enter	400h, 0
	mov	ebx, edi
	mov	ecx, 100h
	rep	stosd
	mov	ch, 1
	dec	eax
	push	edi
	lea	edi, [esp+4]
	rep	stosd
	pop	edi
@@27a:	lodsd
	imul	edx, eax, 004C11DB7h
	shr	edx, 17h
	movsx	ecx, word ptr [esp+edx*2]
	inc	edx
	test	ecx, ecx
	js	@@27c
@@27b:	cmp	[ebx+ecx*4], eax
	je	@@27d
	and	edx, 1FFh
	movsx	ecx, word ptr [esp+edx*2]
	inc	edx
	test	ecx, ecx
	jns	@@27b
@@27c:	mov	ecx, [ebp+4]
	dec	edx
	test	ch, ch
	jne	@@27e
	mov	[esp+edx*2], cx
	mov	[ebx+ecx*4], eax
	inc	ecx
	mov	[ebp+4], ecx
@@27d:	mov	[edi], cl
	inc	edi
	dec	dword ptr [ebp+8]
	jne	@@27a
@@27e:	leave
	pop	ecx
	pop	eax
	pop	esi
	test	eax, eax
	je	@@27f
	xor	eax, eax
	xchg	[@@M], eax
	call	_MemFree, eax
@@27f:	ret
ENDP

_Bm8Grayscale PROC

@@S = dword ptr [ebp+14h]

@@L0 = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	enter	104h, 0

	; 0.299*R+0.587*G+0.114*B

	mov	esi, [@@S]
	mov	ebx, 0FF000000h
	mov	esi, [esi+18h]
	mov	[@@L0], ebx
	mov	edi, esp

@@1:	movzx	eax, byte ptr [esi]
	movzx	edx, byte ptr [esi+1]
	movzx	ecx, byte ptr [esi+2]
	imul	eax, 132h
	imul	edx, 259h
	imul	ecx, 75h
	add	eax, edx
	mov	[esi], ebx
	add	eax, ecx
	add	esi, 4
	shr	eax, 0Ah
	stosb
	sub	eax, ebx
	or	[@@L0], eax
	add	ebx, 10101h
	jnc	@@1
	cmp	byte ptr [@@L0], 0
	je	@@9

	mov	edi, [@@S]
	mov	edx, [edi]
	mov	ecx, [edi+0Ch]
	mov	ebx, [edi+4]
	sub	ecx, edx
	mov	edi, [edi+8]
	mov	[@@S], ecx
	xor	eax, eax
@@2:	mov	ecx, edx
@@3:	mov	al, [edi]
	mov	al, [esp+eax]
	stosb
	dec	ecx
	jne	@@3
	add	edi, [@@S]
	dec	ebx
	jne	@@2
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP

_BmWriteTga PROC

@@S = dword ptr [ebp+14h]
@@D = dword ptr [ebp+18h]

@@M = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@S]
	mov	ebx, [esi+4]
	mov	eax, [esi]
	imul	eax, ebx
	cmp	dword ptr [esi+18h], 0
	jne	@@2
	shl	eax, 2
	add	eax, 12h+1Ah
	call	_MemAlloc, eax
	jc	@@9a
	push	eax
	xchg	edi, eax

	mov	edx, [esi]
	mov	ecx, [esi+14h]
	mov	eax, ebx
	shl	ecx, 10h
	shl	eax, 10h
	mov	cx, [esi+10h]
	add	eax, edx

	mov	dword ptr [edi], 20000h
	and	dword ptr [edi+4], 0
	mov	[edi+8], ecx
	mov	[edi+0Ch], eax
	mov	word ptr [edi+10h], 2820h

	call	@@3

	mov	ecx, edx
	mov	eax, [esi+0Ch]
	neg	ecx
	mov	esi, [esi+8]
	lea	eax, [eax+ecx*4]
@@1a:	mov	ecx, edx
	rep	movsd
	add	esi, eax
	dec	ebx
	jne	@@1a

@@7:	mov	edi, [@@M]
	call	_tga_optimize, edi
	xchg	ebx, eax
	call	_FileCreate, [@@D], FILE_OUTPUT
	jc	@@9
	xchg	esi, eax
	call	_FileWrite, esi, edi, ebx
	call	_FileClose, esi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@2:	add	eax, 412h+1Ah
	call	_MemAlloc, eax
	jc	@@9a
	push	eax
	xchg	edi, eax

	mov	edx, [esi]
	mov	ecx, [esi+14h]
	mov	eax, ebx
	shl	ecx, 10h
	shl	eax, 10h
	mov	cx, [esi+10h]
	add	eax, edx

	mov	dword ptr [edi], 10100h
	mov	dword ptr [edi+4], 20010000h
	mov	[edi+8], ecx
	mov	[edi+0Ch], eax
	mov	word ptr [edi+10h], 2008h
	call	@@3

	mov	ecx, 100h
	push	esi
	mov	esi, [esi+18h]
	rep	movsd
	pop	esi

	mov	ecx, edx
	mov	eax, [esi+0Ch]
	neg	ecx
	mov	esi, [esi+8]
	add	eax, ecx
@@2a:	mov	ecx, edx
	rep	movsb
	add	esi, eax
	dec	ebx
	jne	@@2a
	jmp	@@7

@@3:	push	esi
	mov	ecx, [esi+1Ch]
	mov	[edi], cl
	add	esi, 20h
	add	edi, 12h
	rep	movsb
	pop	esi
	ret
ENDP
