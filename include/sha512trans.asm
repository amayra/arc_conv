
_sha512_transform@8 PROC

@@L0 = dword ptr [ebp-48h]
@@L1 = dword ptr [ebp-8]
@@C = dword ptr [ebp+18h]

	push	10h
	pop	ecx
	push	ebx
	push	esi
	push	edi
	enter	2C8h, 0
	mov	esi, [ebp+14h]
	lea	edi, [@@L0]
	cld
	rep	movsd
	mov	esi, [ebp+18h]
	mov	edi, esp
	add	ecx, 10h
@@1:	mov	eax, [esi]
	mov	edx, [esi+4]
	add	esi, 8
	bswap	eax
	bswap	edx
	mov	[edi+4], eax
	mov	[edi], edx
	add	edi, 8
	dec	ecx
	jne	@@1
	add	ecx, 40h
@@2:	mov	eax, [edi-8*2]
	mov	edx, [edi+4-8*2]
	; s1
	push	ecx
	push	edi
	mov	ecx, eax
	mov	ebx, edx
	mov	esi, eax
	mov	edi, edx
	shrd	eax, ebx, 13h
	shrd	edx, ecx, 13h
	shrd	esi, ebx, 1Dh	; 3Dh
	shrd	edi, ecx, 1Dh	; 3Dh
	xor	edx, esi
	xor	eax, edi
	pop	edi
	shrd	ecx, ebx, 6
	shr	ebx, 6
	xor	eax, ecx
	xor	edx, ebx
	add	eax, [edi-8*7]
	adc	edx, [edi+4-8*7]
	mov	[edi], eax
	mov	[edi+4], edx

	mov	eax, [edi-8*0Fh]
	mov	edx, [edi+4-8*0Fh]
	; s0
	push	edi
	mov	ecx, eax
	mov	ebx, edx
	mov	esi, eax
	mov	edi, edx
	shrd	eax, ebx, 1
	shrd	edx, ecx, 1
	shrd	esi, ebx, 8
	shrd	edi, ecx, 8
	xor	eax, esi
	xor	edx, edi
	pop	edi
	shrd	ecx, ebx, 7
	shr	ebx, 7
	xor	eax, ecx
	xor	edx, ebx
	pop	ecx
	add	eax, [edi-8*10h]
	adc	edx, [edi+4-8*10h]
	add	[edi], eax
	adc	[edi+4], edx
	add	edi, 8
	dec	ecx
	jne	@@2
	add	ecx, 50h
@@3:	mov	[@@C], ecx
	lea	edi, [ecx-50h]
	dec	ecx
	mov	esi, offset @@T
	neg	edi
	and	ecx, 7
	mov	eax, [esi+edi*8]
	mov	edx, [esi+edi*8+4]
	add	eax, [esp+edi*8]
	adc	edx, [esp+edi*8+4]
	add	eax, [@@L0+ecx*8]
	adc	edx, [@@L0+ecx*8+4]
	lea	ebx, [ecx-3]
	lea	esi, [ecx-2]
	dec	ecx
	and	ebx, 7
	and	esi, 7
	and	ecx, 7
	mov	[@@L1], eax
	mov	[@@L1+4], edx
	; ch
	mov	eax, [@@L0+esi*8]
	mov	edx, [@@L0+esi*8+4]
	xor	eax, [@@L0+ecx*8]
	xor	edx, [@@L0+ecx*8+4]
	and	eax, [@@L0+ebx*8]
	and	edx, [@@L0+ebx*8+4]
	xor	eax, [@@L0+ecx*8]
	xor	edx, [@@L0+ecx*8+4]
	add	[@@L1], eax
	adc	[@@L1+4], edx
	mov	eax, [@@L0+ebx*8]
	mov	edx, [@@L0+ebx*8+4]
	; e1
	mov	ecx, eax
	mov	ebx, edx
	mov	esi, eax
	mov	edi, edx
	shrd	eax, ebx, 0Eh
	shrd	edx, ecx, 0Eh
	shrd	esi, ebx, 12h
	shrd	edi, ecx, 12h
	xor	eax, esi
	xor	edx, edi
	mov	esi, ecx
	shrd	ecx, ebx, 9	; 29h
	shrd	ebx, esi, 9	; 29h
	mov	edi, [@@C]
	xor	edx, ecx
	xor	eax, ebx
	mov	ebx, edi
	lea	esi, [edi+1]
	add	edi, 3
	add	eax, [@@L1]
	adc	edx, [@@L1+4]
	and	edi, 7
	mov	[@@L1], eax
	mov	[@@L1+4], edx
	add	[@@L0+edi*8], eax
	adc	[@@L0+edi*8+4], edx
	dec	edi
	and	ebx, 7
	and	esi, 7
	and	edi, 7
	; maj
	mov	eax, [@@L0+ebx*8]
	mov	edx, [@@L0+ebx*8+4]
	or	eax, [@@L0+esi*8]
	or	edx, [@@L0+esi*8+4]
	and	eax, [@@L0+edi*8]
	and	edx, [@@L0+edi*8+4]
	mov	edi, [@@L0+esi*8]
	mov	esi, [@@L0+esi*8+4]
	and	edi, [@@L0+ebx*8]
	and	esi, [@@L0+ebx*8+4]
	or	eax, edi
	or	edx, esi
	add	[@@L1], eax
	adc	[@@L1+4], edx
	mov	eax, [@@L0+ebx*8]
	mov	edx, [@@L0+ebx*8+4]
	; e0
	mov	ecx, eax
	mov	ebx, edx
	mov	esi, eax
	mov	edi, edx
	shrd	eax, ebx, 1Ch
	shrd	edx, ecx, 1Ch
	shrd	esi, ebx, 2	; 22h
	shrd	edi, ecx, 2	; 22h
	xor	edx, esi
	xor	eax, edi
	mov	esi, ecx
	mov	edi, [@@C]
	shrd	ecx, ebx, 7	; 27h
	shrd	ebx, esi, 7	; 27h
	dec	edi
	xor	edx, ecx
	xor	eax, ebx
	mov	ecx, edi
	and	edi, 7
	add	eax, [@@L1]
	adc	edx, [@@L1+4]
	test	ecx, ecx
	mov	[@@L0+edi*8], eax
	mov	[@@L0+edi*8+4], edx
	jne	@@3
	mov	edi, [ebp+14h]
