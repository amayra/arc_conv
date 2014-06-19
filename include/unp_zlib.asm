
_zlib_raw_unpack PROC
	xor	eax, eax
	jmp	@@1a

@M0 macro p0,p1
@@stk=@@stk+4
p0=dword ptr [ebp-@@stk]
endm
@@stk = 0
@M0 @@DE
@M0 @@DP
@M0 @@Bits
@M0 @@Hold
@M0 @@Size
@M0 @@Ret
@M0 @@Dist
@M0 @@Len
PURGE @M0

@@DB = dword ptr [ebp+14h]
@@DC = dword ptr [ebp+18h]
@@SB = dword ptr [ebp+1Ch]
@@SC = dword ptr [ebp+20h]
@@SE = @@SC

_zlib_unpack:
	or	eax, -1
@@1a:	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	ebp, esp
	xchg	ebx, eax
	mov	ecx, [@@DB]
	mov	eax, [@@DC]
	mov	edx, [@@SB]
	add	eax, ecx
	add	[@@SE], edx
	push	eax
	push	ecx
	push	0
	push	0
	push	0		; @@Size
	test	ebx, ebx
	je	@@1b
	call	@@ReadBits, 10h
	xchg	al, ah
	; test	al, 20h		; PRESET_DICT = 0x20
	imul	edx, eax, 8422h	; div16(0x1F)
	shr	edx, 14h
	imul	edx, 1Fh
	cmp	eax, edx
	mov	al, -1
	jne	@@9
	xor	ah, 08h		; Z_DEFLATED = 8
	test	ah, 8Fh
	jne	@@9
@@1b:	call	@@Inflate
@@9:	movsx	esi, al
	mov	ebx, [@@DE]
	mov	eax, [@@DP]
	mov	edx, [@@SE]
	lea	ecx, [ebx+1]
	sub	ebx, eax
	or	ecx, [@@DB]
	sub	eax, [@@DB]
	sub	edx, [@@SB]
	neg	ecx
	sbb	ecx, ecx
	and	ebx, ecx
	or	esi, ebx
	neg	esi
	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	10h

@@ReadByte:
	mov	eax, [@@SB]
	cmp	eax, [@@SE]
	je	@@Err2
	inc	[@@SB]
	movzx	eax, byte ptr [eax]
	ret
@@Err2:	mov	al, -2
	lea	esp, [@@Ret]
	ret

@@WriteByte:
	mov	edx, [@@DP]
	cmp	edx, [@@DE]
	je	@@Err8
	cmp	[@@DB], 0
	je	@@Cpy5
	mov	[edx], al
@@Cpy5:	inc	edx
@@Cpy4:	mov	[@@DP], edx
	ret
@@Cpy2:	add	edx, esi
	jc	@@Cpy3
	cmp	[@@DE], edx
	jae	@@Cpy4
@@Cpy3:	mov	edx, [@@DE]
@@Err8:	mov	[@@DP], edx
	mov	al, -8
	lea	esp, [@@Ret]
	ret

@@WriteCopy:		; edi, esi
	mov	edx, [@@DP]
	not	edi
	mov	eax, edx
	sub	eax, [@@DB]
	add	eax, edi
	jnc	@@Err7
	cmp	[@@DB], 0
	je	@@Cpy2
@@Cpy1:	cmp	edx, [@@DE]
	je	@@Err8
	mov	al, [edx+edi]
	mov	[edx], al
	inc	edx
	dec	esi
	jne	@@Cpy1
	mov	[@@DP], edx
	ret
@@Err7:	mov	al, -7
	lea	esp, [@@Ret]
	ret

@@ReadBits:	; cnt <= 24
	mov	edx, [esp+4]
	mov	ecx, [@@Bits]
	cmp	ecx, edx
	jae	@@Bit2
@@Bit1:	call	@@ReadByte
	shl	eax, cl
	add	[@@Hold], eax
	add	ecx, 8
	cmp	ecx, edx
	jb	@@Bit1
