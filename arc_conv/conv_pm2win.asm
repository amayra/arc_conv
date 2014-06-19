
	dw _conv_pm2win-$-2
_arc_pm2win:
	ret
_conv_pm2win PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'tad'
	jne	@@9
	cmp	ebx, 8
	jb	@@9
	sub	ebx, 4
	lodsd
	xchg	edi, eax
	mov	eax, [esi]
	and	eax, 0FFFF03h
	cmp	eax, 04D4203h
	jne	@@9
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	call	_lzss_unpack, edi, eax, esi, ebx
	xchg	ebx, eax
	call	_ArcSetExt, 'pmb'
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

@@9:	stc
	leave
	ret
ENDP