
_mod_exhibit PROC

@@stk = 0
@M0 @@S
@M0 @@M
@M0 @@K

	enter	@@stk, 0
	sub	eax, 3
	mov	ebx, eax
	shr	eax, 1
	jne	@@9a

	push	dword ptr [ebp+0Ch]
	call	@@2a
	db 'crypt',0, 'key',0, 'gyutab',0, 0
@@2a:	call	_string_select
	jc	@@9a
	and	[@@M], 0
	dec	eax
	jne	@@3

	call	_string_num, dword ptr [ebp+10h]
	jc	@@9a
	mov	[@@K], eax

	mov	eax, [ebp+14h]
	call	@@LoadRLD
	lea	ecx, [ebx-10h]
	lea	edx, [esi+10h]
	call	_exhibit_crypt, [@@K], ecx, edx
	mov	edi, esi
	jmp	@@7

@@3:	test	ebx, ebx
	jne	@@9a
	dec	eax
	je	@@4
	mov	eax, [ebp+10h]
	call	@@LoadRLD
	call	_exhibit_scan, esi, ebx
	jc	@@9
	mov	edi, edx
	xchg	ebx, eax
	jmp	@@7

@@4:	mov	eax, [ebp+10h]
	call	@@LoadRLD
	call	@@Brute, esi
	push	ecx
	push	ecx
	push	'x0'
	mov	edi, esp
	lea	edx, [edi+2]
	call	_hex32_upper, eax, edx
	push	0Ah
	pop	ebx
@@7:	mov	eax, [ebp+8]
	call	_FileCreate, dword ptr [ebp+8+eax*4], FILE_OUTPUT
	jc	@@9
	mov	[@@S], eax
	call	_FileWrite, [@@S], edi, ebx
@@9:	call	_MemFree, [@@M]
	call	_FileClose, [@@S]
@@9a:	leave
	ret

@@LoadRLD:
	call	_FileCreate, eax, FILE_INPUT
	jc	@@9a
	mov	[@@S], eax
	call	_FileGetSize, [@@S]
	jc	@@9
	cmp	eax, 18h
	jb	@@9
	xchg	ebx, eax
	call	_MemAlloc, ebx
	jc	@@9
	mov	[@@M], eax
	xchg	esi, eax
	call	_FileRead, [@@S], esi, ebx
	jc	@@9
	call	_FileClose, [@@S]
	or	[@@S], -1
	cmp	dword ptr [esi], 524C4400h
	jne	@@9
	ret

@@Brute PROC
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	xor	ebx, ebx
	mov	ecx, [ebp+10h]
	mov	esi, [ebp+14h]
	mov	eax, [esi+8]
	cmp	ecx, eax
	jb	@@7
	cmp	eax, 110h
	jne	@@7
	add	esi, eax
@@1:	imul	eax, ebx, 02B1E5071h
	add	eax, 060D9EC74h
	call	_twister_one
	xor	eax, ebx
	cmp	eax, [esi-8]
	jne	@@2
	imul	eax, ebx, 0E3C6F819h
	add	eax, 0EDC56462h
	call	_twister_one
	xor	eax, ebx
	cmp	eax, [esi-4]
	je	@@7
@@2:	inc	ebx
	jne	@@1
@@7:	xchg	eax, ebx
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

ENDP