@@Bit2:	sub	ecx, edx
	xor	eax, eax
	mov	[@@Bits], ecx
	mov	ecx, edx
	inc	eax
	mov	edx, [@@Hold]
	shl	eax, cl
	dec	eax
	and	eax, edx
	shr	edx, cl
	mov	[@@Hold], edx
	ret	4

@@Inflate:
	sub	esp, 8+(10h+120h)*2
	mov	[@@Len], esp
	sub	esp, (10h+20h)*2
	mov	[@@Dist], esp
@@Inf1:	call	@@ReadBits, 3
	shr	eax, 1
	sbb	ebx, ebx
	cmp	eax, 3
	je	@@Err1
	test	eax, eax
	jne	@@Inf3
	and	[@@Bits], 0
	call	@@ReadBits, 10h
	xchg	edi, eax
	call	@@ReadBits, 10h
	not	ax
	cmp	edi, eax
	mov	al, -2
	jne	@@Inf9
	test	edi, edi
	je	@@Inf4
@@Inf2:	call	@@ReadByte
	call	@@WriteByte
	dec	edi
	jne	@@Inf2
	jmp	@@Inf4
@@Err1:	mov	al, -1
	jmp	@@Inf9
@@Inf3:	call	@@Dynamic
	test	al, al
	jne	@@Inf9
@@Inf4:	inc	ebx
	jne	@@Inf1
	xchg	eax, ebx
@@Inf9:	lea	esp, [@@Ret]
	ret

@@Decode:
	push	ebx
	push	edi
	xor	ecx, ecx
	xor	ebx, ebx
	inc	ecx
	xor	edi, edi
@@Dec1:	dec	[@@Bits]
	jns	@@Dec2
	call	@@ReadByte
	mov	[@@Hold], eax
	add	[@@Bits], 8
@@Dec2:	shr	[@@Hold], 1
	movzx	eax, word ptr [edx+ecx*2]
	adc	edi, edi
	inc	ecx
	add	ebx, eax
	sub	edi, eax
	jb	@@Dec3
	cmp	ecx, 10h
	jb	@@Dec1
	mov	al, -9
	jmp	@@Inf9
@@Dec3:	add	ebx, edi
	movzx	eax, word ptr [edx+20h+ebx*2]
	pop	edi
	pop	ebx
	ret

@@Construct PROC
	push	ebx
	push	esi
	push	edi
	enter	20h, 0

	xor	eax, eax
	mov	edi, edx
	lea	ecx, [eax+8]
	rep	stosd

	mov	edi, [ebp+18h]
	mov	esi, [ebp+14h]
	mov	ecx, edi
@@1a:	movzx	eax, byte ptr [ecx]
	inc	word ptr [edx+2*eax]
	inc	ecx
	dec	esi
	jne	@@1a
@@1b:	; esi = 0
	movzx	ecx, word ptr [edx]
	xor	eax, eax
	cmp	[ebp+14h], ecx
	je	@@9
	inc	eax
	mov	ecx, eax
@@3:	mov	[esp+ecx*2], si
	movzx	ebx, word ptr [edx+ecx*2]
	shl	eax, 1
	add	esi, ebx
	sub	eax, ebx
	jb	@@9
	inc	ecx
	cmp	ecx, 10h
	jb	@@3

	xor	esi, esi
@@4a:	movzx	ecx, byte ptr [edi+esi]
	test	ecx, ecx
	je	@@4b
	lea	ecx, [esp+ecx*2]
	movzx	ebx, word ptr [ecx]
	mov	[edx+20h+ebx*2], si
	inc	ebx
	mov	[ecx], bx
@@4b:	inc	esi
	cmp	esi, [ebp+14h]
	jb	@@4a
	dec	eax
	jns	@@4c
@@9:	leave
	pop	edi
	pop	esi
	pop	ebx
	ret	8
@@4c:	movzx	eax, word ptr [edx]
	sub	eax, esi
	inc	eax
	je	@@9
	leave
ENDP

@@Err4:	mov	al, -4
	lea	esp, [@@Ret]
	ret

