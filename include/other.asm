_escude_crypt PROC
	mov	edx, esp
	push	ebx
	push	edi
	mov	eax, [edx+4]
	mov	ecx, [edx+8]
	mov	edi, [edx+0Ch]
@@1:	xor	eax, 65AC9365h
	mov	ebx, eax
	lea	edx, [eax+eax]
	shr	ebx, 1
	xor	edx, eax
	xor	ebx, eax
	shl	edx, 3
	shr	ebx, 3
	xor	eax, edx
	xor	eax, ebx
	xor	[edi], eax
	add	edi, 4
	dec	ecx
	jne	@@1
	pop	edi
	pop	ebx
	ret	0Ch
ENDP

_arc12_lzss_crypt PROC
	xor	eax, eax
@@1:	dec	ecx
	js	@@9
	shr	eax, 1
	jne	@@1a
	dec	ecx
	js	@@9
	mov	al, [edx]
	inc	edx
	stc
	rcr	al, 1
@@1a:	jnc	@@1b
	not	byte ptr [edx]
	inc	edx
	jmp	@@1

@@1b:	inc	edx
	inc	edx
	dec	ecx
	jns	@@1
@@9:	ret
ENDP

_marble_check PROC
	pop	edx
	pop	eax
	push	edx
	call	_unicode_name, eax
	push	eax
	call	@@2a
; 	db 'mg_data.mbl',0, 'mg_data2.mbl',0, 0
	db 'mg_data*',0, 0
@@2a:	call	_filename_select
	jc	@@2b
	push	10h
	pop	eax
@@2b:	ret
ENDP

_marble_crypt PROC
	mov	ecx, [esp+8]
	mov	edx, [esp+4]
	test	ecx, ecx
	je	@@9
	push	ebx
	xor	ebx, ebx
@@1:	mov	al, byte ptr [@@T+ebx]
	inc	ebx
	xor	[edx], al
	inc	edx
	cmp	ebx, 0Ch
	sbb	eax, eax
	and	ebx, eax
	dec	ecx
	jne	@@1
	pop	ebx
@@9:	ret	8

@@T	dd 0F182ED82h,0C388B182h,0BB89868Dh
ENDP

_exhibit_crypt PROC
	push	ebx
	push	esi
	push	edi
	enter	400h, 0

	; 0xAE85A916 - def.rld
	; 0xC284ED26 - "Angel Ring"

	mov	eax, [ebp+14h]
	enter	270h*4, 0
	mov	esi, eax
	call	_twister_init
@@2:	call	_twister_next
	xor	eax, esi
	mov	[ebp+4+ebx*4-4], eax
	test	bh, bh
	je	@@2
	leave

	xor	ecx, ecx
	mov	ebx, [ebp+18h]
	mov	esi, [ebp+1Ch]
	shr	ebx, 2
	mov	eax, 3FF0h
	cmp	ebx, eax
	jb	$+3
	xchg	ebx, eax
@@1:	mov	eax, [esp+ecx*4]
	inc	cl
	xor	[esi], eax
	add	esi, 4
	dec	ebx
	jne	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

_exhibit_scan PROC
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	xor	edx, edx
	mov	ebx, [ebp+18h]
	mov	esi, [ebp+14h]
	cmp	ebx, 18h
	jb	@@9
	cmp	dword ptr [esi], 524C4400h
	jne	@@9
	lea	ecx, [ebx-10h]
	lea	edx, [esi+10h]
	call	_exhibit_crypt, 0AE85A916h, ecx, edx

	mov	eax, [esi+8]
	xor	edx, edx
	cmp	eax, 10h
	jb	@@9
	sub	ebx, eax
	jb	@@9
	add	esi, eax
	sub	ebx, 0Eh
	jb	@@9
	mov	eax, ',0,0'
@@1:	cmp	dword ptr [esi], 0010000C3h
	je	@@2
@@1a:	inc	esi
	dec	ebx
	jns	@@1
@@9:	xchg	eax, edi
	cmp	edx, 1
	xchg	edx, eax
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@2:	cmp	[esi+4], eax
	jne	@@1a
	cmp	[esi+8], eax
	jne	@@1a
	cmp	[esi+0Ah], eax
	jne	@@1a
	add	esi, 0Eh
	mov	edi, esi
@@2a:	sub	ebx, 0Ah
	jb	@@9
	lodsw
	cmp	ax, 'x0'
	jne	@@9

	xor	ecx, ecx
	xor	eax, eax
	inc	ecx
