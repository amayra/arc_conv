
; "Pure My Imouto Milk Purun" *.g2
; purun.exe
; 004B0730 select
; 0048BC10 lzss_unpack
; secure.dll
; 1001F07B header_decode
; 100944BA table_decode

	dw _conv_gml-$-2
_arc_glib2 PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@I
@M0 @@L0, 8
@M0 @@L1, 8

	enter	@@stk+5Ch, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 5Ch
	jc	@@9a
	call	@@Decode, 8465B49Bh, esi, 5Ch
	mov	eax, [esi+54h]
	mov	ebx, [esi+58h]
	mov	edi, offset @@sign
	cmp	ebx, 10h
	jb	@@9a
	push	13h
	pop	ecx
	repe	cmpsb
	jne	@@9a
	call	_FileSeek, [@@S], eax, 0
	jc	@@9a
	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	mov	edi, esp
	call	@@Decode, dword ptr [edi+44h], esi, ebx
	call	@@Decode, dword ptr [edi+34h], esi, ebx
	call	@@Decode, dword ptr [edi+24h], esi, ebx
	call	@@Decode, dword ptr [edi+14h], esi, ebx

	mov	edx, [esi+4]
	mov	eax, [esi]
	lea	ecx, [edx-1]
	sub	eax, 'DBDC'
	shr	ecx, 14h
	or	eax, ecx
	jne	@@9
	mov	[@@N], edx
	call	_ArcCount, edx
	call	_ArcDbgData, esi, ebx
	sub	ebx, 10h
	imul	ecx, [@@N], 18h
	mov	edi, [esi+8]
	sub	ebx, edi
	jb	@@9
	sub	edi, ecx
	jb	@@9
	cmp	ebx, [esi+0Ch]
	jb	@@9
	add	esi, 10h
	add	ecx, esi
	lea	esp, [ebp-@@stk]
	mov	[@@L0+4], edi
	mov	[@@L0], ecx
	mov	[@@L1+4], esp
	sub	esp, 200h
	and	[@@I], 0
	mov	[@@L1], esp

	; 00 name_offset
	; 04 null
	; 08 parent (root = -1)
	; 0C flags (dir = -1, file = 0x100)
	; 10 tab_offset
	; 14 tab_size (dir = 0, file = 0x50)

@@1:	cmp	dword ptr [esi+14h], 50h
	jne	@@8

	mov	ecx, [@@I]
	mov	edi, [@@M]
@@4a:	lea	edx, [ecx*2+ecx]
	mov	eax, [edi+10h+edx*8+8]
	push	dword ptr [edi+10h+edx*8]
	cmp	eax, ecx
	xchg	ecx, eax
	jb	@@4a

	mov	edi, [@@L1]
	jmp	@@4b
@@4e:	cmp	ebx, edi
	je	@@4b
	mov	al, '\'
	cmp	edi, [@@L1+4]
	je	@@4b
	stosb
@@4b:	mov	ebx, edi
	pop	edx
	mov	ecx, [@@L0+4]
	xor	eax, eax
	sub	ecx, edx
	jbe	@@4d
	add	edx, [@@L0]
@@4c:	mov	al, [edx]
	inc	edx
	test	al, al
	je	@@4d
	cmp	edi, [@@L1+4]
	je	@@4d
	stosb
	dec	ecx
	jne	@@4c
@@4d:	cmp	esp, [@@L1]
	jne	@@4e

	xor	eax, eax
	cmp	edi, [@@L1+4]
	jne	$+3
	dec	edi
	stosb
	call	_ArcName, [@@L1], -1
	and	[@@D], 0
	mov	edx, [@@M]
	mov	ebx, [esi+10h]
	mov	ecx, [edx+0Ch]
	sub	ecx, ebx
	jb	@@1a
	cmp	ecx, [esi+14h]
	jb	@@1a
	add	ebx, [edx+8]
	lea	edi, [edx+10h+ebx]
	mov	ebx, [edi+8]
	call	_FileSeek, [@@S], dword ptr [edi+0Ch], 0
	jc	@@1a
	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
	test	ebx, ebx
	je	@@1a
	call	@@5
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 18h
	call	_ArcBreak
	jc	@@9
	inc	[@@I]
	dec	[@@N]
	jne	@@1

