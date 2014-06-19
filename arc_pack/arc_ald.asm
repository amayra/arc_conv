
_arc_ald PROC

@@D = dword ptr [ebp+8]
@@FL = dword ptr [ebp+0Ch]
@@PB = dword ptr [ebp+10h]
@@PC = dword ptr [ebp+14h]

@@stk = 0
@M0 @@M
@M0 @@P
@M0 @@L0
@M0 @@L1, 8
@M0 @@I

	enter	@@stk, 0
	cmp	[@@PC], 0
	jne	@@9a
	mov	esi, [@@PB]
	call	_unicode_ext, -1, dword ptr [esi-4]	; outFileName
	test	ecx, ecx
	je	@@2c
	movzx	eax, word ptr [edx-2]
	or	al, 20h
	sub	al, 61h
	cmp	eax, 1Ah
	jb	$+4
@@2c:	xor	eax, eax
	inc	eax
	mov	[@@L0], eax

	mov	esi, [@@FL]
	lodsd
	xor	edi, edi
	lea	ebx, [eax*2+eax+3]
@@2a:	mov	esi, [esi]
	test	esi, esi
	je	@@2b
	call	_ald_index
	jc	@@2a
	cmp	edi, eax
	jae	$+3
	xchg	edi, eax
	jmp	@@2a
@@2b:	lea	edi, [edi*2+edi+3]
	mov	eax, 0FFh
	add	edi, eax
	add	ebx, eax
	not	eax
	and	edi, eax
	and	ebx, eax
	add	edi, ebx
	mov	[@@P], edi
	mov	[@@L1+4], edi
	call	_MemAlloc, edi
	jb	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	call	_FileWrite, [@@D], edi, eax
	lea	eax, [edi+ebx]
	mov	[@@L1], eax

	mov	ecx, [@@L1+4]
	xor	eax, eax
	shr	ecx, 2
	rep	stosd
	sub	esp, 100h
	mov	edi, esp
	lea	ecx, [eax+40h]
	rep	stosd
	mov	[@@I], eax

	mov	eax, ebx
	call	@@3
	mov	esi, [@@FL]
	lodsd
@@1:	mov	esi, [esi]
	test	esi, esi
	je	@@1a
	call	_ald_index
	jc	@@1c
	lea	eax, [eax*2+eax]
	mov	edx, [@@L0]
	add	eax, [@@L1]
	mov	ecx, [@@I]
	mov	[eax], dl
	mov	[eax+1], cx
@@1c:
	mov	eax, [@@P]
	call	@@3
	mov	ecx, [esi+8]
	mov	ebx, [esi+2Ch]
	lea	eax, [ecx+11h+0Fh]
	and	eax, -10h
	sub	esp, eax
	mov	edi, esp
	stosd
	xchg	ebx, eax
	stosd
	lea	eax, [ebx-10h]
	sub	eax, ecx
	push	esi
	mov	edx, esi
	lea	esi, [esi+0Ch+14h]	; LastWriteTime
	movsd
	movsd
	mov	esi, [edx+4]
	rep	movsb
	pop	esi
	xchg	ecx, eax
	rep	stosb
	mov	edx, esp
	call	_FileWrite, [@@D], edx, ebx
	add	[@@P], eax
	add	esp, ebx

	lea	edx, [esi+30h]
	call	_ArcAddFile, [@@D], edx, 0
	add	[@@P], eax

	movzx	ebx, byte ptr [@@P]
	neg	bl
	jnc	@@1b
	mov	edx, esp
	call	_FileWrite, [@@D], edx, ebx
	add	[@@P], eax
@@1b:	jmp	@@1

@@1a:	mov	ebx, [@@D]
	mov	esi, [@@FL]
	lodsd
	shl	eax, 8
	add	eax, [@@L0]
	push	0
	push	eax
	push	10h
	push	14C4Eh
	mov	edx, esp
	call	_FileWrite, ebx, edx, 10h
	call	_FileSeek, ebx, 0, 0
	call	_FileWrite, ebx, [@@M], [@@L1+4]
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	mov	edx, [@@I]
	inc	[@@I]
	lea	edx, [edx*2+edx]
	add	edx, [@@M]
	mov	[edx], ah
	shr	eax, 10h
	mov	[edx+1], ax
	ret
ENDP

_file_index PROC
	call	_ansi_ext, dword ptr [esi+8], dword ptr [esi+4]
@@1:	dec	edx
	test	ecx, ecx
	je	@@1a
	mov	al, [edx]
	sub	al, 30h
	cmp	al, 0Ah
	jb	@@1
@@1a:	inc	edx
	xor	eax, eax
	xor	ecx, ecx
@@2:	lea	ecx, [ecx*4+ecx]
	lea	ecx, [ecx*2+eax]
	cmp	ecx, 100000h
	jae	@@9
	movzx	eax, byte ptr [edx]
	inc	edx
	sub	al, 30h
	cmp	al, 0Ah
	jb	@@2
	xchg	eax, ecx
	clc
	ret
@@9:	stc
	ret
ENDP

_ald_index PROC
	call	_file_index
	jc	@@9
	sub	eax, 1
@@9:	ret
ENDP
