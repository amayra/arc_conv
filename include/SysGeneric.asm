@SYS_TMP = 0
IFDEF @SYS_UNICODE
@SYS_TMP = @SYS_UNICODE
ENDIF

; IFNDEF @SYS_EXTERN
; @SYS_EXTERN = 11111b	; size,seek,write,read,mem
; ENDIF
IFDEF @SYS_EXTERN
IF (@SYS_EXTERN AND 1)		; memory

extrn	VirtualAlloc:PROC
extrn	VirtualFree:PROC
public _MemAlloc
_MemAlloc PROC
	mov	eax, [esp+4]
	cmp	eax, 80000000h
	sbb	ecx, ecx
	add	eax, 0FFFh
	and	eax, ecx
	and	eax, -1000h
	je	@@1
	call	VirtualAlloc, 0, eax, 1000h, 4
@@1:	cmp	eax, 1
	ret	4
ENDP

public _MemFree
_MemFree PROC
	mov	eax, [esp+4]
	test	eax, eax
	je	@@1
	call	VirtualFree, eax, 0, 8000h
@@1:	cmp	eax, 1
	ret	4
ENDP

ENDIF
IF (@SYS_EXTERN AND 2)		; file read

extrn	ReadFile:PROC
public _FileRead
_FileRead:
	push	ecx
	mov	ecx, esp
	call	ReadFile, dword ptr [ecx+8], \
		dword ptr [ecx+0Ch], dword ptr [ecx+10h], ecx, 0
	add	eax, -1
	pop	eax
	sbb	ecx, ecx
	and	eax, ecx
	cmp	eax, [esp+0Ch]
	ret	0Ch

ENDIF
IF (@SYS_EXTERN AND 4)		; file write

extrn	WriteFile:PROC
public _FileWrite
_FileWrite:
	push	ecx
	mov	ecx, esp
	call	WriteFile, dword ptr [ecx+8], \
		dword ptr [ecx+0Ch], dword ptr [ecx+10h], ecx, 0
	add	eax, -1
	pop	eax
	sbb	ecx, ecx
	and	eax, ecx
	cmp	eax, [esp+0Ch]
	ret	0Ch

ENDIF
IF (@SYS_EXTERN AND 8)		; file seek

extrn	SetFilePointer:PROC
public _FileSeek
_FileSeek PROC
	mov	eax, [esp+0Ch]
	mov	ecx, [esp+8]
	push	eax
	push	0
	push	ecx
	push	dword ptr [esp+10h]
	test	ecx, ecx
	jns	@@3
	test	eax, eax
	je	@@2
@@3:	call	SetFilePointer
	cmp	eax, -1
	cmc
	jc	@@1
	cmp	dword ptr [esp+0Ch], 0
	jne	@@1
	mov	ecx, [esp+8]
	sub	ecx, eax
	neg	ecx
@@1:	ret	0Ch

@@2:	call	_FileSeek64
	jmp	@@1
ENDP

ENDIF
IF (@SYS_EXTERN AND 10h)	; file size

extrn	GetFileSize:PROC
public _FileGetSize
_FileGetSize:
	call	GetFileSize, dword ptr [esp+8], 0
	cmp	eax, -1
	cmc
	adc	eax, 0
	ret	4

ENDIF
IF (@SYS_EXTERN AND 1Eh)	; file create, file close

; WRITE = 1, READ = 2, SH_READ = 4, SH_WRITE = 8

; CREATE_NEW		= 1
; CREATE_ALWAYS		= 2
; OPEN_EXISTING		= 3
; OPEN_ALWAYS		= 4
; TRUNCATE_EXISTING	= 5

FILE_INPUT = 36h	; READ+SH_READ+OPEN_EXISTING*16
FILE_OUTPUT = 21h	; WRITE+CREATE_ALWAYS*16
FILE_ADD = 45h		; WRITE+SH_READ+OPEN_ALWAYS*16
FILE_PATCH = 37h	; WRITE+READ+SH_READ+OPEN_EXISTING*16

IF @SYS_TMP
extrn	CreateFileW:PROC
ELSE
extrn	CreateFileA:PROC
ENDIF
extrn	CloseHandle:PROC
public _FileCreate
_FileCreate:
	mov	eax, [esp+8]
	mov	edx, eax
	mov	ecx, eax
	shl	edx, 30
	shr	eax, 2
	shr	ecx, 4
	and	eax, 3
IF @SYS_TMP
	call	CreateFileW, dword ptr [esp+1Ch], \
		edx, eax, 0, ecx, 0, 0
ELSE
	call	CreateFileA, dword ptr [esp+1Ch], \
		edx, eax, 0, ecx, 0, 0
ENDIF
	cmp	eax, -1
	cmc
	ret	8

public _FileClose
_FileClose:
	jmp	CloseHandle

ENDIF
IF (@SYS_EXTERN AND 20h)	; exit

extrn	ExitProcess:PROC
public _ExitProcess
_ExitProcess = ExitProcess

ENDIF
IF (@SYS_EXTERN AND 40h)	; dispstr

extrn	WriteFile:PROC
public _DispStr
_DispStr PROC	; addr
	pop	eax
	pop	edx
	push	eax
	push	edi
	mov	edi, edx
	xor	eax, eax
	or	ecx, -1
	cld
	repne	scasb
	not	ecx
	dec	ecx
	pop	edi
	push	ecx
	mov	eax, esp
	call	WriteFile, -0Bh, edx, ecx, eax, 0	; STD_OUTPUT_HANDLE
	pop	ecx
	ret
ENDP

ENDIF
ENDIF	; @SYS_EXTERN
