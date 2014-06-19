@SYS_TMP = 0
IFDEF @SYS_UNICODE
@SYS_TMP = @SYS_UNICODE
ENDIF
IF @SYS_TMP
extrn	LoadLibraryA:PROC
extrn	GetProcAddress:PROC
extrn	FreeLibrary:PROC
extrn	GetLongPathNameW:PROC
_GetOpenDirName PROC
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	call	@@4
@@4a	db 'SHELL32.DLL', 0
@@4b	db 'SHGetMalloc', 0
@@4c	db 'SHBrowseForFolderW', 0
@@4d	db 'SHGetPathFromIDListW', 0
@@4:	pop	edi
	call	LoadLibraryA, edi
	test	eax, eax
	je	@@9
	add	edi, @@4b-@@4a
	push	eax
	xchg	esi, eax
	call	GetProcAddress, esi, edi
	test	eax, eax
	je	@@3
	add	edi, @@4c-@@4b
	push	eax
	call	GetProcAddress, esi, edi
	test	eax, eax
	je	@@3
	add	edi, @@4d-@@4c
	push	eax
	call	GetProcAddress, esi, edi
	test	eax, eax
	je	@@3
	push	eax
	sub	esp, 204h
	xor	esi, esi
	push	esi
	mov	edi, esp
	push	esi
	push	esi
	push	esi
	push	1		; BIF_RETURNONLYFSDIRS
	push	dword ptr [ebp+14h]
	push	edi
	push	esi
	push	esi
	; SHGetMalloc
	call	dword ptr [ebp-8], esp, esi
	pop	ebx
	test	eax, eax
	jne	@@2
	; SHBrowseForFolderW
	call	dword ptr [ebp-0Ch], esp
	test	eax, eax
	je	@@1
	push	eax
	; SHGetPathFromIDListW
	call	dword ptr [ebp-10h], eax, edi
	xchg	esi, eax
	mov	edx, [ebx]
	call	dword ptr [edx+14h], ebx
@@1:	mov	edx, [ebx]
	call	dword ptr [edx+8], ebx
@@2:	test	esi, esi
	xchg	eax, esi
	je	@@3
	call	GetLongPathNameW, edi, dword ptr [ebp+18h], dword ptr [ebp+1Ch]
@@3:	xchg	esi, eax
	call	FreeLibrary, dword ptr [ebp-4]
	xchg	esi, eax
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP
ELSE
extrn	LoadLibraryA:PROC
extrn	GetProcAddress:PROC
extrn	FreeLibrary:PROC
extrn	GetLongPathNameA:PROC
_GetOpenDirName PROC
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	call	@@4
@@4a	db 'SHELL32.DLL', 0
@@4b	db 'SHGetMalloc', 0
@@4c	db 'SHBrowseForFolderA', 0
@@4d	db 'SHGetPathFromIDListA', 0
@@4:	pop	edi
	call	LoadLibraryA, edi
	test	eax, eax
	je	@@9
	add	edi, @@4b-@@4a
	push	eax
	xchg	esi, eax
	call	GetProcAddress, esi, edi
	test	eax, eax
	je	@@3
	add	edi, @@4c-@@4b
	push	eax
	call	GetProcAddress, esi, edi
	test	eax, eax
	je	@@3
	add	edi, @@4d-@@4c
	push	eax
	call	GetProcAddress, esi, edi
	test	eax, eax
	je	@@3
	push	eax
	sub	esp, 100h
	xor	esi, esi
	push	esi
	mov	edi, esp
	push	esi
	push	esi
	push	esi
	push	1		; BIF_RETURNONLYFSDIRS
	push	dword ptr [ebp+14h]
	push	edi
	push	esi
	push	esi
	; SHGetMalloc
	call	dword ptr [ebp-8], esp, esi
	pop	ebx
	test	eax, eax
	jne	@@2
	; SHBrowseForFolderA
	call	dword ptr [ebp-0Ch], esp
	test	eax, eax
	je	@@1
	push	eax
	; SHGetPathFromIDListA
	call	dword ptr [ebp-10h], eax, edi
	xchg	esi, eax
	mov	edx, [ebx]
	call	dword ptr [edx+14h], ebx
@@1:	mov	edx, [ebx]
	call	dword ptr [edx+8], ebx
@@2:	test	esi, esi
	xchg	eax, esi
	je	@@3
	call	GetLongPathNameA, edi, dword ptr [ebp+18h], dword ptr [ebp+1Ch]
@@3:	xchg	esi, eax
	call	FreeLibrary, dword ptr [ebp-4]
	xchg	esi, eax
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP
ENDIF