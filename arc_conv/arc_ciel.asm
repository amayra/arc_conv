
; "Ciel Limited Collector's Box", "Fault!!" *.arc

	dw _conv_ciel-$-2
_arc_ciel PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC
@M0 @@L0
@M0 @@L1
@M0 @@L2
@M0 @@L3
@M0 @@L4
@M0 @@L5, 2Ch

	enter	@@stk, 4
	mov	esi, esp
	call	_FileRead, [@@S], esi, 4
	jc	@@9a
	pop	ebx
	lea	eax, [ebx+1]
	shr	eax, 14h
	jne	@@9a
	mov	[@@N], ebx

	imul	ebx, 2Ch
	add	ebx, 4
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	mov	[@@SC], eax

	mov	esi, offset @@T
@@3:	xor	eax, eax
	lodsb
	sub	eax, 4
	jb	@@9
	mov	ebx, eax
	lodsb
	mov	[@@L1], eax
	add	eax, 0Ch
	imul	eax, [@@N]
	add	eax, ebx
	cmp	[@@SC], eax
	jae	@@3b
@@3a:	lodsb
	test	al, al
	jne	@@3a
	jmp	@@3

@@3b:	add	eax, 4
	mov	edx, [@@M]
	mov	[@@L4], eax
	or	eax, -1
	test	ebx, ebx
	je	@@3c
	mov	eax, [edx]
	add	edx, 4
	cmp	eax, 2
	jae	@@3a
@@3c:	mov	[@@L3], esi
	mov	[@@L2], eax
	mov	[@@L0], ebx

	mov	ebx, [@@N]
@@4:	mov	ecx, [@@L1]
	mov	edi, esp
	add	ecx, 0Ch
	call	@@5
	mov	eax, [@@L4]
	cmp	[edi-4], eax
	jne	@@3a
	add	eax, [edi-8]
	mov	[@@L4], eax

	mov	ecx, [@@L1]
	mov	edi, esp
	xor	eax, eax
	repne	scasb
;	jne	@@3a
	test	ecx, ecx
	je	@@4c
	repe	scasb
	jne	@@3a
@@4c:	dec	ebx
	jne	@@4
	call	_ArcCount, [@@N]

	mov	edi, [@@M]
	add	edi, [@@L0]
	push	edi
	mov	ecx, [@@L1]
	mov	esi, [@@L3]
	add	ecx, 0Ch
	mov	edx, edi
	imul	ecx, [@@N]
	mov	ebx, ecx
	call	@@5
	pop	esi
	call	_ArcDbgData, esi, ebx

@@1:	mov	ebx, [@@L1]
	call	_ArcName, esi, ebx
	add	esi, ebx
	and	[@@D], 0
	mov	edi, [esi]
	mov	ebx, [esi+4]
	call	_FileSeek, [@@S], dword ptr [esi+8], 0
	jc	@@1a
	mov	ecx, [@@L2]
	lea	eax, [@@D]
	test	ecx, ecx
	je	@@1c
	inc	ecx
	jne	@@2a
	cmp	ebx, edi
	jne	@@2a
@@1c:	call	_ArcMemRead, eax, 0, ebx, 0
@@1b:	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 0Ch
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@2a:	call	_ArcMemRead, eax, edi, ebx, 0
	call	_lzss_unpack, [@@D], edi, edx, eax
	jmp	@@1b

@@5a:	mov	esi, [@@L3]
@@5:	lodsb
	test	al, al
	je	@@5a
	add	al, [edx]
	inc	edx
	stosb
	dec	ecx
	jne	@@5
	ret

@@T:
db 4,18h, 'arcana',0
db 8,18h, 'after',0
db 8,18h, 'aftersk',0
db 8,18h, 'afterse_title',0
db 8,20h, 'inst',0
db 8,20h, 'HAMA',0
db 8,20h, 'FT',0
db 8,20h, 'while',0
db 8,20h, 'FM',0	; "Famima!"
db 8,20h, 'kemo',0	; "Kemonopani!"
db 8,20h, 'KOITATE',0	; "Koisuru Otome to Shugo no Tate"
db 8,20h, 'faulta',0	; "Fault!! Ace"
db 8,20h, 'sega-sw',0	; SW_FAN_FESTA
db 0

ENDP

_conv_ciel PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

@@L0 = dword ptr [ebp-4]

	push	ebp
	mov	ebp, esp
	call	_ArcGetExt
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	eax, 'pmb'
	je	@@1
@@9:	stc
	leave
	ret

@@1:	sub	ebx, 36h
	jb	@@9
	cmp	word ptr [esi], 'MB'
	jne	@@9
	mov	ecx, 180001h
	mov	eax, [esi+0Ah]
	mov	edx, [esi+0Eh]
	sub	eax, 36h
	sub	edx, 28h
	sub	ecx, [esi+1Ah]
	or	eax, edx
	or	eax, ecx
	jne	@@9
	mov	edi, [esi+12h]
	mov	edx, [esi+16h]
	mov	eax, edi
	and	eax, 3
	lea	eax, [eax+edi*4]
	imul	eax, edx
	cmp	ebx, eax
	jne	@@9
	call	_ArcTgaAlloc, 3, edi, edx
	lea	edi, [eax+12h]
	mov	ebx, [esi+12h]
	mov	edx, [esi+16h]
	add	esi, 36h
	push	edx	; @@L0
	lea	eax, [ebx*2+ebx+3]
	and	al, -4
	imul	edx, eax
	add	edx, esi
@@1a:	mov	ecx, ebx
@@1b:	movsb
	movsb
	movsb
	mov	al, [edx]
	inc	edx
	stosb
	dec	ecx
	jne	@@1b
	mov	eax, ebx
	and	eax, 3
	add	esi, eax
	dec	[@@L0]
	jne	@@1a
	clc
	leave
	ret
ENDP
