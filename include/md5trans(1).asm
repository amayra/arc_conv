_md5_transform@8 PROC
	push	ebp
	push	ebx
	push	esi
	push	edi
	mov	ebx, [esp+14h]
	mov	esi, [esp+18h]
	mov	eax, [ebx]
	mov	ebp, [ebx+4]
	mov	edx, [ebx+8]
	mov	edi, [ebx+0Ch]

	xor	ebx, ebx
@@1:	mov	ecx, ebx
	shr	ecx, 5
	mov	ecx, edx
	jne	@@2b
	jc	@@2a
	xor	ecx, edi
	and	ecx, ebp
	xor	ecx, edi
	add	eax, ecx
	mov	ecx, ebx
	and	ecx, 0Fh
	add	eax, [esi+ecx*4]

	mov	ecx, ebx		; 07,12,17,22
	and	ecx, 3
	lea	ecx, [ecx*4+ecx+7]
	jmp	@@2d

@@2a:	xor	ecx, ebp
	and	ecx, edi
	xor	ecx, edx
	add	eax, ecx
	lea	ecx, [ebx*4+ebx+1]
	and	ecx, 0Fh
	add	eax, [esi+ecx*4]

	mov	ecx, ebx		; 05,09,14,20
	and	ecx, 3
	lea	ecx, [ecx*4+ecx+5]
	bt	ecx, 3
	sbb	ecx, 0
	jmp	@@2d

@@2b:	jc	@@2c
	xor	ecx, ebp
	xor	ecx, edi
	add	eax, ecx
	lea	ecx, [ebx*2+ebx+5]
	and	ecx, 0Fh
	add	eax, [esi+ecx*4]

	mov	ecx, ebx		; 04,11,16,23
	and	ecx, 3
	lea	ecx, [ecx*2+ecx+2]
	bt	ecx, 0
	adc	ecx, ecx
	jmp	@@2d

@@2c:	mov	ecx, edi
	not	ecx
	or	ecx, ebp
	xor	ecx, edx
	add	eax, ecx
	lea	ecx, [ebx*2+ebx]
	lea	ecx, [ecx+ebx*4]
	and	ecx, 0Fh
	add	eax, [esi+ecx*4]

	mov	ecx, ebx		; 06,10,15,21
	and	ecx, 3
	lea	ecx, [ecx*4+ecx+5]
	bt	ecx, 3
	sbb	ecx, -1

@@2d:	add	eax, [@@T+ebx*4]
	rol	eax, cl
	add	eax, ebp
	xchg	eax, ebp	; bacd
	xchg	eax, edx	; cabd
	xchg	eax, edi	; dabc
	inc	ebx
	cmp	ebx, 40h
	jb	@@1

	mov	ebx, [esp+14h]
	add	[ebx], eax
	add	[ebx+4], ebp
	add	[ebx+8], edx
	add	[ebx+0Ch], edi
	pop	edi
	pop	esi
	pop	ebx
	pop	ebp
	ret	8

ALIGN 4
@@T	dd 0d76aa478h,0e8c7b756h,0242070dbh,0c1bdceeeh
	dd 0f57c0fafh,04787c62ah,0a8304613h,0fd469501h
	dd 0698098d8h,08b44f7afh,0ffff5bb1h,0895cd7beh
	dd 06b901122h,0fd987193h,0a679438eh,049b40821h
	dd 0f61e2562h,0c040b340h,0265e5a51h,0e9b6c7aah
	dd 0d62f105dh,002441453h,0d8a1e681h,0e7d3fbc8h
	dd 021e1cde6h,0c33707d6h,0f4d50d87h,0455a14edh
	dd 0a9e3e905h,0fcefa3f8h,0676f02d9h,08d2a4c8ah
	dd 0fffa3942h,08771f681h,06d9d6122h,0fde5380ch
	dd 0a4beea44h,04bdecfa9h,0f6bb4b60h,0bebfbc70h
	dd 0289b7ec6h,0eaa127fah,0d4ef3085h,004881d05h
	dd 0d9d4d039h,0e6db99e5h,01fa27cf8h,0c4ac5665h
	dd 0f4292244h,0432aff97h,0ab9423a7h,0fc93a039h
	dd 0655b59c3h,08f0ccc92h,0ffeff47dh,085845dd1h
	dd 06fa87e4fh,0fe2ce6e0h,0a3014314h,04e0811a1h
	dd 0f7537e82h,0bd3af235h,02ad7d2bbh,0eb86d391h
ENDP
