
; "Diadra Empty" data\*.pop
; "Yakouga 4" *.dat
; 00515910 setkey
; 00515A0C decode
; 005168A4 unpack
; "Desparaiso" dat\mqpdat?.dat
; mqplanet.exe
; 00489240 setkey
; 00489420 decode

; "Koumajou Densetsu 2" data\*.dat
; dirs: data\model.dat, data\language\Japanese.dat

; header:
; dd 'XD' + 30000h, dir_size, 18h
; dd dir_offs, dir_mid, dir_tail

; list:
; dd name_offset, attributes (10h=dir, 20h=file)
; dd time0, time0, time1, time1, time2, time2
; dd offset, size, packed (-1=raw)

; dir:
; dd list_offset, parent_offset (-1=root)
; dd file_count, child_list_offset

	dw 0
_arc_dx3 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L1, 0Ch
@M0 @@L0, 20h

	enter	@@stk, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 18h
	jc	@@9a
	call	_FileGetSize, [@@S]
	xchg	ebx, eax

	mov	edx, [esi+8]
	mov	eax, [esi]
	xor	edx, 18h	; header_size
	xor	eax, 35844h	; 'DX',3,0
	mov	[esi+8], edx
	mov	[esi], eax
	xor	eax, [esi+0Ch]
	xor	edx, [esi+14h]
	sub	ebx, eax
	mov	[esi+0Ch], eax
	mov	[esi+14h], edx
	mov	edi, ebx
	mov	[esi+18h], ebx	; dir_size
	sub	edi, edx
	ror	edi, 4
	lea	eax, [edi-1]
	shr	eax, 14h
	jne	@@9a
	xor	ebx, [esi+4]
	mov	[esi+4], ebx
	xor	ebx, [esi+10h]
	mov	[esi+10h], ebx
	cmp	ebx, edx
	jae	@@9a
	xchg	eax, edx
	xor	edx, edx
	sub	eax, ebx
	lea	ecx, [edx+2Ch]
	div	ecx
	mov	[@@N], eax
	sub	eax, edi
	mov	[@@L0+1Ch], eax
	dec	eax
	shr	eax, 14h
	or	eax, edx
	jne	@@9a

	mov	ebx, [@@L0+18h]
	call	_MemAlloc, ebx
	jc	@@9a
	mov	[@@M], eax
	xchg	esi, eax
	call	@@4, [@@L0+0Ch], ebx, esi
	jc	@@9
	mov	eax, [@@L0+14h]
	add	eax, esi
	call	@@Check, eax, edi
	cmp	eax, [@@N]
	jne	@@9
	call	_ArcCount, [@@L0+1Ch]
	mov	[@@L0+1Ch], edi

	push	dword ptr [@@L0+8]
	push	dword ptr [@@L0+4]
	push	dword ptr [@@L0]
	mov	edx, esp
	ror	byte ptr [edx+1], 4
	ror	byte ptr [edx+3], 4
	ror	byte ptr [edx+7], 5
	ror	byte ptr [edx+8], 3
	ror	byte ptr [edx+0Ah], 4
	xor	dword ptr [edx], 0FF8A00FFh
	xor	dword ptr [edx+4], 0FFFFACFFh
	xor	dword ptr [edx+8], 0CC6D7F00h
	call	_ArcDbgData, edx, 0Ch
	add	esp, 0Ch
	call	_ArcDbgData, esi, ebx

	mov	[@@L1+4], esp
	sub	esp, 200h
	mov	[@@L1], esp
	and	[@@L1+8], 0
@@2:	mov	edx, [@@M]
	mov	eax, [@@L1+8]
	add	edx, [@@L0+14h]
	shl	eax, 4
	mov	edi, esp
	lea	ebx, [edx+eax]
@@2a:	test	eax, eax
	je	@@2c
	push	dword ptr [edx+eax]
	mov	eax, [edx+eax+4]
	jmp	@@2a
@@2b:	pop	esi
	add	esi, [@@M]
	add	esi, [@@L0+10h]
	call	@@3
	jc	@@2d
	mov	byte ptr [edi-1], '\'
@@2c:	cmp	[@@L1], esp
	jne	@@2b
	mov	ecx, [ebx+8]
	mov	esi, [ebx+0Ch]
	test	ecx, ecx
	je	@@2d
	add	esi, [@@M]
	add	esi, [@@L0+10h]
	mov	[@@N], ecx

@@1:	test	byte ptr [esi+4], 10h
	jne	@@8
	push	edi
	push	esi
	call	@@3
	pop	esi
	pop	edi
	jc	@@8
	call	_ArcName, [@@L1], -1
	and	[@@D], 0
	mov	ebx, [esi+24h]
	mov	ecx, [esi+28h]
	test	ebx, ebx
	je	@@1a
	cmp	ecx, -1
	jne	@@1c
	call	_MemAlloc, ebx
	jc	@@1a
	mov	ecx, [esi+20h]
	mov	[@@D], eax
	add	ecx, 18h
	call	@@4, ecx, ebx, eax
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 2Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@2d:	mov	esp, [@@L1]
	inc	[@@L1+8]
	dec	[@@L0+1Ch]
	jne	@@2

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@1c:	lea	eax, [ebx+ecx]
	call	_MemAlloc, eax
	jc	@@1a
	mov	[@@D], eax
	add	eax, ebx
	mov	ecx, [esi+20h]
	push	eax
	add	ecx, 18h
	call	@@4, ecx, dword ptr [esi+28h], eax
	pop	edx
	call	@@Unpack, [@@D], ebx, edx, eax
	jmp	@@1b

