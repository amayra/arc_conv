
; "TropicalKiss" *.pak
; TSSystem.exe

	dw _conv_twinkle-$-2
_arc_twinkle PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	eax
	pop	ebx
	cmp	eax, 'KCAP'
	jne	@@9a
	cmp	ebx, 10h+28h
	jb	@@9
	sub	ebx, 8
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	@@5
	lea	ecx, [eax-1]
	shr	ecx, 14h
	jne	@@9
	call	_ArcCount, eax
	mov	[@@L0], esp
	sub	esp, 200h
	mov	[@@L1], esp

	mov	edi, esp
	add	ebx, 8
@@1:	lodsd
	test	eax, eax
	je	@@1c
	push	ebx
@@1a:	push	eax
	push	esi
	push	edi
	call	@@3
	jc	@@1b
	mov	byte ptr [edi-1], 2Fh
	mov	ebx, [esi+24h]
	mov	esi, [esi+20h]
	sub	esi, 8
	add	esi, [@@M]
	jmp	@@1

@@1b:	pop	edi
	pop	esi
	pop	eax
	add	esi, 28h
	dec	eax
	jne	@@1a
	pop	ebx
@@1c:	lodsd
	test	eax, eax
	je	@@1d
	mov	[@@N], eax
@@2:	push	ebx
	push	edi
	call	@@3
	pop	edi
	jc	@@8
	call	_ArcName, [@@L1], -1
	mov	eax, [esi+20h]
	add	eax, ebx
	mov	ebx, [esi+24h]
	and	[@@D], 0
	call	_FileSeek, [@@S], eax, 0
	jc	@@2a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@2a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	pop	ebx
	add	esi, 28h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@2
@@1d:	cmp	esp, [@@L1]
	jne	@@1b
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	xor	ecx, ecx
@@3a:	xor	eax, eax
	cmp	ecx, 20h
	jae	@@3b
	mov	al, [esi+ecx]
	inc	ecx
@@3b:	cmp	edi, [@@L0]
	je	@@3c
	stosb
	test	al, al
	jne	@@3a
	ret
@@3c:	stc
	ret

@@5 PROC
	push	ebx
	push	esi
	push	ebp
	mov	ebp, esp
	xor	ecx, ecx
	xor	esi, esi
@@1:	mov	ebx, [ebp+8]
	sub	ebx, esi
	jb	@@9
	add	esi, [ebp+4]
	sub	ebx, 8
	jb	@@9
	lodsd
	imul	edx, eax, 28h
	sub	ebx, edx
	jb	@@9
	test	eax, eax
	je	@@1c
@@1a:	mov	edx, ebp
	sub	edx, esp
	shr	edx, 8
	jne	@@9
	push	eax
	push	esi
	mov	esi, [esi+20h]
	sub	esi, 8
	jb	@@9
	jmp	@@1

@@1b:	pop	esi
	pop	eax
	add	esi, 28h
	dec	eax
	jne	@@1a
	mov	ebx, [ebp+4]
	add	ebx, [ebp+8]
	sub	ebx, esi
@@1c:	lodsd
	imul	edx, eax, 28h
	sub	ebx, edx
	jb	@@9
	add	ecx, eax
	cmp	esp, ebp
	jne	@@1b
	xchg	eax, ecx
	jmp	$+4
@@9:	xor	eax, eax
	leave
	pop	esi
	pop	ebx
	ret
ENDP

ENDP

_conv_twinkle PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 8
	jb	@@9
	cmp	eax, 'esh'
	je	@@1
	cmp	eax, 'fml'
	jne	@@9
	mov	ecx, 'gpm'
	cmp	dword ptr [esi], 046FF0000h
	je	@@1a
@@9:	stc
	leave
	ret

@@1:	mov	eax, 0B9B2B077h
	mov	edx, 0F6E6F6F3h
	sub	eax, [esi]
	sub	edx, [esi+4]
	or	eax, edx
	jne	@@9
	mov	ecx, 'gnp'
@@1a:	call	_ArcSetExt, ecx
	mov	edx, esi
@@1b:	neg	byte ptr [edx]
	inc	edx
	dec	ebx
	jne	@@1b
	call	_ArcData, esi, [@@SC]
	clc
	leave
	ret
ENDP
