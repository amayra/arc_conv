
_th123_crypt_init PROC
	push	ebx
	push	edi
	mov	eax, [esp+0Ch]
	lea	edi, [esp+10h]
	xor	ebx, ebx
	stosd
	inc	ebx
@@1:	mov	ecx, eax
	shr	eax, 1Eh
	xor	eax, ecx
	imul	eax, 6C078965h
	add	eax, ebx
	stosd
	inc	ebx
	cmp	ebx, 270h
	jb	@@1
	pop	edi
	pop	ebx
	ret	4
ENDP

_th123_crypt PROC
	push	ebx
	push	esi
	push	edi
	push	ebp
	mov	esi, [esp+14h]
	mov	ebp, [esp+1Ch]
	lea	ebx, [esp+20h]

@@1:	mov	ecx, [ebx+ebp*4]
	lea	edx, [ebp+1]
	cmp	edx, 270h
	sbb	eax, eax
	and	edx, eax
	mov	edi, [ebx+edx*4]
	xor	edi, ecx
	and	edi, 7FFFFFFFh
	xor	edi, ecx
	shr	edi, 1
	sbb	ecx, ecx
	and	ecx, 9908B0DFh
	xor	edi, ecx
	lea	ecx, [ebp+18Dh]
	cmp	ecx, 270h
	cmc
	sbb	eax, eax
	and	eax, 270h
	sub	ecx, eax
	xor	edi, [ebx+ecx*4]
	mov	[ebx+ebp*4], edi
	mov	ebp, edx

	mov	eax, edi
	shr	edi, 0Bh
	xor	eax, edi
	mov	ecx, eax
	and	eax, 0FF3A58ADh
	shl	eax, 7
	xor	eax, ecx
	mov	ecx, eax
	and	eax, 0FFFFDF8Ch
	shl	eax, 0Fh
	xor	eax, ecx
	mov	ecx, eax
	shr	eax, 12h
	xor	eax, ecx
	xor	[esi], al
	inc	esi
	dec	dword ptr [esp+18h]
	jne	@@1
	xchg	eax, ebp
	pop	ebp
	pop	edi
	pop	esi
	pop	ebx
	ret	0Ch
ENDP

; "Mersenne Twister"

if 0
_twister_init PROC
	xchg	edx, eax
	mov	ebx, 270h
	lea	edi, [esp+4]
	push	esi
	mov	esi, 10DCDh
@@1:	mov	eax, edx
	imul	edx, esi
	inc	edx
	mov	ecx, edx
	imul	edx, esi
	inc	edx
	shr	ecx, 10h
	xchg	ax, cx
	stosd
	dec	ebx
	jne	@@1
	pop	esi
	; ebx = 0
	ret
ENDP
endif

_twister_init PROC
	xchg	edx, eax
	mov	ebx, 270h
	lea	edi, [esp+4]
@@1:	mov	eax, edx
	imul	ecx, edx, 10DCDh
	imul	edx, 1C587629h
	inc	ecx
	add	edx, 10DCEh
	shr	ecx, 10h
	mov	ax, cx
	mov	[edi], eax
	add	edi, 4
	dec	ebx
	jne	@@1
	; ebx = 0
	ret
ENDP

ALIGN 10h
_twister_next PROC	; tab=esp, pos=ebx, uses=eax,ecx,edx,edi
	mov	ecx, [esp+4+ebx*4]
	lea	edx, [ebx+1]
	cmp	edx, 270h
	sbb	eax, eax
	and	edx, eax
	mov	edi, [esp+4+edx*4]
	xor	edi, ecx
	and	edi, 7FFFFFFFh
	xor	edi, ecx
	shr	edi, 1
	sbb	ecx, ecx
	and	ecx, 9908B0DFh
	xor	edi, ecx
	lea	ecx, [ebx+18Dh]
	cmp	ecx, 270h
	cmc
	sbb	eax, eax
	and	eax, 270h
	sub	ecx, eax
	xor	edi, [esp+4+ecx*4]
	mov	[esp+4+ebx*4], edi
	mov	ebx, edx

	mov	eax, edi
	shr	edi, 0Bh
	xor	eax, edi
	mov	ecx, eax
	and	eax, 0FF3A58ADh
	shl	eax, 7
	xor	eax, ecx
	mov	ecx, eax
	and	eax, 0FFFFDF8Ch
	shl	eax, 0Fh
	xor	eax, ecx
	mov	ecx, eax
	shr	eax, 12h
	xor	eax, ecx
	ret
ENDP

ALIGN 10h
_twister_one PROC
	mov	edi, eax
	imul	eax, 1C587629h
	add	eax, 10DCEh

	imul	ecx, eax, 10DCDh
	imul	edx, eax, 5A49BA61h
	inc	ecx
	add	edx, 0DC07A108h
	shr	ecx, 10h
	mov	ax, cx

	xor	eax, edi
	and	eax, 7FFFFFFFh
	xor	edi, eax
	shr	edi, 1
	sbb	ecx, ecx
	and	ecx, 9908B0DFh
	xor	edi, ecx

	imul	ecx, edx, 10DCDh
	inc	ecx
	shr	ecx, 10h
	mov	dx, cx
	xor	edi, edx

	mov	eax, edi
	shr	edi, 0Bh
	xor	eax, edi
	mov	ecx, eax
	and	eax, 0FF3A58ADh
	shl	eax, 7
	xor	eax, ecx
	mov	ecx, eax
	and	eax, 0FFFFDF8Ch
	shl	eax, 0Fh
	xor	eax, ecx
	mov	ecx, eax
	shr	eax, 12h
	xor	eax, ecx
	ret
ENDP