@@2b:	lodsb
	sub	al, 30h
	cmp	al, 0Ah
	jb	@@2c
	or	al, 20h
	sub	al, 31h
	cmp	al, 6
	jae	@@9
	add	al, 0Ah
@@2c:	shl	ecx, 4
	lea	ecx, [ecx+eax]
	jnc	@@2b
	mov	[edi+edx], ecx
	add	edx, 4
	dec	ebx
	js	@@9
	lodsb
	cmp	al, ','
	jne	@@9
	jmp	@@2a
ENDP

_png_title PROC
	push	ebx
	push	esi
	mov	ebx, [esp+10h]
	mov	esi, [esp+0Ch]
	sub	ebx, 8
	jb	@@9
	test	esi, esi
	je	@@9
	mov	edx, 0A1A0A0Dh
	mov	eax, [esi]
	sub	edx, [esi+4]
	sub	eax, 474E5089h
	add	esi, 8
	or	eax, edx
	je	@@2
@@9:	xor	eax, eax
	cdq
@@8:	cmp	eax, 1
	pop	esi
	pop	ebx
	ret	8

@@1:	lea	esi, [esi+ecx+0Ch]
@@2:	sub	ebx, 0Ch
	jb	@@9
	mov	ecx, [esi]
	mov	eax, [esi+4]
	bswap	ecx
	sub	ebx, ecx
	jb	@@9
	cmp	eax, 'tXEt'
	jne	@@1
	cmp	ecx, 7
	jb	@@9
	mov	eax, [esi+8]
	movzx	edx, word ptr [esi+0Ch]
	sub	eax, 'ltiT'
	sub	edx, 'e'
	or	eax, edx
	jne	@@9
	lea	edx, [esi+8+6]
	lea	eax, [ecx-6]
	jmp	@@8
ENDP

_xp3_arc_load PROC

@@S = dword ptr [ebp+14h]
@@P = dword ptr [ebp+18h]
@@D = dword ptr [ebp+1Ch]

@@L0 = dword ptr [ebp-14h]

	push	ebx
	push	esi
	push	edi
	enter	0Ch, 0
	push	0
	push	0
	mov	esi, esp
	call	@@2d
@@2a:	lodsd
	xor	edx, edx
	add	eax, [@@P]
	adc	edx, [esi]
	lea	esi, [@@L0]
	jc	@@9a
	call	_FileSeek64, [@@S], eax, edx, 0
	jc	@@9a
	pop	edx
	pop	ecx
	mov	eax, esi
	jmp	@@2e

_xp3_sign:
@@2b:	db 'XP3',0Dh,0Ah,20h,0Ah,1Ah,8Bh,67h,1

@@2c:	lodsd
	xchg	ebx, eax
	lodsd
	test	eax, eax
	jne	@@9a
	cmp	ebx, 0Ch
	jb	@@9a
	call	_MemAlloc, ebx
	jc	@@9a
	pop	edx
	pop	ecx
	mov	edi, eax
	sub	eax, ecx
	add	ecx, ebx
@@2e:	push	edx
	call	_FileRead, [@@S], eax, ecx
	jc	@@9
	ret

@@1b:	cmp	al, 1
	jne	@@9a
	cmp	dword ptr [esi+0Ch], 0
	jne	@@9a
	call	edi, 0
	mov	esi, [esi]
	call	_MemAlloc, esi
	jc	@@9
	push	edi
	xchg	edi, eax
	call	_zlib_unpack, edi, esi, eax, ebx
	xchg	ebx, eax
	call	_MemFree
	cmp	ebx, esi
	je	@@8
@@9:	call	_MemFree, edi
@@9a:	xor	ebx, ebx
	xor	edi, edi
@@8:	mov	edx, [@@D]
	xchg	eax, ebx
	mov	[edx], edi
	cmp	eax, 1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch

@@2d:	pop	ebx
	call	ebx, 13h
	lea	edi, [ebx+@@2b-@@2a]
	push	0Bh
	pop	ecx
	repe	cmpsb
	jne	@@9a
	call	ebx, 11h
	lodsb
	cmp	al, 80h
	jne	@@1a
	lodsd
	xchg	edx, eax
	lodsd
	or	eax, edx
	jne	@@9a
	call	ebx, 11h
	lodsb
@@1a:	test	al, al
	jne	@@1b
	call	edi, -8
	push	edi
	movsd
	movsd
	pop	edi
	jmp	@@8
ENDP

