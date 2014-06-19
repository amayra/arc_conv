
; "RagnarokOnline" *.grf
; Ragexe.exe 1rag1
; 004F47FF tree_v2

; s00 -> d04 size
; s04 -> d00 align_size
; s08 -> d08 unp_size
; s0C -> d10 flags
; s0D -> d0C offset

	dw 0
_arc_ragnarok PROC

@@S = dword ptr [ebp+8]

@@stk = 0
@M0 @@M
@M0 @@D
@M0 @@N
@M0 @@SC

	enter	@@stk+30h, 0
	mov	esi, esp
	call	_FileRead, [@@S], esi, 2Eh
	jc	@@9a
	mov	edi, offset @@sign
	push	4
	pop	ecx
	repe	cmpsd
	jne	@@9a
	cmp	dword ptr [esi+1Ah], 200h
	jne	@@9a
	mov	edi, [esi+0Eh]
	mov	esi, esp
	add	edi, 2Eh
	call	_FileSeek, [@@S], edi, 0
	jc	@@9a
	call	_FileRead, [@@S], esi, 8	
	jc	@@9a
	pop	edi
	pop	ebx
	lea	eax, [@@M]
	call	_ArcMemRead, eax, ebx, edi, 0
	jc	@@9
	mov	esi, [@@M]
	call	_zlib_unpack, esi, ebx, edx, eax
	jc	@@9
	mov	[@@SC], ebx
	call	@@5
	mov	[@@N], eax
	call	_ArcCount, eax
	call	_ArcDbgData, esi, ebx
	call	_ArcSetCP, 949		; Korean

@@1:	mov	ecx, [@@SC]
	mov	edi, esi
	sub	ecx, 11h
	jbe	@@9
	xor	eax, eax
	repne	scasb
	jne	@@9
	mov	[@@SC], ecx
	call	_ArcName, esi, -1
	mov	esi, edi
	and	[@@D], 0
	mov	eax, [esi+0Dh]
	mov	ebx, [esi+4]
	add	eax, 2Eh
	call	_FileSeek, [@@S], eax, 0
	jc	@@1a
	xor	edi, edi
	test	byte ptr [esi+0Ch], 1
	je	@@2b
	mov	edi, [esi+8]
@@2b:	lea	eax, [@@D]
	call	_ArcMemRead, eax, edi, ebx, 0
	xchg	ebx, eax
	mov	edi, edx
	test	byte ptr [esi+0Ch], 6
	je	@@2e
	mov	edx, [esi]
	xor	ecx, ecx
@@2c:	mov	eax, 0CCCCCCCDh
	inc	ecx
	mul	edx
	shr	edx, 3
	jne	@@2c
	mov	eax, ebx
	test	byte ptr [esi+0Ch], 2
	jne	@@2d
	mov	edx, 0A0h
	cmp	eax, edx
	jb	$+3
	xchg	eax, edx
@@2d:	call	@@3, edi, eax, ecx
@@2e:	test	byte ptr [esi+0Ch], 1
	je	@@1a
	call	_zlib_unpack, [@@D], dword ptr [esi+8], edi, ebx
	xchg	ebx, eax
@@1a:	call	_ArcData, [@@D], ebx
	call	_MemFree, [@@D]
@@8:	add	esi, 11h
	call	_ArcBreak
	jc	@@9
	dec	[@@N]
	jne	@@1
@@9:	call	_MemFree, [@@M]
@@9a:	leave
	ret

@@5 PROC	; esi, ebx
	push	edi
	mov	edi, esi
	mov	ecx, ebx
	xor	eax, eax
	xor	edx, edx
@@1:	sub	ecx, 11h
	jbe	@@9
	repne	scasb
	jne	@@9
	add	edi, 11h
	inc	edx
	jmp	@@1
@@9:	xchg	eax, edx
	pop	edi
	ret
ENDP

@@3 PROC	; 004EF0F0

