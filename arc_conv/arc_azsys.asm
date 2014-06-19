
; "Lamune" *.arc
; lamune.exe
; 00406CB0 open_archive
; 0040A965 unpack
; 00430F6A script_decode
; 004213AF game_key(0x99E15CB4)

; "azsystem"

	dw _conv_azsys-$-2
_arc_azsys PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@P

	enter	@@stk+30h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 30h
	jc	@@9a
	pop	eax
	pop	edx	; fileext_count, max = 8
	pop	ecx
	pop	ebx
	sub	eax, 1A435241h
	lea	edx, [ecx-1]
	shr	edx, 14h
	or	eax, edx
	jne	@@9a
	lea	eax, [ebx+30h]
	mov	[@@N], ecx
	mov	[@@P], eax
	imul	edi, ecx, 30h
	lea	eax, [@@M]
	call	_ArcMemRead, eax, edi, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_azsys_unpack, esi, edi, edx, eax
	jc	@@9
	call	_ArcCount, [@@N]
	call	_ArcDbgData, esi, edi

@@1:	lea	edx, [esi+10h]
	call	_ArcName, edx, 20h
	and	[@@D], 0
	mov	eax, [esi]
	mov	ebx, [esi+4]
	add	eax, [@@P]
	jc	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 30h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret
ENDP

_conv_azsys PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'bpc'
	je	@@1
	cmp	eax, 'pam'
	je	@@2
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 20h
	jb	@@9
	cmp	dword ptr [esi], 1A425043h
	jne	@@9
	mov	eax, [esi+4]	; 1 - zlib, 3 - ?
	dec	eax
	and	eax, NOT 2
	ror	eax, 8+3
	movzx	ecx, al
	sub	eax, 3
	shr	eax, 1
	jne	@@9
	add	ecx, 20h-1
	movzx	edi, word ptr [esi+8]
	movzx	edx, word ptr [esi+0Ah]
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	call	@@CPB, edi, esi, ebx
	clc
	leave
	ret

@@2:	sub	ebx, 18h
	jb	@@9
	cmp	dword ptr [esi], 1A50414Dh
	jne	@@9
	sub	ebx, [esi+0Ch]
	jb	@@9
	sub	ebx, [esi+10h]
	jb	@@9
	sub	ebx, [esi+14h]
	jb	@@9
	mov	edi, [esi+4]
	mov	edx, [esi+8]
	call	_ArcTgaAlloc, 24h, edi, edx
	lea	edi, [eax+12h]
	call	@@MAP, edi, esi
	mov	eax, [esi+4]
	mov	ebx, [esi+8]
	mov	edx, eax
	neg	eax
	and	eax, 3
	je	@@2b
	mov	esi, edi
@@2a:	mov	ecx, edx
	rep	movsb
	add	esi, eax
	dec	ebx
	jne	@@2a
@@2b:	clc
	leave
	ret

@@MAP PROC

@@DB = dword ptr [ebp+14h]
@@SB = dword ptr [ebp+18h]

@@stk = 0
@M0 @@H
@M0 @@W
@M0 @@L0, 0Ch
@M0 @@N
@M0 @@M
@M0 @@L1, 8
@M0 @@L2

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	esi, [@@SB]
	mov	edi, [@@DB]
	mov	ecx, [esi+14h]
	mov	edx, [esi+8]
	mov	eax, [esi+4]
	shr	ecx, 1
	push	edx
	push	eax
	push	ecx
	push	dword ptr [esi+10h]
	push	dword ptr [esi+0Ch]
	add	esi, 18h
	add	eax, 3
	shr	eax, 2
	push	eax
	call	_MemAlloc, eax
	jc	@@9a
	push	eax	; @@M
	mov	edx, esi
	add	edx, [@@L0]
	push	edx
	add	edx, [@@L0+4]
	push	edx
	push	edi
	xchg	edi, eax
	mov	ecx, [@@N]
	xor	eax, eax
	rep	stosb
	pop	edi

@@2:	xor	ebx, ebx
	push	ebx	; @@L2
@@1:	mov	eax, [@@L2]
	shl	al, 1
	jne	@@1a
	dec	[@@L0]
	js	@@9
	lodsb
	stc
	adc	al, al
@@1a:	mov	[@@L2], eax
	mov	ecx, [@@M]
	jc	@@1b
	dec	[@@L0+4]
	js	@@9
	mov	edx, [@@L1+4]
	mov	al, [edx]
	inc	edx
	mov	[@@L1+4], edx
	mov	[ecx+ebx], al
@@1b:	movzx	eax, byte ptr [ecx+ebx]
	mov	ecx, eax
	shr	eax, 4
	and	ecx, 0Fh
	call	@@4
	stosw
	xchg	ecx, eax
	call	@@4
	stosw
	inc	ebx
	cmp	ebx, [@@N]
	jb	@@1
	pop	ecx
	dec	[@@H]
	jne	@@2
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@4:	test	eax, eax
	jne	@@4a
	mov	edx, [@@L1]
	dec	[@@L0+8]
	js	@@9
	movzx	eax, word ptr [edx]
	inc	edx
	inc	edx
	mov	[@@L1], edx
	ret