_xp3_next PROC
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp

	mov	edi, [ebp+14h]
	xor	eax, eax
	mov	esi, [edi]
	mov	edx, 'eliF'
	test	esi, esi
	je	@@9
	sub	dword ptr [edi+4], 0Ch
	jb	@@9
	sub	edx, [esi]
	mov	ebx, [esi+4]
	or	edx, [esi+8]
	jne	@@9
	add	esi, 0Ch
	sub	[edi+4], ebx
	jae	@@3d
@@9:	stosd
	stosd
@@8:	stc
	jmp	@@7

@@3a:	mov	eax, [edi+10h]
	mov	esi, [edi+0Ch]
	mov	edx, [edi+8]
	test	eax, eax
	je	@@2a
	mov	eax, [eax] 
	mov	[edi+10h], eax
@@2a:	test	edx, edx
	je	@@8
	test	esi, esi
	je	@@8
	call	@@SizeFix
	call	@@FakeCheck
@@7:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4

@@3d:	lea	edx, [esi+ebx]
	mov	[edi+8], eax
	mov	[edi+0Ch], eax
	mov	[edi+10h], eax
	mov	[edi], edx
@@3:	sub	ebx, 0Ch
	jb	@@3a
	mov	ecx, [esi+4]
	cmp	dword ptr [esi+8], 0
	jne	@@3a
	mov	eax, [esi]
	add	esi, 0Ch
	sub	ebx, ecx
	jb	@@3a
	cmp	eax, 'ofni'
	jne	@@3c
	sub	ecx, 16h
	jb	@@3b
	movzx	eax, word ptr [esi+14h]
	shl	eax, 1
	lea	edx, [edi+8]
	sub	ecx, eax
	jb	@@3b
@@3e:	cmp	dword ptr [edx], 0
	jne	@@3b
	mov	[edx], esi
@@3b:	add	esi, [esi-8]
	jmp	@@3

@@3c:	lea	edx, [edi+0Ch]
	cmp	eax, 'mges'
	je	@@3e
	cmp	eax, 'rlda'
	jne	@@3b
	cmp	ecx, 4
	jb	@@3b
	lea	edx, [edi+10h]
	jmp	@@3e

@@SizeFix PROC

@@L0 = dword ptr [ebp-10h]
@@L1 = dword ptr [ebp-20h]

	push	ebp
	mov	ebp, esp
	mov	ebx, [esi-8]
	push	dword ptr [edx+10h]
	push	dword ptr [edx+0Ch]
	push	dword ptr [edx+8]
	push	dword ptr [edx+4]
	xor	eax, eax
	add	edx, 4
	push	eax
	push	eax
	push	eax
	push	eax
	push	edx
	; type, ptr64, unp64, size64
	sub	ebx, 1Ch
	jb	@@9
@@1:	mov	eax, [@@L0]
	mov	edx, [@@L0+8]
	or	eax, [@@L0+4]
	je	@@9
	or	edx, [@@L0+0Ch]
	je	@@9
	mov	eax, [esi+10h]
	mov	edx, [esi+4]
	or	eax, [esi+18h]
	jne	@@9
	or	edx, [esi+8]
	je	@@9
	lea	edi, [esi+0Ch]
	lea	eax, [@@L0]
	lea	edx, [@@L1]
	call	@@2
	lea	edi, [esi+14h]
	lea	eax, [@@L0+8]
	lea	edx, [@@L1+8]
	call	@@2
	add	esi, 1Ch
	sub	ebx, 1Ch
	jae	@@1
@@9:	pop	edi
	mov	esi, esp
	movsd
	movsd
	movsd
	movsd
	lea	edx, [edi-14h]
	leave
	ret

@@2:	push	esi
	push	edx
	xchg	esi, eax
	mov	ecx, [edi]
	mov	edi, [edi+4]
	mov	eax, [esi]
	mov	edx, [esi+4]
	sub	eax, ecx
	sbb	edx, edi
	jae	@@2a
	add	ecx, eax
	adc	edi, edx
	xor	eax, eax
	cdq
@@2a:	mov	[esi], eax
	mov	[esi+4], edx
	pop	edx
	pop	esi
	add	[edx], ecx
	adc	[edx+4], edi
	jnc	@@2b
	or	dword ptr [edx], -1
	or	dword ptr [edx+4], -1
@@2b:	ret
ENDP

@@FakeCheck PROC
	movzx	ecx, word ptr [edx+14h]
	add	edx, 16h
	cmp	ecx, 24h
	jb	@@5
	cmp	word ptr [edx], '$'
	jne	@@5
	push	esi
	push	edi
	mov	edi, edx
	call	@@5a
	db '$$$ This is a protected archive. $$$', 0
