
; "12+ (Twelve Plus)" *.pb, *.pd
; twplusMP.exe
; 00402980 pd_unpack

	dw _conv_twelve_pd-$-2
_arc_twelve_pd:
	ret

	dw _conv_twelve_pb-$-2
_arc_twelve PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@L0, 14h
@M0 @@L1

	enter	@@stk, 0
	call	_unicode_ext, -1, offset inFileName
	and	[@@L0], 0
	cmp	eax, 'bp'
	je	@@2a
	cmp	eax, 'dp'
	jne	@@9a
	call	_ArcSetConv, offset _arc_twelve_pd
	or	[@@L0], -1
	lea	esi, [@@L0]
	call	_FileRead, [@@S], esi, 2
	jc	@@9a
	movzx	eax, byte ptr [@@L0]
	cmp	eax, 2
	jb	@@9a
	call	_FileSeek, [@@S], eax, 0
	jc	@@9a
@@2a:	lea	esi, [@@L0+4]
	call	_FileRead, [@@S], esi, 10h
	jc	@@9a
	mov	ebx, 0FFFh
	and	ebx, [@@L0+4]
	je	@@9a
	mov	[@@N], ebx
	shl	ebx, 3

	lea	eax, [@@M]
	call	_ArcMemRead, eax, 0, ebx, 0
	jc	@@9
	mov	esi, [@@M]
	cmp	byte ptr [@@L0+2], 0
	je	@@2b
	movzx	eax, byte ptr [@@L0+1]
	call	@@3, 06B113B0Bh, eax, esi, ebx
	call	_ArcDbgData, esi, ebx
@@2b:	call	_ArcCount, [@@N]

@@1:	mov	ebx, [esi+4]
	test	ebx, ebx
	jne	@@1c
	call	_ArcSkip, 1
	jmp	@@8

@@1c:	and	[@@D], 0
	cmp	esi, [@@M]
	je	@@1b
	call	_FileSeek, [@@S], dword ptr [esi], 0
	jc	@@1a
@@1b:	lea	eax, [@@D]
	call	_ArcMemRead, eax, 0, ebx, 0
	xchg	ebx, eax
@@1a:	call	_ArcConv, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 8
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@3 PROC

@@L0 = byte ptr [ebp+14h]
@@L1 = dword ptr [ebp+18h]
@@D = dword ptr [ebp+1Ch]
@@N = dword ptr [ebp+20h]

@@L2 = dword ptr [ebp-10h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	push	0Eh
	pop	ecx
	movzx	ebx, [@@L0+3]
	movzx	eax, [@@L0+2]
	push	ebx
	push	eax
	imul	ebx, ecx
	movzx	edx, [@@L0+1]
	movzx	eax, [@@L0]
	imul	edx, [@@L1]
	push	edx
	push	eax
	mov	[@@L1], ebx

	mov	edi, [@@D]
	cmp	[@@N], 0
	je	@@9
@@1:	mov	ebx, ecx
	add	ebx, [@@L2+8]
	mov	eax, ecx
	xor	edx, edx
	div	ebx
	mov	ebx, ecx
	add	ebx, [@@L2]
	imul	ebx, [@@L2+4]
	imul	ebx, edx
	lea	esi, [ecx+2]
	mov	eax, [@@L1]
	shr	esi, 1
	xor	edx, edx
	div	esi
	mov	eax, [@@L2+0Ch]
	add	ebx, edx
	sub	[edi], bl
	inc	edi
	inc	ecx
	add	[@@L1], eax
	dec	[@@N]
	jne	@@1
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
ENDP

ENDP

_conv_twelve_pb PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	cmp	ebx, 10h
	jb	@@9
	mov	ecx, 'ggo'
	mov	eax, [esi]
	mov	edx, [esi+4]
	sub	eax, 'SggO'
	sub	dh, 2
	or	eax, edx
	je	@@8
	mov	ecx, 'vaw'
	mov	edx, 'EVAW'
	mov	eax, [esi]
	sub	edx, [esi+8]
	sub	eax, 'FFIR'
	or	eax, edx
	je	@@8
	mov	ecx, 'bp'
	mov	eax, [esi+4]
	or	eax, [esi+8]
	or	eax, [esi+0Ch]
	jne	@@9
@@8:	call	_ArcSetExt, ecx
@@9:	stc
	leave
	ret
ENDP

_conv_twelve_pd PROC

@@SB = dword ptr [ebp+8]
@@SC = dword ptr [ebp+0Ch]

	push	ebp
	mov	ebp, esp
	mov	ebx, [@@SC]
	mov	esi, [@@SB]
	sub	ebx, 12h
	jb	@@9
	push	ebx
	movzx	edi, word ptr [esi+2]
	movzx	edx, word ptr [esi+4]
	mov	ebx, edi
	imul	ebx, edx
	push	edx
	push	edi
	mov	al, [esi]
	cmp	al, 6
	je	@@1
	sub	al, 8
	cmp	al, 4
	jb	@@2
@@9:	stc
	leave
	ret

@@1:	lea	ebx, [ebx*2+ebx]
	call	_ArcTgaAlloc, 22h
	lea	edi, [eax+12h]
	call	@@Unpack1, edi, ebx, esi
	clc
	leave
	ret

@@2:	call	_ArcTgaAlloc, 23h
	lea	edi, [eax+12h]
	call	@@Unpack2, edi, ebx, esi
	clc
	leave
	ret

@@Unpack1 PROC

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
	movzx	ebx, byte ptr [esi+1]
	add	esi, 12h
	and	ebx, 3Fh

	mov	ecx, [@@DC]
	mov	eax, [@@SC]
	cmp	ecx, eax
	jb	$+3
	xchg	ecx, eax
	sub	[@@DC], ecx
	test	ecx, ecx
	je	@@9
	add	ebx, offset @@T
	xor	edx, edx
@@1:	lodsb
	sub	al, [ebx+edx]
	stosb
	inc	dl
	dec	ecx
	jne	@@1
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	[@@DC]
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h
@@T:
dd 084BE2329h, 0AED66CE1h, 0F1499052h, 0EBE9BBF1h
dd 03CDBA6B3h, 0993E0C87h, 01C0D5E24h, 0DE47B706h
dd 0C84D12B3h, 0A68BBB43h, 07D5A031Fh, 01F253809h
dd 0FCCBD45Dh, 03B45F596h, 00A890D13h, 032AEDB1Ch
dd 0EE509A20h, 0FD367840h, 0F6324912h, 0DC497D9Eh
dd 0F2144FADh, 0D0664044h, 0B730C46Bh, 022A13B32h
dd 09D9122F6h, 0DA1F8BE1h, 00299CAB0h, 0499D72B9h
dd 0C57E802Ch, 080E9D599h, 0CCC9EAB2h, 0D667BF53h
dd 07ED614BFh, 0668EDC2Dh, 04957EF83h, 08F69FF61h
dd 01ED1CD61h, 072169C9Dh, 0F01DE672h, 0774A4F84h
dd 039E8D702h, 0C9CB532Ch, 074331E12h, 0D5F40C9Eh
dd 0A4D49FD4h, 0CF357E59h, 0CCF42232h, 02D90D3CFh
dd 0758FD348h, 02A1DD9E6h, 02BF7C0E5h, 044878178h
dd 000505F0Eh, 0BE8D61D4h, 00715057Bh, 01F82333Bh
dd 0DA927018h, 0B1CE5464h, 015693E85h, 0046A46F8h
dd 0D90E7396h, 068672F16h, 04A4AF7D4h, 0766857D0h
dd 011BB16FAh, 08824AEADh, 0DB52FE79h, 03CE54325h
dd 0D8D345F4h, 0F50BCE28h, 03D5960C5h, 0598A2797h
dd 0C2D02D76h, 0D468CDC9h, 025796A49h, 014406108h
dd 0A56A3BB1h, 08CC12811h, 0870BA9D6h, 0F12F8C97h
ENDP

@@Unpack2 PROC

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]