@@3:	mov	edx, [@@L0+10h]
	mov	esi, [esi]
	sub	edx, esi
	jb	@@3b
	add	esi, [@@M]
	sub	edx, 4
	jb	@@3b
	movzx	ecx, word ptr [esi]
	add	esi, 4
	shl	ecx, 2
	je	@@3b
	lea	eax, [ecx+ecx]
	add	esi, ecx
	cmp	edx, eax
	jb	@@3b
	mov	edx, edi
@@3a:	cmp	edi, [@@L1+4]
	je	@@3b
	lodsb
	stosb
	test	al, al
	je	@@3c
	dec	ecx
	jne	@@3a
@@3b:	stc
	ret
@@3c:	cmp	edx, edi
	je	@@3b
	clc
	ret

@@4:	push	ebx
	push	esi
	call	_FileSeek, [@@S], dword ptr [esp+10h], 0
	jc	@@4b
	mov	ebx, [esp+10h]
	mov	esi, [esp+14h]
	call	_FileRead, [@@S], esi, ebx
	test	eax, eax
	je	@@4b
	xchg	ebx, eax
	mov	ecx, [esp+0Ch]
	mov	eax, 0AAAAAAABh
	mul	ecx
	shr	edx, 3
	imul	edx, 0Ch
	sub	ecx, edx
@@4a:	mov	al, byte ptr [@@L0+ecx]
	inc	ecx
	xor	[esi], al
	inc	esi
	cmp	ecx, 0Ch
	sbb	eax, eax
	and	ecx, eax
	dec	ebx
	jne	@@4a
@@4b:	sub	esi, [esp+14h]
	cmp	esi, [esp+10h]
	xchg	eax, esi
	pop	esi
	pop	ebx
	ret	0Ch

@@Check PROC

@@S = dword ptr [ebp+14h]
@@N = dword ptr [ebp+18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@S]
	xor	ecx, ecx
	xor	edi, edi
	inc	ecx
	lea	ebx, [edi+2Ch]
	cmp	dword ptr [esi+4], -1
	je	@@2
@@9:	xor	eax, eax
	jmp	@@8

@@1:	mov	eax, [esi+4]
	ror	eax, 4
	cmp	eax, edi
	jae	@@9
@@2:	mov	eax, [esi]
	imul	edx, ecx, 2Ch
	add	ecx, [esi+8]
	jc	@@9
	cmp	eax, edx
	jae	@@9
	cmp	[esi+0Ch], edx
	jne	@@9
	xor	edx, edx
	div	ebx
	test	edx, edx
	jne	@@9
	inc	edi
	add	esi, 10h
	cmp	edi, [@@N]
	jb	@@1
	xchg	eax, ecx
@@8:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP

@@Unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	sub	[@@SC], 9
	jb	@@9
	; [esi] = @@DC, [esi+4] = @@SC
	movzx	ebx, byte ptr [esi+8]
	add	esi, 9
@@1:	cmp	[@@DC], 0
	je	@@7
	dec	[@@SC]
	js	@@9
	xor	eax, eax
	lodsb
	cmp	eax, ebx
	je	@@1b
@@1a:	stosb
	dec	[@@DC]
	jmp	@@1

@@1b:	dec	[@@SC]
	js	@@9
	lodsb
	cmp	eax, ebx
	je	@@1a
	adc	eax, -1
	mov	ecx, eax
	mov	edx, eax
	shr	ecx, 3		; a & 4
	jnc	@@1c
	dec	[@@SC]
	js	@@9
	lodsb
	shl	eax, 5
	add	ecx, eax
@@1c:	xor	eax, eax
	add	ecx, 4
	and	edx, 3		; 3 unused
	jne	@@1d
	dec	[@@SC]
	js	@@9
	lodsb
	jmp	@@1f
@@1d:	dec	edx
	jne	@@1e
	sub	[@@SC], 2
	jb	@@9
	lodsw
	jmp	@@1f
@@1e:	dec	edx
	jne	@@1f
	sub	[@@SC], 3
	jb	@@9
	inc	esi
	lodsw
	shl	eax, 8
	mov	al, [esi-3]
@@1f:	xchg	edx, eax
	mov	eax, edi
	not	edx
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	push	esi
	lea	esi, [edi+edx]
	rep	movsb
	pop	esi
	jmp	@@1

@@7:	xor	esi, esi
@@9:	xchg	eax, edi
	mov	edx, [@@SC]
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

ENDP
