
; "Shitsu Raku No Kami Onna" *.pmp

	dw _conv_pmp-$-2
_arc_pmp:
	ret
_conv_pmp PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'pmp'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	cmp	ebx, 6
	jbe	@@9
	mov	edx, esi
	mov	ecx, ebx
@@1a:	xor	byte ptr [edx], 21h
	inc	edx
	dec	ecx
	jne	@@1a
	sub	esp, 38h
	mov	edi, esp
	call	_zlib_unpack, edi, 36h, esi, ebx
	cmp	eax, 36h
	jne	@@9
	movzx	eax, word ptr [edi]
	mov	ebx, [edi+2]
	mov	edx, [edi+0Eh]
	sub	eax, 'MB'
	sub	edx, 28h
	or	eax, edx
	jne	@@9
	cmp	ebx, edx
	jb	@@9
	cmp	ebx, [edi+0Ah]
	jb	@@9
	call	_MemAlloc, ebx
	jc	@@9
	xchg	edi, eax
	call	_zlib_unpack, edi, ebx, esi, [@@SC]
	xchg	ebx, eax
	call	_ArcSetExt, 'pmb'
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret
ENDP
