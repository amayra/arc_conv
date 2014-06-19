
_des_swap@4 PROC
	pop	edx
	pop	eax
	push	edx
	push	ebx
	push	esi
	push	edi
	xchg	edi, eax
	push	0Fh
	pop	ecx
@@3:	mov	eax, [edi]
	mov	edx, [edi+4]
	mov	ebx, [edi+ecx*8]
	mov	esi, [edi+ecx*8+4]
	mov	[edi+ecx*8], eax
	mov	[edi+ecx*8+4], edx
	mov	[edi], ebx
	mov	[edi+4], esi
	add	edi, 8
	sub	ecx, 2
	jae	@@3
	pop	edi
	pop	esi
	pop	ebx
	ret
ENDP

_des_init@4 PROC
	pop	edx
	pop	eax
	push	edx
	push	ebx
	push	esi
	push	edi
	xchg	edi, eax
	push	8
	pop	ecx
	call	@@7

dd 01C120D02h, 06A39C60Fh, 01CE5A1D2h, 050872DB4h
dd 0F3489E7Bh, 0095F7AE5h, 0B782D438h, 0C6F1902Eh
dd 06C1BA34Dh, 01A140A01h, 05BC0F1A7h, 08479389Eh
dd 02CB6126Dh, 04FDAE503h, 0C1A6943Dh, 02ED0520Bh
dd 07A1F47F8h, 0E983BC65h, 01D130B04h, 04B25E059h
dd 07C9A86F3h, 0DE120DB4h, 0A76138CFh, 0A05E7A83h
dd 016F54D28h, 007C9B46Fh, 0D13CEB92h, 01B150F05h
dd 0FC5A03EDh, 0C9B73681h, 0609FA572h, 01E24DB48h
dd 06083F924h, 0A51E5ABDh, 0CB369C4Fh, 072D807E1h
dd 01F171109h, 0CAB4FC27h, 0A04D967Bh, 0596F3582h
dd 00ED1E318h, 05927A5F0h, 06C8BC31Eh, 00A94D63Fh
dd 0B1E87D42h, 01E181006h, 03D4AD17Ch, 0E89F8625h
dd 0C2F917A0h, 0B4036B5Eh, 0D6A92817h, 08F4AE370h
dd 03D52F4CBh, 061BC9E05h, 0190E0803h, 0C7ADF248h
dd 00EDB6914h, 0907A3586h, 0E32C5FB1h, 0A914C5BEh
dd 052870F68h, 043EDF02Bh, 09C713AD6h, 0160C0700h
dd 0065F9A24h, 03CE1C3B8h, 069A0F54Bh, 082D71E7Dh
dd 0D8243DC7h, 0A192067Bh, 08F436AB0h, 05CE9F51Eh

@@7:	pop	esi
@@1:	lodsd
	xor	ebx, ebx
	push	ecx
	push	eax
@@2:	lodsd
	xchg	edx, eax
@@3:	xor	eax, eax
@@4:	mov	ecx, ebx
	inc	ebx
	and	ecx, 3
	shr	edx, 1
	jnc	@@5
	mov	cl, [esp+ecx]
	bts	eax, ecx
@@5:	test	bl, 3
	jne	@@4
	stosd
	test	bl, 1Fh
	jne	@@3
	test	bl, bl
	jne	@@2
	pop	eax
	pop	ecx
	dec	ecx
	jne	@@1
	pop	edi
	pop	esi
	pop	ebx
	ret
ENDP

_des_set_key@8 PROC	; 00402697 (d[32], s[2])
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	mov	eax, [ebp+18h]
	mov	ecx, [eax]
	mov	edx, [eax+4]

	mov	eax, edx
	shr	eax, 4
	xor	eax, ecx
	and	eax, 0F0F0F0Fh
	xor	ecx, eax
	shl	eax, 4
	xor	edx, eax

	mov	eax, ecx
	shl	eax, 12h
	xor	eax, ecx
	and	eax, 0CCCC0000h
	xor	ecx, eax
	shr	eax, 12h
	xor	ecx, eax

	mov	eax, edx
	shl	eax, 12h
	xor	eax, edx
	and	eax, 0CCCC0000h
	xor	edx, eax
	shr	eax, 12h
	xor	edx, eax

	mov	eax, edx
	shr	eax, 1
	xor	eax, ecx
	and	eax, 55555555h
	xor	ecx, eax
	shl	eax, 1
	xor	edx, eax

	mov	eax, ecx
	shr	eax, 8
	xor	eax, edx
	and	eax, 0FF00FFh
	xor	edx, eax
	shl	eax, 8
	xor	ecx, eax

	mov	eax, edx
	shr	eax, 1
	xor	eax, ecx
	and	eax, 55555555h
	xor	ecx, eax
	shl	eax, 1
	xor	edx, eax

	shl	edx, 8
	mov	eax, 0F0000000h
	bswap	edx
	and	eax, ecx
	xor	ecx, eax
	shr	eax, 4
	xor	edx, eax
	push	ecx
	push	edx
	mov	edi, [ebp+14h]
	mov	ebx, 17EFCh
