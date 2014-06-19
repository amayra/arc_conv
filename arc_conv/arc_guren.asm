
; "Asgaldh" data\gdata.pkd
; "Guren" data\*.pkd

	dw _conv_guren-$-2
_arc_asgaldh PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P

	enter	@@stk+14h, 0
	mov	esi, esp
	push	14h
	pop	edi
	call	_FileRead, [@@S], esi, edi
	jc	@@9a
	pop	eax
	pop	edx
	sub	eax, 4000D7E9h
	dec	edx
	or	eax, edx
	mov	ebx, 10Ch
	jmp	@@2a

	dw _conv_guren-$-2
_arc_guren:
	enter	@@stk+10h, 0
	mov	esi, esp
	push	10h
	pop	edi
	call	_FileRead, [@@S], esi, edi
	jc	@@9a
	pop	eax
	push	2Ch
	pop	ebx
	dec	eax
@@2a:	pop	edx	; packed_count
	pop	ecx	; file_count
	neg	edi
	cmp	ecx, edx
	jb	@@9a
	pop	edx
	mov	[@@P], edx
	mov	[@@N], ecx
	add	edi, edx
	push	ebx
	imul	ebx, ecx
	dec	ecx
	sub	edi, ebx
	shr	ecx, 14h
	or	eax, edi
	or	eax, ecx
	jne	@@9a
	pop	edi
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	byte ptr [esi], 0
	je	@@9
	call	_ArcCount, [@@N]

@@1:	call	_ArcName, esi, edi
	and	[@@D], 0
	add	esi, edi
	mov	eax, [esi-0Ch]
	mov	ebx, [esi-8]
	add	eax, [@@P]
	jc	@@9
	call	_FileSeek, [@@S], eax, 0
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
ENDP

; size = 1FC40h
; 01 00 00 00		; 44Ch
; 80 02 00 00 width	; 450h
; E0 01 00 00 height	; 454h
; 24 08 00 00		; 458h
; 1C F8 01 00 size-424h	; 45Ch
; 00 B0 04 00 width*height	; 460h
; dd 100h dup(?)		; 464h
; dd 0,1,1	; 864h, 868h, 86Ch

_conv_guren PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, '_mb'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 424h
	jb	@@9
	mov	edx, 824h
	mov	eax, [esi]
	sub	edx, [esi+0Ch]
	shr	eax, 1
	or	eax, edx
	jne	@@9
	mov	[@@SC], ebx
	mov	edi, [esi+4]
	mov	edx, [esi+8]
	mov	ebx, edi
	imul	ebx, edx
	cmp	[esi+14h], ebx
	jne	@@9
	call	_ArcTgaAlloc, 38h, edi, edx
	xchg	edi, eax
	mov	edx, [esi]
	add	esi, 18h
	add	edi, 12h
	mov	ecx, 100h
	rep	movsd
	lodsd
	add	esi, 8
	dec	edx
	je	@@1a
	mov	ecx, ebx
	rep	movsb
	jmp	@@1b

@@1a:	call	@@Unpack, edi, ebx, esi, [@@SC], eax
@@1b:	clc
	leave
	ret

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@L0 = dword ptr [ebp+24h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	mov	ebx, [@@L0]
@@1:	cmp	[@@DC], 0
	je	@@7
	dec	[@@SC]
	js	@@9
	lodsb
	cmp	al, bl
	jne	@@1a
	dec	[@@SC]
	js	@@9
	movzx	ecx, byte ptr [esi]
	inc	esi
	test	ecx, ecx
	jne	@@1b
@@1a:	dec	[@@DC]
	stosb
	jmp	@@1

@@1b:	cmp	cl, 1
	jne	@@1c
	add	ecx, 0FFh
	cmp	[@@DC], ecx
	jb	@@9
	dec	[@@SC]
	js	@@9
	mov	cl, [esi]
	inc	esi
	jmp	@@1b

@@1c:	jb	@@1d
	dec	[@@SC]
	js	@@9
	lodsb
	test	al, al
	jne	@@9
@@1d:	sub	[@@DC], ecx
	jb	@@9
	dec	[@@SC]
	js	@@9
	lodsb
	rep	stosb
	jmp	@@1

@@7:	xor	esi, esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

ENDP