@@D = dword ptr [ebp+14h]
@@C = dword ptr [ebp+18h]
@@L0 = dword ptr [ebp+1Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	edi, [@@D]
	mov	ecx, [@@L0]
	push	1
	pop	eax
	cmp	ecx, 3
	jb	@@2
	lea	eax, [ecx+1]
	cmp	ecx, 5
	jb	@@2
	lea	eax, [ecx+9]
	cmp	ecx, 7
	jb	@@2
	lea	eax, [ecx+0Fh]
@@2:	xor	ebx, ebx
	mov	[@@L0], eax
	xor	ecx, ecx
	shr	[@@C], 3
	je	@@9
@@1:	mov	esi, offset @@T
	cmp	ebx, 14h
	jb	@@6
	mov	eax, ebx
	xor	edx, edx
	div	[@@L0]
	test	edx, edx
	je	@@6
	inc	ecx
	cmp	ecx, 8
	jne	@@7
	mov	cl, 1
	push	dword ptr [edi+4]
	push	dword ptr [edi]
	mov	edx, esp
	mov	ax, [edx+3]
	stosw
	mov	al, [edx+6]
	stosb
	mov	ax, [edx]
	stosw
	mov	al, [edx+2]
	mov	ah, [edx+5]
	stosw
	mov	al, [edx+7]
	pop	edx
	pop	edx
	push	-0Eh
	pop	edx
@@3:	cmp	al, [esi+edx]
	je	@@4
	inc	edx
	jne	@@3
	stosb
	jmp	@@8

@@4:	xor	edx, 1
	mov	al, [esi+edx]
	stosb
	jmp	@@8

@@6:	call	@@5
@@7:	add	edi, 8
@@8:	inc	ebx
	dec	[@@C]
	jne	@@1
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@5 PROC
	push	ebp
	push	ebx
	push	ecx
	push	edi
	; ecx < 0x100
	mov	ebp, offset @@2
	xor	eax, eax
	; 53c1d838 51960b2f
	call	ebp
	push	ebx
	call	ebp
	push	ecx
	mov	edi, esp
	push	ebx
	; bc50cb8e 78331146
	call	ebp
	push	ebx
	call	ebp
	; 88083020 c0bc9898
	call	@@3
	pop	ebx
	call	@@3
	; 70b50623
	mov	edi, [edi+8]
	mov	[edi], edx
	call	ebp
	; 88765063
	pop	edx
	pop	ecx
	xor	ebx, edx
	pop	edx
	mov	[edi], ebx
	mov	[edi+4], edx
	; 34269bed 78331146
	call	ebp
	push	ebx
	call	ebp
	pop	edx
	; 52c59c78 50c24f3b
	mov	[edi], ebx
	mov	[edi+4], edx
	pop	edi
	pop	ecx
	pop	ebx
	pop	ebp
	ret

@@3:	mov	cl, 4
@@3a:	mov	al, bl
	shl	edx, 4
	shr	eax, 1
	mov	al, [esi+eax]
	jnc	@@3b
	shr	al, 4
@@3b:	and	al, 0Fh
	shr	ebx, 8
	add	edx, eax
	add	esi, 20h
	dec	ecx
	jne	@@3a
	ret

@@2:	mov	cl, 20h
@@2a:	lodsb
	mov	edx, eax
	and	eax, 1Fh
	shr	edx, 5
	bt	[edi+edx*4], eax
	adc	ebx, ebx
	dec	ecx
	jne	@@2a
	ret	
ENDP

db 000h,02Bh,001h,068h,048h,077h,060h,0FFh
db 06Ch,080h,0B9h,0C0h,0EBh,0FEh
@@T:
dd 021293139h, 001091119h, 0232B333Bh, 0030B131Bh
dd 0252D353Dh, 0050D151Dh, 0272F373Fh, 0070F171Fh
dd 020283038h, 000081018h, 0222A323Ah, 0020A121Ah
dd 0242C343Ch, 0040C141Ch, 0262E363Eh, 0060E161Eh
dd 03B3C0000h, 02738393Ah, 03F300000h, 03B3C3D3Eh
dd 033340000h, 03F303132h, 037280000h, 033343536h
dd 02B2C0000h, 03728292Ah, 02F200000h, 02B2C2D2Eh
dd 023240000h, 02F202122h, 027380000h, 023242526h
dd 0417DF40Eh, 018DB2FE2h, 0BCC66AA3h, 087305995h
dd 0288EC1F4h, 07B12964Dh, 0E739BC5Fh, 0D0650AA3h
dd 07E48D13Fh, 0E4832BF6h, 0AD1207C9h, 05AB5906Ch
dd 01BA78ED0h, 0214DF43Ah, 0C67C68B5h, 09FE25309h
dd 09E0970DAh, 0A56F4336h, 0E75C8D21h, 018F2B4CBh
dd 009D4A61Dh, 070839F68h, 03CE2F14Bh, 0C72E5AB5h
dd 053BE8DD7h, 03A09F660h, 0C5287241h, 09FE4AC1Bh
dd 06009F63Ah, 08DD71BACh, 0BE53419Fh, 0E42872C5h
dd 0C124BCE2h, 016DB7A47h, 0AFF30558h, 0698E903Dh
dd 07BC182B4h, 0D827ED1Ah, 0950CF96Fh, 03E5043A6h
dd 02F4AF1ACh, 05896C279h, 0E4D31D60h, 08B35B70Eh
dd 0C52F3E49h, 0A3FC5892h, 07A14E0B7h, 0D68B0D61h
dd 07EB20BD4h, 0AD18904Fh, 0C7593CE3h, 06186FA25h
dd 08DDBB461h, 07EA7431Ch, 0F8065F9Ah, 0C23925E0h
dd 084D8F21Dh, 0417B3FA6h, 0BE6359CAh, 0279CE005h
dd 071E41B27h, 0D28EAC49h, 00D9AC6F0h, 0B865533Fh
dd 01A02130Dh, 0071C150Ah, 01208181Eh, 0171D0500h
dd 00609111Fh, 016010E1Bh, 00B0C1910h, 00F041403h
dd 00F2F0727h, 01F3F1737h, 00E2E0626h, 01E3E1636h
dd 00D2D0525h, 01D3D1535h, 00C2C0424h, 01C3C1434h
dd 00B2B0323h, 01B3B1333h, 00A2A0222h, 01A3A1232h
dd 009290121h, 019391131h, 008280020h, 018381030h

ENDP	; @@3

@@sign	db 'Master of Magic', 0
ENDP