@@5a:	pop	esi
	xor	eax, eax
@@5b:	lodsb
	test	al, al
	je	@@5c
	scasw
	je	@@5b
@@5c:	pop	edi
	pop	esi
	je	@@9
@@5:	dec	ecx
	js	@@9
	jne	@@1
	movzx	eax, word ptr [edx]
	cmp	eax, 21h	; start
	je	@@9
	cmp	eax, 7Eh	; end
	je	@@9
@@1:	sub	ecx, 5
	jb	@@4
@@2:	cmp	dword ptr [edx], 544A8B66h
	jne	@@3
	mov	eax, [edx+4]
	cmp	eax, 2E002Fh
	jne	@@3
	rol	eax, 10h
	cmp	[edx+8], eax
	je	@@9
@@3:	inc	edx
	inc	edx
	dec	ecx
	jns	@@2
@@4:	clc
	ret

@@9:	stc
	ret
ENDP

ENDP

_exe_size PROC

@@S = dword ptr [ebp+14h]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	eax, 0FFCh
	mov	ebx, 2000h
	push	ecx
	sub	esp, eax
	push	ecx
	sub	esp, eax

	mov	esi, esp
	call	_FileRead, [@@S], esi, ebx
	xchg	ebx, eax
	call	_CheckPeHdr, esp, esi, ebx
	test	eax, eax
	je	@@9
	add	esi, [esi+3Ch]
	movzx	edx, word ptr [esi+14h]	; size of optional header
	mov	eax, [esi+54h]		; size of header
	lea	edx, [esi+edx+18h]	; object table
	movzx	ecx, word ptr [esi+6]	; count of sections
@@1:	mov	ebx, [edx+10h]		; file size
	mov	esi, [edx+14h]		; file address
	add	edx, 28h
	test	ebx, ebx
	je	@@2
	add	esi, ebx
	jc	@@2
	cmp	esi, eax
	jb	$+3
	xchg	esi, eax
@@2:	dec	ecx
	jne	@@1
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4
ENDP

_xp3_findsign PROC

@@S = dword ptr [ebp+14h]

@@N = dword ptr [ebp-4]
@@L0 = dword ptr [ebp-8]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	call	_exe_size, [@@S]
	test	eax, eax
	jle	@@9
	add	eax, 0Fh
	and	al, -10h
	push	40h
	push	eax
	call	_FileSeek, [@@S], eax, 0
	jc	@@9
	mov	eax, 0FFCh
	mov	ebx, 2000h
	push	ecx
	sub	esp, eax
	push	ecx
	sub	esp, eax
@@1:	mov	edi, esp
	call	_FileRead, [@@S], edi, ebx
	cmp	ebx, eax
	je	$+4
	xor	ebx, ebx
	shr	eax, 4
	je	@@9
	xchg	edx, eax
@@2:	push	0Bh
	pop	ecx
	mov	esi, offset _xp3_sign
	repe	cmpsb
	lea	edi, [edi+ecx+5]
	je	@@3
	dec	edx
	jne	@@2
	test	ebx, ebx
	je	@@9
	add	[@@L0], ebx
	dec	[@@N]
	jne	@@1
@@9:	xor	eax, eax
@@8:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	4

@@3:	lea	eax, [edi-10h]
	sub	eax, esp
	add	eax, [@@L0]
	jmp	@@8
ENDP

_aoimy_crypt PROC

@@K = dword ptr [ebp+14h]
@@D = dword ptr [ebp+18h]
@@C = dword ptr [ebp+1Ch]

	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	ebx, [@@K]
	mov	edi, [@@D]
	cmp	[@@C], 0
	je	@@9
	sub	edi, ebx
@@1:	mov	eax, 0A3371629h
	push	8
	pop	edx
	lea	esi, [ebx+eax]
@@2:	mov	ecx, ebx
	ror	ebx, 4
	and	ecx, 0Fh
	inc	ecx
	ror	eax, cl
	add	eax, esi
	dec	edx
	jne	@@2
	mov	ecx, ebx
	and	ecx, 0Fh
	shr	eax, cl
	xor	[edi+ebx], al
	inc	ebx
	dec	[@@C]
	jne	@@1
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

_aoimy_sign dw 'A','O','I','M','Y','0','1',0

_nitro_pak_checksum PROC
	mov	ecx, [esp+4]
	mov	edx, [esp+8]
	push	ebx
	xor	ebx, ebx
