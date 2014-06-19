
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

@@C = dword ptr [ebp+1Ch]	; callback
@@S = dword ptr [ebp+20h]

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
@@2a:	lodsw
	cmp	edi, ebp
	je	@@2c
	stosw
	test	eax, eax
	jne	@@2a
	mov	esi, [@@L1]
	call	@@3
	je	@@2c
	js	@@8
	test	byte ptr [esi], 10h
	je	@@2c
	call	@@5a
	jne	@@1
@@2c:	mov	edi, [esp]
	call	FindNextFileW, ebx, [@@L1]
	test	eax, eax
	jne	@@2
@@2d:	call	FindClose, ebx
@@1a:	pop	edi
	pop	ebx
	cmp	ebx, -1
	je	@@9
	xor	esi, esi
	mov	[edi-2], si
	call	@@3
	jns	@@2c
@@8:	call	FindClose, ebx
	pop	edi
	pop	ebx
	cmp	ebx, -1
	jne	@@8
@@9:	leave
	pop	ecx
	pop	ecx
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@3:	mov	eax, [@@C]
	push	ebx
	push	ebp
	push	edi	; 14 end
	push	dword ptr [esp+10h]	; 10 name
	push	[@@L0]	; 0C base
	push	[@@S]	; 08 full
	push	esi	; 04
	mov	ebp, [ebp]
	call	eax
	pop	esi	; const
	add	esp, 0Ch
	pop	edi	; const
	pop	ebp
	pop	ebx
	test	eax, eax
	ret

@@5:	lodsw
	cmp	edi, ebp
	je	@@5c
	stosw
	test	eax, eax
	jne	@@5
	cmp	word ptr [edi-4], 5Ch
	je	@@5b
@@5a:	mov	byte ptr [edi-2], 5Ch
	cmp	edi, ebp
	je	@@5c
	stosw
@@5b:	cmp	edi, ebp
	lea	edi, [edi-2]
@@5c:	ret
ENDP
