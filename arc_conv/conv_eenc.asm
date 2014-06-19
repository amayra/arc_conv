
; "Seirei no Kuni" image\*.png, music\*.um3

	dw _conv_eenc-$-2
_arc_eenc:
	ret
_conv_eenc PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 8
	jb	@@9
	cmp	eax, '3mu'
	jne	@@2
	mov	eax, 0AC9898B0h
	mov	edx, 0FFFFFDFFh
	sub	eax, [esi]
	sub	edx, [esi+4]
	or	eax, edx
	jne	@@2
	mov	ecx, 800h
	mov	edx, esi
	cmp	ecx, ebx
	jb	$+4
	mov	ecx, ebx
	add	ecx, 3
	shr	ecx, 2
@@1a:	not	dword ptr [edx]
	add	edx, 4
	dec	ecx
	jne	@@1a
	call	_ArcSetExt, 'ggo'
@@8:	call	_ArcData, esi, ebx
	clc
	leave
	ret

@@9:	stc
	leave
	ret

@@2:	mov	eax, [esi]
	sub	ebx, 8
	cmp	eax, 'CNEE'
	jne	@@3
	cmp	[esi+4], ecx
	jne	@@9
	call	@@5
	jmp	@@8

@@3:	cmp	eax, 'ZNEE'
	jne	@@9
	call	_MemAlloc, dword ptr [esi+4]
	jc	@@9
	xchg	edi, eax
	call	@@5
	call	_zlib_unpack, edi, dword ptr [esi+4], esi, ebx
	call	_ArcData, edi, eax
	call	_MemFree, edi
	clc
	leave
	ret

@@5:	lea	ecx, [ebx+3]
	mov	eax, [esi+4]
	add	esi, 8
	xor	eax, 0DEADBEEFh
	mov	edx, esi
	shr	ecx, 2
@@5a:	xor	[edx], eax
	add	edx, 4
	dec	ecx
	jne	@@5a
	ret
ENDP