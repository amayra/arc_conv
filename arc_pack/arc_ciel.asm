
_arc_ciel PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L0, 0Ch

; 0,1 = 8,20h
; 2,3 = 8,18h
; 4,5 = 4,18h

	enter	@@stk, 0
	cmp	[@@PC], 2
	jne	@@9a
	mov	esi, [@@PB]
	mov	edx, [esi]
	movzx	eax, word ptr [edx]
	sub	al, 30h
	cmp	eax, 6
	jae	@@9a
	cmp	word ptr [edx+2], 0
	jne	@@9a
	cmp	eax, 2
	sbb	ebx, ebx
	and	ebx, 8
	add	ebx, 18h
	mov	[@@L0], eax
	mov	[@@L0+4], ebx
	call	_stack_sjis_esc, dword ptr [esi+4]
	mov	[@@L0+8], esp

	mov	esi, [@@FL]
	add	ebx, 0Ch
	lodsd
	cmp	[@@L0], 4
	cmc
	sbb	edi, edi
	imul	ebx, eax
	lea	edi, [ebx+edi*4+8]
	mov	[@@P], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax

	mov	esi, [@@FL]
	mov	eax, [@@L0]
	movsd
	cmp	eax, 4
	jae	@@1
	and	al, 1
	stosd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@7
	mov	ebx, [@@L0+4]
	call	_string_copy_ansi, edi, ebx, dword ptr [esi+4]
	add	edi, ebx

	mov	eax, [esi+2Ch]
	mov	ecx, [@@P]
	stosd
	stosd
	xchg	ecx, eax
	stosd
	lea	edx, [esi+30h]
	test	byte ptr [@@L0], 1
	je	@@1a
	lea	ebx, [ecx*8+ecx+7]
	shr	ebx, 3
	call	_ArcPackFile, [@@D], edx, ecx, ebx, 1, offset _lzss_pack, 0
	jmp	@@1b
@@1a:	call	_ArcAddFile, [@@D], edx, 0
@@1b:	mov	[edi-8], eax
	add	[@@P], eax
	jmp	@@1

@@7:	cmp	[@@L0], 4
	cmc
	sbb	edx, edx
	mov	esi, [@@M]
	mov	ecx, edi
	lea	edx, [esi+edx*4+8]
	mov	ebx, [@@L0+8]
	sub	ecx, edx
	je	@@7c
	cmp	byte ptr [ebx], 0
	je	@@7c
@@7a:	mov	esi, ebx
@@7b:	lodsb
	test	al, al
	je	@@7a
	sub	[edx], al
	inc	edx
	dec	ecx
	jne	@@7b
@@7c:
	mov	esi, [@@M]
	mov	ebx, [@@D]
	sub	edi, esi
	call	_FileSeek, ebx, 0, 0
	call	_FileWrite, ebx, esi, edi
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
