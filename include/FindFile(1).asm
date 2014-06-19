
if 0
WIN32_FIND_DATA		struct
fdFileAttributes	dd ?
fdCreationTime		dd ?, ?
fdLastAccessTime	dd ?, ?
fdLastWriteTime		dd ?, ?
fdFileSizeHigh		dd ?
fdFileSizeLow		dd ?
fdReserved0		dd ?
fdReserved1		dd ?
fdFileName		dw 104h dup(?)
fdAlternateFileName	dw 0Eh dup(?)	; 8.3 alias name
WIN32_FIND_DATA		ends
endif

extrn	FindFirstFileW:PROC
extrn	FindNextFileW:PROC
extrn	FindClose:PROC

_FindFile PROC

@@S = dword ptr [ebp+1Ch]
@@C = dword ptr [ebp+20h]	; callback
@@P = dword ptr [ebp+24h]	; callback param

@@L0 = dword ptr [ebp+4]
@@L1 = dword ptr [ebp+8]

	push	ebx
	push	esi
	push	edi
	push	ecx
	push	ecx
	enter	250h+400h, 0
	mov	[@@L1], esp
	lea	edi, [esp+250h]
	or	ebx, -1
	mov	esi, [@@S]
	mov	[@@S], edi
	xor	eax, eax
	test	esi, esi
	je	@@3a
	cmp	[esi], ax
	je	@@3a
	call	@@5
	je	@@9
@@3a:	mov	[@@L0], edi
@@1:	mov	dword ptr [edi], '*'
	call	FindFirstFileW, [@@S], [@@L1]
	push	ebx
	push	edi
	mov	ebx, eax	; hFind
	inc	eax
	je	@@1a
@@2:	mov	esi, [@@L1]
	add	esi, 2Ch
	movzx	eax, word ptr [esi]
	movzx	edx, word ptr [esi+2]
	test	eax, eax
	je	@@2c
	cmp	eax, 2Eh
	jne	@@2a
	test	edx, edx
	je	@@2c
	sub	eax, edx
	jne	@@2a
	cmp	[esi+4], ax
	je	@@2c
@@2a:	test	byte ptr [esi-2Ch], 10h
	je	@@2b
	call	@@5
	je	@@2c
	call	[@@C], [@@P], [@@S], [@@L0], [@@L1]
	test	eax, eax
	je	@@2c
	jmp	@@1

@@2b:	lodsw
	cmp	edi, ebp
	je	@@2c
	stosw
	test	eax, eax
	jne	@@2b
	call	[@@C], [@@P], [@@S], [@@L0], [@@L1]
	test	eax, eax
	je	@@2d
@@2c:	mov	edi, [esp]
	call	FindNextFileW, ebx, [@@L1]
	test	eax, eax
	jne	@@2
@@2d:	call	FindClose, ebx
@@1a:	pop	edi
	pop	ebx
	cmp	ebx, -1
	je	@@9
	xor	eax, eax
	stosw
	call	[@@C], [@@P], [@@S], [@@L0], eax
	jmp	@@2c

@@9:	leave
	pop	ecx
	pop	ecx
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@5:	push	5Ch
	pop	ecx
@@5a:	lodsw
	cmp	edi, ebp
	je	@@5c
	stosw
	test	eax, eax
	jne	@@5a
	cmp	[edi-4], cx
	je	@@5c
	mov	[edi-2], cx
	stosw
@@5c:	cmp	edi, ebp
	lea	edi, [edi-2]
	ret
ENDP