@@4a:	mov	al, [@@T+eax]
	mov	edx, eax
	shr	eax, 3
	and	edx, 7
	imul	eax, [@@W]
	lea	edx, [eax+edx*2]
	neg	edx
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	edx, [edi+edx]
	movzx	eax, word ptr [edx]
	ret

@@T	db 0*8,0*8+1,0*8+2,0*8+4
	db 1*8,1*8+1
	db 2*8,2*8+1,2*8+2
	db 4*8,4*8+1,4*8+2
	db 8*8,8*8+1,8*8+2,16*8
ENDP

@@CPB PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@C = dword ptr [ebp+1Ch]

@@N = dword ptr [ebp-4]
@@A = dword ptr [ebp-8]
@@M = dword ptr [ebp-0Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	esi, [@@S]
	movzx	ebx, word ptr [esi+8]
	movzx	edx, word ptr [esi+0Ah]
	movzx	ecx, byte ptr [esi+5]
	add	esi, 20h
	ror	ecx, 3
	imul	ebx, edx
	dec	ecx
	push	ebx
	push	ecx
	call	_MemAlloc, ebx
	jc	@@9
	push	eax	; @@M

	xor	ebx, ebx
@@1:	mov	edx, [@@S]
	mov	ecx, [edx+10h+ebx*4]
	mov	eax, [@@C]
	cmp	ecx, eax
	jb	$+3
	xchg	ecx, eax
	sub	[@@C], ecx
	mov	al, [edx+4]
	mov	edx, esi
	add	esi, ecx

	cmp	al, 1
	je	@@1a
	call	_azsys_unpack, [@@M], [@@N], edx, ecx
	jmp	@@1b
@@1a:	xor	eax, eax
	sub	ecx, 4
	jb	@@1b
	add	edx, 4
	call	_zlib_unpack, [@@M], [@@N], edx, ecx
@@1b:
	mov	edx, [@@A]
	test	eax, eax
	xchg	ecx, eax
	je	@@2a
	push	esi
	mov	edi, [@@D]
	mov	esi, [@@M]
	lea	eax, [ebx+ebx+2]	; ABGR -> ARGB
	and	eax, 2
	xor	eax, ebx
	add	edi, eax
@@2:	movsb
	add	edi, edx
	dec	ecx
	jne	@@2
	pop	esi
@@2a:	inc	ebx
	cmp	ebx, edx
	jbe	@@1

	call	_MemFree, [@@M]
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

ENDP

_azsys_unpack PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-0Ch]
@@L1 = dword ptr [ebp-10h]
@@L2 = dword ptr [ebp-14h]
@@L3 = dword ptr [ebp-18h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	sub	[@@SC], 14h
	jb	@@9
	add	esi, 14h
	call	_crc32@12, 0, esi, [@@SC]
	cmp	[esi-14h], eax
	jne	@@9
	mov	ecx, [esi-8]
	mov	edx, [esi-0Ch]
	mov	eax, [esi-10h]
	push	ecx
	push	edx
	push	eax
	add	ecx, eax
	add	eax, esi
	add	ecx, edx
	add	edx, eax
	cmp	[@@SC], ecx
	jne	@@9
	push	edx
	push	eax
	mov	eax, [esi-4]
	mov	ecx, [@@DC]
	cmp	eax, ecx
	jb	$+3
	xchg	eax, ecx
	push	eax
	sub	[@@DC], eax

	xor	ebx, ebx
@@1:	cmp	[@@L3], 0
	je	@@7
	shl	bl, 1
	jne	@@1a
	dec	[@@L0]
	js	@@9
	mov	bl, [esi]
	inc	esi
	stc
	adc	bl, bl
@@1a:	jc	@@1b
	dec	[@@L0+8]
	js	@@9
	mov	eax, [@@L1]
	movzx	ecx, byte ptr [eax]
	inc	eax
	inc	ecx
	sub	[@@L3], ecx
	jb	@@9
	sub	[@@L0+8], ecx
	jb	@@9
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	mov	[@@L1], eax
	jmp	@@1

@@1b:	mov	eax, [@@L2]
	sub	[@@L0+4], 2
	jb	@@9
	movzx	edx, word ptr [eax]
	inc	eax
	inc	eax
	mov	ecx, edx
	and	edx, 1FFFh
	shr	ecx, 0Dh
	not	edx
	add	ecx, 3
	mov	[@@L2], eax
	sub	[@@L3], ecx
	jb	@@9
	mov	eax, edi
	sub	eax, [@@DB]
	add	eax, edx
	jnc	@@9
	lea	eax, [edi+edx]
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@7:	mov	esi, [@@DC]
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP
