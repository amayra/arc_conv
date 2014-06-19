
; "Spirited Heart" *.rpa
; renpy\loader.py, cPickle.c

	dw 0
_arc_rpa3 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC
@M0 @@L0
@M0 @@L1
@M0 @@P
@M0 @@DC

	enter	@@stk+24h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 22h
	jc	@@9a
	pop	eax
	pop	edx
	sub	eax, '-APR'
	sub	edx, ' 0.3'
	or	eax, edx
	jne	@@9a
	pop	eax
	pop	edx
	sub	edx, eax
	sub	eax, '0000'
	or	eax, edx
	jne	@@9a
	add	esi, 10h
	call	@@3
	xchg	edi, eax
	lodsb
	cmp	al, 20h
	jne	@@9a
	call	@@3
	mov	[@@L0], eax
	lodsb
	cmp	al, 0Ah
	jne	@@9a
	call	_FileSeek, [@@S], 0, 2
	jc	@@9a
	sub	eax, edi
	jbe	@@9a
	xchg	edi, eax
	call	_FileSeek, [@@S], eax, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, edi, 0
	jc	@@9
	mov	esi, [@@M]
	call	_zlib_unpack, 0, -1, esi, edi
	jc	@@9
	xchg	ebx, eax
	call	_MemAlloc, ebx
	jc	@@9
	mov	[@@M], eax
	call	_zlib_unpack, eax, ebx, esi, edi
	xchg	edi, eax
	call	_MemFree, esi
	cmp	edi, ebx
	jne	@@9
	mov	[@@SC], ebx
	mov	esi, [@@M]
	call	@@5
	test	eax, eax
	je	@@9
	mov	[@@N], eax
	call	_ArcCount, eax
	call	_ArcDbgData, esi, ebx
	call	_ArcSetCP, 65001		; CP_UTF8

	sub	[@@SC], 2
	lodsw
@@1:	mov	ebx, [@@SC]
	sub	ebx, 9
	call	@@4		; 55
	cmp	al, 55h
	jne	@@9
	xor	eax, eax
	lodsb
	mov	edx, esi
	add	esi, eax
	call	_ArcName, edx, eax
	call	@@4		; 4A
	lodsd
	xor	eax, [@@L0]
	mov	[@@P], eax
	call	@@4		; 4A
	lodsd
	xor	eax, [@@L0]
	mov	[@@DC], eax
	and	[@@L1], 0
	call	@@4		; 55 86
	cmp	al, 55h
	jne	@@1b
	dec	ebx
	xor	eax, eax
	lodsb
	mov	[@@L1], eax
	mov	ecx, eax
	add	eax, 3
	and	eax, -4
	sub	esp, eax
	mov	edi, esp
	sub	ebx, ecx
	rep	movsb
	call	@@4		; 87
@@1b:	call	@@4		; 61
	mov	[@@SC], ebx
	mov	ebx, [@@DC]
	and	[@@D], 0
	test	ebx, ebx
	je	@@1a
	call	_FileSeek, [@@S], [@@P], 0
	jc	@@1a
	mov	edi, [@@L1]
	sub	ebx, edi
	jae	$+4
	xor	ebx, ebx
	lea	eax, [@@D]
	call	_ArcMemRead, eax, edi, ebx, 0
	lea	ebx, [edi+eax]
	mov	ecx, edi
	mov	eax, esp
	mov	edi, [@@D]
	xchg	eax, esi
	rep	movsb
	xchg	eax, esi
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	lea	esp, [ebp-@@stk]
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3:	push	8
	pop	ecx
@@3a:	lodsb
	sub	al, 30h
	cmp	al, 0Ah
	jb	@@3b
	or	al, 20h
	sub	al, 31h
	cmp	al, 6
	jae	@@9a
	add	al, 0Ah
@@3b:	shl	edx, 4
	add	dl, al
	dec	ecx
	jne	@@3a
	xchg	eax, edx
	ret

@@5:	push	ebx
	push	esi
	xor	ecx, ecx
	sub	ebx, 2
	jb	@@5c
	lodsw
	cmp	eax, 280h	; PROTO
	jne	@@5c
@@5a:	sub	ebx, 9
	jb	@@5c
	call	@@4
	cmp	al, 55h		; 'U' SHORT_BINSTRING
	jne	@@5c
	xor	eax, eax
	lodsb
	sub	ebx, eax
	jb	@@5c
	add	esi, eax
	call	@@4
	cmp	al, 4Ah		; 'J' BININT
	jne	@@5c
	lodsd
	call	@@4
	cmp	al, 4Ah
	jne	@@5c
	lodsd
	call	@@4
	cmp	al, 86h		; TUPLE2
	je	@@5b
	cmp	al, 55h
	jne	@@5c
	dec	ebx
	js	@@5c
	xor	eax, eax
	lodsb
	sub	ebx, eax
	jb	@@5c
	add	esi, eax
	call	@@4
	cmp	al, 87h		; TUPLE3
	jne	@@5c
@@5b:	call	@@4
	inc	ecx
	cmp	al, 61h		; 'a' APPEND
	je	@@5a
@@5c:	xchg	eax, ecx
	pop	esi
	pop	ebx
	ret

@@4b:	sub	ebx, 3
	add	esi, 3
@@4a:	dec	ebx
	inc	esi
@@4:	dec	ebx
	js	@@4c
	lodsb
	cmp	al, 71h		; 'q' BINPUT
	je	@@4a
	cmp	al, 72h		; 'r' LONG_BINPUT
	je	@@4b
	cmp	al, 28h		; '(' MARK
	je	@@4
	cmp	al, 5Dh		; ']' EMPTY_LIST
	je	@@4
	cmp	al, 75h		; 'u' SETITEMS
	je	@@4
	cmp	al, 7Dh		; '}' EMPTY_DICT
	je	@@4
	ret
@@4c:	xor	eax, eax
	xor	ebx, ebx
	ret
ENDP
