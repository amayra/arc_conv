
; "Seinarukana -The Spirit of Eternity Sword 2-" *.4ag

; "Ten no Hikari wa Koi no Hoshi" *.wag
; Tenkoi.exe
; 0043285A wag_open

; "Barbaroi" HD\*.004

	dw 0
_arc_gaf4 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0
@M0 @@L1, 10h
@M0 @@L2
@M0 @@L3
@M0 @@L4
@M0 @@P

	enter	@@stk+144h, 0
	mov	[@@L0], esp
	mov	edi, esp
	sub	esp, 4Ch
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4Ah
	jc	@@9a
	mov	eax, [esi]
	movzx	edx, word ptr [esi+4]
	sub	eax, '4FAG'
	je	@@2a
	sub	eax, '@GAW'-'4FAG'
	cmp	dh, 3
	jne	@@9a
@@2a:	mov	[@@L4], edx
	sub	dh, 2
	shr	dh, 1
	or	eax, edx
	jne	@@9a
	mov	ecx, [esi+46h]
	lea	eax, [ecx-1]
	shr	eax, 14h
	jne	@@9a
	mov	[@@N], ecx

	call	_unicode_name, offset inFileName
	xchg	edx, eax
	push	0
	lea	eax, [ecx+ecx]
	and	eax, -4
	sub	esp, eax
	call	_unicode_to_ansi, 932, edx, ecx, esp
	cmp	byte ptr [@@L4+1], 2
	je	@@2d
	call	_sjis_lower, esp
@@2d:	mov	edx, esp
	call	@@Hash, edx, edi
	mov	esp, edi
	call	@@Rotate, edi	; eax, edx
	add	edx, eax
	add	eax, 4Ah
	mov	[@@L1], eax

	mov	ecx, [@@N]
	lea	ebx, [edx+ecx*4+4Ch]
	call	_FileSeek, [@@S], 0, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_xarc_crc16, esi, ebx
	jc	@@9
	mov	eax, [@@L1]
	mov	ebx, [@@N]
	lea	edi, [esi+eax]
	call	@@Offset, edi, ebx, eax, esp
	shl	ebx, 2
	call	_ArcCount, [@@N]
	call	_ArcDbgData, edi, ebx

	lea	edx, [esi+6]
	mov	byte ptr [esi+46h], 0
	call	@@Hash, edx, esp

	mov	esi, edi
@@1:	and	[@@D], 0
	mov	eax, [esi]
	mov	[@@P], eax
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	edi, [@@L1]
	cmp	byte ptr [@@L4+1], 2
	je	@@2b
	call	@@3, 0Ah
	jc	@@1a
	mov	ebx, [edi+4]
	cmp	dword ptr [edi], 'TESD'
	jne	@@1a
	mov	[@@L2], ebx
	cmp	ebx, 10h
	jae	@@1a
@@1b:	lea	edi, [@@L1]
	dec	[@@L2]
	js	@@1a
	call	@@3, 0Ah
	jc	@@1a
	mov	eax, [edi]
	mov	ebx, [edi+4]
	cmp	eax, 'TCIP'
	jne	@@1d
	sub	ebx, 6
	jb	@@1a
	call	@@3, 6
	jc	@@1a
	cmp	[@@D], 0
	jne	@@1c
	cmp	ebx, 0Eh
	jb	@@1c
	sub	ebx, 0Eh
	je	@@1e
	call	_MemAlloc, ebx
	jc	@@1a
	xchg	edi, eax
	call	_FileRead, [@@S], edi, ebx
	call	@@Crypt, edi, ebx, [@@P], [@@L0]
	add	[@@P], ebx
@@1e:	mov	[@@D], edi
	mov	[@@L3], ebx
	push	0Eh
	pop	ebx

@@1c:	call	_FileSeek, [@@S], ebx, 1
	jc	@@1a
	add	[@@P], ebx
	jmp	@@1b

@@1d:	cmp	eax, 'GATF'
	jne	@@1c
	cmp	ebx, 200h
	jae	@@1a
	lea	eax, [ebx+3]
	and	eax, -4
	sub	esp, eax
	mov	edi, esp
	call	@@3, ebx
	jc	@@1a
	lea	ecx, [ebx-2]
	call	_ArcName, edi, ecx
	mov	esp, [@@L0]
	jmp	@@1b

