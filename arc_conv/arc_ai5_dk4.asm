
; "Dragon Knight 4 - Windows Edition" *.arc
; AI5WIN.exe
; 00467750 reg_test
; 0040A170 arc_open
; 0045A6B0 mmo_open

	dw _conv_ai5_dk4-$-2
_arc_ai5_dk4 PROC
	mov	eax, 000290100h
	mov	ecx, 01663E1E9h
	mov	edx, 01BB6625Ch
	jmp	_mod_ai5
ENDP

_conv_ai5_dk4 PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'omm'
	je	@@2
	push	2
	pop	ecx
	call	@@1a
	db 'lib',0,'mes',0
@@1a:	pop	edi
	repne	scasd
	je	@@1
@@9:	stc
	leave
	ret

@@1:	call	_lzss_unpack, 0, -1, esi, ebx
	test	eax, eax
	xchg	edi, eax
	je	@@9
	call	_MemAlloc, edi
	jc	@@9
	xchg	edi, eax
	call	_lzss_unpack, edi, eax, esi, ebx
	xchg	ebx, eax
	call	_ArcData, edi, ebx
	call	_MemFree, edi
	clc
	leave
	ret

@@2:	sub	ebx, 28h
	jb	@@9
	cmp	dword ptr [esi], ' OMM'
	jne	@@9
	mov	[@@SC], ebx

	mov	edi, [esi+0Ch]
	mov	edx, [esi+10h]
	sub	edi, [esi+4]
	sub	edx, [esi+8]
	mov	ebx, edi
	imul	ebx, edx
	push	edx
	push	edi
	push	2
	pop	ecx
	cmp	dword ptr [esi+24h], 1
	sbb	ecx, -1
	call	_ArcTgaAlloc, ecx, edi, edx
	lea	edi, [eax+12h]
	mov	eax, [esi+8]
	shl	eax, 10h
	mov	ax, [esi+4]
	add	esi, 28h
	mov	[edi-12h+8], eax
	push	edi
	cmp	dword ptr [esi-4], 0
	je	@@2a
	add	edi, ebx
@@2a:	lea	ebx, [ebx*2+ebx]
	call	_lzss_unpack, edi, ebx, esi, [@@SC]
	xchg	eax, edi
	pop	edi
	pop	ecx
	pop	edx
	call	_ai6_add_top, eax, ecx, edx, 3

	mov	eax, [esi-4]
	test	eax, eax
	je	@@2b
	lea	edx, [esi+eax]
	mov	ecx, [@@SC]
	sub	ecx, eax
	jae	$+4
	xor	ecx, ecx
	sub	esi, 28h
	call	@@MMO, edi, esi, edx, ecx
@@2b:	clc
	leave
	ret

@@MMO PROC

@@D = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-20h]
@@M = dword ptr [ebp-24h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	edi, [esi+18h]
	mov	ecx, [esi+14h]
	mov	edx, [esi+20h]
	mov	eax, [esi+1Ch]
	sub	edx, edi
	sub	eax, ecx
	push	edx
	push	eax
	push	edi
	push	ecx
	mov	ecx, eax
	xor	ebx, ebx
	or	ecx, edx
	imul	eax, edx
	shr	ecx, 0Fh
	jne	@@2a
	xchg	ebx, eax
@@2a:	push	dword ptr [esi+10h]
	push	dword ptr [esi+0Ch]
	push	dword ptr [esi+8]
	push	dword ptr [esi+4]

	test	ebx, ebx
	je	@@2b
	call	_MemAlloc, ebx
	jc	@@2b
	xchg	edi, eax
	call	_lzss_unpack, edi, ebx, [@@SB], [@@SC]
	jmp	@@2c

@@2b:	xor	edi, edi
	mov	[@@L0+18h], edi
	mov	[@@L0+1Ch], edi
@@2c:	mov	[@@M], edi

	mov	edi, [@@D]
	movzx	esi, word ptr [edi-12h+0Ch]
	movzx	edx, word ptr [edi-12h+0Eh]
	imul	esi, edx
	add	esi, edi

@@1a:	mov	ebx, [@@L0]
	dec	[@@L0+0Ch]
@@1b:	movsb
	movsb
	movsb
	mov	ecx, ebx
	mov	edx, [@@L0+0Ch]
	sub	ecx, [@@L0+10h]
	sub	edx, [@@L0+14h]
	xor	eax, eax
	sub	edx, [@@L0+1Ch]
	jae	@@1c
	cmp	ecx, [@@L0+18h]
	jae	@@1c
	not	edx
	add	ecx, [@@M]
	imul	edx, [@@L0+18h]
	mov	al, [ecx+edx]
@@1c:	stosb
	inc	ebx
	cmp	ebx, [@@L0+8]
	jb	@@1b
	mov	eax, [@@L0+4]
	cmp	eax, [@@L0+0Ch]
	jb	@@1a

	call	_MemFree, [@@M]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

ENDP
