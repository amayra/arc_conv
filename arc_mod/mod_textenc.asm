
; 932 Japan
; 65001 CP_UTF8

extrn	WideCharToMultiByte:PROC
extrn	MultiByteToWideChar:PROC

_mod_textenc PROC

@@stk = 0
@M0 @@L0, 8
@M0 @@L2
@M0 @@L1, 8
@M0 @@M

	push	ebp
	mov	ebp, esp
	cmp	eax, 4
	jne	@@9a
	mov	esi, [ebp+0Ch]
	call	@@2
	mov	esi, [ebp+10h]
	push	edx
	push	eax
	cmp	word ptr [esi], 'x'
	sete	al
	lea	esi, [esi+eax*2]
	push	eax
	call	@@2
	cmp	eax, 3
	je	@@9a
	push	edx
	push	eax

	call	_FileCreate, dword ptr [ebp+14h], FILE_INPUT
	jc	@@9a
	xchg	esi, eax
	xor	edi, edi
	call	_FileGetSize, esi
	jc	@@4a
	test	eax, eax
	js	@@4a
	mov	ebx, eax
	cmp	eax, 1
	adc	eax, 0
	call	_MemAlloc, eax
	xchg	edi, eax
	jc	@@4a
	call	_FileRead, esi, edi, ebx
	xchg	ebx, eax
@@4a:	call	_FileClose, esi
	test	edi, edi
	je	@@9a
	push	edi	; @@M

	mov	eax, [@@L0]
	cmp	eax, 3
	jne	@@2d
	cmp	ebx, 2
	jb	@@2b
	movsx	ecx, word ptr [edi]
	dec	eax
	cmp	ecx, -2
	je	@@2c
	xchg	cl, ch
	dec	eax
	cmp	ecx, -2
	je	@@2c
	cmp	ebx, 3
	jb	@@2b
	shl	ecx, 8
	mov	cl, [edi+2]
	dec	eax
	cmp	ecx, 0FFEFBBBFh
	je	@@2c
@@2b:	; ansi
	xor	eax, eax
	mov	[@@L0+4], 932
@@2c:	mov	[@@L0], eax
@@2d:
	test	eax, eax
	je	@@4c
	shr	ebx, 1
	je	@@4b
	call	@@Swap
	cmp	word ptr [edi], 0FEFFh
	jne	@@4b
	add	edi, 2
	dec	ebx
@@4b:	xchg	eax, ebx
	jmp	@@4e

@@4c:	cmp	[@@L0+4], 65001
	jne	@@4d
	cmp	ebx, 3
	jb	@@4d
	movzx	eax, word ptr [edi+1]
	shl	eax, 8
	mov	al, [edi]
	cmp	eax, 0BFBBEFh
	jne	@@4d
	add	edi, 3
	sub	ebx, 3
@@4d:
	call	MultiByteToWideChar, [@@L0+4], 0, edi, ebx, 0, 0
	test	eax, eax
	je	@@4e
	xchg	esi, eax
	lea	eax, [esi+esi]
	call	_MemAlloc, eax
	jc	@@4e
	xchg	edi, eax
	call	MultiByteToWideChar, [@@L0+4], 0, eax, ebx, edi, esi
	xchg	ebx, eax
	call	_MemFree, [@@M]
	mov	[@@M], edi
	xchg	ebx, eax
@@4e:	xchg	ebx, eax

	mov	eax, [@@L1]
	test	eax, eax
	je	@@5a
	call	@@Swap
	xchg	ebx, eax
	shl	eax, 1
	jmp	@@5b

@@5a:	call	WideCharToMultiByte, [@@L1+4], 0, edi, ebx, 0, 0, 0, 0
	test	eax, eax
	je	@@5b
	xchg	esi, eax
	call	_MemAlloc, esi
	jc	@@4e
	xchg	edi, eax
	call	WideCharToMultiByte, [@@L1+4], 0, eax, ebx, edi, esi, 0, 0
	xchg	ebx, eax
	call	_MemFree, [@@M]
	mov	[@@M], edi
	xchg	ebx, eax
@@5b:	xchg	ebx, eax

	call	_FileCreate, dword ptr [ebp+18h], FILE_OUTPUT
	jc	@@9
	xchg	esi, eax

	cmp	[@@L2], 0
	jne	@@7c
	mov	ecx, [@@L1]
	test	ecx, ecx
	jne	@@7a
	cmp	[@@L1+4], 65001
	jne	@@7c
	mov	eax, 0BFBBEFh
	push	3
	jmp	@@7b
@@7a:	push	-2
	pop	eax
	dec	ecx
	jne	$+4
	xchg	al, ah
	push	2
@@7b:	pop	ecx
	push	eax
	mov	edx, esp
	call	_FileWrite, esi, edx, ecx
@@7c:
	call	_FileWrite, esi, edi, ebx
	call	_FileClose, esi

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret


@@Swap PROC
	dec	eax
	je	@@9
	push	edi
	mov	ecx, ebx
	test	ebx, ebx
	je	@@1a
@@1:	mov	al, [edi]
	mov	dl, [edi+1]
	mov	[edi+1], al
	mov	[edi], dl
	add	edi, 2
	dec	ecx
	jne	@@1
@@1a:	pop	edi
@@9:	ret
ENDP

@@2:	call	_string_num, esi
	jc	@@2a
	xchg	edx, eax
	xor	eax, eax
	ret

@@2a:	push	esi
	call	@@2e
	db 'utf8',0, 'utf16',0, 'utf16be',0, 'auto',0, 0
@@2e:	call	_string_select
	jc	@@9a
	mov	edx, 65001
	dec	eax
	ret
ENDP
