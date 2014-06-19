
_arc_sm2mpx10 PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P

	enter	@@stk, 0
	cmp	[@@PC], 0
	jne	@@9a
	mov	esi, [@@FL]
	mov	ebx, [esi]
	imul	ebx, 14h
	lea	edi, [ebx+20h]
	mov	[@@P], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax
	mov	eax, 'M2MS'
	stosd
	mov	eax, '01XP'
	stosd
	movsd
	mov	eax, [@@P]
	stosd

	mov	esi, [@@PB]
	call	_unicode_name, dword ptr [esi-4]	; outFileName
	xchg	esi, eax
	push	0
	lea	eax, [ecx+ecx]
	and	eax, -4
	sub	esp, eax
	call	_unicode_to_ansi, 932, esi, ecx, esp
	call	_string_copy_ansi, edi, 0Ch, esp
	add	edi, 0Ch
	lea	esp, [ebp-@@stk]
	push	20h
	pop	eax
	stosd

	mov	esi, [@@FL]
	lodsd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@1a
	call	_sjis_lower, dword ptr [esi+4]
	call	_string_copy_ansi, edi, 0Ch, dword ptr [esi+4]
	add	edi, 0Ch
	lea	eax, [esi+30h]
	stosd
	stosd
	jmp	@@1

@@1a:	mov	esi, [@@M]
	mov	ebx, [esi+8]
	test	ebx, ebx
	je	@@4a
	push	edi
	add	esi, 20h
	call	_will_sort, esi, ebx, 14h, 8
@@4:	mov	edi, [esi+0Ch]
	and	dword ptr [esi+0Ch], 0
	call	_sjis_upper, esi
	call	_ArcAddFile, [@@D], edi, 0
	mov	ecx, [@@P]
	add	[@@P], eax
	mov	[esi+0Ch], ecx
	mov	[esi+10h], eax
	add	esi, 14h
	dec	ebx
	jne	@@4
	pop	edi
@@4a:
	mov	ebx, [@@D]
	mov	esi, [@@M]
	sub	edi, esi
	call	_FileSeek, ebx, 0, 0
	call	_FileWrite, ebx, esi, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
