_md5_transform@8 PROC
	push	ebp
	push	ebx
	push	esi
	push	edi
	mov	edi, [esp+14h]
	mov	esi, [esp+18h]
	mov	eax, [edi]
	mov	ecx, [edi+4]
	mov	edx, [edi+8]
	mov	ebx, [edi+0Ch]

	@@a=eax
	@@b=ecx
	@@c=edx
	@@d=ebx
	@@i=0

@M1 macro p0
	@@e=(@@i SHR 4)
	ife @@e
	mov	edi, @@c
	xor	edi, @@d
	and	edi, @@b
	xor	edi, @@d
	elseif @@e eq 1
	mov	edi, @@b
	xor	edi, @@c
	and	edi, @@d
	xor	edi, @@c
	elseif @@e eq 2
	mov	edi, @@b
	xor	edi, @@c
	xor	edi, @@d
	else
	mov	edi, @@d
	not	edi
	or	edi, @@b
	xor	edi, @@c
	endif

	@@f = 0510h SHR (@@e*4)
	@@g = 7351h SHR (@@e*4)

	@@f=(@@f+@@i*@@g) AND 0Fh
	add	edi, [esi+@@f*4]
	lea	@@a, [edi+@@a+p0]

	@@e=(72636387h SHR (@@e*2)) AND 3030303h
	@@e=((@@e+140E0904h) SHR ((@@i AND 3)*8)) AND 1Fh
	rol	@@a, @@e
	add	@@a, @@b
	@@e=@@d
	@@d=@@c
	@@c=@@b
	@@b=@@a
	@@a=@@e
	@@i=@@i+1
endm

@M0 macro p0,p1,p2,p3
	@M1 p0
	@M1 p1
	@M1 p2
	@M1 p3
endm
	@M0 0d76aa478h,0e8c7b756h,0242070dbh,0c1bdceeeh
	@M0 0f57c0fafh,04787c62ah,0a8304613h,0fd469501h
	@M0 0698098d8h,08b44f7afh,0ffff5bb1h,0895cd7beh
	@M0 06b901122h,0fd987193h,0a679438eh,049b40821h
	@M0 0f61e2562h,0c040b340h,0265e5a51h,0e9b6c7aah
	@M0 0d62f105dh,002441453h,0d8a1e681h,0e7d3fbc8h
	@M0 021e1cde6h,0c33707d6h,0f4d50d87h,0455a14edh
	@M0 0a9e3e905h,0fcefa3f8h,0676f02d9h,08d2a4c8ah
	@M0 0fffa3942h,08771f681h,06d9d6122h,0fde5380ch
	@M0 0a4beea44h,04bdecfa9h,0f6bb4b60h,0bebfbc70h
	@M0 0289b7ec6h,0eaa127fah,0d4ef3085h,004881d05h
	@M0 0d9d4d039h,0e6db99e5h,01fa27cf8h,0c4ac5665h
	@M0 0f4292244h,0432aff97h,0ab9423a7h,0fc93a039h
	@M0 0655b59c3h,08f0ccc92h,0ffeff47dh,085845dd1h
	@M0 06fa87e4fh,0fe2ce6e0h,0a3014314h,04e0811a1h
	@M0 0f7537e82h,0bd3af235h,02ad7d2bbh,0eb86d391h

PURGE @M0,@M1

	mov	edi, [esp+14h]
	add	[edi], eax
	add	[edi+4], ecx
	add	[edi+8], edx
	add	[edi+0Ch], ebx
	pop	edi
	pop	esi
	pop	ebx
	pop	ebp
	ret	8
ENDP
