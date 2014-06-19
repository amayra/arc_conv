
; "Moshimo Ashita ga Harenaraba" *.pak
; sysAdv.exe

	dw _conv_sysadv-$-2
_arc_sysadv PROC

@@S = dword ptr [ebp+8]
@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	enter	@@stk+0Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 0Bh
	jc	@@9a
	cmp	dword ptr [esi], 43415005h
	jne	@@9a
	cmp	word ptr [esi+4], 324Bh
	jne	@@9a
	mov	edi, [esi+6]
	lea	ecx, [edi-1]
	shr	ecx, 14h
	jne	@@9a
	mov	[@@N], edi
	movzx	eax, byte ptr [esi+0Ah]
	add	eax, 0Bh
	call	_FileSeek, [@@S], eax, 0
	jc	@@9a
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	call	_FileSeek, [@@S], 0Ah, 0
	jc	@@9a
	mov	ebx, [esi]
	sub	ebx, 0Ah
	jb	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	@@5
	test	eax, eax
	je	@@9
	mov	[@@N], eax
	call	_ArcCount, eax
	call	_ArcDbgData, esi, ebx

@@1:	xor	eax, eax
	lodsb
	push	eax
	push	esi
	lea	esi, [esi+eax+8]
	call	_ArcName
	and	[@@D], 0
	mov	ebx, [esi-4]
	call	_FileSeek, [@@S], dword ptr [esi-8], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5 PROC
	push	ebx
	push	esi
	xor	edx, edx
@@1:	sub	ebx, 9
	jb	@@9
	movzx	ecx, byte ptr [esi]
	inc	esi
	test	ecx, ecx
	je	@@3
@@2:	not	byte ptr [esi]
	inc	esi
	dec	ecx
	jne	@@2
@@3:	add	esi, 8
	inc	edx
	dec	edi
	jne	@@1
@@9:	xchg	eax, edx
	pop	esi
	pop	ebx
	ret
ENDP

ENDP

_conv_sysadv PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'agp'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	cmp	ebx, 1Ch
	jb	@@9
	mov	edx, 'HAGP'
	mov	ecx, 1700070Ah
	mov	eax, [esi]
	sub	edx, [esi+3]
	sub	ecx, [esi+7]
	sub	eax, 'PAGP'
	or	edx, ecx
	or	eax, edx
	jne	@@9
	add	ebx, 5
	call	_MemAlloc, ebx
	jc	@@9
	xchg	edi, eax
	push	edi
	mov	eax, 474E5089h
	stosd
	mov	eax, 0A1A0A0Dh
	stosd
	mov	eax, 0D000000h
	stosd
	mov	eax, 'RDHI'
	stosd
	lea	ecx, [ebx-10h]
	add	esi, 0Bh
	rep	movsb
	pop	edi
	call	_ArcSetExt, 'gnp'
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret
ENDP