@@Dynamic:
	push	ebx
	push	esi
	push	edi
	mov	ebx, esp
	dec	eax
	jne	@@Dyn1
	mov	ecx, 120h
	push	ecx
	push	20h
	sub	esp, 140h
	shr	ecx, 1	; 24h*4
	mov	al, 8
	mov	edi, esp
	rep	stosb
	mov	cl, 1Ch*4
	inc	eax
	rep	stosb
	mov	cl, 6*4
	mov	al, 7
	rep	stosb
	inc	eax
	mov	cl, 2*4
	rep	stosb
	mov	cl, 20h
	mov	al, 5
	rep	stosb
	jmp	@@4b

@@Dyn1:	call	@@ReadBits, 5
	cmp	eax, 1Eh
	jae	@@Err3
	mov	ah, 1
	inc	eax
	push	eax
	call	@@ReadBits, 5
	cmp	eax, 1Eh
	jae	@@Err3
	inc	eax
	push	eax
	call	@@ReadBits, 4
	xor	edi, edi
	lea	esi, [eax+4]
	sub	esp, 13Ch-10h	; 0x1D*2+0x102
	push	edi
	push	edi
	push	edi
	push	edi
@@Dyn2:	call	@@ReadBits, 3
	lea	ecx, [edi+10h]
	inc	edi
	cmp	ecx, 13h
	jb	@@Dyn3
	sub	ecx, 4
	shr	ecx, 1
	jnc	@@Dyn3
	not	ecx
	and	ecx, 7
@@Dyn3:	mov	[esp+ecx], al
	dec	esi
	jne	@@Dyn2
	mov	edx, [@@Len]
	call	@@Construct, 13h, esp

	mov	esi, [ebx-8]
	add	esi, [ebx-4]
	mov	edi, esp
@@2a:	mov	edx, [@@Len]
	call	@@Decode
	cmp	al, 10h
	jb	@@2f
	jne	@@2c
	cmp	edi, esp
	je	@@Err5
	mov	al, [edi-1]
	push	eax
	push	3-1
	push	2
	jmp	@@2e

@@2c:	push	0
	cmp	al, 11h
	jne	@@2d
	push	3-1
	push	3
	jmp	@@2e

@@2d:	push	0Bh-1
	push	7
@@2e:	call	@@ReadBits
	pop	ecx
	add	ecx, eax
	pop	eax
	sub	esi, ecx
	jbe	@@Err6
	rep	stosb
@@2f:	stosb
	dec	esi
	jne	@@2a

@@4b:	mov	esi, [ebx-4]
	mov	edx, [@@Len]
	call	@@Construct, esi, esp
	add	esi, esp
	mov	edx, [@@Dist]
	call	@@Construct, dword ptr [ebx-8], esi
	jmp	@@5a

@@5b:	call	@@WriteByte
@@5a:	mov	edx, [@@Len]
	call	@@Decode
	dec	ah
	js	@@5b
	test	al, al
	je	@@Dyn9
	sub	al, 1Eh
	jae	@@Err9
	mov	esi, eax
	add	al, 1
	je	@@5c
	lea	esi, [eax+4]
	and	esi, 7
	add	al, 14h
	js	@@5c
	shr	eax, 2
	or	esi, 4
	inc	eax
	xchg	ecx, eax
	shl	esi, cl
	call	@@ReadBits, ecx
	add	esi, eax
@@5c:	add	esi, 3
	mov	edx, [@@Dist]
	call	@@Decode
	mov	edi, eax
	cmp	al, 1Eh
	jae	@@Err9
	sub	al, 4
	jb	@@5d
	xor	edi, edi
	shr	eax, 1
	adc	edi, 2
	inc	eax
	xchg	ecx, eax
	shl	edi, cl
	call	@@ReadBits, ecx
	add	edi, eax
@@5d:	call	@@WriteCopy
	jmp	@@5a

@@Err9:	mov	al, -9
	jmp	@@Dyn9
@@Err6:	mov	al, -6
	jmp	@@Dyn9
@@Err5:	mov	al, -5
	jmp	@@Dyn9
@@Err3:	mov	al, -3
@@Dyn9:	mov	esp, ebx
	pop	edi
	pop	esi
	pop	ebx
	ret
ENDP
