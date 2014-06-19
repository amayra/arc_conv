
; "Nitro Wars" *.pak

	dw 0
_arc_n3pk PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Ch
	jc	@@9a
	pop	eax
	cmp	eax, 6B50334Eh
	jne	@@9a
	pop	ebx
	pop	eax	; 100015F0, "NitroWars"
	lea	eax, [ebx-1]
	mov	[@@N], ebx
	shr	eax, 14h
	jne	@@9a
	imul	ebx, 98h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]

	xor	ecx, ecx
	sub	esp, 100h
@@2a:	mov	eax, ecx
	mov	edx, 8
@@2b:	shr	eax, 1
	jnc	$+7
	xor	eax, 0EDB88320h
	dec	edx
	jne	@@2b
	mov	[esp+ecx*4], eax
	inc	ecx
	cmp	ecx, 40h
	jb	@@2a
	mov	byte ptr [esp], 0AAh

@@1:	lea	edi, [esi+16h]
	xor	eax, eax
	lea	ecx, [eax+3Fh]
	mov	edx, edi
	repne	scasb
	jne	@@8
	mov	byte ptr [edi-1], 2Fh
	push	esi
	lea	esi, [esi+56h]
	lea	ecx, [eax+10h]
	rep	movsd
	pop	esi
	stosb
	call	_ArcName, edx, -1

	mov	ebx, [esi+4]
	and	[@@D], 0
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	test	ebx, ebx
	je	@@1a
	mov	eax, [esi+10h]
	test	al, 2
	je	@@1a
	shr	eax, 10h
	mov	ecx, ebx
	dec	eax
	je	@@1c
	dec	eax
	jne	@@1a
	mov	eax, 400h
	cmp	ecx, eax
	jb	$+3
	xchg	ecx, eax
@@1c:	movzx	eax, byte ptr [esi+15h]
	mov	edi, [@@D]
@@1d:	mov	dl, [esp+eax]
	add	al, 1
	xor	[edi], dl
	inc	edi
	dec	ecx
	jne	@@1d
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 98h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP
