
; "France Shoujo ~Une fille blanche~" Data\*.dat

_mod_ddp2 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N

	lea	esp, [ebp-@@stk-18h]
	cmp	edi, 4
	jae	@@9a
	mov	esi, esp
	call	_FileRead, [@@S], esi, 18h
	jc	@@9a
	shr	edi, 1
	jc	@@2b
	shl	ebx, 4
	pop	ecx
	sub	ecx, 20h
	cmp	ebx, ecx
	jne	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ArcCount, [@@N]
@@2a:	call	@@1
	add	esi, 10h
	jmp	@@2a

@@2b:	shl	ebx, 3
	lea	ecx, [ebx+20h]
	pop	ebx
	cmp	ebx, ecx
	jb	@@9a
	sub	ebx, 20h

	lea	eax, [@@M]
	call	_ArcMemRead, eax, 20h, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ddp_check, 20h, 11h, esi, ebx, [@@N]
	lea	ecx, [eax-1]
	shr	ecx, 14h
	jne	@@9
	mov	[@@N], eax
	call	_ArcCount, eax
	add	esi, 20h-8
@@2c:	add	esi, 8
	mov	ebx, [esi+4]
	test	ebx, ebx
	je	@@2c
	push	esi
	mov	esi, [esi]
@@2d:	movzx	ecx, byte ptr [esi]
	lea	edx, [esi+11h]
	sub	ebx, ecx
	sub	ecx, 11h

	; "Shingakkou -Noli me tangere-"
	xor	eax, eax
	cmp	ecx, 2
	jb	@@2e
	cmp	[edx+ecx-2], ax
	jne	@@2e
	shr	ecx, 1
	inc	eax
@@2e:	push	ecx
	push	edx
	call	_ArcUnicode, eax
	call	_ArcName
	push	ebx
	inc	esi
	call	@@1
	dec	esi
	pop	ebx
	movzx	ecx, byte ptr [esi]
	add	esi, ecx
	test	ebx, ebx
	jne	@@2d
	pop	esi
	jmp	@@2c

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@1:	mov	eax, [esi]
	test	eax, eax
	je	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	mov	ebx, [esi+8]
	mov	edi, [esi+4]
	test	ebx, ebx
	jne	$+4
	xchg	ebx, edi
	lea	eax, [@@D]
	call	_ArcMemRead, eax, edi, ebx, 0
	xchg	ebx, eax
	cmp	dword ptr [esi+8], 0
	je	@@1a
	call	_ddp_unpack, [@@D], edi, edx, ebx
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	je	@@9
	ret
ENDP

; "Sweet Home ~H na oneesan wa suki desu ka?~" *.hxp

; Startup.exe
; 004049E9 hxp_open
; 00404D0B hxp_unpack

; "DDSystem"

	dw _conv_ddp-$-2
_arc_ddp PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC
@M0 @@L0, 8

	enter	@@stk+8, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 8
	jc	@@9a
	pop	eax
	pop	ebx
	mov	edi, '0PDD'
	cmp	al, 'D'
	je	$+7
	mov	edi, '6SHS'
	sub	eax, edi
	lea	edx, [ebx-1]
	bswap	eax
	shr	edx, 14h
	jne	@@9a
	mov	[@@N], ebx
	mov	edi, eax
	shr	eax, 1
	jne	_mod_ddp2
	jc	@@2b
	shl	ebx, 2
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	lea	eax, [ebx+8]
	cmp	[esi], eax
	jne	@@9
	call	_ArcCount, [@@N]
@@2a:	lodsd
	test	eax, eax
	je	@@2e
	call	@@1
	jmp	@@2a

@@2e:	call	_ArcSkip, 1
	jmp	@@2a

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@1:	and	[@@D], 0
	test	eax, eax
	je	@@1a
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	lea	edx, [@@L0]
	call	_FileRead, [@@S], edx, 8
	jc	@@1a
	mov	ebx, [@@L0]
	mov	edi, [@@L0+4]
	test	ebx, ebx
	jne	$+4
	xchg	ebx, edi
	lea	eax, [@@D]
	call	_ArcMemRead, eax, edi, ebx, 0
	xchg	ebx, eax
	cmp	[@@L0], 0
	je	@@1a
	call	_ddp_unpack, [@@D], edi, edx, ebx
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	je	@@9
	ret

@@2b:	mov	edi, ebx
	shl	ebx, 3
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	add	ebx, 8
	call	@@6
	test	edi, edi
	jne	@@9
	call	_MemFree, [@@M]
	mov	[@@SC], ebx
	call	_FileSeek, [@@S], 0, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	call	_ddp_check, 8, 5, esi, ebx, [@@N]
	lea	ecx, [eax-1]
	shr	ecx, 14h
	jne	@@9
	mov	[@@N], eax
	call	_ArcCount, eax

@@2c:	add	esi, 8
	mov	ebx, [esi+4]
	test	ebx, ebx
	je	@@2c
	push	esi
	mov	esi, [esi]
@@2d:	movzx	edi, byte ptr [esi]
	add	esi, 5
	sub	ebx, edi
	sub	edi, 5
	call	_ArcName, esi, edi
	mov	eax, [esi-4]
	add	esi, edi
	bswap	eax
	push	ebx
	call	@@1
	pop	ebx
	test	ebx, ebx
	jne	@@2d
	pop	esi
	jmp	@@2c

@@6 PROC
@@1:	mov	eax, [esi]
	test	eax, eax
	je	@@2
	add	eax, [esi+4]
	jc	@@9
	cmp	ebx, eax
	jae	$+3
	mov	ebx, eax
@@2:	add	esi, 8
	dec	edi
	jne	@@1
@@9:	ret
ENDP

ENDP

_ddp_check PROC

@@X = dword ptr [ebp+14h]
@@A = dword ptr [ebp+18h]
@@S = dword ptr [ebp+1Ch]
@@C = dword ptr [ebp+20h]
@@N = dword ptr [ebp+24h]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@X]
	mov	eax, [@@N]
	mov	esi, [@@S]
	lea	eax, [edi+eax*8]
	add	edi, esi
	xor	ebx, ebx
	push	eax
@@1:	mov	ecx, [edi]
	mov	edx, [edi+4]
	mov	eax, [@@C]
	cmp	edx, [@@L0]
	jb	@@3
	sub	eax, edx
	jb	@@3
	cmp	eax, ecx
	jb	@@3
@@2:	cmp	ecx, [@@A]
	jb	@@3
	movzx	eax, byte ptr [esi+edx]
	sub	ecx, eax
	jb	@@3
	cmp	eax, [@@A]
	jb	@@3
	add	edx, eax
	inc	ebx
	jmp	@@2

@@3:	mov	eax, [edi+4]
	sub	edx, eax
	add	eax, esi
	stosd
	xchg	eax, edx
	stosd
	dec	[@@N]
	jne	@@1
	xchg	eax, ebx
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	14h
ENDP

_ddp_unpack PROC

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
@@1:	xor	eax, eax
	cmp	[@@DC], eax
	je	@@7
	dec	[@@SC]
	js	@@9
	lodsb
	cmp	al, 20h
	jae	@@2a
	lea	ecx, [eax+1]
	sub	al, 1Ch
	jbe	@@1b
	sub	[@@SC], eax
	jb	@@9
	cmp	al, 2
	jb	@@1a
	jne	@@1c
	lodsb
	inc	eax
	shl	eax, 8
@@1a:	lodsb
	lea	ecx, [eax+1Eh]
@@1b:	sub	[@@DC], ecx
	jb	@@9
	sub	[@@SC], ecx
	jb	@@9
	rep	movsb
	jmp	@@1

@@1c:	dec	[@@SC]
	js	@@9
	lodsd
	bswap	eax
	xchg	ecx, eax
	jmp	@@1b

@@2a:	test	al, al
	jns	@@2b
	lea	ecx, [eax-80h]
	and	al, 1Fh
	shr	ecx, 5
	mov	ah, al
	dec	[@@SC]
	js	@@9
	lodsb
	xchg	edx, eax
	jmp	@@2e

@@2b:	mov	ecx, eax
	and	eax, 1Fh
	shr	ecx, 5
	dec	ecx
	jne	@@2c
	mov	edx, eax
	and	eax, 3
	shr	edx, 2
	xchg	ecx, eax
	jmp	@@2e

@@2c:	dec	[@@SC]
	js	@@9
	movzx	edx, byte ptr [esi]
	inc	esi
	dec	ecx
	je	@@2d
	mov	dh, al
	dec	[@@SC]
	js	@@9
	lodsb
	cmp	al, 0FEh
	jb	@@2d
	jne	@@2f
	sub	[@@SC], 2
	jb	@@9
	lodsw
	xchg	al, ah
	add	eax, 0FEh
@@2d:	lea	ecx, [eax+4]
@@2e:	add	ecx, 3
	not	edx
	sub	[@@DC], ecx
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

@@2f:	sub	[@@SC], 4
	jb	@@9
	lodsd
	bswap	eax
	xchg	ecx, eax
	jmp	@@2e

@@7:	xor	esi, esi
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

_conv_ddp PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 8
	jb	@@9
	mov	eax, [esi]
	mov	edx, [esi+4]
	sub	eax, 'SggO'
	sub	dh, 2
	or	eax, edx
	jne	@@1
	mov	ecx, 'ggo'
@@8:	call	_ArcSetExt, ecx
@@9:	stc
	leave
	ret

@@1:	mov	ecx, 'ncs'
	mov	edx, 'CSs'
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, 'ySHS'
	or	eax, edx
	je	@@8
	mov	eax, [esi+4]
	cmp	dword ptr [esi], 'uWDD'
	je	@@1b
	cmp	dword ptr [esi], 'xSDD'
	jne	@@1a
@@1b:	cmp	eax, 'tpS'
	je	@@8
	cmp	eax, 'BXH'
	jne	@@1a
	push	ecx
	call	@@HXB, esi, ebx
	pop	ecx
	jmp	@@8

@@1a:	cmp	ebx, 12h
	jb	@@9
	mov	eax, [esi]
	ror	eax, 10h
	and	al, NOT 8
	mov	ecx, 'agt'
	cmp	eax, 2
	jne	@@2
	movzx	eax, word ptr [esi+10h]
	cmp	eax, 18h
	je	@@8
	and	ah, NOT 8
	cmp	eax, 20h
	je	@@8
@@2:	cmp	ebx, 36h
	jb	@@9
	cmp	word ptr [esi], 'MB'
	jne	@@9
	cmp	dword ptr [esi+0Eh], 28h
	jne	@@9
	mov	ecx, 'pmb'
	jmp	@@8

@@HXB PROC
	mov	ecx, [esp+8]
	mov	eax, ecx
	lea	edx, [ecx+6F349h]
	shl	eax, 5
	xor	al, 0A5h
	imul	eax, edx
	mov	edx, [esp+4]
	xor	eax, 34A9B129h
	cmp	ecx, 10h
	jbe	@@9
	sub	ecx, 10h-3
	sar	ecx, 2
@@1:	xor	[edx+10h], eax
	add	edx, 4
	dec	ecx
	jne	@@1
@@9:	ret	8
ENDP

ENDP