@@4:	mov	eax, [@@L0+ecx*8]
	mov	edx, [@@L0+ecx*8+4]
	add	[edi+ecx*8], eax
	adc	[edi+ecx*8+4], edx
	inc	ecx
	cmp	ecx, 8
	jb	@@4
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8

@@T:
dq 0428a2f98d728ae22h,07137449123ef65cdh
dq 0b5c0fbcfec4d3b2fh,0e9b5dba58189dbbch
dq 03956c25bf348b538h,059f111f1b605d019h
dq 0923f82a4af194f9bh,0ab1c5ed5da6d8118h
dq 0d807aa98a3030242h,012835b0145706fbeh
dq 0243185be4ee4b28ch,0550c7dc3d5ffb4e2h
dq 072be5d74f27b896fh,080deb1fe3b1696b1h
dq 09bdc06a725c71235h,0c19bf174cf692694h
dq 0e49b69c19ef14ad2h,0efbe4786384f25e3h
dq 00fc19dc68b8cd5b5h,0240ca1cc77ac9c65h
dq 02de92c6f592b0275h,04a7484aa6ea6e483h
dq 05cb0a9dcbd41fbd4h,076f988da831153b5h
dq 0983e5152ee66dfabh,0a831c66d2db43210h
dq 0b00327c898fb213fh,0bf597fc7beef0ee4h
dq 0c6e00bf33da88fc2h,0d5a79147930aa725h
dq 006ca6351e003826fh,0142929670a0e6e70h
dq 027b70a8546d22ffch,02e1b21385c26c926h
dq 04d2c6dfc5ac42aedh,053380d139d95b3dfh
dq 0650a73548baf63deh,0766a0abb3c77b2a8h
dq 081c2c92e47edaee6h,092722c851482353bh
dq 0a2bfe8a14cf10364h,0a81a664bbc423001h
dq 0c24b8b70d0f89791h,0c76c51a30654be30h
dq 0d192e819d6ef5218h,0d69906245565a910h
dq 0f40e35855771202ah,0106aa07032bbd1b8h
dq 019a4c116b8d2d0c8h,01e376c085141ab53h
dq 02748774cdf8eeb99h,034b0bcb5e19b48a8h
dq 0391c0cb3c5c95a63h,04ed8aa4ae3418acbh
dq 05b9cca4f7763e373h,0682e6ff3d6b2b8a3h
dq 0748f82ee5defb2fch,078a5636f43172f60h
dq 084c87814a1f0ab72h,08cc702081a6439ech
dq 090befffa23631e28h,0a4506cebde82bde9h
dq 0bef9a3f7b2c67915h,0c67178f2e372532bh
dq 0ca273eceea26619ch,0d186b8c721c0c207h
dq 0eada7dd6cde0eb1eh,0f57d4f7fee6ed178h
dq 006f067aa72176fbah,00a637dc5a2c898a6h
dq 0113f9804bef90daeh,01b710b35131c471bh
dq 028db77f523047d84h,032caab7b40c72493h
dq 03c9ebe0a15c9bebch,0431d67c49c100d4ch
dq 04cc5d4becb3e42b6h,0597f299cfc657e2ah
dq 05fcb6fab3ad6faech,06c44198c4a475817h
ENDP