@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5:	push	ebx
	push	esi
	mov	esi, [@@D]
	xor	edx, edx
@@5a:	mov	ecx, 20000h
	sub	ebx, ecx
	jae	$+6
	add	ecx, ebx
	xor	ebx, ebx
	push	edx
	push	ecx
	push	esi
	shl	edx, 1
	add	esi, ecx
	call	@@Decode, dword ptr [edi+10h+edx*8]
	pop	edx
	inc	edx
	and	edx, 3
	test	ebx, ebx
	jne	@@5a
	pop	esi
	pop	ebx
	ret

@@Decode PROC

@@A = dword ptr [ebp+14h]
@@S = dword ptr [ebp+18h]
@@C = dword ptr [ebp+1Ch]

@@L0 = dword ptr [ebp-4]
@@L1 = dword ptr [ebp-8]
@@L2 = byte ptr [ebp-0Ch]
@@L3 = byte ptr [ebp-10h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	eax, [@@A]
	imul	eax, 5Fh
	shr	eax, 0Dh
	mov	edi, offset _glib2_tab
	mov	ecx, 384h
	mov	edx, ecx
	repne	scasw
	jne	@@4
	not	ecx
	mov	esi, offset @@T
	add	ecx, edx
	mov	eax, 0CCCCCCCDh
	mul	ecx
	shr	edx, 2
	lea	eax, [edx*4+edx]
	sub	ecx, eax
	mov	ebx, edx
	mov	eax, 0AAAAAAABh
	mul	ebx
	shr	edx, 2
	lea	eax, [edx*2+edx]
	shl	eax, 1
	sub	ebx, eax
	cmp	ecx, ebx
	sbb	ecx, -1
	lea	ebx, [esi+ebx*4]
	lea	ecx, [esi+ecx*4]
	push	ebx
	push	ecx
	mov	ecx, edx
	mov	eax, 0CCCCCCCDh
	mul	ecx
	shr	edx, 2
	lea	eax, [edx*4+edx]
	sub	ecx, eax
	cmp	ecx, edx
	sbb	ecx, -1
	push	dword ptr [esi-18h+edx*4]
	push	dword ptr [esi-18h+ecx*4]

	mov	edi, [@@S]
	mov	ebx, [@@C]
	add	esi, edx
	xor	ecx, ecx
	sub	ebx, 4
	jb	@@2
@@1:	push	ecx
	movzx	eax, [@@L2]
	movzx	edx, [@@L3]
	mov	al, [edi+eax]
	call	[@@L1]
	call	[@@L0]
	inc	ecx
	mov	[esp+edx], al
	mov	al, [@@L2+1]
	mov	dl, [@@L3+1]
	mov	al, [edi+eax]
	call	[@@L1]
	call	[@@L0]
	inc	ecx
	mov	[esp+edx], al
	mov	al, [@@L2+2]
	mov	dl, [@@L3+2]
	mov	al, [edi+eax]
	call	[@@L1]
	call	[@@L0]
	inc	ecx
	mov	[esp+edx], al
	mov	al, [@@L2+3]
	mov	dl, [@@L3+3]
	mov	al, [edi+eax]
	call	[@@L1]
	call	[@@L0]
	inc	ecx
	mov	[esp+edx], al
	pop	eax
	stosd
	sub	ebx, 4
	jae	@@1
@@2:	and	ebx, 3
	je	@@4
@@3:	mov	al, [edi]
	call	[@@L1]
	call	[@@L0]
	inc	ecx
	stosb
	dec	ebx
	jne	@@3
@@4:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

	db 3,2,1,0
	db 0,2,1,3
	db 1,0,3,2
	db 3,0,2,1
	db 2,1,3,0
	db 3,2,1,0

@@T:	ror	al, cl
	ret
	nop
	xor	al, cl
	ret
	nop
@@6:	not	al
	ret
	nop
	sub	al, 64h
	jmp	@@6
	add	al, cl
	ret
	nop
	rol	al, 4
	ret
ENDP

@@sign db 'GLibArchiveData2.1', 0
ENDP