@@L0 = dword ptr [ebp-8]
@@L1 = dword ptr [ebp-0Ch]
@@L2 = dword ptr [ebp-10h]
@@L3 = dword ptr [ebp-14h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@DB]
	mov	esi, [@@SB]
	xor	ebx, ebx
	movzx	ecx, byte ptr [esi]
	mov	eax, [esi+8]
	mov	edx, [esi+0Ch]
	add	esi, 12h
	sub	[@@SC], eax
	jb	@@9
	sub	[@@SC], edx
	jb	@@9
	push	eax
	push	esi
	add	esi, eax
	push	edx
	add	edx, esi
	push	edx
	push	ecx

@@1:	call	@@3
	jne	@@1a
	xor	eax, eax
	test	byte ptr [@@L3], 1
	je	@@1e
	call	@@3
@@1e:	inc	eax
	mov	ecx, eax
	sub	[@@DC], eax
	jb	@@9
	test	byte ptr [@@L3], 2
	je	@@1f
	shl	eax, 2
	sub	[@@L1], eax
	jb	@@9
	rep	movsd
	jmp	@@1

@@1f:	lea	eax, [eax*2+eax]
	sub	[@@L1], eax
	jb	@@9
	mov	al, -1
@@1g:	movsb
	movsb
	movsb
	stosb
	dec	ecx
	jne	@@1g
	jmp	@@1

@@1a:	dec	eax
	jne	@@1c
	call	@@4
	mov	ah, al
	dec	[@@L1]
	js	@@9
	lodsb
	mov	ecx, eax
	and	ah, 3
	shr	ecx, 0Ah
	inc	ecx
@@1b:	sub	[@@DC], ecx
	jb	@@9
	not	eax
	shl	ecx, 2
	shl	eax, 2
	mov	edx, edi
	sub	edx, [@@DB]
	add	edx, eax
	jnc	@@9
	add	eax, edi
	xchg	esi, eax
	rep	movsb
	xchg	esi, eax
	jmp	@@1

@@1c:	dec	eax
	jne	@@1d
	sub	[@@L1], 2
	jb	@@9
	lodsw
	mov	ecx, eax
	and	ah, 3Fh
	shr	ecx, 0Eh
	inc	ecx
	jmp	@@1b

@@1d:	call	@@4
	mov	ecx, eax
	sub	[@@L1], 2
	jb	@@9
	lodsw
	shl	ecx, 10h
	test	eax, eax
	je	@@7
	add	ecx, eax
	and	ah, 3Fh
	shr	ecx, 0Eh
	add	ecx, 5
	jmp	@@1b

@@7:	mov	esi, [@@DC]
@@9:	xchg	eax, edi
	sub	eax, [@@DB]
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@3:	mov	al, bl
	shr	bl, 2
	jne	@@3a
	dec	[@@L0+4]
	js	@@9
	mov	eax, [@@L0]
	mov	bl, [eax]
	inc	eax
	mov	[@@L0], eax
	mov	al, bl
	shr	bl, 2
	or	bl, 40h
@@3a:	and	eax, 3
	ret

@@4:	mov	al, bh
	shr	bh, 4
	jne	@@4a
	dec	[@@SC]
	js	@@9
	mov	eax, [@@L2]
	mov	bh, [eax]
	inc	eax
	mov	[@@L2], eax
	mov	al, bh
	shr	bh, 4
	or	bh, 10h
@@4a:	and	eax, 0Fh
	ret
ENDP

ENDP