@@1:	movsx	eax, byte ptr [edx]
	test	eax, eax
	je	@@2
	imul	ebx, 89h
	add	ebx, eax
	inc	edx
	dec	ecx
	jne	@@1
@@2:	xchg	eax, ebx
	pop	ebx
	ret	8
ENDP

_n3pk_xor PROC
	push	ebx
	push	edi
	mov	edi, [esp+0Ch]
	mov	ecx, [esp+10h]
	mov	ebx, [esp+14h]
	movzx	edx, byte ptr [esp+18h]
	sub	ecx, 4
	jb	@@2
@@1:	mov	eax, [ebx+edx*4]
	xor	[edi], eax
	add	edi, 4
	inc	dl
	sub	ecx, 4
	jae	@@1
@@2:	add	ecx, 4
	je	@@4
@@3:	mov	al, [ebx+edx]
	xor	[edi], al
	inc	edi
	inc	dl
	dec	ecx
	jne	@@3
@@4:	pop	edi
	pop	ebx
	ret	10h	
ENDP

_n3pk_init PROC
	push	edi
	mov	edi, [esp+8]
	push	esi
	mov	esi, offset @@T
@@3a:	lodsw
	movzx	ecx, al
	shr	eax, 8
@@3b:	push	8
	pop	edx
	push	eax
@@3c:	shr	eax, 1
	jnc	$+7
	xor	eax, 0EDB88320h
	dec	edx
	jne	@@3c
	stosd
	pop	eax
	inc	eax
	dec	ecx
	jne	@@3b
	test	ah, ah
	je	@@3a
	pop	esi
	mov	eax, 0AAAAAAAAh
	mov	edi, [esp+8]
	mov	[edi], eax
	mov	[edi+4Eh], al
	pop	edi
	ret	4

@@T:
db 04h, 00h*4
db 04h, 2Ch*4
db 04h, 2Eh*4
db 10h, 30h*4
db 04h, 2Dh*4
db 0Ch, 34h*4
db 04h, 2Fh*4
db 10h, 37h*4
db 24h, 01h*4
db 24h, 11h*4
db 1Ch, 0Ah*4
db 48h, 1Ah*4
db 14h, 3Bh*4
ENDP

if 0
_qlie_checksum PROC
	xor	eax, eax
	shr	ecx, 3
	je	@@9
	push	ebp
	push	ebx
	push	esi
	push	edi
	xor	esi, esi
	xor	ebp, ebp
	lea	edx, [edx+ecx*8]
	neg	ecx
@@1:	add	esi, 307h
	movzx	ebx, word ptr [edx+ecx*8]
	movzx	edi, word ptr [edx+ecx*8+2]
	xor	ebx, esi
	xor	edi, esi
	add	ax, bx
	shl	edi, 10h
	add	eax, edi
	movzx	ebx, word ptr [edx+ecx*8+4]
	movzx	edi, word ptr [edx+ecx*8+6]
	xor	ebx, esi
	xor	edi, esi
	add	bp, bx
	shl	edi, 10h
	add	ebp, edi
	inc	ecx
	jne	@@1
	xor	eax, ebp
	pop	edi
	pop	esi
	pop	ebx
	pop	ebp
@@9:	ret
ENDP
else 
_qlie_checksum PROC
	mov	eax, 3070307h
	pxor	mm0, mm0
	shr	ecx, 3
	je	@@9
	movd	mm3, eax
	pxor	mm2, mm2
	punpckldq mm3, mm3
@@1:	paddw	mm2, mm3
	movq	mm1, [edx]
	add	edx, 8
	pxor	mm1, mm2
	paddw	mm0, mm1
	dec	ecx
	jne	@@1
@@9:	movq	mm1, mm0
	psrlq	mm0, 20h
	pxor	mm0, mm1
	movd	eax, mm0
	emms
	ret
ENDP
endif

_epa_dist PROC
	push	edi
	xor	ecx, ecx
	mov	edi, [esp+10h]
@@1:	movsx	eax, [@@T+ecx]
	mov	edx, eax
	sar	eax, 4
	and	edx, 0Fh
	imul	edx, [esp+8]
	sub	eax, edx
	imul	eax, [esp+0Ch]
	stosd
	inc	ecx
	cmp	ecx, 0Fh
	jb	@@1
	pop	edi
	ret	0Ch

@@T	db 0F0h,001h,0F1h
	db 0E0h,011h,002h,0D0h
	db 0E2h,0E1h,0F2h,012h
	db 022h,021h,003h,0C0h
ENDP

