
_arc_tasofro PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@C0 = 1	; one key + align 4
@@C1 = 0

@@stk = 0
@M0 @@P
@M0 @@M
@M0 @@L0
if @@C0
@M0 @@L1
endif

	enter	@@stk, 0
	mov	ebx, [@@PC]
	mov	eax, 471E48C5h
	test	ebx, ebx
	je	@@6a
	dec	ebx
	jne	@@9a
	mov	esi, [@@PB]
	call	_string_num, dword ptr [esi]
	jc	@@9a
@@6a:	mov	edx, eax
	shr	edx, 10h
	sub	dh, dl
	sub	dl, ah
	sub	ah, al
	sub	dh, dl
	sub	dl, ah
	cmp	al, 0C5h
	jne	@@9a
	cmp	dl, dh
	jne	@@9a
	shl	edx, 10h
	xchg	dx, ax
	mov	[@@L0], edx

	mov	esi, [@@FL]
	lodsd
	lea	edi, [eax*8+eax+6]
@@4a:	mov	esi, [esi]
	test	esi, esi
	je	@@4b
	mov	eax, [esi+8]
	mov	ecx, 0FFh
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
	mov	[esi+8], eax
	add	edi, eax
	jmp	@@4a
@@4b:	mov	[@@P], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax
if @@C1
	mov	eax, [@@P]
	lea	ebx, [eax+4]
	and	ebx, -4
	sub	ebx, eax
	add	[@@P], ebx
endif
if @@C0
	mov	ecx, 200h
	sub	esp, ecx
	mov	edi, esp
	mov	eax, [@@P]
	mov	[@@L1], eax
	shr	eax, 1
	or	al, 23h
	rep	stosb
	mov	edi, [@@M]
endif
if @@C1
	mov	edx, esp
	call	_FileWrite, [@@D], edx, ebx
endif
	mov	esi, [@@FL]
	lodsd
	stosw
	xor	eax, eax
	stosd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@1a
if @@C0
	mov	ecx, [@@P]
	mov	edx, [@@L1]
	shr	ecx, 2
	mov	ebx, edx
	shr	edx, 2
	or	ebx, -4
@@1b:	mov	eax, ecx
	inc	ecx
	xor	eax, edx
	test	al, 7Fh-11h
	jne	@@1b
	lea	ecx, [ebx+ecx*4]
	mov	eax, [@@P]
	mov	[@@P], ecx
	sub	ecx, eax
	je	@@1c
	mov	edx, esp
	call	_FileWrite, [@@D], edx, ecx
@@1c:
endif
	mov	eax, [@@P]
	stosd
	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, offset @@5
	add	[@@P], eax
	stosd
	call	_sjis_slash, dword ptr [esi+4]
	mov	eax, [esi+8]
	stosb
	xchg	ecx, eax
	mov	eax, [esi+4]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@1a:	mov	esi, [@@M]
	sub	edi, esi
	sub	edi, 6
	mov	[esi+2], edi
	je	@@2c
	lea	eax, [edi+6]
	add	esi, 6
if @@C0
	sub	esp, 270h*4-200h
else
	sub	esp, 270h*4
endif
	call	_th123_crypt_init, eax
	call	_th123_crypt, esi, edi, 0
	lea	esp, [ebp-@@stk]

	mov	ecx, [esi-4]
	mov	ebx, [@@L0]
	mov	eax, ebx
	shr	ebx, 10h
	movzx	edx, ah
@@2b:	xor	[esi], al
	inc	esi
	add	eax, edx
	add	edx, ebx
	dec	ecx
	jne	@@2b
@@2c:	mov	esi, [@@M]
	mov	ebx, [@@D]
	mov	edi, [esi+2]
	add	edi, 6
	call	_FileSeek, ebx, 0, 0
	call	_FileWrite, ebx, esi, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5:	mov	eax, [@@P]
	shr	eax, 1
	or	al, 23h
@@5a:	xor	[esi], al
	inc	esi
	dec	ebx
	jne	@@5a
	ret
ENDP