@@1a:	mov	ebx, [@@L3]
	mov	esp, [@@L0]
	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 4
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2b:	and	[@@L3], 0
	call	_FileRead, [@@S], edi, 10h
	jc	@@1a
	call	@@Crypt, edi, 10h, [@@P], [@@L0]
	add	[@@P], 10h
	mov	ebx, [edi]
	add	ebx, [edi+4]
	jc	@@1a
	call	_MemAlloc, ebx
	jc	@@1a
	mov	[@@D], eax
	xchg	edi, eax
	call	_FileRead, [@@S], edi, ebx
	xchg	ebx, eax
	call	@@Crypt, edi, ebx, [@@P], [@@L0]
	mov	eax, [@@L1]
	cmp	eax, ebx
	jb	$+4
	mov	eax, ebx
	mov	[@@L3], eax
	sub	ebx, eax
	je	@@2c
	dec	ebx
	je	@@2c
	lea	edx, [edi+eax]
	call	_ArcName, edx, ebx
@@2c:	jmp	@@1a

@@3:	push	ebx
	mov	ebx, [esp+8]
	cmp	ebx, 2
	jb	@@3a
	call	_FileRead, [@@S], edi, ebx
	jc	@@3a
	call	_xarc_crc16, edi, ebx
	jc	@@3a
	lea	ecx, [ebx-2]
	call	@@Crypt, edi, ecx, [@@P], [@@L0]
	add	[@@P], ebx
	clc
@@3a:	pop	ebx
	ret

@@Crypt PROC

@@D = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]
@@P = dword ptr [ebp+1Ch]
@@B = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@D]
	mov	ebx, [@@B]
	xor	esi, esi
@@1:	mov	ecx, [ebx]
	mov	eax, [@@P]
	dec	ecx
	add	eax, esi
	xor	edx, edx
	div	ecx
	mov	al, [ebx+4+edx]
	xor	[edi+esi], al
	inc	esi
	cmp	esi, [@@C]
	jb	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

@@Offset PROC

@@D = dword ptr [ebp+14h]
@@N = dword ptr [ebp+18h]
@@P = dword ptr [ebp+1Ch]
@@B = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@N]
	mov	ebx, [@@B]
	shl	edi, 2
	dec	edi
	xor	esi, esi
@@1:	mov	eax, [@@P]
	xor	edx, edx
	add	eax, esi
	div	edi
	xchg	eax, edx
	xor	edx, edx
	mov	ecx, eax
	div	dword ptr [ebx]
	mov	al, [ebx+4+edx]
	add	al, cl
	inc	edx
	cmp	edx, [ebx]
	sbb	ecx, ecx
	and	edx, ecx
	xor	al, [ebx+4+edx]
	mov	edx, [@@D]
	add	eax, [@@N]
	xor	[edx+esi], al
	inc	esi
	cmp	esi, edi
	jbe	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

@@Rotate PROC	; 00425AB0
	push	ebx
	push	esi
	push	edi
	mov	ebx, [esp+10h]
	lea	esi, [ebx+4]
	xor	edx, edx
	xor	ecx, ecx
	mov	edi, [ebx]
@@1:	movzx	eax, byte ptr [esi]
	inc	esi
	xor	edx, eax
	add	ecx, eax
	ror	edx, 1
	dec	edi
	jne	@@1
	mov	edi, 200h
	lea	eax, [edi+ecx]
	lea	esi, [edi+edi+1]
	sub	edi, ecx
	and	ecx, 1Fh
	ror	edi, cl
	mov	ecx, [ebx]
	and	ecx, 1Fh
	ror	eax, cl
	xor	eax, edx
	ror	eax, cl
	xor	eax, edx
	ror	edi, cl
	xor	edi, edx
	shr	ecx, 1
	sbb	ecx, ecx
	xor	edi, ecx
	xor	edx, edx
	div	esi
	xchg	eax, edi
	push	edx
	xor	edx, edx
	div	esi
	pop	eax
	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP

@@Hash PROC

@@S = dword ptr [ebp+14h]
@@D = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@S]
	xor	ebx, ebx
	xor	edx, edx
	mov	edi, esi
	or	ecx, -1
	xor	eax, eax
	repne	scasb
	not	ecx
	dec	ecx
	cmp	ecx, 1
	adc	ecx, 0
@@1:	movsx	edi, byte ptr [esi+eax]		; ???
	add	edx, edi
	add	edi, eax
	xor	ebx, edi
	inc	eax
	add	ebx, ecx
	cmp	eax, ecx
	jb	@@1
	mov	edi, [@@D]
	movzx	eax, bl
	add	ebx, edx
	add	eax, 40h
	stosd
	dec	eax
	mov	[@@S], ecx
	mov	[@@D], eax
	mov	eax, 8846FF0Fh
	and	ebx, eax
	mov	ax, bx
	stosd
	push	4
	pop	ecx
@@2:	mov	eax, ecx
	cdq
	div	[@@S]
	mov	al, [esi+edx]
	xor	eax, ebx
	add	ebx, ecx
	add	eax, ebx
	stosb
	inc	ecx
	xchg	ebx, eax
	cmp	ecx, [@@D]
	jb	@@2
	xor	eax, eax
	stosb
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

ENDP
