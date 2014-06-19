
extrn	GetModuleHandleA:PROC
extrn	GetProcAddress:PROC
extrn	CloseHandle:PROC

PROCESS_ALL_ACCESS		equ 1F0FFFh

_LoadImport PROC
	push	ebx
	push	esi
	push	edi
	mov	esi, [esp+10h]
	mov	edi, [esp+14h]
@@1:	call	GetModuleHandleA, esi
	test	eax, eax
	je	@@9
	xchg	ebx, eax
@@2:	cmp	byte ptr [esi], 0
	lea	esi, [esi+1]
	jne	@@2
@@3:	call	GetProcAddress, ebx, esi
	test	eax, eax
	je	@@9
	stosd
@@4:	cmp	byte ptr [esi], 0
	lea	esi, [esi+1]
	jne	@@4
	cmp	byte ptr [esi], 0
	jne	@@3
	inc	esi
	cmp	byte ptr [esi], 0
	jne	@@1
	xchg	eax, esi
@@9:	cmp	eax, 1
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

_mod_warcscan PROC

@@stk = 0
@M0 @@L0, 40h
@M0 @@L1, 18h
@M0 @@M
@M0 @@D

	enter	18h+40h, 0
	dec	eax
	jne	@@9a
	push	esp
	call	@@1
	db 'USER32.DLL', 0
	db 'EnumWindows', 0
	db 'GetClassNameA', 0
	db 'GetClassNameW', 0
	db 'GetWindowThreadProcessId', 0
	db 0
	db 'KERNEL32.DLL', 0
	db 'OpenProcess', 0
	db 'ReadProcessMemory', 0
	db 0
	db 0

@@1:	call	_LoadImport
	jc	@@9a
	call	_MemAlloc, 200000h
	jc	@@9a
	push	eax	; @@M
	call	_FileCreate, dword ptr [ebp+0Ch], FILE_OUTPUT
	jc	@@9b
	push	eax	; @@D
	; EnumWindows
	call	[@@L1], offset @@3, ebp
	call	_FileClose
@@9b:	call	_MemFree
@@9a:	leave
	ret

@@3:	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebx, [esp+14h]
	mov	ebp, [esp+18h]
	lea	edi, [@@L0]
	; GetClassNameA
	call	[@@L1+4], ebx, edi, 40h
	test	eax, eax
	je	@@3b
	push	3
	pop	ecx
	call	@@3a
	db 092h,0C5h,096h,0BCh,097h,0A2h,08Fh,08Fh, 20h,76h,32h,2Eh
@@3a:	pop	esi
	push	edi
	repe	cmpsd
	pop	edi
	je	@@3d
@@3b:	; GetClassNameW
	call	[@@L1+8], ebx, edi, 20h
	test	eax, eax
	je	@@3e
	push	4
	pop	ecx
	call	@@3c
	dw 0690Eh,0540Dh,091CCh,07DD2h, 20h,76h,32h,2Eh
@@3c:	pop	esi
	push	edi
	repe	cmpsd
	pop	edi
	jne	@@3e
@@3d:	; GetWindowThreadProcessId
	call	[@@L1+0Ch], ebx, edi
	test	eax, eax
	je	@@3e
	; OpenProcess
	call	[@@L1+10h], PROCESS_ALL_ACCESS, 0, dword ptr [edi]
	test	eax, eax
	je	@@3e
	xchg	ebx, eax

	mov	esi, [@@M]
	; ReadProcessMemory
	call	[@@L1+14h], ebx, 400000h, esi, 200000h, edi
	call	CloseHandle, ebx

	call	_exe_timestamp, esi, dword ptr [edi]
	call	_warc_scan, esi, dword ptr [edi], eax
	jc	@@3e
	mov	esi, edx
	mov	ecx, eax
	xchg	ebx, eax
	shr	ecx, 5

	mov	al, '2'
	stosb
	imul	eax, ecx, 67h
	shr	eax, 2+8
	imul	edx, eax, 0Ah
	add	al, 30h
	sub	ecx, edx
	stosb
	lea	eax, [ecx+30h]
	stosb
	and	ebx, 1Fh
	je	@@4b
	lea	eax, [ebx+60h]
	stosb
@@4b:	mov	al, '-'
	stosb

	push	14h
	pop	ecx
@@4c:	dec	ecx
	je	@@4
	cmp	byte ptr [esi+ecx], 0
	je	@@4c
@@4:	lodsb
	mov	edx, eax
	shr	eax, 4
	call	@@4a
	xchg	eax, edx
	call	@@4a
	dec	ecx
	jns	@@4
	mov	al, 0Dh
	stosb
	mov	al, 0Ah
	stosb

	lea	edx, [@@L0]
	sub	edi, edx
	call	_FileWrite, [@@D], edx, edi

@@3e:	xor	eax, eax
	inc	eax
	pop	ebp
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@4a:	and	al, 0Fh
	add	al, -10
	sbb	ah, ah
	add	al, 3Ah
	and	ah, 027h-020h
	add	al, ah
	stosb
	ret
ENDP