@@1:	lea	eax, [ebp-4]
	mov	esi, offset @@T
	call	@@2
	push	ecx
	lea	eax, [ebp-8]
	mov	esi, offset @@T+1Ch
	call	@@2
	xchg	eax, ecx
	pop	ecx
	rol	eax, 10h
	xchg	ax, cx
	shr	ebx, 1
	ror	ecx, 0Ch
	stosd
	xchg	eax, ecx
	stosd
	cmp	ebx, 1
	jne	@@1
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@2:	mov	ecx, ebx
	and	ecx, 1
	inc	ecx
	mov	edx, [eax]
	imul	edx, 10000001h
	shr	edx, cl
	and	edx, 0FFFFFFFh
	mov	[eax], edx
	xor	eax, eax
	xor	ecx, ecx
@@2a:	lodsb
	shr	edx, 1
	jnc	@@2b
	bts	ecx, eax
@@2b:	test	edx, edx
	jne	@@2a
	shr	ecx, 1
	ret

@@T:	db 05h,1Eh,11h,0Ch,06h,14h,1Ah,0Eh, 0
	db 16h,03h,0Bh,1Dh,01h,13h,19h,02h, 0
	db 0Ah,1Ch,15h, 0, 09h,04h, 0, 0Dh,1Bh,12h

	db 1Dh,11h,03h,1Eh,15h,0Dh, 0, 1Ch,04h, 0
	db 0Bh,12h,01h,1Ah, 0, 09h,14h,19h,05h
	db 16h,0Ah,1Bh,13h,02h,0Eh, 0, 06h,0Ch
ENDP

_des_crypt@8 PROC

@@T = dword ptr [esp+14h]
@@K = dword ptr [esp+18h]

	push	ebx
	push	esi
	push	edi
	push	ebp

	xchg	edi, eax
	mov	eax, edx
	shr	eax, 4
	xor	eax, edi
	and	eax, 0F0F0F0Fh
	xor	edi, eax
	shl	eax, 4
	xor	edx, eax

	mov	eax, edi
	shr	eax, 10h
	xor	eax, edx
	and	eax, 0FFFFh
	xor	edx, eax
	shl	eax, 10h
	xor	edi, eax

	mov	eax, edx
	shr	eax, 2
	xor	eax, edi
	and	eax, 33333333h
	xor	edi, eax
	shl	eax, 2
	xor	edx, eax

	mov	eax, edi
	shr	eax, 8
	xor	eax, edx
	and	eax, 0FF00FFh
	xor	edx, eax
	shl	eax, 8
	xor	edi, eax

	mov	eax, edx
	shr	eax, 1
	xor	eax, edi
	and	eax, 55555555h
	xor	edi, eax
	shl	eax, 1
	xor	edx, eax

	rol	edi, 1
	rol	edx, 1
	xchg	edi, edx

	mov	esi, [@@K]
	add	esi, 78h
@@2:	mov	eax, edx
	xor	eax, [esi+4]
	mov	ebx, [@@T]
	ror	eax, 4
	call	@@3
	mov	eax, edx
	xor	eax, [esi]
	call	@@3
	xchg	edi, edx
	cmp	esi, [@@K]
	lea	esi, [esi-8]
	jne	@@2

	ror	edx, 1
	ror	edi, 1

	mov	eax, edx
	shr	eax, 1
	xor	eax, edi
	and	eax, 55555555h
	xor	edi, eax
	shl	eax, 1
	xor	edx, eax

	mov	eax, edi
	shr	eax, 8
	xor	eax, edx
	and	eax, 0FF00FFh
	xor	edx, eax
	shl	eax, 8
	xor	edi, eax

	mov	eax, edx
	shr	eax, 2
	xor	eax, edi
	and	eax, 33333333h
	xor	edi, eax
	shl	eax, 2
	xor	edx, eax

	mov	eax, edi
	shr	eax, 10h
	xor	eax, edx
	and	eax, 0FFFFh
	xor	edx, eax
	shl	eax, 10h
	xor	edi, eax

	mov	eax, edx
	shr	eax, 4
	xor	eax, edi
	and	eax, 0F0F0F0Fh
	xor	edi, eax
	shl	eax, 4
	xor	edx, eax

	xchg	eax, edi
	pop	ebp
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@3:	and	eax, 3F3F3F3Fh
	movzx	ecx, al
	movzx	ebp, ah
	xor	edi, [ebx+ecx*4]
	shr	eax, 10h
	xor	edi, [ebx+ebp*4+100h]
	movzx	ecx, al
	movzx	ebp, ah
	xor	edi, [ebx+ecx*4+200h]
	xor	edi, [ebx+ebp*4+300h]
	add	ebx, 400h
	ret
ENDP
