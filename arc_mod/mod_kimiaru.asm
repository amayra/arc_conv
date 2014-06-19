
_mod_kimiaru PROC

@@stk = 0
@M0 @@S
@M0 @@D
@M0 @@P

	push	ebp
	mov	ebp, esp
	dec	eax
	mov	ebx, eax
	shr	eax, 1
	jne	@@9a
	lea	esi, [ebp+0Ch]
	lodsd
	call	_FileCreate, eax, FILE_PATCH
	jc	@@9a
	push	eax
	or	eax, -1
	dec	ebx
	js	@@4a
	lodsd
	call	_FileCreate, eax, FILE_OUTPUT
	jc	@@9b
@@4a:	push	eax
	push	0

	mov	ebx, 100000h
	call	_MemAlloc, ebx
	jc	@@9
	xchg	edi, eax
@@1:	call	_FileRead, [@@S], edi, ebx
	test	eax, eax
	je	@@9
	xchg	esi, eax
	call	@@Decrypt, offset @@K, [@@P], edi, esi
	add	[@@P], esi

	mov	eax, [@@D]
	cmp	eax, -1
	jne	@@1a
	mov	eax, esi
	neg	eax
	call	_FileSeek, [@@S], eax, 1
	mov	eax, [@@S]
@@1a:	call	_FileWrite, eax, edi, esi
	cmp	esi, ebx
	je	@@1
	call	_MemFree, edi

@@9:	call	_FileClose, [@@D]
@@9b:	call	_FileClose, [@@S]
@@9a:	leave
	ret

@@K	db 'kopkl;fdsl;kl;mwekopj@pgfd[p;:kl:;,lwret'
	db ';kl;kolsgfdio@pdsflkl:,rse;:l,;:lpksdfpo'

@@Decrypt PROC

@@K = dword ptr [ebp+14h]
@@P = dword ptr [ebp+18h]
@@S = dword ptr [ebp+1Ch]
@@C = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	enter	@arc4_size, 0
	mov	ebx, esp
	sub	esp, 40h
	mov	edi, esp
	cmp	[@@C], 0
	je	@@9
@@1:	mov	eax, [@@P]
	shr	eax, 0Ah
	call	@@DecInit, [@@K], eax, edi
	call	_arc4_set_key@12, ebx, edi, 40h
	mov	esi, 3FFh
	mov	edx, [@@P]
	and	edx, esi
	inc	esi
	lea	ecx, [edx+12Ch]
	sub	esi, edx
	lea	eax, [ecx+3]
	and	al, -4
	sub	esp, eax
	mov	edx, esp
	call	_arc4_crypt@12, ebx, edx, ecx
	mov	esp, edi
	mov	eax, [@@C]
	cmp	esi, eax
	jb	$+3
	xchg	esi, eax
	call	_arc4_crypt@12, ebx, [@@S], esi
	add	[@@S], esi
	add	[@@P], esi
	sub	[@@C], esi
	jne	@@1
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@DecInit PROC

@@K = dword ptr [ebp+14h]
@@P = dword ptr [ebp+18h]
@@D = dword ptr [ebp+1Ch]

	push	ebx
	push	esi
	push	edi
	enter	@sha512_size, 0
	mov	ebx, esp
	add	esp, -80h
	mov	edi, esp
	mov	eax, [@@P]
	mov	[ebx], eax
	and	dword ptr [ebx+4], 0
	call	_md5_fast@12, ebx, 8, edi
	lea	edx, [edi+10h]
	call	_sha1_fast@12, ebx, 8, edx
	push	4
	pop	ecx
	mov	eax, 36363636h
@@1:	mov	edx, [edi+10h]
	xor	edx, eax
	xor	[edi], edx
	add	edi, 4
	dec	ecx
	jne	@@1
	add	ecx, 1Ch
	rep	stosd
	mov	edi, esp
	mov	esi, 80h

	call	_sha512_init@4, ebx
	call	_sha512_update@12, ebx, edi, esi
	call	_sha512_update@12, ebx, dword ptr [ebp+14h], 50h
	sub	esp, 40h
	call	_sha512_final@8, ebx, esp

	xor	ecx, ecx
@@2:	xor	dword ptr [edi+ecx*4], 6A6A6A6Ah
	inc	ecx
	cmp	ecx, 20h
	jb	@@2

	call	_sha512_init@4, ebx
	call	_sha512_update@12, ebx, edi, esi
	mov	edx, esp
	call	_sha512_update@12, ebx, edx, 40h
	call	_sha512_final@8, ebx, [@@D]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

ENDP	; @@Decode

ENDP
