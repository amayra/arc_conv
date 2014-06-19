
; "Cure Girl" *.iga
; Himorogi.dll
; 10008630 open_archive
; 10008520 decrypt_loop

	dw 0
_arc_iga0 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@D
@M0 @@L0
@M0 @@P
@M0 @@N
@M0 @@M, 8

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	cmp	dword ptr [esi], '0AGI'
	jne	@@9a
	movzx	eax, word ptr [esi+8]
	dec	eax
	shr	eax, 1
	jne	@@9a
	lea	edx, [@@M]
	call	@@Load, [@@S], edx
	cmp	[@@N], 0
	je	@@9
	mov	edi, [@@L0+4]
	imul	ebx, [@@N], 0Ch
	shl	edi, 1
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx
	call	_ArcDbgData, [@@M+4], edi
	call	_ArcUnicode, 1

@@1:	mov	edi, [@@L0]
	cmp	[@@N], 1
	mov	ecx, edi
	je	@@1c
	mov	ecx, [esi+0Ch]
@@1c:	mov	eax, [esi]
	cmp	edi, ecx
	jb	@@1b
	sub	ecx, eax
	jbe	@@1b
	mov	edx, [@@M+4]
	lea	edx, [edx+eax*2]
	call	_ArcName, edx, ecx
@@1b:	and	[@@D], 0
	mov	eax, [esi+4]
	mov	ebx, [esi+8]
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	test	ebx, ebx
	je	@@1a
	push	2
	pop	eax
	mov	edi, [@@D]
	mov	ecx, ebx
@@1d:	xor	[edi], al
	inc	edi
	inc	eax
	dec	ecx
	jne	@@1d
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 0Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
	call	_MemFree, [@@M+4]
@@9a:	leave
	ret

@@Load PROC

@@S = dword ptr [ebp+14h]
@@D = dword ptr [ebp+18h]

@@L0 = dword ptr [ebp-8]
@@L1 = dword ptr [ebp-0Ch]
@@N = dword ptr [ebp-10h]
@@M = dword ptr [ebp-18h]

	push	ebx
	push	esi
	push	edi
	enter	8, 0
	push	10h+5+5
	push	0	; @@N
	push	0
	push	0	; @@M
	call	@@3
	test	esi, esi
	je	@@9
	mov	[@@M], esi
	mov	eax, ebx

	xor	edx, edx
	lea	ecx, [edx+3]
	div	ecx
	test	edx, edx
	jne	@@9
	mov	[@@N], eax
	dec	eax
	shr	eax, 14h
	jne	@@9

	mov	eax, ebx
	shl	eax, 2
	call	_MemAlloc, eax
	jc	@@9
	mov	[@@M], eax
	xchg	edi, eax
	push	esi
@@2a:	xor	eax, eax
@@2b:	shl	eax, 7
	lodsb
	test	al, 1
	je	@@2b
	shr	eax, 1
	stosd
	dec	ebx
	jne	@@2a
	call	_MemFree

	call	@@3
	test	esi, esi
	je	@@9
	mov	[@@M+4], esi
	mov	[@@L0], ebx

	lea	eax, [ebx+ebx]
	call	_MemAlloc, eax
	jc	@@9
	mov	[@@M+4], eax
	xchg	edi, eax
	push	esi
@@4a:	xor	eax, eax
@@4b:	shl	eax, 7
	lodsb
	test	al, 1
	je	@@4b
	shr	eax, 1
	stosw
	dec	ebx
	jne	@@4a
	call	_MemFree
	jmp	@@7

@@9:	and	[@@N], 0
@@7:	mov	edi, [@@D]
	lea	esi, [@@M]
	push	5
	pop	ecx
	rep	movsd
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@3:	lea	esi, [@@L0]
	call	_FileRead, [@@S], esi, 5
	xchg	edi, eax
	xor	eax, eax
@@3a:	dec	edi
	js	@@3d
	shl	eax, 7
	lodsb
	test	al, 1
	je	@@3a
	shr	eax, 1
	sub	[@@L1], edi
	xchg	ebx, eax
	call	_MemAlloc, ebx
	jc	@@3d
	push	eax
	xchg	edi, eax
	mov	ecx, eax
	rep	movsb
	add	[@@L1], ebx
	mov	edx, ebx
	sub	edx, eax
	pop	esi
	jbe	@@3b
	call	_FileRead, [@@S], edi, edx
	jc	@@3c
@@3b:	call	@@5
	xchg	ebx, eax
	jns	@@3e
@@3c:	call	_MemFree, esi
@@3d:	xor	esi, esi
@@3e:	ret

@@5:	xor	edx, edx
	push	esi
@@5a:	dec	ebx
	js	@@5b
	lodsb
	test	al, 1
	je	@@5a
	inc	edx
	js	@@5b
	test	ebx, ebx
	jne	@@5a
@@5b:	xchg	eax, edx
	pop	esi
	ret

ENDP	; @@3

ENDP