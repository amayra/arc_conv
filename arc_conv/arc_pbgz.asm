
; "Touhou 8 - Imperishable Night" *.dat

	dw 0
_arc_pbgz PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC
@M0 @@L0
@M0 @@L1

	enter	@@stk+10h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	pop	eax
	cmp	eax, 'ZGBP'
	jne	@@9a
	add	esi, 4
	call	_pbg_decode, esi, 0Ch, 0C371Bh
	sub	dword ptr [esi], 1E240h
	sub	dword ptr [esi+4], 5464Eh
	sub	dword ptr [esi+8], 8AA53h
	mov	ebx, [esi]
	lea	eax, [ebx-1]
	mov	[@@N], ebx
	shr	eax, 14h
	jne	@@9a
	call	_FileSeek, [@@S], 0, 2
	jc	@@9a
	xchg	edi, eax
	mov	eax, [esi+4]
	mov	ebx, [esi+8]
	sub	edi, eax
	jbe	@@9a
	mov	[@@L1], eax
	call	_FileSeek, [@@S], eax, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, ebx, edi, 0
	jc	@@9
	mov	esi, [@@M]
	push	eax
	push	edx
	mov	ecx, 400h
	cmp	eax, ecx
	jb	$+4
	xchg	eax, ecx
	call	_pbg_decode, edx, eax, 809B3Eh
	call	_pbg_unpack, esi, ebx
	cmp	eax, ebx
	jne	@@9
	mov	[@@SC], ebx
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, ebx

	call	_ArcParamNum, 1
	db 'pbgz', 0
	dec	eax
	cmp	eax, 2
	sbb	edx, edx
	shl	eax, 5
	add	eax, offset @@T+18h
	and	eax, edx
	mov	[@@L0], eax

@@1:	mov	ecx, [@@SC]
	mov	edi, esi
	sub	ecx, 0Ch
	jbe	@@9
	xor	eax, eax
	repne	scasb
	jne	@@9
	push	ecx
	call	_ArcName, esi, -1
	pop	ecx
	lea	esi, [edi+0Ch]
	mov	[@@SC], ecx
	mov	edi, [@@L1]
	cmp	[@@N], 1
	je	@@1b
	test	ecx, ecx
	je	@@1b
	mov	edi, esi
	repne	scasb
	jne	@@1b
	cmp	ecx, 4
	jb	@@1b
	mov	edi, [edi]
@@1b:	mov	eax, [esi-0Ch]
	mov	ebx, [esi-8]
	and	[@@D], 0
	sub	edi, eax
	jbe	@@1a
	test	ebx, ebx
	je	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, ebx, edi, 0
	call	_pbg_unpack, [@@D], ebx, edx, eax
	xchg	ebx, eax
	cmp	ebx, 4
	jbe	@@1a
	mov	edi, [@@D]
	mov	eax, [edi]
	shl	eax, 8
	cmp	eax, 7A646500h		; "edz"
	jne	@@1a
	mov	al, [edi+3]
	push	8
	pop	ecx
	mov	edi, offset @@T
	repne	scasb
	jne	@@1a
	add	edi, ecx
	movzx	edx, word ptr [edi+ecx*2]
	mov	edi, [@@L0]
	test	edi, edi
	je	@@1a
	mov	ecx, [edi+ecx*4]
	mov	eax, ecx
	shl	ecx, 10h
	shr	eax, 10h
	add	edx, ecx
	sub	ebx, 4
	mov	edi, [@@D]
	cmp	eax, ebx
	jb	$+4
	mov	eax, ebx
	add	edi, 4
	call	_pbg_decode, edi, eax, edx
	jmp	@@1c

@@1a:	mov	edi, [@@D]
@@1c:	call	_ArcData, edi, ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

_pbg_decode PROC	; 0043E1D0 (xor, add, block, max, ecx=src, edx=size)

@@SB = dword ptr [ebp+14h]
@@SC = dword ptr [ebp+18h]
@@L0 = dword ptr [ebp+1Ch]

@@M = dword ptr [ebp-4]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	push	0

	mov	eax, [@@SC]
	movzx	ecx, word ptr [@@L0+2]
	xor	edx, edx
	div	ecx
	shr	ecx, 2
	cmp	edx, ecx
	sbb	eax, eax
	and	edx, eax
	mov	eax, [@@SC]
	and	eax, 1
	add	eax, edx
	sub	[@@SC], eax

	mov	ecx, [@@SC]
	cmp	ecx, 8000h
	jb	@@4b
	call	_MemAlloc, ecx
	jc	@@9a
	mov	[@@M], eax
	xchg	edi, eax
	jmp	@@4c

@@4b:	add	ecx, 3
	and	ecx, -4
	mov	eax, -1000h
	add	ecx, eax
	jnc	@@4a
@@4:	lea	esp, [esp+eax+4]
	push	eax
	add	ecx, eax
	jc	@@4
@@4a:	sub	ecx, eax
	sub	esp, ecx
	mov	edi, esp
@@4c:
	mov	esi, [@@SB]
	mov	ebx, [@@SC]
	mov	ah, byte ptr [@@L0]
	test	ebx, ebx
	je	@@9
@@1:	movzx	ecx, word ptr [@@L0+2]
	cmp	ecx, ebx
	jb	@@1a
	mov	ecx, ebx
@@1a:	sub	ebx, ecx
	add	edi, ecx
	push	ecx
	inc	ecx
	shr	ecx, 1
	je	@@2a
	lea	edx, [edi-1]
@@2:	lodsb
	xor	al, ah
	mov	[edx], al
	sub	edx, 2
	add	ah, byte ptr [@@L0+1]
	dec	ecx
	jne	@@2
@@2a:	pop	ecx
	shr	ecx, 1
	je	@@3b
	lea	edx, [edi-2]
@@3:	lodsb
	xor	al, ah
	mov	[edx], al
	sub	edx, 2
	add	ah, byte ptr [@@L0+1]
	dec	ecx
	jne	@@3
@@3b:	test	ebx, ebx
	jne	@@1
@@9:	mov	esi, [@@M]
	mov	edi, [@@SB]
	mov	ecx, [@@SC]
	test	esi, esi
	mov	eax, esi
	jne	$+4
	mov	esi, esp
	rep	movsb
	test	eax, eax
	je	@@9a
	call	_MemFree, eax
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

ALIGN 8
@@T:	db 2Ah,2Dh,57h,45h,4Ah,41h,54h,4Dh	; inverse order
	dw 0371Bh,0E951h,051C1h,01903h
	dw 0CDABh,03412h,09735h,03799h

	; th8
	dw 0040h,2800h
	dw 0040h,3000h
	dw 1400h,2800h	; 2000h
	dw 1400h,7800h
	dw 0200h,1000h
	dw 0400h,2800h
	dw 0080h,2800h
	dw 0400h,1000h

	; th9
	dw 0040h,2800h
	dw 0040h,3000h
	dw 0400h,0400h	; *
	dw 0400h,0400h	; *
	dw 0200h,1000h
	dw 0400h,0400h	; *
	dw 0080h,2800h
	dw 0400h,1000h

;	dd 0AA371B5Dh,0BBE95174h,0CC51C171h,0DD19038Ah
;	dd 0EECDAB95h,0FF3412B7h,01197359Dh,0773799AAh
ENDP
