
_out_rar_create PROC
	@M1
	test	ebx, ebx
	jne	@@2a
	mov	dword ptr [edi], 72002Eh
	mov	dword ptr [edi+4], 720061h
	mov	[edi+8], ax
@@2a:	call	_FileCreate, esi, FILE_OUTPUT
	sbb	edx, edx
	test	ebx, ebx
	jne	@@2b
	and	word ptr [edi], 0
@@2b:	or	[@@B], edx
	jne	@@9
	mov	[@@D], eax
	push	14h
	call	@@1
	dd 021726152h,0CF00071Ah
	dd 000007390h,00000000Dh
	dd 000000000h
@@1:	call	_FileWrite, eax
	lea	edi, [@@T]
	call	GetSystemTimeAsFileTime, esp, eax, eax
	mov	ecx, esp
	lea	eax, [edi+2]
	call	_FileTimeToDosDateTime, ecx, eax, edi
	pop	ecx
	pop	ecx
	call	_crc32init
@@9:	ret
ENDP

_out_rar_close PROC
	@M1
	mov	esi, [@@D]
	push	7
	call	@@1
	db 0C4h,03Dh,07Bh,000h,040h,007h
@@1:	call	_FileWrite, esi
	call	_FileClose, esi
	ret
ENDP

	db 3
	dw _out_rar_close-$-4
	dw _out_rar_create-$-2
_out_rar PROC
	@M1
	mov	ebx, esp
	mov	esi, offset outFileNameA
	or	ecx, -1
	lea	edx, [esi+outFileNameW-outFileNameA]
	mov	edi, esi
	xor	eax, eax
	repne	scasb
	not	ecx
	dec	ecx
	sub	esp, 0DE0h	; 408h+(408h/4*9)
	mov	edi, esp
	rep	movsb
	mov	esi, edx
	call	@@5
	push	20h
	push	3014h
	push	[@@T]
	push	edx
	push	2000000h
	push	edx
	push	edx
	push	740000h
	sub	edi, esp

	mov	esi, dword ptr [ebx+1Ch]
	call	_crc32, 0, esi, dword ptr [ebx+18h]
	mov	ecx, esp
	lea	edx, [edi-20h]
	mov	[ecx+5], di
	mov	[ecx+7], esi
	mov	[ecx+0Bh], esi
	mov	[ecx+10h], eax
	mov	[ecx+1Ah], dx
	lea	eax, [edi-2]
	inc	ecx
	inc	ecx
	call	_crc32, 0, eax, ecx
	mov	ecx, esp
	mov	[ecx], ax
	call	_FileWrite, [@@D], ecx, edi
	mov	esp, ebx
	call	_FileWrite, [@@D], dword ptr [ebx+18h], esi
	ret

@@5 PROC
	push	ebx
	push	edi
	xor	eax, eax
	xor	ebx, ebx
	stosw
	jmp	@@3
@@2:	mov	[ecx], dl
@@3:	mov	ecx, edi
	inc	edi
	xor	edx, edx
	inc	edx
@@1:	test	dh, dh
	jne	@@2
	shl	edx, 2
	lodsw
	test	eax, eax
	je	@@4
	stosb
	or	ebx, eax
	test	ah, ah
	je	@@1
	mov	al, ah
	or	dl, 2
	stosb
	jmp	@@1

@@4:	dec	esi
	dec	esi
	cmp	edx, 4
	jne	@@1
	dec	edi
	pop	eax
	mov	dl, 82h
	test	bh, bh
	jne	@@7
	mov	dl, 80h
	xchg	edi, eax
@@7:	pop	ebx
	ret
ENDP

ENDP

	.data

ALIGN 4
_crc32tab dd 100h dup(?)

	.code

_crc32init PROC
	xor	ecx, ecx
@@1:	mov	eax, ecx
	mov	edx, 8
@@2:	ror	eax, 1
	jc	$+7
	xor	eax, 06DB88320h
	dec	edx
	jne	@@2
	mov	[_crc32tab+ecx*4], eax
	inc	cl
	jne	@@1
	ret
ENDP

_crc32 PROC
	mov	edx, esp
	push	esi
	mov	esi, [edx+0Ch]
	mov	ecx, [edx+8]
	mov	eax, [edx+4]
	test	ecx, ecx
	je	@@4
	xor	edx, edx
@@3:	mov	dl, [esi]
	inc	esi
	xor	dl, al
	shr	eax, 8
	xor	eax, [_crc32tab+edx*4]
	dec	ecx
	jne	@@3
@@4:	pop	esi
	ret	0Ch
ENDP

