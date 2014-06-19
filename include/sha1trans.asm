
_sha1_transform@8 PROC

@@W = dword ptr [ebp-40h]
@@A = ebx
@@B = esi
@@C = edi
@@D = dword ptr [ebp-44h]
@@E = dword ptr [ebp-48h]
@@I = 0

	push	ebx
	push	esi
	push	edi
	enter	40h, 0
	mov	ecx, [ebp+14h]
	mov	edx, [ebp+18h]
	mov	@@A, [ecx]
	mov	@@B, [ecx+4]
	mov	@@C, [ecx+8]
	push	dword ptr [ecx+0Ch]
	push	dword ptr [ecx+10h]

@M1 macro
	mov	ecx, [@@W+((@@I-3) AND 0Fh)*4]
	xor	ecx, [@@W+((@@I-8) AND 0Fh)*4]
	xor	ecx, [@@W+((@@I-14) AND 0Fh)*4]
	xor	ecx, [@@W+@@I*4]
	rol	ecx, 1
	mov	[@@W+@@I*4], ecx
	mov	eax, @@A
	rol	eax, 5
	add	eax, ecx
endm

@M2 macro p0
	lea	ecx, [ecx+eax+p0]
	add	@@E, ecx
	ror	@@B, 2
	@@T = @@E
	@@E = @@D
	@@D = @@C
	@@C = @@B
	@@B = @@A
	@@A = @@T
	@@I = (@@I+1) AND 0Fh
endm

rept 16
	mov	ecx, [edx]
	add	edx, 4
	bswap	ecx
	mov	[@@W+@@I*4], ecx
	mov	eax, @@A
	rol	eax, 5
	add	eax, ecx
	; ((c ^ d) & b) ^ d
	mov	ecx, @@C
	xor	ecx, @@D
	and	ecx, @@B
	xor	ecx, @@D
	@M2	5A827999h
endm

rept 4
	@M1
	; ((c ^ d) & b) ^ d
	mov	ecx, @@C
	xor	ecx, @@D
	and	ecx, @@B
	xor	ecx, @@D
	@M2	5A827999h
endm

@@E = edx

	pop	edx

rept 20
	@M1
	; b ^ c ^ d
	mov	ecx, @@B
	xor	ecx, @@C
	xor	ecx, @@D
	@M2	6ED9EBA1h
endm

	push	edx

@@E = dword ptr [ebp-48h]

rept 20
	@M1
	; ((b | c) & d) | (b & c)
	mov	ecx, @@B
	mov	edx, @@B
	or	ecx, @@C
	and	edx, @@C
	and	ecx, @@D
	or	ecx, edx
	@M2	8F1BBCDCh
endm

@@E = edx

	pop	edx

rept 20
	@M1
	; b ^ c ^ d
	mov	ecx, @@B
	xor	ecx, @@C
	xor	ecx, @@D
	@M2	0CA62C1D6h
endm

PURGE @M1,@M2

	mov	ecx, [ebp+14h]
	pop	eax
	add	[ecx], @@A
	add	[ecx+4], @@B
	add	[ecx+8], @@C
	add	[ecx+0Ch], eax
	add	[ecx+10h], edx
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
ENDP
