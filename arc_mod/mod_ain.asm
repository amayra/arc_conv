
_mod_ain PROC

@@stk = 0
@M0 @@S
@M0 @@C
@M0 @@M
@M0 @@L0

	push	ebp
	mov	ebp, esp
	dec	eax
	shr	eax, 1
	jne	@@9a
	call	_FileCreate, dword ptr [ebp+0Ch], FILE_INPUT
	jc	@@9a
	push	eax
	xchg	edi, eax
	call	_FileGetSize, edi
	jc	@@9b
	cmp	eax, 10h
	jb	@@9b
	push	eax
	xchg	ebx, eax
	call	_MemAlloc, ebx
	jc	@@9b
	push	eax
	xchg	esi, eax
	call	_FileRead, edi, esi, ebx
	jc	@@9
	call	_FileClose, edi
	and	[@@S], -1
	push	0	; @@L0

	mov	eax, [esi]
	mov	edx, [esi+4]
	cmp	eax, 'SREV'
	je	@@2
	cmp	eax, 0BA02F57Eh
	je	@@4
	test	edx, edx
	jne	@@2c
	mov	ecx, [esi+0Ch]
	mov	edi, [esi+8]
	cmp	eax, '2IA'
	je	@@2b
	xchg	ecx, edi
	cmp	eax, 'XCA'
	jne	@@2c
@@2b:	add	ecx, 10h
	cmp	ebx, ecx
	jne	@@9
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	lea	edx, [esi+10h]
	call	_zlib_unpack, edi, eax, edx, [@@C]
	xchg	ebx, eax
	jmp	@@2a

@@2c:	mov	eax, [ebp+8]
	call	_unicode_ext, -1, dword ptr [ebp+0Ch+eax*4-4]
	inc	[@@L0]
	cmp	eax, 'xca'
	je	@@2d
	jmp	@@9

@@2:	cmp	edx, 6
	jb	@@4
@@2d:	lea	ebx, [ebx*8+ebx+3Ah+7]
	shr	ebx, 3
	call	_MemAlloc, ebx
	jc	@@9
	xchg	edi, eax
	mov	eax, '2IA'
	stosd
	xor	eax, eax
	stosd
	mov	eax, [@@C]
	stosd
	stosd
	call	_zlib_pack, edi, ebx, esi, eax
	sub	edi, 10h
	lea	ebx, [eax+10h]
	mov	[edi+0Ch], eax
	dec	[@@L0]
	jne	@@2a
	mov	dword ptr [edi], 'XCA'
	xchg	[edi+8], eax
	mov	[edi+0Ch], eax
@@2a:	call	_MemFree, esi
	mov	[@@M], edi

@@7:	mov	eax, [ebp+8]
	call	_FileCreate, dword ptr [ebp+0Ch+eax*4-4], FILE_OUTPUT
	jc	@@9
	mov	[@@S], eax
	call	_FileWrite, eax, edi, ebx
@@9:	call	_MemFree, [@@M]
@@9b:	call	_FileClose, [@@S]
@@9a:	leave
	ret

; "Sengoku Rance" *.ain
; DLL\Sys42VM.dll 10037BC0

; ain_key = 0x5D3E3

@@4:	sub	esp, 270h*4
	mov	edi, esp
	mov	eax, 5D3E3h
	mov	ecx, 270h
	or	eax, 1
@@4a:	stosd
	imul	eax, 10DCDh
	dec	ecx
	jne	@@4a
	call	_th123_crypt, esi, ebx, 0
	mov	edi, esi
	jmp	@@7
ENDP
